package utf.objects.dialogue;

import flixel.util.FlxSignal;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import flixel.FlxG;
import utf.objects.dialogue.typers.Typer;
import utf.util.dialogue.TextParser;
import utf.util.FramerateUtil;

/**
 * Displays text with a typewriter effect, revealing characters one by one.
 * Optionally plays a sound for each character and supports skipping to the end.
 */
class TextTyper extends FlxText
{
	/**
	 * Characters that will not trigger sound playback during the typing effect.
	 */
	@:noCompletion
	private static final IGNORE_CHARACTERS:Array<String> = [' ', '\n', '*', '^', '/', '\\'];

	/**
	 * Indicates whether the text has finished typing out.
	 */
	public var finished(get, null):Bool = false;

	/**
	 * A callback that is dispatched when the dialogue tries to call a function.
	 */
	// public var onFunctionCall:FlxTypedSignal<String->Void>;

	/**
	 * Stores the original text that is being typed out.
	 */
	@:noCompletion
	private var originalText:String = '';

	@:noCompletion
	private var actions:Array<Action> = [];

	/**
	 * Current position in the text that has been revealed.
	 */
	@:noCompletion
	private var textPos:Int = 0;

	/**
	 * The `Typer` object controlling the appearance and behavior of the typing effect.
	 */
	@:noCompletion
	private var typer:Typer;

	/**
	 * Timer used to control the speed of the typing effect.
	 */
	@:noCompletion
	private var typingTimer:FlxTimer;

	/**
	 * Constructor for creating a `TextTyper` instance.
	 * @param x The x-coordinate for the text display.
	 * @param y The y-coordinate for the text display.
	 */
	public function new(x:Float, y:Float):Void
	{
		super(x, y, 0, '', 8, true);

		typingTimer = new FlxTimer();
	}

	public override function destroy():Void
	{
		super.destroy();

		// onFunctionCall = FlxDestroyUtil.destroy(onFunctionCall);
		typingTimer = FlxDestroyUtil.destroy(typingTimer);
		typer = FlxDestroyUtil.destroy(typer);
	}

	/**
	 * Starts typing out the specified text using the provided `Typer`.
	 * @param typer The `Typer` instance controlling the typing effect.
	 * @param text The text to be typed out.
	 */
	public function start(typer:Typer, text:String):Void
	{
		setupTyper(typer);

		final parsedText:ParsedText = TextParser.parse(text);

		originalText = parsedText.cleanedText;
		actions = parsedText.actions;
		textPos = 0;

		if (updateTextPos(null))
			updateText();

		typingTimer.start(FramerateUtil.SINGLE_FRAME_TIMING * typer.typerFPS, function(timer:FlxTimer):Void
		{
			if (updateTextPos(timer))
				updateText();
		}, 0);
	}

	/**
	 * Skips the typing effect, immediately displaying the full text.
	 */
	public function skip():Void
	{
		if (typingTimer.active)
		{
			textPos = originalText.length;

			if (updateTextPos(null))
				updateText();
		}
	}

	@:noCompletion
	private inline function setupTyper(typer:Typer):Void
	{
		if (this.typer != null && this.typer != typer)
			this.typer.destroy();

		if (font != typer.fontName)
			font = typer.fontName;

		if (size != typer.fontSize)
			size = typer.fontSize;

		if (typer.fontSpacing != null && letterSpacing != typer.fontSpacing)
			letterSpacing = typer.fontSpacing;

		if (offset != typer.typerOffset)
			offset.copyFrom(typer.typerOffset);

		this.typer = typer;
	}

	@:noCompletion
	private function updateTextPos(timer:FlxTimer):Bool
	{
		final currentChar:String = originalText.charAt(textPos);

		playSounds(currentChar);

		textPos++;

		if (actions != null && actions.length > 0)
		{
			for (action in actions)
			{
				if (action.index != textPos)
					continue;

				switch (action.type)
				{
					case 'speed':
						final speed:Null<Float> = Std.parseFloat(action.value);

						if (speed != null && speed > 0)
							timer.time = FramerateUtil.SINGLE_FRAME_TIMING * speed;
					case 'wait':
						final waitTime:Null<Float> = Std.parseFloat(action.value);

						if (waitTime != null && waitTime > 0)
						{
							timer.active = false;

							FlxTimer.wait(waitTime, () -> timer.active = true);

							return false;
						}
					case 'w':
						final waitTime:Null<Int> = Std.parseInt(action.value);

						if (waitTime != null && waitTime > 0)
						{
							timer.active = false;

							FlxTimer.wait(FramerateUtil.SINGLE_FRAME_TIMING * waitTime, () -> timer.active = true);

							return false;
						}
				}
			}
		}

		if (IGNORE_CHARACTERS.contains(currentChar))
			return updateTextPos(timer);

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
	private function playSounds(currentChar:String):Void
	{
		if (typer?.typerSounds != null && typer?.typerSounds?.length > 0 && !IGNORE_CHARACTERS.contains(currentChar))
		{
			final typingSound:TypingSound = typer.typerSounds[FlxG.random.int(0, typer.typerSounds.length - 1)];

			if (typingSound != null)
			{
				final sound:FlxSound = FlxG.sound.load(typingSound.sound, typingSound.volume);

				if (typingSound.pitch != null)
					sound.pitch = typingSound.pitch;

				sound.play();
			}
		}
	}

	@:noCompletion
	private function get_finished():Bool
	{
		return typingTimer.finished && textPos >= originalText.length;
	}
}
