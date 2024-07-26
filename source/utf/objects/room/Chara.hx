package utf.objects.room;

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
	 * @param width The width of the hitbox.
	 * @param height The height of the hitbox.
	 */
	public function initializeHitbox(width:Float, height:Float):Void
	{
		characterHitbox = new FlxObject(x, y, width, height);
		characterHitbox.centerObject(this, X);
		characterHitbox.y = y + height - characterHitbox.height;
	}

	public override function update(elapsed:Float):Void
	{
		if (characterHitbox != null)
		{
			centerObject(characterHitbox, X);

			y = characterHitbox.y - (characterHitbox.height - height);

			characterHitbox.update(elapsed);
		}

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
