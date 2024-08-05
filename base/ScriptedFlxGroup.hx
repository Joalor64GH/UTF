package utf.modding.base;

import flixel.group.FlxGroup;
import flixel.FlxBasic;

/**
 * A group that can be controlled by scripts.
 */
@:hscriptClass
class ScriptedFlxGroup extends FlxTypedGroup<FlxBasic> implements HScriptedClass {}
