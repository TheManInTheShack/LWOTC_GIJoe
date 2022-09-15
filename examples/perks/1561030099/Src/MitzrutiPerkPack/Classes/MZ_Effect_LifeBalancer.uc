class MZ_Effect_LifeBalancer extends X2Effect;

var localized string HPGainLabel, HPLossLabel;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability Ability;
	local XComGameState_Unit	TargetUnit, SourceUnit;
	local XComGameStateHistory	History;
	local int					SourceObjectID, HPPool;

	History = `XCOMHISTORY;
	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (Ability == none)
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);

	SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
	
	if (Ability != none && TargetUnit != none && SourceUnit != none)
	{
		SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceObjectID));

		HPPool = TargetUnit.GetCurrentStat(eStat_HP) + SourceUnit.GetCurrentStat(eStat_HP);

		//first two cases here are to handle when the effect might overfill one of the units HP, due to large difference in max HP.
		if ( HPPool/2 > TargetUnit.GetMaxStat(eStat_HP) )
		{
			TargetUnit.SetCurrentStat(eStat_HP, TargetUnit.GetMaxStat(eStat_HP));
			SourceUnit.SetCurrentStat(eStat_HP, HPPool - TargetUnit.GetMaxStat(eStat_HP));
		}
		else if (HPPool/2 > SourceUnit.GetMaxStat(eStat_HP) )
		{
			SourceUnit.SetCurrentStat(eStat_HP, SourceUnit.GetMaxStat(eStat_HP));
			TargetUnit.SetCurrentStat(eStat_HP, HPPool - SourceUnit.GetMaxStat(eStat_HP));
		}
		else
		{	
			TargetUnit.SetCurrentStat(eStat_HP, HPPool/2 );

			//in the case of and odd number in the HPPool, give the extra point to the caster.
			if ( HPPool % 2 != 0)
			{
				SourceUnit.SetCurrentStat(eStat_HP, HPPool/2 + 1 );
			}
			else
			{
				SourceUnit.SetCurrentStat(eStat_HP, HPPool/2 );
			}
		}

		//make sure lowestHP is modified correctly if nessecary.
		if ( SourceUnit.LowestHP < SourceUnit.GetCurrentStat(eStat_HP) )
		{
			SourceUnit.LowestHP = SourceUnit.GetCurrentStat(eStat_HP);
		}

		if ( TargetUnit.LowestHP < TargetUnit.GetCurrentStat(eStat_HP) )
		{
			TargetUnit.LowestHP = TargetUnit.GetCurrentStat(eStat_HP);
		}
	}
}

//show a flyover on target
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
		if (Healed > 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(default.HPGainLabel, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
		else if (Healed < 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(default.HPLossLabel, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Bad);
		}	
	}
}

//show a flyover on source
simulated function AddX2ActionsForVisualizationSource(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
		if (Healed > 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(default.HPGainLabel, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
		else if (Healed < 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(default.HPLossLabel, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Bad);
		}	
	}
}