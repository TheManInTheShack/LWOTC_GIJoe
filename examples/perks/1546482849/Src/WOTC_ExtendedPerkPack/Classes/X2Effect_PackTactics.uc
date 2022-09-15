class X2Effect_PackTactics extends X2Effect_Persistent;

var int Radius;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;
	local XComGameState_Player PlayerState;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'PlayerTurnEnded', ActivateOverwatch, ELD_OnStateSubmitted, 50, PlayerState,, EffectObj);
}

static function EventListenerReturn ActivateOverwatch(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Unit					SourceUnit, FollowupUnit;
	local XComGameState_Effect					EffectState;
	local X2Effect_PackTactics					Effect;
	local XComGameState_Effect SourceEffectState;
	local StateObjectReference SourceEffectRef;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Ability OverwatchState;
	local StateObjectReference OverwatchRef;
	
	EffectState = XComGameState_Effect(CallbackData);
	History = `XCOMHISTORY;
	
	//`LOG("=== Pack Tactics Logging Start");

	// Unit that has the Pack Tactics ability
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	//`LOG("=== SourceUnit: " @ SourceUnit.GetFullName());

	// Unit that may activate overwatch
	FollowupUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	//`LOG("=== FollowupUnit: " @ FollowupUnit.GetFullName());

	// Source shouldn't activate
	if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
	{
		//`LOG("=== Not activating because target is source");
		return ELR_NoInterrupt;
	}
	
	// Get the effect from the callback data
	Effect = X2Effect_PackTactics(EffectState.GetX2Effect());

	// Check the source unit to see if the Shield Wall effect is active
	foreach SourceUnit.AffectedByEffects(SourceEffectRef)
	{
		SourceEffectState = XComGameState_Effect(History.GetGameStateForObjectID(SourceEffectRef.ObjectID)); // maybe use GameState
		if (SourceEffectState.GetX2Effect().EffectName == 'ShieldWall')
		{
			//`LOG("=== Shield Wall active for source");
			// Shield Wall is active; now check if the SourceUnit and FollowupUnit are adjacent
			if (class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, FollowupUnit.TileLocation, Effect.Radius))
			{
				//`LOG("=== Ally in range");
				//`LOG("=== FollowupUnit.NumActionPoints(): " @ FollowupUnit.NumActionPoints());
				//`LOG("=== FollowupUnit.NumReserveActionPoints(): " @ FollowupUnit.NumReserveActionPoints());
				//`LOG("=== FollowupUnit.NumAllReserveActionPoints(): " @ FollowupUnit.NumAllReserveActionPoints());
				if (FollowupUnit.NumAllReserveActionPoints() == 0)
				{
					OverwatchRef = FollowupUnit.FindAbility('PistolOverwatch');
					if (OverwatchRef.ObjectID == 0)
						OverwatchRef = FollowupUnit.FindAbility('Overwatch');
					OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
					if (OverwatchState != none)
					{
						//`LOG("=== Overwatch ability found");
						//`LOG("=== Granting overwatch point to: " @ FollowupUnit.GetFullName());
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
						FollowupUnit = XComGameState_Unit(NewGameState.ModifyStateObject(FollowupUnit.Class, FollowupUnit.ObjectID));

						// Give the unit an action point so they can activate overwatch										
						FollowupUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
						`TACTICALRULES.SubmitGameState(NewGameState);
						OverwatchState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, InEventID, CallbackData);
					}
				}
			}
			break;
		}
	}
	
	//`LOG("=== Pack Tactics Logging End");

	return ELR_NoInterrupt;
}