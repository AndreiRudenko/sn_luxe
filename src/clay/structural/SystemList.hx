package clay.structural;


import clay.structural.GenericListIterator;
import clay.System;


class SystemList {


	var head:System;
	var tail:System;


	public function new(){}

	public function add(system:System):Void {

		if (head == null) {
			head = tail = system;
			system.next = system.prev = null;
		} else {
			var node:System = tail;
			// node = tail;
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
		
	}

	public function exists(systemClass:Class<Dynamic>) : Bool {

		var node:System = head;
		while (node != null){
			if (Type.getClass(node) == systemClass){
				return true;
			}

			node = node.next;
		}

		return false;

	}

	public function get(systemClass:Class<Dynamic>):System {

		var node:System = head;
		while (node != null){
			if (Type.getClass(node) == systemClass){
				return node;
			}

			node = node.next;
		}

		return null;

	}

	public inline function remove(system:System) : Void {

		if (head == system){
			head = head.next;
		}

		if (tail == system){
			tail = tail.prev;
		}

		if (system.prev != null){
			system.prev.next = system.next;
		}

		if (system.next != null){
			system.next.prev = system.prev;
		}

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
