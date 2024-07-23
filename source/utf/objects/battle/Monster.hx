package utf.objects.battle;

import flixel.group.FlxSpriteGroup;

/**
 * Represents a monster entity in the game.
 */
class Monster extends FlxSpriteGroup
{
	/**
	 * The ID of the monster.
	 */
	public var monsterID:String;

	/**
	 * The name of the monster.
	 */
	public var monsterName:String;

	/**
	 * Current health points of the monster.
	 */
	public var monsterHp:Int;

	/**
	 * Maximum health points of the monster.
	 */
	public var monsterMaxHp:Int;

	/**
	 * Attack power of the monster.
	 */
	public var monsterAttack:Float;

	/**
	 * Defense power of the monster.
	 */
	public var monsterDefense:Float;

	/**
	 * Experience points reward for defeating the monster.
	 */
	public var monsterXpReward:Int;

	/**
	 * Gold reward for defeating the monster.
	 */
	public var monsterGoldReward:Int;

	/**
	 * Constructor to initialize the monster with specified attributes.
	 * @param monsterId The ID of the monster.
	 */
	public function new(monsterID:String):Void
	{
		super();

		this.monsterID = monsterID;
	}
}
