package utf.states;

import flixel.FlxG;
import flixel.FlxState;
import utf.modding.PolymodHandler;
import utf.states.Title;

class Startup extends FlxState
{
	public override function create():Void
	{
		FlxG.autoPause = FlxG.fixedTimestep = false;

		Data.load();
		Global.load();
		PolymodHandler.load();

		FlxG.switchState(() -> new Title());
	}
}
