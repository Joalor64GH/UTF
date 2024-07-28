package utf.objects.room;

import flixel.FlxObject;
import flixel.FlxSprite;
import utf.input.Controls;

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
		characterHitbox = new FlxObject(x + (this.width - width) / 2, y + this.height - height, width, height);
	}

	public override function setPosition(x:Float = 0.0, y:Float = 0.0):Void
	{
		super.setPosition(x, y);

		if (characterHitbox != null)
			characterHitbox.setPosition(x + (this.width - characterHitbox.width) / 2, y + this.height - characterHitbox.height);
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (characterHitbox != null)
		{
			characterHitbox.update(elapsed);

			x = characterHitbox.x - (this.width - characterHitbox.width) / 2;
			y = characterHitbox.y + characterHitbox.height - this.height;
		}
	}

	public override function draw():Void
	{
		super.draw();

		if (characterHitbox != null)
		{
			characterHitbox.draw();

			#if FLX_DEBUG
			if (Controls.pressed('confirm'))
				characterHitbox.drawDebug();
			#end
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		if (characterHitbox != null)
			characterHitbox.destroy();
	}
}
