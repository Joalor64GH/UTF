package utf.util.macro;

#if macro
import haxe.macro.Context:
#end
import haxe.rtti.Meta;

/**
 * Utility class for managing and retrieving lists of compiled classes.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/util/macro/CompiledClassList.hx
 */
class CompiledClassList
{
	@:noCompletion
	private static var classLists:Map<String, List<Class<Dynamic>>> = [];

	@:noCompletion
	private static function init():Void
	{
		if (classLists != null && Lambda.count(classLists) > 0)
			classLists.clear();

		final metaData:Dynamic<Array<Dynamic>> = Meta.getType(CompiledClassList);

		if (metaData.classLists != null)
		{
			for (list in metaData.classLists)
			{
				final data:Array<Dynamic> = cast list;
				final id:String = cast data[0];
				final classes:List<Class<Dynamic>> = new List();

				for (i in 1...data.length)
				{
					final className:String = cast data[i];

					final classType:Class<Dynamic> = cast Type.resolveClass(className);

					classes.push(classType);
				}

				classLists.set(id, classes);
			}
		}
		else
			throw 'Class lists not properly generated. Try cleaning out your export folder, restarting your IDE, and rebuilding your project.';
	}

	/**
	 * Retrieves a list of classes based on the given request identifier.
	 * Initializes the class lists if they have not been initialized yet.
	 * @param request The identifier for the requested class list.
	 * @return A list of classes corresponding to the request identifier.
	 */
	public static function get(request:String):Null<List<Class<Dynamic>>>
	{
		if (classLists == null || Lambda.count(classLists) <= 0)
			init();

		if (!classLists.exists(request))
		{
			#if macro
			Context.warning('Class list $request not properly generated. Please debug the build macro.');
			#end

			classLists.set(request, new List());
		}

		return classLists.get(request);
	}

	/**
	 * Retrieves a typed list of classes based on the given request identifier.
	 * @param request The identifier for the requested class list.
	 * @param type The expected type of the classes in the list.
	 * @return A list of classes of the specified type corresponding to the request identifier.
	 */
	public static inline function getTyped<T>(request:String, type:Class<T>):List<Class<T>>
	{
		return cast get(request);
	}
}
