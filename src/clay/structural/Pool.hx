package clay.structural;


@:generic
class Pool<T> {


	public var items : Array<T>;
	public var createFunc : Void->T;
	public var size: Int;


	public function new( _size:Int = 0, createCallback:Void->T){

		items = [];
		size = _size;

		createFunc = createCallback;

		if(size > 0) {
			for(i in 0...size) {
				items.push(createFunc());
			}
		}

	}

	public inline function get() : T {

		if(items.length > 0) {
			return items.pop();
		}

		return createFunc();

	}

	public inline function put(item:T) {

		if(size > 0 && (items.length < size)) {
			items.push(item);
		} else {
		}

	}

}

