package utf;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import openfl.utils.Assets;
import openfl.utils.ByteArray;

/**
 * Provides utility functions for constructing paths to various game assets,
 * including scripts, data files, rooms, music, sounds, backgrounds, borders,
 * sprites, fonts, shaders, and spritesheets.
 */
class AssetPaths
{
	private static final PERSISTENT_SOUNDS:Array<String> = [];
	private static final PERSISTENT_FONTS:Array<String> = [];

	/**
	 * Constructs the path for a script asset.
	 * @param key The key for the script.
	 * @return The path to the script file.
	 */
	public static inline function script(key:String):String
	{
		return 'assets/data/$key.hxs';
	}

	/**
	 * Constructs the path for a data asset.
	 * @param key The key for the data.
	 * @return The path to the data file.
	 */
	public static inline function data(key:String):String
	{
		return 'assets/data/$key.json';
	}

	/**
	 * Constructs the path for a room asset.
	 * @param key The key for the room.
	 * @return The path to the room file.
	 */
	public static inline function room(key:String):String
	{
		return 'assets/data/$key.xml';
	}

	/**
	 * Constructs the path for a music asset.
	 * @param key The key for the music.
	 * @return The path to the music file.
	 */
	public static inline function music(key:String):String
	{
		return 'assets/music/$key.ogg';
	}

	/**
	 * Constructs the path for a sound asset.
	 * @param key The key for the sound.
	 * @return The path to the sound file.
	 */
	public static inline function sound(key:String):String
	{
		return 'assets/sounds/$key.wav';
	}

	/**
	 * Constructs the path for a background image asset.
	 * @param key The key for the background.
	 * @return The path to the background image file.
	 */
	public static inline function background(key:String):String
	{
		return 'assets/images/backgrounds/$key.png';
	}

	/**
	 * Constructs the path for a sprite image asset.
	 * @param key The key for the sprite.
	 * @return The path to the sprite image file.
	 */
	public static inline function sprite(key:String):String
	{
		return 'assets/images/sprites/$key.png';
	}

	/**
	 * Constructs the path for a font asset and retrieves the font name if it exists.
	 * @param key The key for the font.
	 * @return The font name, or null if the font does not exist.
	 */
	public static function font(key:String):String
	{
		final path:String = 'assets/fonts/$key.ttf';

		try
		{
			if (Assets.exists(path, FONT))
				return Assets.getFont(path).fontName;
			else if (Assets.exists(Path.withoutExtension(path), FONT))
				return Assets.getFont(Path.withoutExtension(path)).fontName;
		}
		catch (e:Exception)
		{
			FlxG.log.error(e.message);
		}

		return null;
	}

	/**
	 * Constructs the path for a shader asset and retrieves its content.
	 * @param key The key for the shader with its extension.
	 * @return The shader content, or null if the shader does not exist.
	 */
	public static inline function shader(key:String):String
	{
		return 'assets/shaders/$key';
	}

	/**
	 * Constructs the path for a spritesheet asset and retrieves it in the appropriate format.
	 * @param key The key for the spritesheet.
	 * @return The spritesheet frames, or null if the spritesheet does not exist.
	 */
	public static function spritesheet(key:String):FlxAtlasFrames
	{
		final path:String = Path.withoutExtension(AssetPaths.sprite(key));

		try
		{
			if (Assets.exists(Path.withExtension(path, 'xml'), TEXT))
				return FlxAtlasFrames.fromSparrow(AssetPaths.sprite(key), Path.withExtension(path, 'xml'));
			else if (Assets.exists(Path.withExtension(path, 'json'), TEXT))
				return FlxAtlasFrames.fromTexturePackerJson(AssetPaths.sprite(key), Path.withExtension(path, 'json'));
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	/**
	 * Lists all files in a specified directory with a specific extension.
	 * @param directory The directory to search within.
	 * @param extension The file extension to filter by.
	 * @return An array of file paths matching the criteria, sorted alphabetically.
	 */
	public static function list(directory:String, extension:String):Array<String>
	{
		final files:Array<String> = Assets.list().filter(function(file:String):Bool
		{
			return (extension != null && extension.length > 0) ? (Path.directory(file) == directory && Path.extension(file) == extension) : Path.directory(file) == directory;
		});

		files.sort(function(a:String, b:String):Int
		{
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		});

		return files;
	}

	/**
	 * Retrieves the content of a specified asset file as a string.
	 * @param path The path to the asset file.
	 * @param force If true, forces the retrieval even if the asset does not exist.
	 * @return The content of the file as a string, or null if the file does not exist and force is false.
	 */
	public static function getContent(path:String, ?force:Bool = false):String
	{
		if (!Assets.exists(path) && !force)
			return null;

		try
		{
			return Assets.getText(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	/**
	 * Retrieves the content of a specified asset file as a ByteArray.
	 * @param path The path to the asset file.
	 * @param force If true, forces the retrieval even if the asset does not exist.
	 * @return The content of the file as a ByteArray, or null if the file does not exist and force is false.
	 */
	public static function getBytes(path:String, ?force:Bool = false):ByteArray
	{
		if (!Assets.exists(path) && !force)
			return null;

		try
		{
			return Assets.getBytes(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}
}
