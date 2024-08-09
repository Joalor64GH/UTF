package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.typeLimit.NextState;
import flixel.util.FlxColor;
import flixel.FlxG;
import haxe.io.Path;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.filesystem.File;
import openfl.Lib;
import utf.states.Startup;
#if hxdiscord_rpc
import utf.util.discord.DiscordUtil;
#end
import utf.util.logging.ErrorHandler;
import utf.util.CleanupUtil;
import utf.util.FramerateUtil;
import utf.util.MemoryUtil;
import utf.util.ResizeUtil;
import utf.Game;

using StringTools;

/**
 * This class serves as the entry point for the application.
 */
class Main extends Sprite
{
	/**
	 * The width of the game window in pixels.
	 */
	@:noCompletion
	private static final GAME_WIDTH:Int = 640;

	/**
	 * The height of the game window in pixels.
	 */
	@:noCompletion
	private static final GAME_HEIGHT:Int = 480;

	/**
	 * The frame rate of the game, in frames per second (FPS).
	 */
	@:noCompletion
	private static final GAME_FRAMERATE:Int = 30;

	/**
	 * The initial state of the game.
	 */
	@:noCompletion
	private static final GAME_INITIAL_STATE:InitialState = () -> new Startup();

	/**
	 * Whether to skip the splash screen on startup.
	 */
	@:noCompletion
	private static final GAME_SKIP_SPLASH:Bool = true;

	/**
	 * Whether to start the game in fullscreen mode on desktop.
	 */
	@:noCompletion
	private static final GAME_START_FULLSCREEN:Bool = false;

	/**
	 * The entry point of the application.
	 */
	public static function main():Void
	{
		#if android
		Sys.setCwd(Path.addTrailingSlash(VERSION.SDK_INT > 30 ? Context.getObbDir() : Context.getExternalFilesDir()));
		#elseif (ios || switch)
		Sys.setCwd(Path.addTrailingSlash(File.applicationStorageDirectory.nativePath));
		#end

		ErrorHandler.init();

		#if desktop
		Lib.application.window.onKeyDown.add(function(keyCode:KeyCode, keyModifier:KeyModifier):Void
		{
			#if (windows || linux)
			if (keyCode == KeyCode.RETURN && keyModifier.altKey && (!keyModifier.ctrlKey && !keyModifier.shiftKey && !keyModifier.metaKey))
				Lib.application.window.onKeyDown.cancel();
			#elseif mac
			if (keyCode == KeyCode.F && (keyModifier.ctrlKey && keyModifier.metaKey) && (!keyModifier.altKey && !keyModifier.shiftKey))
				Lib.application.window.onKeyDown.cancel();
			#end

			if (keyCode == KeyCode.F4 && (!keyModifier.altKey && !keyModifier.ctrlKey && !keyModifier.shiftKey && !keyModifier.metaKey))
				FlxG.fullscreen = !FlxG.fullscreen;
		});
		#end

		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}

	/**
	 * Initializes the main game instance and sets up the application.
	 */
	public function new():Void
	{
		super();

		if (stage != null)
			setupGame();
		else
			addEventListener(Event.ADDED_TO_STAGE, setupGame);
	}

	@:noCompletion
	private function setupGame(?event:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, setupGame);

		#if (cpp || neko || hl)
		MemoryUtil.enable();
		#end

		#if hxdiscord_rpc
		DiscordUtil.init();
		#end

		CleanupUtil.init();

		ResizeUtil.init();

		final game:Game = new Game(GAME_WIDTH, GAME_HEIGHT, GAME_INITIAL_STATE, GAME_FRAMERATE, GAME_FRAMERATE, GAME_SKIP_SPLASH, GAME_START_FULLSCREEN);

		setupFlixel();

		addChild(game);

		FramerateUtil.adjustStageFramerate();
	}

	@:noCompletion
	private inline function setupFlixel():Void
	{
		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		FlxG.debugger.toggleKeys = [F2];

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end
	}
}
