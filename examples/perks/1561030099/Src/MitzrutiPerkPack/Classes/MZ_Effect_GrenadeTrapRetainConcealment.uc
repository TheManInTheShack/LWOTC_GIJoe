class MZ_Effect_GrenadeTrapRetainConcealment extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'RetainConcealmentOnActivation', GrenadeTrapConcealmentCheck);
}

static function EventListenerReturn GrenadeTrapConcealmentCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	ActivationContext;
	local XComLWTuple Tuple;
	local XComGameState_Ability AbilityState;

	Tuple = XComLWTuple(EventData);
	ActivationContext = XComGameStateContext_Ability(EventSource);
	AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(ActivationContext.InputContext.AbilityRef.ObjectID));
	
	//only need to run checks if it's not already true
	if ( !Tuple.Data[0].b && AbilityState != none)
	{
		if ( AbilityState.GetMyTemplateName() == 'MZGrenadeTrapDetonate' )
		{
			Tuple.Data[0].b = true;
		}
	}

	return ELR_NoInterrupt;
}