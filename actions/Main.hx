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
	version:String,
	dir:String,
	ref:String,
	url:String
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
		// Ensure the .haxelib directory exists
		if (!FileSystem.exists('.haxelib'))
			FileSystem.createDirectory('.haxelib');

		// Read and parse the hmm.json configuration file
		final config:HmmConfig = Json.parse(File.getContent('./hmm.json'));

		// Iterate over each library dependency in the configuration
		for (lib in config.dependencies)
		{
			switch (lib.type)
			{
				case 'haxelib':
					// Prepare the haxelib install command arguments
					final args:Array<String> = ['install'];

					args.push(lib.name);

					if (lib.version != null)
						args.push(lib.version);

					args.push('--quiet');
					args.push('--skip-dependencies');

					// Execute the haxelib install command
					Sys.command('haxelib', args);
				case 'git':
					// Prepare the git command arguments
					final args:Array<String> = ['git'];

					args.push(lib.name);
					args.push(lib.git);
					args.push('--quiet');
					args.push('--skip-dependencies');

					// Execute the git command
					Sys.command('haxelib', args);
			}
		}
	}
}
