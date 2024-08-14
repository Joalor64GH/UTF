package utf;

import flixel.system.scaleModes.RatioScaleMode;

/**
 * Custom scale mode that scales the game size based on a specified percentage of the original size.
 */
class PercentOfHeightScaleMode extends RatioScaleMode
{
	/**
	 * The percentage by which to scale the game size.
	 */
	@:noCompletion
	private var percent:Float;

	/**
	 * Creates a new `PercentOfHeightScaleMode` instance.
	 * @param percent The percentage by which to scale the game size.
	 */
	public function new(percent:Float):Void
	{
		super();

		this.percent = percent;
	}

	public override function updateScaleOffset():Void
	{
		gameSize.scale(percent);

		super.updateScaleOffset();
	}
}
