package utf.modding;

#if polymod
import flixel.util.FlxSave;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.format.ParseRules;
import polymod.util.VersionUtil;
import polymod.Polymod;
import openfl.Lib;
import sys.FileSystem;
import utf.backend.Util;
import utf.objects.battle.MonsterRegistery;

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
		Polymod.onError = function(error:PolymodError)
		{
			switch (error.code)
			{
				case FRAMEWORK_INIT, FRAMEWORK_AUTODETECT, SCRIPT_PARSING:
					// Do nothing.
				case MOD_LOAD_PREPARE, MOD_LOAD_DONE:
					FlxG.log.notice('Loading mod ${error.message}');
				case MISSING_ICON:
					FlxG.log.warn('A mod is missing an icon. Please add one.');
				case SCRIPT_PARSE_ERROR:
					FlxG.log.error(error.message);

					Util.showAlert('Polymod Script Parsing Error', error.message);
				case SCRIPT_RUNTIME_EXCEPTION:
					FlxG.log.error(error.message);

					Util.showAlert('Polymod Script Exception', error.message);
				case SCRIPT_CLASS_MODULE_NOT_FOUND:
					FlxG.log.error(error.message);

					var msg:String = 'Import error in ${error.origin}';
					msg += '\nCould not import class: ${error.message.split(' ').pop()}';
					msg += '\nEnsure the class exists and is spelled correctly.';
					Util.showAlert('Polymod Script Import Error', msg);
				case SCRIPT_CLASS_MODULE_BLACKLISTED:
					FlxG.log.error(error.message);

					Util.showAlert('Polymod Script Blacklist Violation', error.message);
				default:
					switch (error.severity)
					{
						case NOTICE:
							FlxG.log.notice(error.message);
						case WARNING:
							FlxG.log.warn(error.message);
						case ERROR:
							FlxG.log.error(error.message);

							Util.showAlert(FlxStringUtil.toTitleCase(Std.string(error.code)), error.message);
					}
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

	private static function buildParseRules():ParseRules
	{
		final output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		return output;
	}
}
#end
