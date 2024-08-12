package utf.util;

import flixel.FlxG;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;
import utf.Data;

/**
 * Utility class for managing color filters.
 * Provides predefined color matrices that simulate various types of color blindness and
 * allows creating ColorMatrixFilter instances for use in image processing.
 */
class FilterUtil
{
	/**
	 * Map of color blindness simulation filters as arrays of floats.
	 * Each entry represents a color matrix that can be used to simulate specific types of color blindness.
	 */
	@:noCompletion
	private static final filters:Map<String, Array<Float>> = [
		'deuteranopia' => [
			0.43, 0.72, -.15, 0, 0,
			0.34, 0.57, 0.09, 0, 0,
			-.02, 0.03,    1, 0, 0,
			   0,    0,    0, 1, 0
		],
		'protanopia' => [
			0.20, 0.99, -.19, 0, 0,
			0.16, 0.79, 0.04, 0, 0,
			0.01, -.01,    1, 0, 0,
			   0,    0,    0, 1, 0
		],
		'tritanopia' => [
			0.97, 0.11, -.08, 0, 0,
			0.02, 0.82, 0.16, 0, 0,
			0.06, 0.88, 0.18, 0, 0,
			   0,    0,    0, 1, 0
		],
		'achromatomaly' => [
			0.618,  0.32, 0.062, 0, 0,
			0.163, 0.775, 0.062, 0, 0,
			0.163,  0.32, 0.518, 0, 0,
			    0,     0,     0, 1, 0
		],
		'deuteranomaly' => [
			  0.8,   0.2,     0, 0, 0,
			0.258, 0.742,     0, 0, 0,
			    0, 0.142, 0.858, 0, 0,
			    0,     0,     0, 1, 0
		],
		'protanomaly' => [
			0.817, 0.183,     0, 0, 0,
			0.333, 0.667,     0, 0, 0,
			    0, 0.125, 0.875, 0, 0,
			    0,     0,     0, 1, 0
		],
		'tritanomaly' => [
			0.967, 0.033,     0, 0, 0,
			    0, 0.733, 0.267, 0, 0,
			    0, 0.183, 0.817, 0, 0,
			    0,     0,     0, 1, 0
		]
	];

	/**
	 * Retrieves a ColorMatrixFilter based on the provided filter name.
	 *
	 * @param name The name of the filter (e.g., 'deuteranopia', 'protanopia').
	 * @return A ColorMatrixFilter instance representing the color transformation for the specified color blindness type, or null if the filter does not exist.
	 */
	public static function getFilter(name:String):Null<BitmapFilter>
	{
		final matrix:Array<Float> = filters.get(name);

		if (matrix != null && matrix.length > 0)
			return new ColorMatrixFilter(matrix);
		else
			return null;
	}

	/**
	 * Retrieves the list of available filter names.
	 *
	 * @return An array of strings representing the keys in the filters map.
	 */
	public static function getFiltersKeys():Array<String>
	{
		return Lambda.array(filters.keys());
	}

	/**
	 * Reloads and applies a specified color filter to the game.
	 *
	 * @param filter The name of the filter to apply.
	 */
	public static function reloadGameFilter(filter:String):Void
	{
		if (getFiltersKeys().contains(filter))
		{
			// Save the selected filter in the settings
			Data.settings.set('filter', filter);

			// Retrieve the filter and apply it to the game
			final bitmapFilter:Null<BitmapFilter> = getFilter(Data.settings.get('filter'));

			if (bitmapFilter != null)
				FlxG.game.setFilters([bitmapFilter]);
		}
	}
}
