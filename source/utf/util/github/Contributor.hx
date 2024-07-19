package utf.util.github;

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
