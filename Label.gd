extends Label

@onready var parent:Node3D = $"../../../parent"
@onready var child:Node3D = $"../../../parent/child"

var prn: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta) -> void:
	
	prn = str(
		"-- PARENT --",
		"\nTransform: ",
		"\nX: ", parent.transform.basis.x,
		"\ny: ", parent.transform.basis.y,
		"\nz: ", parent.transform.basis.z,
		"\n\nGlobal Transform: ",
		"\nX: ", parent.global_transform.basis.x,
		"\ny: ", parent.global_transform.basis.y,
		"\nz: ", parent.global_transform.basis.z,
		"\n\n-- CHILD --\nTransform: ",
		"\nX: ", child.transform.basis.x,
		"\ny: ", child.transform.basis.y,
		"\nz: ", child.transform.basis.z,
		"\n\nGlobal Transform: ",
		"\nX: ", child.global_transform.basis.x,
		"\ny: ", child.global_transform.basis.y,
		"\nz: ", child.global_transform.basis.z
		
		
	)
	
	text = prn
	
