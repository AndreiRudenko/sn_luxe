package clay;


import luxe.Entity;


// from Ash-Haxe: https://github.com/nadako/Ash-Haxe/blob/master/src/ash/core/Node.hx


@:autoBuild(clay.NodeMacro.build())
class Node<TNode> {


    public var entity:Entity;


    // name and type must match added to entity component
    // for example:
    
    // some_entity.add(new ComponentA('component_name'));
    // some_entity.add(new ComponentA('component_name2'));
    // some_entity.add(new ComponentB('another_component_name'));

    // public var component_name:ComponentA;
    // public var component_name2:ComponentA;
    // public var another_component_name:ComponentB;

        /** Used by the NodeList class. The previous node in a node list. */
    public var prev:TNode;

        /** Used by the NodeList class. The next node in a node list. */
    public var next:TNode;

}

