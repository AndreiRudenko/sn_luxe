package clay;


import clay.Entity;
import clay.View;


class ViewManager {


	var views : Map<String, View>;


	public function new() {

		views = new Map();

	}

	public inline function add( _view:View ) : Void {

		var _dView:View = views.get(_view.name);
		if(_dView != null) {
			trace('ViewManager adding a second view named ${_view.name}!
				This will replace the existing one, possibly leaving the previous one in limbo.');
			remove(_dView);
		}

		views.set( _view.name, _view );
		
	}

	public inline function remove( _view:View ) : Void {

		views.remove( _view.name );

	}
	
	public inline function get<T:(View)>(_name:String) : T { // todo

		return cast views.get(_name);

	}
	
	public inline function check(_entity:Entity) {

		for (v in views) {
			v.check(_entity);
		}

	}

	public inline function removeEntity(_entity:Entity) {

		for (v in views) {
			v.removeEntity(_entity);
		}

	}

	function toString() {

		return 'ViewManager ${Lambda.count(views)} views';

	}

	@:noCompletion public inline function iterator():Iterator<View> {

		return views.iterator();

	}


}
