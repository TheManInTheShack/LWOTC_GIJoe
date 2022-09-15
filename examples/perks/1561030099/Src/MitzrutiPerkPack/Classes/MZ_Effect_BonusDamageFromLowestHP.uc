class MZ_Effect_BonusDamageFromLowestHP extends X2Effect_Persistent;

var float BonusScalar;
var float BetaBonusScalar;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	
	if ( AbilityNames.Length > 0 && AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE) {return 0;}

	if ( `SecondWaveEnabled('BetaStrike') ){ return (Attacker.GetMaxStat(eStat_HP) - Attacker.LowestHP) * BetaBonusScalar; }
	return (Attacker.GetMaxStat(eStat_HP) - Attacker.LowestHP) * BonusScalar;
}