package utf.objects.battle;

import utf.backend.AssetPaths;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

/**
 * Data structure representing attributes of a monster.
 */
typedef MonsterData =
{
	/**
	 * The name of the monster.
	 */
	name:String,
	/**
	 * Current health points of the monster.
	 */
	hp:Int,
	/**
	 * Maximum health points of the monster.
	 */
	maxHp:Int,
	/**
	 * Attack power of the monster.
	 */
	attack:Float,
	/**
	 * Defense power of the monster.
	 */
	defense:Float,
	/**
	 * Experience points reward for defeating the monster.
	 */
	xpReward:Int,
	/**
	 * Gold reward for defeating the monster.
	 */
	goldReward:Int
}

/**
 * Represents a monster entity in the game.
 */
class Monster extends FlxSpriteGroup
{
	/**
	 * Data structure to hold monster attributes.
	 */
	public var data(default, null):MonsterData;

	/**
	 * Constructor to initialize the monster with specified attributes.
	 *
	 * @param x The x-coordinate position.
	 * @param y The y-coordinate position.
	 * @param name The name of the monster.
	 */
	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);

		// Load monster data from assets based on the provided name.
		if (Assets.exists(AssetPaths.data('monsters/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('monsters/$name')));
		else
		{
			// Default values in case data loading fails.
			data = {
				name: 'Error',
				hp: 50,
				maxHp: 50,
				attack: 0,
				defense: 0,
				xpReward: 0,
				goldReward: 0
			};
		}
	}
}
