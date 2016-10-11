package clay;


import clay.structural.ProcessorList;


class Scene extends Objects {


	public var active : Bool = true;

	public var views   	(default, null) : Map<String, View>;

	@:allow(clay.Entity)
	public var entities   	(default, null) : Map<String, Entity>;

	@:allow(clay.Processor)
	public var processors 	(default, null) : ProcessorList;


	public function new( ?_name:String='untitled scene' ) {

		super(_name);

		entities = new Map<String, Entity>();
		views = new Map<String, View>();
		processors = new ProcessorList();

	}


// Entities

	public inline function addEntity( _entity:Entity ) : Void {

		var _prevScene:Scene = _entity._scene;
		if(_prevScene != null){
			_prevScene.removeEntity(_entity);
		}

		var _dEnt:Entity = entities.get(_entity.name);
		if(_dEnt != null) {
			trace('${name} / adding a second entity named ${_entity.name}!
				This will replace the existing one, possibly leaving the previous one in limbo.');
			removeEntity(_dEnt);
		}


		_entity._scene = this;
		entities.set( _entity.name, _entity );

		listenEnitityEvents(_entity);

		if(_entity.componentsCount > 0){
			updateViewsFrom(_entity);
		}
		
	}

	public inline function removeEntity( _entity:Entity ) : Void {

		if(_entity._scene != this){
			trace('${name} / trying to remove entity named ${_entity.name}! But he is on another scene');
			return;
		}

		unlistenEnitityEvents(_entity);

		_entity._scene = null;
		entities.remove( _entity.name );

		updateViewsFrom(_entity);

	}
	
	public inline function getEntity<T:(Entity)>(_name:String) : T { // todo

		return cast entities.get(_name);

	}


// Views

	public inline function addView( _view:View ) : Void {

		var _prevScene:Scene = _view._scene;
		if(_prevScene != null){
			_prevScene.removeView(_view);
		}

		var _dView:View = views.get(_view.name);
		if(_dView != null) {
			trace('${name} / adding a second view named ${_view.name}! 
				This will replace the existing one, possibly leaving the previous one in limbo.');
			removeView(_dView);
		}

		_view._scene = this;
		views.set( _view.name, _view );
		
	}

	public inline function removeView( _view:View ) : Void {

		if(_view._scene != this){
			trace('${name} / trying to remove view named ${_view.name}! But he is on another scene');
			return;
		}

		_view._scene = null;
		views.remove( _view.name );

	}
	
	public inline function getView<T>(_name:String) : T {

		return cast views.get(_name);

	}


// Processors

	public inline function addProcessor( _processor:Processor, ?_priority:Int ) : Void {

		var _prevScene:Scene = _processor._scene;
		if(_prevScene != null){
			_prevScene.removeProcessor(_processor);
		}

		var _dProc = processors.get(_processor.name);
		if(_dProc != null) {
			trace('${name} / adding a second processor named ${_processor.name}! 
				This will replace the existing one, possibly leaving the previous one in limbo.');
			removeProcessor(_dProc);
		}

		if(_priority != null){
			_processor.priority = _priority;
		}

		_processor._scene = this;
		processors.add( _processor );

	}

	public inline function removeProcessor( _processor:Processor ) : Void {

		if(_processor._scene != this){
			trace('${name} / trying to remove processor named ${_processor.name}! But he is on another scene');
			return;
		}

		_processor._scene = null;
		processors.remove( _processor );

	}
	
	public inline function getProcessor<T>(_name:String) : T {

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

	inline public function updateViews() : Void {

		for (v in views) {
			v.update();
		}

	}

	inline public function updateViewsFrom(_entity:Entity) : Void {

		for (v in views) {
			v.updateFrom(_entity);
		}

	}

	inline public function updateProcessorsPriority() : Void {

		processors.sort();

	}

	function listenEnitityEvents(_entity:Entity) {
		
		// _entity.on(Ev.componentAdded, componentAdded);

	}

	function unlistenEnitityEvents(_entity:Entity) {

		// _entity.off(Ev.componentAdded, componentAdded);

	}

	function toString() {

		var pcount:Int = 0;
		var processor:Processor = processors.head;
		while(processor != null) {
			pcount++;
			processor = processor.next;
		}

		return 'Scene: $name / ${Lambda.count(entities)} entities / ${Lambda.count(views)} views / ${pcount} processors / id: $id';

	} //toString

}