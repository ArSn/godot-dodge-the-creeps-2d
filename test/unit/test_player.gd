extends GutTest

var Player: PackedScene = load('res://player.tscn')

var _sender = InputSender.new()

func after_each():
	_sender.release_all()
	_sender.clear()

func test_move_right_adds_positive_x_velocity():
	var player = add_child_autofree(Player.instantiate())
	# todo: find out why it only works when setting the position here, 0,0 does not work
	player.position = Vector2(1, 1)

	_sender.action_down("move_right").wait_frames(1)
	await(_sender.idle)
	
	assert_gt(player.position.x, 0.0, "Player should move right")
	