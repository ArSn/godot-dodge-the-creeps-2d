extends GutTest

var TestMob: PackedScene = load('res://mob.tscn')

func test_mob_plays_sprite_animation():
	var mob = TestMob.instantiate()
	add_child_autoqfree(mob)
	
	var sprite: AnimatedSprite2D = mob.get_node("AnimatedSprite2D")	
	assert_true(sprite.is_playing(), "Animated sprite should be playing")



func test_do_something_effe():
	assert_true(true, "This should pass")