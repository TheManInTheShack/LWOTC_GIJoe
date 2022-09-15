class MZ_Effect_FinishingStroke extends X2Effect_Persistent;
//ability does bonus damage as a percent of target's missing health

var float DamageMod;
var array<name> AbilityNames;
var bool bMainOnly;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit Target;

	if( AbilityNames.find(AbilityState.GetMyTemplateName()) == INDEX_NONE) {return 0;}

	if ( bMainOnly && AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	Target = XComGameState_Unit(TargetDamageable);
	If ( Target ==none) {return 0;}

	return (Target.GetMaxStat(eStat_HP) - Target.GetCurrentStat(eStat_HP)) * DamageMod;
}