package utf.util;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.FlxG;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * Utility class for handling FlxGraphic operations.
 */
class FlxGraphicUtil
{
	/**
	 * Creates a new FlxGraphic from a specified region of an existing graphic.
	 * @param graphic The source graphic asset to partition.
	 * @param region The rectangular region of the source graphic to copy.
	 * @param unique Whether the graphic should be unique in the FlxG bitmap cache.
	 * @param key Optional key for the bitmap cache.
	 * @return A new FlxGraphic containing the specified region of the source graphic, or null if the source graphic is invalid.
	 */
	public static function fromRegion(graphic:FlxGraphicAsset, region:FlxRect, ?unique:Bool = false, ?key:String):FlxGraphic
	{
		// Add the graphic to the FlxG bitmap cache
		final graph:FlxGraphic = FlxG.bitmap.add(graphic, unique, key);

		// Return null if the graphic or its bitmap is invalid
		if (graph == null || graph.bitmap == null)
			return null;

		// Create a new BitmapData object with the dimensions of the specified region
		final portion:BitmapData = new BitmapData(region.width, region.height, true, 0);

		// Copy pixels from the specified region of the original graphic to the new BitmapData object
		portion.copyPixels(graph.bitmap, new Rectangle(region.x, region.y, region.width, region.height), new Point(0, 0));

		// Release the FlxRect back to the object pool
		region.put();

		// Return a new FlxGraphic created from the BitmapData portion
		return FlxGraphic.fromBitmapData(portion);
	}
}
