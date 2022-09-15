class MZ_Effect_ShieldResistsDamage extends X2Effect_Persistent;

var float ResistDamageMod; //, ResistCritMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit	Target;
	local int					Shield;

	Target = XComGameState_Unit(TargetDamageable);
	if ( Target == none || WeaponDamageEffect.bBypassShields == true || CurrentDamage < 1) { return 0; }

	Shield = Target.GetCurrentStat(eStat_ShieldHP);
	If ( Shield < 1) { return 0; }

	return -Min(Round(CurrentDamage * ResistDamageMod), Shield);
}