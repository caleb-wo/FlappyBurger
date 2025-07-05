extends Node2D

@export var pipe_scene : PackedScene

var game_running :bool
var game_over :bool
var scroll
var score
const SCROLL_SPEED :int= 4
var screen_size :Vector2i
var ground_height :int
var pipes :Array
const PIPE_DELAY :int= 100
const PIPE_RANGE :int= 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group( "pipes", "queue_free" )
	pipes.clear()
	generate_pipes()
	$Burger.reset()
	$PipeTimer.start()

func _input( event ):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Burger.flying:
						$Burger.flap()
		elif event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				if game_running == false:
					start_game()
				else:
					if $Burger.flying:
						$Burger.flap()
						check_top() 
			elif event.pressed and event.keycode == KEY_R:
				new_game()



func start_game():	
	game_running = true
	$Burger.flying = true
	$Burger.flap()
	$PipeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		# reset scroll when past viewport
		if scroll >= screen_size.x:
			scroll = 0
		# move ground node
		$Ground.position.x = -scroll
		
		# scroll pipe
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
			

func check_top() ->void:
	if $Burger.position.y < 0:
		$Burger.falling = true
		stop_game()

func stop_game() ->void:
	$PipeTimer.stop()
	$GameOver.show()
	$Burger.flying = false
	game_running = false
	game_over = true



func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
func generate_pipes() -> void:
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = ( screen_size.y - ground_height ) / 2 + randi_range( -PIPE_RANGE, PIPE_RANGE )
	pipe.hit.connect( burger_hit )
	pipe.score.connect( scored )
	add_child(pipe)
	pipes.append(pipe)

func scored()-> void:
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func burger_hit() -> void:
	$Burger.falling = true
	stop_game()


func _on_game_over_restart() -> void:
	new_game()


func _on_ground_body_entered(body: Node2D) -> void:
	$Burger.falling = false
	stop_game()
