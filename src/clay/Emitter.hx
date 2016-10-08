package clay;

import haxe.ds.IntMap;
import clay.utils.Log._debug;
import clay.utils.Log._verbose;
import clay.utils.Log._verboser;
import clay.utils.Log.log;


@:noCompletion typedef EmitHandler = Dynamic->Void;
@:noCompletion typedef HandlerList = Array<EmitHandler>;

private class EmitNode {


	public var event : Int;
	public var handler : EmitHandler;
	public var next : EmitNode;
	public var prev : EmitNode;

	public function new(){}


}


/** A simple event emitter, used as a base class for systems that want to handle direct connections to named events */

// @:generic
class Emitter {

	@:noCompletion public var bindings : IntMap<HandlerList>;

		//store connections loosely, to find connected locations
	var connected : EmitNode;
		//store the items to remove
	var toRemove : EmitNode;

		/** create a new emitter instance, for binding functions easily to named events. similar to `Events` */
	public function new() {

		toRemove = null;
		connected = null;

		bindings = new IntMap<HandlerList>();

	} //new

	inline function setToRemove(_node:EmitNode) {

		// Add to classes doubly linked list.
		_node.prev = null;
		_node.next = toRemove;

		if (toRemove != null) {
			toRemove.prev = _node;
		}

		toRemove = _node;

	}

	inline function setConnected(event:Int, handler:EmitHandler) {

		var _node = new EmitNode();

		_node.event = event;
		_node.handler = handler;

		// Add to doubly linked list.
		_node.prev = null;
		_node.next = connected;

		if (connected != null) {
			connected.prev = _node;
		}

		connected = _node;

	}

	function removeConnected(event:Int, handler:EmitHandler) {

		var _node:EmitNode = connected;
		while (_node != null){
			if (_node.event == event && _node.handler == handler){

				if (_node.prev != null) {
					_node.prev.next = _node.next;
				}

				if (_node.next != null) {
					_node.next.prev = _node.prev;
				}

				if (_node == connected) {
					connected = _node.next;
				}

				return _node;
			}

			_node = _node.next;
		}

		return null;

	}

	@:noCompletion public function _emitter_destroy() {

		var _node:EmitNode = null;
		while (toRemove != null){
			_node = toRemove;
			toRemove = toRemove.next;
			_node.handler = null;
			_node.next = null;
			_node.prev = null;
		}

		while (connected != null){
			_node = connected;
			connected = connected.next;
			_node.handler = null;
			_node.next = null;
			_node.prev = null;
		}

		toRemove = null;
		connected = null;
		bindings = null;
		
	}

		/** Emit a named event */
	// @:generic
	@:noCompletion public function emit<T>( event:Int, ?data:T ) {

		if(bindings == null) return;

		_check();

		var _list = bindings.get(event);
		if(_list != null && _list.length > 0) {
			for(handler in _list) {
				handler(data);
			}
		}

			//needed because handlers
			//might disconnect listeners
		_check();

	} //emit

		/** connect a named event to a handler */
	// @:generic
	@:noCompletion public function on<T>(event:Int, handler: T->Void ) {

		if(bindings == null) return;

		_check();

		#if emitter_pos _verbose('on / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

		if(!bindings.exists(event)) {

			bindings.set(event, [handler]);
			setConnected( event, handler );

		} else {
			var _list = bindings.get(event);
			if(_list.indexOf(handler) == -1) {
				_list.push(handler);
				setConnected( event, handler );
			}
		}

	} //on

		/** disconnect a named event and handler. returns true on success, or false if event or handler not found */
	// @:generic
	@:noCompletion public function off<T>(event:Int, handler: T->Void ) : Bool {

		if(bindings == null) return false;

		_check();

		var _success = false;

		if(bindings.exists(event)) {

			setToRemove(removeConnected(event, handler));

				//debateable :p
			_success = true;

		} //if exists

		return _success;

	} //off

	@:noCompletion public function connections( handler:EmitHandler ) {

		if(connected == null) return null;

		var _list : Array<EmitNode> = [];

		var _node:EmitNode = connected;
		while (_node != null){
			if (_node.handler == handler){
				_list.push(_node);
			}
			_node = _node.next;
		}

		return _list;

	} //connections

	var _checking = false;

	function _check() {

		if(_checking || toRemove == null) {
			return;
		}

		_checking = true;

		var _node:EmitNode = toRemove;
		while (_node != null){
			var _list = bindings.get(_node.event);
			_list.remove( _node.handler );

				//clear the event list if there are no bindings
			if(_list.length == 0) {
				bindings.remove(_node.event);
			}
			_node = _node.next;
		}
		toRemove = null;

		_checking = false;

	} //_check

} //Emitter
