package clay.core;

// clay.core._ClassList.ClNode<clay.core.ClassList.T>
// clay.core._ClassList.ClINode<clay.core.ClassList.T>

class ClassList<T> {


    public var head (default, null) : ClNode<T>;
    public var tail (default, null) : ClNode<T>;

    public var length(default, null):Int = 0;


    public function new() {}

        /** add to list */
    public inline function add(_object_class:Class<Dynamic>, _object:T) : ClNode<T> {

        var node:ClNode<T> = new ClNode(_object_class, _object);

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

        /** set to list, overwrite object class exists */
    public inline function set(_object_class:Class<Dynamic>, _object:T): ClNode<T> {

        var node = get_node(_object_class);

        if(node != null) {
            remove_node(node);
        }

        return add(_object_class, _object);

    }

        /** remove from list */
    public function remove(object_class:Class<Dynamic>):Bool{

        var node = get_node(object_class);

        if(node != null){
            remove_node(node);
            return true;
        }

        return false;

    }

    public inline function exists(object_class:Class<Dynamic>) : Bool {

        return get_node(object_class) != null;

    }
    
    public function get(object_class:Class<Dynamic>) : T {

        var node = get_node(object_class);

        if(node != null){
            return node.object;
        }

        return null;

    }   

    public inline function get_node(object_class:Class<Dynamic>) : ClNode<T> {

        var _ret:ClNode<T> = null;

        var len = length;

        var nodeHead = head;
        var nodeTail = tail;

        while(len > 0) {

            if(nodeHead.object_class == object_class){
                _ret = nodeHead;
                break;
            } else if(nodeTail.object_class == object_class){
                _ret = nodeTail;
                break;
            }

            nodeHead = nodeHead.next;
            nodeTail = nodeTail.prev;

            len -= 2;
        }

        return _ret;

    }

    public inline function remove_node(node:ClNode<T>) {
        
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

    public inline function toArray():Array<T>{

        var ret:Array<T> = [];

        var node = head;
        while (node != null){
            ret.push(node.object);
            node = node.next;
        }
        
        return ret;

    }

    inline function toString() {

        var _list = []; 

        var node = head;
        while (node != null){
            _list.push(node.object_class);
            node = node.next;
        }

        return '[${_list.join(", ")}]';

    }

    public inline function keys():Iterator<Class<Dynamic>> {

        return new ClassListKeysIterator<T>(cast head);

    }

    public inline function iterator():Iterator<T> {

        return new ClassListIterator<T>(cast head);

    }


}


private class ClNode<T> {


    public var object_class : Class<Dynamic>;
    public var object : T;
    public var next : ClNode<T>;
    public var prev : ClNode<T>;


    public function new(_object_class:Class<Dynamic>, _object:T){
        
        object = _object;
        object_class = _object_class;

        if(object_class == null){
            object_class = Type.getClass(object);
        }

    }


}


private class ClassListKeysIterator<T> {


    var node:ClINode<T>;
    

    public function new(head:ClINode<T>){

        node = head;

    }

    public inline function hasNext():Bool {

        return node != null;

    }
    
    public inline function next():Class<Dynamic> {

        var _object_class = node.object_class;
        node = node.next;
        return _object_class;

    }
    
}

private class ClassListIterator<T> {


    var node:ClINode<T>;
    

    public function new(head:ClINode<T>){

        node = head;

    }

    public inline function hasNext():Bool {

        return node != null;

    }
    
    public inline function next():T {

        var _object = node.object;
        node = node.next;
        return _object;

    }
    
}

private typedef ClINode<T> = {

    var next:ClINode<T>;
    var object:T;
    var object_class:Class<Dynamic>;

}