package utf.backend;

#if hxdiscord_rpc
import flixel.FlxG;
import hxdiscord_rpc.Discord as RichPresence;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;

/**
 * This class handles Discord Rich Presence integration.
 */
class Discord
{
	/**
	 * Indicates if Discord Rich Presence is initialized.
	 */
	public static var initialized(default, null):Bool = false;

	/**
	 * Initializes Discord Rich Presence.
	 */
	public static function load():Void
	{
		if (initialized)
			return;

		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		RichPresence.Initialize("1140307809167220836", cpp.RawPointer.addressOf(handlers), 1, null);

		Thread.create(function():Void
		{
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				RichPresence.UpdateConnection();
				#end
				RichPresence.RunCallbacks();

				Sys.sleep(2);
			}
		});

		Lib.application.onExit.add((exitCode:Int) -> RichPresence.Shutdown());

		initialized = true;
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final discriminator:String = cast(request[0].discriminator, String);
		final username:String = cast(request[0].username, String);

		if (Std.parseInt(discriminator) != 0)
			FlxG.log.notice('(Discord) Connected to User "$username#$discriminator"');
		else
			FlxG.log.notice('(Discord) Connected to User "$username"');

		final discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.largeImageKey = "icon";
		discordPresence.largeImageText = "UTF";
		RichPresence.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Disconnected ($errorCode: ${cast (message, String)})');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Error ($errorCode: ${cast (message, String)})');
	}
}
#end
