package utf.external;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.xml.Printer;
import sys.FileSystem;

@:access(haxe.xml.Printer)
class Linker
{
	public static macro function xml(?file_name:String):Array<Field>
	{
		final pos:Position = Context.currentPos();

		var sourcePath:String = Path.directory(Context.getPosInfos(pos).file);

		if (!Path.isAbsolute(sourcePath))
			sourcePath = FileSystem.absolutePath(sourcePath);

		sourcePath = Path.removeTrailingSlashes(Path.normalize(sourcePath));

		final includeElement:Xml = Xml.createElement('include');

		includeElement.set('name', Path.join([sourcePath, file_name ?? 'Build.xml']));

		final printer:Printer = new Printer(true);

		printer.writeNode(includeElement, '\n');

		Context.getLocalClass().get().meta.add(':buildXml', [{expr: EConst(CString(printer.output.toString())), pos: pos}], pos);

		return Context.getBuildFields();
	}
}
