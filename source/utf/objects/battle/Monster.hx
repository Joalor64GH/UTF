package utf.objects.battle;

import flixel.group.FlxSpriteGroup;

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
	 * The ID of the monster.
	 */
	public var monsterId:String;

	/**
	 * Constructor to initialize the monster with specified attributes.
	 *
	 * @param monsterId The ID of the monster.
	 */
	public function new(monsterId:String):Void
	{
		super();

		this.monsterId = monsterId;
	}
}
