package utf;

import flixel.graphics.frames.FlxAtlasFrames;
import utf.Assets;

using haxe.io.Path;

/**
 * Enum representing different types of spritesheets.
 */
enum SpriteSheetType
{
	ASEPRITE;
	PACKER;
	SPARROW;
	TEXTURE_PATCHER_JSON;
	TEXTURE_PATCHER_XML;
}

/**
 * Provides utility functions for constructing paths to various game assets.
 */
@:nullSafety
class Paths
{
	/**
	 * Constructs the path for a font asset and retrieves the font name.
	 * @param key The key identifying the font.
	 * @param cache Whether to cache the font (default is true).
	 * @return The font name, or null if it doesn't exist.
	 */
	public static inline function font(key:String, ?cache:Bool = true):Null<String>
	{
		return Assets.exists('assets/fonts/$key.ttf') ? Assets.getFont('assets/fonts/$key.ttf', cache).fontName : Assets.exists('assets/fonts/$key') ? Assets.getFont('assets/fonts/$key', cache).fontName : null;
	}

	/**
	 * Constructs the path for a background image.
	 * @param key The key identifying the background.
	 * @return The path to the background image file.
	 */
	public static inline function background(key:String):String
	{
		return 'assets/images/backgrounds/$key.png';
	}

	/**
	 * Constructs the path for a sprite image.
	 * @param key The key identifying the sprite.
	 * @return The path to the sprite image file.
	 */
	public static inline function sprite(key:String):String
	{
		return 'assets/images/sprites/$key.png';
	}

	/**
	 * Retrieves a spritesheet in the appropriate format.
	 * @param key The key identifying the spritesheet.
	 * @param type The type of spritesheet.
	 * @return The spritesheet frames, or null if it doesn't exist.
	 */
	public static inline function spritesheet(key:String, ?type:SpriteSheetType):Null<FlxAtlasFrames>
	{
		if (type == null)
			type = SPARROW;

		return switch (type)
		{
			case ASEPRITE: FlxAtlasFrames.fromAseprite(Paths.sprite(key), Paths.sprite(key).withExtension('json'));
			case PACKER: FlxAtlasFrames.fromSpriteSheetPacker(Paths.sprite(key), Paths.sprite(key).withExtension('txt'));
			case SPARROW: FlxAtlasFrames.fromSparrow(Paths.sprite(key), Paths.sprite(key).withExtension('xml'));
			case TEXTURE_PATCHER_JSON: FlxAtlasFrames.fromTexturePackerJson(Paths.sprite(key), Paths.sprite(key).withExtension('json'));
			case TEXTURE_PATCHER_XML: FlxAtlasFrames.fromTexturePackerXml(Paths.sprite(key), Paths.sprite(key).withExtension('xml'));
		}
	}

	/**
	 * Retrieves a music asset as a `Sound` object.
	 * @param key The key identifying the music.
	 * @param cache Whether to cache the sound (default is true).
	 * @return The `Sound` object, or null if it doesn't exist.
	 */
	public static inline function music(key:String, ?cache:Bool = true):Null<openfl.media.Sound>
	{
		return Assets.getSound('assets/music/$key.ogg', cache);
	}

	/**
	 * Constructs the path for a shader asset.
	 * @param key The key identifying the shader.
	 * @return The path to the shader file.
	 */
	public static inline function shader(key:String):String
	{
		return 'assets/shaders/$key';
	}

	/**
	 * Retrieves a sound effect as a `Sound` object.
	 * @param key The key identifying the sound.
	 * @param cache Whether to cache the sound (default is true).
	 * @return The `Sound` object, or null if it doesn't exist.
	 */
	public static inline function sound(key:String, ?cache:Bool = true):Null<openfl.media.Sound>
	{
		return Assets.getSound('assets/sounds/$key.wav', cache);
	}
}
