package clay.structural;

/**
 *  @author Andrei Rudenko
 */


class ClassList {


	var classes:ClassNode;
	public var length(get, null):Int;


	public function new() {}

	public function set<T>(object:T, objectClass:Class<Dynamic> = null) : T {

		if (objectClass == null){
			objectClass = Type.getClass(object);
		}

		// Does a object already exist?
		var cn:ClassNode = classes;
		while (cn != null){
			if (objectClass == cn.objectClass){
				// remove object
				if (cn.prev != null) {
					cn.prev.next = cn.next;
				}

				if (cn.next != null) {
					cn.next.prev = cn.prev;
				}

				if (cn == classes) {
					classes = cn.next;
				}

				break;
			}

			cn = cn.next;
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

	public function get<T>(objectClass:Class<Dynamic>) : Dynamic {

		var cn:ClassNode = classes;
		while (cn != null){
			if (objectClass == cn.objectClass){
				return cn.object;
			}

			cn = cn.next;
		}

		return null;

	}

	public function exists<T>(objectClass:Class<Dynamic>) : Bool {

		var cn:ClassNode = classes;
		while (cn != null){
			if (objectClass == cn.objectClass){
				return true;
			}

			cn = cn.next;
		}

		return false;

	}

	public function remove<T>(objectClass:Class<Dynamic>) : Bool {

		var c:ClassNode = null;

		var cn:ClassNode = classes;
		while (cn != null){
			if (objectClass == cn.objectClass){

				if (cn.prev != null) {
					cn.prev.next = cn.next;
				}

				if (cn.next != null) {
					cn.next.prev = cn.prev;
				}

				if (cn == classes) {
					classes = cn.next;
				}

				return true;
			}

			cn = cn.next;
		}

		return false;

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

		var cn:ClassNode = classes;
		while (cn != null){
			len++;
			cn = cn.next;
		}

		return len;

	}

	inline function toString() {

		var _list = []; 

		var cn:ClassNode = classes;
		while (cn != null){
			_list.push(cn.objectClass);
			cn = cn.next;
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
