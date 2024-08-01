package utf.util.logging;

import haxe.CallStack;
import haxe.Exception;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if (windows && cpp)
import utf.util.native.WindowsAPI;
#end
import utf.util.DateUtil;

/**
 * Error handler utility class for handling uncaught errors and critical errors.
 */
class ErrorHandler
{
	/**
	 * The root directory where log files will be saved.
	 */
	private static final LOGS_ROOT:String = 'logs';

	/**
	 * Initializes the error handler by setting up the necessary error listeners.
	 */
	public static function init():Void
	{
		#if (windows && cpp)
		WindowsAPI.disableErrorReporting();
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
		#end
	}

	@:noCompletion
	private static inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		final log:Array<String> = [];

		if (Std.isOfType(event.error, Error))
		{
			final error:Error = cast(event.error, Error);

			log.push('Error: ${error.message}');
			log.push('Stack Trace:\n${error.getStackTrace()}');
		}
		else if (Std.isOfType(event.error, ErrorEvent))
			log.push('Error Event: ${cast (event.error, ErrorEvent).text}');
		else
			log.push('Unknown Error: ${Std.string(event.error)}');

		saveLog(log.join('\n'));

		WindowUtil.showAlert('Uncaught Error!', log.join('\n'));

		System.exit(1);
	}

	@:noCompletion
	private static inline function onCriticalError(message:String):Void
	{
		final log:Array<String> = [];
		log.push('Error: $message');
		log.push('Exception Stack:\n${CallStack.toString(CallStack.exceptionStack(true))}');
		saveLog(log.join('\n'), true);

		WindowUtil.showAlert('Critical Error!', log.join('\n'));

		System.exit(1);
	}

	#if sys
	@:noCompletion
	private static function saveLog(msg:String, ?critical:Bool = false):Bool
	{
		try
		{
			if (!FileSystem.exists(LOGS_ROOT))
				FileSystem.createDirectory(LOGS_ROOT);

			final filename:String = critical ? 'critical-crash-${DateUtil.getFormattedDateTimeForFile()}.log' : 'crash-${DateUtil.getFormattedDateTimeForFile()}.log';

			File.saveContent('$LOGS_ROOT/$filename', msg);

			return true;
		}
		catch (e:Exception)
			return false;
	}
	#end
}
