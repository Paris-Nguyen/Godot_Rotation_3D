extends Node3D

@onready var parent: Node3D = $parent
@onready var child: Node3D = $parent/child
@onready var label_syntax: Label = $CanvasLayer/Panel_syntax/Label_syntax
@onready var label_mode: Label = $CanvasLayer/Panel_Mode/Label_mode
@onready var label_angle: Label = $CanvasLayer/Panel_Mode/Label_angle
@onready var check_button_x: CheckButton = $CanvasLayer/HBoxContainer_Buttons1/PanelContainer_Toggle/VBoxContainer/CheckButton_x
@onready var check_button_y: CheckButton = $CanvasLayer/HBoxContainer_Buttons1/PanelContainer_Toggle/VBoxContainer/CheckButton_y
@onready var check_button_z: CheckButton = $CanvasLayer/HBoxContainer_Buttons1/PanelContainer_Toggle/VBoxContainer/CheckButton_z
@onready var check_button_pc: CheckButton = $CanvasLayer/HBoxContainer_Buttons1/PanelContainer_Toggle/VBoxContainer/CheckButton_pc

var default_rotation_amount: float = 5
var ra: float = deg_to_rad(default_rotation_amount)
var axis: float = 0
var parentchild: float = 0
var rotation_direction: float = 0
var mode: int = 0
var mode_type: String
var max_mode = 4
var plus_pressing: float = false
var minus_pressing: float = false
var plus_angle_pressing: float = false
var minus_angle_pressing = false



var ptext: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	check_button_x.set_pressed_no_signal(true)
	label_mode.text = str("Mode: ",mode, "\nType: ", mode_type)
	label_angle.text = str("Angle (Radian) : " , ra, "\nAngle (Degrees) : ",rad_to_deg(ra))
	mode = max_mode
	change_mode()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta) -> void:
	label_syntax.text = ptext

	if Input.is_key_pressed(KEY_1):
		parent.transform.basis = transform.basis.rotated(Vector3(1,0,0),ra)
		#parent.transform.basis = parent.transform.basis * Basis(Vector3(1,0,0),ra)
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if plus_pressing or minus_pressing:
		rotate_object()

	if plus_angle_pressing or minus_angle_pressing:
		change_angle()





func change_mode() -> void:
	if mode == max_mode:
		mode = 0
	elif mode < max_mode:
		mode += 1
	else:
		ptext = "Error Mode Variable Not Valid"
	
	match mode:
		0:
			mode_type = ".rotate_axis ( ANGLE ) "	
		1:
			mode_type = ".rotate ( VECTOR3 , ANGLE )"
		2:
			mode_type = ".rotate_object_local ( VECTOR3 , ANGLE )"
		3:
			mode_type = ".rotation.axis = ANGLE"
		4:
			mode_type = ".global_rotation.axis = Angle"
		_:
			mode_type = "No Mode Type Found"
			
	label_mode.text = str("Mode: ",mode, "\nType: ", mode_type)


func change_angle() -> void:
	if plus_angle_pressing:
		ra += deg_to_rad(0.05)
		if ra >= 2*PI:
			ra = 0
	
	if minus_angle_pressing:
		ra -= deg_to_rad(0.05)
		if ra <= 0:
			ra = 2*PI
	label_angle.text = str("Angle (Radian) : " , ra, "\nAngle (Degrees) : ",rad_to_deg(ra))
	
func reset_object() -> void:
	if parentchild == 0:
		if mode == 0:
			parent.transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),parent.transform.origin)
			ptext = "Parent:\nLocal Reset\n.transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),parent.transform.origin)"
		elif mode == 1:
			parent.global_transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),parent.global_transform.origin)
			ptext = "Parent:\nGlobal Reset\n.global_transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),parent.transform.origin)"
		elif mode == 2:
			parent.global_transform.basis = Basis()
			ptext = "Parent:\nGlobal Basis Reset\nparent.global_transform.basis = Basis()"
		else:
			ptext = "Error No Rest Mode Available Choose another reset Mode"
	elif parentchild == 1:
		if mode == 0:
			child.transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),child.transform.origin)
			ptext = "Child:\nLocal Reset\nchild.transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),child.transform.origin)"
		elif mode ==1:
			child.global_transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),child.global_transform.origin)
			ptext = "Child:\nGlobal Reset\nchild.global_transform = Transform3D(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1),child.global_transform.origin)"
		elif mode ==2:
			child.global_transform.basis = Basis()
			ptext = "Child:\nGlobal Basis Reset\nchild.global_transform.basis = Basis()"
		else:
			ptext = "Error No Rest Mode Available Choose another reset Mode"
	else:
		ptext = "Error Parentchild Variable Not Valid"


func rotate_object() -> void:
	if rotation_direction == 0:
		ra = abs(ra)
	elif rotation_direction == 1:
		ra = -abs(ra)
	elif rotation_direction == 2:
		reset_object()
	else:
		printerr("rotation direction variable in valid")
	
	if parentchild == 0:
		if mode == 0:
			if axis == 0:
				parent.rotate_x(ra)
				ptext = "Parent\nRotate X\nparent.rotate_x(ra)"
			elif axis == 1:
				parent.rotate_y(ra)
				ptext = "Parent\nRotate Y\nparent.rotate_y(ra)"
			elif axis == 2:
				parent.rotate_z(ra)
				ptext = "Parent\nRotate Z\nparent.rotate_z(ra)"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 1:
			if axis == 0:
				parent.rotate(Vector3(1,0,0), ra)
				ptext = "Parent\nRotate X Vector:\nparent.rotate(Vector3(1,0,0), ra)"
			elif axis == 1:
				parent.rotate(Vector3(0,1,0), ra)
				ptext = "Parent\nRotate Y Vector:\nparent.rotate(Vector3(0,1,0), ra)"
			elif axis == 2:
				parent.rotate(Vector3(0,0,1), ra)
				ptext = "Parent\nRotate Z Vector:\nparent.rotate(Vector3(0,0,1), ra)"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 2:
			if axis == 0:
				parent.rotate_object_local(Vector3(1,0,0), ra)
				ptext = "Parent\nRotate X Vector in local co-ordinates?:\nparent.rotate_object_local(Vector3(1,0,0), ra)"
			elif axis == 1:
				parent.rotate_object_local(Vector3(0,1,0), ra)
				ptext = "Parent\nRotate Y Vector in local co-ordinates?:\nparent.rotate_object_local(Vector3(0,1,0), ra)"
			elif axis == 2:
				parent.rotate_object_local(Vector3(0,0,1), ra)
				ptext = "Parent\nRotate Z Vector in local co-ordinates?:\nparent.rotate_object_local(Vector3(0,0,1), ra)"
			else:
				ptext = "Error Axis Variable Not Valid"
		
		
		elif mode == 3:
			if axis == 0:
				parent.rotation.x = ra
				ptext = "Parent\nSet Local X rotation to Angle:\nparent.rotation.x = ra"
			elif axis == 1:
				parent.rotation.y = ra
				ptext = "Parent\nSet Local y rotation to Angle:\nparent.rotation.y = ra"
			elif axis == 2:
				parent.rotation.z = ra
				ptext = "Parent\nSet Local z rotation to Angle:\nparent.rotation.Z = ra"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 4:
			if axis == 0:
				parent.global_rotation.x = ra
				ptext = "Parent\nSet Global X rotation to Angle:\nparent.global_rotation.x = ra"
			elif axis == 1:
				parent.global_rotation.y = ra
				ptext = "Parent\nSet Global y rotation to Angle:\nparent.global_rotation.x = ra"
			elif axis == 2:
				parent.global_rotation.z = ra
				ptext = "Parent\nSet Global z rotation to Angle:\nparent.global_rotation.x = ra"
			else:
				ptext = "Error Axis Variable Not Valid"
		else:
			ptext = "Error Mode Variable Not Valid"



	elif parentchild == 1:
		if mode == 0:
			if axis == 0:
				child.rotate_x(ra)
				ptext = "Child:\nRotate X\nchild.rotate_x(ra)"
			elif axis == 1:
				child.rotate_y(ra)
				ptext = "Child\nRotate Y\nchild.rotate_y(ra)"
			elif axis == 2:
				child.rotate_z(ra)
				ptext = "Child\nRotate Z\nchild.rotate_z(ra)"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 1:
			if axis == 0:
				child.rotate(Vector3(1,0,0), ra)
				ptext = "Child\nRotate X Vector:\nchild.rotate(Vector3(1,0,0), ra)"
			elif axis == 1:
				child.rotate(Vector3(0,1,0), ra)
				ptext = "Child\nRotate Y Vector:\nchild.rotate(Vector3(0,1,0), ra)"
			elif axis == 2:
				child.rotate(Vector3(0,0,1), ra)
				ptext = "Child\nRotate Z Vector:\nchild.rotate(Vector3(0,0,1), ra)"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 2:
				
			if axis == 0:
				child.rotate_object_local(Vector3(1,0,0), ra)
				ptext = "Child\nRotate X Vector in local co-ordinates?:\nchild.rotate_object_local(Vector3(1,0,0), ra)"
			elif axis == 1:
				child.rotate_object_local(Vector3(0,1,0), ra)
				ptext = "Child\nRotate Y Vector in local co-ordinates?:\nchild.rotate_object_local(Vector3(0,1,0), ra)"
			elif axis == 2:
				child.rotate_object_local(Vector3(0,0,1), ra)
				ptext = "Child\nRotate Z Vector in local co-ordinates?:\nchild.rotate_object_local(Vector3(0,0,1), ra)"
			else:
				ptext = "Error Axis Variable Not Valid"

		elif mode == 3:
			if axis == 0:
				child.rotation.x = ra
				ptext = "Child\nSet Local X rotation to Angle:\nchild.rotation.x = ra"
			elif axis == 1:
				child.rotation.y = ra
				ptext = "Child\nSet Local y rotation to Angle:\nchild.rotation.y = ra"
			elif axis == 2:
				child.rotation.z = ra
				ptext = "Child\nSet Local z rotation to Angle:\nchild.rotation.Z = ra"
			else:
				ptext = "Error Axis Variable Not Valid"
		elif mode == 4:
			if axis == 0:
				child.global_rotation.x = ra
				ptext = "Child\nSet Global X rotation to Angle:\nchild.global_rotation.x = ra"
			elif axis == 1:
				child.global_rotation.y = ra
				ptext = "Child\nSet Global y rotation to Angle:\nchild.global_rotation.x = ra"
			elif axis == 2:
				child.global_rotation.z = ra
				ptext = "Child\nSet Global z rotation to Angle:\nchild.global_rotation.x = ra"
			else:
				ptext = "Error Axis Variable Not Valid"
				
				
				
		else:
			ptext = "Error Mode Variable Not Valid"
	else:
		ptext = "Error Parentchild Variable Not Valid"

	ra = abs(ra)
	

func _on_button_plus_button_down() -> void:
	plus_pressing = true
	minus_pressing = false
	rotation_direction = 0

func _on_button_plus_button_up() -> void:
	plus_pressing = false


func _on_button_minus_button_down() -> void:
	minus_pressing = true
	plus_pressing = false
	rotation_direction = 1

func _on_button_minus_button_up() -> void:
	minus_pressing = false


func _on_button_minus_pressed() -> void:
	rotate_object()

func _on_button_reset_pressed() -> void:
	rotation_direction = 2
	reset_object()
	
func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_button_mode_pressed() -> void:
	change_mode()

func _on_check_button_x_toggled(_toggled_on) -> void:
	check_button_y.set_pressed_no_signal(false)
	check_button_z.set_pressed_no_signal(false)
	axis = 0
	
func _on_check_button_y_toggled(_toggled_on)  -> void:
	check_button_x.set_pressed_no_signal(false)
	check_button_z.set_pressed_no_signal(false)
	axis = 1
	
func _on_check_button_z_toggled(_toggled_on)  -> void:
	check_button_x.set_pressed_no_signal(false)
	check_button_y.set_pressed_no_signal(false)
	axis = 2

func _on_check_button_pc_toggled(toggled_on) -> void:
	if toggled_on:
		parentchild = 1
	else:
		parentchild = 0


func _on_button_plus_angle_button_down() -> void:
	plus_angle_pressing = true
	minus_angle_pressing = false
	
func _on_button_plus_angle_button_up() -> void:
	plus_angle_pressing = false

func _on_button_minus_angle_button_down() -> void:
	minus_angle_pressing = true
	plus_angle_pressing = false

func _on_button_minus_angle_button_up() -> void:
	minus_angle_pressing = false
