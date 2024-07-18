package funkin.modding;

#if android
import android.Tools;
#end
import polymod.Polymod;
import openfl.Lib;
import flixel.FlxG;

/**
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodErrorHandler.hx
 */
class PolymodErrorHandler
{
	/**
	 * Show a popup with the given text.
	 * This displays a system popup, it WILL interrupt the game.
	 * Make sure to only use this when it's important, like when there's a script error.
	 *
	 * @param name The name at the top of the popup.
	 * @param desc The body text of the popup.
	 */
	public static function showAlert(name:String, desc:String):Void
	{
		#if !android
		Lib.application.window.alert(desc, name);
		#else
		Tools.showAlertDialog(name, desc, {name: 'Ok', func: null});
		#end
	}

	public static function onPolymodError(error:PolymodError):Void
	{
		switch (error.code)
		{
			case FRAMEWORK_INIT, FRAMEWORK_AUTODETECT, SCRIPT_PARSING:
				return;
			case MOD_LOAD_PREPARE, MOD_LOAD_DONE:
				FlxG.log.notice('LOADING MOD - ${error.message}');
			case MISSING_ICON:
				FlxG.log.warn('A mod is missing an icon. Please add one.');
			case SCRIPT_PARSE_ERROR:
				FlxG.log.error(error.message);

				showAlert('Polymod Script Parsing Error', error.message);
			case SCRIPT_RUNTIME_EXCEPTION:
				FlxG.log.error(error.message);

				showAlert('Polymod Script Exception', error.message);
			case SCRIPT_CLASS_MODULE_NOT_FOUND:
				FlxG.log.error(error.message);

				var msg:String = 'Import error in ${error.origin}';
				msg += '\nCould not import unknown class ${error.message.split(' ').pop()}';
				msg += '\nCheck to ensure the class exists and is spelled correctly.';
				showAlert('Polymod Script Import Error', msg);
			case SCRIPT_CLASS_MODULE_BLACKLISTED:
				FlxG.log.error(error.message);

				showAlert('Polymod Script Blacklist Violation', error.message);
			default:
				switch (error.severity)
				{
					case NOTICE:
						FlxG.log.notice(error.message);
					case WARNING:
						FlxG.log.warn(error.message);
					case ERROR:
						FlxG.log.error(error.message);
				}
		}
	}
}
