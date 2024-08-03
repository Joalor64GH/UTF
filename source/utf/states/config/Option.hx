package utf.states;

import flixel.math.FlxMath;

/**
 * Enum defining the types of options available.
 */
enum OptionType
{
	Toggle;
	Integer(min:Int, max:Int, step:Int);
	Decimal(min:Float, max:Float, step:Float);
	Function;
}

/**
 * Represents a configurable option within the settings.
 */
class Option
{
	/**
	 * The name of the option displayed in the settings menu.
	 */
	public var name:String;

	/**
	 * The type of the option which determines how its value is handled.
	 */
	public var type:OptionType;

	/**
	 * The current value of the option.
	 */
	public var value:Dynamic;

	/**
	 * Indicates whether to display a '%' sign for Integer and Decimal types.
	 */
	public var showPercentage:Bool;

	/**
	 * Creates a new option with a specified name, type, and initial value.
	 * @param name The name of the option.
	 * @param type The type of the option which dictates how values are managed.
	 * @param value The initial value of the option.
	 * @param showPercentage (Optional) Whether to display a '%' sign for Integer and Decimal types.
	 */
	public function new(name:String, type:OptionType, value:Dynamic, ?showPercentage:Bool = false):Void
	{
		this.name = name;
		this.type = type;
		this.value = value;
		this.showPercentage = showPercentage;
	}

	/**
	 * Changes the value of the option based on the direction input.
	 * Adjusts the value by a step amount, respecting the option type constraints.
	 * @param direction The direction to adjust the value. Positive for incrementing, negative for decrementing.
	 */
	public function changeValue(?direction:Int = 0):Void
	{
		switch (type)
		{
			case OptionType.Toggle:
				value = !value;
			case OptionType.Integer(min, max, step):
				value = Math.floor(FlxMath.bound(value + direction * step, min, max));
			case OptionType.Decimal(min, max, step):
				value = FlxMath.bound(value + direction * step, min, max);
			case OptionType.Function:
				// No value change for Function type
		}
	}

	/**
	 * Converts the option to a string for display purposes.
	 * @return A string representation of the option, formatted according to its type.
	 */
	public function toString():String
	{
		switch (type)
		{
			case OptionType.Toggle:
				return '$name: ${value ? 'On' : 'Off'}';
			case OptionType.Integer(_, _, _):
				return '$name: $value${showPercentage ? '%' : ''}';
			case OptionType.Decimal(_, _, _):
				return '$name: $value${showPercentage ? '%' : ''}';
			case OptionType.Function:
				return name;
		}

		return 'Error!';
	}
}
