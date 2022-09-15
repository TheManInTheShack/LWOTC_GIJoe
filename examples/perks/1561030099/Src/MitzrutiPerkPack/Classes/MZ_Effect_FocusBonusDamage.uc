class MZ_Effect_FocusBonusDamage extends X2Effect_Persistent;

var float DamagePerFocus;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local MZ_EffectState_Focus ManaEffectState;

	If ( AbilityNames.Length > 0 && AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE ) { return 0; }

	ManaEffectState = MZ_EffectState_Focus(Attacker.GetUnitAffectedByEffectState('FocusLevel'));
	if ( ManaEffectState != none )
	{
		return DamagePerFocus * ManaEffectState.FocusLevel;
	}
	else
	{
		return DamagePerFocus * Attacker.GetTemplarFocusLevel();
	}

	return 0;
}