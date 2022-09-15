class MZ_Effect_DR_StatBased extends X2Effect_Persistent;

var float DRScalar;
var ECharStatType UseStat;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if ( currentdamage == 0 ) { return 0; }
	return EffectState.GetSourceUnitAtTimeOfApplication().GetCurrentStat(UseStat) * DRScalar ;
}