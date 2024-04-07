extends GutTest

var TestMob: PackedScene = load('res://mob.tscn')

func test_mob_plays_sprite_animation():
	var mob = TestMob.instantiate()
	add_child_autoqfree(mob)
	
	var sprite: AnimatedSprite2D = mob.get_node("AnimatedSprite2D")	
	assert_true(sprite.is_playing(), "Animated sprite should be playing")


func test_queues_free_when_visible_on_screen_notifier_exits():
	var mob = TestMob.instantiate()
	add_child_autoqfree(mob)
	
	mob._on_visible_on_screen_notifier_2d_screen_exited()
	
	assert_true(mob.is_queued_for_deletion(), "Mob should be queued for deletion")