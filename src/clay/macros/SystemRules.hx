package clay.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

@:noCompletion class SystemRules {

#if macro

	static var _listenEmitter_field : Field;
	static var _unlistenEmitter_field : Field;

	macro public static function apply() : Array<Field> {

        _listenEmitter_field = null;
        _unlistenEmitter_field = null;

        var _fields = Context.getBuildFields();

            //do this first to ensure the values are set
        for(_field in _fields) {
            switch(_field.name) {
                case '_listenEmitter': _listenEmitter_field = _field;
                case '_unlistenEmitter': _unlistenEmitter_field = _field;
            }
        }

            //if no init field, insert one
        if(_listenEmitter_field == null) {
            _listenEmitter_field = {
                name: '_listenEmitter',
                doc: null, meta: [],
                access: [AOverride,APublic],
                kind: FFun({ params:[], args:[], ret:null, expr:macro {  } }),
                pos: Context.currentPos()
            };
            _fields.push(_listenEmitter_field);
        }

            //if no ondestroy field, insert one
        if(_unlistenEmitter_field == null) {
            _unlistenEmitter_field = {
                name: '_unlistenEmitter',
                doc: null, meta: [],
                access: [AOverride,APublic],
                kind: FFun({ params:[], args:[], ret:null, expr:macro {  } }),
                pos: Context.currentPos()
            };
            _fields.push(_unlistenEmitter_field);
        }

		for(_field in _fields) {

			switch(_field.name) {

				case
					'onUpdate',
					'onRender',
					'onTouchMove',
					'onTouchDown',
					'onTouchUp',
					'onMouseMove',
					'onMouseDown',
					'onMouseUp',
					'onMouseWheel',
					'onGamepadAxis',
					'onGamepadUp',
					'onGamepadDown',
					'onGamepadDevice',
					'onKeyDown',
					'onKeyUp',
					'onTextInput',
					'onInputDown',
					'onInputUp',
					'onWindowMoved',
					'onWindowResized',
					'onWindowSized',
					'onWindowMinimized',
					'onWindowRestored' :
				{
					connect_event(_field);
				}

			} //switch _field.name

		} //for field in fields

		return _fields;

	} //apply



	static function connect_event( _field:haxe.macro.Field ) {

		if(_field.access.indexOf(AOverride) != -1) {

			var _event_name : String = _field.name.substr(2).toLowerCase();

				//inject the init connection
			switch(_listenEmitter_field.kind) {
				default:
				case FFun(f):
					switch(f.expr.expr) {
						default:
						case EBlock(exprs):
							exprs.push( Context.parse('Clay.systems.on( clay.Ev.${_event_name}, ${"_" + _event_name}, this )', _field.pos) );
					} //switch exp
			} //switch kind

				//and inject the ondestroy connection
			switch(_unlistenEmitter_field.kind) {
				default:
				case FFun(f):
					switch(f.expr.expr) {
						default:
						case EBlock(exprs):
							exprs.push( Context.parse('Clay.systems.off( clay.Ev.${_event_name}, ${"_" + _event_name} )', _field.pos) );
					} //switch exp
			} //switch kind

		} //if override

	} //connect_event

#end //macro

} //EntityRules
