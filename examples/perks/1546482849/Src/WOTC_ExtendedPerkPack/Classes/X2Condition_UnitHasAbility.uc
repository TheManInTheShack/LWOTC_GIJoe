class X2Condition_UnitHasAbility extends X2Condition;

var name RequiredAbility;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(kSource);

	if (SourceUnit == none || !SourceUnit.HasSoldierAbility(RequiredAbility))
	{
		return 'AA_InvalidAbility';
	}

	return 'AA_Success';
}