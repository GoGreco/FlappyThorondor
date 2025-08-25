extends CharacterBody2D

#definindo varáveis da movimentação

const velocidade_do_pulo : int = -600              
const gravidade : int = 2500 

func _physics_process(delta):
	
	
	if get_parent().game_running == true:
		velocity.y += delta*gravidade
		$AnimatedSprite2D.play("flying")
		
		if Input.is_action_just_pressed('ui_accept'):
				velocity.y = velocidade_do_pulo
	else:
		position = get_parent().thorondor_start_position
		$AnimatedSprite2D.play("flying")
		
	move_and_slide()	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
