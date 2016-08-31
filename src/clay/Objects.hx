package clay;


class Objects {


	public var id (default, null) : String;
	public var name (default, set) : String;


	@:noCompletion public function new( ?_name:String = '', _id:String = '' ) {

		name = _name;
		id = _id == '' ? clay.utils.Id.uniqueid() : _id;

	}

	function set_name(_name:String) : String {

		return name = _name;

	}


}