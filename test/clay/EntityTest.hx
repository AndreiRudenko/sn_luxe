package clay;


import massive.munit.Assert;

import clay.Entity;
import clay.Engine;
import clay.Scene;
import clay.Mockups;


// @:access(clay.Entity)
class EntityTest {


	var engine:Engine;


	@Before
	public function createEngine():Void {

		engine = new Engine();

	}

	@After
	public function clearEngine():Void {

		engine = null;

	}

	@Test
	public function canStoreAndRetrieveComponent():Void {

		var entity:Entity = new Entity();
		var component:MockComponent = new MockComponent();
		entity.add(component);
		Assert.isTrue(entity.get(MockComponent) == component); 

	}
	@Test
	public function canStoreAndRetrieveMultipleComponents():Void {

		var entity:Entity = new Entity();
		var component1:MockComponent = new MockComponent();
		entity.add(component1);
		var component2:MockComponent2 = new MockComponent2();
		entity.add(component2);
		Assert.isTrue(entity.get(MockComponent) == component1); 
		Assert.isTrue(entity.get(MockComponent2) == component2); 

	}

	@Test
	public function canCreateWithMultipleComponents():Void {

		var entity:Entity = new Entity('testEntity', [new MockComponent(), new MockComponent2()]);

		Assert.isTrue(entity.has(MockComponent)); 
		Assert.isTrue(entity.has(MockComponent2)); 

	}

	@Test
	public function canReplaceComponent():Void {

		var entity:Entity = new Entity();
		var component1:MockComponent = new MockComponent();
		entity.add(component1);
		var component2:MockComponent = new MockComponent();
		entity.add(component2);
		Assert.isTrue(entity.get(MockComponent) == component2); 

	}

	@Test
	public function canStoreBaseAndExtendedComponents():Void {

		var entity:Entity = new Entity();
		var component1:MockComponent = new MockComponent();
		entity.add(component1);
		var component2:MockComponentExtended = new MockComponentExtended();
		entity.add(component2);
		Assert.isTrue(entity.get(MockComponent) == component1); 
		Assert.isTrue(entity.get(MockComponentExtended) == component2); 

	}

	@Test
	public function canStoreExtendedComponentAsBaseType():Void {

		var entity:Entity = new Entity();
		var component:MockComponentExtended = new MockComponentExtended();
		entity.add(component, MockComponent);
		Assert.isTrue(entity.get(MockComponent) == component);

	}

	@Test
	public function getReturnNullIfNoComponent():Void {

		var entity:Entity = new Entity();
		Assert.isTrue(entity.get(MockComponent) == null);
		
	}

	@Test
	public function hasComponentIsFalseIfComponentTypeNotPresent():Void {

		var entity:Entity = new Entity();
		entity.add(new MockComponent2());
		Assert.isFalse(entity.has(MockComponent));
		
	}

	@Test
	public function hasComponentIsTrueIfComponentTypeIsPresent():Void {

		var entity:Entity = new Entity();
		entity.add(new MockComponent());
		Assert.isTrue(entity.has(MockComponent));
		
	}

	@Test
	public function canRemoveComponent():Void {

		var entity:Entity = new Entity();
		var component:MockComponent = new MockComponent();
		entity.add(component);
		entity.remove(MockComponent);
		Assert.isFalse(entity.has(MockComponent));
		
	}

	@Test
	public function testEntityHasNameByDefault():Void {

		var entity:Entity = new Entity();
		Assert.isTrue(entity.name.length > 0);

	}

	@Test
	public function testEntityNameStoredAndReturned():Void {

		var name:String = "anything";
		var entity:Entity = new Entity(name, null, null, false);
		Assert.isTrue(entity.name == "anything");

	}

	@Test
	public function testEntityNameUnique():Void {

		var name:String = "anything";
		var entity:Entity = new Entity(name, null, null, true );
		Assert.isTrue(entity.name == 'anything.${entity.id}');

	}

	@Test
	public function testEntityNameCanBeChanged():Void {
		
		var entity:Entity = new Entity("anything");
		entity.name = "otherThing";
		Assert.isTrue(entity.name == "otherThing");

	}


	@Test
	public function testEntitySetAndReturnScene():Void {

		var scene:Scene = new Scene("scene1");

		var entity:Entity = new Entity( "entity", null, scene );
		Assert.isTrue(entity.scene == scene);
		Assert.isTrue(scene.getEntity(entity.name) == entity);

	}

	@Test
	public function testEntitySetSceneToNull():Void {

		var scene:Scene = new Scene("scene1");

		var entity:Entity = new Entity( "entity", null, scene );
		entity.scene = null;

		Assert.isTrue(entity.scene == null);
		Assert.isTrue(scene.getEntity(entity.name) == null);

	}

	@Test
	public function testEntitySetChangeAndReturnScene():Void {

		var scene:Scene = new Scene("scene1");
		var scene2:Scene = new Scene("scene2");

		var entity:Entity = new Entity( "entity", null, scene );
		entity.scene = scene2;
		Assert.isTrue(entity.scene == scene2);
		Assert.isTrue(scene.getEntity(entity.name) == null);
		Assert.isTrue(scene2.getEntity(entity.name) == entity);

	}

	@Test
	public function testEntityCanReplaceOther():Void {

		var scene:Scene = new Scene("scene1");

		var entity:Entity = new Entity( "entity", null, scene, false );
		var entity2:Entity = new Entity( "entity", null, scene, false );

		Assert.isTrue(entity.scene == null);
		Assert.isTrue(entity2.scene == scene);
		Assert.isTrue(scene.getEntity("entity") == entity2);

	}

	@Test
	public function testEntityDestroy():Void {

		var scene:Scene = new Scene("scene1");

		var entity:Entity = new Entity( "entity", null, scene );
		var entName:String = entity.name;
		entity.destroy();

		Assert.isTrue(scene.getEntity(entName) == null);

	}


}

/*
class MockComponent {

	public var value:Int;

	public function new(value:Int = 0) {
		this.value = value;
	}

}

class MockComponent2 {

	public var value:String;

	public function new(){}

}

class MockComponentExtended extends MockComponent {

	public var other:Int;

	public function new() {
		super();
	}

}*/