class MZ_Cost_AP_FreeIfLethal extends X2AbilityCost_ActionPoints;

//got this stuff made in case it's needed, but...
//var name RequiredAbility, RequiredEffect;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit; //, SourceUnit;
	
	//SourceUnit = XComGameState_Unit(AffectState);
	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

	//if ( SourceUnit != none && (RequiredAbility == '' || SourceUnit.HasSoldierAbility(RequiredAbility) && (RequiredEffect == none || SourceUnit.AffectedByEffectNames.Find(RequiredEffect) != INDEX_NONE) )
	//{
	if (TargetUnit != none && TargetUnit.IsDead())
	{
		return;
	}
	//}

	super.ApplyCost(AbilityContext, kAbility, AffectState, AffectWeapon, NewGameState);
}
