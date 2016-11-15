package clay;


import clay.utils.Log.*;

import clay.structural.SystemList;


class SystemManager {


	var systemList : SystemList;


	public function new() {

		_verbose('create new SystemManager');

		systemList = new SystemList();

	}

	/* add system to SystemManager */
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

	/* check for system in SystemManager */
	public inline function has(_systemClass:Class<Dynamic>) : Bool {

		return systemList.exists(_systemClass);

	}

	/* get system from SystemManager */
	public inline function get(_systemClass:Class<System> ) {

		return systemList.get(_systemClass);

	}

	/* remove system from SystemManager */
	public inline function remove( _system:System) : Void {


		if(systemList.exists(Type.getClass(_system))) {
			_verbose('remove system ${Type.getClassName(Type.getClass(_system))}');

			_system._unlistenEmitter();
			systemList.remove( _system );

		} else {
			_verbose('can`t remove system ${Type.getClassName(Type.getClass(_system))}, cause it is not in systemList');
		}


	}

	/* remove all systems from list */
	public inline function empty() {

		_verbose('remove all systems');

		for (s in systemList) {
			s._unlistenEmitter();
		}

		systemList.clear();

	}


	/* update system priority */
	@:allow(clay.System)
	inline function updatePriority(_system:System) {


		if(systemList.exists(Type.getClass(_system))){ // do i need checking ?
			_verbose('update system ${Type.getClassName(Type.getClass(_system))}');

			_system._unlistenEmitter();

			systemList.remove(_system);
			systemList.add(_system);

			_system._listenEmitter();
		} else {
			_verbose('can`t update system ${Type.getClassName(Type.getClass(_system))}, cause it is not in systemList');

		}


	}

	/* destroy SystemManager */
	@:noCompletion public function destroy() {

		_verbose('destroy SystemManager');

		empty();

		systemList = null;

	}

	@:noCompletion public inline function iterator():Iterator<System> {

		return systemList.iterator();

	}


}
