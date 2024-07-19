package utf.substates;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import utf.backend.AssetPaths;
import utf.backend.Controls;
import utf.backend.Data;
import utf.backend.Global;
import utf.backend.Typers;
import utf.objects.dialogue.Writer;
import utf.states.Room;

class GameOver extends FlxSubState
{
	var gameoverbg:FlxSprite;
	var writer:Writer;

	override function create():Void
	{
		Typers.reloadFiles();

		FlxG.sound.playMusic(AssetPaths.music('gameover'));

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.screenCenter();
		bg.active = false;
		add(bg);

		gameoverbg = new FlxSprite(0, 30, AssetPaths.sprite('gameovergameoverbg'));
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
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					final lines:Array<String> = [
						'  You cannot give\n  up just yet...',
						'  Our fate rests\n  upon you...',
						'  You\'re going to\n  be alright!',
						'  Don\'t lose hope!',
						'  It cannot end\n  now!'
					];

					writer.startDialogue([
						{typer: Typers.data.get('gameover'), text: FlxG.random.getObject(lines)},
						{typer: Typers.data.get('gameover'), text: '  ${Global.name}!^1\n  Stay determined...'}
					]);
				});
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.instance.justPressed('confirm') && !members.contains(writer) && gameoverbg.alpha == 1)
		{
			FlxTween.tween(gameoverbg, {alpha: 0}, 1.5, {
				onComplete: (twn:FlxTween) -> close()
			});

			FlxG.sound.music.fadeOut(1.5);
		}

		super.update(elapsed);
	}
}
