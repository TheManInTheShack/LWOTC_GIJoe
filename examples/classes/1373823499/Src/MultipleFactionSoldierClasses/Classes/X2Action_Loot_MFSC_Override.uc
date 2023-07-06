class X2Action_Loot_MFSC_Override extends X2Action_Loot;

simulated state Executing
{
	function BeginSlurp()
	{
		local XComGameStateHistory History;
		local ParticleSystemComponent FXComponent;
		local X2ItemTemplate ItemTemplate;
		local XComGameState_Item LootItemState;
		local XComTacticalController TacticalController;
		local XGUnit ActiveUnit;
		local XComGameState_Unit SelectedUnit;
		local float ParameterValue;
		local Vector VectorValue;
		local X2CharacterTemplate CharacterTemplate; 

		History = `XCOMHISTORY;

		if( LootVisActors.Length > 0 )
		{
			LootStartTimeSeconds = WorldInfo.TimeSeconds;
			LootStartLoc = LootVisActors[0].Location;
			if( LootVisActors[0] != None )
			{
				LootVisActors[0].SetPhysics(PHYS_Interpolating);

				LootItemState = XComGameState_Item(History.GetGameStateForObjectID(LootVisActorsObjectIDs[0]));
				ItemTemplate = LootItemState.GetMyTemplate();
				if( ItemTemplate.LootParticleSystemEnding != None )
				{
					foreach LootVisActors[0].AllOwnedComponents(class'ParticleSystemComponent', FXComponent)
					{
						// Jwats: Swap the particles for the ending particle system
						LootVisActors[0].DetachComponent(FXComponent);
						FXComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ItemTemplate.LootParticleSystemEnding, LootVisActors[0].Location, LootVisActors[0].Rotation, LootVisActors[0]);
						LootVisActors[0].AttachComponent(FXComponent);

						TacticalController = XComTacticalController(`XWORLDINFO.GetALocalPlayerController());
						ActiveUnit = TacticalController.GetActiveUnit();
						SelectedUnit = XComGameState_Unit(History.GetGameStateForObjectID(ActiveUnit.ObjectID));
						if( SelectedUnit != None )
						{
							CharacterTemplate = class'XComGameState_Unit_MFSC'.static.GetCharTemplateForUnit(SelectedUnit);
							ParameterValue = CharacterTemplate.DataName == 'TemplarSoldier' ? 1.0f : 0.0f;
							VectorValue.X = ParameterValue;
							VectorValue.Y = ParameterValue;
							VectorValue.Z = ParameterValue;
							FXComponent.SetVectorParameter('Templar', VectorValue);
							FXComponent.SetFloatParameter('Templar', ParameterValue);
						}
						break;
					}
				}
			}
		}
	}

	function UpdateSlurp()
	{
		local float TimeSinceStart;
		local float Alpha;
		local Vector TargetLocation;

		TimeSinceStart = WorldInfo.TimeSeconds - LootStartTimeSeconds;

		if( TimeSinceStart >= LootSlurpTime )
		{
			`PRES.Notify(LootVisActorItemPickupStrings[0]);
			LootVisActors[0].Destroy();
			LootVisActors.Remove(0, 1);
			LootVisActorsObjectIDs.Remove(0, 1);
			LootVisActorItemPickupStrings.Remove(0, 1);
			BeginSlurp();
		}
		else
		{
			Alpha = (TimeSinceStart * TimeSinceStart) / (LootSlurpTime * LootSlurpTime);
			UnitPawn.Mesh.GetSocketWorldLocationAndRotation(LootReceptionSocket, TargetLocation);
			LootVisActors[0].SetLocation(VLerp(LootStartLoc, TargetLocation, Alpha));
		}
	}

Begin:
	// highlight loot sparkles for the old state
	OldLootableObjectState.UpdateLootSparklesEnabled(true);

	// Start looting anim
	if( OldLootableObjectState.HasNonPsiLoot() )
	{
		Params.AnimName = 'HL_LootBodyStart';
		Params.PlayRate = GetNonCriticalAnimationSpeed();
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
		{
			Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
		}
		else
		{
			FinishAnim(PlayingSequence);
		}
		}


		// Loop while the UI is displayed
		Params.AnimName = 'HL_LootLoop';
		Params.Looping = true;
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		}

		// show the UI, and wait for it to finish before playing the slurp
		`PRES.UIInventoryTactical(NewUnitState, OldLootableObjectState, OnUIInventoryTacticalClosed);
		while( !bLootingComplete )
		{
			Sleep(0.1f);
		}
	}
	// clear loot sparkles based on the new state
	NewLootableObjectState.UpdateLootSparklesEnabled(false);

	BeginSlurp();
	while( LootVisActors.Length > 0 )
	{
		UpdateSlurp();
		Sleep(0.001f);
	}

	if( OldLootableObjectState.HasNonPsiLoot() )
	{
		Params.AnimName = 'HL_LootStop';
		Params.Looping = false;
		Params.PlayRate = GetNonCriticalAnimationSpeed();
		if( UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) )
		{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		if( Metadata.VisualizeActor.CustomTimeDilation < 1.0 )
		{
			Sleep(PlayingSequence.AnimSeq.SequenceLength * PlayingSequence.Rate * Metadata.VisualizeActor.CustomTimeDilation);
		}
		else
		{
			FinishAnim(PlayingSequence);
		}
		}
		
		Unit.UnitSpeak('LootCaptured');
	}

	CompleteAction();
}

