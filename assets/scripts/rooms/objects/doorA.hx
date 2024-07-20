import utf.backend.AssetPaths;
import utf.objects.room.RoomObject;

class DoorA extends RoomObject
{
	public function new():Void
	{
		super('doorA');

		loadGraphic(AssetPaths.sprite(objectID));
		immovable = true;
		solid = false;
	}
}
