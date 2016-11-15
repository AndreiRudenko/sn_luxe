## clay
entity component system written in haxe, inspired by many libraries / engines [eskimo](https://github.com/PDeveloper/eskimo), [ash](https://github.com/nadako/Ash-Haxe), [ecx](https://github.com/eliasku/ecx), [luxe](https://github.com/underscorediscovery/luxe).

![clay](clay.png)  

## example
```haxe
package ;

import clay.Entity;
import clay.System;
import clay.Engine;
import clay.View;


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

class SystemA extends System{

	public var entsA:View; // ComponentA
	public var entsB:View; // ComponentB
	public var entsC:View; // ComponentA, ComponentB

	public function new(){

		super();

		entsA = Clay.views.get("entsA");
		entsB = Clay.views.get("entsB");
		entsC = Clay.views.get("entsC");

	}

	override public function update(dt:Float){

		for (entity in entsA.entities) {

			var component:ComponentA = entity.get(ComponentA);
			trace(component.string);

		}

		for (entity in entsB.entities) {

			var component:ComponentB = entity.get(ComponentB);
			trace(component.int);

		}

		for (entity in entsC.entities) {

			var componentA:ComponentA = entity.get(ComponentA);
			var componentB:ComponentB = entity.get(ComponentB);
			trace(componentA.string);
			trace(componentB.int);
		}

	}

}

class Main {

	static function main():Void {

		var engine:Engine = new Engine();

		engine.views.add(new View('entsA', [ComponentA]));
		engine.views.add(new View('entsB', [ComponentB]));
		engine.views.add(new View('entsC', [ComponentA, ComponentB]));

		engine.systems.add(new SystemA());

		var entityA:Entity = new Entity("entityA", null, false);
		var entityB:Entity = new Entity("entityB", null, false);

		var component1:ComponentA = new ComponentA('hello');
		var component2:ComponentB = new ComponentB(16);
		entityA.add(component1);
		entityA.add(component2);

		var component3:ComponentB = new ComponentB(3);
		entityB.add(component3);

		engine.update(1/60);

	}

}

```
