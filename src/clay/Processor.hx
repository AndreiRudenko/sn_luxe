package clay;


import clay.utils.Log.*;


class Processor extends Objects {


	public var active : Bool = true;

	public var entities (default, null): Array<Entity>;

	public var priority (default, set) : Int = 0;
	
	public var scene (get, set) : Scene;

	@:allow(clay.Scene)
	var _scene : Scene;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var prev : Processor;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var next : Processor;

	var view : Array<Class<Dynamic>>;


	public function new( ?_options:ProcessorOptions ) {

		super( 'processor' );

		name += '.$id';

		view = [];
		entities = [];

		if( _options != null ){

			if(_options.name != null){
				name = _options.name;
				if(_options.name_unique == true){
					name += '.$id';
				}
			}

			if(_options.view != null){
				view = _options.view;
			}

			if(_options.priority != null){
				priority = _options.priority;
			}

		}

	}

	public function onInit():Void {}

	public function onDestroy():Void {}

	public function onUpdate(dt:Float) {}

	public function onRender(){}

	public function setView( _view:Array<Class<Dynamic>> ){

		view = _view;
		updateView();

	}

	@:allow(clay.Scene)
	function updateView() : Void {

		entities.splice(0, entities.length);

		if(_scene == null){
			return;
		}

		var sceneEntities:Map<String,Entity> = _scene.entities;

		var match:Bool = true;

		for (entity in sceneEntities) {
			match = true;

			for (componentClass in view) {
				if(!entity.has(componentClass)){
					match = false;
					break;
				}
			}

			if(match){
				entities.push(entity);
			}
		}

	}

	function get_scene() : Scene {

		return _scene;

	}

	function set_scene(otherScene:Scene) : Scene {

		if(_scene != null) {
			_scene.processors.remove( this );
		}

		if(otherScene != null) {
			otherScene.processors.add( this );
		}

		_scene = otherScene;

		updateView();

		return _scene;

	}

	function set_priority(value:Int) : Int {

		priority = value;

		if(_scene != null){
			_scene.updateProcessorsPriority();
		}

		return priority;

	}

	function toString() {
		
		return 'Processor: $name / ${entities.length} entities / id: $id';

	}
}

typedef ProcessorOptions = {

	@:optional var name : String;
	@:optional var name_unique : Bool;
	@:optional var priority : Int;
	@:optional var view : Array<Class<Dynamic>>;

} //ProcessorOptions
