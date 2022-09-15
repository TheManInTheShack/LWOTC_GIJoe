class X2Condition_UnitAffectedByPhysicalEffect extends X2Condition;

function name MeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
    {
		return 'AA_NotAUnit';
    }

	if (TargetUnit.IsBurning() || TargetUnit.IsPoisoned() || TargetUnit.IsAcidBurning())
    {
		return 'AA_Success';
    }

    if (TargetUnit.AffectedByEffectNames.Find(class'X2StatusEffects'.default.BleedingName) != INDEX_NONE)
    {
        return 'AA_Success';
    }

	return 'AA_UnitIsNotImpaired';
}