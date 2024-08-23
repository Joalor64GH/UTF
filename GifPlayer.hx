package;

import flixel.util.FlxDestroyUtil;
import format.gif.Data;
import format.gif.Reader;
import format.gif.Tools;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import lime.app.Event;
import openfl.display.BitmapData;

@:nullSafety
class GifPlayer implements IFlxDestroyable
{
	public var bitmapData:BitmapData;

	public var onGraphicLoaded:Event<Void->Void>;
	public var onProccessBlock:Event<Int->Void>;
	public var onEndOfFile:Event<Void->Void>;

	@:noCompletion
	private var blockIndex:Int = 0;

	@:noCompletion
	private var cachedFrames:Map<Int, Bytes> = [];

	@:noCompletion
	private var currentFrame:Int = 0;

	@:noCompletion
	private var data:Data;

	@:noCompletion
	private var delay:Float = 0;

	@:noCompletion
	private var isPlaying:Bool = false;

	@:noCompletion
	private var isPaused:Bool = false;

	@:noCompletion
	private var timeCounter:Float = 0;

	public function new():Void
	{
		onGraphicLoaded = new Event<Void->Void>();
		onProccessBlock = new Event<Int->Void>();
		onEndOfFile = new Event<Void->Void>();
	}

	public function load(bytes:Bytes):Void
	{
		currentFrame = 0;
		blockIndex = 0;
		timeCounter = 0;
		data = new Reader(new BytesInput(bytes)).read();
		cachedFrames = [];

		if (bitmapData != null
			&& (bitmapData.width != data.logicalScreenDescriptor.width || bitmapData.height != data.logicalScreenDescriptor.height))
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		bitmapData = new BitmapData(data.logicalScreenDescriptor.width, data.logicalScreenDescriptor.height, 0, true);

		if (onGraphicLoaded != null)
			onGraphicLoaded.dispatch();
	}

	public function play():Void
	{
		if (!isPlaying)
		{
			isPlaying = true;
			isPaused = false;
			currentFrame = 0;
			blockIndex = 0;
			timeCounter = 0;

			processBlock();
		}
	}

	public function stop():Void
	{
		isPlaying = false;
		isPaused = false;
		currentFrame = 0;
		blockIndex = 0;
		timeCounter = 0;
	}

	public function pause():Void
	{
		if (isPlaying && !isPaused)
			isPaused = true;
	}

	public function resume():Void
	{
		if (isPlaying && isPaused)
			isPaused = false;
	}

	public function update(elapsed:Float):Void
	{
		if (!isPlaying || isPaused)
			return;

		timeCounter += elapsed;

		if (timeCounter >= delay)
		{
			timeCounter -= delay;

			processBlock();
		}
	}

	public function destroy():Void
	{
		stop();

		if (bitmapData != null)
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		data = null;
		cachedFrames = null;

		if (onGraphicLoaded != null)
			onGraphicLoaded.removeAll();

		onGraphicLoaded = null;

		if (onProccessBlock != null)
			onProccessBlock.removeAll();

		onProccessBlock = null;

		if (onEndOfFile != null)
			onEndOfFile.removeAll();

		onEndOfFile = null;
	}

	@:noCompletion
	private function processBlock():Void
	{
		if (!isPlaying)
			return;

		if (blockIndex >= data.blocks.length)
		{
			isPlaying = false;

			if (onEndOfFile != null)
				onEndOfFile.dispatch();

			return;
		}

		if (onProccessBlock != null)
			onProccessBlock.dispatch(blockIndex);

		switch (data.blocks[blockIndex])
		{
			case BFrame(_):
				if (!cachedFrames.exists(currentFrame))
					cachedFrames.set(currentFrame, Tools.extractFullRGBA(data, currentFrame));

				if (bitmapData != null)
					bitmapData.setPixels(bitmapData.rect, cachedFrames.get(currentFrame));

				nextBlock();
			case BExtension(EGraphicControl(gce)):
				delay = gce.delay / 100;
			case BEOF:
				isPlaying = false;

				if (onEndOfFile != null)
					onEndOfFile.dispatch();
		}
	}

	@:noCompletion
	private inline function nextBlock(?advanceCurrentFrame:Bool = true):Void
	{
		if (advanceCurrentFrame)
			currentFrame++;

		blockIndex++;
	}
}
