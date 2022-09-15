// By Reality Machina
class rm_Condition_MimeticSkin extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;
	//local GameRulesCache_VisibilityInfo VisibilityInfo;
	//local X2GameRulesetVisibilityManager VisibilityMgr;

	UnitState = XComGameState_Unit(kTarget);
	//VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	if (UnitState == none)
		return 'AA_NotAUnit';

	if (UnitState.IsConcealed())
		return 'AA_UnitIsConcealed';

	if (class'X2TacticalVisibilityHelpers'.static.GetNumEnemyViewersOfTarget(kTarget.ObjectID) > 0) //can't be seen by any enemies
		return 'AA_UnitIsFlanked';

	if(UnitState.GetCoverTypeFromLocation() == CT_None || UnitState.GetCoverTypeFromLocation() == CT_MidLevel) //can't be in none, or half cover
		return 'AA_UnitIsFlanked';

	return 'AA_Success'; 
}