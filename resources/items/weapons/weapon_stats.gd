extends Resource
class_name WeaponStats

@export var damage : float = 1.0
@export_range(0.0 , 1.0) var accuracy : float = 0.9
@export_range(0.5 , 3.0) var cooldown : float = 0.5
#暴击几率
@export_range(0.0 , 1.0) var crit_chance : float = 0.05
@export var crit_damage : float = 1.5
@export var max_shoot_distance : float = 150.0
@export var knockback : float = 1.0
@export_range(0.0 , 1.0) var life_steal : float = 0.1
#后坐力
@export var recoil : float = 25.0
@export_range(0.1 , 3.0) var recoil_duration : float = 0.1
@export_range(0.1 , 3.0) var attack_duration : float = 0.2
@export_range(0.1 , 3.0) var back_duration : float = 0.15
@export var projectile_scene : PackedScene
@export var projectile_speed : float = 1500.0
