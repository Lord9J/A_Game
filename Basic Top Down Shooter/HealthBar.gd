extends TextureProgress


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgess.value=100

func set_percent_value_int(value):
	$TextureProgess.value=value
