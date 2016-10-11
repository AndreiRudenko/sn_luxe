package clay;


import clay.Objects;
import clay.utils.Log.*;


class Processor {


	public var active : Bool = true;

	public var id       (default, null) : String;
	public var name     (default, set) : String;
	public var priority (default, set) : Int = 0;

	public var events   (default, null): Events;
	public var scene    (get, set) : Scene;
                        
	@:allow(clay.Scene)
	var _scene : Scene;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var prev : Processor;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var next : Processor;


	public function new(_name:String = 'processor', _priority:Int = 0, _opt_scene:Scene = null, name_unique:Bool = false) {

		name = _name;
		id = clay.utils.Id.uniqueid();

		if(name_unique){
			name += '.$id';
		}

		events = new Events();

		if(_priority != 0){
			priority = _priority;
		}

		if(_opt_scene != null){
			scene = _opt_scene;
		} else {
			// scene = Clay.scene;
		}

	}

	public function destroy() {

		onDestroy();
		events.destroy();

		scene = null;
		events = null;

	}

	public function onDestroy() {}
	public function onUpdate(dt:Float) {}
	public function onRender() {}


	function get_scene() : Scene {

		return _scene;

	}

	function set_scene(otherScene:Scene) : Scene {

		if(otherScene != null){
			otherScene.addProcessor(this);
		} else if(_scene != null) {
			_scene.removeProcessor(this);
		}

		return otherScene;

	}
	
	function set_name(value:String) : String {

		if(_scene != null){
			var _sceneTmp:Scene = _scene;
			_scene.removeProcessor(this);
			name = value;
			_sceneTmp.addProcessor(this);
		} else {
			name = value;
		}
		
		return value;

	}

	function set_priority(value:Int) : Int {

		priority = value;

		if(_scene != null){
			_scene.updateProcessorsPriority();
		}

		return priority;

	}

	function toString() {
		
		return 'Processor: $name / id: $id';

	}
}

typedef ProcessorOptions = {

	@:optional var name : String;
	@:optional var name_unique : Bool;
	@:optional var priority : Int;
	@:optional var view : Array<Class<Dynamic>>;

} //ProcessorOptions
