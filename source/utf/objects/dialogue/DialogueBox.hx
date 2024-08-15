package utf.objects.dialogue;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import utf.objects.dialogue.Writer;

typedef DialogueData =
{
	> WriterData,

	portrait:String
	?face:String,
}

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
	 * The writer responsible for displaying text within the dialogue box.
	 */
	public var writer(default, null):Writer;

	/**
	 * The background box of the dialogue, rendered as a `FlxShapeBox`.
	 */
	@:noCompletion
	private var box:FlxShapeBox;

	/**
	 * Constructor for creating a `DialogueBox` instance.
	 * @param showOnTop Determines whether the dialogue box should be shown at the top of the screen.
	 */
	public function new(showOnTop:Bool = false):Void
	{
		super();

		box = new FlxShapeBox(32, showOnTop ? 10 : 320, BOX_WIDTH, BOX_HEIGHT, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		writer = new Writer(box.x, box.y);
		writer.scrollFactor.set();
		add(writer);
	}
}
