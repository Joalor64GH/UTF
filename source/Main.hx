package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.typeLimit.NextState;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.events.Event;
import openfl.Lib;
import utf.Game;

using StringTools;

/**
 * This class serves as the entry point for the application.
 */
class Main extends openfl.display.Sprite
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
	private static final GAME_INITIAL_STATE:InitialState = () -> new utf.states.Startup();

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
		Sys.setCwd(haxe.io.Path.addTrailingSlash(android.os.Build.VERSION.SDK_INT > 30 ? android.content.Context.getObbDir() : android.content.Context.getExternalFilesDir()));
		#elseif (ios || switch)
		Sys.setCwd(haxe.io.Path.addTrailingSlash(openfl.filesystem.File.applicationStorageDirectory.nativePath));
		#end

		utf.util.logging.ErrorHandler.init();

		utf.util.WindowUtil.init();

		Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		Lib.current.stage.quality = openfl.display.StageQuality.LOW;
		Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
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

		#if hxdiscord_rpc
		utf.util.discord.DiscordUtil.init();
		#end

		utf.util.CleanupUtil.init();
		utf.util.ResizeUtil.init();

		final game:Game = new Game(GAME_WIDTH, GAME_HEIGHT, GAME_INITIAL_STATE, GAME_FRAMERATE, GAME_FRAMERATE, GAME_SKIP_SPLASH, GAME_START_FULLSCREEN);

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

		addChild(game);

		utf.util.FramerateUtil.adjustStageFramerate();
	}
}
