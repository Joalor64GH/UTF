package utf.objects.room;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Represents an object within a room.
 */
class Object extends FlxSprite
{
	/**
	 * The ID of the object.
	 */
	public var objectID:String;

	/**
	 * Indicates whether the object is interactable.
	 */
	public var objectInteractable:Bool;

	/**
	 * Constructor to initialize the object with a specified ID.
	 * @param objectID The ID of the object.
	 */
	public function new(objectID:String):Void
	{
		super();

		this.objectID = objectID;
	}

	/**
	 * Function to interact with the object if the object is interactable.
	 */
	public function interact():Void {}
}
