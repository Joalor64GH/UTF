package utf.objects.dialogue;

import flixel.FlxG;
import utf.registries.TyperRegistry;
import utf.AssetPaths;
import utf.input.Controls;
import utf.Data;
import utf.objects.dialogue.typers.Typer;
import utf.objects.dialogue.TypeText;

using flixel.util.FlxArrayUtil;

typedef WriterData =
{
	typer:String,
	text:String
}

/**
 * Represents a dialogue writer that displays text sequentially, allowing the player to advance or skip through dialogue pages.
 * Handles the display of dialogue using different typers and invokes a callback when the dialogue is finished.
 */
class Writer extends TypeText
{
	/**
	 * Determines whether the player can skip the dialogue text.
	 */
	public var skippable:Bool = true;

	/**
	 * Callback function to be executed when all dialogue pages are completed.
	 */
	public var finishCallback:Void->Void = null;

	/**
	 * Indicates whether the dialogue has been completed.
	 */
	@:noCompletion
	private var done:Bool = false;

	/**
	 * A list of `WriterData` objects, each containing a typer and text for the dialogue.
	 */
	@:noCompletion
	private var list:Array<WriterData> = [];

	/**
	 * The current page of the dialogue being displayed.
	 */
	@:noCompletion
	private var page:Int = 0;

	/**
	 * Starts the dialogue sequence with the provided list of dialogue data.
	 * @param list The list of `WriterData` objects representing the dialogue pages.
	 */
	public function startDialogue(list:Array<WriterData>):Void
	{
		this.list = list ?? [{typer: 'default', text: 'Error!'}];
		page = 0;

		if (list[page] != null)
			changeDialogue(list[page]);
	}

	/**
	 * Changes the current dialogue page to the specified `WriterData`.
	 * @param dialogue The `WriterData` object containing the typer and text for the dialogue page.
	 */
	public function changeDialogue(dialogue:WriterData):Void
	{
		if (dialogue == null)
			dialogue = {typer: 'default', text: 'Error!'};

		done = false;

		start(TyperRegistry.fetchTyper(dialogue.typer ?? 'default'), dialogue.text);
	}


	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

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
	}
}
