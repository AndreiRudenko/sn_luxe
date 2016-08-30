package clay.utils;


// taken from https://github.com/underscorediscovery/luxe


class Id {


	inline public static function uniqueid(?val:Null<Int>) : String {

		// http://www.anotherchris.net/csharp/friendly-unique-id-generation-part-2/#base62

		if(val == null) {
			val = Std.random(0x7fffffff);
		}

		function to_char(value:Int) : String {
			if (value > 9) {
				var ascii = (65 + (value - 10));
				if (ascii > 90) { ascii += 6; }
				return String.fromCharCode(ascii);
			} else return Std.string(value).charAt(0);
		} //to_char

		var r = Std.int(val % 62);
		var q = Std.int(val / 62);
		if (q > 0) return uniqueid(q) + to_char(r);
		else return Std.string(to_char(r));

	}


}
