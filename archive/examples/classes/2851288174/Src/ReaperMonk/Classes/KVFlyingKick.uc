class KVFlyingKick extends X2Effect_Persistent config(MonkAbility);

var config array<name> AbilityWhitelist;

//function RegisterForEvents(XComGameState_Effect EffectGameState)
//{
	//local X2EventManager EventMgr;
	//local XComGameState_Unit UnitState;
	//local Object EffectObj;
//
	//EventMgr = `XEVENTMGR;
//
	//EffectObj = EffectGameState;
	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
//
	//EventMgr.RegisterForEvent(EffectObj, 'KVFlyingKickEffect', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
//}


function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	//local X2AbilityTemplate         Template;
	//local XComGameState_Player		PlayerState;
	//local XComGameState_Ability		AbilityState;
	local X2EventManager			EventMgr;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	//local int						i;
	//local StateObjectReference		EffectRef;
	//local XComGameState_Unit		UnitState;
	//local UnitValue					MoveValue;
	//local bool						bEnemyTurn;
	//local UnitValue					UV;
	//local XComGameStateHistory		History;
//

	if (kAbility.GetMyTemplate().IsMelee() && kAbility.IsAbilityInputTriggered() || default.AbilityWhitelist.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
	{	
				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('KVFlyingKickEffect', SourceUnit, SourceUnit, NewGameState);
	}
return false;
}

    //EventListener = new class'X2AbilityTrigger_EventListener';
    //EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    //EventListener.ListenerData.EventID = 'UnitDied';
    //EventListener.ListenerData.Filter = eFilter_Unit;
    //EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    //Template.AbilityTriggers.AddItem(EventListener);
//
//
    //Trigger = new class'X2AbilityTrigger_EventListener';
    //Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    //Trigger.ListenerData.EventID = 'SoulReaperContinue';
    //Trigger.ListenerData.Filter = eFilter_Unit;
    //Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.SoulReaperListener;
    //Template.AbilityTriggers.AddItem(Trigger);