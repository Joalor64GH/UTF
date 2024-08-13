package utf;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.Lib;
import utf.util.FilterUtil;

/**
 * Handles saving and loading game settings.
 */
class Data
{
	/**
	 * Stores game settings like filter and quality options.
	 */
	public static var settings(default, null):Map<String, Dynamic> = ['filter' => 'none', 'low-quality' => false];

	/**
	 * Saves the current settings to a file.
	 */
	public static function save():Void
	{
		final save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));
		save.data.settings = settings;
		save.close();
	}

	/**
	 * Loads settings from a file and applies them.
	 */
	public static function load():Void
	{
		final save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));

		if (!save.isEmpty() && save.data.settings != null)
		{
			settings = save.data.settings;
			FilterUtil.reloadGameFilter(settings.get('filter'));
		}

		save.destroy();
	}

	/**
	 * Updates a setting and saves it.
	 *
	 * @param name The name of the setting to update.
	 * @param value The new value for the setting.
	 */
	public static function updateSetting(name:String, value:Dynamic):Void
	{
		if (settings.exists(name) && settings.get(name) != value)
		{
			settings.set(name, value);
			save();
		}
	}

	/**
	 * Retrieves a setting's value.
	 *
	 * @param name The name of the setting.
	 * @return The value of the setting, or null if it doesn't exist.
	 */
	public static function getSetting(name:String):Null<Dynamic>
	{
		return settings.get(name);
	}
}
