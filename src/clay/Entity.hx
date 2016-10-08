package clay;


import clay.structural.ClassList;
import clay.utils.Log.*;


class Entity extends Objects {


	public var active : Bool = true;

		/** if the entity is in a scene, this is not null */
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

	/**
	 * add a component to the entity.
	 * 
	 * @param _component The component object to add.
	 * @param _componentClass The class of the component. This is only necessary if the component
	 * extends another component class and you want the framework to treat the component as of
	 * the base class type. If not set, the class type is determined directly from the component.
	 * 
	 * @return A reference to the entity.
	 */
	
	inline public function add<T>( _component:T , _componentClass:Class<Dynamic> = null) : Entity {

		components.set(_component, _componentClass);

		if(_scene != null){
			_scene.updateProcessorsView();
		}

		emit(Ev.componentAdded, {entity : this, component : _component});

		return this;

	}

	/**
	 * add a array of components to the entity.
	 * 
	 * @param _component Array of components to add.
	 * 
	 * @return A reference to the entity.
	 */
	
	inline public function addMany<T>( _components:Array<T> ) : Entity {

		for (component in _components) {
			components.set(component);
		}

		if(_scene != null){
			_scene.updateProcessorsView();
		}

		for (component in _components) {
			emit(Ev.componentAdded, {entity : this, component : component});
		}

		return this;

	}

	/**
	 * remove a component from the entity.
	 *
	 * @param _componentClass The class of the component to be removed.
	 * @return the component, or null if the component doesn't exist in the entity
	 */
	
	inline public function remove<T>( _componentClass:Class<Dynamic> ) : T {


		var _removedComponent = components.remove( _componentClass );

		emit(Ev.componentRemoved, {entity : this, component : _removedComponent});

		return _removedComponent;
		
	}

	/**
	 * remove a component from the entity.
	 *
	 * @param _componentClasses The array of component classes to be removed.
	 */
	
	inline public function removeMany( _componentClasses:Array<Class<Dynamic>> ) {

		var _removedComponent = null;

		for (componentClass in _componentClasses) {
			_removedComponent = components.remove( componentClass );
			emit(Ev.componentRemoved, {entity : this, component : _removedComponent});
		}
		
	}

	/**
	 * get a component from the entity.
	 *
	 * @param _componentClass The class of the component requested.
	 * @return The component, or null if none was found.
	 */
	
	inline public function get<T>( _componentClass:Class<Dynamic> ) : T {

		return components.get( _componentClass );

	}
	
	/**
	 * get a component from the entity.
	 *
	 * @param _componentClass The class of the component requested.
	 * @return The component, or null if none was found.
	 */
	
	inline public function has<T>( _componentClass:Class<T> ) : Bool {

		return components.exists( _componentClass );

	}

	/**
	 * remove all components from the entity
	 */
	
	inline public function clear() {

		var node = components.classes;

		while (node != null){
			emit(Ev.componentRemoved, {entity : this, component : node.object});
			node = node.next;
		}

		components.clear();

	}

	/**
	 * destroy this entity. removes it from the scene if any
	 */
	
	public function destroy() {

		emit(Ev.destroy, this);

		clear();

		if(_scene != null){
			_scene.removeEntity(this);
		}
		
		_scene = null;
		components = null;

		_emitter_destroy();

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
