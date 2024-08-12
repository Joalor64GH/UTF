package utf;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.Lib;

class Data
{
	public static var settings(default, null):Map<String, Dynamic> = [
		'filter' => 'none'
	];

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));
		save.data.settings = settings;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();

		save.bind('data', Lib.application.meta.get('file'));

		if (!save.isEmpty())
		{
			if (save.data.settings != null)
				settings = save.data.settings;
		}

		save.destroy();
	}
}
