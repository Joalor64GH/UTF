package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.input.keyboard.FlxKey;
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
import utf.objects.debug.Overlay;
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
	 * Tracks frames per second (Overlay).
	 */
	public static var overlay:Overlay;

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

		addChild(new FlxGame(640, 480, Startup, 60, 60));

		setupFlixel();

		overlay = new Overlay(10, 10, FlxColor.RED);
		FlxG.game.addChild(overlay);
	}

	@:noCompletion
	private function setupFlixel():Void
	{
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		FlxG.autoPause = false;

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxG.debugger.toggleKeys = [FlxKey.F2];

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxG.signals.gameResized.add(onResizeGame);

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
		final scale:Float = Math.min(width / FlxG.width, height / FlxG.height);

		if (overlay != null)
			overlay.scaleX = overlay.scaleY = (scale > 1 ? scale : 1);

		if (FlxG.cameras != null && (FlxG.cameras.list != null && FlxG.cameras.list.length > 0))
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera != null && (camera.filters != null && camera.filters.length > 0))
				{
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
						camera.flashSprite.__cacheBitmapData2 = null;
						camera.flashSprite.__cacheBitmapData3 = null;
						camera.flashSprite.__cacheBitmapColorTransform = null;
					}
				}
			}
		}

		if (FlxG.game != null)
		{
			FlxG.game.__cacheBitmap = null;
			FlxG.game.__cacheBitmapData = null;
			FlxG.game.__cacheBitmapData2 = null;
			FlxG.game.__cacheBitmapData3 = null;
			FlxG.game.__cacheBitmapColorTransform = null;
		}
	}
}
