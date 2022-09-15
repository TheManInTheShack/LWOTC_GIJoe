class Grimy_Effect_BonusExecute extends X2Effect_Persistent config(GrimyPerkPorts);

var float Bonus;
var config array<name> MarkEffectNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local name		MarkEffectName;
	local XComGameState_Unit	Target;
	
	if ( !AbilityState.IsMeleeAbility() ) { return 0; }
	
	Target = XComGameState_Unit(TargetDamageable);
	foreach default.MarkEffectNames(MarkEffectName)
	{
		if (Target.AffectedByEffectNames.Find(MarkEffectName) != INDEX_NONE)
		{
			return CurrentDamage * Bonus ;
		}
	}
	
	return 0;
}