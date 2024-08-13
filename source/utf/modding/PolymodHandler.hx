package utf.modding;

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
import utf.registries.CharaRegistry;
import utf.registries.MonsterRegistry;
import utf.registries.ObjectRegistry;
import utf.registries.RoomRegistry;
import utf.registries.TyperRegistry;
import utf.util.macro.ClassMacro;
import utf.util.TimerUtil;
import utf.util.WindowUtil;

/**
 * Handles the initialization and management of mods using the Polymod framework.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx
 */
class PolymodHandler
{
	/**
	 * The root directory for mods.
	 */
	private static final MODS_ROOT:String = 'mods';

	/**
	 * Stores metadata for the loaded mods.
	 */
	public static var data(default, null):Map<String, ModMetadata> = [];

	/**
	 * Loads the game with ALL mods enabled with Polymod.
	 */
	public static function load(?clearScripts:Bool = false):Void
	{
		if (clearScripts)
			Polymod.clearScripts();
		
		Polymod.onError = function(error:PolymodError):Void
		{
			final code:String = FlxStringUtil.toTitleCase(Std.string(error.code).split('_').join(' '));

			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('($code) ${error.message}');
				case WARNING:
					FlxG.log.warn('($code) ${error.message}');
				case ERROR:
					FlxG.log.error('($code) ${error.message}');

					WindowUtil.showAlert(code, error.message);
			}
		}

		buildImports();

		if (!FileSystem.exists(MODS_ROOT))
			FileSystem.createDirectory(MODS_ROOT);

		Polymod.init({
			modRoot: MODS_ROOT,
			dirs: getModDirs(),
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			parseRules: buildParseRules(),
			useScriptedClasses: true,
			apiVersionRule: VersionUtil.anyPatch(Lib.application.meta.get('version')),
			customFilesystem: buildFileSystem(),
		});

		loadRegisteries();
	}

	@:noCompletion
	private static function loadRegisteries():Void
	{
		FlxG.log.notice('Loading the registries.');

		final registriesStart:Float = TimerUtil.start();

		CharaRegistry.loadCharacters();
		MonsterRegistry.loadMonsters();
		ObjectRegistry.loadObjects();
		RoomRegistry.loadRooms();
		TyperRegistry.loadTypers();

		FlxG.log.notice('Registries loading took: ${TimerUtil.seconds(registriesStart)}');
	}

	@:noCompletion
	private static function getModDirs():Array<String>
	{
		if (data != null && Lambda.count(data) > 0)
			data.clear();

		final packs:Array<String> = [];

		for (pack in Polymod.scan({modRoot: MODS_ROOT, apiVersionRule: VersionUtil.anyPatch(Lib.application.meta.get('version'))}))
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
		return new ZipFileSystem({modRoot: MODS_ROOT, autoScan: true});
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
