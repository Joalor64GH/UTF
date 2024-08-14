package utf.objects.dialogue;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.util.FlxColor;
import utf.objects.dialogue.Writer;

class DialogueBox extends FlxSpriteGroup
{
	public var writer(default, null):Writer;

	@:noCompletion
	private var box:FlxShapeBox;

	public function new(showOnTop:Bool = false):Void
	{
		box = new FlxShapeBox(32, showOnTop ? 10 : 320, 576, 150, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE},
			FlxColor.BLACK);
		box.scrollFactor.set();
		box.active = false;
		add(box);

		writer = new Writer(box.x + 20, box.y + 10);
		writer.scrollFactor.set();
		add(writer);
	}
}
