class Grimy_AbilityCost_HP extends X2AbilityCost;

var int Cost;
var float PercentCost; //only values between 0 and 1 matter. Is a percentage of CURRENT health.
//var bool	bFreeCost;
var int		FreeCostShots;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit) {
	local int BloodCost;

	BloodCost = Cost;
	if ( ActivatingUnit.HasSoldierAbility('MZDropByDrop') )
	{
		if ( BloodCost > 1 )
		{
			BloodCost = BloodCost - class'MZBloodMagic_AbilitySet'.default.DropByDrop_HPCostDown;
		}
	}

	if ( ActivatingUnit.HasSoldierAbility('MZDarkPotency') && kAbility.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		BloodCost = BloodCost + class'MZBloodMagic_AbilitySet'.default.DarkPotency_HPCostUp;
	}


	if ( (bFreeCost == True && ActivatingUnit.GetCurrentStat(eStat_HP) > (BloodCost * FreeCostShots) && ActivatingUnit.GetCurrentStat(eStat_HP) > 1) || ( !bFreeCost && ActivatingUnit.GetCurrentStat(eStat_HP) > BloodCost && ActivatingUnit.GetCurrentStat(eStat_HP) > 1 ) )
	{
		return 'AA_Success';
	}

	return 'AA_CannotAfford_HP';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState) {
	local XComGameState_Unit ModifiedUnitState;
	local int BloodCost;

	if ( !bFreeCost )
	{
		ModifiedUnitState = XComGameState_Unit(AffectState);

		BloodCost = ModifiedUnitState.GetCurrentStat(eStat_HP) * PercentCost;

		if ( BloodCost < Cost )
		{
			BloodCost = Cost;
		}

		if ( ModifiedUnitState.HasSoldierAbility('MZDropByDrop') )
		{
			if ( BloodCost > 1 )
			{
				BloodCost = BloodCost - class'MZBloodMagic_AbilitySet'.default.DropByDrop_HPCostDown;
				if ( BloodCost <= 0 ) { BloodCost = 1; }
			}
		}

		if ( ModifiedUnitState.HasSoldierAbility('MZDarkPotency') && kAbility.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			BloodCost = BloodCost + class'MZBloodMagic_AbilitySet'.default.DarkPotency_HPCostUp;
		}

		if ( BloodCost >= ModifiedUnitState.GetCurrentStat(eStat_HP) )
		{
			BloodCost = ModifiedUnitState.GetCurrentStat(eStat_HP) - 1;
		}

		ModifiedUnitState.SetCurrentStat(eStat_HP, ModifiedUnitState.GetCurrentStat(eStat_HP) - BloodCost);
	}
}

defaultproperties
{
	Cost = 1
	PercentCost = 0
	bFreeCost = false
	FreeCostShots = 1
}