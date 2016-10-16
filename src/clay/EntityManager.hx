package clay;


import clay.Entity;
import clay.utils.Log.*;


class EntityManager {


	var entities : Map<String, Entity>;


	public function new() {

		_verbose('create new EntityManager');

		entities = new Map();

	}

	/* add entity to EntityManager */
	public inline function add( _entity:Entity ) : Void {

		_verbose('add entity ${_entity.name}');

		var _dEnt:Entity = entities.get(_entity.name);
		if(_dEnt != null) {
			log('adding a second entity named ${_entity.name}!
				This will replace the existing one, possibly leaving the previous one in limbo.');
			remove(_dEnt);
		}

		entities.set( _entity.name, _entity );

		listenEntitySignals(_entity);

		if(_entity.componentsCount > 0){
			Clay.views.check(_entity);
		}
		
	}

	/* remove entity from EntityManager */
	public inline function remove( _entity:Entity ) : Void {

		_verbose('remove entity ${_entity.name}');

		unlistenEntitySignals(_entity);

		entities.remove( _entity.name );

		Clay.views.removeEntity(_entity);

	}

	/* get entity from EntityManager */
	public inline function get<T:(Entity)>(_name:String) : T { // todo

		return cast entities.get(_name);

	}

	function listenEntitySignals(_entity:Entity) {

		_entity.componentAdded.connect(componentAdded);
		_entity.entityDestroyed.connect(entityDestroyed);

	}

	function unlistenEntitySignals(_entity:Entity) {

		_entity.componentAdded.disconnect(componentAdded);
		_entity.entityDestroyed.disconnect(entityDestroyed);

	}


// entity signals

	function componentAdded(_entity:Entity, _component:Dynamic, _componentClass:Class<Dynamic>){

		Clay.views.check(_entity);
	    
	}

	function entityDestroyed(_entity:Entity){
	    
	}

	@:noCompletion public inline function iterator():Iterator<Entity> {

		return entities.iterator();

	}


}
