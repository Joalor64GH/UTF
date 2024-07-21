package utf.modding;

#if polymod
import flixel.util.FlxSave;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.format.ParseRules;
import polymod.fs.ZipFileSystem;
import polymod.util.VersionUtil;
import polymod.Polymod;
import openfl.Lib;
import sys.FileSystem;
import utf.backend.registries.MonsterRegistery;
import utf.backend.registries.ObjectRegistery;
import utf.backend.registries.TyperRegistery;
import utf.util.macro.ClassMacro;
import utf.util.WindowUtil;

/**
 * Handles the initialization and management of mods using the Polymod framework.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx
 */
class PolymodHandler
{
	/**
	 * Stores metadata for the loaded mods.
	 */
	public static var data(default, null):Map<String, ModMetadata> = [];

	/**
	 * Reloads and initializes the mods.
	 */
	public static function reloadMods():Void
	{
		Polymod.onError = function(error:PolymodError):Void
		{
			final code:String = Std.string(error.code);

			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('(${code.toUpperCase()}) ${error.message}');
				case WARNING:
					FlxG.log.warn('(${code.toUpperCase()}) ${error.message}');
				case ERROR:
					FlxG.log.error('(${code.toUpperCase()}) ${error.message}');

					WindowUtil.showAlert(FlxStringUtil.toTitleCase(code.split('_').join(' ')), error.message);
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
			apiVersionRule: VersionUtil.anyPatch(Lib.application.meta.get('version')),
			customFilesystem: buildFileSystem(),
		});
	}

	/**
	 * Reloads all scripts and registers them.
	 */
	public static function reloadScripts():Void
	{
		Polymod.clearScripts();
		PolymodHandler.reloadMods();
		Polymod.registerAllScriptClasses();

		reloadRegisteries();
	}

	/**
	 * Reloads registries.
	 */
	public static function reloadRegisteries():Void
	{
		MonsterRegistery.loadMonsters();
		ObjectRegistery.loadObjects();
		TyperRegistery.loadTypers();
	}

	@:noCompletion
	private static function getModDirs():Array<String>
	{
		if (data != null && Lambda.count(data) > 0)
			data.clear();

		final packs:Array<String> = [];

		for (pack in Polymod.scan({modRoot: 'mods', apiVersionRule: VersionUtil.anyPatch(Lib.application.meta.get('version'))}))
		{
			data.set(pack.id, pack);

			// TODO: Adding the ability to disable mods.
			if (true)
				packs.push(pack.id);
		}

		return packs;
	}

	@:noCompletion
	private static function buildImports():Void
	{
		Polymod.addImportAlias('flixel.effects.particles.FlxEmitter', flixel.effects.particles.FlxEmitter);
		Polymod.addImportAlias('flixel.group.FlxContainer', flixel.group.FlxContainer);
		Polymod.addImportAlias('flixel.group.FlxGroup', flixel.group.FlxGroup);
		Polymod.addImportAlias('flixel.group.FlxSpriteContainer', flixel.group.FlxSpriteContainer);
		Polymod.addImportAlias('flixel.group.FlxSpriteGroup', flixel.group.FlxSpriteGroup);
		Polymod.addImportAlias('flixel.math.FlxPoint', flixel.math.FlxPoint.FlxBasePoint);

		Polymod.blacklistImport('haxe.Serializer');
		Polymod.blacklistImport('haxe.Unserializer');

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

	@:noCompletion
	private static function buildFileSystem():ZipFileSystem
	{
		return new ZipFileSystem({modRoot: 'mods', autoScan: true});
	}

	@:noCompletion
	private static function buildParseRules():ParseRules
	{
		final output:ParseRules = ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		return output;
	}
}
#end
