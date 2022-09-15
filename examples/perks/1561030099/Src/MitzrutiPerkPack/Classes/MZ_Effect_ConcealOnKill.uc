class MZ_Effect_ConcealOnKill extends X2Effect_Persistent;
// Modified version of Shadowfall

var name AbilityName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'KillMail', MZ_Helper_EffectGS(EffectGameState).ConcealOnKillListener, ELD_OnStateSubmitted, 10, UnitState);
}

/*
static function EventListenerReturn ConcealOnKillListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit Killer;

	//  if the kill was made with Shadowfall and the killer is revealed, then conceal them
	Killer = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (Killer != None && AbilityContext != none && AbilityContext.InputContext.AbilityTemplateName == 'MZHungeringShot' && !Killer.IsConcealed())
	{
		Killer.EnterConcealment();      //  this creates a new game state and submits it
	}

	return ELR_NoInterrupt;
}
*/

defaultproperties
{
	GameStateEffectClass = class'MZ_Helper_EffectGS'
}