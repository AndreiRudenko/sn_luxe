package clay.structural;


import clay.structural.GenericListIterator;
import clay.System;


class SystemList {


    // @:allow(clay.Scene)
    @:allow(clay.SystemManager)
	var head:System;

    // @:allow(clay.structural)
	var tail:System;

	var _sortingArray:Array<System> = [];


	public function new(){}

	public function add(processor:System):Void {

		if (head == null) {
			head = tail = processor;
			processor.next = processor.prev = null;
		} else {
			var node:System = tail;
			// node = tail;
			while (node != null) {
				if (node.priority <= processor.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = processor;
				processor.prev = tail;
				processor.next = null;
				tail = processor;
			} else if (node == null) {
				processor.next = head;
				processor.prev = null;
				head.prev = processor;
				head = processor;
			} else {
				processor.next = node.next;
				processor.prev = node;
				node.next.prev = processor;
				node.next = processor;
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

	public function get(systemClass:Class<Dynamic>) : System {

		var node:System = head;
		while (node != null){
			if (Type.getClass(node) == systemClass){
				return node;
			}

			node = node.next;
		}

		return null;

	}

	public inline function remove(processor:System) : Void {

		if (head == processor){
			head = head.next;
		}

		if (tail == processor){
			tail = tail.prev;
		}

		if (processor.prev != null){
			processor.prev.next = processor.next;
		}

		if (processor.next != null){
			processor.next.prev = processor.prev;
		}

	}

	public function sort() : Void {


		var node:System = head;
		while (node != null){
			_sortingArray.push(node);
			node = node.next;
		}

		clear();
		
		for (n in _sortingArray) {
			add(n);
		}

		_sortingArray.splice(0, _sortingArray.length);

	}

	public function clear() : Void {

		var processor:System = null;
		while (head != null) {
			processor = head;
			head = head.next;
			processor.prev = null;
			processor.next = null;
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
