package utf.states;

import flixel.FlxG;
import flixel.FlxState;
import utf.backend.Data;
import utf.backend.Global;
#if polymod
import utf.modding.PolymodHandler;
#end
import utf.states.Title;

class Startup extends FlxState
{
	override function create():Void
	{
		FlxG.autoPause = false;

		Data.load();

		Global.load();

		#if polymod
		PolymodHandler.load();
		#end

		FlxG.switchState(() -> new Title());
	}
}
