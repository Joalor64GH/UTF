package utf.objects.dialogue.portraits;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Represents an portrait within a dialogue.
 */
class Portrait extends FlxSprite
{
	/**
	 * The ID of the portrait.
	 */
	public var portraitID:String;

	/**
	 * Constructor to initialize the portrait with a specified ID.
	 * @param portraitID The ID of the portrait.
	 */
	public function new(portraitID:String):Void
	{
		super();

		this.portraitID = portraitID;
	}

	/**
	 * Function to change the face of the portrait.
	 * @param name The name of the face.
	 */
	public function changeFace(name:String):Void {}
}
