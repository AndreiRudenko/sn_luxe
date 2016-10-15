package clay;


import clay.structural.ClassList;
import clay.signals.Signal3;
import clay.utils.Log.*;


class Entity {
	

	public var id (default, null) : String;
	public var name (get, set) : String;
	var _name : String;

	public var active : Bool = true;

		/** if the entity is in a scene, this is not null */
	public var componentsCount (default, null)  : Int = 0;

	@:allow(clay.View)
	var componentAdded : Signal3<Entity, Dynamic, Class<Dynamic>>;
	@:allow(clay.View)
	var componentRemoved : Signal3<Entity, Dynamic, Class<Dynamic>>;

	var components : ClassList;


	public function new( _entname:String = 'entity', _components:Array<Dynamic> = null, name_unique:Bool = true) {

		_name = _entname;

		id = clay.utils.Id.uniqueid();

		if(name_unique){
			_name += '.$id';
		}

		_verbose('create new entity / ${_name}');

		componentAdded = new Signal3();
		componentRemoved = new Signal3();

		components = new ClassList();

		Clay.entities.add(this);

		if(_components != null){
			addMany(_components);
		}

	}

	/**
	 * destroy this entity. removes it from the scene if any
	 */
	
	public function destroy() {

		_verbose('destroy entity / ${_name}');

		// emit(Ev.entitydestroy, this); // todo

		clear();

		Clay.entities.remove(this);

		components = null;

		componentAdded.destroy();
		componentRemoved.destroy();

		componentAdded = null;
		componentRemoved = null;

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
		_verbose('add component ${_componentClass} / to ${_name}');

		// if component exists remove it
		if(components.exists(_componentClass)){
			remove(_componentClass);
		}

		components.set(_component, _componentClass);

		Clay.views.check(this);

		// emit(Ev.componentadded, {entity : this, component : _component, componentClass : _componentClass}); // maybe?

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

		_verbose('remove component ${_componentClass} / from ${_name}');

		var _component = components.get( _componentClass );

		if(_component != null){


			componentRemoved.send(this, _component, _componentClass);

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

		_verbose('remove all components / from ${_name}');

		var toRemove = null;
		var node = components.classes;
		while (node != null){

			toRemove = node;
			node = node.next;

			componentRemoved.send(this, toRemove.object, toRemove.objectClass);
		
			components.removeNode(toRemove);

			componentsCount--;
		}

	}

	function get_name() : String {
		
		return _name;

	}

	function set_name(value:String) : String {

		_verbose('set name ${value}');

		Clay.entities.remove(this);

		_name = value;

		Clay.entities.add(this);
		
		return value;

	}

	function toString() {
		
		return 'Entity: $name / ${components.length} components:${components} / id: $id';

	}


}


typedef ComponentEvent = {

	var entity : Entity;
	var component : Dynamic;
	var componentClass : Class<Dynamic>;
}

