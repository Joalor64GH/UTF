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

	private var data:Data;
	private var blocks:Array<Block> = [];
	private var frameCount:Int = 0;
	private var currentFrame:Int = 0;
	private var blockIndex:Int = 0;
	private var cachedFrames:Map<Int, Bytes> = [];
	private var useCache:Bool = true;

	public function new(?useCache:Bool = true, ?preCache:Bool = false):Void
	{
		this.useCache = useCache;
		this.preCache = preCache;

		onPreProccessStart = new Event<Void->Void>();
		onPreProccessFinish = new Event<Void->Void>();
		onProccessBlock = new Event<Int->Void>();
		onEndOfFile = new Event<Void->Void>();
	}

	public function load(bytes:Bytes):Void
	{
		frameCount = 0;
		currentFrame = 0;
		blockIndex = 0;
		blocks = [];
		cachedFrames = [];

		data = new Reader(new BytesInput(gifBytes)).read();

		if (bitmapData != null && (bitmapData.width != data.logicalScreenDescriptor.width || bitmapData.height != data.logicalScreenDescriptor.height))
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
		cachesFrames = null;
	}

	@:noCompletion
	private function processBlock():Void
	{
		if (onProccessBlock != null)
			onProccessBlock.dispatch(blockIndex);

		switch (data.blocks[blockIndex])
		{
			case BFrame(_):
				var pixels:Bytes = null;

				if (useCache && cachedFrames != null && cachedFrames.exists(currentFrame))
					pixels = cachedFrames.get(currentFrame);

				if (pixels == null)
				{
					pixels = Tools.extractFullRGBA(data, currentFrame);

					if (useCache && cachedFrames != null)
						cachedFrames.set(currentFrame, pixels);
				}

				if (bitmapData != null)
					bitmapData.setPixels(bitmapData.rect, pixels);

				nextBlock();
			case BExtension(EGraphicControl(gce)):
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
			case BEOF:
				if (onEndOfFile != null)
					onEndOfFile();
			default:
				nextBlock(false);
		}
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
