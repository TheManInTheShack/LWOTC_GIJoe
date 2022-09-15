// This is a variant of grimy's bonus damage effect that instead checks an array of multiple abilities.

class MZ_Effect_MultiAbilityDamage extends X2Effect_Persistent;

var float Bonus, TierMult;
var array<name> AbilityNames;
var int BaseDamage;
var bool bExcludeRobotic;
var bool bExcludeOrganic;
var bool bDOTOnly;
var bool bMainOnly;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local X2WeaponTemplate WeaponTemplate;

	if (AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE) { return 0; }

	if (bExcludeRobotic && XComGameState_Unit(TargetDamageable).GetMyTemplate().bIsRobotic) { return 0; }
	if (bExcludeOrganic && !XComGameState_Unit(TargetDamageable).GetMyTemplate().bIsRobotic) { return 0; }
	if ( bDOTOnly && AppliedData.EffectRef.ApplyOnTickIndex < 0 ) { return 0; }
	if ( bMainOnly && AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	if ( BaseDamage != 0 || TierMult != 0.0) {
		if ( AbilityState.GetSourceWeapon() != none ) {
			WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
			if (WeaponTemplate != none) {
				return BaseDamage + TierMult * WeaponTemplate.Tier;
			}
		}
	}

	return CurrentDamage * Bonus;
}

defaultproperties
{
	BaseDamage = 0
	TierMult = 0.0
	Bonus = 0
	bExcludeRobotic = false
	bExcludeOrganic = false
	bDOTOnly = false
	bMainOnly = false
}