package clay.structural;


import clay.utils.Log.assert;


class ClassList {


	public var head (default, null) : ClNode;
	public var tail (default, null) : ClNode;

	public var length(default, null):Int = 0;


	public function new() {}

	public inline function add<T>(_object:T, _objectClass:Class<Dynamic>) : ClNode {

		var node = new ClNode(_object, _objectClass);

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

	public function remove(objectClass:Class<Dynamic>):Bool{

		var node = getNode(objectClass);

		if(node != null){
			removeNode(node);
			return true;
		}

		return false;

	}

	public inline function exists(objectClass:Class<Dynamic>) : Bool {

		return getNode(objectClass) != null;

	}
	
	public function get<T>(objectClass:Class<Dynamic>) : T {

		var node = getNode(objectClass);

		if(node != null){
			return node.object;
		}

		return null;

	}	

	public inline function getNode(objectClass:Class<Dynamic>) : ClNode {

		var _ret:ClNode = null;

		var len = length;

		var nodeHead = head;
		var nodeTail = tail;

		while(len > 0) {

			if(nodeHead.objectClass == objectClass){
				_ret = nodeHead;
				break;
			} else if(nodeTail.objectClass == objectClass){
				_ret = nodeTail;
				break;
			}

			nodeHead = nodeHead.next;
			nodeTail = nodeTail.prev;

			len -= 2;
		}

		return _ret;

	}

	public inline function removeNode(node:ClNode) {
		
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

	}

	public inline function clear(){

		var node = head;
		var next = null;
		for (i in 0...length) {

			next = node.next;

			node.prev = null;
			node.next = null;

			node = next;
		}
		
		head = tail = null;
		length = 0;
		
	}

	inline function toString() {

		var _list = []; 

		var node = head;
		while (node != null){
			_list.push(node.objectClass);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():Dynamic {

		return new ClassListIterator(head);

	}


}


private class ClNode {


	public var objectClass : Class<Dynamic>;
	public var object : Dynamic;
	public var next : ClNode;
	public var prev : ClNode;


	public function new(_object:Dynamic, _objectClass:Class<Dynamic>){
		
		object = _object;
		objectClass = _objectClass;

		if(objectClass == null){
			objectClass = Type.getClass(object);
		}

	}


}


private class ClassListIterator {


	var node:ClINode;
	

	public function new(head:ClINode){

		node = head;

	}

	public inline function hasNext():Bool {

		return node != null;

	}
	
	public inline function next():Dynamic {

		var _object = node.object;
		node = node.next;
		return _object;

	}
	
}

private typedef ClINode = {
	var next:ClINode;
	var object:Dynamic;
}