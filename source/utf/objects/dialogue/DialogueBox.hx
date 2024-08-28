package utf.objects.dialogue;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import utf.objects.dialogue.portraits.Portrait;
import utf.objects.dialogue.Writer;

/**
 * A dialogue box that displays text in a defined area on the screen.
 * This class is responsible for creating and managing the visual representation
 * of the dialogue box, including the background box and the writer that displays text.
 */
class DialogueBox extends FlxSpriteGroup
{
	/**
	 * The width of the dialogue box.
	 */
	@:noCompletion
	private static final BOX_WIDTH:Int = 576;

	/**
	 * The height of the dialogue box.
	 */
	@:noCompletion
	private static final BOX_HEIGHT:Int = 150;

	/**
	 * The background box of the dialogue, rendered as a `FlxShapeBox`.
	 */
	@:noCompletion
	private var box:FlxShapeBox;

	public var portrait(default, null):Portrait;

	/**
	 * The writer responsible for displaying text within the dialogue box.
	 */
	public var writer(default, null):Writer;

	/**
	 * Constructor for creating a `DialogueBox` instance.
	 * @param showOnTop Determines whether the dialogue box should be shown at the top of the screen.
	 */
	public function new(?showOnTop:Bool = false):Void
	{
		super();

		box = new FlxShapeBox(32, showOnTop ? 10 : 320, BOX_WIDTH, BOX_HEIGHT, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		portrait = new Portrait('unknown');
		portrait.scrollFactor.set();
		add(portrait);

		writer = new Writer(box.x, box.y);
		writer.onPortraitChange(function(portrait:String):Void
		{
			switch (portrait)
			{
				case '':
					writer.setPosition(box.x, box.y);
				default:
					portrait = PortraitRegistry.fetchPortrait(portrait);
					portrait.setPosition(box.x, box.y);
					portrait.scrollFactor.set();
					add(portrait);

					writer.setPosition(box.x + 104, box.y);
			}
		});
		writer.onFaceChange.add(function(expression:String):Void
		{
			if (portrait != null)
				portrait.changeFace(expression);
		});
		writer.scrollFactor.set();
		add(writer);
	}

	public function setOnTop(?value:Bool = false):Void
	{
		box.setPosition(32, value ? 10 : 320);
		portrait?.setPosition(box.x, box.y);
		writer.setPosition(box.x, box.y);
	}

	/**
	 * Starts the dialogue sequence with the provided list of dialogue data.
	 * @param list The list of `WriterData` objects representing the dialogue pages.
	 */
	public inline function startDialogue(list:Array<WriterData>):Void
	{
		writer.startDialogue(list);
	}
}
