package utf.util;

#if android
import android.Tools;
#end
import openfl.Lib;

/**
 * Utility class for window-related functions.
 */
class WindowUtil
{
	/**
	 * Show a popup with the given text.
	 *
	 * @param name The title of the popup.
	 * @param desc The content of the popup.
	 */
	public static function showAlert(name:String, desc:String):Void
	{
		#if !android
		Lib.application.window.alert(desc, name);
		#else
		Tools.showAlertDialog(name, desc, {name: 'Ok', func: null});
		#end
	}
}
