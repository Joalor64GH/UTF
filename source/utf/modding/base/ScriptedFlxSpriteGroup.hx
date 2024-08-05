package utf.modding.base;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;

/**
 * A sprite group that can be controlled by scripts.
 */
@:hscriptClass
class ScriptedFlxSpriteGroup extends FlxTypedSpriteGroup<FlxSprite> implements HScriptedClass {}
