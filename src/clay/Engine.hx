package clay;


class Engine {


	public var scene : Scene;
	
	public var events : Events;


	@:noCompletion public function new() {

		scene = new Scene();
		Clay.scene = scene;

		events = new Events();
		Clay.events = events;

	}

	public function update(dt:Float) : Void {
		
	    Timer.update(dt);

	    scene.update(dt);


	}


}