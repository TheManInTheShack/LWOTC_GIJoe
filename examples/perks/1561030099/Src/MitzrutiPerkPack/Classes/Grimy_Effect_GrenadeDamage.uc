class Grimy_Effect_GrenadeDamage extends X2Effect_Persistent;

var float DamageMult;
var int BonusDamage;
var bool bDOTOnly;
var bool bExcluderockets;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local XComGameState_Item SourceWeapon;
	local X2GrenadeTemplate GrenadeTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();

	if ( bDOTOnly && AppliedData.EffectRef.ApplyOnTickIndex < 0 ) { return 0; }

	if (SourceWeapon != none) {
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
		if (GrenadeTemplate == none) {
			GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
		}

		if (GrenadeTemplate != none) {
			if ( !bExcluderockets || !GrenadeTemplate.IsA('X2RocketTemplate') ) {
				return DamageMult * CurrentDamage + BonusDamage;
			}
		}
	}
	return 0;
}

DefaultProperties
{
	BonusDamage = 0
	DamageMult = 0.0
	bDOTOnly = false
	bExcluderockets = false
	DuplicateResponse = eDupe_Allow
}