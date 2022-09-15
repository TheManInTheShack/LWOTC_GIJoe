class MZ_Effect_PiercingCold extends X2Effect_Persistent;

var int BonusShred;
var int BonusAP;
var bool Shred, Pierce;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	local XComGameState_Unit			TargetState;

	if ( TargetDamageable.IsImmuneToDamage('Frost') || !Shred ) { return 0; }

	TargetState = XComGameState_Unit(TargetDamageable);

	if (TargetState != none && TargetState.AffectedByEffectNames.Find('Burning') == INDEX_NONE)
	{
		if ( TargetState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE )
		{
			return 3 + BonusShred;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE )
		{
			return 2 + BonusShred;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
		{
			return 1 + BonusShred;
		}
	}

	return 0;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	local XComGameState_Unit			TargetState;

	if ( TargetDamageable.IsImmuneToDamage('Frost') || !Pierce ) { return 0; }

	TargetState = XComGameState_Unit(TargetDamageable);

	if (TargetState != none && TargetState.AffectedByEffectNames.Find('Burning') == INDEX_NONE)
	{
		if ( TargetState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE )
		{
			return 3 + BonusAP;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE )
		{
			return 2 + BonusAP;
		}
		else if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
		{
			return 1 + BonusAP;
		}
	}

	return 0;
}