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

		_entity.entityRemoved.send(_entity);

		unlistenEntitySignals(_entity);

		entities.remove( _entity.name );

	}

	/* get entity from EntityManager */
	public inline function get<T:(Entity)>(_name:String) : T { // todo

		return cast entities.get(_name);

	}

	/* destroy EntityManager */
	@:noCompletion public function destroy() {

		_verbose('destroy EntityManager');
		
		for (e in entities) {
			e.destroy();
		}

		entities = null;
		
	}

	function listenEntitySignals(_entity:Entity) {

		_entity.componentAdded.connect(componentAdded);

	}

	function unlistenEntitySignals(_entity:Entity) {

		_entity.componentAdded.disconnect(componentAdded);

	}


// entity signals

	function componentAdded(_entity:Entity, _component:Dynamic, _componentClass:Class<Dynamic>){

		Clay.views.check(_entity);
	    
	}

	@:noCompletion public inline function iterator():Iterator<Entity> {

		return entities.iterator();

	}


}
