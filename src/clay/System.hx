package clay;

import clay.signals.Events;
import clay.utils.Log.*;


@:autoBuild(clay.macros.SystemRules.apply())
class System {


	public var active (default, set) : Bool = true;
	public var priority (default, set) : Int = 0;
	// public var events   (default, null): Events;

	@:noCompletion public var prev : System;
	@:noCompletion public var next : System;


	@:noCompletion public function onrender() {}
	@:noCompletion public function update(dt:Float) {}


	public function new() {

		_verbose('creating new system / ${Type.getClassName(Type.getClass(this))}');

		// events = new Events();

	}

	public function destroy() {

		_verbose('destroy system / ${Type.getClassName(Type.getClass(this))}');

		Clay.systems.remove(this);

		// events.destroy();
		// events = null;

	}

	function _update(dt:Float) {

		_verboser('calling update on ${Type.getClassName(Type.getClass(this))}');

		update(dt);

	}

	function _render(_) {

		_verboser('calling render on ${Type.getClassName(Type.getClass(this))}');
		onrender();

	}

	function _destroy(_) {

		_verboser('calling destroy on ${Type.getClassName(Type.getClass(this))}');
		destroy();

	}

	@:allow(clay.SystemManager)
	function _listenEmitter() {}
	@:allow(clay.SystemManager)
	function _unlistenEmitter() {}

	function set_priority(value:Int) : Int {
		
		_verbose('set priority on ${Type.getClassName(Type.getClass(this))} / to : ${value}');

		priority = value;

		Clay.systems.updatePriority(this);

		return priority;

	}

	function set_active(value:Bool):Bool {

		active = value;

		if(active){
			_listenEmitter();
		} else {
			_unlistenEmitter();
		}
		
		return value;

	}


}
