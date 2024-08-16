package utf.states.room;

import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxImageFrame;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import utf.registries.CharaRegistry;
import utf.registries.ObjectRegistry;
import utf.objects.dialogue.DialogueBox;
import utf.objects.room.Chara;
import utf.objects.room.Object;
import utf.util.FlxGraphicUtil;

/**
 * Represents a room in the game, managing the character, objects, and cameras within the room.
 */
class Room extends FlxTransitionableState
{
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
	 * A group containing the background sprites in the room.
	 */
	@:noCompletion
	private var backgrounds:FlxTypedGroup<FlxSprite>;

	/**
	 * A group containing the tile sprites in the room.
	 */
	@:noCompletion
	private var tiles:FlxTypedGroup<FlxSprite>;

	/**
	 * A group containing the interactive objects in the room.
	 */
	@:noCompletion
	private var objects:FlxTypedGroup<Object>;

	/**
	 * The main character object present in the room.
	 */
	@:noCompletion
	private var chara:Chara;

	/**
	 * The main game camera for rendering the room.
	 */
	@:noCompletion
	private var camGame:FlxCamera;

	/**
	 * The HUD camera used for displaying overlays like dialogue boxes.
	 */
	@:noCompletion
	private var camHud:FlxCamera;

	/**
	 * The object that the camera follows within the room.
	 */
	@:noCompletion
	private var camFollow:FlxObject;

	/**
	 * Determines whether the camera's following behavior can be controlled.
	 */
	@:noCompletion
	private var camFollowControllable:Bool = false;

	/**
	 * The dialogue box currently active in the room, if any.
	 */
	@:noCompletion
	private var dialogueBox:DialogueBox;

	/**
	 * Constructor to initialize the room with a specified ID.
	 * @param roomNumber The number of the room.
	 */
	public function new(roomNumber:Int):Void
	{
		super();

		this.roomNumber = roomNumber;
	}

	public override function create():Void
	{
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		if (backgrounds != null)
			add(backgrounds);

		if (tiles != null)
			add(tiles);

		if (objects != null)
			add(objects);

		camFollow = new FlxObject(0, 0, 1, 1);

		if (chara != null)
		{
			if (!camFollowControllable)
				camFollow.setPosition(chara.getGraphicMidpoint().x, chara.getGraphicMidpoint().y);

			add(chara);
		}

		FlxG.camera.follow(camFollow);

		FlxG.camera.setScrollBoundsRect(0, 0, roomWidth, roomHeight);

		super.create();
	}

	public override function update(elapsed:Float):Void
	{
		if (!camFollowControllable)
			camFollow.setPosition(chara.getGraphicMidpoint().x, chara.getGraphicMidpoint().y);

		super.update(elapsed);

		if (chara != null && chara.characterHitbox != null && objects != null)
		{
			FlxG.collide(chara.characterHitbox, objects);

			objects.forEach(function(obj:Object):Void
			{
				if (obj != null && chara.characterControllable && chara.overlaps(obj))
				{
					if (dialogueBox != null && dialogueBox.active)
						return;

					if (Controls.justPressed('confirm') && obj.objectInteractable)
						obj.interact();
					else
						obj.overlap();
				}
			});
		}
	}

	/**
	 * Creates a background in the room.
	 * @param name The name of the background image.
	 * @param x The x-coordinate to place the background.
	 * @param y The y-coordinate to place the background.
	 * @return The created background sprite.
	 */
	public function createBackground(name:String, x:Float, y:Float):FlxSprite
	{
		if (backgrounds == null)
			backgrounds = new FlxTypedGroup<FlxSprite>();

		final bg:FlxSprite = new FlxSprite(x, y, AssetPaths.background(name));
		bg.scrollFactor.set();
		bg.active = false;
		backgrounds.add(bg);
		return bg;
	}

	/**
	 * Creates a tile in the room.
	 * @param name The name of the image asset for the tile.
	 * @param x The x-coordinate where the tile should be placed.
	 * @param y The y-coordinate where the tile should be placed.
	 * @param rect The portion of the image to use for the tile, specified as a `FlxRect`.
	 * @return The created tile sprite.
	 */
	public function createTile(name:String, x:Float, y:Float, rect:FlxRect):FlxSprite
	{
		if (tiles == null)
			tiles = new FlxTypedGroup<FlxSprite>();

		final tile:FlxSprite = new FlxSprite(x, y, FlxGraphicUtil.fromRegion(AssetPaths.background(name), rect));
		tile.scrollFactor.set();
		tile.active = false;
		tiles.add(tile);
		return tile;
	}

	/**
	 * Creates an object in the room.
	 * @param id The ID of the object to create.
	 * @param x The x-coordinate to place the object.
	 * @param y The y-coordinate to place the object.
	 * @return The created object.
	 */
	public function createObject(id:String, x:Float, y:Float):Object
	{
		if (objects == null)
			objects = new FlxTypedGroup<Object>();

		final object:Object = ObjectRegistry.fetchObject(id);
		object.setPosition(x, y);
		objects.add(object);
		return object;
	}

	/**
	 * Loads the character into the room.
	 * @param id The ID of the character to load.
	 * @param x The x-coordinate to place the character.
	 * @param y The y-coordinate to place the character.
	 * @return The loaded character.
	 */
	public function loadCharacter(id:String, x:Float, y:Float):Chara
	{
		chara = CharaRegistry.fetchCharacter(id);
		chara.setPosition(x, y);
		return chara;
	}

	/**
	 * Initiates a dialogue sequence in the room.
	 * @param dialogue The array of `DialogueData` to display during the dialogue sequence.
	 * @param finishCallback An optional callback function to execute once the dialogue finishes.
	 */
	public function startDialogue(dialogue:Array<DialogueData>, ?finishCallback:Void->Void):Void
	{
		dialogueBox = new DialogueBox((chara != null && chara.y >= 260));
		dialogueBox.camera = camHud;
		dialogueBox.scrollFactor.set();
		dialogueBox.writer.finishCallback = function():Void
		{
			if (finishCallback != null)
				finishCallback();

			remove(dialogueBox);
		}
		dialogueBox.startDialogue(dialogue);
		add(dialogueBox);
	}
}
