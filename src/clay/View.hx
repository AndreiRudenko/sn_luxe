package clay;

// import clay.utils.Log.*;
import clay.Entity;

class View extends Objects {


	public var entities(default, null):Map<String, Entity>;
	public var viewClasses (default, null) : Array<Class<Dynamic>>;

	public var scene (get, set) : Scene;

	@:allow(clay.Scene)
	var _scene : Scene;


	public function new( _name:String, _viewClasses:Array<Class<Dynamic>>, _opt_scene:Scene = null ) {

		entities = new Map();

		super( _name );

		if(_viewClasses != null){
			viewClasses = _viewClasses;
		} else {
			viewClasses = [];
		}

		if(_opt_scene != null){
			scene = _opt_scene;
		} else {
			// scene = Clay.scene;
		}

	}

	public function destroy(){

	    clear();
	    scene = null;
	    entities = null;
	    viewClasses = null;

	}

	public function addViewClass(_viewClass:Class<Dynamic>):Bool{

		if(!hasViewClass(_viewClass)){
			viewClasses.push(_viewClass);
			update();
			return true;
		}

		return false;

	}

	public function hasViewClass(_viewClass:Class<Dynamic>):Bool{

		for (c in viewClasses) {
			if(_viewClass == c){
				return true;
			}
		}
		return false;

	}

	public function removeViewClass(_viewClass:Class<Dynamic>):Bool{

		if(viewClasses.remove(_viewClass)){
			update();
			return true;
		}

		return false;

	}

	public function setViewClasses(_viewClasses:Array<Class<Dynamic>>){

		if(_viewClasses != null){
			viewClasses = _viewClasses;
		} else {
			viewClasses.splice(0, viewClasses.length);
		}

		update();

	}

	@:noCompletion public function onComponentAdded(component:Dynamic, entity:Entity) {}
	@:noCompletion public function onComponentRemoved(component:Dynamic, entity:Entity) {}

	// @:noCompletion public function onEntityInit(entity:Entity) {}
	@:noCompletion public function onEntityAdded(entity:Entity) {}
	@:noCompletion public function onEntityRemoved(entity:Entity) {}
	@:noCompletion public function onEntityDestroy(entity:Entity) {}


	@:allow(clay.Scene)
	function update() {

		if(scene == null){
			clear();
			return;
		}

		// check and clear
		for (e in entities) {
			if(!matchView(e)){
				removeEntity(e);
			}
		}

		// add new
		for (e in scene.entities) {
			if(matchView(e) && !entities.exists(e.name)){
				addEntity(e);
			}
		}

	}

	@:allow(clay.Scene)
	function updateFrom(_entity:Entity) {
		
		if(scene == null){
			return;
		}

		if(!matchView(_entity)){
			removeEntity(_entity);
			return;
		}

		// add new
		if(matchView(_entity) && !entities.exists(_entity.name)){
			addEntity(_entity);
		}

	}

	inline function addEntity(_entity:Entity) {

		listenEnitityEvents(_entity);
		entities.set(_entity.name, _entity);

		onEntityAdded(_entity);

	}

	inline function removeEntity(_entity:Entity) {

		onEntityRemoved(_entity);

		unlistenEnitityEvents(_entity);
		entities.remove(_entity.name);

	}

	inline function matchView(_entity:Entity):Bool {

		var match:Bool = true;

		for (c in viewClasses) {
			if(!_entity.has(c)) {
				match = false;
				break;
			}
		}

		return match;

	}

	function matchComponent(_component:Dynamic):Bool {

		var _componentClass = Type.getClass(_component);
		for (c in viewClasses) {
			if(_componentClass == c){
				return true;
			}
		}

		return false;

	}

	inline function clear() {

		for (e in entities) {
			removeEntity(e);
		}

	}

	function listenEnitityEvents(_entity:Entity) {
		
		_entity.on(Ev.componentAdded,   _componentAdded);
		_entity.on(Ev.componentRemoved, _componentRemoved);
		_entity.on(Ev.entityDestroy,    _onEntityDestroy);

	}

	function unlistenEnitityEvents(_entity:Entity) {

		_entity.off(Ev.componentAdded,   _componentAdded);
		_entity.off(Ev.componentRemoved, _componentRemoved);
		_entity.off(Ev.entityDestroy,    _onEntityDestroy);

	}

	inline function _componentAdded(event:ComponentEvent) {

		if(matchView(event.entity)){
			onComponentAdded(event.component, event.entity);
		}

	}

	inline function _componentRemoved(event:ComponentEvent) {

		onComponentRemoved(event.component, event.entity);

		if(matchComponent(event.component)){
			removeEntity(event.entity);
		}

	}

	inline function _onEntityDestroy(_entity:Entity) {
		
		onEntityRemoved(_entity);
		onEntityDestroy(_entity);

	}

	function get_scene() : Scene {

		return _scene;

	}

	function set_scene(otherScene:Scene) : Scene {

		if(otherScene != null){

			if(otherScene != _scene){
				clear();
			}

			otherScene.addView(this);

		} else if(_scene != null) {

			// clear();
			_scene.removeView(this);

		}

		update();

		return otherScene;

	}

	override function set_name(value:String) : String {

		if(_scene != null){
			var _sceneTmp:Scene = _scene;
			_scene.removeView(this);
			name = value;
			_sceneTmp.addView(this);
		} else {
			name = value;
		}
		
		return value;

	}

	function toString() {

		return 'Scene: $name / ${Lambda.count(entities)} entities / id: $id';

	}

}
