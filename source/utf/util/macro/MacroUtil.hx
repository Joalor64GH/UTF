package utf.util.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end

/**
 * Utility class for various macro operations.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/util/macro/MacroUtil.hx
 */
class MacroUtil
{
	/**
	 * Gets the value of a Haxe compiler define.
	 * @param key The name of the define to get the value of.
	 * @param defaultValue The value to return if the define is not set.
	 * @return An expression containing the value of the define.
	 */
	public static macro function getDefine(key:String, defaultValue:String = null):Expr
	{
		#if !display
		var value:String = Context.definedValue(key);

		if (value != null && value.length > 0)
			return macro $v{value};
		#end

		return macro $v{defaultValue};
	}

	#if macro
	/**
	 * Convert an ExprOf<Class<T>> to a ClassType.
	 * @param e An expression representing the class.
	 * @return The ClassType corresponding to the expression.
	 */
	public static function getClassTypeFromExpr(e:Expr):ClassType
	{
		final parts:Array<String> = [];

		var nextSection:ExprDef = e.expr;

		while (nextSection != null)
		{
			final section:ExprDef = nextSection;

			nextSection = null;

			switch (section)
			{
				case EConst(c):
					switch (c)
					{
						case CIdent(cn):
							if (cn != 'null')
								parts.unshift(cn);
						default:
					}
				case EField(exp, field):
					nextSection = exp.expr;

					parts.unshift(field);
				default:
			}
		}

		final fullClassName:String = parts.join('.');

		if (fullClassName.length > 0)
		{
			switch (Context.follow(Context.getType(fullClassName), false))
			{
				case TInst(t, params):
					return t.get();
				default:
					throw 'Class type could not be parsed: ${fullClassName}';
			}
		}

		return null;
	}

	/**
	 * Checks if a field is static.
	 * @param field The field to check.
	 * @return True if the field is static, otherwise false.
	 */
	public static function isFieldStatic(field:haxe.macro.Expr.Field):Bool
	{
		return field.access.contains(AStatic);
	}

	/**
	 * Converts a value to an equivalent macro expression.
	 * @param value The value to convert.
	 * @return The macro expression representing the value.
	 */
	public static function toExpr(value:Dynamic):ExprOf<Dynamic>
	{
		return Context.makeExpr(value, Context.currentPos());
	}

	/**
	 * Checks if two classes are equal.
	 * @param class1 The first class to compare.
	 * @param class2 The second class to compare.
	 * @return True if the classes are equal, otherwise false.
	 */
	public static function areClassesEqual(class1:ClassType, class2:ClassType):Bool
	{
		return class1.pack.join('.') == class2.pack.join('.') && class1.name == class2.name;
	}

	/**
	 * Retrieve a ClassType from a string name.
	 * @param name The name of the class.
	 * @return The ClassType corresponding to the name.
	 */
	public static function getClassType(name:String):ClassType
	{
		switch (Context.getType(name))
		{
			case TInst(t, _params):
				return t.get();
			default:
				throw 'Class type could not be parsed: ${name}';
		}
	}

	/**
	 * Determine whether a given ClassType is a subclass of a given superclass.
	 * @param classType The class to check.
	 * @param superClass The superclass to check for.
	 * @return Whether the class is a subclass of the superclass.
	 */
	public static function isSubclassOf(classType:ClassType, superClass:ClassType):Bool
	{
		if (areClassesEqual(classType, superClass))
			return true;

		if (classType.superClass != null)
			return isSubclassOf(classType.superClass.t.get(), superClass);

		return false;
	}

	/**
	 * Determine whether a given ClassType implements a given interface.
	 * @param classType The class to check.
	 * @param interfaceType The interface to check for.
	 * @return Whether the class implements the interface.
	 */
	public static function implementsInterface(classType:ClassType, interfaceType:ClassType):Bool
	{
		for (i in classType.interfaces)
		{
			if (areClassesEqual(i.t.get(), interfaceType))
				return true;
		}

		if (classType.superClass != null)
			return implementsInterface(classType.superClass.t.get(), interfaceType);

		return false;
	}
	#end
}
