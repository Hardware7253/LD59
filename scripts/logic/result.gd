class_name Result

enum ResultType {OK, ERROR}

var type: ResultType
var error_msg: String

func _init(result_type: ResultType = ResultType.OK, msg: String = ""):
	type = result_type 
	error_msg = msg
