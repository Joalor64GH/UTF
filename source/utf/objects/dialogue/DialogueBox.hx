package utf.objects.dialogue;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import utf.objects.dialogue.portraits.Portrait;
import utf.objects.dialogue.Writer;
import utf.registries.dialogue.PortraitRegistry;

/**
 * A dialogue box that displays text in a defined area on the screen.
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
	 * A callback function that is triggered when the dialogue sequence finishes.
	 */
	public var finishCallback:Void->Void;

	/**
	 * The background box of the dialogue, rendered as a `FlxShapeBox`.
	 */
	@:noCompletion
	private var box:FlxShapeBox;

	/**
	 * The portrait displayed in the dialogue box, representing the speaker.
	 */
	@:noCompletion
	private var portrait:Portrait;

	/**
	 * The writer responsible for displaying text within the dialogue box.
	 */
	@:noCompletion
	private var writer(default, null):Writer;

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

		writer = new Writer(box.x, box.y);
		writer.finishCallback = function():Void
		{
			if (finishCallback != null)
				finishCallback();
		}
		writer.onPortraitChange.add(function(id:String):Void
		{
			if (id == null || id.length <= 0)
				writer.setPosition(box.x, box.y);
			else if (portrait == null || portrait.portraitID != id)
			{
				if (portrait != null)
					remove(portrait);

				portrait = PortraitRegistry.fetchPortrait(id);
				portrait.setPosition(box.x, box.y);
				portrait.scrollFactor.set();
				insert(members.indexOf(box) + 1, portrait);

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

		if (portrait != null)
		{
			portrait.setPosition(box.x, box.y);
			writer.setPosition(box.x + 104, box.y);
		}
		else
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
