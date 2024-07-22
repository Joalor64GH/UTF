package utf.objects.debug;

import flixel.util.FlxStringUtil;
import openfl.display.FPS;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.Lib;
import utf.backend.AssetPaths;

/**
 * This class extends `FPS` and is used to display the current frame rate (FPS)
 * and optionally the memory usage of the application. It updates the FPS count and memory usage
 * in real-time and renders them in a text field overlay.
 *
 * @see https://github.com/openfl/openfl/blob/develop/src/openfl/display/FPS.hx
 */
class Overlay extends FPS
{
	/**
	 * The current memory usage of the application, in bytes.
	 */
	public var currentMemory(default, null):Int = 0;

	@:noCompletion
	private var cacheMemory:Int = 0;

	/**
	 * Constructs an instance with specified position and text color.
	 *
	 * @param x The x-coordinate of the overlay position. Default is 10.
	 * @param y The y-coordinate of the overlay position. Default is 10.
	 * @param color The color of the text in the overlay. Default is white (0xFFFFFFFF).
	 */
	public function new(x:Float = 10, y:Float = 10, color:Int = 0xFFFFFFFF):Void
	{
		super(x, y, color);

		final textFormat:TextFormat = defaultTextFormat;
		textFormat.font = AssetPaths.font('DTM-Sans');
		textFormat.size = 16;
		setTextFormat(textFormat);
	}

	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;

		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		final currentCount:Int = times.length;

		currentFPS = Math.round((currentCount + cacheCount) / 2);
		currentMemory = System.totalMemory;

		if (currentCount != cacheCount || currentMemory != cacheMemory)
		{
			text = Std.string(currentFPS);

			#if debug
			text += '\n${FlxStringUtil.formatBytes(currentMemory)}';
			#end
		}

		cacheCount = currentCount;
		cacheMemory = currentMemory;
	}
}
