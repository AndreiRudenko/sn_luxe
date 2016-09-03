package clay.structural;

/**
 *  @author Andrei Rudenko
 */


class ClassList {


	var classes:ClassNode;
	public var length(get, null):Int;


	public function new() {}

	inline public function set<T>(object:T, objectClass:Class<Dynamic> = null) : T {

		if (objectClass == null){
			objectClass = Type.getClass(object);
		}

		// Does a object already exist?
		var node:ClassNode = classes;
		while (node != null){
			if (objectClass == node.objectClass){
				// remove object
				if (node.prev != null) {
					node.prev.next = node.next;
				}

				if (node.next != null) {
					node.next.prev = node.prev;
				}

				if (node == classes) {
					classes = node.next;
				}

				break;
			}

			node = node.next;
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

	public function exists<T>(objectClass:Class<Dynamic>) : Bool {

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


}


private class ClassNode {


	public var objectClass : Class<Dynamic>;
	public var object : Dynamic;
	public var next : ClassNode;
	public var prev : ClassNode;


	public function new(){}


}
