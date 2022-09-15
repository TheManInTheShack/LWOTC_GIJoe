class MZ_Effect_ModifyGrenadeRange extends X2Effect_Persistent;

var bool bThrowGrenade, bLaunchGrenade, bGrenadeTrap;
var float RangeChangeMult;
var int RangeChangeFlat;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	//local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'OnGetItemRange', MZ_Helper_EffectGS(EffectGameState).ModifyGrenadeRange, ELD_Immediate);
}

defaultproperties
{
	GameStateEffectClass = class'MZ_Helper_EffectGS'
	RangeChangeMult = 1.0f
}