// This is an Unreal Script
class MZ_Effect_Shellbust extends X2Effect_Persistent;

var int BonusShred;
var int BonusAP;
var name AbilityName;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	if (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	return BonusShred;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	if (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	return BonusAP;
}