package utf.util;

/**
 * Utility class for date-related functions.
 */
class DateUtil
{
	/**
	 * Get the current season as a number.
	 *
	 * @return 1 for Winter, 2 for Spring, 3 for Summer, 4 for Autumn.
	 */
	public static function getWeather():Int
	{
		final curDate:Date = Date.now();

		switch (curDate.getMonth() + 1)
		{
			case 12 | 1 | 2:
				return 1;
			case 3 | 4 | 5:
				return 2;
			case 6 | 7 | 8:
				return 3;
			case 9 | 10 | 11:
				return 4;
		}

		return 0;
	}
}
