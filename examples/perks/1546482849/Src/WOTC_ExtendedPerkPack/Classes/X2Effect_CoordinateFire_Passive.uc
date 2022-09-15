class X2Effect_CoordinateFire_Passive extends X2Effect_Persistent;

var int Radius;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'CoordinateFireFollowup', CoordinateFireFollowupShot, ELD_OnStateSubmitted, 50,,, EffectObj);
}

static function EventListenerReturn CoordinateFireFollowupShot(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local StateObjectReference					Target, Followup, FollowupAbility;
	local XComGameState_Unit					TargetUnit, SourceUnit, FollowupUnit;
	local XComGameState_Effect					EffectState;
	local XComGameStateContext_Ability			AbilityContext;
	local X2Effect_CoordinateFire_Passive		Effect;
	
	// Unit that is the source of the event (the one that used Coordinate Fire)
	SourceUnit = XComGameState_Unit(EventSource);
	//`LOG("=== SourceUnit: " @ SourceUnit.GetFullName());
	
	// Get the target for the original Coordinate Fire shot
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	Target = AbilityContext.InputContext.PrimaryTarget;
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Target.ObjectID));
	//`LOG("=== TargetUnit: " @ TargetUnit.GetFullName());

	// Unit that may fire the follow-up shot
	EffectState = XComGameState_Effect(CallbackData);
	Followup = EffectState.ApplyEffectParameters.TargetStateObjectRef;
	FollowupUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	//`LOG("=== FollowupUnit: " @ FollowupUnit.GetFullName());
	
	// Get the effect from the callback data
	Effect = X2Effect_CoordinateFire_Passive(EffectState.GetX2Effect());

	// Check if the SourceUnit and FollowupUnit are adjacent
	if (class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, FollowupUnit.TileLocation, Effect.Radius))
	{
		FollowupAbility = FollowupUnit.FindAbility('F_CoordinateFire_Followup');
		//`LOG("=== FollowupAbility.ObjectID: " @ FollowupAbility.ObjectID);
		class'XComGameState_Ability'.static.AbilityTriggerAgainstSingleTarget_Static(FollowupAbility.ObjectID, Followup, Target, false);
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="F_CoordinateFire_Effect";
}