class Grimy_Effect_BonusHexHunter extends X2Effect_Persistent;

var float Bonus;
var name AbilityName;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	if (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	return XComGameState_Unit(TargetDamageable).GetMaxStat(eStat_PsiOffense) / Bonus;
}