package clay;

@:keep
@:enum abstract Ev(Int) from Int to Int {

	var unknown		        	= 0;
	var ready  		        	= 1;
	var init  		        	= 2;
	var destroy  		    	= 3;
	var componentAdded  		= 4;
	var componentRemoved  		= 5;

} //Ev
