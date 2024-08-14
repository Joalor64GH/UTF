package utf.states.room;

import polymod.hscript.HScriptedClass;
import utf.substates.battle.EnemyEncounter;

/**
 * An enemy encounter that can be controlled by scripts.
 */
@:hscriptClass
class ScriptedEnemyEncounter extends EnemyEncounter implements HScriptedClass {}
