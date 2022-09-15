class MZ_Effect_KnifeFlurryBonus extends X2Effect_Persistent;

var float Bonus;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local X2WeaponTemplate WeaponTemplate;

	if (AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE) { return 0; }

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	if ( AbilityState.GetSourceWeapon() != none ) {
		WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if (WeaponTemplate != none) {
			return Bonus * WeaponTemplate.BaseDamage.Damage;
		}
	}

	return 0;
}