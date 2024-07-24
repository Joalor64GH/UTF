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
			Sys.command('haxelib', ['newrepo', '--quiet', '--never']);

		final config:HmmConfig = Json.parse(File.getContent('./hmm.json'));

		for (lib in config.dependencies)
		{
			switch (lib.type)
			{
				case 'haxelib':
					final args:Array<String> = ['install'];

					args.push(lib.name);

					if (lib.version != null)
						args.push(lib.version);

					args.push('--quiet');
					args.push('--never');
					args.push('--skip-dependencies');

					Sys.command('haxelib', args);
				case 'git':
					final args:Array<String> = ['git'];

					args.push(lib.name);
					args.push(lib.url);

					if (lib.ref != null)
						args.push(lib.ref);

					args.push('--quiet');
					args.push('--never');
					args.push('--skip-dependencies');

					Sys.command('haxelib', args);
			}
		}

		Sys.command('haxelib', ['list']);
	}
}
