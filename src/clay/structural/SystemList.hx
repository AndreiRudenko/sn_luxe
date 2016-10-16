package clay.structural;


import clay.structural.GenericListIterator;
import clay.System;


class SystemList {


	public var head (default, null) : System;
	public var tail (default, null) : System;

	public var length(default, null):Int = 0;

	public function new(){}

	public inline function add(system:System):Void {

		if (head == null) {
			head = tail = system;
			system.next = system.prev = null;
		} else {
			var node:System = tail;
			while (node != null) {
				if (node.priority <= system.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = system;
				system.prev = tail;
				system.next = null;
				tail = system;
			} else if (node == null) {
				system.next = head;
				system.prev = null;
				head.prev = system;
				head = system;
			} else {
				system.next = node.next;
				system.prev = node;
				node.next.prev = system;
				node.next = system;
			}
		}

		length++;

	}

	public inline function exists(systemClass:Class<Dynamic>) : Bool {

		var ret:Bool = false;

		var node:System = head;
		while (node != null){
			if (Type.getClass(node) == systemClass){
				ret = true;
			}

			node = node.next;
		}

		return ret;

	}

	public inline function get(systemClass:Class<Dynamic>):System { 

		var ret:System = null;

		var node:System = head;
		while (node != null){
			if (Type.getClass(node) == systemClass){
				ret = node;
			}

			node = node.next;
		}

		return ret;

	}

	public inline function remove(system:System) : Void {

		if (system == head){
			head = head.next;
			
			if (head == null) {
				tail = null;
			}
		} else if (system == tail) {
			tail = tail.prev;
				
			if (tail == null) {
				head = null;
			}
		}

		if (system.prev != null){
			system.prev.next = system.next;
		}

		if (system.next != null){
			system.next.prev = system.prev;
		}

		system.next = system.prev = null;

		length--;

	}

	public inline function update(system:System) : Void {

		remove(system);
		add(system);

	}

	public function updateAll() : Void {

		var _sortingArray:Array<System> = [];

		var node:System = head;
		while (node != null){
			_sortingArray.push(node);
			node = node.next;
		}

		clear();
		
		for (n in _sortingArray) {
			add(n);
		}

	}

	public function clear() : Void {

		var system:System = null;
		while (head != null) {
			system = head;
			head = head.next;
			system.prev = null;
			system.next = null;
		}

		tail = null;
		
		length = 0;

	}

	inline function toString() {

		var _list:Array<String> = []; 

		var cn:String;
		var node:System = head;
		while (node != null){
			cn = Type.getClassName(Type.getClass(node));
			_list.push(cn);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():GenericListIterator<System> {

		return new GenericListIterator(head);

	}
	

}
