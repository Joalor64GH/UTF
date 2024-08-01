package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.input.keyboard.FlxKey;
import flixel.util.typeLimit.NextState;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import haxe.io.Path;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filesystem.File;
import openfl.Lib;
import utf.states.Startup;
import utf.util.logging.ErrorHandler;
import utf.util.CleanupUtil;
import utf.util.MemoryUtil;

using StringTools;

/**
 * This class serves as the entry point for the application.
 */
class Main extends Sprite
{
	/**
	 * The width of the game window in pixels.
	 */
	private static final GAME_WIDTH:Int = 640;

	/**
	 * The height of the game window in pixels.
	 */
	private static final GAME_HEIGHT:Int = 480;

	/**
	 * The frame rate of the game, in frames per second (FPS).
	 */
	private static final GAME_FRAMERATE:Int = 60;

	/**
	 * The initial state of the game.
	 */
	private static final GAME_INITIAL_STATE:InitialState = () -> new Startup();

	/**
	 * Whether to skip the splash screen on startup.
	 */
	private static final GAME_SKIP_SPLASH:Bool = true;

	/**
	 * Whether to start the game in fullscreen mode.
	 */
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

		CleanupUtil.init();

		FlxG.autoPause = false;

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxG.signals.gameResized.add(onResizeGame);

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, NEW);

		addChild(new FlxGame(GAME_WIDTH, GAME_HEIGHT, GAME_INITIAL_STATE, GAME_FRAMERATE, GAME_FRAMERATE, GAME_SKIP_SPLASH, GAME_START_FULLSCREEN));

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		FlxG.debugger.toggleKeys = [FlxKey.F2];

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		FlxG.game.focusLostFramerate = 30;

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end
	}

	@:access(openfl.display.Sprite)
	private inline function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras?.list?.length > 0)
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera?.filters?.length > 0)
				{
					camera.flashSprite?.__cacheBitmap = null;
					camera.flashSprite?.__cacheBitmapData = null;
					camera.flashSprite?.__cacheBitmapData2 = null;
					camera.flashSprite?.__cacheBitmapData3 = null;
					camera.flashSprite?.__cacheBitmapColorTransform = null;
				}
			}
		}

		FlxG.game?.__cacheBitmap = null;
		FlxG.game?.__cacheBitmapData = null;
		FlxG.game?.__cacheBitmapData2 = null;
		FlxG.game?.__cacheBitmapData3 = null;
		FlxG.game?.__cacheBitmapColorTransform = null;
	}
}
