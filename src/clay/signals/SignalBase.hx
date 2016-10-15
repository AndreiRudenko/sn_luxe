package clay.signals;

import clay.structural.Sll;

import haxe.ds.IntMap;
import clay.utils.Log._debug;
import clay.utils.Log._verbose;
import clay.utils.Log._verboser;
import clay.utils.Log.log;

@:autoBuild(clay.signals.SignalMacro.build())
class SignalBase<HandlerData> {
	

	public var signals (default, null) : Sll<HandlerData>;
	

	public function new(_poolSize:Int = 0) {

		signals = new Sll(_poolSize);

	}

	public function destroy() {

		signals = null;

	}

	public inline function connect(handler:HandlerData ) {

		if(!signals.exists(handler)){
			signals.add(handler);
		}

	}

	public inline function disconnect(handler:HandlerData ) : Bool {

		return signals.remove(handler);

	}


}
