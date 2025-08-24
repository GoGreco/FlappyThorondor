extends Node

#Definindo constantes e variáveis do jogo
#Pré carregando os obstáculos
var pillar_1 = ("res://scenes/pillar_1")
var pillar_2 = ("res://scenes/pillar_2")
var pillar_3 = ("res://scenes/pillar_3")
var pillar_4 = ("res://scenes/pillar_4")
var pillar_5 = ("res://scenes/pillar_5")

@onready var thorondor = $Thorondor
@onready var ground = $Ground
@onready var camera = $Camera2D
@onready var score_label = $HUD/score
@onready var start_label = $HUD/start_game
@onready var high_score_label = $HUD/high_score
@onready var restart_button = $HUD/Button

#Definindo constantes do início do jogo
const thorondor_start_position := Vector2i( 120,324)
const camera_start_position := Vector2i(576, 324)

#Variáveis de movimento
var speed
const max_speed : float = 25.0
const start_speed : float = 10.0
const speed_modifier : float = 50.0

var game_running: bool

var screen_size : Vector2i
var ground_height : int 
var ground_scale : int


#Variáveis dos pilares 
var last_pillar
var pillar_heights := [pillar_1, pillar_2, pillar_3, pillar_4, pillar_5]
var created_pillars : Array

#Variáveis dos pontos
var score : int 
var high_score : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

#essa função irá resetar completamente o jogo quando ele recomeçar
func new_game():
	
	start_label.text = "APERTE ESPAÇO PARA JOGA: "
	get_tree().paused = false
	game_running = false
	
	thorondor.position = thorondor_start_position
	thorondor.velocity = Vector2i(0, 0)
	camera.position = camera_start_position
	ground.position = Vector2i(0, 0)
	start_label.show()
	restart_button.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#atribui um valor a velocidade
	speed = start_speed
	
	#checa se o jogo está rodando
	if game_running:
		#checa se a velocidade está maior do que o valor máximo atribuido a ela na sessão das variaveis 
		if speed > max_speed:
			speed = max_speed
		else:
			speed+=float(score)/speed_modifier
		
		thorondor.position.x += speed
		camera.position.x += speed
	
	
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			get_tree().paused = false

func create_pillar():
	pass

func show_score():
	pass
