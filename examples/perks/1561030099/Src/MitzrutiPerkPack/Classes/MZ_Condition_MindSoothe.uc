class MZ_Condition_MindSoothe extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit;
	local XComGameState_Unit TargetUnit;

	SourceUnit = XComGameState_Unit(kSource);
	if (SourceUnit == none)
	{
		return 'AA_NotAUnit';
	}

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
	{
		return 'AA_NotAUnit';
	}

	If ( SourceUnit.IsEnemyUnit(TargetUnit) )
	{
		If ( TargetUnit.IsMindControlled() )
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_UnitIsHostile';
		}
	}

	If ( SourceUnit.IsFriendlyUnit(TargetUnit) )
	{
		If ( TargetUnit.IsMindControlled() )
		{
			return 'AA_UnitIsMindControlled';
		}
		else
		{
			return 'AA_Success';
		}
	}

	return 'AA_UnknownError';
}