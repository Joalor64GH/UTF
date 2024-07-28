package utf.input;

#if FLX_GAMEPAD
import flixel.input.gamepad.FlxGamepadInputID;
#end
#if FLX_KEYBOARD
import flixel.input.keyboard.FlxKey;
#end
import flixel.FlxG;

/**
 * A structure for input bindings, which includes both a keyboard key and a gamepad button.
 */
typedef Bind =
{
	/**
	 * The keyboard key associated with the action.
	 */
	key:FlxKey,
	/**
	 * The gamepad button associated with the action.
	 */
	gamepad:FlxGamepadInputID
}

/**
 * Provides static methods to handle input actions for both keyboard and gamepad.
 */
class Controls
{
	/**
	 * A map of input bindings, associating action names with specific keys and gamepad buttons.
	 */
	public static var binds(default, null):Map<String, Bind> = [
		'down' => {key: FlxKey.DOWN, gamepad: FlxGamepadInputID.DPAD_DOWN},
		'right' => {key: FlxKey.RIGHT, gamepad: FlxGamepadInputID.DPAD_RIGHT},
		'up' => {key: FlxKey.UP, gamepad: FlxGamepadInputID.DPAD_UP},
		'left' => {key: FlxKey.LEFT, gamepad: FlxGamepadInputID.DPAD_LEFT},
		'confirm' => {key: FlxKey.Z, gamepad: FlxGamepadInputID.A},
		'cancel' => {key: FlxKey.X, gamepad: FlxGamepadInputID.B},
		'menu' => {key: FlxKey.C, gamepad: FlxGamepadInputID.Y}
	];

	/**
	 * Checks if the input associated with the given tag was just pressed.
	 * @param tag The action name to check.
	 * @return true if the key or gamepad button was just pressed, false otherwise.
	 */
	public static function justPressed(tag:String):Bool
	{
		if (binds.exists(tag))
		{
			final bind:Bind = binds.get(tag);

			if (bind == null)
				return false;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, JUST_PRESSED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyJustPressed(bind.gamepad))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if the input associated with the given tag is currently pressed.
	 * @param tag The action name to check.
	 * @return true if the key or gamepad button is pressed, false otherwise.
	 */
	public static function pressed(tag:String):Bool
	{
		if (binds.exists(tag))
		{
			final bind:Bind = binds.get(tag);

			if (bind == null)
				return false;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, PRESSED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyPressed(bind.gamepad))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if the input associated with the given tag was just released.
	 * @param tag The action name to check.
	 * @return true if the key or gamepad button was just released, false otherwise.
	 */
	public static function justReleased(tag:String):Bool
	{
		if (binds.exists(tag))
		{
			final bind:Bind = binds.get(tag);

			if (bind == null)
				return false;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, JUST_RELEASED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyJustReleased(bind.gamepad))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if any of the inputs associated with the given tags were just pressed.
	 * @param tags An array of action names to check.
	 * @return true if any of the keys or gamepad buttons were just pressed, false otherwise.
	 */
	public static function anyJustPressed(tags:Array<String>):Bool
	{
		if (tags == null || tags.length <= 0)
			return false;

		for (tag in tags)
		{
			if (!binds.exists(tag))
				continue;

			final bind:Bind = binds.get(tag);

			if (bind == null)
				continue;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, JUST_PRESSED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyJustPressed(bind.gamepad))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if any of the inputs associated with the given tags are currently pressed.
	 * @param tags An array of action names to check.
	 * @return true if any of the keys or gamepad buttons are pressed, false otherwise.
	 */
	public static function anyPressed(tags:Array<String>):Bool
	{
		if (tags == null || tags.length <= 0)
			return false;

		for (tag in tags)
		{
			if (!binds.exists(tag))
				continue;

			final bind:Bind = binds.get(tag);

			if (bind == null)
				continue;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, PRESSED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyPressed(bind.gamepad))
				return true;
			#end
		}

		return false;
	}

	/**
	 * Checks if any of the inputs associated with the given tags were just released.
	 * @param tags An array of action names to check.
	 * @return true if any of the keys or gamepad buttons were just released, false otherwise.
	 */
	public static function anyJustReleased(tags:Array<String>):Bool
	{
		if (tags == null || tags.length <= 0)
			return false;

		for (tag in tags)
		{
			if (!binds.exists(tag))
				continue;

			final bind:Bind = binds.get(tag);

			if (bind == null)
				continue;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, JUST_RELEASED))
				return true;
			#end

			#if FLX_GAMEPAD
			if (FlxG.gamepads.anyJustReleased(bind.gamepad))
				return true;
			#end
		}

		return false;
	}
}
