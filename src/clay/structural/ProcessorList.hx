package clay.structural;


import clay.Processor;


class ProcessorList {


    @:allow(clay.Scene)
	var head:Processor;

    // @:allow(clay.structural)
	var tail:Processor;


	public function new(){}

	public function add(processor:Processor):Void {

		// Does a object already exist?
		var node:Processor = head;
		while (node != null){
			if (node == processor){
				// remove object
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

				break;
			}

			node = node.next;
		}

		if (head == null) {
			head = tail = processor;
			processor.next = processor.prev = null;
		} else {
			node = tail;
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

	public function remove(processor:Processor) : Void {

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

	public function removeByName(name:String) : Bool {

		var node:Processor = head;
		while (node != null){
			if (node.name == name){

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

				return true;

			}

			node = node.next;
		}

		return false;

	}

	public function get(name:String) : Processor {

		var node:Processor = head;
		while (node != null){
			if (node.name == name){
				return node;
			}

			node = node.next;
		}

		return null;

	}

	public function sort() : Void {

		var arr:Array<Processor> = [];

		var node:Processor = head;
		while (node != null){
			arr.push(node);
			node = node.next;
		}

		for (n in arr) {
			add(n);
		}

	}

	public function clear() : Void {

		var processor:Processor = null;
		while (head != null) {
			processor = head;
			head = head.next;
			processor.prev = null;
			processor.next = null;
		}

		tail = null;

	}

	inline function toString() {

		var _list = []; 

		var node:Processor = head;
		while (node != null){
			_list.push(node.name);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

}
