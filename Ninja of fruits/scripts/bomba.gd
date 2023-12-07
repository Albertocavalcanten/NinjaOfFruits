# Script de funções da bomba.

extends RigidBody2D

onready var shape = get_node("Shape")
onready var sprite = get_node("Sprite")
onready var anim = get_node("Animation")

signal vida

var cortada = false

func _ready():
	set_process(true)
	randomize()
	
func _process(delta):
	if get_pos().y > 800:
		queue_free()

# Gerador de bombas em posições aleatórias.
func born(iniPos):
	set_pos(iniPos)
	var iniVel = Vector2(0, rand_range(-1000, -800))
	if  iniPos.x < 640:
		iniVel = iniVel.rotated(deg2rad(rand_range(0, -30)))
	else:
		iniVel = iniVel.rotated(deg2rad(rand_range(0, 30)))
	
	set_linear_velocity(iniVel)
	set_angular_velocity(rand_range(-10, 10))
	
# Caso a bomba seja cortada pelo jogador.
func cut():
	if cortada: return
	cortada = true
	emit_signal("vida")
	set_mode(MODE_KINEMATIC)
	anim.play("Explode")
