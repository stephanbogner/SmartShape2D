extends SS2D_Action

## ActionSetPivot

var _shape: SS2D_Shape
var _old_pos: Vector2
var _new_pos: Vector2


func _init(s: SS2D_Shape, et: Transform2D, pos: Vector2) -> void:
	_shape = s
	_new_pos = pos
	_old_pos = et * s.get_parent().get_global_transform() * s.position


func get_name() -> String:
	return "Set Pivot"


func do() -> void:
	_set_pivot(_new_pos)


func undo() -> void:
	_set_pivot(_old_pos)


func _set_pivot(point: Vector2) -> void:
	var np: Vector2 = point
	var ct: Transform2D = _shape.get_global_transform()
	ct.origin = np
	var xform := ct.affine_inverse() * _shape.get_global_transform()

	_shape.begin_update()
	_shape.disable_constraints()
	for i in _shape.get_point_count():
		var key: int = _shape.get_point_key_at_index(i)
		_shape.set_point_position(key, xform * _shape.get_point_position(key))
	_shape.enable_constraints()
	_shape.end_update()

	_shape.position = _shape.get_parent().get_global_transform().affine_inverse() * np
