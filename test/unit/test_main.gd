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
	
	main.new_game()
	assert_eq(main.score, 0, "Score should be 0")
	assert_call_count(player_double, "start", 1)
	

	