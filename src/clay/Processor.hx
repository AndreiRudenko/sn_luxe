package clay;


import clay.Objects;
import clay.utils.Log.*;
import clay.events.RemoveComponentEvent;
import clay.events.AddComponentEvent;


class Processor extends ID {


	public var active : Bool = true;

	public var events (default, null): Events;

	public var entities (default, null): Array<Entity>;

	public var priority (default, set) : Int = 0;
	
	public var scene (get, set) : Scene;

	@:allow(clay.Scene)
	var _scene : Scene;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var prev : Processor;

	@:allow(clay.Scene)
	@:allow(clay.structural.ProcessorList)
	var next : Processor;

	var view : Array<Class<Dynamic>>;


	public function new(?_options:ProcessorOptions) {

		super( 'processor' );

		name += '.$id';

		events = new Events();

		view = [];
		entities = [];

		if( _options != null ){

			if(_options.name != null){
				name = _options.name;
				if(_options.name_unique == true){
					name += '.$id';
				}
			}

			if(_options.view != null){
				view = _options.view;
			}

			if(_options.priority != null){
				priority = _options.priority;
			}

		}

	}

	public function destroy() {

		onDestroy();

		if(_scene != null) {
			_scene.processors.remove( this );
			_scene = null;
		}

		for (e in entities) {
			_disconnectEntityEvents(e);
		}

		entities = null;
		view = null;

		events.destroy();
		events = null;

	}

	public function onInit():Void {}

	public function onDestroy():Void {}

	public function onUpdate(dt:Float) {}

	public function onRender() {}

	public function onComponentAdded(component:Dynamic) {

		trace('onComponentAdded: ${Type.getClass(component)}');

	}

	public function onComponentRemoved(component:Dynamic) {

		trace('onComponentRemoved: ${Type.getClass(component)}');

	}

	public function onEntityAdded(entity:Entity) {
		// trace('entity: ${entity.name} added, from processor: ${name}');
	}

	public function onEntityRemoved(entity:Entity) {
		// trace('entity: ${entity.name} removed, from processor: ${name}');
	}

	public function onEntityInit(entity:Entity) {
		// trace('entity: ${entity.name} init, from processor: ${name}');
	}

	public function onEntityDestroy(entity:Entity) {
		// trace('entity: ${entity.name} destroy, from processor: ${name}');
	}


	public function setView(_view:Array<Class<Dynamic>>) {

		view = _view;
		updateView();

	}

	@:allow(clay.Scene)
	function updateView() : Void {

		// disconnect events
		for (e in entities) {
			_disconnectEntityEvents(e);
		}

		entities.splice(0, entities.length);

		if(_scene == null) {
			return;
		}

		var sceneEntities:Map<String,Entity> = _scene.entities;

		var match:Bool = true;

		for (entity in sceneEntities) {
			match = true;

			for (componentClass in view) {
				if(!entity.has(componentClass)) {
					match = false;
					break;
				}
			}

			if(match) {
				_connectEntityEvents(entity);
				entities.push(entity);
			}
		}

		// trace('processor: ${name} updateView, entities: ${entities.length}');

	}

	inline function _connectEntityEvents(entity:Entity) {

		entity.on(Ev.init, onEntityInit);
		entity.on(Ev.destroy, onEntityDestroy);
		entity.on(Ev.componentAdded, _componentAdded);
		entity.on(Ev.componentRemoved, _componentRemoved);

	}

	inline function _disconnectEntityEvents(entity:Entity) {

		entity.off(Ev.init, onEntityInit);
		entity.off(Ev.destroy, onEntityDestroy);
		entity.off(Ev.componentAdded, _componentAdded);
		entity.off(Ev.componentRemoved, _componentRemoved);

	}

	function _componentRemoved(event:RemoveComponentEvent) {

		var componentClass:Class<Dynamic> = Type.getClass(event.component);
		var _remove:Bool = false;

		for (viewClass in view) {
			if(viewClass == componentClass){
				_remove = true;
				// trace('processor: ${name} has: ${componentClass} component');
				break;
			}
		}

		if(!_remove){
			return;
		}
		
		var entity:Entity = event.entity;
		var component:Dynamic = event.component;

		trace('entity: ${entity.name} removed from processor: ${name}');

		onComponentRemoved(component);

		_disconnectEntityEvents(entity);
		entities.remove(entity);

	}

	function _componentAdded(event:AddComponentEvent) {

		var componentClass:Class<Dynamic> = Type.getClass(event.component);

		for (viewClass in view) {
			if(viewClass == componentClass){
				onComponentAdded(event.component);
				return;
			}
		}


	}

	function get_scene() : Scene {

		return _scene;

	}

	function set_scene(otherScene:Scene) : Scene {

		if(_scene != null) {
			_scene.processors.remove( this );
		}

		if(otherScene != null) {
			otherScene.processors.add( this );
		}

		_scene = otherScene;

		updateView();

		return _scene;

	}

	function set_priority(value:Int) : Int {

		priority = value;

		if(_scene != null){
			_scene.updateProcessorsPriority();
		}

		return priority;

	}

	function toString() {
		
		return 'Processor: $name / ${entities.length} entities / id: $id';

	}
}

typedef ProcessorOptions = {

	@:optional var name : String;
	@:optional var name_unique : Bool;
	@:optional var priority : Int;
	@:optional var view : Array<Class<Dynamic>>;

} //ProcessorOptions
