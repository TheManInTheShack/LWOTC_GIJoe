class MZ_Cooldown_AbilitySetReduces extends X2AbilityCooldown;

var array<name> AbilityInSet;
var int PerAbilityChange;

defaultproperties
{
	PerAbilityChange = -1
}

///Also need to trigger all the shared abilities cooldowns.

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local name AbilityName;
	local int Cooldown;

	UnitState = XComGameState_Unit(AffectState);
	Cooldown = iNumTurns;
	if(UnitState != none)
	{
		foreach AbilityInSet(AbilityName)
		{
			if ( UnitState.HasSoldierAbility(AbilityName, true) )
			{
				Cooldown += PerAbilityChange;
			}
		}
	}

	return Cooldown;
}

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateContext_Ability	AbilityContext;
	local name							AbilityName;

	local XComGameState_Ability			AbilityState;
	local XComGameState_Unit			UnitState;
	local StateObjectReference			AbilityRef;

	// For debug only
	if(`CHEATMGR != None && `CHEATMGR.strAIForcedAbility ~= string(kAbility.GetMyTemplateName()))
		iNumTurns = 0;

	if(bDoNotApplyOnHit)
	{
		AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
		if(AbilityContext != None && AbilityContext.IsResultContextHit())
			return;
	}
	kAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);

	UnitState = XComGameState_Unit(AffectState);
	if(UnitState != none)
	{
		foreach AbilityInSet(AbilityName)
		{
			AbilityRef = UnitState.FindAbility(AbilityName);
			if(AbilityRef.ObjectID != 0)
			{
				AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(AbilityRef.ObjectID));
				if(AbilityState == none)
				{
					// This AbilityState needs to be added to the NewGameState
					AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));

					// Apply the same cooldown to it.
					AbilityState.iCooldown = GetNumTurns(AbilityState, AffectState, AffectWeapon, NewGameState);
				}
			}
		}
	}
}