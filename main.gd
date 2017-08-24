### SIX DOUBLES ###
### Author: Normand M. Blais ###
### August 24, 2017 ###

### How to play ###
### Use the arrow keys and the space bar to control the game ###
### "Six doubles" is a "dice" game for one player ###
### The goal is to score six doubles before to run out of ###
### "credits" at any one number between 1 and 6 (incl) ###
### the game board is like a score board or a game status board ###
### The board is represented by a 9x6 grid (9 rows and 6 columns ###
### the top row shows the overall score ###
### the next 6 rows are the "credits" ###
### the last two rows (bottom of the board) are the dice ###
### Keyboard control ###
### up arrow key ---> play both dice ###
### right arrow key ---> play the top die ###
### left arrow key ---> play the bottom die ###
### down arrow key ---> pass a turn ###
### space bar ---> "shuffle" the credits ###
### game precedure ###
### a turn starts by playing both dice ###
### if a double is not obtained, the player has 4 choices ###
### 1 - play both dice ###
### 2 - play the rigth die ###
### 3 - play the left die ###
### 4 - pass
### when a double is obtained for the first time ###
### the corresponding top row square "light up" ###
### if a double is obtained again, a credit is lost ###
### if no double is obtained, a credit is lost at both "dice" ###
### same situation occured if the player passes a turn (two credits lost) ###
### using the space bar to shuffle the credits is only allowed "before" a turn ###
### the game is over if all the squares on the top row are "lightup" or ###
### no more credits left at any one number corresponding to a double ###
### 
extends Node2D

onready var tile_blue = preload("res://tile.tscn")
onready var tile_yellow = preload("res://target.tscn")
onready var tile_black = preload("res://credit.tscn")

onready var die_top = get_node("top")
onready var die_bottom = get_node("bottom")

enum {TD = 0, BD = 1}
enum {BOTH = 0, ANY = 1, PASS = 2, SHUFFLE = 3}
enum {IDLE =  0, LIVED =  1, WIN =  2, LOST = 3}

const TLSIZE = 48

var offsets = Vector2(TLSIZE * 1, TLSIZE * 2)

var score = [0,0,0,0,0,0]
var credits = [6,6,6,6,6,6]
var dice_results = [98, 99]

var topDice  = false 
var bottomDice = false 
var update_score = false

var count_top
var count_bottom

var x1
var x2

var zflag = false

var game_status
var turn

static func minimun(ar, size):
	var mm = ar[0]
	var mi = 0
	for i in range(size):
		if ar[i] < mm:
			mm = ar[i]
			mi = i
	return mi

static func maximun(ar, size):
	var mx = ar[0]
	var mi = 0
	for i in range(size):
		if ar[i] > mx:
			mx = ar[i]
			mi = i
	return mi
	
func is_game_over():
	if game_status == WIN:
		game_status = IDLE
		return true
	elif game_status == LOST:
		game_status = IDLE
		return true
	return false

func turn_on_yellow(x):
	var s = tile_yellow.instance()
	s.set_pos(Vector2(TLSIZE*x+offsets.x,offsets.y))
	add_child(s)

func turn_on_black(x, y):
	var s = tile_black.instance()
	s.set_pos(Vector2(TLSIZE*x+offsets.x,TLSIZE*y+offsets.y))
	add_child(s)

func turn_on_blue(x, y):
	var s = tile_blue.instance()
	s.set_pos(Vector2(TLSIZE*x+offsets.x,TLSIZE*y+offsets.y))
	add_child(s)
	
func game_manager(last_turn):
	var d1 = dice_results[0]
	var d2 = dice_results[1]
	
	if last_turn == BOTH:
		if d1 == d2:
			turn = BOTH
			score[d1-1] += 1
			if score[d1-1] > 1:
				score[d1-1] = 1
				credits[d1-1] -= 1
				turn_on_black(d1-1, credits[d1-1]+1)
				if credits[d1-1] == 0:
					game_status = LOST
			else:
				turn_on_yellow(d1-1)
				var tot = 0
				for x in range(6):
					tot += score[x]
				if tot == 6:
					game_status = WIN
		else:
			turn = ANY
	elif last_turn == ANY:
		if d1 == d2:
			turn = BOTH
			score[d1-1] += 1
			if score[d1-1] > 1:
				score[d1-1] = 1
				credits[d1-1] -= 1
				turn_on_black(d1-1, credits[d1-1]+1)
				if credits[d1-1] == 0:
					game_status = LOST
			else:
				turn_on_yellow(d1-1)
				var tot = 0
				for x in range(6):
					tot += score[x]
				if tot == 6:
					game_status = WIN
		else:
			credits[d1-1] -= 1
			credits[d2-1] -= 1
			turn_on_black(d1-1, credits[d1-1]+1)
			turn_on_black(d2-1, credits[d2-1]+1)
			if credits[d1-1] == 0 or credits[d2-1] == 0:
				game_status = LOST
			turn = BOTH
	elif last_turn == PASS:
		if credits[d1-1] > 1 and credits[d2-1] > 1:
			credits[d1-1] -= 1
			credits[d2-1] -= 1
			turn_on_black(d1-1, credits[d1-1]+1)
			turn_on_black(d2-1, credits[d2-1]+1)
			if credits[d1-1] == 0 or credits[d2-1] == 0:
				game_status = LOST
		turn = BOTH
	elif last_turn == SHUFFLE:
		turn = BOTH
		var mmi = minimun(credits, 6)
		var mxi = maximun(credits, 6)
		if mmi != mxi:
			turn_on_black(mxi, credits[mxi])
			turn_on_blue(mmi, credits[mmi]+1)
			credits[mmi] += 1
			credits[mxi] -= 1
			
func _ready():
	randomize()
	## create the main board
	for i in range(6):
		for j in range(9):
			var s = tile_blue.instance()
			s.set_pos(Vector2(TLSIZE*i+offsets.x,TLSIZE*j+offsets.y))
			add_child(s, true)
			
	count_top = 0
	count_bottom = 0
	die_top.set_pos(Vector2(offsets.x, TLSIZE * 7 + offsets.y))
	die_bottom.set_pos(Vector2(offsets.x, TLSIZE * 8 + offsets.y))
	die_top.set_z(-1)
	die_bottom.set_z(-1)
	zflag = true
	####
	game_status = LIVED
	turn = BOTH
	set_process(true)
	set_process_input(true)
	
func _input(event):
	if event.type != 1: 
		return
	if game_status != LIVED:
		return
	## show dice
	if zflag:
		die_top.set_z(1)
		die_bottom.set_z(1)
		zflag = false
		
	if event.is_action_pressed("btn_play"):
		topDice = true
		bottomDice = true
		count_top = 51
		count_bottom = 51
		update_score = true
	elif event.is_action_pressed("btn_top") and turn == ANY:
		topDice = true
		bottomDice = false
		count_top = 51
		update_score = true
	elif event.is_action_pressed("btn_bottom") and turn == ANY:
		topDice = false
		bottomDice = true
		count_bottom = 51
		update_score = true
	elif event.is_action_pressed("btn_pass") and turn == ANY:
		turn = PASS
		game_manager(turn)
	elif event.is_action_pressed("btn_shuffle") and turn == BOTH:
		turn = SHUFFLE
		game_manager(turn)
		
func _process(delta):
	var new_pos_x

	if topDice and count_top > 0:
		new_pos_x = floor(randf() * 6) * TLSIZE + offsets.x
		die_top.set_pos(Vector2(new_pos_x, die_top.get_pos().y))
		count_top -= 1
		x1 = new_pos_x
		dice_results[TD] = (x1 - offsets.x)/TLSIZE+1
		
	if bottomDice and count_bottom > 0:
		new_pos_x = floor(randf() * 6) * TLSIZE + offsets.x
		die_bottom.set_pos(Vector2(new_pos_x, die_bottom.get_pos().y))
		count_bottom -= 1
		x2 = new_pos_x
		dice_results[BD] = (x2 - offsets.x)/TLSIZE+1
		
	if count_bottom == 0 and count_top == 0 and update_score:
		game_manager(turn)
		update_score = false
		if game_status == WIN:
			turn = IDLE
			print("You won")
		elif game_status == LOST:
			turn = IDLE
			print("You lost")
	
