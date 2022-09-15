class X2AbilityCost_Ammo_ControlledFire extends X2AbilityCost_Ammo;

simulated function int CalcAmmoCost(XComGameState_Ability Ability, XComGameState_Item ItemState, XComGameState_BaseObject TargetState)
{
	local XComGameState_Unit ActivatingUnit;

	ActivatingUnit = XComGameState_Unit(TargetState);
	if (ActivatingUnit != none && 
		ActivatingUnit.HasSoldierAbility('F_ControlledFire') && 
		(Ability.GetMyTemplateName() == 'LW2WotC_AreaSuppressionShot' || Ability.GetMyTemplateName() == 'AreaSuppressionShot_LW'))
	{
		return 0;
	}
	
	return super.CalcAmmoCost(Ability, ItemState, TargetState);
}

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	if (ActivatingUnit.HasSoldierAbility('F_ControlledFire') && 
		(kAbility.GetMyTemplateName() == 'LW2WotC_AreaSuppressionShot' || kAbility.GetMyTemplateName() == 'AreaSuppressionShot_LW'))
	{
		return 'AA_Success';
	}
	
	return super.CanAfford(kAbility, ActivatingUnit);
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	if (Unit.HasSoldierAbility('F_ControlledFire') && 
		(kAbility.GetMyTemplateName() == 'LW2WotC_AreaSuppressionShot' || kAbility.GetMyTemplateName() == 'AreaSuppressionShot_LW'))
	{
		return;
	}

	super.ApplyCost(AbilityContext, kAbility, AffectState, AffectWeapon, NewGameState);
}