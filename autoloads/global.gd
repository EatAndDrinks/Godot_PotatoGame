extends Node

signal on_create_block_text(unit : Node2D)
signal on_create_damage_text(unit : Node2D , hitbox : HitboxComponent)
signal on_upgrade_selected 
signal on_create_heal_text(unit : Node2D , heal : float)

const FLASH_MATERIAL = preload("uid://d3if2ah6hrkol")
const FLOATING_TEXT_SCENES = preload("uid://cw4nn1b3lyjka")


enum UpgradeTier {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY 
}

var player : Player
var game_pause : bool = false

func get_chance_access(chance : float) -> bool:
	var random : float = randf_range(0 , 1)
	if random < chance:
		return true
	return false
