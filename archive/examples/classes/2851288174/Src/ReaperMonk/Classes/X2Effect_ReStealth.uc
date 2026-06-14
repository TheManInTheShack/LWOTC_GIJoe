class X2Effect_ReStealth extends X2Effect_Persistent config(MonkAbility);

function bool ReConceal(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit						OldTargetState, NewTargetState;

	
	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (OldTargetState.IsConcealed())
		return false;

	//if (!OldTargetState.IsDead())
	else
	{
		NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
		`XEVENTMGR.TriggerEvent('EffectEnterUnitConcealment', NewTargetState, NewTargetState, NewGameState);
	}	

	return false;
}

//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
	//local X2EventManager EventMgr;
	//local XComGameState_Unit UnitState;
	//local Object EffectObj;
//
	//EventMgr = `XEVENTMGR;
	//EffectObj = EffectGameState;
	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
//
	//EventMgr.RegisterForEvent(EffectObj, 'KillMail', KVReStealthListener, ELD_OnStateSubmitted, , UnitState);
//}
//
//static function EventListenerReturn KVReStealthListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
//{
	////local XComGameStateContext_Ability AbilityContext;
	//local XComGameState_Unit Killer;
//
	//Killer = XComGameState_Unit(EventSource);
	////AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	//if (Killer != None && !Killer.IsConcealed())
	//{
		//Killer.EnterConcealment();      //  this creates a new game state and submits it
	//}
//
	//return ELR_NoInterrupt;
//}

//&& AbilityContext.InputContext.AbilityTemplateName == 'Shadowfall'  && AbilityContext != none

//class X2Effect_ReStealth extends X2Effect_Persistent config(MonkAbility);

//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
	//local Object EffectObj;
	//local X2EventManager EventMan;
//
	//EffectObj = EffectGameState;
	//EventMan = `XEVENTMGR;
	//EventMan.RegisterForEvent(EffectObj, 'KillMail', EffectGameState.FullThrottleListener, ELD_OnStateSubmitted);
	////EventMan.RegisterForEvent(EffectObj, 'HomingMineDetonated', EffectGameState.DistractionListener, ELD_OnStateSubmitted);
//}
//
//DefaultProperties
//{
	//EffectName = "Distraction"
	//DuplicateResponse = eDupe_Ignore
//}