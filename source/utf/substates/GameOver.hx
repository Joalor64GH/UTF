package utf.substates;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import utf.backend.AssetPaths;
import utf.input.Controls;
import utf.backend.Data;
import utf.backend.Global;
import utf.objects.dialogue.Writer;

class GameOver extends FlxSubState
{
	var gameoverbg:FlxSprite;
	var writer:Writer;

	override function create():Void
	{
		FlxG.sound.playMusic(AssetPaths.music('gameover'));

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		bg.active = false;
		add(bg);

		gameoverbg = new FlxSprite(0, 30, AssetPaths.sprite('gameoverbg'));
		gameoverbg.alpha = 0;
		gameoverbg.screenCenter(X);
		gameoverbg.scrollFactor.set();
		gameoverbg.active = false;
		add(gameoverbg);

		writer = new Writer(120, 320);
		writer.skippable = false;
		writer.finishCallback = () -> remove(writer);
		writer.scrollFactor.set();
		add(writer);

		super.create();

		FlxTween.tween(gameoverbg, {alpha: 1}, 1.5, {
			onComplete: function(twn:FlxTween)
			{
				FlxTimer.wait(1, function():Void
				{
					final lines:Array<String> = [
						'  You cannot give\n  up just yet...',
						'  Our fate rests\n  upon you...',
						'  You\'re going to\n  be alright!',
						'  Don\'t lose hope!',
						'  It cannot end\n  now!'
					];

					writer.startDialogue([
						{typer: 'gameover', text: FlxG.random.getObject(lines)},
						{typer: 'gameover', text: '  ${Global.name}!^1\n  Stay determined...'}
					]);
				});
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.justPressed('confirm') && !members.contains(writer) && gameoverbg.alpha == 1)
		{
			FlxTween.tween(gameoverbg, {alpha: 0}, 1.5, {
				onComplete: (twn:FlxTween) -> close()
			});

			FlxG.sound.music.fadeOut(1.5);
		}

		super.update(elapsed);
	}
}
