package clay;


import luxe.Ev;
import luxe.Input;
import luxe.Screen;
import luxe.Entity;

import luxe.Log._debug;
import luxe.Log._verboser;

import clay.core.SystemList;

@:access(clay.System)
class Systems {


        /** The list of systems */
    @:noCompletion public var _systems:Map<String, System>;
        /** The ordered list of active systems */
    public var active_systems: SystemList;

    var systems_count:Int = 0;
    var active_count:Int = 0;


    public function new() {

        _systems = new Map();
        active_systems = new SystemList();

        Luxe.core.on(Ev.init, init);
        Luxe.core.on(Ev.destroy, ondestroy);
        Luxe.core.on(Ev.update, update);

        Luxe.core.on(Ev.prerender, prerender);
        Luxe.core.on(Ev.postrender, postrender);
        Luxe.core.on(Ev.render, render);

        Luxe.core.on(Ev.keydown, keydown);
        Luxe.core.on(Ev.keyup, keyup);
        Luxe.core.on(Ev.textinput, textinput);

        Luxe.core.on(Ev.inputup, inputup);
        Luxe.core.on(Ev.inputdown, inputdown);

        Luxe.core.on(Ev.mouseup, mouseup);
        Luxe.core.on(Ev.mousedown, mousedown);
        Luxe.core.on(Ev.mousemove, mousemove);
        Luxe.core.on(Ev.mousewheel, mousewheel);

        Luxe.core.on(Ev.touchup, touchup);
        Luxe.core.on(Ev.touchdown, touchdown);
        Luxe.core.on(Ev.touchmove, touchmove);

        Luxe.core.on(Ev.gamepadup, gamepadup);
        Luxe.core.on(Ev.gamepaddown, gamepaddown);
        Luxe.core.on(Ev.gamepadaxis, gamepadaxis);
        Luxe.core.on(Ev.gamepaddevice, gamepaddevice);

        Luxe.core.on(Ev.windowmoved, windowmoved);
        Luxe.core.on(Ev.windowresized, windowresized);
        Luxe.core.on(Ev.windowsized, windowsized);
        Luxe.core.on(Ev.windowminimized, windowminimized);
        Luxe.core.on(Ev.windowrestored, windowrestored);

    }

    public function destroy() {

        if(systems_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.destroy();
            }
        }

        Luxe.core.off(Ev.init, init);
        Luxe.core.off(Ev.destroy, ondestroy);
        Luxe.core.off(Ev.update, update);

        Luxe.core.off(Ev.prerender, prerender);
        Luxe.core.off(Ev.postrender, postrender);
        Luxe.core.off(Ev.render, render);

        Luxe.core.off(Ev.keydown, keydown);
        Luxe.core.off(Ev.keyup, keyup);
        Luxe.core.off(Ev.textinput, textinput);

        Luxe.core.off(Ev.inputup, inputup);
        Luxe.core.off(Ev.inputdown, inputdown);

        Luxe.core.off(Ev.mouseup, mouseup);
        Luxe.core.off(Ev.mousedown, mousedown);
        Luxe.core.off(Ev.mousemove, mousemove);
        Luxe.core.off(Ev.mousewheel, mousewheel);

        Luxe.core.off(Ev.touchup, touchup);
        Luxe.core.off(Ev.touchdown, touchdown);
        Luxe.core.off(Ev.touchmove, touchmove);

        Luxe.core.off(Ev.gamepadup, gamepadup);
        Luxe.core.off(Ev.gamepaddown, gamepaddown);
        Luxe.core.off(Ev.gamepadaxis, gamepadaxis);
        Luxe.core.off(Ev.gamepaddevice, gamepaddevice);

        Luxe.core.off(Ev.windowmoved, windowmoved);
        Luxe.core.off(Ev.windowresized, windowresized);
        Luxe.core.off(Ev.windowsized, windowsized);
        Luxe.core.off(Ev.windowminimized, windowminimized);
        Luxe.core.off(Ev.windowrestored, windowrestored);

    } //destroy

    public function add<T:System>( _system:T, priority:Int = 0 ) : T {
        
            // set priority
        _system.priority = priority;

            //store it in the system list
        _systems.set( _system.name, _system );
        systems_count++;
            //store reference of the owner
        _system.systems_manager = this;
            //let them know
        _system.onadded();

            //if this system is added
            //after init has happened,
            //it should init immediately
        if(Luxe.core.inited) {
            _system.init();
        }

            // enable system
        enable(_system.name);

            //debug stuff
        _debug('$name / adding a system called ' + _system.name + ', now at ' + Lambda.count(_systems) + ' systems');

        return null;

    } //add

    public function remove<T:System>( _name:String ) : T {

        if(_systems.exists(_name)) {

            var _system:T = cast _systems.get(_name);

            if(_system != null) {

                    //if it's running disable it
                if(_system.active) {
                    disable(_system.name);
                } //_system.active

                    //tell user
                _system.onremoved();

                    //remove it
                _systems.remove(_name);
                systems_count--;

            } //system != null

            return _system;

        } //remove

        return null;


    } //remove

    public function enable( _name:String ) {
        
        if(systems_count == 0) {
            return;
        }

        var _system = _systems.get( _name );
        if(_system != null) {
            _debug('$name / enabling a system ' + _name );
            _system.onenabled();
            _system._active = true;
            active_systems.add(_system);
            active_count++;
            _debug('$name / now at ${active_systems.length} active systems');
        }

    } //enable

    public function disable( _name:String ) {

        if(systems_count == 0) {
            return;
        }

        var _system = _systems.get( _name );
        if(_system != null) {
            _debug('$name / disabling a system ' + _name );
            _system.ondisabled();
            _system._active = false;
            active_systems.remove( _system );
            active_count--;
            _debug('$name / now at ${active_systems.length} active systems');
        }
        
    } //disable

    function init(_) {
        if(systems_count > 0) {
            for (_system in _systems) {
                _system.init();
            }
        }
    } //init

    function reset(_) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onreset();
            }
        }
    } //reset

    function update(dt:Float) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _verboser('${_system.name} / update / $dt');
                _system.update(dt);
            }
        }
    } //update

    function ondestroy(_) {

        destroy();

    } //ondestroy

    function render(_) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onrender();
            }
        }
    } //render

    function prerender(_) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onprerender();
            }
        }
    } //prerender

    function postrender(_) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onpostrender();
            }
        }
    } //postrender

//Internal helper functions

    function keydown(_event:KeyEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onkeydown(_event);
            }
        }
    } //onkeydown

    function keyup(_event:KeyEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onkeyup(_event);
            }
        }
    } //onkeyup

    function textinput(_event:TextEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ontextinput(_event);
            }
        }
    } //ontextinput

//inputbindings

    function inputup(_event:InputEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.oninputup(_event);
            }
        }
    } //oninputup

    function inputdown(_event:InputEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.oninputdown(_event);
            }
        }
    } //oninputdown

//mouse

    function mousedown(_event:MouseEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onmousedown(_event);
            }
        }
    } //onmousedown

    function mousewheel(_event:MouseEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onmousewheel(_event);
            }
        }
    } //onmousewheel

    function mouseup(_event:MouseEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onmouseup(_event);
            }
        }
    } //onmouseup

    function mousemove(_event:MouseEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onmousemove(_event);
            }
        }
    } //onmousemove

//touch

    function touchdown(_event:TouchEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ontouchdown(_event);
            }
        }
    } //ontouchdown

    function touchup(_event:TouchEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ontouchup(_event);
            }
        }
    } //ontouchup

    function touchmove(_event:TouchEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ontouchmove(_event);
            }
        }
    } //ontouchmove

//gamepad

    function gamepadaxis(_event:GamepadEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ongamepadaxis(_event);
            }
        }
    } //ongamepadaxis

    function gamepadup(_event:GamepadEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ongamepadup(_event);
            }
        }
    } //ongamepadup

    function gamepaddown(_event:GamepadEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ongamepaddown(_event);
            }
        }
    } //ongamepaddown

    function gamepaddevice(_event:GamepadEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.ongamepaddevice(_event);
            }
        }
    } //ongamepaddevice

//windowing

    function windowmoved(_event:WindowEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onwindowmoved(_event);
            }
        }
    } //windowmoved

    function windowresized(_event:WindowEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onwindowresized(_event);
            }
        }
    } //windowresized

    function windowsized(_event:WindowEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onwindowsized(_event);
            }
        }
    } //windowsized

    function windowminimized(_event:WindowEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onwindowminimized(_event);
            }
        }
    } //windowminimized

    function windowrestored(_event:WindowEvent) {
        if(active_count > 0) {
            var node = active_systems.head;
            var _system = null;
            while(node != null) {
                _system = node;
                node = node.next;
                _system.onwindowrestored(_event);
            }
        }
    } //windowrestored

}

