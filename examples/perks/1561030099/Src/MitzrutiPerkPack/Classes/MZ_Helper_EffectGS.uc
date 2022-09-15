class MZ_Helper_EffectGS extends XComGameState_Effect;

function EventListenerReturn ButterflyCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, DeadUnit;
	local XComGameStateHistory History;
	local X2WeaponTemplate	Weapon;

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
				Weapon = X2WeaponTemplate(XComGameState_Ability(History.GetGameStateForObjectId(AbilityContext.InputContext.AbilityRef.ObjectID)).GetSourceWeapon().GetMyTemplate());

				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
				{
					if (SourceUnit.IsEnemyUnit(DeadUnit))
					{
						if (Weapon != None && ( Weapon.WeaponCat == 'combatknife' || Weapon.WeaponCat == 'wristblade') )
						{
							NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
							XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = ButterflyVisualizationFn;
							SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
							SourceUnit.ActionPoints.AddItem('momentum');
							SubmitNewGameState(NewGameState);
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

function ButterflyVisualizationFn(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('MZFloatLikeAButterfly');
		if (AbilityTemplate != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage);

		}
		break;
	}
}

////// Diving Slash cooldown reset
function EventListenerReturn DivingSlashResetCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState					NewGameState;
	local XComGameState_Unit			SourceUnit, DeadUnit;
	local XComGameStateHistory			History;
	local StateObjectReference			AbilityRef;
	local XComGameState_Ability			AbilityState;

	if (!bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none && AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			History = `XCOMHISTORY;
			SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			DeadUnit = XComGameState_Unit(EventData);
			
			if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID && SourceUnit.IsEnemyUnit(DeadUnit))
			{
				AbilityRef = SourceUnit.FindAbility('MZDivingSlash');
				if(AbilityRef.ObjectID != 0)
				{
					if ( XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID)).iCooldown > 0 )
					{
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
						XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = DivingSlashResetVisualizationFn;

						AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(AbilityRef.ObjectID));
						if(AbilityState == none)
						{
							// This AbilityState needs to be added to the NewGameState
							AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));	
						}
						// eliminate the cooldown.
						AbilityState.iCooldown = 0;

						SubmitNewGameState(NewGameState);
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
function DivingSlashResetVisualizationFn(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('MZDivingSlashReset');
		if (AbilityTemplate != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage);

		}
		break;
	}
}

function EventListenerReturn StealthPistolConcealmentCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	ActivationContext;
	local XComLWTuple Tuple;
	local X2WeaponTemplate Weapon;
	local XComGameState_Unit Target;
	local XComGameState_Ability AbilityState;
	local StateObjectReference	Multitarget;

	Tuple = XComLWTuple(EventData);
	ActivationContext = XComGameStateContext_Ability(EventSource);
	AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(ActivationContext.InputContext.AbilityRef.ObjectID));
	Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
	
	//only need to run checks if it's not already true
	if ( Weapon != none && !Tuple.Data[0].b)
	{
		if ( Weapon.WeaponCat == 'pistol' || Weapon.WeaponCat == 'sidearm' )
		{
			Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ActivationContext.InputContext.PrimaryTarget.ObjectID));
			If ( Target == none || Target.IsDead() )
			{
				Foreach ActivationContext.InputContext.MultiTargets(MultiTarget)
				{
					Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(MultiTarget.ObjectID));
					If ( Target != none && !Target.IsDead() )
					{
						return ELR_NoInterrupt;
					}
				}

				Tuple.Data[0].b = true;
			}
			
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn ConcealOnKillListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit Killer;
	local MZ_Effect_ConcealOnKill Effect;

	//  if the kill was made with Shadowfall and the killer is revealed, then conceal them
	Killer = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	Effect = MZ_Effect_ConcealOnKill(GetX2Effect());
	if (Effect != none && Killer != None && AbilityContext != none && AbilityContext.InputContext.AbilityTemplateName == Effect.AbilityName && !Killer.IsConcealed())
	{
		Killer.EnterConcealment();      //  this creates a new game state and submits it
	}

	return ELR_NoInterrupt;
}

///for a scraped ability, but maybe i could reuse it later.
function EventListenerReturn RollingCutterKillCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, DeadUnit;
	local XComGameStateHistory History;
	local UnitValue	RollingKills;

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

				if (SourceUnit.IsEnemyUnit(DeadUnit) && AbilityContext.InputContext.AbilityTemplateName == 'MZRollingCutter')
				{
					if ( AbilityContext.InputContext.AbilityTemplateName == 'MZRollingCutter' || AbilityContext.InputContext.AbilityTemplateName == 'MZRollingCutterX' || AbilityContext.InputContext.AbilityTemplateName == 'MZCrossImpact' || AbilityContext.InputContext.AbilityTemplateName == 'MZCrossRipperSlasher') 
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
					if ( SourceUnit.GetUnitValue('MZRollingCutterKills', RollingKills) )
					{
						SourceUnit.SetUnitFloatValue('MZRollingCutterKills', RollingKills.fValue + 1, eCleanup_BeginTurn);
					}
					else
					{
						SourceUnit.SetUnitFloatValue('MZRollingCutterKills', 1, eCleanup_BeginTurn);
					}
					SubmitNewGameState(NewGameState);
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

///////////// Grenade Trap //////////////
function EventListenerReturn GrenadeTrap_AbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Ability			AbilityState;
	local XComGameState_Unit			AbilityUnit, SourceUnit, SourceUnitAtTimeOfLaunch;
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  AbilityContext;
	local TTile                         CheckTile, AffectedTile;
	local bool                          bLocationMatch;
	local int                           LocationIdx;
	local vector                        TargetLoc;
	local bool							bAbilityUnitCaughtInDetonation;
	
	if (bRemoved)
		return ELR_NoInterrupt;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	//  Proximity mine should not blow up as a pre-emptive strike; only blow up after the ability has successfully executed
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	AbilityUnit = XComGameState_Unit(EventSource);
	AbilityState = XComGameState_Ability(EventData);

	if (SourceUnit != none && AbilityUnit != none && AbilityState != none && AbilityContext != none)
	{
		SourceUnitAtTimeOfLaunch = GetSourceUnitAtTimeOfApplication();

		if (SourceUnitAtTimeOfLaunch.IsEnemyUnit(AbilityUnit) && AbilityState.IsAbilityInputTriggered() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			foreach ApplyEffectParameters.AbilityResultContext.RelevantEffectTiles(CheckTile)
			{
				if (CheckTile == AbilityUnit.TileLocation)
				{
					bLocationMatch = true;
					bAbilityUnitCaughtInDetonation = true; //The unit itself tripped the mine; it must be caught in the explosion
					break;
				}
			}
			if (!bLocationMatch)
			{
				for (LocationIdx = 0; LocationIdx < AbilityContext.InputContext.TargetLocations.Length; ++LocationIdx)
				{
					TargetLoc = AbilityContext.InputContext.TargetLocations[LocationIdx];
					AffectedTile = `XWORLD.GetTileCoordinatesFromPosition(TargetLoc);
					foreach ApplyEffectParameters.AbilityResultContext.RelevantEffectTiles(CheckTile)
					{
						if (CheckTile == AffectedTile)
						{
							bLocationMatch = true;
							bAbilityUnitCaughtInDetonation = false;
							break;
						}
					}
				}
			}
			if (bLocationMatch)
			{
				DetonateGrenadeTrap(SourceUnit, bAbilityUnitCaughtInDetonation?AbilityUnit:None, GameState);
			}
		}
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn GrenadeTrap_ObjectMoved(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory  History;
	local XComGameState_Unit    MovedUnit, SourceUnit, SourceUnitAtTimeOfLaunch;	
	local TTile                 AffectedTile;
	local bool                  bTileMatches;

	if (bRemoved)
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	MovedUnit = XComGameState_Unit(EventData);
	if (MovedUnit != none && SourceUnit != none)
	{
		foreach ApplyEffectParameters.AbilityResultContext.RelevantEffectTiles(AffectedTile)
		{
			if (AffectedTile == MovedUnit.TileLocation)
			{
				bTileMatches = true;
				break;
			}
		}
		if (bTileMatches)
		{
			SourceUnitAtTimeOfLaunch = GetSourceUnitAtTimeOfApplication();

			if (MovedUnit.IsEnemyUnit(SourceUnitAtTimeOfLaunch) && MovedUnit.IsAlive())          //  friendlies will not trigger the proximity mine
			{
				DetonateGrenadeTrap(SourceUnit, MovedUnit, GameState);
			}
		}
	}

	return ELR_NoInterrupt;
}

private function DetonateGrenadeTrap(XComGameState_Unit SourceUnit, XComGameState_Unit TriggeringUnit, XComGameState RespondingToGameState)
{
	local XComGameState_Ability AbilityState;
	local AvailableAction Action;
	local AvailableTarget Target;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local TTile                 AffectedTile;
	local XComGameState_Unit    UnitState;

	History = `XCOMHISTORY;

	//FindAbility(name AbilityTemplateName, optional StateObjectReference MatchSourceWeapon, optional array<StateObjectReference> ExcludeSourceWeapons)
	Action.AbilityObjectRef = SourceUnit.FindAbility('MZGrenadeTrapDetonate', ApplyEffectParameters.ItemStateObjectRef);
	if (Action.AbilityObjectRef.ObjectID != 0)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Action.AbilityObjectRef.ObjectID));
		if (AbilityState != none)
		{
			//  manually check the unit states being modified by the event as they may not be properly updated in the world data until the event is complete
			foreach RespondingToGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
			{
				foreach ApplyEffectParameters.AbilityResultContext.RelevantEffectTiles(AffectedTile)
				{
					if (UnitState.TileLocation == AffectedTile)
					{
						if (Target.AdditionalTargets.Find('ObjectID', UnitState.ObjectID) == INDEX_NONE)
							Target.AdditionalTargets.AddItem(UnitState.GetReference());

						break;      //  no need to keep checking tiles for this unit
					}
				}
			}

			Action.AvailableCode = 'AA_Success';
			AbilityState.GatherAdditionalAbilityTargetsForLocation(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], Target);

			//Ensure that the triggering unit is caught in the blast.
			if (TriggeringUnit != None && Target.AdditionalTargets.Find('ObjectID', TriggeringUnit.ObjectID) == INDEX_NONE)
			{
				Target.AdditionalTargets.AddItem(TriggeringUnit.GetReference());
			}

			Action.AvailableTargets.AddItem(Target);

			if (class'XComGameStateContext_Ability'.static.ActivateAbility(Action, 0, ApplyEffectParameters.AbilityInputContext.TargetLocations))
			{
				EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(self);
				NewGameState = History.CreateNewGameState(true, EffectRemovedState);
				RemoveEffect(NewGameState, RespondingToGameState);
				SubmitNewGameState(NewGameState);
			}
		}
	}
}

function EventListenerReturn ModifyGrenadeRange(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	local XComGameState_Ability		Ability;
	local X2GrenadeLauncherTemplate	GLTemplate;
	local X2WeaponTemplate			WeaponTemplate;
	local XComGameState_Item		SourceAmmo;
	local float						fRange;
	local MZ_Effect_ModifyGrenadeRange	SourceEffect;
	
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none){ return ELR_NoInterrupt; }

	Item = XComGameState_Item(EventSource);
	if(Item == none) { return ELR_NoInterrupt; }

	if(OverrideTuple.Id != 'GetItemRange'){ return ELR_NoInterrupt; }

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability
	if(Ability == none) { return ELR_NoInterrupt; }

	if ( Item.OwnerStateObject.ObjectID != ApplyEffectParameters.TargetStateObjectRef.ObjectID ) {	return ELR_NoInterrupt;	}

	SourceEffect = MZ_Effect_ModifyGrenadeRange(GetX2Effect());

	if (( SourceEffect.bThrowGrenade == true && Ability.GetMyTemplateName() == 'ThrowGrenade' ) || ( SourceEffect.bLaunchGrenade == true && Ability.GetMyTemplateName() == 'LaunchGrenade' ) || ( SourceEffect.bGrenadeTrap == true && Ability.GetMyTemplateName() == 'MZThrowGrenadeTrap' ))
	{
		// All the validation checks are complete - get the existing range and modify
		GLTemplate = X2GrenadeLauncherTemplate(Item.GetMyTemplate());
		if(GLTemplate != none)
		{
			SourceAmmo = Ability.GetSourceAmmo();
			if(SourceAmmo != none)
			{
				WeaponTemplate = X2WeaponTemplate(SourceAmmo.GetMyTemplate());
				if(WeaponTemplate != none)
				{
					fRange = WeaponTemplate.iRange + GLTemplate.IncreaseGrenadeRange;
				}
			}
		}

		if (fRange == 0)
		{
			WeaponTemplate = X2WeaponTemplate(Item.GetMyTemplate());
			if(WeaponTemplate != none)
			{
				fRange = WeaponTemplate.iRange;
			}	
		}
	
		fRange = (fRange * SourceEffect.RangeChangeMult) + SourceEffect.RangeChangeFlat;

		// Flag override Tuple as an override and pass the modified value
		OverrideTuple.Data[0].b = true;
		OverrideTuple.Data[1].i = Round(fRange);
	}
	

	return ELR_NoInterrupt;
}

function EventListenerReturn FrostShieldAntiBypassListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit NewSourceUnit, TargetUnit;
	local int DamageDealt, DmgIdx, HPToShift;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(Self.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		if (TargetUnit != none && TargetUnit.IsAlive() )
		{
			for (DmgIdx = 0; DmgIdx < TargetUnit.DamageResults.Length; ++DmgIdx)
			{
				if (TargetUnit.DamageResults[DmgIdx].Context == AbilityContext)
				{
					DamageDealt += TargetUnit.DamageResults[DmgIdx].DamageAmount;
				}
			}
			if (DamageDealt > 0 && TargetUnit.GetCurrentStat(eStat_ShieldHP) > 0 )
			{
				//this implies that the damage bypassed the shield.
				//shift shield to HP. limited by missing HP or current shield, whichever is lower.
				HPToShift = Min((TargetUnit.GetMaxStat(eStat_HP) - TargetUnit.GetCurrentStat(eStat_HP)), TargetUnit.GetCurrentStat(eStat_ShieldHP));

				if ( HPToShift >= 1 )
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					//  Submit a game state that shifts the shield to HP.
					NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
					NewSourceUnit.ModifyCurrentStat(eStat_HP, HPToShift);
					NewSourceUnit.ModifyCurrentStat(eStat_ShieldHP, -HPToShift);				
					`TACTICALRULES.SubmitGameState(NewGameState);
				}		
			}
		}
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	bTacticalTransient=true
}