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
	 * A callback that is dispatched when the dialogue tries to call a function.
	 */
	public var onFunctionCall:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

	/**
	 * A callback that is dispatched when the dialogue tries to change the face.
	 */
	public var onFaceChange:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

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

	@:noCompletion
	private var delay:Float = 0;

	@:noCompletion
	private var counter:Float = 0;

	@:noCompletion
	private var typing:Bool = false;

	@:noCompletion
	private var waiting:Bool = false;

	@:noCompletion
	private var finished:Bool = false;

	/**
	 * Constructor for creating a `TextTyper` instance.
	 * @param x The x-coordinate for the text display.
	 * @param y The y-coordinate for the text display.
	 */
	public function new(x:Float, y:Float):Void
	{
		super(x, y, 0, '', 8, true);
	}

	public override function update(elapsed:Float):Void
	{
		if (typing && !finished)
		{
			counter += elapsed;

			while (counter >= delay && !waiting)
			{
				counter -= delay;

				processText();
			}
		}

		super.update(elapsed);
	}

	public override function destroy():Void
	{
		super.destroy();

		counter = 0;
		typing = false;
		finished = true;
		waiting = false;
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

		counter = 0;
		waiting = finished = false;
		textPos = 0;

		final parsedText:ParsedText = TextParser.parse(text);

		originalText = parsedText.cleanedText;
		actions = parsedText.actions;

		processText();

		typing = true;
	}

	/**
	 * Skips the typing effect, immediately displaying the full text.
	 */
	public function skip():Void
	{
		if (typing && !waiting && !finished)
		{
			textPos = originalText.length;

			processText();
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

		delay = FramerateUtil.SINGLE_FRAME_TIMING * typer.typerFPS;

		this.typer = typer;
	}

	@:noCompletion
	private function processText():Void
	{
		processActions();

		if (updateTextPos())
			updateText();
	}

	@:noCompletion
	private function updateTextPos():Bool
	{
		final currentChar:String = originalText.charAt(textPos);

		playSounds(currentChar);

		textPos++;

		if (IGNORE_CHARACTERS.contains(currentChar))
			return updateTextPos();

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
				counter = 0;
				typing = false;
				finished = true;
				waiting = false;
			}
		}
	}

	@:noCompletion
	private function processActions():Bool
	{
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
							delay = FramerateUtil.SINGLE_FRAME_TIMING * speed;
					case 'wait':
						final waitTime:Null<Float> = Std.parseFloat(action.value);

						if (waitTime != null && waitTime > 0)
						{
							waiting = true;

							FlxTimer.wait(waitTime, () -> waiting = false);
						}
					case 'w':
						final waitTime:Null<Int> = Std.parseInt(action.value);

						if (waitTime != null && waitTime > 0)
						{
							waiting = true;

							FlxTimer.wait(FramerateUtil.SINGLE_FRAME_TIMING * waitTime, () -> waiting = false);
						}
					case 'function':
						if (onFunctionCall != null)
							onFunctionCall.dispatch(action.value);
					case 'face':
						if (onFaceChange != null)
							onFaceChange.dispatch(action.value);
				}
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
}
