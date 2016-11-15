package clay;


import clay.Entity;
import clay.View;
import clay.utils.Log.*;


class ViewManager {


	var views : Map<String, View>;


	public function new() {

		_verbose('creating new ViewManager');

		views = new Map();

	}

	public inline function add( _view:View ) : Void {

		_add(_view);

		// check if entities added before view
		for (e in Clay.entities) {
			_view.check(e);
		}

	}

	public inline function remove( _view:View ) : Void {

		_verbose('remove view ${_view.name}');

		views.remove( _view.name );

	}
	
	public inline function get<T:(View)>(_name:String) : T { // todo

		return cast views.get(_name);

	}
	
	public inline function check(_entity:Entity) {

		_verbose('check entity ${_entity.name}');

		for (v in views) {
			v.check(_entity);
		}

	}
	
	public inline function checkAll() {

		_verbose('check all entities');

		for (e in Clay.entities) {
			check(e);
		}

	}

	public inline function removeEntity(_entity:Entity) {

		_verbose('remove entity ${_entity.name}');

		for (v in views) {
			v._remove(_entity);
		}

	}

	@:allow(clay.View)
	inline function _add( _view:View ) : Void {

		_verbose('add view ${_view.name}');

		var _dView:View = views.get(_view.name);
		if(_dView != null) {
			log('adding a second view named ${_view.name}!
				This will replace the existing one, possibly leaving the previous one in limbo.');
			remove(_dView);
		}

		views.set( _view.name, _view );

	}

	/* destroy ViewManager */
	@:noCompletion public function destroy() {

		_verbose('destroy ViewManager');
		
		for (v in views) {
			v.destroy();
		}

		views = null;
		
	}

	function toString() {

		return 'ViewManager ${Lambda.count(views)} views';

	}

	@:noCompletion public inline function iterator():Iterator<View> {

		return views.iterator();

	}


}
