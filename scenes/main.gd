extends Node

#Definindo constantes e variáveis do jogo
#Pré carregando os obstáculos
var pillar_1 = preload("res://scenes/pillar_1.tscn")
var pillar_2 = preload("res://scenes/pillar_2.tscn")
var pillar_3 = preload("res://scenes/pillar_3.tscn")
var pillar_4 = preload("res://scenes/pillar_4.tscn")

@onready var thorondor = $Thorondor
@onready var ground = $Ground
@onready var camera = $Camera2D
@onready var score_label = $HUD/score
@onready var start_label = $HUD/start_game
@onready var high_score_label = $HUD/high_score
@onready var restart_button = $HUD/game_over     

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
var pillar_heights := [pillar_1, pillar_2, pillar_3, pillar_4]
var created_pillars : Array
var after_danger: bool = false


#Variáveis dos pontos
var score : int 
var high_score : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	restart_button.pressed.connect(new_game)
	
	#define o tamanho da tela
	screen_size = get_window().size
	
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	ground_scale = int(ground.get_node("Sprite2D").scale.y)
	
	new_game()

#essa função irá resetar completamente o jogo quando ele recomeçar
func new_game():
	
	start_label.text = "APERTE ESPAÇO PARA JOGA: "
	get_tree().paused = false
	  
	thorondor.position = thorondor_start_position
	thorondor.velocity = Vector2i(0, 0)
	camera.position = camera_start_position
	ground.position = Vector2i(0, 0)
	start_label.show()
	restart_button.hide()
	high_score_label.hide() 
	
	game_running = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#atribui um valor a velocidade
	speed = start_speed
	show_score()
	#checa se o jogo está rodando
	if game_running:
		#checa se a velocidade está maior do que o valor máximo atribuido a ela na sessão das variaveis 
		if speed > max_speed:
			speed = max_speed
		else:
			speed+=float(score)/speed_modifier   
		
		thorondor.position.x += speed
		camera.position.x += speed
		#atualiza a posição do chão com base na posição da câmera
		if camera.position.x - ground.position.x > screen_size.x * 1.5:
			ground.position.x += screen_size.x
	
		create_pillar()
		show_score()
		 
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			get_tree().paused = false
			start_label.hide()

func create_pillar():
	#função irá criar pillares se o array de pilares criados está vazio, ou se o último pilar esá atrás da câmera
	if created_pillars.is_empty() or last_pillar.position.x < camera.position.x    :
		#define uma altura de pilar com base nas alturas encontradas no array definido inicialmente
		
		var pillar_type = pillar_heights[randi()%pillar_heights.size()]
		var pillar
		
		#isntancia um pilar, uma vez instanciado, temos acesso aos dados do pilar
		pillar = pillar_type.instantiate()
		last_pillar = pillar
		
		var pillar_size = pillar.get_node("Sprite2D").texture.get_height()
		var pillar_scale = pillar.get_node("Sprite2D").scale
		
		var pillar_x : int = camera.position.x + screen_size.x/2
		var pillar_y : int = screen_size.y -(ground_height*ground_scale)-((pillar_size*pillar_scale.y)/2)
		
		add_pillar(pillar, pillar_x, pillar_y)
		if thorondor.position.x > pillar_x:
			after_danger = true
			passed_pillar()
		
	
	
func add_pillar(column, x, y):
	column.position = Vector2i(x, y)
	column.body_entered.connect(hit_pillar)
	
	add_child(column)
	created_pillars.append(column)
	
func hit_pillar(body):
	if body.name == "Thorondor":
		game_over()


func passed_pillar():
	score+=1
	after_danger = false

func show_score():
	score_label.text = str(score)

func high_score_setter():
	if score > high_score:
		high_score = score
		high_score_label.text = "Recorde: "+ str(high_score)
		
func game_over():
	high_score_setter()
	get_tree().paused = true
	game_running = false
	start_label.text = "GAME OVER\nthough luck"
	start_label.show()
	high_score_label.show()
	restart_button.show()
	
