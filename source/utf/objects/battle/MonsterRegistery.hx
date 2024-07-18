package utf.objects.battle;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import utf.objects.battle.Monster;

/**
 * Handles the loading and management of scripted monster classes.
 */
class MonsterRegistery
{
	/**
	 * Map to store associations between monster IDs and scripted monster classes.
	 */
	private static final monsterScriptedClasses:Map<String, String> = [];

	/**
	 * Loads and initializes scripted monster classes.
	 */
	public static function loadMonsters():Void
	{
		clearMonsters();

		final scriptedMonsters:Array<String> = ScriptedMonster.listScriptClasses();

		if (scriptedMonsters.length > 0)
		{
			FlxG.log.notice('Initiating ${scriptedMonsters.length} scripted monsters...');

			for (scriptedMonster in scriptedMonsters)
			{
				var monster:Monster = ScriptedMonster.init(scriptedMonster, 'unknown');

				if (monster == null)
					continue;

				FlxG.log.notice('Initialized monster "${monster.monsterName}"!');

				monsterScriptedClasses.set(monster.monsterId, scriptedMonster);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(monsterScriptedClasses)} monsters!');
	}

	/**
	 * Fetches a scripted monster by its ID.
	 *
	 * @param monsterID The ID of the monster.
	 * @return The monster or null if not found.
	 */
	public static function fetchMonster(monsterID:String):Null<Monster>
	{
		if (!monsterScriptedClasses.exists(monsterID))
		{
			FlxG.log.error('Unable to load "${monsterID}", not found in cache');

			return null;
		}

		final monsterScriptedClass:String = monsterScriptedClasses.get(monsterID);

		if (monsterScriptedClass != null)
		{
			final monster:Monster = ScriptedMonster.init(monsterScriptedClass, monsterID);

			if (monster == null)
			{
				FlxG.log.error('Unable to initiate "${monsterID}"');

				return null;
			}

			return monster;
		}

		return null;
	}

	/**
	 * Clears all loaded monster data and associations.
	 */
	public static function clearMonsters():Void
	{
		if (monsterScriptedClasses != null)
			monsterScriptedClasses.clear();
	}
}
