package clay;


import clay.Objects;

import clay.structural.SystemList;
import clay.structural.GenericListIterator;


class SystemManager {


	var systemList : SystemList;


	public function new() {

		systemList = new SystemList();

		Clay.engine.on(clay.Ev.update, update);

	}

	public function destroy() {

		empty();

		Clay.engine.off(clay.Ev.update, update);

	}

	public inline function add(_system:System, ?_priority:Int, ?pos:haxe.PosInfos) {

		// trace('add system ${_system} / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}');

		var _dProc = systemList.get(Type.getClass(_system));
		if(_dProc != null) {
			trace('SystemManager adding a second system ${Type.getClassName(Type.getClass(_system))}! This will replace the existing one.');
			remove(_dProc);
		}

		if(_priority != null){
			_system.priority = _priority;
		}
		systemList.add( _system );

	}

	public inline function has(_systemClass:Class<Dynamic>) : Bool {

		return systemList.exists(_systemClass);

	}

	public inline function get<T>(_systemClass:Class<Dynamic>) : T {

		return cast systemList.get(_systemClass);

	}

	public inline function remove( _system:System ) : Void {

		systemList.remove( _system );

	}

	public inline function empty() {

		systemList.clear();

	}

	function update(dt:Float) {

		var system:System = systemList.head;
		while(system != null) {
			if(system.active){
				system.update(dt);
			}
			system = system.next;
		}

	}

	@:allow(clay.System)
	inline function updatePriority() {

		systemList.sort();

	}

	@:noCompletion public inline function iterator():Iterator<System> {

		return systemList.iterator();

	}


}
