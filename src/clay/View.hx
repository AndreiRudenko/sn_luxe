package clay;


import clay.Entity;
import clay.utils.Log.*;


class View {


	public var name(get, set): String;
	var _name : String;
	public var entities(default, null):Map<String, Entity>;
	public var viewClasses (default, null) : ViewClasses;

	public var onAdded:Entity->Void;
	public var onRemoved:Entity->Void;


	public function new( _viewName:String, _viewClasses:Array<Class<Dynamic>> ) {

		_verbose('creating new view / ${_viewName}');

		_name = _viewName;

		entities = new Map();
		viewClasses = new ViewClasses(this, _viewClasses);

	}

	public function destroy(){

		_verbose('${_name} / destroy');

		clear();

		Clay.engine.views.remove(this);

		entities = null;
		viewClasses = null;
		
	}

	public function check(_entity:Entity) {

		_verbose('${_name} / check entity ${_entity.name}');

		if(entities.exists(_entity.name) && !viewClasses.matchEntity(_entity)){
			removeEntity(_entity);
			return;
		}

		// add new
		if(!entities.exists(_entity.name) && viewClasses.matchEntity(_entity)){
			addEntity(_entity);
		}

	}

	@:allow(clay.ViewClasses)
	inline function update() {

		_verbose('${_name} / check all entities');

		// check and clear
		for (e in entities) {
			if(entities.exists(e.name) && !viewClasses.matchEntity(e)){
				removeEntity(e);
			}
		}

		// check and add from engine
		for (e in Clay.entities) {
			if(!entities.exists(e.name) && viewClasses.matchEntity(e)){
				addEntity(e);
			}
		}

	}

	@:allow(clay.ViewManager)
	inline function addEntity(_entity:Entity) {

		_verbose('${_name} / add entity ${_entity.name}');

		entities.set(_entity.name, _entity);

		listenEnitityEvents(_entity);

		if(onAdded != null){
			onAdded(_entity);
		}

	}

	@:allow(clay.ViewManager)
	inline function removeEntity(_entity:Entity) {

		_verbose('${_name} / remove entity');

		if(onRemoved != null){
			onRemoved(_entity);
		}

		unlistenEnitityEvents(_entity);

		entities.remove(_entity.name);

	}

	inline function clear() {

		_verbose('${_name} / remove all entities');

		for (e in entities) {
			removeEntity(e);
		}

	}

	function listenEnitityEvents(_entity:Entity) {

		_verbose('${_name} / listen entity events ${_entity.name}');

		_entity.componentRemoved.connect(_componentRemoved);

	}

	function unlistenEnitityEvents(_entity:Entity) {

		_verbose('${_name} / unlisten entity events ${_entity.name}');

		_entity.componentRemoved.disconnect(_componentRemoved);

	}

	function _componentRemoved(_entity:Entity, _component:Dynamic, _componentClass:Class<Dynamic>) {

		if(viewClasses.matchClass(_componentClass)){

			_verbose('${_name} / on component removed ${_componentClass}');

			removeEntity(_entity);
		}

	}

	function get_name() : String {
		
		return _name;

	}

	function set_name(value:String) : String {

		_verbose('${_name} / set name to ${value}');

		Clay.engine.views.remove(this);
		_name = value;
		Clay.engine.views.add(this);
		
		return value;

	}

	function toString() {

		return 'View: $name / ${Lambda.count(entities)} entities / viewClasses: $viewClasses';

	}


}


class ViewClasses {


	var classes : Array<Class<Dynamic>>;
	var view : View;


	public function new(_view:View, _viewClasses:Array<Class<Dynamic>>){
		_verbose('create new ViewClasses ${_viewClasses}');

		view = _view;

		if(_viewClasses != null){
			classes = _viewClasses;
		} else {
			classes = [];
		}

	}

	public function destroy(){

		_verbose('destroy');

	    classes = null;
	    view = null;

	}

	public function add(_viewClass:Class<Dynamic>):Bool{

		_verbose('add ${_viewClass}');

		if(!has(_viewClass)){
			classes.push(_viewClass);
			view.update();
			return true;
		}

		return false;

	}

	public function has(_viewClass:Class<Dynamic>):Bool{

		for (c in classes) {
			if(_viewClass == c){
				return true;
			}
		}
		return false;

	}

	public function remove(_viewClass:Class<Dynamic>):Bool{

		_verbose('remove ${_viewClass}');

		if(classes.remove(_viewClass)){
			view.update();
			return true;
		}

		return false;

	}

	public function set(_viewClasses:Array<Class<Dynamic>>){

		_verbose('set ${_viewClasses}');

		if(_viewClasses != null){
			classes = _viewClasses;
		} else {
			classes.splice(0, classes.length);
		}

		view.update();

	}

	public function matchEntity(_entity:Entity):Bool{

		_verbose('matchEntity ${_entity.name}');

		for (c in classes) {
			if(!_entity.has(c)) {
				return false;
			}
		}

		return true;

	}

	public function matchComponent(_component:Dynamic):Bool {

		_verbose('matchEntity ${Type.getClassName(Type.getClass(_component))}');

		var _componentClass = Type.getClass(_component);
		for (c in classes) {
			if(_componentClass == c){
				return true;
			}
		}

		return false;

	}

	public function matchClass(_componentClass:Class<Dynamic>):Bool {

		_verbose('matchEntity ${Type.getClassName(_componentClass)}');

		for (c in classes) {
			if(_componentClass == c){
				return true;
			}
		}

		return false;

	}

	@:noCompletion public inline function iterator():Iterator<Class<Dynamic>> {

		return classes.iterator();

	}


}
