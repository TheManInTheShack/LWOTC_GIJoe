class MZ_Helper_Restrict extends Object config(MZPerkWeapons);

var config array<name> PsiShard_Weapons, PsiCrit_Weapons, PsiAim_TargetSkills, PsiAim_TargetReactionSkills, PsiAim_CursorSkills, PsiAim_ScatterSkills;
var config array<name> UseFanfireAnimForAbilities;
var config float PsiCritMult;
var config int PsiCritFlat;

var config bool bLog_PsiScatter;

//badly named function? yes. sorry it used to do something completely different.
static function CreatePsiCritDamage()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<name> TemplateNames;
	local array<X2DataTemplate> DifficultyVariants;
	local name TemplateName, AbilityName;
	local X2DataTemplate ItemTemplate;
	local X2WeaponTemplate WeaponTemplate;
	//local WeaponDamageValue	WeaponDamage;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Effect_PersistentStatChange			PoisonEffect;
	local X2Effect_Persistent					PersistentEffect;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplateManager.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		ItemTemplateManager.FindDataTemplateAllDifficulties(TemplateName, DifficultyVariants);
		// Iterate over all variants
		
		foreach DifficultyVariants(ItemTemplate)
		{
			WeaponTemplate = X2WeaponTemplate(ItemTemplate);
			if (WeaponTemplate != none)
			{
				/* don't think this actually works properly. doesn't really need to since everything uses it's own damage tags now.
				if (default.PsiCrit_Weapons.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
				{
					foreach WeaponTemplate.ExtraDamage(WeaponDamage)
					{
						if (WeaponDamage.Crit < 1)
						{
							WeaponDamage.Crit = WeaponDamage.Damage * default.PsiCritMult + default.PsiCritFlat;
						}
					}
				}
				*/

				/*
				Ability was rewritten to no longer need this, probablly.
				if ( default.PsiShard_Weapons.Find(WeaponTemplate.WeaponCat) != INDEX_NONE && WeaponTemplate.InventorySlot != eInvSlot_TertiaryWeapon)
				{
					WeaponTemplate.Abilities.AddItem('MZStaticShockShot');
				}
				*/
				if ( WeaponTemplate.WeaponCat == 'ripjack' )
				{
					AbilityCondition = new class'X2Condition_AbilityProperty';
					AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZRipjackBleed');
					PersistentEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(3,2);
					PersistentEffect.TargetConditions.AddItem(AbilityCondition);
					WeaponTemplate.BonusWeaponEffects.AddItem(PersistentEffect);
				}

				if ( WeaponTemplate.WeaponCat == 'pistol' || WeaponTemplate.WeaponCat == 'sidearm' )
				{
					if ( WeaponTemplate.GetAnimationNameFromAbilityName('Fanfire') != '')
					{
						foreach default.UseFanfireAnimForAbilities(AbilityName)
						{
							WeaponTemplate.SetAnimationNameForAbility(AbilityName, WeaponTemplate.GetAnimationNameFromAbilityName('Fanfire'));
						}
					}
					else
					{
						`LOG("Warning:: Could not find Fanfire anim for weapon: " $ String(WeaponTemplate.DataName));
					}

					// Grimy Needlepoint Rounds Poison Effect
					AbilityCondition = new class'X2Condition_AbilityProperty';
					AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyNeedlePointPassive');
					PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
					PoisonEffect.EffectTickedFn = none;
					PoisonEffect.TargetConditions.AddItem(AbilityCondition);
					WeaponTemplate.BonusWeaponEffects.AddItem(PoisonEffect);
				}
			}
		}
	}
}

static function ApplyPsiAimToSkills()
{
	local X2AbilityTemplateManager				AbilityManager;
	local array<X2AbilityTemplate>				TemplateAllDifficulties;
	local X2AbilityTemplate						Template;
	local name									TemplateName;
	local MZ_Aim_PsiAttack						AimType;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (default.PsiAim_TargetSkills.Length > 0)
	{
		foreach default.PsiAim_TargetSkills(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				Template.AbilityToHitCalc = new class'MZ_Aim_PsiAttack';
				
			}
		}
	}

	if (default.PsiAim_TargetReactionSkills.Length > 0)
	{
		AimType = new class'MZ_Aim_PsiAttack';
		AimType.bReactionFire = true;

		foreach default.PsiAim_TargetReactionSkills(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				Template.AbilityToHitCalc = AimType;	
			}
		}
	}

	if (default.PsiAim_CursorSkills.Length > 0)
	{
		AimType = new class'MZ_Aim_PsiAttack';
		AimType.bMultiTargetOnly = true;
		AimType.bIgnoreCoverBonus = false;

		foreach default.PsiAim_CursorSkills(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				Template.AbilityToHitCalc = AimType;
			}
		}
	}

	if (default.PsiAim_ScatterSkills.Length > 0)
	{
		AimType = new class'MZ_Aim_PsiAttack';
		AimType.bIndirectFire = true;

		foreach default.PsiAim_ScatterSkills(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				Template.AbilityToHitCalc = AimType;
			}
		}
	}
}

static final simulated function PsiScatter_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit			UnitState;
	local XComGameState_Ability			AbilityState;
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameStateHistory			History;
	local vector						NewLocation;
	local XComWorldData					World;
	local float							ScatterAmount;
	local AvailableTarget				Target;
	local TTile							TileLocation;

	History = `XCOMHISTORY;
	
	AbilityContext = XComGameStateContext_Ability(Context);
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	`LOG("Mofying context for: " @ AbilityState.GetMyTemplateName() @ " cast by: "@ UnitState.GetFullName(), default.bLog_PsiScatter, 'MZPsi_Scatter');

	World = `XWORLD;
	NewLocation = AbilityContext.InputContext.TargetLocations[0];
	
	if (GetScatterAmount(AbilityState, UnitState, NewLocation, ScatterAmount))
	{
		`LOG("Original hit loc: " @ NewLocation @ "Num multi targets:" @ AbilityContext.InputContext.MultiTargets.Length @ "multi hit results:" @ AbilityContext.ResultContext.MultiTargetHitResults.Length @ "scatter, tiles: " @ ScatterAmount, default.bLog_PsiScatter, 'MZPsi_Scatter');

		ScatterAmount = class'XComWorldData'.const.WORLD_StepSize * ScatterAmount;

		`LOG("Scatter, units: " @ ScatterAmount, default.bLog_PsiScatter, 'MZPsi_Scatter');

		NewLocation.X += `SYNC_RAND_STATIC(int(ScatterAmount * 2)) - ScatterAmount;
		NewLocation.Y += `SYNC_RAND_STATIC(int(ScatterAmount * 2)) - ScatterAmount;
		NewLocation.Z += `SYNC_RAND_STATIC(int(ScatterAmount));

		`LOG("New hit loc: " @ NewLocation, default.bLog_PsiScatter, 'MZPsi_Scatter');

		//	Prevents from targeting off-map locations
		TileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
		if (World.IsTileOutOfRange(TileLocation))
		{
			NewLocation = World.FindClosestValidLocation(NewLocation, false, false);
			`LOG("Scatter tile is out of bounds, new valid hit loc: " @ NewLocation, default.bLog_PsiScatter, 'MZPsi_Scatter');
		}
		
		if (AbilityState.GetMyTemplate().TargetingMethod.static.UseGrenadePath())
		{
			`LOG("Ability uses grenade path, scatter to floor", default.bLog_PsiScatter, 'MZPsi_Scatter');
			NewLocation.Z = World.GetFloorZForPosition(NewLocation);
		}
		else
		{
			`LOG("Ability uses direct projectiles, get optimal Z.", default.bLog_PsiScatter, 'MZPsi_Scatter');
			GetOptimalZ(NewLocation, World);
		}

		AbilityState.GatherAdditionalAbilityTargetsForLocation(NewLocation, Target);
		AbilityContext.InputContext.MultiTargets = Target.AdditionalTargets;

		AbilityContext.InputContext.TargetLocations.Length = 0;
		AbilityContext.InputContext.TargetLocations.AddItem(NewLocation);

		AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
		AbilityContext.ResultContext.ProjectileHitLocations.AddItem(NewLocation);

		// To Hit Calc is done before this function runs, so we have to re-roll multi target hit results.
		if (AbilityState.GetMyTemplate().AbilityToHitCalc != none)
		{
			AbilityContext.ResultContext.MultiTargetHitResults.Length = 0;
			AbilityState.GetMyTemplate().AbilityToHitCalc.RollForAbilityHit(AbilityState, Target, AbilityContext.ResultContext);
		}

		`LOG("Final hit loc: " @ NewLocation @ "new multi targets:" @ AbilityContext.InputContext.MultiTargets.Length @ "new multi hit results:" @ AbilityContext.ResultContext.MultiTargetHitResults.Length, default.bLog_PsiScatter, 'MZPsi_Scatter');

		//AbilityContext.PostBuildVisualizationFn.AddItem(PsiScatter_PostBuildVisualization);
	}
}

//	Change the Z-point the projectile hits based on if the targeted tile has some sort of object in it.
static final function GetOptimalZ(out vector ScatteredTargetLoc, XComWorldData World)
{
	local TTile							TileLocation;
	local array<StateObjectReference>	TargetsOnTile;
	local XComGameState_Unit			TargetUnit;

	`LOG("Running:" @ GetFuncName() @ "for original scatter location:", default.bLog_PsiScatter, 'MZPsi_Scatter');
	`LOG(ScatteredTargetLoc, default.bLog_PsiScatter, 'MZPsi_Scatter');

	ScatteredTargetLoc.Z = World.GetFloorZForPosition(ScatteredTargetLoc);

	`LOG("Lowered Z to the floor:", default.bLog_PsiScatter, 'MZPsi_Scatter');
	`LOG(ScatteredTargetLoc, default.bLog_PsiScatter, 'MZPsi_Scatter');

	//	Check if there are any units on targeted tile, and grab a unit state for the first of them.
	TileLocation = World.GetTileCoordinatesFromPosition(ScatteredTargetLoc);
	TargetsOnTile = World.GetUnitsOnTile(TileLocation);
	if (TargetsOnTile.Length > 0)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetsOnTile[0].ObjectID));
		if (TargetUnit != none)
		{
			//	If there is a unit, the rocket hits a random point on the upper part of the target's vertical profile.
			ScatteredTargetLoc.Z += TargetUnit.UnitHeight * (class'XComWorldData'.const.WORLD_FloorHeight - class'XComWorldData'.const.WORLD_HalfFloorHeight * `SYNC_FRAND_STATIC());

			`LOG("There's a unit on tile, raising Z:" @ TargetUnit.GetFullName() @ "Unit height:" @ TargetUnit.UnitHeight, default.bLog_PsiScatter, 'MZPsi_Scatter');
			`LOG(ScatteredTargetLoc, default.bLog_PsiScatter, 'MZPsi_Scatter');
		}
	}
	else if (World.IsTileFullyOccupied(TileLocation)) // Tile contains an object
	{	
		ScatteredTargetLoc.Z += class'XComWorldData'.const.WORLD_HalfFloorHeight + class'XComWorldData'.const.WORLD_HalfFloorHeight * `SYNC_FRAND_STATIC();

		`LOG("Tile is fully occupied, raising Z:", default.bLog_PsiScatter, 'MZPsi_Scatter');
		`LOG(ScatteredTargetLoc, default.bLog_PsiScatter, 'MZPsi_Scatter');
	}
}

/*
static private function PsiScatter_PostBuildVisualization(XComGameState VisualizeGameState)
{
	local VisualizationActionMetadata	ActionMetadata;
	local XComGameStateHistory			History;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_PlaySoundAndFlyOver	FlyOverAction;

	local XComGameStateContext_Ability	Context;
	local XComGameState_Ability			AbilityState;
	local XComGameState_Unit			UnitState;
	local X2Action						FindAction;
	local array<X2Action>				FoundActions;
	local X2Action_MarkerNamed			ReplaceAction;
	//local ScatterStruct ScatterParams;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = UnitState;

	//this is based on scatter params, which we aren't using.
	if (GetScatterParams(AbilityState, UnitState, ScatterParams))
	{
		//	Replace any Cinescript Camera Actions associated with the ability shooter with dummy stubs.
		if (ScatterParams.bRemoveCinematicCam)
		{
			VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_StartCinescriptCamera', FoundActions, , Context.InputContext.SourceObject.ObjectID);
			foreach FoundActions(FindAction)
			{
				ReplaceAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', Context));
				ReplaceAction.SetName("ReplaceCinescriptCameraAction");
				VisMgr.ReplaceNode(ReplaceAction, FindAction);			
			}
			VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_EndCinescriptCamera', FoundActions, , Context.InputContext.SourceObject.ObjectID);
			foreach FoundActions(FindAction)
			{
				ReplaceAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', Context));
				ReplaceAction.SetName("ReplaceCinescriptCameraAction");
				VisMgr.ReplaceNode(ReplaceAction, FindAction);			
			}
		}
	}

	//	Try to put the Flyover Action right after Fire Action, if it exists. If not, let it autoparent.
	//flyover for the hit miss thing, which isn't happening. instead, scaling scatter based on psi offense.
	FindAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', ActionMetadata.VisualizeActor, Context.InputContext.SourceObject.ObjectID);
	if (FindAction != none)
	{
		FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, FindAction));
	}
	else
	{
		FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	}

	//if (bHit)
	//{
	//	FlyOverAction.SetSoundAndFlyOverParameters(None, class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[eHit_Success], '', eColor_Good, AbilityState.GetMyIconImage());
	//}
	//else
	//{
	//	FlyOverAction.SetSoundAndFlyOverParameters(None, class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[eHit_Miss], '', eColor_Bad, AbilityState.GetMyIconImage());
	//}

	//`LOG("========= TREE AFTER ===============");
	//PrintActionRecursive(VisMgr.BuildVisTree, 0);
	//`LOG("-------------------------------------");
}
*/

static private function bool GetScatterAmount(const XComGameState_Ability AbilityState, const XComGameState_Unit UnitState, const vector TargetLoc, out float ScatterAmount)
{
	local float			EffectiveAim, MaxScatter;
	local int			TileDistance, RandRoll;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;

	EffectiveAim = UnitState.GetCurrentStat(eStat_PsiOffense);

	//Adjust it for distance to the target using the Range Table
	//currently this will only be accurate if we convert psi to regular aim first. may want a seperate table.
	TileDistance = TileDistanceBetween(UnitState, TargetLoc);

	if(class'MZ_Aim_PsiAttack'.default.PsiAim_Range.Length > 0)
	{
		if (TileDistance > class'MZ_Aim_PsiAttack'.default.PsiAim_Range.Length - 1)
		{
			EffectiveAim += class'MZ_Aim_PsiAttack'.default.PsiAim_Range[class'MZ_Aim_PsiAttack'.default.PsiAim_Range.Length - 1];
		}
		else
		{
			EffectiveAim += class'MZ_Aim_PsiAttack'.default.PsiAim_Range[TileDistance];
		}
	}

	//need to grab the abilities' current radius, and base maximum scatter off that
	RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);
	If ( RadiusMultiTarget != none )
	{
		MaxScatter = RadiusMultiTarget.GetTargetRadius(AbilityState);
	}
	else
	{
		MaxScatter = 0;
		return false;
	}

	ScatterAmount = 1.0;

	return true;
}

static private function int TileDistanceBetween(const XComGameState_Unit Unit, const vector TargetLoc)
{
    local XComWorldData WorldData;
    local vector UnitLoc;
    local float Dist;
    local int Tiles;

    WorldData = `XWORLD;
    UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
    Dist = VSize(UnitLoc - TargetLoc);
    Tiles = Dist / WorldData.WORLD_StepSize;
    return Tiles;
}

static private function bool DidUnitMoveThisTurn(const XComGameState_Unit UnitState)
{
	local UnitValue MovesThisTurn;

	UnitState.GetUnitValue('MovesThisTurn', MovesThisTurn);

	return MovesThisTurn.fValue > 0;
}