package utf.states.room;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import utf.backend.registries.CharaRegistry;
import utf.backend.registries.ObjectRegistry;
// import utf.backend.registries.TileRegistry;
import utf.backend.AssetPaths;
import utf.backend.Global;
import utf.input.Controls;
import utf.objects.room.Chara;
import utf.objects.room.Object;
// import utf.objects.room.Tile;

/**
 * Represents a room in the game, managing the character, objects, and cameras within the room.
 */
class Room extends FlxTransitionableState
{
	/**
	 * The ID of the room.
	 */
	public var roomID:String;

	/**
	 * The number of the room.
	 */
	public var roomNumber:Int;

	/**
	 * The name of the room.
	 */
	public var roomName:String;

	/**
	 * The width of the room.
	 */
	public var roomWidth:Int;

	/**
	 * The height of the room.
	 */
	public var roomHeight:Int;

	/**
	 * The scale of the room.
	 */
	public var roomScale:Float;

	/**
	 * The character within the room.
	 */
	var chara:Chara;

	// var tiles:FlxTypedGroup<Tile> = new FlxTypedGroup<Tile>();

	/**
	 * The group of objects within the room.
	 */
	var objects:FlxTypedGroup<Object> = new FlxTypedGroup<Object>();

	/**
	 * The main game camera.
	 */
	var camGame:FlxCamera;

	/**
	 * The HUD camera.
	 */
	var camHud:FlxCamera;

	/**
	 * Constructor to initialize the room with a specified ID.
	 * @param roomID The ID of the room.
	 */
	public function new(roomID:String):Void
	{
		super();

		this.roomID = roomID;
	}

	override function create():Void
	{
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FlxG.camera.setScrollBoundsRect(0, 0, roomWidth, roomHeight);

		add(objects);
		add(chara);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (chara != null && chara.characterHitbox != null)
			FlxG.collide(chara.characterHitbox, objects);
	}

	/**
	 * Loads the character into the room.
	 * @param characterID The ID of the character to load.
	 * @param x The x-coordinate to place the character.
	 * @param y The y-coordinate to place the character.
	 * @return The loaded character.
	 */
	public function loadCharacter(characterID:String, x:Float, y:Float):Chara
	{
		chara = CharaRegistry.fetchCharacter(characterID);
		chara.setPosition(x, y);
		return chara;
	}

	/**
	 * Creates an object in the room.
	 * @param objectID The ID of the object to create.
	 * @param x The x-coordinate to place the object.
	 * @param y The y-coordinate to place the object.
	 * @return The created object.
	 */
	public function createObject(objectID:String, x:Float, y:Float):Object
	{
		final object:Object = ObjectRegistry.fetchObject(objectID);
		object.setPosition(x, y);
		objects.add(object);
		return object;
	}
}
