package clay;

import clay.Emitter;
import clay.Events;
import clay.SystemManager;
import clay.EntityManager;
import clay.ViewManager;


@:keep
@:noCompletion
@:log_as('clay')
class Engine {


	public var emitter : Emitter<clay.Ev>;
	public var events : Events;
	public var entities : EntityManager;
	public var systems : SystemManager;
	public var views : ViewManager;


	@:noCompletion public function new() {

		Clay.engine = this;

		emitter = new Emitter<clay.Ev>();

		events = new Events();
		Clay.events = events;

		entities = new EntityManager();
		Clay.entities = entities;

		systems = new SystemManager();
		Clay.systems = systems;

		views = new ViewManager();
		Clay.views = views;

	}

	public function update(dt:Float) : Void {

		systems.emit(clay.Ev.update, dt);
		emit(clay.Ev.update, dt);

	}

	public function render() : Void {

		systems.emit(clay.Ev.render);
		emit(clay.Ev.render);

	}

	public inline function on<T>(event:clay.Ev, handler:T->Void ) {
		emitter.on(event, handler);
	}

	public inline function off<T>(event:clay.Ev, handler:T->Void ) {
		return emitter.off(event, handler);
	}

	public inline function emit<T>(event:clay.Ev, ?data:T ) {
		return emitter.emit(event, data);
	}


}