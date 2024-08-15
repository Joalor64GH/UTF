package utf.objects.dialogue;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import utf.objects.dialogue.Writer;

class DialogueBox extends FlxSpriteGroup
{
	private static final BOX_WIDTH:Int = 576;
	private static final BOX_HEIGHT:Int = 150;

	public var writer(default, null):Writer;

	@:noCompletion
	private var box:FlxShapeBox;

	public function new(showOnTop:Bool = false):Void
	{
		super();

		box = new FlxShapeBox(32, showOnTop ? 10 : 320, BOX_WIDTH, BOX_HEIGHT, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE},
			FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		writer = new Writer(box.x - 12, box.y - 10);
		writer.scrollFactor.set();
		add(writer);
	}
}
