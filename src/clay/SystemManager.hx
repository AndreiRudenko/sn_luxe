package clay;


import clay.utils.Log.*;

import clay.structural.SystemList;
import clay.structural.GenericListIterator;
import clay.SystemEmitter;


class SystemManager {


	var emitter : SystemEmitter<clay.Ev>;
	var systemList : SystemList;


	public function new() {

		_verbose('create new SystemManager');

		systemList = new SystemList();
		emitter = new SystemEmitter();

	}

	public function destroy() {

		_verbose('destroy SystemManager');

		emitter._emitter_destroy();
		empty();

		emitter = null;
		systemList = null;

	}

	public inline function add(_system:System, ?_priority:Int) {

		_verbose('add system ${Type.getClassName(Type.getClass(_system))}');

		var _dProc = systemList.get(Type.getClass(_system));
		if(_dProc != null) {
			log('adding a second system ${Type.getClassName(Type.getClass(_system))}! This will replace the existing one.');
			remove(_dProc);
		}

		if(_priority != null){
			_system.priority = _priority;
		}

		systemList.add( _system );
		_system._listenEmitter();

	}

	public inline function has(_systemClass:Class<Dynamic>) : Bool {

		return systemList.exists(_systemClass);

	}

	public inline function get(_systemClass:Class<System> ) {

		return systemList.get(_systemClass);

	}

	public inline function remove( _system:System) : Void {


		if(systemList.exists(Type.getClass(_system))) {
			_verbose('remove system ${Type.getClassName(Type.getClass(_system))}');

			_system._unlistenEmitter();
			systemList.remove( _system );

		} else {
			_verbose('can`t remove system ${Type.getClassName(Type.getClass(_system))}, cause it is not in systemList');
		}


	}

	public inline function empty() {

		_verbose('remove all systems');

		for (s in systemList) {
			s._unlistenEmitter();
		}

		systemList.clear();

	}

	public inline function on<T>(event:clay.Ev, handler:T->Void, _system:System  ) {

		emitter.on(event, handler, _system);

	}

	public inline function off<T>(event:clay.Ev, handler:T->Void ) {

		return emitter.off(event, handler);

	}

	public inline function emit<T>(event:clay.Ev, ?data:T ) {

		return emitter.emit(event, data);

	}

	// update system priority
	@:allow(clay.System)
	inline function update(_system:System) {


		if(systemList.exists(Type.getClass(_system))){ // do i need checking ?
			_verbose('update system ${Type.getClassName(Type.getClass(_system))}');

			_system._unlistenEmitter();

			systemList.update(_system);

			_system._listenEmitter();
		} else {
			_verbose('can`t update system ${Type.getClassName(Type.getClass(_system))}, cause it is not in systemList');

		}


	}

	@:noCompletion public inline function iterator():Iterator<System> {

		return systemList.iterator();

	}


}
