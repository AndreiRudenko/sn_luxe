package clay.signals;

import clay.structural.Oll;

import haxe.ds.IntMap;
import clay.utils.Log._debug;
import clay.utils.Log._verbose;
import clay.utils.Log._verboser;
import clay.utils.Log.log;

// signal with ordering

@:autoBuild(clay.macros.SignalMacro.build())
class SignalBase<HandlerData> {
	

	public var signals (default, null) : Oll<HandlerData>;
	

	public function new(_poolSize:Int = 0) {

		signals = new Oll(_poolSize);

	}

	public function destroy() {

		signals = null;

	}

	public inline function connect(handler:HandlerData, order:Int = 0 ) {

		if(!signals.exists(handler)){
			signals.add(handler, order);
		}

	}

	public inline function disconnect(handler:HandlerData ) : Bool {

		return signals.remove(handler);

	}

	public inline function updateOrder(handler:HandlerData, order:Int ) {

		signals.update(handler, order);

	}


}
