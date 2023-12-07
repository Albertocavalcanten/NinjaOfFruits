#Script de funções de jogabilidade.

extends Node2D

onready var frutas = get_node("Frutas")

var abacaxi = preload("res://scenes//abacaxi.tscn")
var pera = preload("res://scenes//pera.tscn")
var laranja = preload("res://scenes//laranja.tscn")
var melancia = preload("res://scenes//melancia.tscn")
var bomba = preload("res://scenes//bomba.tscn")

var ponto = 0
var vidas = 3

func _ready():
	pass

# Gerador aleatório de frutas ou bomba.
func _on_Generator_timeout():
	if vidas <= 0: return
	for i in range(0, rand_range(1, 4)):
		var type = int(rand_range(0, 5))
		var obj
		if type == 0:
			obj = abacaxi.instance()
		elif type == 1:
			obj = pera.instance()
		elif type == 2:
			obj = laranja.instance()
		elif type == 3:
			obj = melancia.instance()
		elif type == 4:
			obj = bomba.instance()
			
		obj.born(Vector2(rand_range(200, 1080), 800))
		
		obj.connect("ponto", self, "inc_ponto")
		
		# Caso o objeto gerado seja uma bomba, não contará ponto.
		if type == 4:
			obj.connect("vida", self, "dec_vida")
		
		frutas.add_child(obj)

# Função de decréscimo do número de vidas.
func dec_vida():
	vidas -= 1
	if vidas == 0:
		get_node("GameOverScreen").start()
		get_node("InputProc").acabou = true
		get_node("Control/Bomba1").set_modulate(Color(1, 0, 0))
	if vidas == 1:
		get_node("Control/Bomba2").set_modulate(Color(1, 0, 0))
	if vidas == 2:
		get_node("Control/Bomba3").set_modulate(Color(1, 0, 0))
		
# Função de acréscimo do número de pontos.	
func inc_ponto():
	if vidas == 0: return
	ponto += 1
	get_node("Control/Label").set_text(str(ponto))