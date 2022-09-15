class X2Condition_Concealed extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);

	if (!UnitState.IsConcealed())
		return 'AA_NoTargets';

	return 'AA_Success'; 
}