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