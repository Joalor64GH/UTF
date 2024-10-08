package utf.modding;

import flixel.FlxG;
import polymod.backends.PolymodAssets;
import polymod.format.ParseRules;
import polymod.fs.ZipFileSystem;
import polymod.util.VersionUtil;
import polymod.Polymod;
import openfl.Lib;
import sys.FileSystem;
import utf.util.macro.ClassMacro;
#if (windows && cpp)
import utf.util.native.WindowsAPI;
#end
import utf.util.TimerUtil;
import utf.util.WindowUtil;

/**
 * Handles the initialization and management of mods using the Polymod framework.
 *
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx
 */
@:nullSafety
class PolymodHandler
{
	/**
	 * The root directory for mods.
	 */
	@:noCompletion
	private static final MODS_ROOT:String = 'mods';

	/**
	 * Stores metadata for the loaded mods.
	 */
	public static var loadedMods(default, null):Map<String, ModMetadata> = [];

	/**
	 * Loads the game with ALL mods enabled with Polymod.
	 */
	public static function load():Void
	{
		Polymod.clearScripts();

		Polymod.onError = function(error:PolymodError):Void
		{
			final code:String = flixel.util.FlxStringUtil.toTitleCase(Std.string(error.code).split('_').join(' '));

			switch (error.severity)
			{
				case NOTICE:
					FlxG.log.notice('($code) ${error.message}');
				case WARNING:
					FlxG.log.warn('($code) ${error.message}');

					#if (windows && debug && cpp)
					WindowsAPI.showWarning(code, error.message);
					#elseif debug
					WindowUtil.showAlert(code, error.message);
					#end
				case ERROR:
					FlxG.log.error('($code) ${error.message}');

					#if (windows && cpp)
					WindowsAPI.showError(code, error.message);
					#else
					WindowUtil.showAlert(code, error.message);
					#end
			}
		}

		buildImports();

		if (!FileSystem.exists(MODS_ROOT))
			FileSystem.createDirectory(MODS_ROOT);

		final polymodParams:PolymodParams = {
			modRoot: MODS_ROOT,
			dirs: getModDirs(),
			framework: OPENFL,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			parseRules: buildParseRules(),
			useScriptedClasses: true,
			customFilesystem: buildFileSystem()
		};

		final appVersion:Null<String> = Lib.application.meta?.get('version');

		if (appVersion != null)
			polymodParams.apiVersionRule = VersionUtil.anyPatch(appVersion);

		Polymod.init(polymodParams);

		loadRegisteries();
	}

	@:noCompletion
	private static function loadRegisteries():Void
	{
		final registriesStart:Float = TimerUtil.start();

		utf.registries.battle.MonsterRegistry.loadMonsters();

		utf.registries.dialogue.TyperRegistry.loadTypers();
		utf.registries.dialogue.PortraitRegistry.loadPortraits();

		utf.registries.room.CharaRegistry.loadCharacters();
		utf.registries.room.ObjectRegistry.loadObjects();

		utf.registries.EnemyEncounterRegistry.loadEnemyEncounters();
		utf.registries.RoomRegistry.loadRooms();

		FlxG.log.notice('Registries loading took: ${TimerUtil.seconds(registriesStart)}');
	}

	@:noCompletion
	private static function getModDirs():Array<String>
	{
		if (loadedMods != null && Lambda.count(loadedMods) > 0)
			loadedMods.clear();

		final dirs:Array<String> = [];

		final scanParams:ScanParams = {modRoot: MODS_ROOT};

		final appVersion:Null<String> = Lib.application.meta?.get('version');

		if (appVersion != null)
			scanParams.apiVersionRule = VersionUtil.anyPatch(appVersion);

		for (pack in Polymod.scan(scanParams))
		{
			loadedMods.set(pack.id, pack);

			// TODO: Adding the ability to disable mods.
			if (true)
				dirs.push(pack.id);
		}

		return dirs;
	}

	@:noCompletion
	private static inline function buildImports():Void
	{
		Polymod.addImportAlias('flixel.effects.particles.FlxEmitter', flixel.effects.particles.FlxEmitter);
		Polymod.addImportAlias('flixel.group.FlxContainer', flixel.group.FlxContainer);
		Polymod.addImportAlias('flixel.group.FlxGroup', flixel.group.FlxGroup);
		Polymod.addImportAlias('flixel.group.FlxSpriteContainer', flixel.group.FlxSpriteContainer);
		Polymod.addImportAlias('flixel.group.FlxSpriteGroup', flixel.group.FlxSpriteGroup);
		Polymod.addImportAlias('flixel.math.FlxPoint', flixel.math.FlxPoint.FlxBasePoint);

		#if cpp
		Polymod.blacklistImport('cpp.Lib');
		#end
		Polymod.blacklistImport('haxe.Serializer');
		Polymod.blacklistImport('haxe.Unserializer');
		Polymod.blacklistImport('lime.system.CFFI');
		Polymod.blacklistImport('lime.system.System');
		Polymod.blacklistImport('lime.system.JNI');
		Polymod.blacklistImport('lime.utils.Assets');
		Polymod.blacklistImport('openfl.desktop.NativeProcess');
		Polymod.blacklistImport('openfl.utils.Assets');
		Polymod.blacklistImport('Sys');
		Polymod.blacklistImport('Reflect');
		Polymod.blacklistImport('Type');

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
	private static inline function buildFileSystem():ZipFileSystem
	{
		return new ZipFileSystem({modRoot: MODS_ROOT, autoScan: true});
	}

	@:noCompletion
	private static inline function buildParseRules():ParseRules
	{
		final output:ParseRules = ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		return output;
	}
}
