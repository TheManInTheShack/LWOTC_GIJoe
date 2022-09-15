// This is an Unreal Script
class MZ_Condition_Concealed extends X2Condition;

//just yoinking this from musashi's stealth overhaul.

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);

	if (!UnitState.IsConcealed())
		return 'AA_NoTargets';

	return 'AA_Success'; 
}