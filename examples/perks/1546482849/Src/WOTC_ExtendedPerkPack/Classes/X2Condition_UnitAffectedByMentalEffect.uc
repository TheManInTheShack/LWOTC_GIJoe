class X2Condition_UnitAffectedByMentalEffect extends X2Condition;

function name MeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
    {
		return 'AA_NotAUnit';
    }

	if (TargetUnit.IsPanicked() || TargetUnit.IsDisoriented() || TargetUnit.IsDazed() || TargetUnit.IsStunned())
    {
		return 'AA_Success';
    }

	return 'AA_UnitIsNotImpaired';
}