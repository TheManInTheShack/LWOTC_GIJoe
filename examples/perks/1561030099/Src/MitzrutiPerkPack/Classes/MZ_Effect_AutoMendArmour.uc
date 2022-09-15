class MZ_Effect_AutoMendArmour extends X2Effect_Persistent;

var int DeShredPerTurn;
var int MaxDeShred;
var name DeShrededName;
var name EventToTriggerOnDeShred;

var localized string DeShredMessage;

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue HealthRegenerated;
	local int AmountToHeal, Healed;
	
	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if ( OldTargetState.Shredded < 1 ) {return false;}

	if ( DeShrededName != '' && MaxDeShred > 0)
	{
		OldTargetState.GetUnitValue(DeShrededName, HealthRegenerated);
		// If the unit has already been healed the maximum number of times, do not regen
		if (HealthRegenerated.fValue >= MaxDeShred)
		{
			return false;
		}
		else
		{
			// Ensure the unit is not healed for more than the maximum allowed amount
			AmountToHeal = min(DeShredPerTurn, (MaxDeShred - HealthRegenerated.fValue));
		}
	}
	else
	{
		AmountToHeal = DeShredPerTurn;
	}

	// Perform the heal
	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	
	NewTargetState.Shredded -= min(AmountToHeal, NewTargetState.Shredded);

	if (EventToTriggerOnDeShred != '')
	{
		`XEVENTMGR.TriggerEvent(EventToTriggerOnDeShred, NewTargetState, NewTargetState, NewGameState);
	}

	// If this health regen is being tracked, save how much the unit was healed
	if (DeShrededName != '')
	{
		Healed = OldTargetState.Shredded - NewTargetState.Shredded;
		if (Healed > 0)
		{
			NewTargetState.SetUnitFloatValue(DeShrededName, HealthRegenerated.fValue + Healed, eCleanup_BeginTactical);
		}
	}

	return false;
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	Healed = OldUnit.Shredded - NewUnit.Shredded;
	
	if( Healed > 0 )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		Msg = Repl(default.DeShredMessage, "<Heal/>", Healed);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="MZUnwavering"
	EffectTickedFn=RegenerationTicked
	DeShrededName="MZUnwaveringDeShreded"
	MaxDeShred=-1
}