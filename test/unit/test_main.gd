extends GutTest

var TestMain: PackedScene = load('res://main.tscn')

func test_new_game_starts_new_game():
	var main = TestMain.instantiate()
	add_child_autoqfree(main)

	# Mock the player
	var Player = load('res://player.gd')
	var PlayerDouble = double(Player)
	var player_double = PlayerDouble.new()
	player_double.set_name("Player")
	main.get_node("Player").free()
	main.add_child(player_double)
	
	# Mock the HUD
	var Hud = load('res://hud.gd')
	var HudDouble = double(Hud)
	var hud_double = HudDouble.new()
	hud_double.set_name("HUD")
	main.get_node("HUD").free()
	main.add_child(hud_double)

	# Add some mobs so they can be cleared out
	var mob1: Node = Node.new()
	mob1.add_to_group("mobs")
	add_child_autoqfree(mob1)
	var mob2: Node = Node.new()
	mob2.add_to_group("mobs")
	add_child_autoqfree(mob2)

	assert_true( get_tree().get_nodes_in_group("mobs").size() == 2, "There should be 2 mobs" )
	
	# Act
	main.new_game()
	
	# Verify things are called
	assert_eq(main.score, 0, "Score should be 0")
	assert_call_count(player_double, "start", 1)

	assert_call_count(hud_double, "update_score", 1, [ 0 ])
	assert_call_count(hud_double, "show_message", 1, [ "Get Ready" ] )

	await wait_frames(10)
	
	# Verify the mobs have been cleared out
	assert_true( get_tree().get_nodes_in_group("mobs").size() == 0, "There should be 2 mobs" )
	
func test_game_over_stops_timers_and_shows_game_over_hud():
	var main = TestMain.instantiate()
	add_child_autoqfree(main)
	
	# Start the times so we can ensure we stopped them again
	main.get_node("ScoreTimer").start()
	main.get_node("MobTimer").start()
	
	# Mock the HUD
	var Hud = load('res://hud.gd')
	var HudDouble = double(Hud)
	var hud_double = HudDouble.new()
	hud_double.set_name("HUD")
	main.get_node("HUD").free()
	main.add_child(hud_double)
	
	# Act
	main.game_over()
	
	# Verify things are called
	assert_call_count(hud_double, "show_game_over", 1)
	# Verify timers are stopped
	assert_true( main.get_node("ScoreTimer").is_stopped() )
	assert_true( main.get_node("MobTimer").is_stopped() )

func test_on_score_timer_timeout_increases_score_by_one_in_hud():
	var main = TestMain.instantiate()
	add_child_autoqfree(main)
	
	# Mock the HUD
	var Hud = load('res://hud.gd')
	var HudDouble = double(Hud)
	var hud_double = HudDouble.new()
	hud_double.set_name("HUD")
	main.get_node("HUD").free()
	main.add_child(hud_double)
	
	main.score = 1337
	
	# Act
	main._on_score_timer_timeout()	
	
	# Verify things are called
	assert_call_count(hud_double, "update_score", 1, [ 1338 ])
	
func test_on_start_timer_timeout_starts_the_timers():
	var main = TestMain.instantiate()
	add_child_autoqfree(main)
	
	# Act
	main._on_start_timer_timeout()	
	
	# Verify things are called
	assert_false( main.get_node("ScoreTimer").is_stopped() )
	assert_false( main.get_node("MobTimer").is_stopped() )
	

	