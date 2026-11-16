extends Control

# Membaca node SettingPanel sesuai posisi hierarki di panel Scene
@onready var setting_panel: Panel = $VBoxContainer/SettingButton/SettingPanel

func _ready() -> void:
	# Pastikan kursor mouse terlihat
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Sembunyikan panel setting saat pertama kali dijalankan
	setting_panel.hide()

# Dihubungkan dari sinyal pressed() milik PlayButton
func _on_play_button_pressed() -> void:
	# Sesuaikan "res://map.tscn" dengan nama file scene 3D kamu
	get_tree().change_scene_to_file("res://scene/map.tscn")

# Dihubungkan dari sinyal pressed() milik SettingButton
func _on_setting_button_pressed() -> void:
	setting_panel.show()

# Dihubungkan dari sinyal pressed() milik BackButton (di dalam SettingPanel)
func _on_back_button_pressed() -> void:
	setting_panel.hide()

# Dihubungkan dari sinyal pressed() milik QuitButton
func _on_quit_button_pressed() -> void:
	get_tree().quit()
