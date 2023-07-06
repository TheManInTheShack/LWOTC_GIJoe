class X2Effect_FlurryAction extends X2Effect_ModifyStats config(MonkAbility);;

//var int FlurryMobilityBonus;
//
//
//
//simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
//{
	//local XComGameStateHistory  History;
	//local XComGameState_Unit	UnitState;
	//local StatChange			NewStatChange;
//
	//
	////History = `XCOMHISTORY;
	////UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnit));
	//UnitState = XComGameState_Unit(kNewTargetState);
	//NewStatChange.StatType = eStat_Mobility;
	//NewStatChange.StatAmount =  FlurryMobilityBonus;
	//NewEffectState.StatChanges.AddItem(NewStatChange);
	//
//
	//super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
//}

//simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
//{
	//super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
//}

//simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
//{
	//local XComGameState_Unit UnitState;
//
	//super.AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, EffectApplyResult);
//
	//if( EffectApplyResult != 'AA_Success' )
	//{
		//return;
	//}
//
	//UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	//if (UnitState == none)
		//return;
//
	//if (UnitState != none)
	//{
		//class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), EffectFriendlyName, '', eColor_Good, "img:///UILibrary_PerkIcons.UIPerk_aethershift");
		//class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(BuildTrack, VisualizeGameState.GetContext(), 1.4f);
	//}
//
	//class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
//}

//simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
//{
	//local XComGameState_Unit UnitState;
//
	//super.AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);
//
	//UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	//if (UnitState == none)
		//return;
//
	//// dead units should not be reported. Also, rescued civilians should not display the fly-over.
	//if( !UnitState.IsAlive() || UnitState.bRemovedFromPlay )
	//{
		//return;
	//}
//
	//class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(BuildTrack, VisualizeGameState.GetContext(), 2.0f);
	//class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(BuildTrack, VisualizeGameState.GetContext(), EffectLostFriendlyName, '', eColor_Bad, "img:///UILibrary_PerkIcons.UIPerk_aethershift", 2.0f);
//
	//class'X2StatusEffects'.static.UpdateUnitFlag(BuildTrack, VisualizeGameState.GetContext());
//}
//
//simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
//{
	////We assume 'AA_Success', because otherwise the effect wouldn't be here (on load) to get sync'd
	//AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
//}

//defaultproperties
//{
	//FlurryMobilityBonus=1
	//DuplicateResponse=eDupe_Ignore
//}
//