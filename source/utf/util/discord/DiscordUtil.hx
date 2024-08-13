package utf.util.discord;

#if hxdiscord_rpc
import flixel.FlxG;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;
import utf.Data;

/**
 * Utility class for handling Discord Rich Presence integration.
 */
class DiscordUtil
{
	/**
	 * Discord Application ID.
	 */
	@:noCompletion
	private static final APPLICATION_ID:String = '1140307809167220836';

	/**
	 * Deamon Thread.
	 */
	@:noCompletion
	private static var deamonThread:Thread;

	/**
	 * Indicates if Discord Rich Presence is initialized.
	 */
	public static var initialized(default, null):Bool = false;

	/**
	 * Initializes Discord Rich Presence.
	 *
	 * Sets up the Discord Rich Presence, starts a background thread for updates,
	 * and ensures proper shutdown on application exit.
	 */
	public static function init():Void
	{
		if (initialized)
			return;

		final handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(APPLICATION_ID, cpp.RawPointer.addressOf(handlers), 1, null);

		if (deamonThread == null)
		{
			deamonThread = Thread.create(function():Void
			{
				while (true)
				{
					#if DISCORD_DISABLE_IO_THREAD
					Discord.UpdateConnection();
					#end

					Discord.RunCallbacks();

					Sys.sleep(Data.settings.get('low-quality') ? 5 : 2);
				}
			});
		}

		if (Lib.application != null && !Lib.application.onExit.has(shutdown))
			Lib.application.onExit.add(shutdown);

		initialized = true;
	}

	@:noCompletion
	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final discriminator:String = request[0].discriminator;
		final username:String = request[0].username;

		if (Std.parseInt(discriminator) != 0)
			FlxG.log.notice('(Discord) Connected to User "$username#$discriminator"');
		else
			FlxG.log.notice('(Discord) Connected to User "$username"');

		final discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.largeImageKey = "icon";
		discordPresence.largeImageText = "UTF";
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	@:noCompletion
	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Disconnected ($errorCode:$message)');
	}

	@:noCompletion
	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		FlxG.log.notice('(Discord) Error ($errorCode:$message)');
	}

	@:noCompletion
	private static function shutdown(exitCode:Int):Void
	{
		updateThread = null;
		Discord.Shutdown();
		initialized = false;
	}
}
#end
