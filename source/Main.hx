package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filesystem.File;
import openfl.utils.AssetCache;
import openfl.utils.Assets;
import openfl.Lib;
#if polymod
import polymod.Polymod;
#end
import utf.backend.AssetPaths;
import utf.backend.Data;
import utf.objects.debug.Overlay;
import utf.states.Startup;
import utf.util.logging.ErrorHandler;
#if (cpp || neko || hl)
import utf.util.MemoryUtil;
#end
import utf.util.TimerUtil;

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
				window.onKeyDown.cancel();
			#elseif mac
			if (keyCode == KeyCode.F && (keyModifier.ctrlKey && keyModifier.metaKey) && (!keyModifier.altKey && !keyModifier.shiftKey))
				window.onKeyDown.cancel();
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
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	@:noCompletion
	private function onAddedToStage(?event:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		#if (cpp || neko || hl)
		MemoryUtil.enable();
		#end

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(onPreStateCreate);
		#if (cpp || neko || hl)
		FlxG.signals.postStateSwitch.add(onPostStateSwitch);
		#end

		addChild(new FlxGame(640, 480, Startup, 60, 60));

		FlxG.autoPause = false;

		FlxG.debugger.toggleKeys = [FlxKey.F2];

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		if (FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;

		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		FlxG.game.focusLostFramerate = 30;

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		overlay = new Overlay(10, 10, FlxColor.RED);
		FlxG.game.addChild(overlay);
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

		@:privateAccess
		if (FlxG.game != null)
		{
			FlxG.game.__cacheBitmap = null;
			FlxG.game.__cacheBitmapData = null;
		}
	}

	@:noCompletion
	private inline function onPreStateCreate(state:FlxState):Void
	{
		final cache:AssetCache = cast(Assets.cache, AssetCache);

		for (key in cache.sound.keys())
		{
			FlxG.log.notice('Removing "$key" from the sound cache.');

			cache.sound.remove(key);
		}

		for (key in cache.font.keys())
		{
			FlxG.log.notice('Removing "$key" from the font cache.');

			cache.font.remove(key);
		}

		#if polymod
		Polymod.clearCache();
		#end
	}

	#if (cpp || neko || hl)
	@:noCompletion
	private inline function onPostStateSwitch():Void
	{
		FlxG.log.notice('Running the garbage collector.');

		final gcStart:Float = TimerUtil.start();

		MemoryUtil.collect(true);
		MemoryUtil.compact();
		MemoryUtil.collect(false);

		FlxG.log.notice('Garbage collection took: ${TimerUtil.seconds(gcStart)}');
	}
	#end
}
