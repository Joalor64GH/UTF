package utf.objects.room;

import utf.backend.AssetPaths;
import flixel.FlxSprite;

/**
 * Represents an object within a room.
 */
class RoomObject extends FlxSprite
{
	/**
	 * The ID of the object.
	 */
	public var objectID:String;

	/**
	 * The name of the object.
	 */
	public var objectName:String;

	/**
	 * Constructor to initialize the object with a specified ID.
	 *
	 * @param objectID The ID of the object.
	 */
	public function new(objectID:String):Void
	{
		super();

		this.objectID = objectID;
	}
}
