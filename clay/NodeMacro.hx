package clay;


// based on Ash-Haxe: https://github.com/nadako/Ash-Haxe/blob/master/src/ash/core/NodeMacro.hx


import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;


class NodeMacro {


    macro public static function build():Array<Field> {

        var fields = Context.getBuildFields();
        var pos = Context.currentPos();

        Context.getLocalClass().get().meta.add(":keep", [], pos);

        var populateExprs = [];
        for (field in fields) {

            switch (field.kind) {
                case FVar(type, _):
                    switch (type) {
                        case TPath(path):

                            if (path.params.length > 0){
                                throw new Error("Type parameters for node field types are not yet supported yet", field.pos);
                            }

                            populateExprs.push(macro _components.push($v{field.name}));

                        default:
                            throw new Error("Invalid node class with field type other than class: " + field.name, field.pos);
                    }
                default:
                    // functions and properties are ignored and intended to be used only in custom Node APIs
                    // only variables are set by component system
            }
        }

        if (populateExprs.length == 0){
            throw new Error("Node subclass doesnt declare any component variables", pos);
        }

        var components_type = macro : Array<String>;

        fields.push({
            name: "_components",
            kind: FVar(components_type),
            access: [APrivate, AStatic],
            pos: pos
        });

        fields.push({
            name: "_get_components",
            kind: FFun({
                args: [],
                params: [],
                ret: components_type,
                expr: macro {

                    if (_components == null) {
                        _components = [];
                        $b{populateExprs};
                    }

                    return _components;

                }
            }),
            access: [APublic, AStatic],
            pos: pos
        });

        return fields;

    }


}
