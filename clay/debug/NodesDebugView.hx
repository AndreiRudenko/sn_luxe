package clay.debug;


import luxe.Color;
import luxe.Rectangle;
import luxe.Text;
import luxe.utils.Maths;
import luxe.Vector;
import luxe.Input;
import luxe.Screen.WindowEvent;
import luxe.Log.*;

import clay.NodeList;


class NodesDebugView extends luxe.debug.DebugView  {

    var items_list : luxe.Text;

    var margin = 32;
    var font_size = 15.0;

    public function new(_debug:luxe.Debug) {

        super(_debug);

        name = 'Nodes';
        node_lists = [];

        // creating in new, instead of create function
        var debug = Luxe.debug;

        items_list = new luxe.Text({
            name: 'debug.node_lists.list',
            depth : 999.3,
            no_scene : true,
            color : new Color(0,0,0,1).rgb(0xf6007b),
            pos : new Vector(0,0),
            font : Luxe.renderer.font,
            text : get_list(),
            point_size : font_size,
            batcher : debug.batcher,
            visible : false,
        });

        items_list.geometry.id = 'debug.node_lists.list.geometry';

        resize();

    }

    var node_lists : Array<NodeList<Dynamic>>;

    public function add_nodelist(_nodelist:NodeList<Dynamic>) : Void {

        assert(node_lists.indexOf(_nodelist) == -1);

        node_lists.push(_nodelist);

    } //add_nodelist

    public function remove_nodelist(_nodelist:NodeList<Dynamic>) : Bool {

            //maybe this isn't as handy
        assert(node_lists.indexOf(_nodelist) != -1);

        var _result = node_lists.remove(_nodelist);

        refresh();

        return _result;

    } //remove_nodelist

    public override function onkeydown(e:KeyEvent) {

        if(e.keycode == Key.key_2 && visible) {
            toggle_ids();
        }

        if(e.keycode == Key.key_3 && visible) {
            toggle_components();
        }

    } //onkeydown
    var hide_ids : Bool = true;
    function toggle_ids() {
        hide_ids = !hide_ids;
        refresh();
    }

    var hide_components : Bool = true;
    function toggle_components() {
        hide_components = !hide_components;
        refresh();
    }


    inline function tabs(_d:Int) {
        var res = '';
        for(i in 0 ... _d) res += '    ';
        return res;
    }

    inline function list_entity(_list:String, e:luxe.Entity, _depth:Int = 1) : String {

        var _active = (e.active) ? '' : '/ inactive';
        var _pre = (_depth == 1) ? tabs(_depth) : tabs(_depth)+'> ';
        var _id = hide_ids ? '' : e.id;
        var _comp_count = Lambda.count(e.components);
        var _comp = '• ' + _comp_count;
        var _childs = '> ${e.children.length}';

        _list += '${_pre}$_id ${e.name} $_childs $_comp $_active\n';

        if(!hide_components) {
	        for(_name in e.components.keys()) {
	            var comp = e.components.get(_name);
	            var _comp_id = hide_ids ? '' : ' '+comp.id;
	            _list += tabs(_depth+1) + '•$_comp_id ${comp.name}\n';
	        }
        }

        for(_child in e.children) {
            _list = list_entity(_list, _child, _depth+2);
        }

        return _list;
    }

    inline function get_list() : String {

        var _result = '';

            for(_nodelist in node_lists) {
                var _id = hide_ids ? '' : '${_nodelist.id} ';

                _result += _id;
                _result += '${_nodelist.name} ';
                _result += '( ${_nodelist.length} )\n';
                for(node in _nodelist.nodes) {
                    _result = list_entity(_result, node.entity);
                }
            }

        return _result;

    } //get_list

    public override function refresh() {

        items_list.text = get_list();

    } //refresh

    public override function process() {

        if(!visible) return;

        var _has_changed = false;

        for(_node in node_lists) {
            if(_node._has_changed) {
                _has_changed = true;
                _node._has_changed = false;
            }
        } //each nodelist

        if(_has_changed) {

            refresh();

        } //_has_changed

    } //process

#if (desktop || web)
    //:wip:
    override function onmousewheel(e:MouseEvent) {
        var h = items_list.text_bounds.h;
        var vh = Luxe.debug.inspector.size.y - margin;
        var diff = h - vh;

        var new_y = items_list.pos.y;
        var max_y = Luxe.debug.padding.y +(margin*1.5);
        var min_y = max_y;

        if(diff > 0) {
            min_y = (max_y - (diff+(margin*2)));
        }

        new_y -= (margin/2) * e.y;
        new_y = Maths.clamp(new_y, min_y, max_y);
        items_list.pos.y = new_y;
    }
#end

//state
    public override function show() {

        super.show();
        refresh();
        items_list.visible = true;

    } //show

    public override function hide() {

        super.hide();
        items_list.visible = false;

    } //hide

//sizing

    function resize() {

        var debug = Luxe.debug;

        var viewrect = new Rectangle(
            debug.inspector.pos.x + (margin/2),
            debug.inspector.pos.y + (margin*1.5),
            debug.inspector.size.x - margin,
            debug.inspector.size.y - margin - (margin*1.5)
        );

        var left = debug.padding.x + margin;
        var top = debug.padding.y +(margin*1.5);

        if(items_list != null) {
            items_list.pos = new Vector(left, top);
            items_list.clip_rect = viewrect;
        }

    }
    override function onwindowsized(e:WindowEvent) resize();

}
