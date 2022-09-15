class X2Effect_ScaledConditionalStatChange extends X2Effect_Persistent;

//var ECharStatType Stat;
//var int BonusPerEnemy;
//var int MaxBonus;
//
//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
	//local XComGameState_Unit UnitState;
	//local X2EventManager EventMgr;
	//local Object ListenerObj;
//
	//EventMgr = `XEVENTMGR;
//
	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
//
	//ListenerObj = EffectGameState;
//
	//// Register to tick after EVERY action.
	//EventMgr.RegisterForEvent(ListenerObj, 'OnUnitBeginPlay', EventHandler, ELD_OnStateSubmitted, 25, UnitState,, EffectGameState);	
	//EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', EventHandler, ELD_OnStateSubmitted, 25,,, EffectGameState);	
//}
//
//static function EventListenerReturn EventHandler(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
//{
	//local XComGameState_Unit UnitState, SourceUnitState, NewUnitState;
	//local XComGameState_Effect NewEffectState;
	//local XComGameState_Ability AbilityState;
	//local XComGameState NewGameState;
	//local XMBEffect_ConditionalStatChange EffectTemplate;
	//local XComGameState_Effect EffectState;
	//local bool bOldApplicable, bNewApplicable;
    //
	//local int BadGuys;
    //local int OldBonus;
    //local int NewBonus;
//
	//EffectState = XComGameState_Effect(CallbackData);
	//if (EffectState == none)
    //{
		//return ELR_NoInterrupt;
    //}
    //
	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
//
    //BadGuys = UnitState.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
    //NewBonus = Clamp (BadGuys * BonusPerEnemy, 0, MaxBonus);
    //OldBonus = 
    //
	//bOldApplicable = EffectState.StatChanges.Length > 0;
    //bNewApplicable = (BadGuys > 0);
//
//
    ////
//
	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	//SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	//AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
//
	//EffectTemplate = XMBEffect_ConditionalStatChange(EffectState.GetX2Effect());
//
	//bOldApplicable = EffectState.StatChanges.Length > 0;
	//bNewApplicable = class'XMBEffectUtilities'.static.CheckTargetConditions(EffectTemplate.Conditions, EffectState, SourceUnitState, UnitState, AbilityState) == 'AA_Success';
//
	//if (bOldApplicable != bNewApplicable)
	//{
		//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Conditional Stat Change");
//
		//NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		//NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', EffectState.ObjectID));
//
		//if (bNewApplicable)
		//{
			//NewEffectState.StatChanges = EffectTemplate.m_aStatChanges;
//
			//// Note: ApplyEffectToStats crashes the game if the state objects aren't added to the game state yet
			//NewUnitState.ApplyEffectToStats(NewEffectState, NewGameState);
		//}
		//else
		//{
			//NewUnitState.UnApplyEffectFromStats(NewEffectState, NewGameState);
			//NewEffectState.StatChanges.Length = 0;
		//}
//
		//`GAMERULES.SubmitGameState(NewGameState);
	//}
//
	//return ELR_NoInterrupt;
//}
//
//simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
//{
	//super(X2Effect_Persistent).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
//}