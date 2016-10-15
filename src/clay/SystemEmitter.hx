package clay;

import haxe.ds.IntMap;
import clay.structural.OrderedList;
import clay.System;
import clay.utils.Log.*;

@:noCompletion typedef OrderedEmitHandler = Dynamic->Void;
@:noCompletion typedef OrderedHandlerList = OrderedList<OrderedEmitHandler>;

@:noCompletion private typedef EmitNode<T> = { event : T, handler:OrderedEmitHandler #if clay_emitter_pos, ?pos:haxe.PosInfos #end }


/** A simple event emitter, used as a base class for systems that want to handle direct connections to named events */

// @:generic
class SystemEmitter<ET:Int> {

	@:noCompletion public var bindings : IntMap<OrderedHandlerList>;

		//store connections loosely, to find connected locations
	var connected : List< EmitNode<ET> >;
		//store the items to remove
	var _to_remove : List< EmitNode<ET> >;

		/** create a new emitter instance, for binding functions easily to named events. similar to `Events` */
	public function new() {

		_to_remove = new List();
		connected = new List();

		bindings = new IntMap<OrderedHandlerList>();

	} //new

	@:noCompletion public function _emitter_destroy() {
		while(_to_remove.length > 0) {
			var _node = _to_remove.pop();
			_node.event = null;
			_node.handler = null;
			_node = null;
		}

		while(connected.length > 0) {
			var _node = connected.pop();
			_node.event = null;
			_node.handler = null;
			_node = null;
		}

		_to_remove = null;
		connected = null;
		bindings = null;
	}

		/** Emit a named event */
	// @:generic
	@:noCompletion public function emit<T>( event:ET, ?data:T #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) {

		if(bindings == null) return;

		_check();

		_checking = true;

		var _list = bindings.get(event);
		if(_list != null && _list.length > 0) {
			for(handler in _list) {
                #if clay_emitter_pos _verboser('emit / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end
				handler(data);
			}
		}
		
		_checking = false;

			//needed because handlers
			//might disconnect listeners
		_check();

	} //emit

		/** connect a named event to a handler */
	// @:generic
	@:noCompletion public function on<T>(event:ET, handler: T->Void, system:System #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) {

		if(bindings == null) return;

		_check();

        #if clay_emitter_pos _verbose('on / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

		if(!bindings.exists(event)) {
			var _olist:OrderedList<OrderedEmitHandler> = new OrderedList();
			_olist.add(handler, system.priority);
			bindings.set(event, _olist);
			connected.push({ handler:handler, event:event });

		} else {
			var _list = bindings.get(event);
			if(!_list.exists(handler)){
				_list.add(handler, system.priority);
				connected.push({ handler:handler, event:event });
			}
		}

	} //on

		/** disconnect a named event and handler. returns true on success, or false if event or handler not found */
	// @:generic
	@:noCompletion public function off<T>(event:ET, handler: T->Void #if clay_emitter_pos, ?pos:haxe.PosInfos #end) : Bool {

		if(bindings == null) return false;

		_check();

		var _success = false;

		if(bindings.exists(event)) {

            #if clay_emitter_pos _verbose('off / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

			_to_remove.push({ event:event, handler:handler });

			for(_info in connected) {
				if(_info.event == event && _info.handler == handler) {
					connected.remove(_info);
				}
			}

				//debateable :p
			_success = true;

		} //if exists

		return _success;

	} //off

	@:noCompletion public function update<T>(event:ET, handler: T->Void, system:System #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) : Bool {

		var _list = bindings.get(event);
		if(_list != null){
			var _obj = _list.get(handler);
			if(_obj != null){

            	#if clay_emitter_pos _verbose('update / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

				_obj.priority = system.priority;

				_list.update(_obj);
				
				return true;
			}
		}

		return false;

	}

	@:noCompletion public function connections( handler:OrderedEmitHandler ) {

		if(connected == null) return null;

		var _list : Array<EmitNode<ET>> = [];

		for(_info in connected) {
			if(_info.handler == handler) {
				_list.push(_info);
			}
		}

		return _list;

	} //connections

	var _checking = false;

	function _check() {

		if(_checking || _to_remove == null) {
			return;
		}

		_checking = true;

		if(_to_remove.length > 0) {

			for(_node in _to_remove) {

				var _list = bindings.get(_node.event);
				_list.remove( _node.handler );

					//clear the event list if there are no bindings
				if(_list.length == 0) {
					bindings.remove(_node.event);
				}

			} //each node

			_to_remove = null;
			_to_remove = new List();

		} //_to_remove length > 0

		_checking = false;

	} //_check

} //Emitter
