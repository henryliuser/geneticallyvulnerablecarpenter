extends Control
var gravity = 35
var playerHP = 100
var speedMultiplier = 1
var debug = true
var pressshit = false
onready var scrambleAnim = $scramble
const hurtColor = Color(0.5,0,1,0.5)
var keyToText = {KEY_SHIFT:"SHIFT",KEY_ENTER:"ENTER",KEY_CONTROL:"CTRL",
KEY_SPACE:"SPACE",KEY_COMMA:",",KEY_COLON:":",KEY_PERIOD:".",KEY_SLASH:"/",
KEY_SEMICOLON:";",KEY_APOSTROPHE:"\'",KEY_BRACKETLEFT:"[",KEY_BRACKETRIGHT:"]",
KEY_HYPHEN:"-",KEY_EQUAL:"=",KEY_0:"ZER0",KEY_1:"1",KEY_2:"2",KEY_3:"3",KEY_4:"4",
KEY_5:"5",KEY_6:"6",KEY_7:"7",KEY_8:"8",KEY_9:"9",KEY_Q:"Q",KEY_W:"W",
KEY_E:"E",KEY_R:"R",KEY_T:"T",KEY_Y:"Y",KEY_U:"U",KEY_I:"I",KEY_O:"O",KEY_P:"P",
KEY_A:"A",KEY_S:"S",KEY_D:"D",KEY_F:"F",KEY_G:"G",KEY_H:"H",KEY_J:"J",KEY_K:"K",
KEY_L:"L",KEY_Z:"Z",KEY_X:"X",KEY_C:"C",KEY_V:"V",KEY_B:"B",KEY_N:"N",KEY_M:"M"}

var keyList = [KEY_SHIFT,KEY_ENTER,KEY_CONTROL,KEY_SPACE,
KEY_PERIOD,KEY_SLASH,KEY_SEMICOLON,
KEY_EQUAL,KEY_0,KEY_1,KEY_2,KEY_3,KEY_4,
KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,KEY_0,KEY_Q,KEY_W,KEY_E,KEY_R,KEY_T,KEY_Y,
KEY_U,KEY_I,KEY_O,KEY_P,KEY_A,KEY_S,KEY_D,KEY_F,KEY_G,KEY_H,KEY_J,KEY_K,
KEY_L,KEY_Z,KEY_X,KEY_C,KEY_V,KEY_B,KEY_N,KEY_M]

var dontChange = {"ui_accept":1,"ui_select":1,"ui_cancel":1,
"ui_focus_next":1,"ui_focus_prev":1,"ui_left":1,"ui_right":1,
"ui_up":1,"ui_down":1,"ui_page_up":1,"ui_page_down":1, "ui_home":1, "ui_end":1}

var labels = ["left","right","jump","atk","fix","duck"]
var moves = [" Left: ", "Right: ", "  Jump: ", "Attack: ", "  Fix: ", "Crouch: "]
var actions = {"player_left":0, "player_right":1, "player_jump":2, "player_attack":3, "player_fix":4, "player_crouch":5}
var actionss = {"player_left":KEY_A, "player_right":KEY_D, "player_jump":KEY_SPACE, "player_attack":KEY_H, "player_fix":KEY_J, "player_crouch":KEY_S}
#var moves = ["  Up: ", "Down: ", " Left: ", "Right: ", " Atk: ", "  Fix: "]
var dead = false
onready var gui = $TopGUI
const UP = Vector2(0,-1)
func _ready():
	randomize()
	

func _process(delta):
	$TopGUI/health.text = "HP: " + str(playerHP)
	if dead:
		if Input.is_action_pressed("ui_accept"):
			dead = false
			playerHP = 100
			$CanvasLayer/death0000.visible = false
			resetControls()
			get_tree().change_scene("res://Scenes/Main Menu.tscn")
	

static func dPrint(node,string):
	print(node.name + ": " + string)

static func getSign(a):
	return (a > 0) - (a < 0)
	
func playerHurt(dmg):
	playerHP -= dmg
	if playerHP <= 0:
		dead = true
		$CanvasLayer/death0000.visible = true

func resetControls():
	for action in InputMap.get_actions():
		if dontChange.get(action) != 1:
			var nodeIndex = actions.get(action);
			var eventKey = actionss.get(action)
			var event = InputEventKey.new()
			event.scancode = eventKey
			InputMap.get_action_list(action)[0].set_pressed(false)
			var ev = InputEventAction.new()
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			ev.set_action(action)
			ev.set_pressed(false)
			Input.parse_input_event(ev)
			get_node("TopGUI/"+labels[nodeIndex]).text = moves[nodeIndex] + keyToText.get(eventKey)
			nodeIndex += 1

func scrambleControls():
	for action in InputMap.get_actions():
		if dontChange.get(action) != 1:
			var nodeIndex = actions.get(action);
			var eventKey = keyList[randi()%keyList.size()]
			var event = InputEventKey.new()
			event.scancode = eventKey
			for i in range(InputMap.get_actions().size()):
				if InputMap.event_is_action(event, InputMap.get_actions()[i]):
					eventKey = keyList[randi()%keyList.size()]
					event.scancode = eventKey 
					i = 0
#			action.pressed = false
#			InputMap.erase_action(action)
#			InputMap.add_action(action)
			InputMap.get_action_list(action)[0].set_pressed(false)
			var ev = InputEventAction.new()
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			ev.set_action(action)
			ev.set_pressed(false)
			Input.parse_input_event(ev)
			get_node("TopGUI/"+labels[nodeIndex]).text = moves[nodeIndex] + keyToText.get(eventKey)
			nodeIndex += 1
	scrambleAnim.play("default")
			#set nodes[nodeindex] to display "actions[nodeindex] + keyToText.get(eventKey)"