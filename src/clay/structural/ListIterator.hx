package clay.structural;

class ListIterator<T> {


	var node:ListNode<T>;
	

	public function new(head:ListNode<T>){

		node = head;

	}

	public inline function hasNext():Bool {

		return node != null;

	}
	
	public inline function next():T {

		var _value = node.value;
		node = node.next;
		return _value;

	}
	
}

private typedef ListNode<T> = {
	var next:ListNode<T>;
	var value:T;
}