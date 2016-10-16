package clay;


import clay.structural.ClassList;
import clay.signals.Signal3;
import clay.signals.Signal1;
import clay.utils.Log.*;


class Entity {
	

	public var active : Bool = true;

	public var id (default, null) : String;
	public var name (get, set) : String;
	public var componentsCount (default, null)  : Int = 0;
	public var components (get, null): Iterator<Dynamic>;

	var _name : String;
	var _components : ClassList;

	// signals
	@:allow(clay.View)
	@:allow(clay.EntityManager)
	var componentAdded : Signal3<Entity, Dynamic, Class<Dynamic>>;

	@:allow(clay.View)
	@:allow(clay.EntityManager)
	var componentRemoved : Signal3<Entity, Dynamic, Class<Dynamic>>;

	@:allow(clay.EntityManager)
	var entityDestroyed : Signal1<Entity>;


	public function new( _entname:String = 'entity', _aComponents:Array<Dynamic> = null, name_unique:Bool = true) {

		_name = _entname;

		id = clay.utils.Id.uniqueid();

		if(name_unique){
			_name += '.$id';
		}

		_verbose('create new entity / ${_name}');

		componentAdded = new Signal3();
		componentRemoved = new Signal3();
		entityDestroyed = new Signal1();

		_components = new ClassList();

		Clay.entities.add(this);

		if(_aComponents != null){
			addMany(_aComponents);
		}

	}

	/**
	 * destroy this entity. removes it from the scene if any
	 */
	
	public function destroy() {

		_verbose('destroy entity / ${_name}');

		entityDestroyed.send(this);

		clear();

		Clay.entities.remove(this);

		_components = null;

		entityDestroyed.destroy();
		componentAdded.destroy();
		componentRemoved.destroy();

		entityDestroyed = null;
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
		if(_components.exists(_componentClass)){
			remove(_componentClass);
		}

		_components.add(_component, _componentClass);

		componentAdded.send(this, _component, _componentClass);

		componentsCount++;
		
		return this;

	}

	/**
	 * add a array of _components to the entity.
	 * 
	 * @param _components Array of _components to add.
	 * 
	 * @return A reference to the entity.
	 */
	
	public inline function addMany<T>( _aComponents:Array<T> ) : Entity {

		for (component in _aComponents) {
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

		var _component = _components.get( _componentClass );

		if(_component != null){


			componentRemoved.send(this, _component, _componentClass);

			_components.remove( _componentClass );

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

		return _components.get( _componentClass );

	}
	
	/**
	 * get a component from the entity.
	 *
	 * @param _componentClass The class of the component requested.
	 * @return The component, or null if none was found.
	 */
	
	inline public function has<T>( _componentClass:Class<T> ) : Bool {

		return _components.exists( _componentClass );

	}

	/**
	 * remove all _components from the entity
	 */
	
	inline public function clear() {

		_verbose('remove all _components / from ${_name}');

		var toRemove = null;
		var node = _components.head;
		while (node != null){

			toRemove = node;
			node = node.next;

			componentRemoved.send(this, toRemove.object, toRemove.objectClass);
		
			_components.removeNode(toRemove);

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

	function get_components():Iterator<Dynamic> {

		return _components.iterator();

	}

	function toString() {
		
		return 'Entity: $name / ${_components.length} _components:${_components} / id: $id';

	}


}
