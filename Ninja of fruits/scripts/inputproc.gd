#Script de processamento de comandos

extends Node2D

onready var limit = get_node("Limit") # Limite de tempo onde um toque na tela é válido.
onready var inter = get_node("Inter") # Intervalo de tempo onde o jogador toca na tela sucessivamente.

var pressed = false
var drag = false
var curPos = Vector2(0, 0)
var prePos = Vector2(0, 0)

var acabou = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
# Função de transformação do evento de arrastar o dedo na tela em um corte válido no jogo.
func _fixed_process(delta):
	update()
	if drag and curPos != prePos and prePos != Vector2(0, 0) and not acabou:
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(prePos, curPos)
		if not result.empty():
			result.collider.cut()
		
# Função de processamento do tipo de evento ocorrido na tela.
func _input(event):
	event = make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

# Função para quando o jogador pressiona o dedo na tela do smartphone.		
func pressed(pos):
	pressed = true
	prePos = pos
	limit.start()
	inter.start()
	
# Função para quando o jogador deixa de tocar a tela do smartphone.
func released():
	pressed = false
	drag = false
	limit.stop()
	inter.stop()
	prePos = Vector2(0, 0)
	curPos = Vector2(0, 0)
	
# Função para quando o jogador arrasta o dedo na tela do smartphone.
func drag(pos):
	curPos = pos
	drag = true


func _on_Inter_timeout():
	prePos = curPos


func _on_Limit_timeout():
	released()
	
# Função de visualização do movimento de arrastar realizado pelo jogador.
func _draw():
	if drag and curPos != prePos and prePos != Vector2(0, 0) and not acabou:
		draw_line(curPos, prePos, Color(1, 0, 0), 10)
