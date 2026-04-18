class_name Result

enum ResultType {OK, ERROR}

var result_type: ResultType
var error_msg: String

func _init(type: ResultType = ResultType.OK, msg: String = ""):
    result_type = type
    error_msg = msg

