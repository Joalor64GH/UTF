import flixel.FlxG;
import utf.backend.AssetPaths;
import utf.objects.dialogue.typers.Typer;

class Default extends Typer
{
	public function new():Void
	{
		super('default');

		fontName = AssetPaths.font('DTM-Mono');
		fontSize = 32;
		typerSounds = [FlxG.sound.load(AssetPaths.sound('txt1'), 1)];
		typerDelay = 0.05;
	}
}
