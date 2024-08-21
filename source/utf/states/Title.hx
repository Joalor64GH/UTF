package utf.states;

import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import utf.states.Intro;

class Title extends FlxState
{
	@:noCompletion
	private var titleText:FlxText;

	@:noCompletion
	private var letters:String = '';

	public override function create():Void
	{
		final titleImage:FlxSprite = new FlxSprite(0, 0, Paths.sprite('titleimage'));
		titleImage.scale.set(2, 2);
		titleImage.updateHitbox();
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		titleImage.active = false;
		add(titleImage);

		titleText = new FlxText(0, 355, 0, '[PRESS Z]', 16);
		titleText.font = Paths.font('Small');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		titleText.active = false;
		add(titleText);

		super.create();

		FlxG.sound.play(Paths.music('intronoise'), () -> titleText.alpha = 1);
	}

	public override function update(elapsed:Float):Void
	{
		if (Controls.justPressed('confirm') && titleText.alpha == 1)
			FlxG.switchState(() -> new Intro());
		else if (FlxG.keys.firstJustPressed() != FlxKey.NONE && titleText.alpha == 1)
		{
			final letter:String = cast(FlxG.keys.firstJustPressed(), FlxKey).toString();

			if (letters == 'ball' && letters.length > 3)
				return;
			else if (letters.length > 3)
				letters = '';

			letters += letter.toLowerCase();

			if (letters.indexOf('ball') != -1)
				FlxG.sound.play(Paths.sound('ballchime'));
		}

		super.update(elapsed);
	}
}
