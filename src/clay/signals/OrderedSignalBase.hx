package clay.signals;

import clay.structural.OrderedList;
import clay.structural.Pool;

import haxe.ds.IntMap;
import clay.utils.Log._debug;
import clay.utils.Log._verbose;
import clay.utils.Log._verboser;
import clay.utils.Log.log;

@:autoBuild(clay.signals.OrderedSignalMacro.build())
class OrderedSignalBase<HandlerData> {
	

	public var signals (default, null) : OrderedList<HandlerData>;
	

	public function new(_poolSize:Int = 0) {

		signals = new OrderedList(_poolSize);

	}

	public function destroy() {

		signals = null;

	}

	public inline function connect(handler:HandlerData, _priority:Int = 0) {

		if(!signals.exists(handler)){
			signals.add(handler, _priority);
		}

	}

	public inline function update(handler:HandlerData, _priority:Int = 0) {

		var _s = signals.get(handler);
		if(_s != null){
			_s.priority = _priority;
			signals.update(_s);
		}

	}

	public inline function disconnect(handler:HandlerData ) : Bool {

		return signals.remove(handler);

	}


}
