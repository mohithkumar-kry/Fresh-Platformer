extends TextureButton
@onready var parent = $".."

func _ready() -> void:
	pressed.connect(_on_pressed)  # connects the signal in code, no editor step needed

func _on_pressed() -> void:
	print("BUTTON CLICKED")
	hide()
	parent.buttons_pressed += 1
