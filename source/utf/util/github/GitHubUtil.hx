package utf.util.github;

import flixel.FlxG;
import haxe.Exception;
import haxe.Http;
import haxe.Json;
import openfl.Lib;

using StringTools;

/**
 * Represents a GitHub contributor.
 */
typedef Contributor =
{
	login:String,
	id:Int,
	node_id:String,
	avatar_url:String,
	gravatar_id:String,
	url:String,
	html_url:String,
	followers_url:String,
	following_url:String,
	gists_url:String,
	starred_url:String,
	subscriptions_url:String,
	organizations_url:String,
	repos_url:String,
	events_url:String,
	received_events_url:String,
	type:String,
	site_admin:Bool,
	contributions:Int
}

/**
 * Utility class for interacting with the GitHub API.
 */
class GitHubUtil
{
	/**
	 * The GitHub username for the repository owner.
	 */
	@:noCompletion
	private static final USER:String = 'MAJigsaw77';

	/**
	 * The name of the GitHub repository.
	 */
	@:noCompletion
	private static final REPOSITORY:String = 'UTF';

	/**
	 * Retrieves the list of contributors for the specified GitHub repository.
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
					final responseLocation:Null<String> = http.responseHeaders.get('Location');

					if (responseLocation != null)
					{
						http.url = responseLocation;
						http.request(false);
					}
					else
						throw 'Redirect location header missing';
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
