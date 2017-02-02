package clay.core;


import clay.core.GenericListIterator;


// based on Ash-Haxe: https://github.com/nadako/Ash-Haxe/blob/master/src/ash/core/SystemList.hx

/**
 * Used internally, this is an ordered list of Systems for use by the engine update loop.
 */


class SystemList {


    public var head (default, null) : System;
    public var tail (default, null) : System;

    public var length(default, null):Int = 0;

    public function new(){}

    public inline function add(systems:System):Void {

        if (head == null) {
            head = tail = systems;
            systems.next = systems.prev = null;
        } else {
            var node:System = tail;
            while (node != null) {
                if (node.priority <= systems.priority){
                    break;
                }

                node = node.prev;
            }

            if (node == tail) {
                tail.next = systems;
                systems.prev = tail;
                systems.next = null;
                tail = systems;
            } else if (node == null) {
                systems.next = head;
                systems.prev = null;
                head.prev = systems;
                head = systems;
            } else {
                systems.next = node.next;
                systems.prev = node;
                node.next.prev = systems;
                node.next = systems;
            }
        }

        length++;

    }

    public inline function exists(_name:String) : Bool {

        var ret:Bool = false;

        var node:System = head;
        while (node != null){
            if (node.name == _name){
                ret = true;
                break;
            }

            node = node.next;
        }

        return ret;

    }

    public inline function get(_name:String):System { 

        var ret:System = null;

        var node:System = head;
        while (node != null){
            if (node.name == _name){
                ret = node;
                break;
            }

            node = node.next;
        }

        return ret;

    }

    public inline function remove(systems:System) : Void {

        if (systems == head){
            head = head.next;
            
            if (head == null) {
                tail = null;
            }
        } else if (systems == tail) {
            tail = tail.prev;
                
            if (tail == null) {
                head = null;
            }
        }

        if (systems.prev != null){
            systems.prev.next = systems.next;
        }

        if (systems.next != null){
            systems.next.prev = systems.prev;
        }

        systems.next = systems.prev = null;

        length--;

    }

    public inline function update(systems:System) : Void {

        remove(systems);
        add(systems);

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

        var systems:System = null;
        while (head != null) {
            systems = head;
            head = head.next;
            systems.prev = null;
            systems.next = null;
        }

        tail = null;
        
        length = 0;

    }

    @:noCompletion public inline function toString() {

        var _list:Array<String> = []; 

        var cn:String;
        var node:System = head;
        while (node != null){
            cn = Type.getClassName(Type.getClass(node));
            _list.push('$cn / priority: ${node.priority}');
            node = node.next;
        }

        return '[${_list.join(", ")}]';

    }

    public inline function iterator():GenericListIterator<System> {

        return new GenericListIterator(head);

    }
    

}
