// This is an Unreal Script

class MZ_Effect_NeuralFeedbackDamageBonus extends X2Effect_Persistent;

var name AbilityName;
var float DamagePerRank;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {

	If (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	return Attacker.GetSoldierRank() * DamagePerRank;
}
