// This is an Unreal Script
class MZ_Effect_NeuralDamping extends X2Effect_Persistent;

var array<name> ImmuneTypes;
var float BonusMult;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return (ImmuneTypes.Find(DamageType) != INDEX_NONE);
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local array<name> AppliedDamageTypes;
	local name DamageType;
	local X2Effect_ApplyWeaponDamage ApplyDamageEffect;

	if (AbilityState.GetMyTemplate().AbilitySourceName == 'eAbilitySource_Psionic')
	{
		return CurrentDamage * BonusMult;
	}

	ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (ApplyDamageEffect != none)
	{
		ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);

		foreach AppliedDamageTypes(DamageType)
		{
			if (DamageType=='Psi' && !TargetDamageable.IsImmuneToDamage(DamageType))
			{
				return CurrentDamage * BonusMult;
			}
		}
	}

	return 0;
}

