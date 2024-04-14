extends GutTest

var Player: PackedScene = load('res://player.tscn')

var _sender = InputSender.new(Input)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_move_right_adds_positive_x_velocity():
	var player = add_child_autofree(Player.instantiate())
	var previous_x: float = player.position.x

	_sender.action_down("move_right").wait_frames(1)
	await(_sender.idle)
	
	assert_gt(player.position.x, previous_x, "Player should move right")
	
#func test_move_left_adds_negative_x_velocity():
#	var player = add_child_autofree(Player.instantiate())
#	player.position = Vector2(1, 1)
#
#	_sender.action_down("move_left").wait_frames(1)
#	await(_sender.idle)
#	
#	assert_lt(player.position.x, 0.0, "Player should move left")
	
