package clay;


class MockComponent {

	public var value:Int;

	public function new(value:Int = 0) {
		this.value = value;
	}

}

class MockComponent2 {

	public var value:String;

	public function new(){}

}

class MockComponentExtended extends MockComponent {

	public var other:Int;

	public function new() {
		super();
	}

}