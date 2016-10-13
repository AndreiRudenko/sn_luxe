package clay;


import massive.munit.Assert;

import clay.Entity;
import clay.Engine;
import clay.View;
import clay.Mockups;


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
		Assert.isTrue(view.viewClasses.has(MockComponent)); 

	}

	@Test
	public function canStoreViewClasses():Void {

		var view:View = new View("view", [MockComponent, MockComponent2]);
		Assert.isTrue(view.viewClasses.has(MockComponent) && view.viewClasses.has(MockComponent2)); 

	}

	@Test
	public function canAddViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.viewClasses.add(MockComponent2);
		Assert.isTrue(view.viewClasses.has(MockComponent) && view.viewClasses.has(MockComponent2)); 

	}

	@Test
	public function canChangeViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.viewClasses.set([MockComponent2]);
		Assert.isTrue(view.viewClasses.has(MockComponent2) && !view.viewClasses.has(MockComponent)); 

	}

	@Test
	public function canRemoveViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		view.viewClasses.remove(MockComponent);
		Assert.isTrue(!view.viewClasses.has(MockComponent)); 

	}

	@Test
	public function hasViewClass():Void {

		var view:View = new View("view", [MockComponent]);
		Assert.isTrue(view.viewClasses.has(MockComponent)); 

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
	public function testViewCanAddAndRemoveEntities():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.views.add(view);
		
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
	public function testViewCanRemoveAndAddEntities():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.views.add(view);
		
		var entity:Entity = new Entity('ent', [new MockComponent()]);
		entity.remove(MockComponent);

		var hasEnt:Bool = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isFalse(hasEnt);

		entity.add(new MockComponent());

		hasEnt = false;
		for (e in view.entities) {
			if(e == entity){
				hasEnt = true;
			}
		}

		Assert.isTrue(hasEnt);
	}


	@Test
	public function testViewHasEntitiesOnNameChanged():Void {

		var view:View = new View( "view", [MockComponent] );
		engine.views.add(view);

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

		var view:View = new View( "view", [] );
		var view2:View = new View( "view", [] );
		Clay.views.add(view);
		Clay.views.add(view2);

		Assert.isTrue(Clay.views.get("view") == view2);

	}

	@Test
	public function testViewDestroy():Void {

		var view:View = new View( "view", [] );
		Clay.views.add(view);

		var viewName:String = view.name;
		view.destroy();

		Assert.isTrue(Clay.views.get(viewName) == null);

	}


}
