package utf.util;

import lime.ui.KeyCode;
import openfl.Lib;
#if linux
import utf.Assets;
#end

/**
 * Utility class for window-related functions.
 */
@:nullSafety
class WindowUtil
{
	/**
	 * Initializes the window utility.
	 */
	public static function init():Void
	{
		#if web
		// https://github.com/ninjamuffin99/canabalt-hf/blob/a1f44cc39275474b644cea63b30a553c71f235fc/source/Main.hx#L27
		Lib.application.window.element.style.setProperty('image-rendering', 'pixelated');
		#end

		#if desktop
		Lib.application.window.onKeyDown.add(function(keyCode:KeyCode, keyModifier:lime.ui.KeyModifier):Void
		{
			#if (windows || linux)
			if (keyCode == KeyCode.RETURN && keyModifier.altKey && (!keyModifier.ctrlKey && !keyModifier.shiftKey && !keyModifier.metaKey))
				Lib.application.window.onKeyDown.cancel();
			#elseif mac
			if (keyCode == KeyCode.F && (keyModifier.ctrlKey && keyModifier.metaKey) && (!keyModifier.altKey && !keyModifier.shiftKey))
				Lib.application.window.onKeyDown.cancel();
			#end

			if (keyCode == KeyCode.F4 && (!keyModifier.altKey && !keyModifier.ctrlKey && !keyModifier.shiftKey && !keyModifier.metaKey))
				flixel.FlxG.fullscreen = !flixel.FlxG.fullscreen;
		});
		#end

		#if linux
		if (Assets.exists('icon.png'))
		{
			final icon:Null<openfl.display.BitmapData> = Assets.getBitmapData('icon.png', false);

			if (icon != null)
				Lib.application.window.setIcon(icon.image);
		}
		#end
	}

	/**
	 * Show a popup with the given text.
	 * @param name The title of the popup.
	 * @param desc The content of the popup.
	 */
	public static inline function showAlert(name:String, desc:String):Void
	{
		#if !android
		Lib.application.window.alert(desc, name);
		#else
		android.Tools.showAlertDialog(name, desc, {name: 'Ok', func: null});
		#end
	}

	/**
	 * Sets the title of the application window.
	 * @param value The title to set for the application window.
	 */
	public static inline function setWindowTitle(value:String):Void
	{
		Lib.application.window.title = value;
	}
}
