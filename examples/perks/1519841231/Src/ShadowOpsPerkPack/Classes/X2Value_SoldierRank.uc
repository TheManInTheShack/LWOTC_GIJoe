class X2Value_SoldierRank extends XMBValue;

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	return UnitState.GetSoldierRank();
}