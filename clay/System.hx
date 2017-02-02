package clay;

import luxe.Quaternion;
import luxe.Vector;
import luxe.Transform;
import luxe.Input;
import luxe.Screen;
import luxe.Objects.ID;
import luxe.options.ComponentOptions;

import luxe.Log.log;
import luxe.Log._debug;
import luxe.Log._verbose;


class System extends ID {


    public var active (get, set) : Bool;
    public var priority (default, set) : Int = 0;
    var _active : Bool = true;

    @:noCompletion public var prev : System;
    @:noCompletion public var next : System;
    
        /** called when the scene is initiated. **use this instead of new** for system setup. it respects the order of creations, children, and component ordering. */
    public function init() {}
        /** called once per frame, passing the delta time */
    public function update(dt:Float) {}

        /** called when the system is added to systems */
    public function onadded() {}
        /** called when the system is removed from systems */
    public function onremoved() {}

        /** called when the system is enabled */
    @:noCompletion public function onenabled() {}
        /** called when the system is disabled */
    @:noCompletion public function ondisabled() {}

        /** called when the system update priority is changed */
    @:noCompletion public function onprioritychanged(value:Int) {}

        /** called when the fixed update is triggered, if the entity has a fixed_rate set. hands the fixed_rate for interchangeable update/fixedupdate convenience */
    @:noCompletion public function onfixedupdate(rate:Float) {}
       /** called when the scene starts or is reset. use this to reset state. */
    @:noCompletion public function onreset() {}
        /** called when the scene, parent or entity is destroyed. use this to clean up state. */
    @:noCompletion public function ondestroy() {}

        /** override this to get notified when a key is released. only called if overridden. */
    @:noCompletion public function onkeyup( event:KeyEvent ) {}
        /** override this to get notified when a key is pressed. only called if overridden. */
    @:noCompletion public function onkeydown( event:KeyEvent ) {}
        /** override this to get notified when a text input event happens. only called if overridden. */
    @:noCompletion public function ontextinput( event:TextEvent ) {}

        /** override this to get notified when a named input event happens. only called if overridden. */
    @:noCompletion public function oninputdown( event:InputEvent ) {}
        /** override this to get notified when a named input event happens. only called if overridden. */
    @:noCompletion public function oninputup( event:InputEvent ) {}

        /** override this to get notified when a mouse button is pressed. only called if overridden. */
    @:noCompletion public function onmousedown( event:MouseEvent ) {}
        /** override this to get notified when a mouse button is pressed. only called if overridden. */
    @:noCompletion public function onmouseup( event:MouseEvent ) {}
        /** override this to get notified when a mouse is moved. only called if overridden. */
    @:noCompletion public function onmousemove( event:MouseEvent ) {}
        /** override this to get notified when the mouse wheel/trackpad is scrolled. only called if overridden. */
    @:noCompletion public function onmousewheel( event:MouseEvent ) {}

        /** override this to get notified when a touch begins. only called if overridden. */
    @:noCompletion public function ontouchdown( event:TouchEvent ) {}
        /** override this to get notified when a touch ends. only called if overridden. */
    @:noCompletion public function ontouchup( event:TouchEvent ) {}
        /** override this to get notified when a touch moves. only called if overridden. */
    @:noCompletion public function ontouchmove( event:TouchEvent ) {}

        /** override this to get notified when a gamepad button is released. only called if overridden. */
    @:noCompletion public function ongamepadup( event:GamepadEvent ) {}
        /** override this to get notified when a gamepad button is pressed. only called if overridden. */
    @:noCompletion public function ongamepaddown( event:GamepadEvent ) {}
        /** override this to get notified when a gamepad axis changes. only called if overridden. */
    @:noCompletion public function ongamepadaxis( event:GamepadEvent ) {}
        /** override this to get notified when a gamepad device event happens. only called if overridden. */
    @:noCompletion public function ongamepaddevice( event:GamepadEvent ) {}

       /** override this to get notified when a window is moved, with the data containing the new x/y position */
    @:noCompletion public function onwindowmoved( event:WindowEvent ) {}
        /** override this to get notified when a window is resized by the user, with the data containing the new x/y size */
    @:noCompletion public function onwindowresized( event:WindowEvent ) {}
        /** override this to get notified when a window is resized by the system or code or the user, with the data containing the new x/y size */
    @:noCompletion public function onwindowsized( event:WindowEvent ) {}
        /** override this to get notified when a window is minimized. */
    @:noCompletion public function onwindowminimized( event:WindowEvent ) {}
        /** override this to get notified when a window is restored. */
    @:noCompletion public function onwindowrestored( event:WindowEvent ) {}

    @:noCompletion public function onrender() {}
    @:noCompletion public function onprerender() {}
    @:noCompletion public function onpostrender() {}

    public var systems_manager:clay.Systems;


        /** Use this to pass instance specific data and values to the system. */
    public function new( ?_options:SystemOptions ) {

        var _name = '';

        if(_options != null) {
            if(_options.name != null) {
                _name = _options.name;
            }
        }

        super(_name == '' ? 'system.${Luxe.utils.uniqueid()}' : _name);

    } //new

    public function destroy() {
        
    } //destroy

//Internal

    function set_priority(value:Int) : Int {
        
        priority = value;

        onprioritychanged(priority);

        if(systems_manager != null) {
            systems_manager.active_systems.remove( this );
            systems_manager.active_systems.add( this );
        }

        return priority;

    } //set_priority

    inline function get_active():Bool {

        return _active;

    } //get_active

    function set_active(value:Bool):Bool {

        _active = value;

        if(systems_manager != null) {
            if(_active){
                systems_manager.enable(name);
            } else {
                systems_manager.disable(name);
            }
        }
        
        return _active;

    } //set_active

    inline function toString() {
        return 'luxe System: $name / id: $id';
    }

//internal api

} //Component

typedef SystemOptions = {

        /** The name of this system. highly recommended you set this. */
    @:optional var name : String;

} //StatesOptions