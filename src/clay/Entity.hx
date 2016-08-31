package clay;


import clay.structural.ClassList;
import clay.utils.Log.*;


class Entity extends Objects {


	public var active : Bool = true;

	public var scene (get, set) : Scene;

	@:allow(clay.Scene)
	var _scene : Scene;

	var components : ClassList;


	public function new( ?_options:EntityOptions ) {

		super( 'entity' );

		name += '.$id';

		components = new ClassList();

		if(_options != null){
			
			if(_options.name != null){
        		name = _options.name;
				if(_options.name_unique == true){
					name += '.$id';
				}
			}
			
			if(_options.components != null){
				var _components:Array<Dynamic> = _options.components;
				for (component in _components) {
					add(component);
				}
			}

			if(_options.scene != null){
				_scene = _options.scene;
			} else {
				_scene = Clay.scene;
			}


		} else {

			_scene = Clay.scene;

		}

		_scene.addEntity(this);

	}

	inline public function add<T>( _component:T , _componentClass:Class<Dynamic> = null) : T {

		if(_scene != null){
			_scene.updateProcessorsView();
		}

		return components.set(_component, _componentClass);

	}

	inline public function remove<T>( componentClass:Class<T> ) : Bool {
		
		if(_scene != null){
			_scene.updateProcessorsView();
		}

		return components.remove(componentClass);
		
	}

	inline public function get<T>( componentClass:Class<T> ) : T {

		return components.get(componentClass);

	}

	inline public function has<T>( componentClass:Class<T> ) : Bool {

		return components.exists(componentClass);

	}

	inline public function clear() {

		components.clear();

	}

	public function destroy() {

		clear();

		if(_scene != null){
			_scene.removeEntity(this);
		}

		_scene = null;
		components = null;

	}


	function get_scene() : Scene {

		return _scene;

	}

	function set_scene(otherScene:Scene) : Scene {

		if(_scene != null) {
			_scene.entities.remove( name );
			_scene.updateProcessorsView();
		}

		if(otherScene != null) {
			otherScene.entities.set( name, this );
			otherScene.updateProcessorsView();
		}

		_scene = otherScene;

		return _scene;

	}

	override function set_name(value:String) : String {

		if(_scene != null){
			_scene.entities.remove( name );
			name = value;
			_scene.entities.set( name, this );
		} else {
			name = value;
		}
		
		return value;

	}


	function toString() {
		
		return 'Entity: $name / ${components.length} components:${components} / id: $id';

	}


}


typedef EntityOptions = {

	@:optional var name : String;
	@:optional var scene : Scene;
	@:optional var name_unique : Bool;
	@:optional var components : Array<Dynamic>;

} //EntityOptions
