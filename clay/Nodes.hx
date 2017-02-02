package clay;


import luxe.Entity;
import luxe.Log.*;

import clay.core.ClassList;

@:access(clay.NodeList)
class Nodes {

        /** node lists */
    var node_lists:ClassList<NodeList<Dynamic>>;

    var _component_added_eid:String;
    var _component_removed_eid:String;


    public function new() {
        
        _debug('creating new Nodes');

        node_lists = new ClassList();

        _component_added_eid = Luxe.events.listen('component.added', component_added); // use emitter?
        _component_removed_eid = Luxe.events.listen('component.removed', component_removed);

    }

        /** create and add node to node_lists list */
    public function create<TNode:Node<TNode>>(_node_class:Class<TNode>):NodeList<TNode> {

        #if js
            _debug('create NodeList: "${untyped _node_class.__name__}"');
        #else
            _debug('create NodeList: "${_node_class}"');
        #end

        var _nodelist:NodeList<TNode> = cast node_lists.get(_node_class);

        if(_nodelist == null) {
            _nodelist = new NodeList(_node_class);
            add(_nodelist);
        }

        return _nodelist;

    }

        /** add node to node_lists list */
    public function add<TNode:Node<TNode>>(_nodelist:NodeList<TNode>):NodeList<TNode> {

        #if js
            _debug('add NodeList: "${untyped _nodelist.node_class.__name__}"');
        #else
            _debug('add NodeList: "${_nodelist.node_class}"');
        #end

        node_lists.add(_nodelist.node_class, _nodelist);

        // for (e in Luxe.scene.entities) {
        //  _nodelist.add(e);
        // }

        return _nodelist;

    }

        /** get node from node_lists list */
    public inline function get<TNode:Node<TNode>>(_node_class:Class<TNode>):NodeList<TNode> {

        return cast node_lists.get(_node_class);

    }

        /** remove node from node_lists list */
    public function remove<TNode:Node<TNode>>(_node_class:Class<TNode>):NodeList<TNode> {

        #if js
            _debug('remove NodeList: "${untyped _node_class.__name__}"');
        #else
            _debug('remove NodeList: "${_node_class}"');
        #end

        var _nodelist:NodeList<TNode> = cast node_lists.get(_node_class);
        if(_nodelist != null) {
            _nodelist.empty();
            node_lists.remove(_node_class);
        }
        
        return _nodelist;

    }

        /** remove all from node_lists list */
    public function empty() {

        _debug('remove all entities and node_lists');

        var node = node_lists.head;
        while(node != null) {
            node.object.empty();
            node = node.next;
        }

    }

        /** destroy Nodes */
    public function destroy() {

        _debug('destroy Nodes');

        empty();

        Luxe.events.unlisten(_component_added_eid);
        Luxe.events.unlisten(_component_removed_eid);

        node_lists = null;

    }

    function component_added(_event) {

        var entity = _event.entity;
        var component_name = _event.component.name;

        var node = node_lists.head;
        while(node != null) {
            node.object.component_added(entity, component_name);
            node = node.next;
        }

    }

    function component_removed(_event) {

        var entity = _event.entity;
        var component_name = _event.component.name;

        var node = node_lists.head;
        while(node != null) {
            node.object.component_removed(entity, component_name);
            node = node.next;
        }

    }

    inline function toString() {

        var _list = []; 

        var node = node_lists.head;
        while (node != null){

            #if js
                _list.push(untyped node.object_class.__name__);
            #else
                _list.push(node.object_class);
            #end

            node = node.next;
        }

        return 'node_lists: [${_list.join(", ")}]';

    }

}