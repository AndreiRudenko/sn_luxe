package clay;


import luxe.Log.*;

import luxe.Entity;
import luxe.Objects;
import clay.core.NodePool;
import clay.core.GenericListIterator;


// based on Ash-Haxe: https://github.com/nadako/Ash-Haxe/blob/master/src/ash/core/NodeList.hx


class NodeList<TNode:Node<TNode>> extends Objects {


    public var node_class (default, null) : Class<TNode>;
    public var nodes:Map<String, TNode>;
    public var length (default, null) : Int = 0;

    @:noCompletion public var head(default, null):TNode;
    @:noCompletion public var tail(default, null):TNode;

        /** for update debug view */
    @:noCompletion public var _has_changed:Bool = true;

    var component_names:Array<String>;
    var node_pool:NodePool<TNode>;

        /** create new NodeList from node_class */
    public function new( _node_class:Class<TNode> ) {
        
        var _name:String = '';

        node_class = _node_class;

        nodes = new Map();

        #if cpp
            _name = Type.getClassName(node_class);
            component_names = Reflect.field(node_class, "_get_components")();
        #else
            _name = untyped node_class.__name__;
            component_names = untyped node_class._get_components();
        #end

        super(_name);

        node_pool = new NodePool<TNode>( node_class, component_names );
        
        var _view:clay.debug.NodesDebugView = Luxe.core.debug.get_view('Nodes');
        if(_view != null) {
            _view.add_nodelist(this);
        }

    }

        /** destroy NodeList */
    public function destroy(){

        _debug('destroy NodeList: $name');

        empty();

        node_class = null;
        nodes = null;
        component_names = null;

        head = null;
        tail = null;

        var _view:clay.debug.NodesDebugView = Luxe.core.debug.get_view('Nodes');
        if(_view != null) {
            _view.remove_nodelist(this);
        }

    }

        /** add entity if match*/
    public inline function add(_entity:Entity) {

        if(!has_entity(_entity) && match_entity(_entity)) {
            _add_entity(_entity);
        }

    }

        /** force remove entity */
    public inline function remove(_entity:Entity) {

        if(has_entity(_entity)) {
            _remove_entity(_entity);
        }

    }

    inline function has_entity(_entity:Entity):Bool {

        return nodes.exists(_entity.name);

    }

    public inline function empty() {

        _debug('remove all nodes and nodes');

        for (node in nodes) {
            _remove_entity(node.entity);
        }

    }

    inline function match_component(_component_name:String):Bool {

        var ret:Bool = false;

        for (n in component_names) { // maybe some faster solution ?
            if(n == _component_name) {
                ret = true;
                break;
            }
        }

        _debug('component: ${_componentClass} ${ret == true ? 'is' : 'is not'} match');

        return ret;

    }

    inline function match_entity(_entity:Entity):Bool {

        var ret:Bool = true;

        for (n in component_names) { // maybe some faster solution ?
            if(!_entity.has(n)) {
                ret = false;
                break;
            }
        }

        _debug('entity: ${_entity.name} ${ret == true ? 'is' : 'is not'} match');

        return ret;

    }

    inline function _add_entity(_entity:Entity) {

        _debug('add entity: ${_entity.name}');

        var node:TNode = node_pool.get();
        node.entity = _entity;

        for (n in component_names) {
            Reflect.setField(node, n, _entity.get(n));
        }

        nodes.set(_entity.name, node);

        // add to nodeList
        if (head == null) {
            head = tail = node;
            node.next = node.prev = null;
        } else {
            tail.next = node;
            node.prev = tail;
            node.next = null;
            tail = node;
        }

        emit(NodeEvent.added, node);

        length++;

        _has_changed = true;

    }

    inline function _remove_entity(_entity:Entity) {

        // _debug('"${node_class}" / remove entity: "${_entity.name}"');

        var node:TNode = nodes.get(_entity.name);
        nodes.remove(_entity.name);

        // remove from nodeList
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

        emit(NodeEvent.removed, node);

        node_pool.put(node);

        length--;

        _has_changed = true;
        
    }

    inline function component_added(_entity:Entity, _component_name:String) {
        
        // _debug('"${node_class}" / component: "${_componentClass}" added to entity: "${_entity.name}"');

        if(!has_entity(_entity) && match_entity(_entity)) {
            _add_entity(_entity);
        }

    }

    inline function component_removed(_entity:Entity, _component_name:String) {

        // _debug('"${node_class}" / component: "${_componentClass}" removed from entity: "${_entity.name}"');

        if(has_entity(_entity) && match_component(_component_name)) {
            _remove_entity(_entity);
        }

    }

    function toString() {

        return 'NodeList: $name / ${Lambda.count(nodes)} nodes';

    }

    @:noCompletion public inline function iterator():GenericListIterator<TNode> {

        return new GenericListIterator(head);

    }

}

@:enum abstract NodeEvent(Int) from Int to Int {

    var unknown      = 0;
    var added        = 1;
    var removed      = 2;

}