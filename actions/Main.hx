package;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;

/**
 * Represents the configuration structure for the HMM tool, containing an array of library dependencies.
 */
typedef HmmConfig =
{
	dependencies:Array<LibraryConfig>
}

/**
 * Represents the configuration for a single library, including its name, type, version, directory, reference, and URL.
 */
typedef LibraryConfig =
{
	name:String,
	type:String,
	?version:String,
	?dir:String,
	?ref:String,
	?url:String
}

/**
 * The Main class is designed specifically for use with GitHub Actions.
 * Its purpose is to install libraries specified in a configuration file (`hmm.json`)
 * without their dependencies.
 */
class Main
{
	/**
	 * The main function is the entry point of the program.
	 * It checks for the existence of the `.haxelib` directory, creating it if it does not exist.
	 * Then it reads the `hmm.json` configuration file, parses it, and installs each library
	 * according to its specified type, using the appropriate commands while skipping dependencies.
	 */
	public static function main():Void
	{
		if (!FileSystem.exists('.haxelib'))
		{
			final args:Array<String> = ['haxelib', 'newrepo', '--quiet', '--never'];

			Sys.println(AnsiColors.yellow(args.join(' ')));

			Sys.command(args.shift(), args);
		}

		final config:HmmConfig = Json.parse(File.getContent('./hmm.json'));

		for (lib in config.dependencies)
		{
			switch (lib.type)
			{
				case 'haxelib':
					final args:Array<String> = ['haxelib', 'install'];

					args.push(lib.name);

					if (lib.version != null)
						args.push(lib.version);

					args.push('--quiet');
					args.push('--never');
					args.push('--skip-dependencies');

					Sys.println(AnsiColors.yellow(args.join(' ')));

					Sys.command(args.shift(), args);
				case 'git':
					final args:Array<String> = ['haxelib', 'git'];

					args.push(lib.name);
					args.push(lib.url);

					if (lib.ref != null)
						args.push(lib.ref);

					args.push('--quiet');
					args.push('--never');
					args.push('--skip-dependencies');

					Sys.println(AnsiColors.yellow(args.join(' ')));

					Sys.command(args.shift(), args);
			}
		}

		final args:Array<String> = ['haxelib', 'list'];

		Sys.println(AnsiColors.yellow(args.join(' ')));

		Sys.command(args.shift(), args);
	}
}

/**
 * @see https://github.com/andywhite37/hmm/blob/master/src/hmm/utils/AnsiColors.hx
 */
class AnsiColors
{
	public static var disabled:Bool;

	public static function red(input:String):String
	{
		return color(input, Red);
	}

	public static function green(input:String):String
	{
		return color(input, Green);
	}

	public static function yellow(input:String):String
	{
		return color(input, Yellow);
	}

	public static function blue(input:String):String
	{
		return color(input, Blue);
	}

	public static function magenta(input:String):String
	{
		return color(input, Magenta);
	}

	public static function cyan(input:String):String
	{
		return color(input, Cyan);
	}

	public static function gray(input:String):String
	{
		return color(input, Gray);
	}

	public static function white(input:String):String
	{
		return color(input, White);
	}

	public static function none(input:String):String
	{
		return color(input, None);
	}

	public static function color(input:String, ansiColor:AnsiColor):String
	{
		return disabled ? input : '${ansiColor}$input${AnsiColor.None}';
	}
}

enum abstract AnsiColor(String) from String to String
{
	var Black = '\033[0;30m';
	var Red = '\033[0;31m';
	var Green = '\033[0;32m';
	var Yellow = '\033[0;33m';
	var Blue = '\033[0;34m';
	var Magenta = '\033[0;35m';
	var Cyan = '\033[0;36m';
	var Gray = '\033[0;37m';
	var White = '\033[1;37m';
	var None = '\033[0;0m';
}
