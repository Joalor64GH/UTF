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
	public var monsterName:String = '';

	/**
	 * Current health points of the monster.
	 */
	public var monsterHp:Int = 0;

	/**
	 * Maximum health points of the monster.
	 */
	public var monsterMaxHp:Int = 0;

	/**
	 * Attack power of the monster.
	 */
	public var monsterAttack:Float = 0;

	/**
	 * Defense power of the monster.
	 */
	public var monsterDefense:Float = 0;

	/**
	 * Experience points reward for defeating the monster.
	 */
	public var monsterXpReward:Int = 0;

	/**
	 * Gold reward for defeating the monster.
	 */
	public var monsterGoldReward:Int = 0;

	/**
	 * Comments related to the monster.
	 */
	public var monsterComments:Array<String> = [];

	/**
	 * Commands available for interacting with the monster.
	 */
	public var monsterCommands:Array<String> = [];

	/**
	 * Dialogues associated with the monster.
	 */
	public var monsterDialogues:Array<String> = [];

	/**
	 * Message displayed when the monster is checked.
	 */
	public var monsterCheckMessage:String = '';

	/**
	 * Indicates whether the monster can be spared.
	 */
	public var monsterSpareable:Bool = true;

	/**
	 * Constructor to initialize the monster with specified attributes.
	 * @param monsterID The ID of the monster.
	 */
	public function new(monsterID:String):Void
	{
		super();

		this.monsterID = monsterID;
	}

	/**
	 * Handles the logic for when the monster is attacked.
	 * @param status The status or amount of damage taken by the monster.
	 */
	public function handleAttack(status:Int):Void
	{
		// TODO
	}

	/**
	 * Handles the logic for when a command is issued to the monster.
	 * @param command The command given to the monster.
	 */
	public function handleCommand(command:String):Void
	{
		// TODO
	}
}
