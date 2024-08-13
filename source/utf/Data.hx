package utf;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.Lib;
import utf.util.FilterUtil;

/**
 * Handles saving and loading of settings to and from a file.
 */
class Data
{
	/**
	 * Map to store game settings.
	 */
	public static var settings(default, null):Map<String, Dynamic> = [
		'filter' => 'none',
		'low-quality' => false
	];

	/**
	 * Saves the current settings to a file.
	 * Uses the FlxSave class to bind to a file and stores the settings map.
	 */
	public static function save():Void
	{
		final save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));
		save.data.settings = settings;
		save.close();
	}

	/**
	 * Loads settings from a file and applies the saved filter.
	 * Retrieves the settings using FlxSave and updates the settings map.
	 */
	public static function load():Void
	{
		final save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));

		if (!save.isEmpty())
		{
			if (save.data.settings != null)
				settings = save.data.settings;

			FilterUtil.reloadGameFilter(settings.get('filter'));
		}

		save.destroy();
	}

	public static function updateSetting(name:String, value:Dynamic):Void
	{
		if (!Data.settings.exists(name))
			return;

		if (Data.settings.get(name) != value)
		{
			Data.settings.set(name, value);
			Data.save();
		}
	}

	public static function getSetting(name:String):Void
	{
		if (!Data.settings.exists(name))
			return;

		return Data.settings.get(name);
	}
}
