package utf.util;

import flixel.FlxObject;
import flixel.FlxSprite;

using utf.util.ObjectUtil;

/**
 * Represents a character within a room, including an associated hitbox.
 */
class Chara extends FlxSprite
{
	/**
	 * The ID of the character.
	 */
	public var characterID:String;

	/**
	 * The hitbox associated with the character.
	 */
	public var characterHitbox:FlxObject;

	/**
	 * Constructor to initialize the character with a specified ID.
	 * @param characterID The ID of the character.
	 */
	public function new(characterID:String):Void
	{
		super();

		this.characterID = characterID;
	}

	/**
	 * Initializes the hitbox for the character and aligns it with the character sprite.
	 */
	public function initializeHitbox():Void
	{
		characterHitbox = new FlxObject(x, y, 16, 4);
		characterHitbox.centerOverlay(this, X);
		characterHitbox.y = y + height - characterHitbox.height;
	}

	public override function update(elapsed:Float):Void
	{
		if (characterHitbox != null)
			characterHitbox.update(elapsed);

		super.update(elapsed);
	}

	public override function draw():Void
	{
		super.draw();

		if (characterHitbox != null)
			characterHitbox.draw();
	}

	public override function destroy():Void
	{
		super.destroy();

		if (characterHitbox != null)
			characterHitbox.destroy();
	}
}
