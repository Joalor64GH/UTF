package utf.objects.dialogue;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;

// TODO: Rewrite this to use a sprite group with text's as it's letters.
class TypeText extends FlxText
{
	private static final IGNORE_CHARACTERS:Array<String> = ['\n', ' ', '^', '!', '.', '?', ',', ':', '/', '\\', '|', '*'];

	public var finished(get, null):Bool = false;

	private var originalText:String = '';
	private var textPos:Int = 0;

	private var typing:Bool = false;
	private var typingTimer:FlxTimer;

	public function new(x:Float, y:Float):Void
	{
		super(x, y, 0, '', 8, true);

		typingTimer = new FlxTimer();
	}

	public function start(typer:Typer, text:String):Void
	{
		setupTyper(typer);

		originalText = text;
		typing = true;
		textPos = 1;

		updateText();

		typingTimer.start(typer.typerLettersPerSecond, function(timer:FlxTimer):Void
		{
			if (updateTextPos(timer))
			{
				updateText();
				playSounds();
			}
		});
	}

	public function skip():Void
	{
		if (typing)
		{
			textPos = originalText.length;

			updateText();
		}
	}

	@:noCompletion
	private inline function setupTyper(typer:Typer):Void
	{
		this.typer = typer;
	}

	@:noCompletion
	private function updateTextPos(timer:FlxTimer):Bool
	{
		if (!typing)
			return false;

		switch (originalText.charAt(textPos))
		{
			case ' ' | '\n':
				textPos++;

				return false;
			case '^':
				final waitTime:Null<Int> = Std.parseInt(originalText.charAt(textPos + 1));

				if (waitTime != null)
				{
					originalText = originalText.substring(0, textPos) + originalText.substring(textPos + 2);

					textPos--;

					if (waitTime > 0)
					{
						timer.active = false;

						FlxTimer.wait(1 / (waitTime * 10), () -> timer.active = true);

						return false;
					}
				}
				else
					textPos++;
			default:
				textPos++;
		}

		if (textPos > originalText.length)
			textPos = originalText.length;

		return true;
	}

	@:noCompletion
	private function updateText():Void
	{
		final curText:String = originalText.substr(0, textPos);

		if (text != curText)
		{
			text = curText;

			if (textPos >= originalText.length)
			{
				if (typingTimer.active)
					typingTimer.cancel();

				typing = false;
			}
		}
	}

	@:noCompletion
	private function playSounds():Void
	{
		if (sounds != null && sounds.length > 0 && !IGNORE_CHARACTERS.contains(originalText.charAt(textPos - 1)))
		{
			for (sound in sounds)
				sound.stop();

			FlxG.random.getObject(sounds).play(true);
		}
	}

	@:noCompletion
	private function get_finished():Bool
	{
		return !typing && textPos >= originalText.length;
	}
}
