class X2Effect_ActivateOverwatch extends X2Effect_Persistent config(ShadowOps);

var config array<name> OverwatchAbilities;
var name UnitValueName;

var private name EventName;

static private function TriggerAssociatedEvent(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameStateHistory History;
	local X2EventManager EventManager;

	`Log(string(GetFuncName()));

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventManager = `XEVENTMGR;
	EventManager.TriggerEvent(default.EventName, TargetUnit, SourceUnit);
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit SourceUnitState;
	local XComGameStateHistory History;
	local Object ListenerObj;

	`Log(string(GetFuncName()));

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	ListenerObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// Register for the required event
	EventMgr.RegisterForEvent(ListenerObj, default.EventName, EventHandler, ELD_OnStateSubmitted,, SourceUnitState,, EffectGameState);	
}

static function EventListenerReturn EventHandler(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState, OverwatchState;
	local X2Effect_ActivateOverwatch EffectTemplate;
	local XComGameState_Effect EffectState;
	local StateObjectReference OverwatchRef;
	local XComGameState NewGameState;
	local name AbilityName;
	local XComGameState_Item SourceWeapon;

	`Log(string(GetFuncName()));

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;

	EffectState = XComGameState_Effect(CallbackData);
	if (EffectState == none)
		return ELR_NoInterrupt;

	EffectTemplate = X2Effect_ActivateOverwatch(EffectState.GetX2Effect());
	EventMgr.UnRegisterFromEvent(CallbackData, EffectTemplate.EventName);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	foreach EffectTemplate.OverwatchAbilities(AbilityName)
	{
		OverwatchRef = UnitState.FindAbility(AbilityName);
		if (OverwatchRef.ObjectID == 0)
			continue;

		OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
		if (AbilityState.SourceWeapon.ObjectID != 0 && AbilityState.SourceWeapon != OverwatchState.SourceWeapon)
			continue;

		// Verify that the weapon has ammo
		SourceWeapon = OverwatchState.GetSourceWeapon();
		if (SourceWeapon.Ammo == 0)
			continue;

		// Found a valid overwatch ability. First, make a couple of changes before we activate the ability.

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));

		while (UnitState.NumActionPoints() < 2)
		{
			//  give the unit an action point so they can activate overwatch										
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);					
		}
		if (EffectTemplate.UnitValueName != '')
			UnitState.SetUnitFloatValue(EffectTemplate.UnitValueName, 1, eCleanup_BeginTurn);

		`TACTICALRULES.SubmitGameState(NewGameState);

		// Now activate the overwatch ability.

		OverwatchState.AbilityTriggerAgainstSingleTarget(UnitState.GetReference(), false);
		return ELR_NoInterrupt;
	}

	// No ability found
	return ELR_NoInterrupt;
}

defaultproperties
{
	EffectAddedFn=TriggerAssociatedEvent
	EventName="TriggerOverwatchAbility"
}