package utf.backend;

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
		if (!binds.exists(tag))
			return false;

		#if FLX_KEYBOARD
		if (FlxG.keys.checkStatus(binds.get(tag).key, JUST_PRESSED))
			return true;
		#end

		#if FLX_GAMEPAD
		if (FlxG.gamepads.anyJustPressed(binds.get(tag).gamepad))
			return true;
		#end
	}

	/**
	 * Checks if the input associated with the given tag is currently pressed.
	 * @param tag The action name to check.
	 * @return true if the key or gamepad button is pressed, false otherwise.
	 */
	public static function pressed(tag:String):Bool
	{
		if (!binds.exists(tag))
			return false;

		#if FLX_KEYBOARD
		if (FlxG.keys.checkStatus(binds.get(tag).key, PRESSED)
			return true;
		#end

		#if FLX_GAMEPAD
		if (FlxG.gamepads.anyPressed(binds.get(tag).gamepad))
			return true;
		#end
	}

	/**
	 * Checks if the input associated with the given tag was just released.
	 * @param tag The action name to check.
	 * @return true if the key or gamepad button was just released, false otherwise.
	 */
	public static function justReleased(tag:String):Bool
	{
		if (!binds.exists(tag))
			return false;

		#if FLX_KEYBOARD
		if (FlxG.keys.checkStatus(binds.get(tag).key, JUST_RELEASED)
			return true;
		#end

		#if FLX_GAMEPAD
		if (FlxG.gamepads.anyJustReleased(binds.get(tag).gamepad))
			return true;
		#end
	}
}
