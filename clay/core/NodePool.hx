package clay.core;


// from Ash-Haxe: https://github.com/nadako/Ash-Haxe/blob/master/src/ash/core/NodePool.hx


/**
 * This internal class maintains a pool of deleted nodes for reuse by the framework. This reduces the overhead
 * from object creation and garbage collection.
 *
 * Because nodes may be deleted from a NodeList while in use, by deleting Nodes from a NodeList
 * while iterating through the NodeList, the pool also maintains a cache of nodes that are added to the pool
 * but should not be reused yet. They are then released into the pool by calling the releaseCache method.
 */


class NodePool<TNode:Node<TNode>> {


    var tail:TNode;
    var node_class:Class<TNode>;
    var cache_tail:TNode;
    var components:Array<String>;

        /** Creates a pool for the given node class. */
    public function new(_node_class:Class<TNode>, _components:Array<String>) {

        node_class = _node_class;
        components = _components;

    }

        /** Get a node from the pool. */
    public function get():TNode {

        if (tail != null) {
            var node:TNode = tail;
            tail = tail.prev;
            node.prev = null;
            return node;
        } else {
            return Type.createEmptyInstance(node_class);
        }

    }

        /** Adds a node to the pool. */
    public function put(node:TNode):Void {

        for (n in components){
            Reflect.setField(node, n, null);
        }

        // node.entity = null;
        node.entity = cast null;
        node.next = null;
        node.prev = tail;
        tail = node;

    }

        /** Adds a node to the cache. */
    public function cache(node:TNode):Void {

        node.prev = cache_tail;
        cache_tail = node;

    }

        /** Releases all nodes from the cache into the pool. */
    public function release_cache():Void {

        while (cache_tail != null) {
            var node:TNode = cache_tail;
            cache_tail = node.prev;
            node.next = null;
            node.prev = tail;
            tail = node;
        }

    }


}
