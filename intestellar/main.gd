extends Node

@export var mob_scene: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mobs = []
	var player_pos
#	print(delta)
	for child in get_children():
		if child is RigidBody2D:
			mobs.append(child.position)
		if child is Area2D:
			player_pos = child.position
			

#	var sumx=0 
#	var sumy=0
#	var CM = Vector2(0,0)
	var gravity_velocity = Vector2(0,0)
	var all_gs = []
	var netg = Vector2(0,0)
	for mob in mobs:
#		sumx += mob[0]
#		sumy += mob[1]
#		print(mob)
#		var mobg = 1/((mob[0]-player_pos.x) * (mob[0]-player_pos.x)+ (mob[1]-player_pos.y)  * (mob[1]-player_pos.y))
		var mobg = mob.distance_to(player_pos)
		var mobgv = mob - player_pos
		all_gs.append(mobgv)
		netg += 1/(mobgv.length() * mobgv.length()) * mobgv
#		print(netg)
#		all_gs.append(mobg)
	#calculate gravitational center instaead of averaged center
#	if(mobs.size()>0):
#		CM.x = sumx/mobs.size()
#		CM.y = sumy/mobs.size()
#		print(mobs.size())

	#now incorporate player motion towards CM
#	for child in get_children():
#		if child is Area2D:
##			print(child.position)
#			gravity_velocity.x = CM.x - child.position.x
#			gravity_velocity.y = CM.y - child.position.y
#
#			gravity_velocity = gravity_velocity.normalized()*50;
#			child.position += gravity_velocity * delta
#	print("cm  :",CM)
#	print("gv  :",gravity_velocity)
	
#	new gravity
	for child in get_children():
		if child is Area2D:
			pass
			netg = netg.normalized()
#			print(netg)
			#modify velocity based on mob g
			gravity_velocity+= netg*50
			child.position += gravity_velocity*delta
			#modify child.position based on velocity
#	print("netg :", netg)
#	print("vel :", gravity_velocity)
			

#	pass
func game_over():
	get_node("ScoreTimer").stop()
	get_node("MobTimer").stop()
	get_node("HUD").show_game_over()
	get_node("stay").stop()
	get_node("Death").play()

func new_game():
	get_tree().call_group("mobs","queue_free")
	get_node("stay").play()
	score=0
	get_node("HUD").update_score(score)
	get_node("HUD").show_message("Light Speed!")
	get_node("Player").start(get_node("StartPosition").position)
	get_node("StartTimer").start()
	
	


func _on_mob_timer_timeout():
	#create new instance of the mob scene
	var mob = mob_scene.instantiate()
	#choose a random location
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	#set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI/2
	
	#set mob's position to a random location
	mob.position = mob_spawn_location.position
	
	#add some randomness to the direction
	direction += randf_range(-PI/4, PI/4)
	mob.rotation  = direction
	
	#choose the velocity for the mob
	var velocity = Vector2(randf_range(100.0, 150.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn the mob by adding it to the Main scene
	add_child(mob)
#	print(mob)
	
	


func _on_score_timer_timeout():
	score+=1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	get_node("MobTimer").start()
	get_node("ScoreTimer").start()
	

