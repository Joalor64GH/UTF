package utf.objects.dialogue;

typedef Action =
{
	index:Int,
	type:String,
	value:String
}

class TagParser
{
	private static final regex:EReg = ~/(\[([a-zA-Z]+):([^\]]+)\])/;

	public static function parse(text:String):{cleanedText:String, actions:Array<Action>}
	{
		final cleanedText:StringBuf = new StringBuf();
		final actions:Array<Action> = new Array<Action>();

		var lastPos:Int = 0;
		var matchPos:Int = 0;

		while (regex.match(text))
		{
			matchPos = regex.matchedPos().pos;

			final fullMatch:String = regex.matched(1);
			final type:String = regex.matched(2);
			final value:String = regex.matched(3);

			cleanedText.addSub(text, lastPos, matchPos - lastPos);
			actions.push({index: cleanedText.length, type: type, value: value});

			lastPos = matchPos + fullMatch.length;
			text = text.substr(lastPos);
			lastPos = 0;
		}

		cleanedText.addSub(text, lastPos, text.length - lastPos);

		return {cleanedText: cleanedText.toString(), actions: actions};
	}
}
