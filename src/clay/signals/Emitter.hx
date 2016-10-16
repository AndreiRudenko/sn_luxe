package clay.signals;

import haxe.ds.IntMap;

import clay.structural.Dll;
import clay.structural.Oll;

import clay.utils.Log._debug;
import clay.utils.Log._verbose;
import clay.utils.Log._verboser;
import clay.utils.Log.log;


@:noCompletion typedef EmitHandler = Dynamic->Void;
@:noCompletion typedef HandlerList = Oll<EmitHandler>;

@:noCompletion private typedef EmitNode<T> = { event : T, handler:EmitHandler #if clay_emitter_pos, ?pos:haxe.PosInfos #end }


/** A simple event emitter, used as a base class for systems that want to handle direct connections to named events */

// @:generic
class Emitter<ET:Int> {
	

	@:noCompletion public var bindings : IntMap<HandlerList>;

		//store connections loosely, to find connected locations
	var connected : Dll< EmitNode<ET> >;
		//store the items to remove
	var _to_remove : Dll< EmitNode<ET> >;

		/** create a new emitter instance, for binding functions easily to named events. similar to `Events` */
	public function new() {

		_to_remove = new Dll();
		connected = new Dll();

		bindings = new IntMap<HandlerList>();

	} //new

	@:noCompletion public function _emitter_destroy() {

		while(_to_remove.length > 0) {
			var _node = _to_remove.remFirst();
			_node.event = null;
			_node.handler = null;
			_node = null;
		}

		while(connected.length > 0) {
			var _node = connected.remFirst();
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
	@:noCompletion public function on<T>(event:ET, handler: T->Void, order:Int = 0 #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) {

		if(bindings == null) return;

		_check();

		#if clay_emitter_pos _verbose('on / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

		if(!bindings.exists(event)) {

			var oll:Oll<EmitHandler> = new Oll();
			oll.add(handler, order);
			bindings.set(event, oll);
			connected.addFirst({ handler:handler, event:event #if clay_emitter_pos, pos:pos #end });

		} else {
			var _list = bindings.get(event);
			if(!_list.exists(handler)){
				_list.add(handler, order);
				connected.addFirst({ handler:handler, event:event });
			}
		}

	} //on

		/** disconnect a named event and handler. returns true on success, or false if event or handler not found */
	// @:generic
	@:noCompletion public function off<T>(event:ET, handler: T->Void #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) : Bool {

		if(bindings == null) return false;

		_check();

		var _success = false;

		if(bindings.exists(event)) {

			#if clay_emitter_pos _verbose('off / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

			_to_remove.addFirst({ event:event, handler:handler });

			var node = connected.head;
			while(node != null) {
				if(node.value.event == event && node.value.handler == handler) {
					connected.removeNode(node);
					break;
				}
				node = node.next;
			}

				//debateable :p
			_success = true;

		} //if exists

		return _success;

	} //off

	@:noCompletion public function update<T>(event:ET, handler: T->Void, order:Int #if clay_emitter_pos, ?pos:haxe.PosInfos #end ) : Bool {

		var _list = bindings.get(event);
		if(_list != null){
			var _obj = _list.getNode(handler);
			if(_obj != null){

				#if clay_emitter_pos _verbose('update / $event / ${pos.fileName}:${pos.lineNumber}@${pos.className}.${pos.methodName}'); #end

				_list.updateNode(_obj, order);
				
				return true;
			}
		}

		return false;

	}


	@:noCompletion public function connections( handler:EmitHandler ) {

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


			var node = _to_remove.head;
			while(node != null) {
				var _list = bindings.get(node.value.event);
				_list.remove( node.value.handler );

					//clear the event list if there are no bindings
				if(_list.length == 0) {
					bindings.remove(node.value.event);
				}
				node = node.next;
			}

			_to_remove.clear();

		} //_to_remove length > 0

		_checking = false;

	} //_check

} //Emitter
