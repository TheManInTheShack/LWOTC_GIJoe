class MZ_Effect_StealthPistol extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj, FilterObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	FilterObj = `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);

	EventMgr.RegisterForEvent(EffectObj, 'RetainConcealmentOnActivation', MZ_Helper_EffectGS(EffectGameState).StealthPistolConcealmentCheck, , , FilterObj);
}



defaultproperties
{
	GameStateEffectClass = class'MZ_Helper_EffectGS'
	EffectName = "MZStealthPistol"
}