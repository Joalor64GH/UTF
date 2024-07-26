package utf.states;

import utf.backend.AssetPaths;
import utf.input.Controls;
import utf.backend.Global;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import utf.objects.room.Chara;
import utf.objects.room.Object;
// import utf.objects.room.Tile;

using StringTools;

class Room extends FlxTransitionableState
{
	public var roomID:String;
	public var roomNumber:Int;
	public var roomName:String;
	public var roomWidth:Int;
	public var roomHeight:Int;
	public var roomScale:Float;

	var chara:Chara;
	// var tiles:FlxTypedGroup<Tile> = new FlxTypedGroup<Tile>();
	var objects:FlxTypedGroup<Object> = new FlxTypedGroup<Object>();

	var camGame:FlxCamera;
	var camHud:FlxCamera;

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

	public function loadCharacter(characterID:String, x:Float, y:Float):Chara
	{
		chara = CharaRegistery.fetchCharacter(characterID);
		chara.setPosition(x, y);
		return chara;
	}

	public function createObject(objectID:String, x:Float, y:Float):Object
	{
		final object:Object = ObjectRegistery.fetchObject(objectID);
		object.setPosition(x, y);
		objects.add(object);
		return object;
	}
}
