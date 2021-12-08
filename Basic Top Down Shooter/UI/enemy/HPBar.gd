extends TextureRect
var parent_rotation 
func _ready():
	$TextureProgress.value=100

func set_percent_value_int(value):
	$TextureProgress.value=value



func _process(delta):
	parent_rotation = get_parent().rotation
	set_rotation(- parent_rotation)




