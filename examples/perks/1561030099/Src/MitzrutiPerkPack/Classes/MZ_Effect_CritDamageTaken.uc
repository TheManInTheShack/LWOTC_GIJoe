class MZ_Effect_CritDamageTaken extends X2Effect_Persistent;

var float DamageMult;
var int DamageFlat;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{	
	if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		return CurrentDamage*DamageMult + DamageFlat;
	}
 
	return 0;
}