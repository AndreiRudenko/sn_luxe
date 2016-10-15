package clay.structural;

/**
 *  A singly linked list
 *  @author Andrei Rudenko
 */

import clay.structural.ListIterator;

class Sll<T> {


	public var head (default, null) : SllNode<T>;
	public var poolSize (default, null) : Int = 0;

	public var headPool : SllNode<T>;

	var reservedSize : Int = 0;

	// public var length(get, null):Int;


	public function new(_reservedSize:Null<Int> = 0) {

		if(_reservedSize > 0){
			reservedSize = _reservedSize;
			while(_reservedSize != 0) {
				addToPool(new SllNode<T>(cast null));
				_reservedSize--;
			}
		}

	}

	public inline function add(_value:T) : Void {

		// var node:SllNode<T> = getFromPool();
		var node:SllNode<T> = new SllNode<T>(_value);
		// node.value = _value;

		if (head == null) {
			head = node;
		} else {
			node.next = head;
			head = node;
		}

	}

	public function shift():T{

		if(valid(head)){
			var _head:SllNode<T> = head;
			var _value:T = head.value;

			head = head.next;

			addToPool(_head);

			return _value;
		}

	    return null;

	}

	public function first():T {

		if(valid(head)){
			return head.value;
		}

		return null;

	}

	inline function addToPool(node:SllNode<T>) {

		if(reservedSize > 0 && poolSize < reservedSize){
			// trace('add to pool');
			node.value = cast null; // clear node value
			if (headPool == null) {
				headPool = node;
			} else {
				node.next = headPool;
				headPool = node;
			}
			poolSize++;
		} else {
			// trace('destroy');
			node.value = cast null;
			node.next = null;
		}

	}

	inline function getFromPool():SllNode<T> {

		var node:SllNode<T> = null;
		if(poolSize > 0){
			// trace('get from pool');
			node = headPool;
			headPool = headPool.next;
			node.next = null;
			poolSize--;
		} else {
			// trace('create new node');
			node = new SllNode(cast null);
		}

		return node;

	}


	public inline function clear(){

		while(valid(head)) {
			var _head = head;
			head = head.next;
			addToPool(_head);
		}
	    
	}

	public inline function isEmpty():Bool {

	    return head == null;

	}


	public inline function remove(_value:T):Bool{

		var _ret:Bool = false;

		var prev = null;
		var node = head;
	    while(valid(node)) {
	    	if(node.value == _value){
	    		if(prev != null){
	    			prev.next = node.next;
	    		} else {
	    			head = node.next; 
	    		}

				addToPool(node);

	    		_ret = true;
	    		break;
	    	}
	    	prev = node;
			node = node.next;
		}

		return _ret;

	}

	inline function toString() {

		var _list = []; 

		var node = head;
		while (valid(node)){
			_list.push(node.value);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public function exists(_value:T) : Bool {

		var node = head;
		while (valid(node)){
			if (node.value == _value){
				return true;
			}

			node = node.next;
		}

		return false;

	}

	inline function valid(node:SllNode<T>):Bool {

		return node != null;

	}

	public inline function iterator():Iterator<T> {

		return new ListIterator<T>(head);

	}


}


private class SllNode<T> {


	public var value : T;
	public var next : SllNode<T>;


	public function new(_value:T){

		value = _value;

	}


}


