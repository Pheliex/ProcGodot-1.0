extends DirectionalLight3D

@export var day_duration_seconds: float = 120.0
@export var start_hour: float = 8.0

@onready var time_label: Label = $"../CanvasLayer/MarginContainer/TimeLabel"

var current_hour: float = 8.0
var is_night_time: bool = false

func _ready() -> void:
	current_hour = start_hour
	
	# 1. Cek dan paksa atur status lampu saat game pertama kali dimuat
	is_night_time = (current_hour >= 18.0 or current_hour < 5.5)
	get_tree().call_group("street_lights", "set_visible", is_night_time)

func _process(delta: float) -> void:
	# 2. Jalankan waktu maju
	var hours_per_second = 24.0 / day_duration_seconds
	current_hour += hours_per_second * delta
	
	if current_hour >= 24.0:
		current_hour -= 24.0

	# 3. Perhitungan Rotasi Matahari
	var sun_angle_x = -((current_hour - 6.0) / 12.0) * 180.0
	rotation_degrees = Vector3(sun_angle_x, -45.0, 0.0)
	
	# 4. Logika Perubahan Lampu Jalan saat Game Berjalan
	var should_lights_be_on = (current_hour >= 18.0 or current_hour < 5.5)
	if should_lights_be_on != is_night_time:
		is_night_time = should_lights_be_on
		get_tree().call_group("street_lights", "set_visible", is_night_time)

	# 5. Update UI Jam
	update_time_ui()

func update_time_ui() -> void:
	var hours = int(current_hour)
	var minutes = int((current_hour - hours) * 60.0)
	
	var period_name = ""
	if hours >= 5 and hours < 11:
		period_name = "Pagi"
	elif hours >= 11 and hours < 15:
		period_name = "Siang"
	elif hours >= 15 and hours < 18:
		period_name = "Sore"
	else:
		period_name = "Malam"

	if time_label:
		time_label.text = "%02d:%02d (%s)" % [hours, minutes, period_name]
