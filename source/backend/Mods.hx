package backend;

#if polymod
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.format.ParseRules;
import polymod.util.VersionUtil;
import polymod.Polymod;
import openfl.Lib;
import sys.FileSystem;

/**
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx
 */
class Mods
{
	public static var data(default, null):Map<String, ModMetadata> = [];

	public static function load():Void
	{
		Polymod.onError = function(error:PolymodError)
		{
			final code:String = Std.string(error.code).toUpperCase();

			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('($code) ${error.message}');
				case WARNING:
					FlxG.log.warn('($code) ${error.message}');
				case ERROR:
					FlxG.log.error('($code) ${error.message}');
			}
		}

		buildImports();

		if (!FileSystem.exists('mods'))
			FileSystem.createDirectory('mods');

		Polymod.init({
			modRoot: 'mods',
			dirs: getModDirs(),
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			parseRules: buildParseRules(),
			useScriptedClasses: true,
			loadScriptsAsync: #if html5 true #else false #end,
			apiVersionRule: VersionUtil.anyPatch(Lib.application.meta.get('version'))
		});
	}

	private static function getModDirs():Array<String>
	{
		if (data != null && Lambda.count(data) > 0)
			data.clear();

		final packs:Array<String> = [];

		for (pack in Polymod.scan({modRoot: 'mods'}))
		{
			data.set(pack.id, pack);

			// TODO: Adding the ability to disable mods.
			if (true)
				packs.push(pack.id);
		}

		return packs;
	}

	private static function buildImports():Void
	{
		Polymod.addImportAlias('flixel.math.FlxPoint', .FlxBasePoint);

		Polymod.blacklistImport('Sys');
		Polymod.blacklistImport('Reflect');
		Polymod.blacklistImport('Type');

		#if cpp
		Polymod.blacklistImport('cpp.Lib');
		#end

		for (cls in ClassMacro.listClassesInPackage('polymod'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}

		#if sys
		for (cls in ClassMacro.listClassesInPackage('sys'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}
		#end
	}

	private static function buildParseRules():ParseRules
	{
		final output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		return output;
	}
}
#end
