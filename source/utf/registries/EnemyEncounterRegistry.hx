package utf.registries;

import flixel.FlxG;
import utf.substates.battle.EnemyEncounter;
import utf.substates.battle.ScriptedEnemyEncounter;

/**
 * Handles the loading and management of enemy encounter classes within the game.
 */
class EnemyEncounterRegistry
{
	/**
	 * Map to store associations between enemy encounter numbers and their classes.
	 */
	private static final enemyEncounterScriptedClasses:Map<String, String> = [];

	/**
	 * Loads and initializes enemy encounter classes.
	 */
	public static function loadEnemyEncounters():Void
	{
		clearEnemyEncounters();

		final enemyEncounterList:Array<String> = ScriptedEnemyEncounter.listScriptClasses();

		if (enemyEncounterList.length > 0)
		{
			FlxG.log.notice('Initiating ${enemyEncounterList.length} enemy encounters...');

			for (enemyEncounterClass in enemyEncounterList)
			{
				final enemyEncounter:EnemyEncounter = ScriptedEnemyEncounter.init(enemyEncounterClass, 0);

				if (enemyEncounter == null)
					continue;

				FlxG.log.notice('Initialized enemy encounter "${enemyEncounter.enemyEncounterID}"!');

				enemyEncounterScriptedClasses.set(enemyEncounter.enemyEncounterID, enemyEncounterClass);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(enemyEncounterScriptedClasses)} enemy encounter(s)!');
	}

	/**
	 * Fetches a enemy encounter by its number.
	 * @param enemyEncounterID The ID of the enemy encounter.
	 * @return The enemy encounter or null if not found.
	 */
	public static function fetchEnemyEncounter(enemyEncounterID:String):Null<EnemyEncounter>
	{
		if (!enemyEncounterScriptedClasses.exists(enemyEncounterID))
		{
			FlxG.log.error('Unable to load enemy encounter "${enemyEncounterID}", not found in cache');

			return null;
		}

		final enemyEncounterClass:String = enemyEncounterScriptedClasses.get(enemyEncounterID);

		if (enemyEncounterClass != null)
		{
			final enemyEncounter:EnemyEncounter = ScriptedEnemyEncounter.init(enemyEncounterClass, enemyEncounterID);

			if (enemyEncounter == null)
			{
				FlxG.log.error('Unable to initiate enemy encounter "${enemyEncounterID}"');

				return null;
			}

			return enemyEncounter;
		}

		return null;
	}

	/**
	 * Clears all loaded enemy encounter classes.
	 */
	public static function clearEnemyEncounters():Void
	{
		if (enemyEncounterScriptedClasses != null)
			enemyEncounterScriptedClasses.clear();
	}
}
