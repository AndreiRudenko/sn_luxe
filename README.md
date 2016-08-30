## clay
Entity component system written in haxe, inspired by many libraries / engines [eskimo](https://github.com/PDeveloper/eskimo), [ash](https://github.com/nadako/Ash-Haxe), [tusk](https://github.com/BlazingMammothGames/tusk), [luxe](https://github.com/underscorediscovery/luxe).


## example
```haxe
package ;

import clay.Entity;
import clay.Processor;
import clay.Engine;


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

	public function new(){
		super({ view : [ComponentA] });
	}

	override public function onUpdate(dt:Float){
		for (entity in entities) {
			if(!entity.active){
				continue;
			}

			var component:TestComponent = entity.get(TestComponent);
			trace('entity: ${entity.name} process: ${component}');
		}
	}

}

class Main {

	static function main():Void {

		var engine:Engine = new Engine();

		var entity1:Entity = new Entity();
		var entity2:Entity = new Entity();

		var component1:ComponentA = new ComponentA('hello');
		var component2:ComponentB = new ComponentB(16);
		entity1.add(component1);
		entity1.add(component2);

		var component3:ComponentB = new ComponentB(3);
		entity2.add(component3);

		var processor:ProcessorA = new ProcessorA();
		engine.scene.addProcessor(processor);
		
		engine.update(1/60);

	}

}
```
