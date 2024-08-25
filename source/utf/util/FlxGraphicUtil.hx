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
	 * @return A new FlxGraphic containing the specified region of the source graphic, or an existing one if it is already cached, or null if the source graphic is invalid.
	 */
	@:access(flixel.graphics.FlxGraphic)
	public static function fromRegion(graphic:FlxGraphicAsset, region:FlxRect):Null<FlxGraphic>
	{
		final graph:FlxGraphic = FlxG.bitmap.add(graphic);

		if (graph == null || graph.bitmap == null)
			return null;

		final key:String = '${graph.key}_Region:${region.x}_${region.y}_${region.width}_${region.height}';

		if (!FlxG.bitmap.checkCache(key))
		{
			FlxG.log.notice('Creating "$key" from "${graph.key}"');

			final portion:BitmapData = new BitmapData(Math.floor(region.width), Math.floor(region.height), true, 0);
			portion.copyPixels(graph.bitmap, new Rectangle(region.x, region.y, region.width, region.height), new Point(0, 0));

			region.put();

			final portionGraphic:FlxGraphic = new FlxGraphic(key, portion);
			FlxG.bitmap.addGraphic(portionGraphic);
			return portionGraphic;
		}

		FlxG.log.notice('Reusing "$key" from cache');

		region.put();

		return FlxG.bitmap.get(key);
	}
}
