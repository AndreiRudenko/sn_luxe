package clay.events;

import clay.Entity;

class AddComponentEvent extends Event {


	public var entity:Entity;
	public var component:Dynamic;


	public function new(_entity:Entity, _component:Dynamic){
		super();

		entity = _entity;
		component = _component;

	}
	
	
}
