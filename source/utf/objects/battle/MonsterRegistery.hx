package utf.objects.battle;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import haxe.Json;
import utf.backend.AssetPaths;
import utf.objects.battle.Monster;

/**
 * Handles the loading and management of monster data and scripted monster classes.
 */
class MonsterRegistery
{
	/**
	 * Cache to store loaded monster data.
	 */
	private static final monsterCache:Map<String, MonsterData> = [];

	/**
	 * Map to store associations between monster IDs and scripted monster classes.
	 */
	private static final monsterScriptedClass:Map<String, String> = [];

	/**
	 * Loads monster data from JSON files and initializes scripted monster classes.
	 */
	public static function loadMonsters():Void
	{
		clearMonsters();

		for (file in AssetPaths.list('assets/data/monsters', 'json'))
		{
			if (file == null || file.length <= 0)
				continue;

			try
			{
				final content:String = Assets.getText(file);

				if (content != null && content.length > 0)
				{
					final parsedData:MonsterData = Json.parse(content);

					if (parsedData == null)
						throw 'Unable to parse the file content!';

					monsterCache.set(new Path(file).file, parsedData);
				}
				else
					throw 'No data to parse!';
			}
			catch (e:Exception)
			{
				FlxG.log.error('Unable to parse monster attributes file located at "$file", ${e.message}');
				continue;
			}
		}

		for (scriptedMonster in ScriptedMonster.listScriptClasses())
		{
			var monster:Monster = ScriptedMonster.init(scriptedMonster, 'unknown');

			if (monster == null)
				continue;

			monsterScriptedClass.set(monster.monsterId, scriptedMonster);
		}
	}

	/**
	 * Clears all loaded monster data and associations.
	 */
	public static function clearMonsters():Void
	{
		if (monsterCache != null)
			monsterCache.clear();

		if (monsterScriptedClass != null)
			monsterScriptedClass.clear();
	}
}
