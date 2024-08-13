package utf.modding;

import polymod.backends.OpenFLBackend;
import utf.AssetPaths;

@:access(utf.AssetPaths)
class AssetsBackend extends OpenFLBackend
{
	public override function clearCache():Void
	{
		super.clearCache();

		AssetPaths.PERSISTENT_SOUNDS.splice(0, AssetPaths.PERSISTENT_SOUNDS.length);
		AssetPaths.PERSISTENT_FONTS.splice(0, AssetPaths.PERSISTENT_FONTS.length);
	}
}
