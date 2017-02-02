

import luxe.Entity;
import luxe.Component;
import luxe.GameConfig;
import luxe.Input;

import clay.Node;
import clay.NodeList;
import clay.NodeList.NodeEvent;
import clay.System;


class Main extends luxe.Game {

    override function config(config:GameConfig) {

        config.window.title = 'luxe game';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        return config;

    } //config

    public static var systems:clay.Systems;
    public static var nodes:clay.Nodes;

    override function ready() {

        #if !no_debug_console
            luxe.Debug.views.push(new clay.debug.NodesDebugView(Luxe.debug));
        #end
        
        systems = new clay.Systems();
        nodes = new clay.Nodes();

        nodes.create(NodeA);
        nodes.create(NodeB);

        systems.add(new SystemA(), 1); // priority, updating after SystemB
        systems.add(new SystemB(), 0);

        var e:Entity = new Entity();
        e.add(new ComponentA('compA'));
        e.add(new ComponentA('compA2'));
        e.add(new ComponentB('compB'));

        var e2:Entity = new Entity();
        e2.add(new ComponentA('compA'));
        e2.add(new ComponentB('compB'));

    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main


class ComponentA extends Component {

    public var text:String;

    public function new(_name:String) {
        super({name : _name});
    }

    override function onadded() {
        text = Luxe.utils.uniqueid();
        Luxe.events.fire('component.added', {entity : entity, component : this});
    }

    override function onremoved() {
        Luxe.events.fire('component.removed', {entity : entity, component : this});
    }

} //ComponentA


class ComponentB extends Component {

    public var number:Float;

    public function new(_name:String) {
        super({name : _name});
    }

    override function onadded() {
        number = Math.random();
        Luxe.events.fire('component.added', {entity : entity, component : this});
    }

    override function onremoved() {
        Luxe.events.fire('component.removed', {entity : entity, component : this});
    }

} //ComponentB



class NodeA extends Node<NodeA> {
    public var compA:ComponentA;
    public var compB:ComponentB;
} //NodeA


class NodeB extends Node<NodeB> {
    public var compA:ComponentA;
    public var compA2:ComponentA;
    public var compB:ComponentB;
} //NodeB


class SystemA extends System {

    var a_nodes:NodeList<NodeA>;

    public function new() {
        super({name : 'systemA'});
    }

    override function onadded() {
        a_nodes = Main.nodes.get(NodeA);
    }

    override function onmousedown( event:MouseEvent ) {
        trace('SystemA a_nodes: ${a_nodes.length} ');

        for (node in a_nodes) {
            trace(node.entity.name);
            trace(node.compA.text);
            trace(node.compB.number);
        }
    }

    override function update( dt:Float ) {

        for (node in a_nodes) {
            // do stuff
        }

    }


} //SystemA


class SystemB extends System {

    var b_nodes:NodeList<NodeB>;

    public function new() {
        super({name : 'systemB'});
    }

    override function onadded() {
        b_nodes = Main.nodes.get(NodeB);

        b_nodes.on(NodeEvent.added, node_added);
        b_nodes.on(NodeEvent.removed, node_removed);
    }

    function node_added(node:NodeB) {
        trace('node added with entity: ${node.entity.name}');
    }

    function node_removed(node:NodeB) {
        trace('node removed with entity: ${node.entity.name}');
    }

    override function onmousedown( event:MouseEvent ) {

        trace('SystemB b_nodes: ${b_nodes.length} ');

        for (node in b_nodes) {
            trace(node.entity.name);
            trace(node.compA.text);
            trace(node.compA2.text);
            trace(node.compB.number);
        }

    }


} //SystemB
