extends Node

signal on_create_block_text(unit : Node2D)
signal on_create_damage_text(unit : Node2D , hitbox : HitboxComponent)

const FLASH_MATERIAL = preload("uid://d3if2ah6hrkol")
const FLOATING_TEXT_SCENES = preload("uid://cw4nn1b3lyjka")

var player : Player

func get_chance_access(chance : float) -> bool:
	var random : float = randf_range(0 , 0.1)
	if random < chance:
		return true
	return false
