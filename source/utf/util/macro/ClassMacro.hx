package utf.util.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import utf.util.macro.MacroUtil;

/**
 * Macros to generate lists of classes at compile time.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/util/macro/ClassMacro.hx
 */
class ClassMacro
{
	/**
	 * Gets a list of `Class<T>` for all classes in a specified package.
	 * @param targetPackage A String containing the package name to query.
	 * @param includeSubPackages Whether to include classes located in sub-packages of the target package.
	 * @return A list of classes matching the specified criteria.
	 */
	public static macro function listClassesInPackage(targetPackage:String, includeSubPackages:Bool = true):ExprOf<Iterable<Class<Dynamic>>>
	{
		if (!onGenerateCallbackRegistered)
		{
			onGenerateCallbackRegistered = true;

			Context.onGenerate(onGenerate);
		}

		final request:String = 'package~$targetPackage~${includeSubPackages ? 'recursive' : 'nonrecursive'}';

		classListsToGenerate.push(request);

		return macro utf.util.macro.CompiledClassList.get($v{request});
	}

	/**
	 * Get a list of `Class<T>` for all classes extending a specified class.
	 * @param targetClass The class to query for subclasses.
	 * @return A list of classes matching the specified criteria.
	 */
	public static macro function listSubclassesOf<T>(targetClassExpr:ExprOf<Class<T>>):ExprOf<List<Class<T>>>
	{
		if (!onGenerateCallbackRegistered)
		{
			onGenerateCallbackRegistered = true;

			Context.onGenerate(onGenerate);
		}

		final targetClass:ClassType = MacroUtil.getClassTypeFromExpr(targetClassExpr);

		var targetClassPath:String = null;

		if (targetClass != null)
			targetClassPath = targetClass.pack.join('.') + '.' + targetClass.name;

		final request:String = 'extend~$targetClassPath';

		classListsToGenerate.push(request);

		return macro utf.util.macro.CompiledClassList.getTyped($v{request}, ${targetClassExpr});
	}

	#if macro
	private static function onGenerate(allTypes:Array<haxe.macro.Type>):Void
	{
		classListsRaw = [];

		for (request in classListsToGenerate)
			classListsRaw.set(request, []);

		for (type in allTypes)
		{
			switch (type)
			{
				case TInst(t, _params):
					final classType:ClassType = t.get();
					final className:String = t.toString();

					if (!classType.isInterface)
					{
						for (request in classListsToGenerate)
						{
							if (doesClassMatchRequest(classType, request))
								classListsRaw.get(request).push(className);
						}
					}
				default:
					continue;
			}
		}

		compileClassLists();
	}

	@:noCompletion
	private static function compileClassLists():Void
	{
		final compiledClassList:ClassType = MacroUtil.getClassType('utf.util.macro.CompiledClassList');

		if (compiledClassList == null)
			throw 'Could not find CompiledClassList class.';

		if (compiledClassList.meta.has('classLists'))
			compiledClassList.meta.remove('classLists');

		final classLists:Array<Expr> = [];

		for (request in classListsToGenerate)
		{
			final classListEntries:Array<Expr> = [macro $v{request}];

			for (i in classListsRaw.get(request))
				classListEntries.push(macro $v{i});

			classLists.push(macro $a{classListEntries});
		}

		compiledClassList.meta.add('classLists', classLists, Context.currentPos());
	}

	@:noCompletion
	private static function doesClassMatchRequest(classType:ClassType, request:String):Bool
	{
		final splitRequest:Array<String> = request.split('~');

		switch (splitRequest[0])
		{
			case 'package':
				final classPackage:String = classType.pack.join('.');

				if (splitRequest[2] == 'recursive')
					return StringTools.startsWith(classPackage, splitRequest[1]);
				else
					return ~/^${targetPackage}(\.|$)/.match(classPackage);
			case 'extend':
				return MacroUtil.implementsInterface(classType, MacroUtil.getClassType(splitRequest[1]))
					|| MacroUtil.isSubclassOf(classType, MacroUtil.getClassType(splitRequest[1]));
			default:
				throw 'Unknown request type: ${splitRequest[0]}';
		}
	}

	private static var onGenerateCallbackRegistered:Bool = false;
	private static var classListsRaw:Map<String, Array<String>> = [];
	private static var classListsToGenerate:Array<String> = [];
	#end
}
