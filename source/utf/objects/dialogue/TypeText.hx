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

	public var delay:Float = 0.05;
	public var finished(get, null):Bool = false;

	private var originalText:String = '';
	private var textPos:Int = 0;
	private var timer:Float = 0;
	private var typing:Bool = false;
	private var sounds:Array<FlxSound> = [];

	public function new(x:Float, y:Float):Void
	{
		super(x, y, 0, '', 8, true);
	}

	public function start(text:String, ?delay:Float = 0.05, ?sounds:Array<FlxSound>):Void
	{
		if (delay != null)
			this.delay = delay;

		if (sounds != null && sounds.length > 0)
			this.sounds = sounds;

		originalText = text;
		typing = true;
		textPos = 1;

		updateText();
	}

	public function skip():Void
	{
		if (typing)
		{
			textPos = originalText.length;
			updateText();
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (textPos < originalText.length && typing)
			timer += elapsed;

		if (typing && timer >= delay)
		{
			switch (originalText.charAt(textPos))
			{
				case ' ' | '\n':
					textPos++;

					return;
				case '^':
					final waitTime:Null<Int> = Std.parseInt(originalText.charAt(textPos + 1));

					if (waitTime != null)
					{
						originalText = originalText.substring(0, textPos) + originalText.substring(textPos + 2);

						textPos--;

						if (waitTime > 0)
						{
							typing = false;

							FlxTimer.wait(1 / (waitTime * 10), () -> typing = true);

							return;
						}
					}
					else
						textPos++;
				default:
					textPos++;
			}

			if (textPos > originalText.length)
				textPos = originalText.length;

			updateText();

			timer %= delay;

			if (sounds != null && sounds.length > 0 && !IGNORE_CHARACTERS.contains(originalText.charAt(textPos - 1)))
			{
				for (sound in sounds)
					sound.stop();

				FlxG.random.getObject(sounds).play(true);
			}
		}

		super.update(elapsed);
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
				timer = 0;
				typing = false;
			}
		}
	}

	@:noCompletion
	private function get_finished():Bool
	{
		return !typing && textPos >= originalText.length;
	}
}
