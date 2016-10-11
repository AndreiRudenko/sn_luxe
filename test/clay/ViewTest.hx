package clay;


import massive.munit.Assert;

import clay.Entity;
import clay.Engine;
import clay.Scene;
import clay.View;
import clay.Mockups;


// @:access(clay.View)
class ViewTest {


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
	public function canStoreViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		Assert.isTrue(view.viewClasses[0] == MockComponent); 

	}

	@Test
	public function canStoreViewClasses():Void {

		var view:View = new View("view", [MockComponent, MockComponent2]);
		Assert.isTrue(view.viewClasses[0] == MockComponent && view.viewClasses[1] == MockComponent2); 

	}

	@Test
	public function canAddViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.addViewClass(MockComponent2);
		Assert.isTrue(view.hasViewClass(MockComponent) && view.hasViewClass(MockComponent2)); 

	}

	@Test
	public function canChangeViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.setViewClasses([MockComponent2]);
		Assert.isTrue(view.viewClasses[0] == MockComponent2); 

	}

	@Test
	public function canRemoveViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.removeViewClass(MockComponent);
		Assert.isTrue(!view.hasViewClass(MockComponent)); 

	}

	@Test
	public function hasViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		Assert.isTrue(view.hasViewClass(MockComponent)); 

	}

	@Test
	public function testViewCantHaveNullViewClasses():Void {
		
		var view:View = new View("view", null);
		Assert.isTrue(view.viewClasses != null);

	}

	@Test
	public function testViewNameStoredAndReturned():Void {

		var name:String = "anything";
		var view:View = new View(name, []);
		Assert.isTrue(view.name == "anything");

	}

	@Test
	public function testViewNameCanBeChanged():Void {
		
		var view:View = new View("anything", []);
		view.name = "otherThing";
		Assert.isTrue(view.name == "otherThing");

	}

	@Test
	public function testViewSetAndReturnScene():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [], scene );
		Assert.isTrue(view.scene == scene);
		Assert.isTrue(scene.getView(view.name) == view);

	}

	@Test
	public function testViewSetSceneToNull():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [], scene );
		view.scene = null;

		Assert.isTrue(view.scene == null);
		Assert.isTrue(scene.getView(view.name) == null);

	}

	@Test
	public function testViewSetChangeAndReturnScene():Void {

		var scene:Scene = new Scene("scene1");
		var scene2:Scene = new Scene("scene2");

		var view:View = new View( "view", [], scene );
		view.scene = scene2;
		Assert.isTrue(view.scene == scene2);
		Assert.isTrue(scene.getView(view.name) == null);
		Assert.isTrue(scene2.getView(view.name) == view);

	}

	@Test
	public function testViewCanAddAndRemoveEntities():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.scene.addView(view);
		
		var entity:Entity = new Entity('ent');
		entity.add(new MockComponent());

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

		entity.remove(MockComponent);

		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isFalse(hasEnt);

	}

	@Test
	public function testViewCanAddEntitiesOnSceneChanged():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [MockComponent] );
		engine.scene.addView(view);

		var entity:Entity = new Entity('ent', null, scene);
		entity.add(new MockComponent());

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isFalse(hasEnt);

		view.scene = scene;
		
		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

	}

	@Test
	public function testViewCanRemoveEntitiesOnSceneChanged():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [MockComponent] );
		engine.scene.addView(view);

		var entity:Entity = new Entity('ent');
		entity.add(new MockComponent());

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

		view.scene = scene;
		
		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isFalse(hasEnt);

	}

	@Test
	public function testViewCanRemoveEntitiesOnSceneNull():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.scene.addView(view);

		var entity:Entity = new Entity('ent');
		entity.add(new MockComponent());

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

		view.scene = null;

		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isFalse(hasEnt);

	}

	@Test
	public function testViewHasEntitiesOnNameChanged():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.scene.addView(view);

		var entity:Entity = new Entity('ent');
		entity.add(new MockComponent());

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

		view.name = "another";

		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);

	}

	@Test
	public function testViewCanReplaceAnotherView():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [], scene );
		var view2:View = new View( "view", [], scene );

		Assert.isTrue(view.scene == null);
		Assert.isTrue(view2.scene == scene);
		Assert.isTrue(scene.getView("view") == view2);

	}

	@Test
	public function testViewDestroy():Void {

		var scene:Scene = new Scene("scene1");

		var view:View = new View( "view", [], scene );
		var viewName:String = view.name;
		view.destroy();

		Assert.isTrue(scene.getEntity(viewName) == null);

	}


}
