package clay;


import clay.structural.OrderedMap;


class Scene extends Objects {


	public var active : Bool = true;

	@:allow(clay.Entity)
	public var entities   	(default, null) : Map<String, Entity>;

	@:allow(clay.Processor)
	public var processors 	(default, null) : OrderedMap<String, Processor>;


	public function new( ?_name:String='untitled scene' ) {

		super(_name);

		entities = new Map<String, Entity>();

		var _map = new Map<String, Processor>();
		processors = new OrderedMap(_map);

	}

	public inline function addEntity( _entity:Entity ) : Void {

		_entity._scene = this;
		entities.set( _entity.name, _entity );

		updateProcessorsView();
		
	}

	public inline function removeEntity( _entity:Entity ) : Void {

		_entity._scene = null;
		entities.remove( _entity.name );

		updateProcessorsView();

	}
	
	public inline function getEntity<T:(Entity)>(_name:String) : T {

		return cast entities.get(_name);

	}

	public inline function addProcessor( _processor:Processor ) : Void {

		_processor._scene = this;
		processors.set( _processor.name, _processor );
		_processor.updateView();

	}

	public inline function removeProcessor( _processor:Processor ) : Void {

		_processor._scene = null;
		processors.remove( _processor.name );
		_processor.updateView();

	}
	
	public inline function getProcessor<T:(Processor)>(_name:String) : T {

		return cast processors.get(_name);

	}

	public function update(dt:Float){

		if(!active){
			return;
		}

		for (processor in processors) {
			if(processor.active){
				processor.onUpdate(dt);
			}
		}

	}

	inline public function updateProcessorsView() : Void {

		for (processor in processors) {
			processor.updateView();
		}

	}
	
	function toString() {

		return 'Scene: $name / ${Lambda.count(entities)} entities / ${Lambda.count(processors)} processors / id: $id';

	} //toString

}