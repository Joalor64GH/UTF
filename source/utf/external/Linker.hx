package utf.external;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.xml.Printer;
import sys.FileSystem;

/**
 * This class provides a macro to include an XML build file in the metadata of a Haxe class.
 * The file must be located relative to the directory of the Haxe class that uses this macro.
 */
@:access(haxe.xml.Printer)
class Linker
{
	/**
	 * Adds an XML `<include>` element to the class's metadata, pointing to a specified build file.
	 * @param file_name The name of the XML file to include. Defaults to `Build.xml` if not provided.
	 * @return An array of fields that are processed during the build.
	 */
	public static macro function xml(?file_name:String = 'Build.xml'):Array<Field>
	{
		final pos:Position = Context.currentPos();

		var sourcePath:String = Path.directory(Context.getPosInfos(pos).file);

		if (!Path.isAbsolute(sourcePath))
			sourcePath = FileSystem.absolutePath(sourcePath);

		sourcePath = Path.removeTrailingSlashes(Path.normalize(sourcePath));

		final includeElement:Xml = Xml.createElement('include');

		final fileToInclude:String = Path.join([sourcePath, file_name?.length > 0 ? file_name : 'Build.xml']);

		if (!FileSystem.exists(fileToInclude))
			Context.error('The specified file "$fileToInclude" could not be found at "$sourcePath".', pos);

		includeElement.set('name', fileToInclude);

		final printer:Printer = new Printer(true);

		printer.writeNode(includeElement, '\n');

		Context.getLocalClass().get().meta.add(':buildXml', [{expr: EConst(CString(printer.output.toString())), pos: pos}], pos);

		return Context.getBuildFields();
	}
}
