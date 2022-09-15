class MZ_Effect_StrafeComboDamage extends X2Effect_Persistent;

var array<name> AbilityNames;
var int Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local UnitValue					StrafePoints;

	Attacker.GetUnitValue('StrafePointsThisTurn', StrafePoints);

	if( AbilityNames.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE && StrafePoints.fValue > 0 )
	{
		return StrafePoints.fValue * Bonus;
	}

	return 0;		
}