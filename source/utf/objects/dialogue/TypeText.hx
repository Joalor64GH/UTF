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
	private var typer:Typer;
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
		textPos = 1;
		updateText();

		typingTimer.start(typer.typerLettersPerSecond, function(timer:FlxTimer):Void
		{
			if (updateTextPos(timer))
			{
				updateText();
				playSounds();
			}
		}, 0);
	}

	public function skip():Void
	{
		if (typingTimer.active)
		{
			textPos = originalText.length;

			updateText();
		}
	}

	@:noCompletion
	private inline function setupTyper(typer:Typer):Void
	{
		if (font != typer.fontName)
			font = typer.fontName;

		if (size != typer.fontSize)
			size = typer.fontSize;

		if (typer.fontSpacing != null && letterSpacing != typer.fontSpacing)
			letterSpacing = typer.fontSpacing;

		this.typer = typer;
	}

	@:noCompletion
	private function updateTextPos(timer:FlxTimer):Bool
	{
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
			}
		}
	}

	@:noCompletion
	private function playSounds():Void
	{
		if (typer?.sounds != null && typer?.sounds?.length > 0 && !IGNORE_CHARACTERS.contains(originalText.charAt(textPos - 1)))
		{
			for (sound in typer.sounds)
				sound.stop();

			FlxG.random.getObject(typer.sounds).play(true);
		}
	}

	@:noCompletion
	private function get_finished():Bool
	{
		return typingTimer.finished && textPos >= originalText.length;
	}
}
