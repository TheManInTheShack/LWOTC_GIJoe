class X2Effect_Shadowmelt extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'KillMail', ShadowmeltListener, ELD_OnStateSubmitted, , UnitState);
}

static function EventListenerReturn ShadowmeltListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit Killer;

	Killer = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (Killer != None && AbilityContext != none && AbilityContext.InputContext.AbilityTemplateName == 'Shadowmelt' && !Killer.IsConcealed())
	{
		Killer.EnterConcealment();      //  this creates a new game state and submits it
	}

	return ELR_NoInterrupt;
}

