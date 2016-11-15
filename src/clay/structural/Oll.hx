package clay.structural;

// ordered linked list
import clay.structural.ListIterator;


class Oll<T> {


	public var head (default, null) : OllNode<T>;
	public var tail (default, null) : OllNode<T>;

	public var poolSize (default, null) : Int = 0;
	public var length(default, null):Int = 0;

	var headPool : OllNode<T>;
	var tailPool : OllNode<T>;

	var reservedSize : Int = 0;


	public function new(_reservedSize:Null<Int> = 0) {

		if(_reservedSize > 0){
			reservedSize = _reservedSize;
			while(poolSize < reservedSize) {
				putNodeToPool(new OllNode<T>(cast null));
			}
		}

	}

	public inline function add(_value:T, _order:Int) : OllNode<T> {

		var node = getNodeFromPool(_value);
		node.order = _order;

		return addNode(node);

	}

	public inline function addNode(node:OllNode<T>):OllNode<T> {

		if (head == null) {
			head = tail = node;
			// node.next = node.prev = null;
		} else {
			var orderedNode = tail;
			while (orderedNode != null) {
				if (orderedNode.order <= node.order){
					break;
				}
				orderedNode = orderedNode.prev;
			}

			if (orderedNode == tail) {
				tail.next = node;
				node.prev = tail;
				node.next = null;
				tail = node;
			} else if (orderedNode == null) {
				node.next = head;
				node.prev = null;
				head.prev = node;
				head = node;
			} else {
				node.next = orderedNode.next;
				node.prev = orderedNode;
				orderedNode.next.prev = node;
				orderedNode.next = node;
			}
		}

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
	
	public inline function getNode(_value:T) : OllNode<T> {

		var _ret:OllNode<T> = null;

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

	public inline function exists(_value:T) : Bool {

		return getNode(_value) != null;

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

	public inline function removeNode(node:OllNode<T>):OllNode<T> {

		var hook = node;

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

		return hook;
		
	}	

	public inline function update(_value:T, order:Int) {

		var node = getNode(_value);
		updateNode(node, order);

	}

	/* update node priority */
	public inline function updateNode(node:OllNode<T>, order:Int) {

		unlink(node);

		length--;

		node.order = order;
		addNode(node);

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

	inline function getNodeFromPool(_value:T):OllNode<T> {

		var node:OllNode<T> = null;

		if(reservedSize == 0 || poolSize == 0){
			node = new OllNode(_value);
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

	inline function putNodeToPool(node:OllNode<T>):T {

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


	inline function unlink(node:OllNode<T>):OllNode<T> {

		var hook = node;

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

		length--;

		return hook;

	}

	inline function toString() {

		var _list = []; 

		var node = head;
		while (node != null){
			_list.push(node.value);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():Iterator<T> {

		return new ListIterator<T>(head);

	}


}


class OllNode<T> {


	public var order : Int;
	public var value : T;
	public var next : OllNode<T>;
	public var prev : OllNode<T>;


	public function new(_value:T){
		// trace('new OllNode');
		value = _value;

	}


}


