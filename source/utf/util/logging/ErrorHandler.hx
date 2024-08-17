package utf.util.logging;

import haxe.CallStack;
import haxe.Exception;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.system.System;
import openfl.Lib;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
#if (windows && cpp)
import utf.util.native.WindowsAPI;
#end
import utf.util.DateUtil;
import utf.util.WindowUtil;

/**
 * Error handler utility class for handling uncaught errors and critical errors.
 */
class ErrorHandler
{
	/**
	 * The root directory where log files will be saved.
	 */
	@:noCompletion
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

		if (Std.isOfType(event.error, ErrorEvent))
		{
			final error:ErrorEvent = cast(event.error, ErrorEvent);

			log.push(error.text);
		}
		else
		{
			if (Std.isOfType(event.error, String))
				log.push(event.error);
			else
				log.push(Std.string(event.error));

			log.push(CallStack.toString(CallStack.exceptionStack(true)));

			#if sys
			saveLog(log.join('\n'));
			#end
		}

		WindowUtil.showAlert('Uncaught Error', log.join('\n'));

		System.exit(1);
	}

	@:noCompletion
	private static inline function onCriticalError(message:String):Void
	{
		final log:Array<String> = [];

		if (message != null && message.length > 0)
			log.push(message);

		log.push(CallStack.toString(CallStack.exceptionStack(true)));

		#if sys
		saveLog(log.join('\n'));
		#end

		WindowUtil.showAlert('Critical Error', log.join('\n'));

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
