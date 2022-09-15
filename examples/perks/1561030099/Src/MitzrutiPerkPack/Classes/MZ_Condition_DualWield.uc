class MZ_Condition_DualWield extends X2Condition;

var bool bIsDual;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(kSource);

	if ( X2WeaponTemplate(SourceUnit.GetPrimaryWeapon().GetMyTemplate()).WeaponCat == X2WeaponTemplate(SourceUnit.GetSecondaryWeapon().GetMyTemplate()).WeaponCat )
	{
		if ( bIsDual )
		{
			return 'AA_Success';
		}
	}
	else if ( !bIsDual)
	{
		return 'AA_Success';
	}

	return 'AA_WeaponIncompatible';
}

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	if ( X2WeaponTemplate(SourceUnit.GetPrimaryWeapon().GetMyTemplate()).WeaponCat == X2WeaponTemplate(SourceUnit.GetSecondaryWeapon().GetMyTemplate()).WeaponCat )
	{
		return bIsDual;
	}

	return !bIsDual;
}

defaultproperties
{
	bIsDual = True;
}