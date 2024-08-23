package;

import format.gif.Data;
import format.gif.Reader;
import format.gif.Tools;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import lime.app.Event;
import openfl.display.BitmapData;

@:nullSafety
class GifPlayer
{
	public var bitmapData:BitmapData;

	public var onGraphicLoaded:Event<Void->Void>;
	public var onProccessBlock:Event<Int->Void>;
	public var onEndOfFile:Event<Void->Void>;

	private var blockIndex:Int = 0;
	private var blocks:Array<Block> = [];

	private var cachedFrames:Map<Int, Bytes> = [];
	private var cacheFrames:Bool = true;
	private var currentFrame:Int = 0;

	private var data:Data;

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
		blocks = [];
		cachedFrames = [];

		data = new Reader(new BytesInput(bytes)).read();

		if (bitmapData != null
			&& (bitmapData.width != data.logicalScreenDescriptor.width || bitmapData.height != data.logicalScreenDescriptor.height))
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		bitmapData = new BitmapData(data.logicalScreenDescriptor.width, data.logicalScreenDescriptor.height, 0, true);

		if (onGraphicLoaded != null)
			onGraphicLoaded();
	}

	public function play():Void
	{
		currentFrame = 0;
		blockIndex = 0;
		processBlock();
	}

	public function dispose():Void
	{
		blocks = null;
		cachedFrames = null;
	}

	@:noCompletion
	private function processBlock():Void
	{
		if (blockIndex >= data.blocks.length)
		{
			if (onEndOfFile != null)
				onEndOfFile();

			return;
		}

		if (onProccessBlock != null)
			onProccessBlock.dispatch(blockIndex);

		switch (data.blocks[blockIndex])
		{
			case BFrame(_):
				handleFrame();
			case BExtension(EGraphicControl(gce)):
				handleGraphicControlExtension(gce);
			case BEOF:
				if (onEndOfFile != null)
					onEndOfFile();
		}
	}

	@:noCompletion
	private function handleFrame():Void
	{
		if (cachedFrames != null)
		{
			if (!cachedFrames.exists(currentFrame))
				cachedFrames.set(currentFrame, Tools.extractFullRGBA(data, currentFrame));

			if (bitmapData != null)
				bitmapData.setPixels(bitmapData.rect, cachedFrames.get(currentFrame));
		}

		nextBlock();
	}

	@:noCompletion
	private function handleGraphicControlExtension(gce:GraphicControlExtension):Void
	{
		var delayMs:Float = gce.delay * 10;

		if (frameRate != null)
			delayMs = Std.int(1000 / frameRate);

		if (currentFrame > 0)
		{
			Timer.delay(function():Void
			{
				nextBlock(false);
			}, delayMs);
		}
		else
			nextBlock(false);
	}

	@:noCompletion
	private inline function nextBlock(?advanceCurrentFrame:Bool = true):Void
	{
		if (advanceCurrentFrame)
			currentFrame++;

		blockIndex++;
		processBlock();
	}
}
