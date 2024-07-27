/*package utf.backend.registries;

import flixel.FlxG;
import utf.states.room.Room;
import utf.states.room.ScriptedRoom;

/**
 * Handles the loading and management of room classes within the game.
 */
class RoomRegistry
{
	/**
	 * Map to store associations between room numbers and their classes.
	 */
	private static final roomClasses:Map<Int, String> = [];

	/**
	 * Loads and initializes room classes.
	 */
	public static function loadRooms():Void
	{
		clearRooms();

		final roomList:Array<String> = ScriptedRoom.listScriptClasses();

		if (roomList.length > 0)
		{
			FlxG.log.notice('Initiating ${roomList.length} rooms...');

			for (roomClass in roomList)
			{
				final room:Room = ScriptedRoom.init(roomClass, 'unknown');

				if (room == null)
					continue;

				FlxG.log.notice('Initialized room "${room.roomNumber}"!');

				roomClasses.set(room.roomNumber, roomClass);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(roomClasses)} room(s)!');
	}

	/**
	 * Fetches a room by its number.
	 * @param roomNumber The number of the room.
	 * @return The room or null if not found.
	 */
	public static function fetchRoom(roomNumber:Int):Null<Room>
	{
		if (!roomClasses.exists(roomNumber))
		{
			FlxG.log.error('Unable to load room number "${roomNumber}", not found in cache');

			return null;
		}

		final roomClass:String = roomClasses.get(roomNumber);

		if (roomClass != null)
		{
			final room:Room = ScriptedRoom.init(roomClass, roomNumber);

			if (room == null)
			{
				FlxG.log.error('Unable to initiate room number "${roomNumber}"');

				return null;
			}

			return room;
		}

		return null;
	}

	/**
	 * Clears all loaded room classes.
	 */
	public static function clearRooms():Void
	{
		if (roomClasses != null)
			roomClasses.clear();
	}
}
*/
