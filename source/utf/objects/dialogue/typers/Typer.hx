package utf.objects.dialogue.typers;

import flixel.FlxG;
import flixel.sound.FlxSound;
import utf.backend.AssetPaths;

/**
 * Represents a typer for displaying text in the game.
 */
class Typer
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
	public var fontSpacing:Float;

	/**
	 * Array of sounds associated with the typer.
	 */
	public var typerSounds:Array<FlxSound>;

	/**
	 * The delay between characters being typed.
	 */
	public var typerDelay:Float;

	/**
	 * Constructor to initialize the typer with specified ID.
	 *
	 * @param typerID The ID of the typer.
	 */
	public function new(typerID:String):Void
	{
		this.typerID = typerID;
	}
}
