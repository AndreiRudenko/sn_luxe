package clay;


class Engine {


	public var scene : Scene;


	@:noCompletion public function new() {

		scene = new Scene();
		Clay.scene = scene;

	}

	public function update(dt:Float) : Void {

	    scene.update(dt);

	}


}