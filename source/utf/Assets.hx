package utf;

@:nullSafety
class Assets
{
	public static function getSound(path:String, ?cache:Bool = true):Null<Sound>
	{
		if (!Assets.exists(path))
			return null;

		try
		{
			return Assets.getSound(path, cache);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function getBitmapData(path:String, ?force:Bool = false):Null<BitmapData>
	{
		if (!Assets.exists(path))
			return null;

		try
		{
			return Assets.getSound(path, cache);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function list(directory:String, extension:String):Array<String>
	{
		final files:Array<String> = Assets.list().filter(function(file:String):Bool
		{
			return
				(extension != null && extension.length > 0) ? (Path.directory(file) == directory && Path.extension(file) == extension) : Path.directory(file) == directory;
		});

		files.sort(function(a:String, b:String):Int
		{
			return (a < b) ? -1 : (a > b) ? 1 : 0;
		});

		return files;
	}

	public static function getContent(path:String, ?force:Bool = false):String
	{
		if (!Assets.exists(path) && !force)
			return null;

		try
		{
			return Assets.getText(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}

	public static function getBytes(path:String, ?force:Bool = false):Null<ByteArray>
	{
		if (!Assets.exists(path) && !force)
			return null;

		try
		{
			return Assets.getBytes(path);
		}
		catch (e:Exception)
			FlxG.log.error(e.message);

		return null;
	}
}
