package utf.util.native;

#if (windows && cpp)
/**
 * Contains extended memory statistics for a process.
 */
@:build(utf.external.Linker.xml('builders/WindowsAPIBuilder.xml'))
@:cppInclude('windows.h')
@:cppInclude('psapi.h')
@:unreflective
@:structAccess
@:native('PROCESS_MEMORY_COUNTERS_EX')
extern class PROCESS_MEMORY_COUNTERS_EX
{
	@:native('PROCESS_MEMORY_COUNTERS_EX')
	static function alloc():PROCESS_MEMORY_COUNTERS_EX;

	var PeakWorkingSetSize:cpp.SizeT;
	var WorkingSetSize:cpp.SizeT;
}

/**
 * Utility class for Windows API-related functions.
 */
@:build(utf.external.Linker.xml('builders/WindowsAPIBuilder.xml'))
@:cppInclude('windows.h')
@:cppInclude('psapi.h')
@:nativeGen
class WindowsAPI
{
	/**
	 * Shows a message box with an error icon.
	 * @param message The message to display.
	 * @param title The title of the message box.
	 * @return The result of the message box interaction.
	 */
	public static function showError(message:cpp.ConstCharStar, title:cpp.ConstCharStar):Int
	{
		return untyped MessageBox(null, message, title, untyped MB_OK | untyped MB_ICONERROR);
	}

	/**
	 * Shows a message box with a warning icon.
	 * @param message The message to display.
	 * @param title The title of the message box.
	 * @return The result of the message box interaction.
	 */
	public static function showWarning(message:cpp.ConstCharStar, title:cpp.ConstCharStar):Int
	{
		return untyped MessageBox(null, message, title, untyped MB_OK | untyped MB_ICONWARNING);
	}

	/**
	 * Shows a message box with an information icon.
	 * @param message The message to display.
	 * @param title The title of the message box.
	 * @return The result of the message box interaction.
	 */
	public static function showInformation(message:cpp.ConstCharStar, title:cpp.ConstCharStar):Int
	{
		return untyped MessageBox(null, message, title, untyped MB_OK | untyped MB_ICONINFORMATION);
	}

	/**
	 * Shows a message box with a question icon.
	 * @param message The message to display.
	 * @param title The title of the message box.
	 * @return The result of the message box interaction.
	 */
	public static function showQuestion(message:cpp.ConstCharStar, title:cpp.ConstCharStar):Int
	{
		return untyped MessageBox(null, message, title, untyped MB_OKCANCEL | untyped MB_ICONQUESTION);
	}

	/**
	 * Disables the "Report to Microsoft" dialog that appears when the application crashes.
	 */
	public static function disableErrorReporting():Void
	{
		untyped SetErrorMode(untyped SEM_FAILCRITICALERRORS | untyped SEM_NOGPFAULTERRORBOX);
	}

	/**
	 * Retrieves the current working set size of the process.
	 * This represents the amount of physical memory (RAM) currently being used by the process.
	 * @return The current working set size in bytes. Returns 0 if the retrieval fails.
	 */
	public static function GetProcessMemoryWorkingSetSize():cpp.SizeT
	{
		final pcm:PROCESS_MEMORY_COUNTERS_EX = PROCESS_MEMORY_COUNTERS_EX.alloc();

		if (untyped GetProcessMemoryInfo(untyped GetCurrentProcess(), untyped __cpp__('(PROCESS_MEMORY_COUNTERS *) {0}', cpp.RawPointer.addressOf(pcm)),
			untyped sizeof(pcm)))
			return pcm.WorkingSetSize;
		else
			Sys.println('Failed to get memory usage information.');

		return 0;
	}

	/**
	 * Retrieves the peak working set size of the process.
	 * This represents the maximum amount of physical memory (RAM) used by the process at any point in its lifetime.
	 * @return The peak working set size in bytes. Returns 0 if the retrieval fails.
	 */
	public static function GetProcessMemoryPeakWorkingSetSize():cpp.SizeT
	{
		final pcm:PROCESS_MEMORY_COUNTERS_EX = PROCESS_MEMORY_COUNTERS_EX.alloc();

		if (untyped GetProcessMemoryInfo(untyped GetCurrentProcess(), untyped __cpp__('(PROCESS_MEMORY_COUNTERS *) {0}', cpp.RawPointer.addressOf(pcm)),
			untyped sizeof(pcm)))
			return pcm.PeakWorkingSetSize;
		else
			Sys.println('Failed to get peak working set size information.');

		return 0;
	}
}
#end
