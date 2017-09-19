extends Node

## Instructions:
## The goal is to move the red square over the Godot logo using the mouse.
## The moving pieces are "pickable". Selecting the right side of a piece
## tells it to move right and so forth.

onready var bigred = get_node("pieces/bigred")
onready var leftblue = get_node("pieces/leftblue")
onready var leftwhite = get_node("pieces/leftwhite")
onready var rightblue = get_node("pieces/rightblue")
onready var rightwhite = get_node("pieces/rightwhite")
onready var horizontal = get_node("pieces/horizontal")
onready var yellow1 = get_node("pieces/yellow1")
onready var yellow2 = get_node("pieces/yellow2")
onready var yellow3 = get_node("pieces/yellow3")
onready var yellow4 = get_node("pieces/yellow4")

var vel = Vector2(500,500)

var start_pos = Vector2()
var end_pos = Vector2()
var direction = Vector2()

var target = null

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			end_pos = event.pos

func _process(delta):
	
	if target == null: return
	
	var motion = vel * delta	
	var direction = (end_pos - start_pos)
	
	direction.x = direction.x*cos(PI/4) - direction.y*sin(PI/4)
	direction.y = direction.y*cos(PI/4) + direction.x*sin(PI/4)
	
	if direction.x > 0 and direction.y > 0:
		direction.x = 1
		direction.y = 0
	elif direction.x < 0 and direction.y < 0:
		direction.x = -1
		direction.y = 0
	elif direction.x < 0 and direction.y > 0:
		direction.x = 0
		direction.y = 1
	elif direction.x > 0 and direction.y < 0:
		direction.x = 0
		direction.y = -1
	else:
		direction.x = 0
		direction.y = 0
		
	target.move(motion*direction)

func _on_bigred_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			start_pos = bigred.get_pos()
			target = bigred
		else:
			target = null

func _on_leftblue_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = leftblue
			start_pos = leftblue.get_pos()
		else:
			target = null

func _on_leftwhite_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = leftwhite
			start_pos = leftwhite.get_pos()
		else:
			target = null

func _on_rightblue_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = rightblue
			start_pos = rightblue.get_pos()
		else:
			target = null

func _on_rightwhite_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = rightwhite
			start_pos = rightwhite.get_pos()
		else:
			target = null

func _on_horizontal_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = horizontal
			start_pos = horizontal.get_pos()
		else:
			target = null

func _on_yellow1_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = yellow1
			start_pos = yellow1.get_pos()
		else:
			target = null

func _on_yellow2_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = yellow2
			start_pos = yellow2.get_pos()
		else:
			target = null
	
func _on_yellow3_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = yellow3
			start_pos = yellow3.get_pos()
		else:
			target = null

func _on_yellow4_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.pressed:
			target = yellow4
			start_pos = yellow4.get_pos()
		else:
			target = null
