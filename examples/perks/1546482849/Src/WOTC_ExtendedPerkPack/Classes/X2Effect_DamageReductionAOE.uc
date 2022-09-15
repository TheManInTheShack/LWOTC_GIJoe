class X2Effect_DamageReductionAOE extends X2Effect_PersistentAOE;

var float DamageReduction;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (IsEffectCurrentlyRelevant(EffectState, TargetUnit) && CurrentDamage > 0)
	{
		DamageMod = -int(float(CurrentDamage) * DamageReduction);
	}

	return DamageMod;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
