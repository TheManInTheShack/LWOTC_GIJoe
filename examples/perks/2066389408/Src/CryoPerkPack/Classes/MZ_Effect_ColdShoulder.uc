class MZ_Effect_ColdShoulder extends X2Effect_Persistent;

var int ChillFlatDR, BChillFlatDR;
var float ChillPercentDR, BCHillPercentDR;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{

	if ( Attacker.AffectedByEffectNames.Find('Freeze') != INDEX_NONE || Attacker.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE)
	{
		return -(CurrentDamage * BChillPercentDR) - BChillFlatDR;
	}
	else if ( Attacker.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || Attacker.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
	{
		return -(CurrentDamage * ChillPercentDR) - ChillFlatDR;
	}

	return 0;
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return DamageType == 'Frost';
}