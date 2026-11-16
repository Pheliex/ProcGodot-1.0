extends CharacterBody3D

# Pengaturan kecepatan gerak & lompat
const SPEED = 2.5
const JUMP_VELOCITY = 2.5

# Pengaturan sensitivitas mouse
@export var MOUSE_SENSITIVITY: float = 0.003

# Referensi ke node Camera3D (pastikan nama node kamera kamu adalah Camera3D)
@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	# Menyembunyikan dan mengunci kursor mouse ke dalam layar game
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Mengatur rotasi kamera saat mouse digerakkan
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Putar badan karakter ke kiri / kanan (Sumbu Y)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		# Putar kamera ke atas / bawah (Sumbu X)
		camera_3d.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# Batasi agar kamera tidak bisa berputar balik ke belakang (maksimal 80 derajat ke atas/bawah)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-80.0), deg_to_rad(80.0))
		
	# Tekan tombol ESC untuk menampilkan kembali kursor mouse jika ingin keluar
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	# Efek gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Melompat saat menekan Spasi
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Mengambil input WASD / Panah
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Menyesuaikan arah jalan dengan sudut pandang kamera saat ini
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
