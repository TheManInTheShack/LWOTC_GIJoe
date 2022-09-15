class MZ_Effect_SwordBulletVsSectoid extends X2Effect_Persistent;

var name AbilityName;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit Target;

	if ( AbilityState.GetMyTemplateName() == AbilityName )
	{
		Target = XComGameState_Unit(TargetDamageable);

		if (Target.HasSoldierAbility('VulnerabilityMelee', true) )
		{
			return class'X2Ability_Vulnerabilities'.default.MELEE_DAMAGE_MODIFIER;
		}
	}

	return 0;
}