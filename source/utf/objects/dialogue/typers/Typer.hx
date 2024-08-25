package utf.objects.dialogue.typers;

import flixel.math.FlxPoint;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;
import openfl.media.Sound;

/**
 * A structure representing the sound settings for typing effects.
 */
typedef TypingSound =
{
	/**
	 * The sound to be played when typing.
	 */
	sound:Sound,

	/**
	 * The volume level of the sound, where 1.0 is 100%.
	 */
	volume:Float,

	/**
	 * The pitch of the sound, if specified. Defaults to 1.0 (normal pitch) if not provided.
	 */
	?pitch:Float
}

/**
 * Represents a typer for displaying text in the game.
 */
class Typer implements IFlxDestroyable
{
	/**
	 * The ID of the typer.
	 */
	public var typerID:String;

	/**
	 * The offset position of the typer relative to a base position.
	 */
	public var typerOffset:FlxPoint = FlxPoint.get();

	/**
	 * Array of sounds associated with the typer.
	 */
	public var typerSounds:Array<TypingSound>;

	/**
	 * The amount of seconds between characters being typed.
	 */
	public var typerFPS:Float;

	/**
	 * The name of the font used by the typer.
	 */
	public var fontName:String;

	/**
	 * The size of the font used by the typer.
	 */
	public var fontSize:Int;

	/**
	 * The spacing between characters in the text.
	 */
	public var fontSpacing:Null<Float>;

	/**
	 * Constructor to initialize the typer with specified ID.
	 * @param typerID The ID of the typer.
	 */
	public function new(typerID:String):Void
	{
		this.typerID = typerID;
	}

	/**
	 * Clean up memory.
	 */
	public function destroy():Void
	{
		typerOffset = FlxDestroyUtil.put(typerOffset);
		typerSounds = FlxArrayUtil.clearArray(typerSounds);
	}

	/**
	 * Converts the typer to a string for display and debugging purposes.
	 * @return A string representation of the typer, including its ID, font properties, spacing, associated sounds, and typing delay.
	 */
	public function toString():String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("Typer ID", typerID),
			LabelValuePair.weak("Font Name", fontName),
			LabelValuePair.weak("Font Size", fontSize),
			LabelValuePair.weak("Font Spacing", fontSpacing),
			LabelValuePair.weak("Typer Sounds", typerSounds),
			LabelValuePair.weak("Typer Letters Per Second", typerFPS)
		]);
	}
}
