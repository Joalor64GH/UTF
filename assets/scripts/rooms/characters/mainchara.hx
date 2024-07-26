import flixel.FlxG;
import utf.backend.AssetPaths;
import utf.backend.Global;
import utf.input.Controls;
import utf.objects.room.Chara;

class MainChara extends Chara
{
	public function new():Void
	{
		super('mainchara');

		frames = AssetPaths.spritesheet('f_mainchara');

		animation.addByPrefix('down', 'f_maincharad', 6, false);
		animation.addByPrefix('right', 'f_maincharar', 6, false);
		animation.addByPrefix('up', 'f_maincharau', 6, false);
		animation.addByPrefix('left', 'f_maincharal', 6, false);

		switch (Global.facing)
		{
			case 0:
				animation.play('down');
			case 1:
				animation.play('right');
			case 2:
				animation.play('up');
			case 3:
				animation.play('left');
		}

		animation.finish();
	}

	public override function update(elapsed:Float):Void
	{
		if (Controls.pressed('down'))
		{
			if (!Controls.anyPressed(['right', 'left']))
				animation.play('down');

			characterHitbox.velocity.y = 180;

			#if debug
			if (Controls.pressed('cancel'))
				characterHitbox.velocity.y = 300;
			#end
		}
		else if (Controls.pressed('up'))
		{
			if (!Controls.anyPressed(['right', 'left']))
				animation.play('up');

			characterHitbox.velocity.y = -180;

			#if debug
			if (Controls.pressed('cancel'))
				characterHitbox.velocity.y = -300;
			#end
		}

		if (Controls.pressed('right'))
		{
			animation.play('right');

			characterHitbox.velocity.x = 180;

			#if debug
			if (Controls.pressed('cancel'))
				characterHitbox.velocity.x = 300;
			#end
		}
		else if (Controls.pressed('left'))
		{
			animation.play('left');

			characterHitbox.velocity.x = -180;

			#if debug
			if (Controls.pressed('cancel'))
				characterHitbox.velocity.x = -300;
			#end
		}

		if (Controls.anyJustReleased(['down', 'up', 'right', 'left']))
		{
			animation.finish();

			characterHitbox.velocity.set();
		}

		super.update(elapsed);
	}
}
