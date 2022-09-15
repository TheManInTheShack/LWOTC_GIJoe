class Isms_Effect_LastWish extends X2Effect_Persistent config(GameData_SoldierSkills);

var privatewrite name SustainUsed;
var privatewrite name SustainEvent, SustainTriggeredEvent;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local X2EventManager EventMan;
	local UnitValue SustainValue;

	if( !UnitState.IsAbleToAct(true) )
	{
		// Stunned units may not go into Sustain
		return false;
	}

	if (UnitState.GetUnitValue(default.SustainUsed, SustainValue))
	{
		if (SustainValue.fValue > 0)
			return false;
	}

	UnitState.SetUnitFloatValue(default.SustainUsed, 1, eCleanup_BeginTactical);
	UnitState.SetCurrentStat(eStat_HP, Min(5, UnitState.GetMaxStat(eStat_HP)));
	EventMan = `XEVENTMGR;
	EventMan.TriggerEvent(default.SustainEvent, UnitState, UnitState, NewGameState);
	return true;
}

function bool PreBleedoutCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return PreDeathCheck(NewGameState, UnitState, EffectState);
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMan;
	local Object EffectObj;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, default.SustainTriggeredEvent, class'XComGameState_Effect'.static.SustainActivated, ELD_OnStateSubmitted, , UnitState);
}

DefaultProperties
{
	SustainUsed = "SustainUsed"
	SustainEvent = "SustainTriggered"
	SustainTriggeredEvent = "SustainSuccess"
}