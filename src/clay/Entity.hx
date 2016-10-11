package clay;


import clay.structural.ClassList;
import clay.utils.Log.*;

class Entity extends Objects {


	public var active : Bool = true;

		/** if the entity is in a scene, this is not null */
	public var scene (get, set) : Scene;
	public var componentsCount (default, null)  : Int = 0;

	@:allow(clay.Scene)
	var _scene : Scene;

	var components : ClassList;


	public function new( _name:String = 'entity', _components:Array<Dynamic> = null, _opt_scene:Scene = null, name_unique:Bool = true) {

		super( _name );

		if(name_unique){
			name += '.$id';
		}

		components = new ClassList();

		if(_components != null){
			addMany(_components);
		}

		if(_opt_scene != null){
			scene = _opt_scene;
		} else {
			scene = Clay.scene;
		}

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
	
	public inline function add<T>( _component:T, _componentClass:Class<Dynamic> = null) : Entity {

		if(_componentClass == null){
			_componentClass = Type.getClass(_component);
		}

		// if component exists remove it
		if(components.exists(_componentClass)){
			remove(_componentClass);
		}

		components.set(_component, _componentClass);

		if(_scene != null){
			_scene.updateViewsFrom(this);
		}

		emit(Ev.componentAdded, {entity : this, component : _component});

		componentsCount++;
		
		return this;

	}

	/**
	 * add a array of components to the entity.
	 * 
	 * @param _components Array of components to add.
	 * 
	 * @return A reference to the entity.
	 */
	
	public inline function addMany<T>( _components:Array<T> ) : Entity {

		for (component in _components) {
			add(component);
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

		var _component = components.get( _componentClass );

		if(_component != null){

			emit(Ev.componentRemoved, {entity : this, component : _component});

			components.remove( _componentClass );

			componentsCount--;
		}

		return _component;
		
	}

	/**
	 * remove a component from the entity.
	 *
	 * @param _componentClasses The array of component classes to be removed.
	 */
	
	inline public function removeMany( _componentClasses:Array<Class<Dynamic>> ) {

		for (componentClass in _componentClasses) {
			remove(componentClass);
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


		var toRemove = null;
		var node = components.classes;
		while (node != null){

			toRemove = node;
			node = node.next;

			emit(Ev.componentRemoved, {entity : this, component : toRemove.object});
		
			components.removeNode(toRemove);

			componentsCount--;
		}

	}

	/**
	 * destroy this entity. removes it from the scene if any
	 */
	
	public function destroy() {

		emit(Ev.entityDestroy, this);

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
		
		if(otherScene != null){
			otherScene.addEntity(this);
		} else if(_scene != null) {
			_scene.removeEntity(this);
		}

		return otherScene;

	}

	override function set_name(value:String) : String {

		if(_scene != null){
			var _sceneTmp:Scene = _scene;
			_scene.removeEntity(this);
			name = value;
			_sceneTmp.addEntity(this);
		} else {
			name = value;
		}
		
		return value;

	}

	function toString() {
		
		return 'Entity: $name / ${components.length} components:${components} / id: $id';

	}


}


typedef ComponentEvent = {

	var entity : Entity;
	var component : Dynamic;
}


typedef EntityOptions = {

	@:optional var name : String;
	@:optional var scene : Scene;
	@:optional var no_scene : Bool;
	@:optional var name_unique : Bool;
	@:optional var components : Array<Dynamic>;

} //EntityOptions
