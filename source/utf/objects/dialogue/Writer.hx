package utf.objects.dialogue;

import flixel.FlxG;
import utf.backend.registries.TyperRegistry;
import utf.backend.AssetPaths;
import utf.input.Controls;
import utf.backend.Data;
import utf.objects.dialogue.typers.Typer;
import utf.objects.dialogue.TypeText;

using flixel.util.FlxArrayUtil;

typedef DialogueData =
{
	typer:String,
	text:String
}

class Writer extends TypeText
{
	public var skippable:Bool = true;
	public var finishCallback:Void->Void = null;

	var done:Bool = false;
	var list:Array<DialogueData> = [];
	var page:Int = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y);
	}

	public function startDialogue(list:Array<DialogueData>):Void
	{
		this.list = list ?? [
			{typer: 'default', text: 'Error!'}
		];

		page = 0;

		if (list[page] != null)
			changeDialogue(list[page]);
	}

	public function changeDialogue(dialogue:DialogueData):Void
	{
		if (dialogue == null)
			dialogue = {typer: 'default', text: 'Error!'};

		final typer:Typer = TyperRegistry.fetchTyper(dialogue.typer ?? 'default');

		if (font != typer.fontName)
			font = typer.fontName;

		if (size != typer.fontSize)
			size = typer.fontSize;

		if (typer.fontSpacing != null && letterSpacing != typer.fontSpacing)
			letterSpacing = typer.fontSpacing;

		done = false;

		start(dialogue.text, typer.typerDelay, typer.typerSounds);
	}

	override public function update(elapsed:Float):Void
	{
		if (Controls.justPressed('confirm') && finished && !done)
		{
			if (page < list.indexOf(list.last()))
			{
				page++;

				changeDialogue(list[page]);
			}
			else if (page == list.indexOf(list.last()))
			{
				if (finishCallback != null)
					finishCallback();

				done = true;
			}
		}
		else if (Controls.justPressed('cancel') && !finished && skippable)
			skip();

		super.update(elapsed);
	}
}
