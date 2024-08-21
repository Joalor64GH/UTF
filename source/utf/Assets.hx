package utf;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.Assets as OpenFLAssets;
import openfl.utils.ByteArray;

class Assets
{
	public static function exists(path:String):Bool
	{
		return OpenFLAssets.exists(path);
	}

	public static function getBitmapData(path:String, ?cache:Bool = true):Null<BitmapData>
	{
		try
		{
			return OpenFLAssets.getBitmapData(path, cache);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function getSound(path:String, ?cache:Bool = true):Null<Sound>
	{
		try
		{
			return OpenFLAssets.getSound(path, cache);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function getFont(path:String, ?cache:Bool = true):Null<Font>
	{
		try
		{
			return OpenFLAssets.getFont(path, cache);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function list(directory:String):Array<String>
	{
		final files:Array<String> = OpenFLAssets.list().filter((file:String) -> return Path.directory(file) == directory);

		files.sort((a:String, b:String) -> return (a < b) ? -1 : (a > b) ? 1 : 0);

		return files;
	}

	public static function getText(path:String):String
	{
		try
		{
			return OpenFLAssets.getText(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function getBytes(path:String):Null<ByteArray>
	{
		try
		{
			return OpenFLAssets.getBytes(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}
}
