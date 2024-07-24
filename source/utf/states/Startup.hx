package utf.states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import utf.backend.Data;
#if hxdiscord_rpc
import utf.backend.Discord;
#end
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

		#if hxdiscord_rpc
		Discord.load();
		#end

		Global.load();

		#if polymod
		PolymodHandler.reloadMods();
		PolymodHandler.reloadRegisteries();
		#end

		FlxG.game.focusLostFramerate = FlxG.updateFramerate;

		if (Data.settings.get('filter') != 'none' && Data.filters.exists(Data.settings.get('filter')))
			FlxG.game.setFilters([Data.filters.get(Data.settings.get('filter'))]);

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);

		super.create();

		FlxG.switchState(() -> new Title());
	}
}
