extends GutTest

var TestHud: PackedScene = load('res://hud.tscn')

func test_hud_shows_message_and_starts_timer():
	var hud = TestHud.instantiate()
	add_child_autoqfree(hud)
	
	hud.show_message("Hello, World!")

	var label: Label = hud.get_node("Message")
	assert_eq(label.text, "Hello, World!", "Label text should be 'Hello, World!'")

	var timer: Timer = hud.get_node("MessageTimer")
	assert_false(timer.is_stopped(), "Timer should be started")
	
func test_hud_update_score_should_show_score():
	var hud = TestHud.instantiate()
	autoqfree(hud)
	
	hud.update_score(100)
	 
	var label: Label = hud.get_node("ScoreLabel")
	assert_eq(label.text, "100", "Label text should be '100'")
	
func test_on_start_button_pressed_starts_game():
	var hud = TestHud.instantiate()
	autoqfree(hud)

	watch_signals(hud)
	hud._on_start_button_pressed()
	assert_signal_emitted(hud, "start_game")
	
	var startButton: Button = hud.get_node("StartButton")
	assert_false(startButton.visible, "Start button should be hidden")
	
func test_on_message_timer_timeout_hides_message():
	var hud = TestHud.instantiate() 
	autoqfree(hud)
	
	var label: Label = hud.get_node("Message")
	label.text = "Hello world!"
	label.visible = true
	
	hud._on_message_timer_timeout()
	
	assert_false(label.visible, "Message should be hidden")

func test_show_game_over_shows_message_and_then_shows_start_button():
	var hud = TestHud.instantiate()
	add_child_autoqfree(hud)
	
	# create mock timer that times out almost immediately
	var timer: Timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.name = "MessageTimer"
	var realTimer: Timer = hud.get_node("MessageTimer")
	autoqfree(realTimer)
	hud.get_node("MessageTimer").replace_by(timer)
	
	
	# act
	hud.show_game_over()
	
	# assert
	var message: Label = hud.get_node("Message")
	assert_eq(message.text, "Game Over", "Label text should be 'Game Over'")

	timer.start()	
	await wait_seconds(0.2)

	assert_eq(message.text, "Dodge the creeps!", "Label text should be 'Dodge the creeps!'")
	var startButton: Button = hud.get_node("StartButton")
	assert_true(startButton.visible, "Start button should be visible")