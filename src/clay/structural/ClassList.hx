package clay.structural;

/**
 *  @author Andrei Rudenko
 */


class ClassList {


	@:noCompletion public var classes:ClassNode;
	public var length(get, null):Int;


	public function new() {}

	inline public function set<T>(object:T, objectClass:Class<Dynamic> = null) : T {

		if (objectClass == null){
			objectClass = Type.getClass(object);
		}

		var c:ClassNode = new ClassNode();

		c.objectClass = objectClass;
		c.object = object;

		// Add to classes doubly linked list.
		c.prev = null;
		c.next = classes;

		if (classes != null) {
			classes.prev = c;
		}

		classes = c;

		return c.object;

	}

	public function get<T>(objectClass:Class<Dynamic>) : T {

		var node:ClassNode = classes;
		while (node != null){
			if (objectClass == node.objectClass){
				return node.object;
			}

			node = node.next;
		}

		return null;

	}

	public function exists(objectClass:Class<Dynamic>) : Bool {

		var node:ClassNode = classes;
		while (node != null){
			if (objectClass == node.objectClass){
				return true;
			}

			node = node.next;
		}

		return false;

	}

	public function remove<T>(objectClass:Class<Dynamic>) : T {

		var node:ClassNode = classes;
		while (node != null){
			if (objectClass == node.objectClass){

				if (node.prev != null) {
					node.prev.next = node.next;
				}

				if (node.next != null) {
					node.next.prev = node.prev;
				}

				if (node == classes) {
					classes = node.next;
				}

				return node.object;
			}

			node = node.next;
		}

		return null;

	}

	public inline function removeNode(node:ClassNode) {

		if(node != null){

			if (node.prev != null) {
				node.prev.next = node.next;
			}

			if (node.next != null) {
				node.next.prev = node.prev;
			}

			if (node == classes) {
				classes = node.next;
			}

			node = null;
			
		}

	}

	inline public function shift<T>() : T {

		if (classes.next != null) {
			classes.next.prev = null;
		}

		var _ret:ClassNode = classes;

		classes = classes.next;

		return _ret.object;

	}

	inline public function clear() {

		var c:ClassNode = null;
		while (classes != null){
			c = classes;
			classes = classes.next;
			c.next = null;
			c.prev = null;
		}

		classes = null;

	}

	inline function get_length():Int {

		var len:Int = 0;

		var node:ClassNode = classes;
		while (node != null){
			len++;
			node = node.next;
		}

		return len;

	}

	inline function toString() {

		var _list = []; 

		var node:ClassNode = classes;
		while (node != null){
			_list.push(node.objectClass);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	inline public function iterator():Dynamic {

		return new ClassListIterator(classes);

	}


}


private class ClassNode { // todo: maybe create pool?


	public var objectClass : Class<Dynamic>;
	public var object : Dynamic;
	public var next : ClassNode;
	public var prev : ClassNode;


	public function new(){}


}


private class ClassListIterator {

	private var prev:HasNextClassNode;

	public inline function new(head:ClassNode) {
		this.prev = {next: head, object : head.object};
	}

	public inline function hasNext():Bool {
		return prev.next != null;
	}

	public inline function next():Dynamic { // todo
		prev = prev.next;
		return prev.object;
	}

}


private typedef HasNextClassNode = {
	var next:ClassNode;
	var object:Dynamic;
}

