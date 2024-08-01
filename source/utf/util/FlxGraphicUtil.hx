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
		final graph:FlxGraphic = FlxG.bitmap.add(graphic, unique, key);

		if (graph == null || graph.bitmap == null)
			return null;

		final portion:BitmapData = new BitmapData(Math.floor(region.width), Math.floor(region.height), true, 0);
		portion.copyPixels(graph.bitmap, new Rectangle(region.x, region.y, region.width, region.height), new Point(0, 0));

		region.put();

		return FlxGraphic.fromBitmapData(portion);
	}
}
