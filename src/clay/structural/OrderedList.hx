package clay.structural;


import clay.structural.Pool;


class OrderedList<T> {


	public var length (default, null):Int = 0;
	
	public var head (default, null) :OrderedNode<T>;
	var tail:OrderedNode<T>;

	var _sortingArray:Array<OrderedNode<T>> = [];

	var pool:Pool<OrderedNode<T>>;
	var poolSize :Int = 0;



	public function new(_poolSize:Int = 0){

		function createFunc():OrderedNode<T> {
			return new OrderedNode();
		}

		poolSize = _poolSize;

		pool = new Pool(poolSize, createFunc);

	}

	public function add(_obj:T, _priority:Int):Void {

		var _ordered:OrderedNode<T> = null;

		if(poolSize > 0){
			_ordered = pool.get();
		} else {
			_ordered = new OrderedNode();
		}

		_ordered.object = _obj;
		_ordered.priority = _priority;


		if (head == null) {
			head = tail = _ordered;
			_ordered.next = _ordered.prev = null;
		} else {
			var node = tail;
			while (node != null) {
				if (node.priority <= _ordered.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = _ordered;
				_ordered.prev = tail;
				_ordered.next = null;
				tail = _ordered;
			} else if (node == null) {
				_ordered.next = head;
				_ordered.prev = null;
				head.prev = _ordered;
				head = _ordered;
			} else {
				_ordered.next = node.next;
				_ordered.prev = node;
				node.next.prev = _ordered;
				node.next = _ordered;
			}
		}

		length++;

	}

	public function set(_obj:T, _priority:Int):Void {

		var node = head;
		while (node != null){
			if (node.object == _obj){

				if (head == node){
					head = head.next;
				}

				if (tail == node){
					tail = tail.prev;
				}

				if (node.prev != null){
					node.prev.next = node.next;
				}

				if (node.next != null){
					node.next.prev = node.prev;
				}

				length--;

				break;
			}

			node = node.next;
		}

		var _ordered:OrderedNode<T> = null;

		if(poolSize > 0){
			_ordered = pool.get();
		} else {
			_ordered = new OrderedNode();
		}

		_ordered.object = _obj;
		_ordered.priority = _priority;


		if (head == null) {
			head = tail = _ordered;
			_ordered.next = _ordered.prev = null;
		} else {
			node = tail;
			while (node != null) {
				if (node.priority <= _ordered.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = _ordered;
				_ordered.prev = tail;
				_ordered.next = null;
				tail = _ordered;
			} else if (node == null) {
				_ordered.next = head;
				_ordered.prev = null;
				head.prev = _ordered;
				head = _ordered;
			} else {
				_ordered.next = node.next;
				_ordered.prev = node;
				node.next.prev = _ordered;
				node.next = _ordered;
			}
		}

		length++;

	}

	public function exists(_obj:T) : Bool {

		var node = head;
		while (node != null){
			if (node.object == _obj){
				return true;
			}

			node = node.next;
		}

		return false;

	}

	public function get(_obj:T) : OrderedNode<T> {

		var node = head;
		while (node != null){
			if (node.object == _obj){
				return node;
			}

			node = node.next;
		}

		return null;

	}


	/* update node priority */
	public inline function update(_node:OrderedNode<T>) : Void {

		removeNode(_node);
		add(_node.object, _node.priority);

	}
	
	public inline function remove(_obj:T) : Bool {

		var _ret:Bool = false;
		var _toPool = null;
		var node = head;
		while (node != null){
			if (node.object == _obj){

				_toPool = node;

				if (head == node){
					head = head.next;
				}

				if (tail == node){
					tail = tail.prev;
				}

				if (node.prev != null){
					node.prev.next = node.next;
				}

				if (node.next != null){
					node.next.prev = node.prev;
				}

				length--;

				_ret = true;

				break;
			}

			node = node.next;
		}

		pool.put(_toPool);

		return _ret;

	}

	public inline function removeNode(node:OrderedNode<T>) : Void {

		var _toPool = node;

		if (head == node){
			head = head.next;
		}

		if (tail == node){
			tail = tail.prev;
		}

		if (node.prev != null){
			node.prev.next = node.next;
		}

		if (node.next != null){
			node.next.prev = node.prev;
		}

		pool.put(_toPool);

		length--;

	}

	public function sort() : Void {


		var node = head;
		while (node != null){
			_sortingArray.push(node);
			node = node.next;
		}

		clear();
		
		for (n in _sortingArray) {
			add(n.object, n.priority);
		}

		_sortingArray.splice(0, _sortingArray.length);

	}

	public function clear() : Void {

		var _node = null;
		while (head != null) {
			_node = head;
			head = head.next;
			_node.prev = null;
			_node.next = null;

			pool.put(_node);

			length--;
		}

		tail = null;

	}

	inline function toString() {

		var _list:Array<String> = []; 

		var cn:String;
		var node = head;
		while (node != null){
			cn = 'object : ${node.object} / priority ${node.priority}';
			_list.push(cn);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}


	public inline function iterator() {

		return new OrderedListIterator<T>(head);

	}
	

}


private class OrderedNode<T> {


	public var priority : Int;
	public var object : T;
	public var next : OrderedNode<T>;
	public var prev : OrderedNode<T>;


	public function new(){}


}

private class OrderedListIterator<T> {

	private var prev:HasNextClassNode<T>;

	public inline function new(head:OrderedNode<T>) {
		this.prev = {next: head, object : head.object};
	}

	public inline function hasNext():Bool {
		return prev.next != null;
	}

	public inline function next():T {
		prev = prev.next;
		return prev.object;
	}

}


private typedef HasNextClassNode<T> = {
	var next:OrderedNode<T>;
	var object:T;
}



