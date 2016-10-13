package clay;


import clay.Events;


class System {


	public var active (default, default) : Bool = true;
	public var priority (default, set) : Int = 0;
	public var events   (default, null): Events;

	@:noCompletion public var prev : System;
	@:noCompletion public var next : System;


	@:noCompletion public function onRender() {}
	@:noCompletion public function onDestroy() {}
	@:noCompletion public function update(dt:Float) {}


	public function new() {

		events = new Events();

	}

	public function destroy() {

		onDestroy();
		events.destroy();

		events = null;

	}


	function set_priority(value:Int) : Int {

		priority = value;

		Clay.systems.updatePriority();

		return priority;

	}


}

