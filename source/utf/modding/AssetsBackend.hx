package utf.modding;

import polymod.backends.OpenFLBackend;
import utf.AssetPaths;

@:access(utf.AssetPaths)
class AssetsBackend extends OpenFLBackend
{
	public override function clearCache():Void
	{
		super.clearCache();

		AssetPaths.PERSISTENT_SOUNDS = [];
		AssetPaths.PERSISTENT_FONTS = [];
	}
}
