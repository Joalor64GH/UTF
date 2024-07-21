package utf.states;

import utf.backend.AssetPaths;
import utf.backend.Controls;
import utf.backend.Global;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import utf.objects.dialogue.Writer;
import utf.objects.room.Object;

using StringTools;

class Room extends FlxTransitionableState
{
	var camGame:FlxCamera;
	var camHud:FlxCamera;

	public function new(room:Int):Void
	{
		super();
	}

	override function create():Void
	{
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		//FlxG.camera.setScrollBoundsRect(0, 0, Std.parseInt(data.node.width.innerData), Std.parseInt(data.node.height.innerData));

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		/*if (chara != null)
		{
			FlxG.collide(chara, objects);
		}*/
	}
}
