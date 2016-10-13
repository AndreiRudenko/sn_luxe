package clay;


import massive.munit.Assert;

import clay.Entity;
import clay.Engine;
import clay.System;

class EventsTest {


	var engine:Engine;


	@Before
	public function createEngine():Void {

		engine = new Engine();

	}

	@After
	public function clearEngine():Void {

		engine = null;

	}
	

}
