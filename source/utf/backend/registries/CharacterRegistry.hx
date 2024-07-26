package utf.backend.registries;

import flixel.FlxG;
import haxe.io.Path;
import haxe.Exception;
import utf.objects.room.Chara;

/**
 * Handles the loading and management of character objects within a room.
 */
class CharacterRegistry
{
	/**
	 * Map to store associations between character IDs and their classes.
	 */
	private static final characterClasses:Map<String, String> = [];

	/**
	 * Loads and initializes character classes.
	 */
	public static function loadCharacters():Void
	{
		clearCharacters();

		final characterList:Array<String> = Chara.listCharacterClasses();

		if (characterList.length > 0)
		{
			FlxG.log.notice('Initiating ${characterList.length} characters...');

			for (character in characterList)
			{
				var chara:Chara = Chara.init(character, 'unknown');

				if (chara == null)
					continue;

				FlxG.log.notice('Initialized character "${chara.characterID}"!');

				characterClasses.set(chara.characterID, character);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(characterClasses)} characters!');
	}

	/**
	 * Fetches a character by its ID.
	 * @param characterID The ID of the character.
	 * @return The character or null if not found.
	 */
	public static function fetchCharacter(characterID:String):Null<Chara>
	{
		if (!characterClasses.exists(characterID))
		{
			FlxG.log.error('Unable to load "${characterID}", not found in cache');

			return null;
		}

		final characterClass:String = characterClasses.get(characterID);

		if (characterClass != null)
		{
			final chara:Chara = Chara.init(characterClass, characterID);

			if (chara == null)
			{
				FlxG.log.error('Unable to initiate "${characterID}"');

				return null;
			}

			return chara;
		}

		return null;
	}

	/**
	 * Clears all loaded character classes.
	 */
	public static function clearCharacters():Void
	{
		if (characterClasses != null)
			characterClasses.clear();
	}
}
