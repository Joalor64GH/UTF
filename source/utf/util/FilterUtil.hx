package utf.util;

import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;

/**
 * Utility class for managing color filters.
 */
class FilterUtil
{
	/**
	 * Map of color blindness simulation filters as arrays of floats.
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
	 */
	public static function getFilter(name:String):BitmapFilter
	{
		final matrix:Array<Float> = filters.get(name);

		if (matrix != null && matrix.length > 0)
			return new ColorMatrixFilter(matrix);
		else
			return null;
	}
}
