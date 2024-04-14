extends GutTest

var Player: PackedScene = load('res://player.tscn')

var _sender = InputSender.new(Input)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_move_right_changes_position_right():
	var player = add_child_autofree(Player.instantiate())
	var previous_x: float = player.position.x

	_sender.action_down("move_right").wait_frames(10)
	await(_sender.idle)
	
	assert_gt(player.position.x, previous_x, "Player should move right")
	
func test_move_left_changes_position_left():
	var player = add_child_autofree(Player.instantiate())
	# We can't move below 0 so we have to move the player to the right first
	player.position.x = 100
	var previous_x: float = player.position.x

	_sender.action_down("move_left").wait_frames(10)
	await(_sender.idle)

	assert_lt(player.position.x, previous_x, "Player should move left")

func test_move_down_changes_position_down():
	var player = add_child_autofree(Player.instantiate())
	var previous_y: float = player.position.y

	_sender.action_down("move_down").wait_frames(10)
	await(_sender.idle)

	assert_gt(player.position.y, previous_y, "Player should move down")
	
func test_move_up_changes_position_up():
	var player = add_child_autofree(Player.instantiate())
	# We can't move below 0 so we have to move the player down first
	player.position.y = 100
	var previous_y: float = player.position.y

	_sender.action_down("move_up").wait_frames(10)
	await(_sender.idle)

	assert_lt(player.position.y, previous_y, "Player should move up")
	
func test_play_animation_when_moving():
	var player = add_child_autofree(Player.instantiate())
	var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

	_sender.action_down("move_right").wait_frames(30)
	await wait_frames(10)
	assert_true(sprite.is_playing(), "Player should play animation when moving")
	await(_sender.idle)	

func test_stop_animation_when_not_moving():
	var player = add_child_autofree(Player.instantiate())
	var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
	assert_false(sprite.is_playing(), "Player should stop animation when not moving")
	
func test_stop_animation_when_having_stopped():
	var player = add_child_autofree(Player.instantiate())
	var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

	# We start and stop the movement for this test
	_sender.action_down("move_right").wait_frames(10)
	await(_sender.idle)
	_sender.action_up("move_right").wait_frames(10)
	await(_sender.idle)
	assert_false(sprite.is_playing(), "Player should stop animation after stopping")
	
