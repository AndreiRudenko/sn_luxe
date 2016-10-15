package clay.signals;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;


class OrderedSignalMacro {


	public static function build():Array<Field> {


		var fields = Context.getBuildFields();
		var cls:ClassType = Context.getLocalClass().get();


		var signature = switch(cls.superClass.params[0]) {
			case TFun(args, _):
				args;
			default:
				throw new Error("Invalid signal type parameter", cls.pos);
		}

		var arguments:Array<FunctionArg> = [];
		var callArgs:Array<Expr> = [];
		var i = 0;
		for (argDef in signature) {
			i++;
			var name = 'object$i';
			arguments.push({
				name: name,
				opt: argDef.opt,
				type: haxe.macro.TypeTools.toComplexType(argDef.t)
			});
			callArgs.push(macro $i{name});
		}

		fields.push({
			name: "send",
			access: [APublic],
			meta: [],
			kind: FFun({
				args: arguments,
				ret: macro : Void,
				expr: macro {


					var node = signals.head;
					while(node != null) {
						node.object($a{callArgs});
						node = node.next;
					}


					// for (s in signals) {
					// 	s($a{callArgs});
					// }


				},
				params: [],
			}),
			pos: cls.pos
		});

		return fields;
	}


}

#end