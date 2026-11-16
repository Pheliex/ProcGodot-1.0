extends DirectionalLight3D

# Durasi 1 hari penuh dalam detik nyata (120 detik = 2 menit)
@export var day_duration_seconds: float = 120.0

# Jam mulai saat game dijalankan
@export var start_hour: float = 8.0

# Reference ke Node UI dan WorldEnvironment
@onready var time_label: Label = $"../CanvasLayer/MarginContainer/TimeLabel"
@onready var world_env: WorldEnvironment = $"../WorldEnvironment"

var current_hour: float = 8.0
var is_night_time: bool = false

func _ready() -> void:
	current_hour = start_hour
	
	# Cek apakah saat mulai game sudah masuk waktu malam (18:00 - 05:30)
	is_night_time = (current_hour >= 18.0 or current_hour < 5.5)
	
	# Atur status awal lampu jalanan
	get_tree().call_group("street_lights", "set_visible", is_night_time)
	
	# Atur kecerahan awal gambar langit (langsung gelap jika mulai saat malam)
	if world_env and world_env.environment:
		world_env.environment.background_energy_multiplier = 0.05 if is_night_time else 1.0

func _process(delta: float) -> void:
	# 1. Jalankan waktu maju
	var hours_per_second = 24.0 / day_duration_seconds
	current_hour += hours_per_second * delta
	
	if current_hour >= 24.0:
		current_hour -= 24.0

	# 2. Perhitungan Rotasi Sumbu X Matahari
	var sun_angle_x = -((current_hour - 6.0) / 12.0) * 180.0
	rotation_degrees = Vector3(sun_angle_x, -45.0, 0.0)
	
	# 3. Logika Lampu Jalan (Menyala jam 18:00 - 05:30)
	var should_lights_be_on = (current_hour >= 18.0 or current_hour < 5.5)
	if should_lights_be_on != is_night_time:
		is_night_time = should_lights_be_on
		get_tree().call_group("street_lights", "set_visible", is_night_time)

	# 4. Transisi Kecerahan Langit Gambar / Panorama di WorldEnvironment
	if world_env and world_env.environment:
		var target_energy = 0.05 if is_night_time else 1.0
		# Meredupkan/menerangkan langit secara perlahan (transisi halus)
		world_env.environment.background_energy_multiplier = move_toward(
			world_env.environment.background_energy_multiplier, 
			target_energy, 
			delta * 0.5
		)

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
