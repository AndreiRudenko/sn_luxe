package clay;


class ID {


	public var id : String;
	public var name : String = '';

	@:noCompletion public function new(?_name:String='', _id:String='') {

		name = _name;
		id = _id == '' ? clay.utils.Id.uniqueid() : _id;

	} //new


} //ID


class Objects extends Emitter<Int> {


	public var id (default, null) : String;
	public var name (default, set) : String;


	@:noCompletion public function new( ?_name:String = '', _id:String = '' ) {

		super();
		
		name = _name;
		id = _id == '' ? clay.utils.Id.uniqueid() : _id;

	}

	function set_name(_name:String) : String {

		return name = _name;

	}


}

