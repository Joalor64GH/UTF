package utf;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.Assets as OpenFLAssets;
import openfl.utils.ByteArray;

/**
 * Provides utility functions for handling game assets, such as images, sounds, fonts, and text files.
 */
@:nullSafety
class Assets
{
	/**
	 * Checks if an asset exists at the given path.
	 * @param path The path to the asset.
	 * @return `true` if the asset exists, `false` otherwise.
	 */
	public static function exists(path:String):Bool
	{
		return OpenFLAssets.exists(path);
	}

	/**
	 * Retrieves a bitmap image asset.
	 * @param path The path to the image file.
	 * @param cache Whether to cache the bitmap data (default is true).
	 * @return The `BitmapData` object, or null if the file does not exist or an error occurs.
	 */
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

	/**
	 * Retrieves a sound asset.
	 * @param path The path to the sound file.
	 * @param cache Whether to cache the sound data (default is true).
	 * @return The `Sound` object, or null if the file does not exist or an error occurs.
	 */
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

	/**
	 * Retrieves a font asset.
	 * @param path The path to the font file.
	 * @param cache Whether to cache the font data (default is true).
	 * @return The `Font` object, or null if the file does not exist or an error occurs.
	 */
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

	/**
	 * Lists all files in a directory.
	 * @param directory The directory to list files from.
	 * @return An array of file paths sorted alphabetically.
	 */
	public static function list(directory:String):Array<String>
	{
		final files:Array<String> = OpenFLAssets.list().filter((file:String) -> return Path.directory(file) == directory);

		files.sort((a:String, b:String) -> return (a < b) ? -1 : (a > b) ? 1 : 0);

		return files;
	}

	/**
	 * Retrieves the text content of a file.
	 * @param path The path to the text file.
	 * @return The content of the file as a `String`, or null if the file does not exist or an error occurs.
	 */
	public static function getText(path:String):Null<String>
	{
		try
		{
			return OpenFLAssets.getText(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	/**
	 * Retrieves the raw byte data of a file.
	 * @param path The path to the file.
	 * @return A `ByteArray` containing the file's bytes, or null if the file does not exist or an error occurs.
	 */
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
