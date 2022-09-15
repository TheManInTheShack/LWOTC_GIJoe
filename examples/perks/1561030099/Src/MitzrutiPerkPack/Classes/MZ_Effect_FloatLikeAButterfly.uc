class MZ_Effect_FloatLikeAButterfly extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', MZ_Helper_EffectGS(EffectGameState).ButterflyCheck, ELD_OnStateSubmitted);
}


defaultproperties
{
	GameStateEffectClass = class'MZ_Helper_EffectGS'
	EffectName = "MZFloatLikeAButterfly"
}