package utf.objects.battle;

import utf.backend.AssetPaths;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import openfl.utils.Assets;

typedef MonsterData =
{
	name:String,
	hp:Int,
	maxHp:Int,
	attack:Float,
	defense:Float,
	xpReward:Int,
	goldReward:Int
}

class Monster extends FlxSpriteGroup
{
	public var data(default, null):MonsterData;

	public function new(x:Float = 0, y:Float = 0, name:String):Void
	{
		super(x, y);

		if (Assets.exists(AssetPaths.data('monsters/$name')))
			data = Json.parse(Assets.getText(AssetPaths.data('monsters/$name')));
		else
		{
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
