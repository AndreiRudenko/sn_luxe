## clay
entity component system written in haxe, inspired by many libraries / engines [eskimo](https://github.com/PDeveloper/eskimo), [ash](https://github.com/nadako/Ash-Haxe), [tusk](https://github.com/BlazingMammothGames/tusk), [luxe](https://github.com/underscorediscovery/luxe).


## example
```haxe
package ;

import clay.Entity;
import clay.Processor;
import clay.Engine;
import clay.View;
import clay.Scene;


class ComponentA {

	public var string : String;

	public function new( _string:String ) : Void {
		string = _string;
	}

}

class ComponentB {

	public var int : Int;

	public function new( _int:Int ) : Void {
		int = _int;
	}

}

class ProcessorA extends Processor{

	public var entsA:View; // ComponentA
	public var entsB:View; // ComponentB
	public var entsC:View; // ComponentA, ComponentB

	public function new(){

		super("ProcessorA");

		entsA = Clay.scene.getView("entsA");
		entsB = Clay.scene.getView("entsB");
		entsC = Clay.scene.getView("entsC");

	}

	override public function onUpdate(dt:Float){

		for (entity in entsA.entities) {

			var component:ComponentA = entity.get(ComponentA);
			trace('processor ${name} entity: ${entity.name} process: ${component}');

			for (entity in entsB.entities) {

				var component:ComponentB = entity.get(ComponentB);
				trace('processor ${name} entity: ${entity.name} process: ${component}');

			}
		}

		for (entity in entsB.entities) {

			var componentA:ComponentA = entity.get(ComponentA);
			var componentB:ComponentB = entity.get(ComponentB);
			trace('processor ${name} entity: ${entity.name} process: ${componentA}');
			trace('processor ${name} entity: ${entity.name} process: ${componentB}');

		}

	}

}

class Main {

	static function main():Void {

		var engine:Engine = new Engine();

		engine.scene.addView(new View('entsA', [ComponentA]));
		engine.scene.addView(new View('entsB', [ComponentB]));
		engine.scene.addView(new View('entsC', [ComponentA, ComponentB]));

		engine.scene.addProcessor(new ProcessorA());

		var entity1:Entity = new Entity();
		var entity2:Entity = new Entity();

		var component1:ComponentA = new ComponentA('hello');
		var component2:ComponentB = new ComponentB(16);
		entity1.add(component1);
		entity1.add(component2);

		var component3:ComponentB = new ComponentB(3);
		entity1.add(component3);

		engine.update(1/60);

	}

}
```
