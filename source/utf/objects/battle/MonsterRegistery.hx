package utf.objects.battle;

import flixel.FlxG;
import haxe.Exception;
import haxe.Json;
import utf.objects.battle.Monster;

class MonsterRegistery
{
	private static final monsterCache:Map<String, MonsterData> = [];
	private static final monsterScriptedClass:Map<String, String> = [];

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
					final parsedData:MonsterData = Json.parse(file);

					if (parsedData == null)
						throw 'Unable to parse the file content!';
					
					monsterCache.set(parsedData.name, parsedData);
				}
				else
					throw 'No data to parse!';
			}
			catch (e:Exception)
			{
				FlxG.log.error('Unable to parse monster atributes file located at "$file", ${e.messege}');
				continue;
			}
		}
	}

	public static function clearMonsters():Void
	{
		if (monsterCache != null)
			monsterCache.clear();

		if (monsterScriptedClass != null)
			monsterScriptedClass.clear();
	}
}
