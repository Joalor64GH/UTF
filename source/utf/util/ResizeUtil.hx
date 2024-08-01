package utf.util;

import flixel.FlxG;

/**
 * Utility class for handling resizing events and managing cached bitmap data.
 */
class ResizeUtil
{
	/**
	 * Initializes the resize utility by setting up the resize event listener.
	 */
	public static function init():Void
	{
		FlxG.signals.gameResized.add(onResizeGame);
	}

	@:access(openfl.display.Sprite)
	private static inline function onResizeGame(width:Int, height:Int):Void
	{
		if (FlxG.cameras?.list?.length > 0)
		{
			for (camera in FlxG.cameras.list)
			{
				if (camera?.filters?.length > 0)
				{
					if (camera.flashSprite != null)
					{
						camera.flashSprite.__cacheBitmap = null;
						camera.flashSprite.__cacheBitmapData = null;
						camera.flashSprite.__cacheBitmapData2 = null;
						camera.flashSprite.__cacheBitmapData3 = null;
						camera.flashSprite.__cacheBitmapColorTransform = null;
					}
				}
			}
		}

		if (FlxG.game != null)
		{
			FlxG.game.__cacheBitmap = null;
			FlxG.game.__cacheBitmapData = null;
			FlxG.game.__cacheBitmapData2 = null;
			FlxG.game.__cacheBitmapData3 = null;
			FlxG.game.__cacheBitmapColorTransform = null;
		}
	}
}
