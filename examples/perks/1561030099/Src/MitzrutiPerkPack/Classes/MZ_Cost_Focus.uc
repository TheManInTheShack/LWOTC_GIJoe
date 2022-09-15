class MZ_Cost_Focus extends X2AbilityCost_Focus;

/*
var int FocusAmount;
var bool ConsumeAllFocus;
var bool GhostOnlyCost;
*/

var int ManaAmount, MaxManaCost;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local int FocusLevel;
	local MZ_EffectState_Focus ManaEffectState;
	local UnitValue						CurrentFocusValue;

	if( GhostOnlyCost && ActivatingUnit.GhostSourceUnit.ObjectID == 0 )
	{
		return 'AA_Success';
	}
	
	ManaEffectState = MZ_EffectState_Focus(ActivatingUnit.GetUnitAffectedByEffectState('FocusLevel'));
    if (ManaEffectState != none )
    {
		if (ManaEffectState.FocusLevel >= GetManaCost(kAbility, ActivatingUnit, ManaEffectState))
		{
			return 'AA_Success';
		}
    }
    else
    {
        FocusLevel = ActivatingUnit.GetTemplarFocusLevel();
        if (FocusLevel >= FocusAmount)
		{
            return 'AA_Success';
		}
    }

	if ( ActivatingUnit.GetUnitValue('WOTC_APA_Templar_CurrentFocusLevel', CurrentFocusValue) )
	{
		if (CurrentFocusValue.fValue >= FocusAmount)
		{
			return 'AA_Success';
		}
	}

	return 'AA_CannotAfford_Focus';
}

function int GetManaCost(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit, MZ_EffectState_Focus ManaEffectState)
{	 
	if ( ConsumeAllFocus )
	{	
		return Max(ManaAmount, ManaEffectState.FocusLevel);
	}

	return ManaAmount;
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Effect_TemplarFocus FocusState;
	local MZ_EffectState_Focus ManaEffectState;
	local XComGameState_Unit ActivatingUnit;
	local int ManaCost;
	local UnitValue CurrentFocusValue;

	ActivatingUnit = XComGameState_Unit(AffectState);

	if (bFreeCost || FocusAmount < 1 || (GhostOnlyCost && ActivatingUnit.GhostSourceUnit.ObjectID == 0) )
		return;

	ManaEffectState = MZ_EffectState_Focus(ActivatingUnit.GetUnitAffectedByEffectState('FocusLevel'));
    if ( ManaEffectState != none)
    {
		ManaCost = GetManaCost(kAbility, ActivatingUnit, ManaEffectState);
		ManaEffectState.SetFocusLevel(ManaEffectState.FocusLevel - ManaCost, ActivatingUnit, NewGameState);
	}
	else
	{
		FocusState = ActivatingUnit.GetTemplarFocusEffectState();
		`assert(FocusState != none);
		FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
		if( ConsumeAllFocus )
		{
			FocusState.SetFocusLevel(0, XComGameState_Unit(AffectState), NewGameState);
		}
		else
		{
			FocusState.SetFocusLevel(FocusState.FocusLevel - FocusAmount, XComGameState_Unit(AffectState), NewGameState);
		}
	}

	if ( ActivatingUnit.GetUnitValue('WOTC_APA_Templar_CurrentFocusLevel', CurrentFocusValue) )
	{
		if( ConsumeAllFocus )
		{
			ActivatingUnit.SetUnitFloatValue('WOTC_APA_Templar_CurrentFocusLevel', 0, eCleanup_BeginTactical);
		}
		else
		{
			ActivatingUnit.SetUnitFloatValue('WOTC_APA_Templar_CurrentFocusLevel', CurrentFocusValue.fValue - FocusAmount, eCleanup_BeginTactical);
		}
	}
}

// Start Issue #257, also see CHHelpers for Issue #257
// Add or set the preview cost.
// Return true to indicate that the out TotalPreviewCost should be returned immediately from XComGameState_Ability::GetFocusCost
// *extended version of the highlander thing. should i really include highlander comments? eh whatever.
simulated function bool PreviewFocusCost(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, out int TotalPreviewCost)
{
	local MZ_EffectState_Focus ManaEffectState;
	local int ManaCost;

	if ( GhostOnlyCost && UnitState.GhostSourceUnit.ObjectID == 0)
		return false;
	
	ManaEffectState = MZ_EffectState_Focus(UnitState.GetUnitAffectedByEffectState('FocusLevel'));
	
    if ( ManaEffectState != none )
    {
		ManaCost = GetManaCost(AbilityState, UnitState, ManaEffectState);
		TotalPreviewCost += ManaCost;
		if ( ManaEffectState.FocusLevel >= ManaCost)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		if (ConsumeAllFocus && UnitState.GetTemplarFocusLevel() != 0)
		{
			TotalPreviewCost = UnitState.GetTemplarFocusLevel();
			return true;
		}
	}

	TotalPreviewCost += FocusAmount;
	return false;
}
// End Issue #257


DefaultProperties
{
	FocusAmount = 1;
	ManaAmount = 3;
}