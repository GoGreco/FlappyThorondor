extends CharacterBody2D

#definindo varáveis da movimentação

const velocidade_do_pulo : int = 100
const gravidade : int = 4000

func _physics_process(delta):
	
	velocity.y += delta*gravidade
	
	if Input.is_action_just_pressed('ui_accept'):
			velocity.y += velocidade_do_pulo
	
	move_and_slide()	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
