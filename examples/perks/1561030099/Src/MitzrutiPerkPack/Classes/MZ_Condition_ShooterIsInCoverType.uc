class MZ_Condition_ShooterIsInCoverType extends X2Condition;

var ECoverType MatchCover;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(kSource);

	if (SourceUnit.GetCoverTypeFromLocation() == MatchCover)
	{
		return 'AA_Success';
	}
	
	return 'AA_InvalidPeekType';
}