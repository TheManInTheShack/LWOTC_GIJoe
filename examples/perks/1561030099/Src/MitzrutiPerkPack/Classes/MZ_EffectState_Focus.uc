class MZ_EffectState_Focus extends XComGameState_Effect config(MZPerkFocus);

var int FocusRecovery;
var int FocusLevel, MaxFocusLevel;

var config array<name> HunkerAbilityNames;

function EventListenerReturn OnOverrideUnitFocusUI(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    //local XComGameState_Unit SourceUnit;
    local XComLWTuple Tuple;
	local MZ_Effect_Focus	Effect;

    //SourceUnit = XComGameState_Unit(EventSource);
    Tuple = XComLWTuple(EventData);
	Effect = MZ_Effect_Focus(GetX2Effect());

    Tuple.Data[0].b = true;

	Tuple.Data[1].i = FocusLevel;

	//prolly better to just handle the mucking about when it's created or some wierd effect changes it, rather than do it here.
	Tuple.Data[2].i = MaxFocusLevel;

    Tuple.Data[3].s = Effect.sFocusColour;
    Tuple.Data[4].s = Effect.sFocusIconPath;
    Tuple.Data[5].s = Effect.sFocusTooltip;
    Tuple.Data[6].s = Effect.sFocusLabel;

    return ELR_NoInterrupt;
}

function bool SetFocusLevel(int SetFocus, XComGameState_Unit TargetUnit, XComGameState NewGameState, optional bool SkipVisualization)
{
	local MZ_Effect_Focus FocusEffect;
	local MZ_EffectState_Focus SelfObject;
	local int NewFocus;

	FocusEffect = MZ_Effect_Focus(GetX2Effect());
	`assert(FocusEffect != none);

	if (SetFocus > MaxFocusLevel)
		NewFocus = MaxFocusLevel;
	else
		NewFocus = SetFocus;

	if (NewFocus < 0)
		NewFocus = 0;

	if (NewFocus == FocusLevel)
		return false;
	
	if (StatChanges.Length > 0)
	{
		SelfObject = self;
		TargetUnit.UnApplyEffectFromStats(SelfObject, NewGameState);
		StatChanges.Length = 0;
	}	

	FocusLevel = NewFocus;

	StatChanges = FocusEffect.GetFocusModifiersForLevel(NewFocus).StatChanges;
	if (StatChanges.Length > 0)
	{
		SelfObject = self;
		TargetUnit.ApplyEffectToStats(SelfObject, NewGameState);
	}

	/* seems to suggest the viz is unnessecary. although would be nice to play a flyover for change amount.
	if (!SkipVisualization)
		NewGameState.GetContext().PostBuildVisualizationFn.AddItem(FocusChangeVisualization);
	*/

	`XEVENTMGR.TriggerEvent('FocusLevelChanged', self, TargetUnit, NewGameState);

	if( TargetUnit.GhostSourceUnit.ObjectID > 0 && FocusLevel == 0 )
	{
		`XEVENTMGR.TriggerEvent('GhostKill', self, TargetUnit);
	}

	return true;
}

simulated function FocusChangeVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata Metadata;
	local MZ_EffectState_Focus OldFocus;
	local MZ_EffectState_Focus NewFocus;
	local MZ_EffectState_Focus EndFocus;
	local MZ_EffectState_Focus IterateFocus;
	local StateObjectReference UnitRef;
	local int FocusObjectID;

	History = `XCOMHISTORY;

	foreach VisualizeGameState.IterateByClassType(class'MZ_EffectState_Focus', IterateFocus)
	{
		UnitRef = IterateFocus.ApplyEffectParameters.TargetStateObjectRef;
		Metadata.StateObject_OldState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		Metadata.StateObject_NewState = History.GetGameStateForObjectID(UnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		Metadata.VisualizeActor = History.GetVisualizer(UnitRef.ObjectID);

		FocusObjectID = XComGameState_Unit(Metadata.StateObject_OldState).GetUnitAffectedByEffectState('FocusLevel').ObjectID;
		OldFocus = MZ_EffectState_Focus(History.GetGameStateForObjectID(FocusObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
		NewFocus = MZ_EffectState_Focus(History.GetGameStateForObjectID(FocusObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
		EndFocus = MZ_EffectState_Focus(History.GetGameStateForObjectID(FocusObjectID));

		if( OldFocus != None && NewFocus != None && EndFocus != None )
		{
			FocusChangeVisualizationHelper(VisualizeGameState, Metadata, NewFocus.FocusLevel, OldFocus.FocusLevel, EndFocus.FocusLevel, FocusObjectID);
		}
	}
}
simulated function FocusChangeVisualizationHelper(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, int NewFocusLevel, int OldFocusLevel, int EndFocusLevel, int FocusObjectID)
{
	local X2Action_PlaySoundAndFlyOver FlyOverAction;
	local string ModifyDisplay, NumberDisplay;
	local X2Action_CameraLookAt LookAtCamera;
	//local X2Action_PlayAnimation PlayAnim;
	local Array<X2Action> ParentActions;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_MarkerTreeInsertEnd EndNode;
	local X2Action_MarkerNamed MarkerNamed;
	local int ModifyValue;
	//local bool PlayAnimation;

	VisMgr = `XCOMVISUALIZATIONMGR;

	ModifyValue = NewFocusLevel - OldFocusLevel;

	if( XComGameState_Unit(ActionMetadata.StateObject_NewState) != None && ModifyValue != 0 )
	{
		// Jwats: Play the anim and the flyover at the same time.
		if( ModifyValue > 0 )
		{
			EndNode = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MarkerTreeInsertEnd'));
			if( EndNode != None )
			{
				ParentActions = EndNode.ParentActions;
			}
			else
			{
				VisMgr.GetAllLeafNodes(VisMgr.BuildVisTree, ParentActions);
			}

			LookAtCamera = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), true, , ParentActions));
			LookAtCamera.LookAtActor = ActionMetadata.VisualizeActor;
			ParentActions.Length = 0;
		}

		//class'X2Ability_TemplarAbilitySet'.static.PlayFocusFX(VisualizeGameState, ActionMetadata, "ADD_StopFocus", OldFocusLevel);
		//class'X2Ability_TemplarAbilitySet'.static.PlayFocusFX(VisualizeGameState, ActionMetadata, "ADD_StartFocus", NewFocusLevel);
		//class'X2Ability_TemplarAbilitySet'.static.UpdateFocusUI(VisualizeGameState, ActionMetadata);

		if ( ModifyValue > 0 )
		{
			// Jwats: Only the final focus result should play an animation
			/* I don't want an anim to play. just slows the game down, esp if you had a full squad with Necro or Water Focus.
			PlayAnimation = NewFocusLevel == EndFocusLevel;

			if( PlayAnimation )
			{
				PlayAnim = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, LookAtCamera));
				PlayAnim.Params.AnimName = 'HL_GainingFocus';
				ParentActions.AddItem(PlayAnim);
			}
			*/

			if( ModifyValue > 0 )
				NumberDisplay = "+" $ ModifyValue;
			else
				NumberDisplay = string(ModifyValue);

			ModifyDisplay = Repl(class'X2Effect_ModifyTemplarFocus'.default.FlyoverText, "<FocusAmount/>", NumberDisplay);
			FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, LookAtCamera));
			FlyOverAction.SetSoundAndFlyOverParameters(None, ModifyDisplay, '', ModifyValue > 0 ? eColor_Good : eColor_Bad, , 0.5f, true);
			ParentActions.AddItem(FlyOverAction);

			MarkerNamed = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, , ParentActions));
			MarkerNamed.SetName("Join");
		}

		if( EndNode != None )
		{
			VisMgr.DisconnectAction(EndNode);
			VisMgr.ConnectAction(EndNode, VisMgr.BuildVisTree, false, ActionMetadata.LastActionAdded);
		}
	}
}

function ManaLevelModifiers GetCurrentFocusModifiers()
{
	return GetFocusModifiersForLevel(FocusLevel);
}

function ManaLevelModifiers GetFocusModifiersForLevel(int Level)
{
	return MZ_Effect_Focus(GetX2Effect()).GetFocusModifiersForLevel(Level);
}

//For use only by the listeners below it. restore focus when appropriate mechanic triggers.
private function RecoverFocus(XComGameState_Unit SourceUnit, optional int StaticAmount)
{
	local XComGameState				NewGameState;
	local MZ_EffectState_Focus		NewSelfState;
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	//XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = ButterflyVisualizationFn;
	NewSelfState = MZ_EffectState_Focus(NewGameState.ModifyStateObject(Self.Class, Self.ObjectID));
	If ( StaticAmount != 0 )
	{
		NewSelfState.SetFocusLevel(FocusLevel+StaticAmount, SourceUnit, NewGameState);
	}
	else
	{
		NewSelfState.SetFocusLevel(FocusLevel+FocusRecovery, SourceUnit, NewGameState);
	}
	SubmitNewGameState(NewGameState);
}

function EventListenerReturn RewardFocusOnPsiSkillCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local X2AbilityTemplate				AbilityTemplate;
	local bool							Boost;
	local X2AbilityCost_Focus			FocusCost;
	local int							i;
	local XComGameState_Unit			SourceUnit;

	if (!bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				//need to check the ability in question doesn't have a focus cost.
				AbilityTemplate = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();

				if (AbilityTemplate != none && AbilityTemplate.AbilitySourceName == 'eAbilitySource_Psionic')
				{
					for (i = 0; i < AbilityTemplate.AbilityCosts.Length; ++i)
					{
						FocusCost = X2AbilityCost_Focus( AbilityTemplate.AbilityCosts[i] );
						if( FocusCost != none && !FocusCost.bFreeCost ) { 
							if ( !(FocusCost.GhostOnlyCost == true && SourceUnit.GhostSourceUnit.ObjectID > 0) )
							{
								Boost = true;
								break;
							}
						}
					}

					if (!Boost)
					{
						if ( AbilityTemplate.AbilityCooldown.iNumTurns > 2 )
						{
							SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
							RecoverFocus(SourceUnit, Round(AbilityTemplate.AbilityCooldown.iNumTurns/2)+1);
						}
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn RewardFocusOnKillCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit		SourceUnit, DeadUnit;
	local XComGameStateHistory		History;
	local X2AbilityTemplate			AbilityTemplate;
	local X2AbilityCost_Focus		FocusCost;
	local bool						Boost;
	local int						i;

	if (!bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				History = `XCOMHISTORY;
				SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				DeadUnit = XComGameState_Unit(EventData);
				//Weapon = X2WeaponTemplate(XComGameState_Ability(History.GetGameStateForObjectId(AbilityContext.InputContext.AbilityRef.ObjectID)).GetSourceWeapon().GetMyTemplate());

				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
				{
					if (SourceUnit.IsEnemyUnit(DeadUnit))
					{
						//need to check the ability in question doesn't have a focus cost.
						AbilityTemplate = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();

						if (AbilityTemplate != none)
						{
							for (i = 0; i < AbilityTemplate.AbilityCosts.Length; ++i)
							{
								FocusCost = X2AbilityCost_Focus( AbilityTemplate.AbilityCosts[i] );
								if( FocusCost != none && !FocusCost.bFreeCost ) {
									if ( !(FocusCost.GhostOnlyCost == true && SourceUnit.GhostSourceUnit.ObjectID > 0) )
									{
										Boost = true;
										break;
									}
								}
							}

							if (!Boost)
							{
								If ( DeadUnit.AffectedByEffectNames.Find('X2Effect_TheLostHeadshot') == INDEX_NONE )
								{
									RecoverFocus(SourceUnit);
								}
								else
								{
									RecoverFocus(SourceUnit, Round(FocusRecovery/2));
								}
							}
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn RewardOneFocusOnAssistCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit		SourceUnit, DeadUnit;
	local XComGameStateHistory		History;
	local X2AbilityTemplate			AbilityTemplate;

	if (!bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID != ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				History = `XCOMHISTORY;
				SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				DeadUnit = XComGameState_Unit(EventData);
					//Weapon = X2WeaponTemplate(XComGameState_Ability(History.GetGameStateForObjectId(AbilityContext.InputContext.AbilityRef.ObjectID)).GetSourceWeapon().GetMyTemplate());

				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
				{
					if (SourceUnit.IsEnemyUnit(DeadUnit))
					{
						//need to check the ability in question doesn't have a focus cost.
						AbilityTemplate = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();
						if (AbilityTemplate != none)
						{
							RecoverFocus(SourceUnit, 1);
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn RewardFocusOnEventCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if ( SourceUnit.IsAbleToAct() )
	{
		RecoverFocus(SourceUnit);
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn RewardFocusWaterEventCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if ( SourceUnit.IsAbleToAct() )
	{
		If ( FocusLevel < MaxFocusLevel*0.34 )
		{
			RecoverFocus(SourceUnit);
		}
		else if ( FocusLevel < MaxFocusLevel*0.67 )
		{
			RecoverFocus(SourceUnit, Max(1, FocusRecovery*0.67));
		}
		else
		{
			RecoverFocus(SourceUnit, Max(1, FocusRecovery*0.34));
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn RewardFocusWhileConcealedCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if ( SourceUnit.IsAbleToAct() && ( SourceUnit.IsConcealed() || SourceUnit.IsSuperConcealed() ) )
	{
		RecoverFocus(SourceUnit);
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn RewardFocusOnHunkerCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if ( HunkerAbilityNames.Find(AbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE )
		{
			SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

			if ( SourceUnit.IsAbleToAct() )
			{
				RecoverFocus(SourceUnit);
			}
		}
	}	

	return ELR_NoInterrupt;
}

// gain focus when dashing, unless the ability also costs focus. additional +1 for standard moves.
function EventListenerReturn RewardFocusOnDashCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit		SourceUnit;
	local X2AbilityTemplate			AbilityTemplate;
	local X2AbilityCost_Focus		FocusCost;
	local bool						Boost, bIsDash;
	local int						i, PathIndex, FarthestTile;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	//Unit moved over some amount of tiles on it's controlling player's turn.
	//note that teleporting/etc does not count.
	if( AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length > 0 && `TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID && SourceUnit.IsAbleToAct())
	{

		//If this move was uninterrupted, or we do not have a resume
		if( AbilityContext.InterruptionStatus == eInterruptionStatus_None || AbilityContext.ResumeHistoryIndex < 0 )
		{

			PathIndex = AbilityContext.GetMovePathIndex(SourceUnit.ObjectID);
			
			for(i = AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1; i >= 0; --i)
			{
				if(AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles[i] == SourceUnit.TileLocation)
				{
					FarthestTile = i;
					break;
				}
			}

			for (i = 0; i < AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases.Length; ++i)
			{
				if (AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases[i] <= FarthestTile)
				{
					bIsDash = true;
					break;
				}
			}

			if ( bIsDash)
			{
				if ( AbilityContext.InputContext.AbilityTemplateName == 'StandardMove' )
				{
					//standard move gets +1 since it doesn't do anything other than move.
					RecoverFocus(SourceUnit, 1 + FocusRecovery);
					return ELR_NoInterrupt;
				}
				else
				{
					//need to check the ability in question doesn't have a focus cost. (ex. Sabers or othe melee focus consumer)
					AbilityTemplate = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();
					if (AbilityTemplate != none)
					{
						//apply recovery if the ability doesn't cost focus.
						for (i = 0; i < AbilityTemplate.AbilityCosts.Length; ++i)
						{
							FocusCost = X2AbilityCost_Focus( AbilityTemplate.AbilityCosts[i] );
							if( FocusCost != none && !FocusCost.bFreeCost ) 
							{ 
								if ( !(FocusCost.GhostOnlyCost == true && SourceUnit.GhostSourceUnit.ObjectID > 0) )
								{
									Boost = true;
									break;
								}
							}
						}

						if (!Boost)
						{
							RecoverFocus(SourceUnit);
							return ELR_NoInterrupt;
						}
					}
				}		
			}
		}
	}

	return ELR_NoInterrupt;
}

//completely unfinished.
function EventListenerReturn RewardFocusWhenAttackedCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Unit			SourceUnit, Attacker;
	local XComGameStateHistory			History;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		History = `XCOMHISTORY;
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		Attacker = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(GameState);

		if (Attacker != none && Attacker.IsEnemyUnit(SourceUnit))
		{
			if (AbilityContext.InputContext.PrimaryTarget.ObjectID == SourceUnit.ObjectID)
			{
				switch ( AbilityContext.ResultContext.HitResult )
				{
					//should reward more focus if the attack's gonna hurt.
					case eHit_Crit:
						RecoverFocus(SourceUnit, 2.5*FocusRecovery);
					case eHit_Success:
						RecoverFocus(SourceUnit, 2*FocusRecovery);
					case eHit_Graze:
						RecoverFocus(SourceUnit, 1.5*FocusRecovery);
					default:
						RecoverFocus(SourceUnit);
				}
			}
			else
			{
				//should it apply if not the primary target? hrmm.
			}
		}
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	bTacticalTransient=true
}