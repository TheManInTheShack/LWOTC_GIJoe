class MZ_Effect_LastStand extends X2Effect_Persistent config(GameCore);

var privatewrite name LastStandEvent, SustainUsed;
var name AbilityToActivate;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local X2EventManager EventMan;
	local bool bCanPerformLastStand;
	local XComGameState_Unit AttackingUnit;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local UnitValue SustainValue;

	if( !UnitState.IsAbleToAct(true) )
	{
		// Stunned units may not go into Sustain
		return false;
	}

	if (UnitState.GetUnitValue(default.SustainUsed, SustainValue))
	{
		if (SustainValue.fValue > 0)
			return false;
	}

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	if (AbilityContext != none)
	{
		History = `XCOMHISTORY;
		AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(NewGameState);
		if (AttackingUnit != none 
			&& AttackingUnit.IsEnemyUnit(UnitState) 
			&& AbilityContext.InputContext.PrimaryTarget.ObjectID == UnitState.ObjectID
			&& (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == AttackingUnit.ControllingPlayer.ObjectID))
		{
			AbilityRef = UnitState.FindAbility(AbilityToActivate);
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (AbilityState != none)
			{
				if (AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit) == 'AA_Success')
				{
					bCanPerformLastStand = true;
				}
			}
		}
	}

	if (bCanPerformLastStand)
	{
		UnitState.SetUnitFloatValue(default.SustainUsed, 1, eCleanup_BeginTactical);
		UnitState.SetCurrentStat(eStat_HP, 1);
		EventMan = `XEVENTMGR;
		EventMan.TriggerEvent(default.LastStandEvent, AttackingUnit, UnitState, NewGameState);
		return true;
	}

	return false;
}

function bool PreBleedoutCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return PreDeathCheck(NewGameState, UnitState, EffectState);
}

DefaultProperties
{
	SustainUsed = "SustainUsed"
	LastStandEvent = "MZLastStandTriggered"
	EffectName = "MZLastStandEffect"
	DuplicateResponse = eDupe_Ignore
	AbilityToActivate = "MZLastStandTriggered"
	bInfiniteDuration=true
}