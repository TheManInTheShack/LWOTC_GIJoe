class Isms_Effect_GhostFragile extends X2Effect_Persistent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
 
 	If (CurrentDamage > 2)
	{	
		DamageMod = int(float(CurrentDamage) * 0.15);
	}
 
	return DamageMod;
}