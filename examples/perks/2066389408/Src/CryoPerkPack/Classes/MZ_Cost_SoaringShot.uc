class MZ_Cost_SoaringShot extends X2AbilityCost_Charges;

var name UseChargesFromAbilityName;
var int MinCharges;
var bool ConsumeAllCharges;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local XComGameStateHistory History;
	local StateObjectReference SharedAbilityRef;
	local XComGameState_Ability SharedAbilityState;

	SharedAbilityRef = ActivatingUnit.FindAbility(UseChargesFromAbilityName);
	if (SharedAbilityRef.ObjectID > 0)
	{
		History = `XCOMHISTORY;
		SharedAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SharedAbilityRef.ObjectID));
		if(SharedAbilityState.iCharges >= NumCharges && SharedAbilityState.iCharges >= MinCharges) { return 'AA_Success'; }
	}

	return 'AA_CannotAfford_Charges';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local StateObjectReference SharedAbilityRef;
	local XComGameState_Ability SharedAbilityState;

	if (bOnlyOnHit && AbilityContext.IsResultContextMiss())
	{
		return;
	}

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (UnitState == None)
	{
		History = `XCOMHISTORY;
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	}

	SharedAbilityRef = UnitState.FindAbility(UseChargesFromAbilityName);
	if (SharedAbilityRef.ObjectID > 0)
	{
		SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
		if (ConsumeAllCharges)
		{
			SharedAbilityState.iCharges = 0;
		}
		else
		{
			SharedAbilityState.iCharges -= NumCharges;
		}
	}
}

defaultproperties
{
	NumCharges = 1
	MinCharges = 1
	ConsumeAllCharges = false
}