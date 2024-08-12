package utf.modding.base;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A particles emitter that can be controlled by scripts.
 */
@:hscriptClass
class ScriptedFlxEmitter extends FlxTypedEmitter<FlxParticle> implements HScriptedClass {}
