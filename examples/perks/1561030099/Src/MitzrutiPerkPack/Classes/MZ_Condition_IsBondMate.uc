class MZ_Condition_IsBondMate extends X2Condition;

var bool Nope;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit;
	local SoldierBond BondData;
	local StateObjectReference BondRef;
 
	SourceUnit = XComGameState_Unit(kSource);
	if (SourceUnit == none)
	{
		return 'AA_NotAUnit';
	}

	if (!SourceUnit.HasSoldierBond(BondRef, BondData))
	{
		if ( Nope)
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_NotABondmate';
		}
	}
	
	If ( BondRef.ObjectID == kTarget.ObjectID)
	{
		if ( Nope )
		{
			return 'AA_WrongBondLevel';
		}
		else
		{
			return 'AA_Success';
		}
	}
}