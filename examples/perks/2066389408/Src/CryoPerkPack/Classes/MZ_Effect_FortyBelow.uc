class MZ_Effect_FortyBelow extends X2Effect_Persistent;

var int FlatBonus, PerTierBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit			TargetState;
	local array<name> AppliedDamageTypes;
	local X2Effect_ApplyWeaponDamage ApplyDamageEffect;
	local int bonus;

	if ( TargetDamageable.IsImmuneToDamage('Frost') ) { return 0; }

	TargetState = XComGameState_Unit(TargetDamageable);

	if (TargetState != none && TargetState.AffectedByEffectNames.Find('Burning') == INDEX_NONE)
	{
		if ( TargetState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE )
		{
			Bonus = FlatBonus + 2*PerTierBonus;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE )
		{
			Bonus = FlatBonus + PerTierBonus;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
		{
			Bonus = FlatBonus;
		}
		else
		{
			return 0;
		}
	}

	ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (ApplyDamageEffect != none && Bonus > 0)
	{
		ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);

		if ( AppliedDamageTypes.Find('Frost') != INDEX_NONE )
		{
			return Bonus;
		}
	}

	return 0;
}