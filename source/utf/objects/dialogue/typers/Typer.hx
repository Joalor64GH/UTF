package utf.objects.dialogue.typers;

import flixel.util.FlxArrayUtil;
import flixel.util.FlxStringUtil;
import openfl.media.Sound;

typedef TypingSound =
{
	sound:Sound,
	volume:Float,
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
	 * Array of sounds associated with the typer.
	 */
	public var typerSounds:Array<TypingSound>;

	/**
	 * The amount of seconds between characters being typed.
	 */
	public var typerLPS:Float;

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
			LabelValuePair.weak("Typer Latters Per Second", typerLPS)
		]);
	}
}
