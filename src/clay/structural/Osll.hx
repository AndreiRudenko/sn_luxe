package clay.structural;

/**
 *  object singly linked list
 *  @author Andrei Rudenko
 *  just change OsllNode to class whith next variable
 */


class Osll {


	public var head (default, null) : OsllNode;


	public function new() {}

	public inline function add(node:OsllNode) : Void {

		if (head == null) {
			head = node;
		} else {
			node.next = head;
			head = node;
		}

	}

	public function shift():OsllNode{

		if(valid(head)){
			var _head:OsllNode = head;
			head = head.next;
			return _head;
		}

	    return null;

	}

	public function first():OsllNode {

		return head;

	}

	public inline function clear(){

		while(valid(head)) {
			var _head = head;
			head = head.next;
			_head.next = cast null;
		}
	    
	}

	public inline function isEmpty():Bool {

	    return head == null;

	}


	public inline function remove(_node:OsllNode):Bool{

		var _ret:Bool = false;

		var prev = null;
		var node = head;
	    while(valid(node)) {
	    	if(node == _node){
	    		if(prev != null){
	    			prev.next = node.next;
	    		} else {
	    			head = node.next; 
	    		}

	    		node.next = null;

	    		_ret = true;
	    		break;
	    	}
	    	prev = node;
			node = node.next;
		}

		return _ret;

	}

	inline function toString() {

		var _list = []; 

		var node = head;
		while (valid(node)){
			_list.push(node);
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public function exists(_node:OsllNode) : Bool {

		var node = head;
		while (valid(node)){
			if (node == _node){
				return true;
			}

			node = node.next;
		}

		return false;

	}

	inline function valid(node:OsllNode):Bool {

		return node != null;

	}

	public inline function iterator() {

		return new OsllIterator(head);

	}


}

private typedef OsllNode = {

	var next:OsllNode;

}

class OsllIterator {


	var node:OsllNode;
	

	public function new(head:OsllNode){

		node = head;

	}

	public inline function hasNext():Bool {

		return node != null;

	}
	
	public inline function next():OsllNode {

		node = node.next;
		return node;

	}
	
}
