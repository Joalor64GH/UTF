package utf.util;

import flixel.util.FlxAxes;
import flixel.FlxObject;
import flixel.FlxSprite;

using utf.util.ObjectUtil;

/**
 * Represents the character within a room.
 */
class Chara extends FlxSprite
{
	public var hitbox:FlxObject;

	public function new(?x:Float = 0, ?y:Float = 0):Void
	{
		super(x, y);
	}

	/**
	 * Initializes the hitbox for the character.
	 */
	public function initializeHitbox():Void
	{
		hitbox = new FlxObject(x, y, 16, 4);
		hitbox.centerOverlay(this, FlxAxes.X);
		hitbox.y = y + height - hitbox.height;
	}

	public override function update(elapsed:Float):Void
	{
		if (hitbox != null)
			hitbox.update(elapsed);

		super.update(elapsed);
	}

	public override function draw():Void
	{
		super.draw();

		if (hitbox != null)
			hitbox.draw();
	}
}
