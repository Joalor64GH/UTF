package;

#if android
import android.content.Context;
import android.os.Build;
#end
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import haxe.io.Path;
import haxe.CallStack;
import haxe.Exception;
import haxe.Log;
#if hl
import hl.Api;
#end
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.filesystem.File;
import openfl.system.System;
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
import utf.util.WindowUtil;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

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

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		#if hl
		Api.setErrorHandler(onCriticalError);
		#elseif cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
		#end

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

		#if debug
		FlxG.log.redirectTraces = true;
		#end

		FlxG.signals.gameResized.add(onResizeGame);
		FlxG.signals.preStateCreate.add(onPreStateCreate);
		FlxG.signals.postStateSwitch.add(onPostStateSwitch);

		#if (!mobile || !switch)
		FlxG.signals.postUpdate.add(onPostUpdate);
		#end

		addChild(new FlxGame(640, 480, Startup, 60, 60));

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		#if FLX_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end

		overlay = new Overlay(10, 10, FlxColor.RED);
		overlay.visible = Data.settings.get('overlay-overlay');
		FlxG.game.addChild(overlay);
	}

	private static inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		final log:Array<String> = [];

		if (Std.isOfType(event.error, Error))
			log.push(cast(event.error, Error).message);
		else if (Std.isOfType(event.error, ErrorEvent))
			log.push(cast(event.error, ErrorEvent).text);
		else
			log.push(Std.string(event.error));

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					log.push('C Function');
				case Module(m):
					log.push('Module [$m]');
				case FilePos(s, file, line, column):
					log.push('$file [line $line]');
				case Method(classname, method):
					log.push('$classname [method $method]');
				case LocalFunction(name):
					log.push('Local Function [$name]');
			}
		}

		final msg:String = log.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('errors'))
				FileSystem.createDirectory('errors');

			File.saveContent('errors/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			FlxG.log.warn('Couldn\'t save error message "${e.message}"');
		#end

		WindowUtil.showAlert('Uncaught an Error!', msg);

		System.exit(1);
	}

	private static inline function onCriticalError(error:Dynamic):Void
	{
		final log:Array<String> = [Std.isOfType(error, String) ? error : Std.string(error)];

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					log.push('C Function');
				case Module(m):
					log.push('Module [$m]');
				case FilePos(s, file, line, column):
					log.push('$file [line $line]');
				case Method(classname, method):
					log.push('$classname [method $method]');
				case LocalFunction(name):
					log.push('Local Function [$name]');
			}
		}

		final msg:String = log.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('errors'))
				FileSystem.createDirectory('errors');

			File.saveContent('errors/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			FlxG.log.warn('Couldn\'t save error message "${e.message}"');
		#end

		WindowUtil.showAlert('Critical Error!', msg);

		System.exit(1);
	}

	private inline function onResizeGame(width:Int, height:Int):Void
	{
		if (overlay != null)
		{
			final scale:Float = Math.min(width / FlxG.width, height / FlxG.height);

			overlay.scaleX = (scale > 1 ? scale : 1);
			overlay.scaleY = (scale > 1 ? scale : 1);
		}

		if (FlxG.cameras != null && (FlxG.cameras.list != null && FlxG.cameras.list.length > 0))
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera != null && (camera.filters != null && camera.filters.length > 0))
				{
					@:privateAccess
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
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

	private inline function onPreStateCreate(state:FlxState):Void
	{
		var cache:AssetCache = cast(Assets.cache, AssetCache);

		for (key in cache.bitmapData.keys())
		{
			if (!FlxG.bitmap.checkCache(key))
				cache.bitmapData.remove(key);
		}

		for (key in cache.sound.keys())
			cache.sound.remove(key);

		for (key in cache.font.keys())
			cache.font.remove(key);

		#if polymod
		Polymod.clearCache();
		#end
	}

	private inline function onPostStateSwitch():Void
	{
		System.gc();
	}

	#if (!mobile || !switch)
	private inline function onPostUpdate():Void
	{
		if (FlxG.keys.justPressed.F4)
			FlxG.fullscreen = !FlxG.fullscreen;
	}
	#end
}
