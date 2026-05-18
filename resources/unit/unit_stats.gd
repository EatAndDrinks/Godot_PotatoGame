extends Resource
class_name UnitStats

enum UnitType {
	PLAYER,
	ENEMY
}

@export var name : String
@export var type : UnitType
@export var icon : Texture
@export var health : float = 1
@export var health_increase_per_wave : float = 1
@export var damage : float = 1
@export var damage_increase_per_wave : float= 1
@export var speed : float = 300
@export var luck : int = 1
@export var block_chance : float = 0
@export var gold_drop : int = 1
@export var hp_regen : float = 0.0
@export var life_steal : float = 0.0
@export var harvesting : float = 0.0
