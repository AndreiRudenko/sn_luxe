package clay;


import clay.Events;
import clay.utils.Log.*;


@:autoBuild(clay.macros.SystemRules.apply())
class System {


	public var active (default, default) : Bool = true;
	public var priority (default, set) : Int = 0;
	public var events   (default, null): Events;

	@:noCompletion public var prev : System;
	@:noCompletion public var next : System;


	@:noCompletion public function onRender() {}
	@:noCompletion public function onDestroy() {}
	@:noCompletion public function onUpdate(dt:Float) {}


	public function new() {

		_verbose('creating new system / ${Type.getClassName(Type.getClass(this))}');

		events = new Events();

	}

	public function destroy() {

		_verbose('destroy system / ${Type.getClassName(Type.getClass(this))}');
		onDestroy();

		Clay.systems.remove(this);

		events.destroy();
		events = null;

	}


	function _update(dt:Float) {

        _verboser('calling update on ${Type.getClassName(Type.getClass(this))}');
		onUpdate(dt);

	}

	function _render(_) {

        _verboser('calling render on ${Type.getClassName(Type.getClass(this))}');
		onRender();

	}

	function _destroy(_) {

        _verboser('calling destroy on ${Type.getClassName(Type.getClass(this))}');
		onDestroy();

	}

	@:allow(clay.SystemManager)
	function _listenEmitter() {}
	@:allow(clay.SystemManager)
	function _unlistenEmitter() {}

	function set_priority(value:Int) : Int {
		
        _verbose('set priority on ${Type.getClassName(Type.getClass(this))} / to : ${value}');

		priority = value;

		Clay.systems.update(this);

		return priority;

	}


}
