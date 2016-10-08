package clay;


import clay.structural.ProcessorList;


class Scene extends Objects {


	public var active : Bool = true;

	@:allow(clay.Entity)
	public var entities   	(default, null) : Map<String, Entity>;

	@:allow(clay.Processor)
	public var processors 	(default, null) : ProcessorList;


	public function new( ?_name:String='untitled scene' ) {

		super(_name);

		entities = new Map<String, Entity>();

		processors = new ProcessorList();

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

	public inline function addProcessor( _processor:Processor, ?_priority:Int ) : Void {

		if(_priority != null){
			_processor.priority = _priority;
		}

		_processor._scene = this;
		processors.add( _processor );
		_processor.updateView();

	}

	public inline function removeProcessor( _processor:Processor ) : Void {

		_processor._scene = null;
		processors.remove( _processor );
		_processor.updateView();

	}
	
	public inline function getProcessor<T:(Processor)>(_name:String) : T {

		return cast processors.get(_name);

	}

	public function update(dt:Float){

		if(!active){
			return;
		}

		var processor:Processor = processors.head;
		while(processor != null) {
			if(processor.active){
				processor.onUpdate(dt);
			}
			processor = processor.next;
		}

	}

	inline public function updateProcessorsView() : Void {

		var processor:Processor = processors.head;
		while(processor != null) {
			processor.updateView();
			processor = processor.next;
		}

	}

	inline public function updateProcessorsPriority() : Void {

		processors.sort();

	}
	
	function toString() {

		var pcount:Int = 0;
		var processor:Processor = processors.head;
		while(processor != null) {
			pcount++;
			processor = processor.next;
		}

		return 'Scene: $name / ${Lambda.count(entities)} entities / ${pcount} processors / id: $id';

	} //toString

}