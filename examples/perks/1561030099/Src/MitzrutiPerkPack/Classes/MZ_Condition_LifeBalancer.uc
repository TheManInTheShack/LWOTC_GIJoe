class MZ_Condition_LifeBalancer extends X2Condition;

var bool bAllowDrainAlly;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit, TargetUnit;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit == none || TargetUnit == none)
	{
		return 'AA_NotAUnit';
	}

	//on friendly targets: only targets that HP can be given to
	if ( SourceUnit.IsFriendlyUnit(TargetUnit) )
	{
		//if the target has 1 less HP than the caster, no HP will be transffered due to how the effect rounds. so invalidate that as a target option.
		if ( TargetUnit.GetCurrentStat(eStat_HP) < TargetUnit.GetMaxStat(eStat_HP) && TargetUnit.GetCurrentStat(eStat_HP) < SourceUnit.GetCurrentStat(eStat_HP) - 1 )
		{
			return 'AA_Success';
		}

		if ( bAllowDrainAlly )
		{
			if ( SourceUnit.GetCurrentStat(eStat_HP) < SourceUnit.GetMaxStat(eStat_HP) && TargetUnit.GetCurrentStat(eStat_HP) > SourceUnit.GetCurrentStat(eStat_HP) )
			{
				return 'AA_Success';
			}
		}

		return 'AA_UnitIsNotInjured';
	}

	//on enemey targets: only targets that HP can be taken from
	if ( SourceUnit.IsEnemyUnit(TargetUnit) )
	{
		if ( SourceUnit.GetCurrentStat(eStat_HP) < SourceUnit.GetMaxStat(eStat_HP) && TargetUnit.GetCurrentStat(eStat_HP) > SourceUnit.GetCurrentStat(eStat_HP) )
		{
			return 'AA_Success';
		}

		return 'AA_MissingRequiredEffect';
	}
}

defaultproperties
{
	bAllowDrainAlly = true
}