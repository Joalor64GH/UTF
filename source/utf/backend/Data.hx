package utf.backend;

import utf.backend.AssetPaths;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.Lib;

class Data
{
	public static var settings(default, null):Map<String, Dynamic> = ['overlay-overlay' => false, 'filter' => 'none'];

	public static var filters(default, null):Map<String, BitmapFilter> = [
		'deuteranopia' => new ColorMatrixFilter([
			0.43, 0.72, -.15, 0, 0, 0.34, 0.57, 0.09, 0, 0, -.02, 0.03, 1, 0, 0, 0, 0, 0, 1, 0
		]),
		'protanopia' => new ColorMatrixFilter([
			0.20, 0.99, -.19, 0, 0, 0.16, 0.79, 0.04, 0, 0, 0.01, -.01, 1, 0, 0, 0, 0, 0, 1, 0
		]),
		'tritanopia' => new ColorMatrixFilter([
			0.97, 0.11, -.08, 0, 0, 0.02, 0.82, 0.16, 0, 0, 0.06, 0.88, 0.18, 0, 0, 0, 0, 0, 1, 0
		]),
		'achromatomaly' => new ColorMatrixFilter([
			0.618, 0.32, 0.062, 0, 0, 0.163, 0.775, 0.062, 0, 0, 0.163, 0.32, 0.518, 0, 0, 0, 0, 0, 1, 0
		]),
		'deuteranomaly' => new ColorMatrixFilter([0.8, 0.2, 0, 0, 0, 0.258, 0.742, 0, 0, 0, 0, 0.142, 0.858, 0, 0, 0, 0, 0, 1, 0]),
		'protanomaly' => new ColorMatrixFilter([
			0.817, 0.183, 0, 0, 0, 0.333, 0.667, 0, 0, 0, 0, 0.125, 0.875, 0, 0, 0, 0, 0, 1, 0
		]),
		'tritanomaly' => new ColorMatrixFilter([
			0.967, 0.033, 0, 0, 0, 0, 0.733, 0.267, 0, 0, 0, 0.183, 0.817, 0, 0, 0, 0, 0, 1, 0
		])
	];

	public static var binds(default, null):Map<String, FlxKey> = ['confirm' => FlxKey.Z, 'cancel' => FlxKey.X, 'menu' => FlxKey.C];

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('data', Lib.application.meta.get('file'));
		save.data.settings = settings;
		save.data.binds = binds;
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

			if (save.data.binds != null)
				binds = save.data.binds;
		}

		save.destroy();
	}
}
