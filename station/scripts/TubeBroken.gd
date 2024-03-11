extends Node
@onready var tubes = $Tubes
@onready var tubes_broken = $"Tubes Broken"
@onready var gpu_particles_3d = $GPUParticles3D

@onready var progress_bar = $SubViewport/VBoxContainer/ProgressBar
@onready var repair_hit = $RepairHit
@onready var air_sound = $AirSound

var is_repaired = false

var repair_per_hit = 10
var repair_amount = 0

func _ready():
	tubes.visible = false
	tubes_broken.visible = true
	progress_bar.value = repair_amount

func repair():
	repair_amount += repair_per_hit
	progress_bar.value = repair_amount
	repair_hit.pitch_scale = randf_range(0.8, 1)
	repair_hit.play()
	if repair_amount >= 100:
		air_sound.stop()
		tubes_broken.visible = false
		tubes.visible = true
		gpu_particles_3d.emitting = false
		get_tree().create_timer(3).timeout.connect(func (): gpu_particles_3d.queue_free())
		is_repaired = true
		RepairObjectives.repaired()

func _on_area_3d_area_entered(area):
	if not is_repaired: repair()
