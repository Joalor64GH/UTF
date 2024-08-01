package utf.util.native;

#if (windows && cpp)
/**
 * Utility class for Windows API-related functions.
 */
@:buildXml('
<target id="haxe">
	<section if="mingw">
		<lib name="-lpsapi" />
	</section>

	<section if="windows" unless="mingw">
		<lib name="psapi.lib" />
	</section>
</target>
')
@:cppInclude('windows.h')
@:cppInclude('psapi.h')
@:nativeGen
class WindowsAPI
{
	/**
	 * Disables the "Report to Microsoft" dialog that appears when the application crashes.
	 */
	public static function disableErrorReporting():Void
	{
		untyped SetErrorMode(untyped SEM_FAILCRITICALERRORS | untyped SEM_NOGPFAULTERRORBOX);
	}
}
#end
