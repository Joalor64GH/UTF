package utf.backend;

import flixel.FlxG;
import haxe.Exception;
import haxe.Http;
import haxe.Json;
import openfl.Lib;
import utf.util.github.Contributor;

/**
 * Utility class for interacting with the GitHub API.
 */
class GitHubUtil
{
	/**
	 * The GitHub username for the repository owner.
	 */
	public static var USER(default, null):String = 'MAJigsaw77';

	/**
	 * The name of the GitHub repository.
	 */
	public static var REPOSITORY(default, null):String = 'UTF';

	/**
	 * Retrieves the list of contributors for the specified GitHub repository.
	 *
	 * @return An array of Contributor objects representing the contributors.
	 * @throws Exception if there is an error while fetching the contributors.
	 */
	public static inline function getContributors():Array<Contributor>
	{
		var contributors:Array<Contributor> = [];

		try
		{
			var http:Http = new Http('https://api.github.com/repos/$USER/$REPOSITORY/contributors');
			http.setHeader('User-Agent', 'UTF v${Lib.application.meta['version']}');
			http.onStatus = function(status:Int):Void
			{
				if (status >= 300 && status < 400)
				{
					if (http.responseHeaders.exists('Location'))
					{
						http.url = http.responseHeaders.get('Location');
						http.request(false);
					}
					else
						FlxG.log.error('Redirect location header missing');
				}
			}
			http.onData = function(data:String):Void
			{
				if (data != null && data.length > 0)
					contributors = Json.parse(data.trim());
			}
			http.onError = (message:String) -> throw message;
			http.request(false);
		}
		catch (e:Exception)
			FlxG.log.error('Error while trying to get the contributors: ${e.message}');

		return contributors;
	}
}
