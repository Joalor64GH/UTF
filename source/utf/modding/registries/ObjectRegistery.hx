package utf.modding.registries;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import utf.objects.room.Object;
import utf.objects.room.ScriptedObject;

/**
 * Handles the loading and management of scripted room object classes.
 */
class ObjectRegistery
{
	/**
	 * Map to store associations between room object IDs and scripted room object classes.
	 */
	private static final objectScriptedClasses:Map<String, String> = [];

	/**
	 * Loads and initializes scripted room object classes.
	 */
	public static function loadObjects():Void
	{
		clearObjects();

		final scriptedObjects:Array<String> = ScriptedObject.listScriptClasses();

		if (scriptedObjects.length > 0)
		{
			FlxG.log.notice('Initiating ${scriptedObjects.length} scripted objects...');

			for (scriptedObject in scriptedObjects)
			{
				var object:Object = ScriptedObject.init(scriptedObject, 'unknown');

				if (object == null)
					continue;

				FlxG.log.notice('Initialized object "${object.objectName}"!');

				objectScriptedClasses.set(object.objectID, scriptedObject);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(objectScriptedClasses)} objects!');
	}

	/**
	 * Fetches a scripted room object by its ID.
	 *
	 * @param objectID The ID of the object.
	 * @return The object or null if not found.
	 */
	public static function fetchObject(objectID:String):Null<Object>
	{
		if (!objectScriptedClasses.exists(objectID))
		{
			FlxG.log.error('Unable to load "${objectID}", not found in cache');

			return null;
		}

		final objectScriptedClass:String = objectScriptedClasses.get(objectID);

		if (objectScriptedClass != null)
		{
			final object:Object = ScriptedObject.init(objectScriptedClass, objectID);

			if (object == null)
			{
				FlxG.log.error('Unable to initiate "${objectID}"');

				return null;
			}

			return object;
		}

		return null;
	}

	/**
	 * Clears all loaded room objects scripted classes.
	 */
	public static function clearObjects():Void
	{
		if (objectScriptedClasses != null)
			objectScriptedClasses.clear();
	}
}
