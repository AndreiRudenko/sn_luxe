package clay.structural;

// doubly linked list
import clay.structural.ListIterator;


class Dll<T> {


	public var head (default, null) : DllNode<T>;
	public var tail (default, null) : DllNode<T>;

	public var poolSize (default, null) : Int = 0;
	public var length(default, null):Int = 0;

	var headPool : DllNode<T>;
	var tailPool : DllNode<T>;

	var reservedSize : Int = 0;


	public function new(_reservedSize:Null<Int> = 0) {

		if(_reservedSize > 0){
			reservedSize = _reservedSize;
			while(poolSize < reservedSize) {
				putNodeToPool(new DllNode<T>(cast null));
			}
		}

	}

	public inline function addFirst(_value:T) : DllNode<T> {

		var node = getNodeFromPool(_value);

		node.next = head;
		if (head != null){
			head.prev = node;
		} else {
			tail = node;
		}

		head = node;
		
		length++;

		return node;

	}

	public inline function addLast(_value:T) : DllNode<T> {

		var node = getNodeFromPool(_value);

		if (tail != null) {
			tail.next = node;
			node.prev = tail;
		} else{
			head = node;
		}

		tail = node;
		
		length++;

		return node;

	}

	public inline function getFirst() : T {

		if(head != null){
			return head.value;
		}

		return null;

	}

	public inline function getLast() : T {

		if(tail != null){
			return tail.value;
		}

		return null;

	}

	public inline function getNode(_value:T) : DllNode<T> {

		var _ret:DllNode<T> = null;

		var len = length;

		var nodeHead = head;
		var nodeTail = tail;

		while(len > 0) {

			if(nodeHead.value == _value){
				_ret = nodeHead;
				break;
			} else if(nodeTail.value == _value){
				_ret = nodeTail;
				break;
			}

			nodeHead = nodeHead.next;
			nodeTail = nodeTail.prev;

			len -= 2;
		}

		return _ret;

	}

	public inline function remFirst() : T {
		
		var node = head;
		if (head == tail){
			head = tail = null;
		} else {
			head = head.next;
			node.next = null;
			head.prev = null;
		}

		length--;

		return putNodeToPool(node);

	}

	public inline function remLast() : T {
		
		var node = tail;
		if (head == tail){
			head = tail = null;
		} else {
			tail = tail.prev;
			node.prev = null;
			tail.next = null;
		}
		
		length--;

		return putNodeToPool(node);

	}

	public inline function remove(_value:T):Bool{

		var node = getNode(_value);
		if(node != null){
			removeNode(node);
			return true;
		}
		
		return false;

	}

	public inline function removeNode(node:DllNode<T>) {
		
		if (node == head){
			head = head.next;
			
			if (head == null) {
				tail = null;
			}
		} else if (node == tail) {
			tail = tail.prev;
				
			if (tail == null) {
				head = null;
			}
		}

		if (node.prev != null) {
			node.prev.next = node.next;
		}

		if (node.next != null) {
			node.next.prev = node.prev;
		}

		node.next = node.prev = null;


		putNodeToPool(node);
		length--;

	}

	public inline function exists(_value:T) : Bool {

		return getNode(_value) != null;

	}

	public inline function clear(gc:Bool = true){

		if (gc || reservedSize > 0) {
			var node = head;
			var next = null;
			for (i in 0...length) {

				next = node.next;

				node.prev = null;
				node.next = null;

				putNodeToPool(node);

				node = next;
			}
		}
		
		head = tail = null;
		length = 0;
		
	}

	public inline function toArray():Array<T>{

		var ret:Array<T> = [];

		var node = head;
		while (node != null){
			ret.push(node.value);
			node = node.next;
		}
		
		return ret;

	}
	
	inline function getNodeFromPool(_value:T):DllNode<T> {

		var node:DllNode<T> = null;

		if(reservedSize == 0 || poolSize == 0){
			node = new DllNode(_value);
		} else {
			node = headPool;

			headPool = headPool.next;

			if(headPool == null){
				tailPool = null;
			}

			poolSize--;

			node.next = null;
			node.value = _value;
		}

		return node;

	}

	inline function putNodeToPool(node:DllNode<T>):T {

		var _value = node.value;

		if(reservedSize > 0 && poolSize < reservedSize){

			if(headPool == null){
				headPool = tailPool = node;
			} else {
				tailPool = tailPool.next = node;
			}

			node.value = cast null; // clear node value

			poolSize++;
		} else {
			node.value = cast null;
			node.prev = null;
			node.next = null;
		}

		return _value;

	}

	public inline function printPool(){

	    var _list = []; 

		var node = headPool;
		while (node != null){
			_list.push(node.value);
			node = node.next;
		}

		return 'pool: [${_list.join(", ")}]';

	}

	inline function toString() {

		var _list = []; 

		var node = head;
		while (node != null){
			_list.push(node.value);
			node = node.next;
		}

		return 'node: [${_list.join(", ")}]';

	}
	
	public inline function iterator():Iterator<T> {

		return new ListIterator<T>(head);

	}


}


private class DllNode<T> {


	public var value : T;
	public var next : DllNode<T>;
	public var prev : DllNode<T>;


	public function new(_value:T){
		// trace('new DllNode');
		value = _value;

	}


}


