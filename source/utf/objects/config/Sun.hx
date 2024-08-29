package utf.objects.config;

/**
 * This class exists simply because FlxShape makes it impossible to move the object using offsets and being smooth.
 */
class Sun extends flixel.addons.display.shapes.FlxShapeCircle
{
	@:noCompletion
	private override function fixBoundaries(trueWidth:Float, trueHeight:Float):Void
	{
		width = trueWidth;
		height = trueHeight;
		shapeDirty = true;
	}
}
