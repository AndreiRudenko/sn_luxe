package clay;


import clay.utils.Log.*;


class Processor extends Objects {


	public var active : Bool = true;

	public var scene (get, set) : Scene;

	@:allow(clay.Scene)
	var _scene : Scene;

	var view : Array<Class<Dynamic>>;
	var entities : Array<Entity>;


	public function new( ?_options:ProcessorOptions ) {

		if( _options != null ){

			super( def(_options.name, 'processor') );

			if(_options.name_unique == true){
				name += '.$id';
			}

			view = def(_options.view, []);
			
		} else {

			super( 'processor' );

			view = [];

			name += '.$id';
		}

		entities = [];

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
			_scene.processors.remove( name );
		}

		if(otherScene != null) {
			otherScene.processors.set( name, this );
		}

		_scene = otherScene;

		updateView();

		return _scene;

	}

	override function set_name(value:String) : String {

		if(_scene != null){
			_scene.processors.remove( name );
			name = value;
			_scene.processors.set( name, this );
		} else {
			name = value;
		}
		
		return value;

	}

	function toString() {
		
		return 'Processor: $name / ${entities.length} entities / id: $id';

	}
}

typedef ProcessorOptions = {

	@:optional var name : String;
	// @:optional var scene : Scene;
	@:optional var name_unique : Bool;
	@:optional var view : Array<Class<Dynamic>>;

} //ProcessorOptions
