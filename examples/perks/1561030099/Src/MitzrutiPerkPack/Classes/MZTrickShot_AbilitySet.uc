// This is an Unreal Script
class MZTrickShot_AbilitySet extends X2Ability dependson (XComGameStateContext_Ability) config(MZPerkPack);
	
var config int DisablingSting_Charges, DisablingSting_Cooldown, DisablingSting_AmmoCost, DisablingSting_Stun_Chance, DisablingSting_Stun_Duration, Medishot_Charges, Medishot_Range, BlazingSpear_Charges, BlazingSpear_Cooldown, PlagueSpear_Charges, PlagueSpear_Cooldown;
var config int StingingGale_Charges, StingingGale_Cooldown, StingingGale_AmmoCost, SecretHunt_Cooldown, BurialShot_Cooldown, BlisterShot_Rupture, BlisterShot_AmmoCost, BlisterShot_Cooldown, Ventilate_AmmoCost, Ventilate_Cooldown;
var config int AccurateReaction_Bonus, HammerShot_AmmoCost, HammerShot_Cooldown, HammerShot_Knockback, SuperShot_Cooldown, SuperShred_Cooldown, SurefireShot_Charges;
var config int StormLanceShot_Cooldown, ExplosiveShot_Cooldown, BloodKillZone_Width, BloodKillZone_Length, BloodKillZoneShot_HPCost, FightInTheShade_BlindTurns; 
var config float ExplosiveShot_Radius, ShotgunWedding_DamageMod, BloodShot_DamageMod, BloodShot_BetaDamageMod, BloodShot_PercentHPCost, HungeringShot_LifeSteal, BloodKillZone_BonusMult, FightInTheShade_VisionMult, SonicBoom_Radius, AbyssalShot_BonusDamage, BloodSpear_BonusDamage, BulletRave_DamageScalar, BulletRave_FinalAimMod, PlagueSpear_DamageMult;
var config float SuperShot_PerRoundDamage, SuperShred_PerRoundShred;
var config int ShotgunWedding_Cooldown, ShotgunWedding_Length, ShotgunWedding_Width, BloodShot_HPCost, BloodShot_AimMod, BloodShot_CritMod, BloodShot_GrazeMod, AbyssalShot_HPCost, BloodSpear_HPCost, HungeringShot_Charges, HungeringShot_Ammo, DetonationShot_Cooldown, DetonationShot_AmmoCost, BulletRave_Cooldown;
var config int Sidewinder_Cooldown, VitalsShot_Cooldown, VitalsShot_Advent_BleedTurns, VitalsShot_Advent_BleedDamage, VitalsShot_Robot_Stun, VitalsShot_Alien_Confuse, VitalsShot_Undead_BurnDmg, VitalsShot_Undead_BurnSpread, VitalsShot_MaxOustChance, SonicBoom_Ammo, SonicBoom_AimMod, SonicBoom_Charges, SonicBoom_Cooldown;
var config bool BloodKillZone_IsreactionFire;

var localized string BloodShotBonusName, BloodKillZoneBonusName, VitalsShotPsiCoolEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddDisablingStingAbility());
	Templates.AddItem(AddStingingGaleAbility());
	Templates.AddItem(AddAccurateReactionAbility());
	Templates.AddItem(PurePassive('MZBlindingSuppression', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist"));
	Templates.AddItem(PurePassive('MZConfusingSuppression', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_chosendazed"));
	Templates.AddItem(PurePassive('MZDisablingSuppression', "img:///UILibrary_PerkIcons.UIPerk_disablingshot"));
	Templates.AddItem(PurePassive('MZPoisoningSuppression', "img:///UILibrary_PerkIcons.UIPerk_poisoned"));
	Templates.AddItem(PurePassive('MZBurningSuppression', "img:///UILibrary_PerkIcons.UIPerk_burn"));
	Templates.AddItem(PurePassive('MZPanicSuppression', "img:///UILibrary_PerkIcons.UIPerk_panic"));
	Templates.AddItem(AddStormLanceShot());
	Templates.AddItem(AddExplosiveShot());
	Templates.AddItem(AddShotgunWedding());
	/*>>*/Templates.AddItem(AddShotgunWeddingChaser());
	/*>>*/Templates.AddItem(class'MZGrimyHeadHunter_AbilitySet'.static.GrimyBonusDamage('MZShotgunWeddingBonus','MZShotgunWeddingChaser', default.ShotgunWedding_DamageMod));
	Templates.AddItem(AddBloodShot());
	/*>>*/Templates.AddItem(AddBloodShotBonus());
	Templates.AddItem(AbyssalShot());
	Templates.AddItem(AddHungeringShot());
	Templates.AddItem(AddHungeringShotConceal());
	Templates.AddItem(AddDetonationshot());
	Templates.AddItem(AddBloodKillZone());
	/*>>*/Templates.AddItem(AddBloodKillZoneShot());
	/*>>*/Templates.AddItem(AddBloodKillZoneShotBonus());
	Templates.AddItem(PurePassive('MZFightInTheShade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist"));
	Templates.AddItem(AddMediShot());
	Templates.AddItem(AddHammerShot());
	Templates.AddItem(AddSidewinder());
	Templates.AddItem(AddVitalsShot());
	Templates.AddItem(AddSonicBoom(default.SonicBoom_Charges, default.SonicBoom_Cooldown));
	Templates.AddItem(AddSecretHunt());
	/*>>*/Templates.AddItem(AddSecretHuntConceal());
	Templates.AddItem(RunningOnEmpty());
	/*>>*/Templates.AddItem(RunningOnEmptyTrigger());
	Templates.AddItem(NoMercy());
	/*>>*/Templates.AddItem(NoMercyShot());
	Templates.AddItem(BloodSpear());
	Templates.AddItem(BurialShot());
	Templates.AddItem(BulletRave());
	Templates.AddItem(BlazingSpear());
	Templates.AddItem(PlagueSpear());
	Templates.AddItem(BlisterShot());
	Templates.AddItem(Ventilate());
	Templates.AddItem(SuperShot());
	Templates.AddItem(SuperShredShot());
	Templates.AddItem(SurefireShot());

	Templates.AddItem(FondFarewell());

	return Templates;
}
	
static function X2AbilityTemplate AddDisablingStingAbility()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Effect_Stunned					StunnedEffect;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('MZDisablingSting', false, false, false);
	Template.SuperConcealmentLoss = 0;
	Template.ConcealmentRule = eConceal_Always;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsSuperConcealed = true;
	Template.AbilityShooterConditions.AddItem(ConcealedCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DisablingSting_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.DisablingSting_Charges;
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	Template.AbilityCosts.AddItem(ChargeCost);
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.DisablingSting_AmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.DisablingSting_Stun_Duration, default.DisablingSting_Stun_Chance, false);
	StunnedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	Template.AddTargetEffect(StunnedEffect);

//BEGIN AUTOGENERATED CODE: Template Overrides 'Sting'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ActivationSpeech = 'Sting';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DisablingShot";
//END AUTOGENERATED CODE: Template Overrides 'Sting'

	return Template;
}

static function X2AbilityTemplate AddStingingGaleAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Condition_UnitProperty			ConcealedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStingingGale');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_soulreaper";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	Template.SuperConcealmentLoss = 0;
	Template.ConcealmentRule = eConceal_Always;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.StingingGale_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.StingingGale_Charges;
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	Template.AbilityCosts.AddItem(ChargeCost);
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.StingingGale_AmmoCost;
	AmmoCost.bConsumeAllAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	MultiTargetUnits = new class'X2AbilityMultiTarget_AllUnits';
	MultiTargetUnits.bUseAbilitySourceAsPrimaryTarget = true;
	MultiTargetUnits.bAcceptEnemyUnits = true;
	Template.AbilityMultiTargetStyle = MultiTargetUnits;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsSuperConcealed = true;
	ConcealedCondition.ExcludeAlive=false;
	ConcealedCondition.ExcludeDead=true;
	ConcealedCondition.ExcludeHostileToSource=true;
	Template.AbilityShooterConditions.AddItem(ConcealedCondition);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Faceoff_BuildVisualization;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Faceoff'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Banish';
//END AUTOGENERATED CODE: Template Overrides 'Faceoff'

	return Template;
}
function Faceoff_BuildVisualization(XComGameState VisualizeGameState)
{
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;
	local X2Action_Fire                 FireAction;
	local X2Action_Fire_Faceoff         FireFaceoffAction;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	

	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface;
	local int                       EffectIndex, TargetIndex;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local VisualizationActionMetadata        SourceTrack;
	local XComGameStateHistory      History;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local name         ApplyResult;

	local X2Action_StartCinescriptCamera CinescriptStartAction;
	local X2Action_EndCinescriptCamera   CinescriptEndAction;
	local X2Camera_Cinescript            CinescriptCamera;
	local string                         PreviousCinescriptCameraType;
	local X2Effect                       TargetEffect;

	local X2Action_MarkerNamed				JoinActions;
	local array<X2Action>					LeafNodes;
	local XComGameStateVisualizationMgr		VisualizationMgr;
	local X2Action_ApplyWeaponDamageToUnit	ApplyWeaponDamageAction;


	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;

	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if( SourceTrack.StateObject_NewState == none )
		SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	SourceTrack.VisualizeActor = ShooterVisualizer;

	if( AbilityTemplate.ActivationSpeech != '' )     //  allows us to change the template without modifying this function later
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(SourceTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}


	// Add a Camera Action to the Shooter's Metadata.  Minor hack: To create a CinescriptCamera the AbilityTemplate 
	// must have a camera type.  So manually set one here, use it, then restore.
	PreviousCinescriptCameraType = AbilityTemplate.CinescriptCameraType;
	AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
	CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
	CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptStartAction.CinescriptCamera = CinescriptCamera;
	AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;


	class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	//  Fire at the primary target first
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	FireAction.SetFireParameters(Context.IsResultContextHit(), , false);
	//  Setup target response
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
	ActionMetadata = EmptyTrack;
	ActionMetadata.VisualizeActor = TargetVisualizer;
	TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
	if( TargetStateObject != none )
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID,
														   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
														   eReturnType_Reference,
														   VisualizeGameState.HistoryIndex);
		`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
	}
	else
	{
		//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
		//and show no change.
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	}

	for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
	{
		ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

		// Target effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

		// Source effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
	}
	if( TargetVisualizerInterface != none )
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
	if ( ApplyWeaponDamageAction != None)
	{
		VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
		VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireAction);
	}

	//  Now configure a fire action for each multi target
	for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
	{
		// Add an action to pop the previous CinescriptCamera off the camera stack.
		CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptEndAction.CinescriptCamera = CinescriptCamera;
		CinescriptEndAction.bForceEndImmediately = true;

		// Add an action to push a new CinescriptCamera onto the camera stack.
		AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
		CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
		CinescriptCamera.TargetObjectIdOverride = AbilityContext.MultiTargets[TargetIndex].ObjectID;
		CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptStartAction.CinescriptCamera = CinescriptCamera;
		AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;

		// Add a custom Fire action to the shooter Metadata.
		TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		FireFaceoffAction = X2Action_Fire_Faceoff(class'X2Action_Fire_Faceoff'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		FireFaceoffAction.SetFireParameters(Context.IsResultContextMultiHit(TargetIndex), AbilityContext.MultiTargets[TargetIndex].ObjectID, false);
		FireFaceoffAction.vTargetLocation = TargetVisualizer.Location;


		//  Setup target response
		TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = TargetVisualizer;
		TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		if( TargetStateObject != none )
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID,
															   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
															   eReturnType_Reference,
															   VisualizeGameState.HistoryIndex);
			`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
		}
		else
		{
			//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			//and show no change.
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex )
		{
			TargetEffect = AbilityTemplate.AbilityMultiTargetEffects[EffectIndex];
			ApplyResult = Context.FindMultiTargetEffectApplyResult(TargetEffect, TargetIndex);

			// Target effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

			// Source effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		}
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}

		ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
		if( ApplyWeaponDamageAction != None )
		{
			VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
			VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireFaceoffAction);
		}
	}
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	// Add an action to pop the last CinescriptCamera off the camera stack.
	CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptEndAction.CinescriptCamera = CinescriptCamera;

	//Add a join so that all hit reactions and other actions will complete before the visualization sequence moves on. In the case
	// of fire but no enter cover then we need to make sure to wait for the fire since it isn't a leaf node
	VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

	if( VisualizationMgr.BuildVisTree.ChildActions.Length > 0 )
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceTrack, Context, false, none, LeafNodes));
		JoinActions.SetName("Join");
	}
}

static function X2AbilityTemplate AddAccurateReactionAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ModifyReactionFire           ReactionFire;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAccurateReaction');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_coolpressure";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ReactionFire = new class'X2Effect_ModifyReactionFire';
	ReactionFire.ReactionModifier = default.AccurateReaction_Bonus;
	ReactionFire.BuildPersistentEffect(1, true, true, true);
	ReactionFire.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(ReactionFire);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddStormLanceShot()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Line			TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZStormLanceShot', "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.StormLanceShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	TargetStyle = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddExplosiveShot()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius			TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZExplosiveShot', "img:///UILibrary_PerkIcons.UIPerk_bigbooms");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ExplosiveShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = default.ExplosiveShot_Radius;
	TargetStyle.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddShotgunWedding()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_TriggerEvent             InsanityEvent;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShotgunWedding');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShotgunWedding_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.deadeye;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ShotgunWedding_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ShotgunWedding_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'FireMZShotgunWeddingChaser';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	//unfortunately, this animation doesn't work with shotguns.
	//Template.ActionFireClass = class'X2Action_Fire_SaturationFire';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//can I skip the visualize for the initial marking?
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SaturationFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SaturationFire'

	Template.AdditionalAbilities.AddItem('MZShotgunWeddingChaser');
	Template.AdditionalAbilities.AddItem('MZShotgunWeddingBonus');

	Template.DamagePreviewFn = ShotgunWeddingDamagePreview;

	return Template;	
}

function bool ShotgunWeddingDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	//AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZShotgunWeddingChaser');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddShotgunWeddingChaser()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardAim	AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShotgunWeddingChaser');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	AimType =  new class'X2AbilityToHitCalc_StandardAim';
	AimType.bOnlyMultiHitWithSuccess = true;
	Template.AbilityToHitCalc = AimType;
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';	

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ShotgunWedding_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ShotgunWedding_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityMultiTargetConditions.Length = 0;

	//Template.AddShooterEffectExclusions();

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'FireMZShotgunWeddingChaser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.MergeVisualizationFn = SequentialShot_MergeVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SaturationFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SaturationFire'

	return Template;	
}

static function X2AbilityTemplate AddBloodShot()
{
	local X2AbilityTemplate		Template;
	local Grimy_AbilityCost_HP					HPCost;
	local X2Effect_Blind					BlindEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBloodShot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodtrail");
	Template.AbilityIconColor = "C34144";
	Template.ShotHUDPriority = 320;

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodShot_HPCost;
	HPCost.PercentCost = default.BloodShot_PercentHPCost;
	Template.AbilityCosts.AddItem(HPCost);

	//have to block vamp ammo.
	Template.bAllowAmmoEffects = false; //

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.FightInTheShade_BlindTurns, default.FightInTheShade_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.FightInTheShade_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFightInTheShade');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BlindEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.AdditionalAbilities.AddItem('MZBloodShotBonus');

	return Template;
}
static function X2AbilityTemplate AddBloodShotBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KillingStroke				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodShotBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_KillingStroke';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName= 'MZBloodShot';
	DamageEffect.BonusMult = default.BloodShot_DamageMod;
	DamageEffect.BetaBonusMult = default.BloodShot_BetaDamageMod;
	DamageEffect.AimMod = default.BloodShot_AimMod;
	DamageEffect.CritMod = default.BloodShot_CritMod;
	DamageEffect.GrazeMod = default.BloodShot_GrazeMod;
	DamageEffect.FriendlyName = default.BloodShotBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AbyssalShot()
{
	local X2AbilityTemplate				Template;
	local Grimy_AbilityCost_HP			HPCost;
	local X2Effect_Blind				BlindEffect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local MZ_Damage_AddElemental		WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZAbyssalShot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodtrail");
	Template.AbilityIconColor = "C34144";
	Template.ShotHUDPriority = 320;

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.AbyssalShot_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.AbyssalShot_BonusDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	//have to block vamp ammo.
	Template.bAllowAmmoEffects = false; //

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.FightInTheShade_BlindTurns, default.FightInTheShade_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.FightInTheShade_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFightInTheShade');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BlindEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate AddHungeringShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local MZ_Effect_LifeSteal				LifeSteal;
	local X2Condition_UnitProperty			ShooterCondition;
	local X2Effect_Blind					BlindEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	Template =class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZHungeringShot', "img:///UILibrary_PerkIcons.UIPerk_soulsteal");
	Template.ShotHUDPriority = 320;

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.HungeringShot_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.bAllowAmmoEffects = false;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	LifeSteal = new class'MZ_Effect_LifeSteal';
	LifeSteal.FlatVamp = default.HungeringShot_LifeSteal;
	Template.AddTargetEffect(LifeSteal);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.FightInTheShade_BlindTurns, default.FightInTheShade_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.FightInTheShade_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFightInTheShade');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BlindEffect);

	Template.ConcealmentRule = eConceal_KillShot;

	return Template;
}

static function X2AbilityTemplate AddHungeringShotConceal()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ConcealOnKill          ConcealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHungeringShotConceal');
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_shadowfall";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ConcealEffect = new class'MZ_Effect_ConcealOnKill';
	ConcealEffect.BuildPersistentEffect(1, true, false, false);
	ConcealEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ConcealEffect.AbilityName = 'MZHungeringShot';
	Template.AddTargetEffect(ConcealEffect);
	
	Template.PrerequisiteAbilities.AddItem('MZHungeringShot');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddDetonationShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Effect_TriggerEvent             InsanityEvent;
	

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZDetonationShot', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade");
	//Template.IconImage = IconImage;
	Template.ShotHUDPriority = 340;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DetonationShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_Fuse';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);

	Template.DamagePreviewFn = DetonationShotDamagePreview;

	return Template;
}

function bool DetonationShotDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameStateHistory History;
	local XComGameState_Ability FuseTargetAbility;
	local XComGameState_Unit TargetUnit;
	local StateObjectReference EmptyRef, FuseRef;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	if (TargetUnit != none)
	{
		if (class'X2Condition_FuseTarget'.static.GetAvailableFuse(TargetUnit, FuseRef))
		{
			FuseTargetAbility = XComGameState_Ability(History.GetGameStateForObjectID(FuseRef.ObjectID));
			if (FuseTargetAbility != None)
			{
				//  pass an empty ref because we assume the ability will use multi target effects.
				FuseTargetAbility.GetDamagePreview(EmptyRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
				return true;
			}
		}
	}
	return false;
}

static function X2AbilityTemplate AddBloodKillZone( bool bDisplayZone=false)
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_ReserveActionPoints		ReservePointsEffect;
	local X2Effect_MarkValidActivationTiles MarkTilesEffect;
	local X2Condition_UnitEffects           SuppressedCondition;
	local X2Effect_Persistent			KillZoneEffect;
	local Grimy_AbilityCost_HP						HPCost;
	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodKillZone');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodKillZoneShot_HPCost;
	HPCost.bFreeCost = true;
	HPCost.FreeCostShots = 2;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_SkirmisherInterrupt'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.BloodKillZone_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.BloodKillZone_Length * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = 'MZBloodKillZoneReserveActionPoint';
	Template.AddShooterEffect(ReservePointsEffect);

	MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
	MarkTilesEffect.AbilityToMark = 'MZBloodKillZoneShot';
	MarkTilesEffect.bVisualizeFlagsOnCursor = bDisplayZone;
	Template.AddShooterEffect(MarkTilesEffect);

	if (bDisplayZone)
	{
		// Add persistent effect on shooter to be able to have a callback on load, 
		// so the pathing pawn is notified to display a flag on Killzone tiles on load.
		KillZoneEffect = new class'X2Effect_Persistent';
		KillZoneEffect.EffectName = 'KillZoneSource';
		KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		Template.AddShooterEffect(KillZoneEffect);
	}

	Template.AdditionalAbilities.AddItem('MZBloodKillZoneShot');
	Template.AdditionalAbilities.AddItem('MZBloodKillZoneShotBonus');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_killzone";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Defensive;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.AbilityIconColor = "C34144";

	Template.ActivationSpeech = 'KillZone';
	//Template.ConcealmentRule = eConceal_Never; //to make this break concealment.
	
	Template.bCrossClassEligible = false;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	Template.DamagePreviewFn = BloodKillZoneShotDamagePreview;
	
	return Template;
}

function bool BloodKillZoneShotDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	//AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZBloodKillZoneShot');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddBloodKillZoneShot()
{
	local X2AbilityTemplate							Template;
	local X2AbilityCost_Ammo						AmmoCost;
	local X2AbilityCost_ReserveActionPoints			ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim			StandardAim;
	local X2Condition_AbilityProperty				AbilityCondition;
	local X2AbilityTarget_Single					SingleTarget;
	local X2AbilityTrigger_EventListener			Trigger;
	local X2Effect_Persistent						KillZoneEffect;
	local X2Condition_UnitEffectsWithAbilitySource  KillZoneCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local Grimy_AbilityCost_HP						HPCost;
	local X2Effect_Blind							BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodKillZoneShot');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodKillZoneShot_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('MZBloodKillZoneReserveActionPoint');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = default.BloodKillZone_IsreactionFire;
	StandardAim.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.TargetMustBeInValidTiles = true;
	Template.AbilityTargetConditions.AddItem(AbilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//  Do not shoot targets that were already hit by this unit this turn with this ability
	KillZoneCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	KillZoneCondition.AddExcludeEffect('KillZoneTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(KillZoneCondition);
	//  Mark the target as shot by this unit so it cannot be shot again this turn
	KillZoneEffect = new class'X2Effect_Persistent';
	KillZoneEffect.EffectName = 'KillZoneTarget';
	KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	KillZoneEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(KillZoneEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.FightInTheShade_BlindTurns, default.FightInTheShade_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.FightInTheShade_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFightInTheShade');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BlindEffect);

	Template.bAllowAmmoEffects = false;			//because vamp ammo.
	Template.bAllowBonusWeaponEffects = true;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

//BEGIN AUTOGENERATED CODE: Template Overrides 'KillZoneShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'KillZoneShot'

	return Template;
}

static function X2AbilityTemplate AddBloodKillZoneShotBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KillingStroke				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodKillZoneShotBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_KillingStroke';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName= 'MZBloodKillZoneShot';
	DamageEffect.BonusMult = default.BloodKillZone_BonusMult;
	DamageEffect.BetaBonusMult = default.BloodKillZone_BonusMult;
	DamageEffect.FriendlyName = default.BloodKillZoneBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddMediShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges_GremlinHeal      Charges;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_CKHeal					HealEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZMediShot', "img:///UILibrary_PerkIcons.UIPerk_nulllance");
	Template.bDontDisplayInAbilitySummary = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_medkit";
	
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Charges = new class'X2AbilityCharges_GremlinHeal';
	Charges.InitialCharges = default.Medishot_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetConditions.Length = 0;
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.Medishot_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	Template.AbilityTargetEffects.Length = 0;

	HealEffect = new class'MZ_Effect_CKHeal';
	HealEffect.IsCritBased = false;
	Template.AddTargetEffect(HealEffect);
	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowAmmoEffects = false;

	Template.DisplayTargetHitChance = false;
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Never;

	return Template;
}

static function X2AbilityTemplate AddHammerShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZHammerShot',"img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_StunStrike");
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_stunstrike";
	//Template.ShotHUDPriority = 320;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.HammerShot_AmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HammerShot_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('KnockbackDamage');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.HammerShot_Knockback;
	KnockbackEffect.OnlyOnDeath = false; 
	Template.AddTargetEffect(KnockbackEffect);

	return Template;
}

static function X2AbilityTemplate AddSidewinder()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2Condition_UnitEffectsOnSource	JetCondition;
	local X2AbilityToHitCalc_StandardAim	HitCalc;
	local X2Effect_ApplyWeaponDamage		JetHit;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSidewinder', "img:///UILibrary_PerkIcons.UIPerk_precisionshot");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Sidewinder_Cooldown;
	Template.AbilityCooldown = Cooldown;

	HitCalc = new class'X2AbilityToHitCalc_StandardAim';
	HitCalc.bHitsAreCrits = true;
	Template.AbilityToHitCalc = HitCalc;

	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_IsAlien');

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	JetCondition = new class'X2Condition_UnitEffectsOnSource';
	JetCondition.AddRequireEffect('IRI_JetShot_Effect', 'AA_MissingRequiredEffect');
	Template.AbilityMultiTargetConditions.AddItem(JetCondition);
	
	JetHit = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	JetHit.TargetConditions.AddItem(JetCondition);
	Template.AddMultiTargetEffect(JetHit);

	return Template;
}

static function X2AbilityTemplate AddVitalsShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropCondition;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_Stunned					StunEffect;
	local MZ_Effect_NeuralFeedbackCoolPsi	PsiEffect;
	local X2Effect_PersistentStatChange		ConfuseEffect;
	local X2Effect_Burning					BurningEffect;
	local X2Condition_UnitEffectsOnSource	JetCondition;
	local X2Effect_KillUnit					OustEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZVitalsShot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodletter");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Sidewinder_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	//Vs Alien:	[Confusion]
	ConfuseEffect = class'X2StatusEffects'.static.CreateConfusedStatusEffect(default.VitalsShot_Alien_Confuse);
	ConfuseEffect.TargetConditions.AddItem(new class'MZ_Condition_IsAlien');
	Template.AddTargetEffect(ConfuseEffect);
	//Vs Advent: [bleeding]
	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.IsAdvent = true;
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.VitalsShot_Advent_BleedTurns, default.VitalsShot_Advent_BleedDamage);
	BleedingEffect.TargetConditions.AddItem(UnitPropCondition);
	Template.AddTargetEffect(BleedingEffect);
	//Vs Psionic: [Put Psi on Cooldown]
	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeNonPsionic = true;
	PsiEffect = new class'MZ_Effect_NeuralFeedbackCoolPsi';
	PsiEffect.EffectAppliedName = default.VitalsShotPsiCoolEffectName;
	PsiEffect.TargetConditions.AddItem(UnitPropCondition);
	Template.AddTargetEffect(PsiEffect);
	//Vs Robot/Turret: [Shutdown]
	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeOrganic = true;
	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.VitalsShot_Robot_Stun,100,false);
	StunEffect.TargetConditions.AddItem(UnitPropCondition);
	Template.AddTargetEffect(StunEffect);
	//Vs Undead: [Burning]
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.VitalsShot_Undead_BurnDmg, default.VitalsShot_Undead_BurnSpread);
	BurningEffect.TargetConditions.AddItem(new class'MZ_Condition_TurnUndead');
	Template.AddTargetEffect(BurningEffect);

	//During JetShot: []
	OustEffect = new class'X2Effect_KillUnit';
	JetCondition = new class'X2Condition_UnitEffectsOnSource';
	JetCondition.AddRequireEffect('IRI_JetShot_Effect', 'AA_MissingRequiredEffect');
	OustEffect.TargetConditions.AddItem(JetCondition);
	OustEffect.ApplyChanceFn = OustApplyChanceFunction;
	OustEffect.DamageTypes.AddItem('Stun');
	Template.AddTargetEffect(OustEffect);
	//Template.AddShooterEffect();

	return Template;
}
function name OustApplyChanceFunction(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	//local XComGameState_Item WeaponState;
	local int Randroll;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if (TargetUnit != none)
	{
		if( TargetUnit.IsResistanceHero() || TargetUnit.IsChosen() )
		{
			return 'AA_UnitIsImmune';
		}

		Randroll = `SYNC_RAND(100);
		if ( Randroll < ( TargetUnit.GetMaxStat(eStat_HP) - TargetUnit.GetCurrentStat(eStat_HP) ) * default.VitalsShot_MaxOustChance / TargetUnit.GetMaxStat(eStat_HP) )
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_EffectChanceFailed';
		}
	}

	return 'AA_UnitIsImmune';
}

static function X2AbilityTemplate AddSonicBoom(int BonusCharges, int BonusCooldown) {
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2Effect_PersistentStatChange		JetDisorient;
	local X2Condition_UnitEffectsOnSource	JetCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSonicBoom');

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bigbooms"; // 
	Template.ShotHUDPriority = 330;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = default.SonicBoom_Radius;
	TargetStyle.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bMultiTargetOnly = true;
	StandardMelee.BuiltInHitMod = default.SonicBoom_AimMod;
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityToHitOwnerOnMissCalc = StandardMelee;
		
	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	Template.AddShooterEffectExclusions();

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.SonicBoom_Ammo;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects
	
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect(); 
	WeaponDamageEffect.bAllowWeaponUpgrade = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	JetDisorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	JetCondition = new class'X2Condition_UnitEffectsOnSource';
	JetCondition.AddRequireEffect('IRI_JetShot_Effect', 'AA_MissingRequiredEffect');
	JetDisorient.TargetConditions.AddItem(JetCondition);
	Template.AddMultiTargetEffect(JetDisorient);

	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;	
}

static function X2AbilityTemplate AddSecretHunt()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StandardAim	HitCalc;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSecretHunt', "img:///UILibrary_DLC2Images.UIPerk_shadowfall");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SecretHunt_Cooldown;
	Template.AbilityCooldown = Cooldown;

	HitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = HitCalc;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect(); 
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.ConcealmentRule = eConceal_KillShot;
	Template.AdditionalAbilities.AddItem('MZSecretHuntConceal');

	return Template;
}
static function X2AbilityTemplate AddSecretHuntConceal()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_SecretHuntConceal          ConcealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSecretHuntConceal');
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_shadowfall";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ConcealEffect = new class'MZ_Effect_SecretHuntConceal';
	ConcealEffect.BuildPersistentEffect(1, true, false, false);
	ConcealEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(ConcealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate RunningOnEmpty()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZRunningOnEmpty', "img:///UILibrary_MZChimeraIcons.WeaponMod_AutoLoader", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZRunningOnEmptyTrigger');
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}
static function X2AbilityTemplate RunningOnEmptyTrigger()
{
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2Condition_AbilitySourceWeapon   WeaponCondition;
	local X2AbilityTrigger_EventListener	Listener;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRunningOnEmptyTrigger');
	
	Template.bDontDisplayInAbilitySummary = false;
	
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	WeaponCondition.CheckAmmo = true;
	WeaponCondition.AddAmmoCheck(0, eCheck_Exact, 0, 0);
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	
	Listener = new class'X2AbilityTrigger_EventListener';
    Listener.ListenerData.Filter = eFilter_Unit;
    Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
    Listener.ListenerData.EventFn = RunningOnEmptyEventListener;
    Listener.ListenerData.EventID = 'UnitMoveFinished';
    Listener.ListenerData.Priority = 40;    //  default Priority is 50, lowering the value so this ability triggers AFTER the move goes through
    Template.AbilityTriggers.AddItem(Listener);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.WeaponMod_AutoLoader";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = RunningOnEmpty_BuildGameState;
	Template.BuildVisualizationFn = RunningOnEmpty_BuildVisualization;

	Template.Hostility = eHostility_Neutral;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	Template.CinescriptCameraType="GenericAccentCam";

	return Template;	
}
simulated function XComGameState RunningOnEmpty_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item WeaponState, NewWeaponState;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);	
	AbilityContext = XComGameStateContext_Ability(Context);	
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.AbilityRef.ObjectID ));

	WeaponState = AbilityState.GetSourceWeapon();
	NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', WeaponState.ObjectID));

	if (NewWeaponState.Ammo < NewWeaponState.GetClipSize())
	{
		NewWeaponState.Ammo = 1;
	}

	NewGameState.AddStateObject(NewWeaponState);

	return NewGameState;	
}
simulated function RunningOnEmpty_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          ShootingUnitRef;	
	local X2Action_PlayAnimation		PlayAnimation;

	local VisualizationActionMetadata   InitData;
	local VisualizationActionMetadata   BuildData;

	local XComGameState_Ability Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	ShootingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildData = InitData;
	BuildData.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	BuildData.VisualizeActor = History.GetVisualizer(ShootingUnitRef.ObjectID);

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildData, Context));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFriendlyName, Ability.GetMyTemplate().ActivationSpeech, eColor_Good);
					
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildData, Context));
	PlayAnimation.Params.AnimName = 'HL_Reload';
	//****************************************************************************************
}
static function EventListenerReturn RunningOnEmptyEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Item            WeaponState;
   
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    SourceUnit = XComGameState_Unit(EventSource);
	WeaponState = SourceUnit.GetPrimaryWeapon();

    if (AbilityContext != none && SourceUnit != none && WeaponState != none)
	{
		if ( AbilityContext.InputContext.AbilityTemplateName == 'StandardMove' && WeaponState.Ammo == 0)
		{
			//Attempt to fire RunningOnEmpty.
			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZRunningOnEmptyTrigger', SourceUnit.GetReference());
		}
	}

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate NoMercy()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZNoMercy', "img:///UILibrary_MZChimeraIcons.Ability_TwinStrike");
	Template.AdditionalAbilities.AddItem('MZNoMercyShot');

	return Template;
}
static function X2AbilityTemplate NoMercyShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StandardAim	HitCalc;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityCost_Ammo                AmmoCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZNoMercyShot', "img:///UILibrary_MZChimeraIcons.Ability_TwinStrike");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityCosts.length = 0;
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AbilityTriggers.length = 0;
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = NoMercyEventListener;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	HitCalc = new class'X2AbilityToHitCalc_StandardAim';
	HitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = HitCalc;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect(); 
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bShowActivation = true;
	Template.ConcealmentRule = eConceal_KillShot;

	return Template;
}
static function EventListenerReturn NoMercyEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Item            WeaponState;
	local X2AbilityToHitCalc_StandardAim	HitCalc;
	local GameRulesCache_VisibilityInfo VisInfo;
   
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
    SourceUnit = XComGameState_Unit(EventSource);
    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
 
    if (AbilityContext != none && AbilityState != none && WeaponState != none && SourceUnit != none && TargetUnit != none)
    {   //  if this is an offensive ability from a primary weapon, and the enemy is still alive
        if ( AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive() && X2WeaponTemplate(WeaponState.GetMyTemplate()).InventorySlot == eInvSlot_PrimaryWeapon)
        {
			HitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
			// if the attack can benefit from flanking
			if (  HitCalc != none && HitCalc.bIndirectFire != true && HitCalc.bMeleeAttack != true && HitCalc.bIgnoreCoverBonus != true )
			{
				//if it is a flank attack
				if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
				{
					if(SourceUnit.CanFlank() && TargetUnit.CanTakeCover() && VisInfo.TargetCover == CT_None)
					{
						//Attempt to fire No Mercy.
						class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZNoMercyShot', AbilityContext.InputContext.PrimaryTarget);
					}
				}
			}
		}
    }
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate BloodSpear()
{
	local X2AbilityTemplate					Template;
	local Grimy_AbilityCost_HP				HPCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local MZ_Damage_AddElemental			WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBloodSpear', "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance");
	Template.ShotHUDPriority = 380;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	ToHitCalc.bIgnoreCoverBonus = true;
	ToHitCalc.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	//In a line! Zap!
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_Line';
	Template.TargetingMethod = class'X2TargetingMethod_Line';

	//have to block vamp ammo.
	Template.bAllowAmmoEffects = false; //

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodSpear_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.BloodSpear_BonusDamage;
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate BurialShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown					Cooldown;
	local MZ_Cost_AP_FreeIfLethal			ActionPointsCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Effect_Shredder				    WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBurialShot', "img:///UILibrary_PerkIcons.UIPerk_reaper");
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityCosts.Length = 0;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointsCost = new class'MZ_Cost_AP_FreeIfLethal';
	ActionPointsCost.bAddWeaponTypicalCost = true;
	ActionPointsCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointsCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BurialShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'X2Effect_Shredder';
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	
	return Template;
}

static function X2AbilityTemplate BulletRave()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2AbilityCost_ActionPoints		ActionPointsCost;
	local X2AbilityCost_Ammo				AmmoCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBulletRave', "img:///UILibrary_MZChimeraIcons.Ability_PinDown");
	Template.ShotHUDPriority = 330;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.FinalMultiplier = default.BulletRave_FinalAimMod;
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityToHitOwnerOnMissCalc = StandardMelee;

	Template.AbilityCosts.Length = 0;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointsCost = new class'X2AbilityCost_ActionPoints';
	ActionPointsCost.bAddWeaponTypicalCost = true;
	ActionPointsCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointsCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BulletRave_Cooldown;
	Template.AbilityCooldown = Cooldown;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.BonusDamageScalar = default.BulletRave_DamageScalar;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bNoDoubleGrip = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate BlazingSpear()
{
	local X2AbilityTemplate					Template;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line			TargetStyle;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBlazingSpear', "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance");
	Template.bDontDisplayInAbilitySummary = false;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = StandardMelee;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlazingSpear_Cooldown;
	Template.AbilityCooldown = Cooldown;

	if ( default.BlazingSpear_Charges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.BlazingSpear_Charges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Line';
	TargetStyle.bSightRangeLimited = true;				//seems to be possible to make it draw past your sight range, but doesn't actually target them?
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.TargetingMethod = class'X2TargetingMethod_Line';

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = 1.1f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1));

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	return Template;
}

static function X2AbilityTemplate PlagueSpear()
{
	local X2AbilityTemplate					Template;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line			TargetStyle;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZPlagueSpear', "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance");
	Template.bDontDisplayInAbilitySummary = false;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = StandardMelee;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PlagueSpear_Cooldown;
	Template.AbilityCooldown = Cooldown;

	if ( default.PlagueSpear_Charges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.PlagueSpear_Charges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Line';
	TargetStyle.bSightRangeLimited = true;				//seems to be possible to make it draw past your sight range, but doesn't actually target them?
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.TargetingMethod = class'X2TargetingMethod_Line';

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Poison';
	WeaponDamageEffect.BonusDamageScalar = default.PlagueSpear_DamageMult;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('poison');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect() );

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	return Template;
}

static function X2AbilityTemplate BlisterShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBlisterShot',"img:///UILibrary_PerkIcons.UIPerk_bulletshred");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.BlisterShot_AmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlisterShot_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = 1.0f;
	WeaponDamageEffect.AddRupture = default.BlisterShot_Rupture;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1));

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	return Template;
}

static function X2AbilityTemplate Ventilate()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZVentilate',"img:///UILibrary_MZChimeraIcons.Ability_Ventilate");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.Ventilate_AmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Ventilate_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// World Damage
	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 100;
	WorldDamage.bApplyOnHit = false;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = true;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.bAllowDestructionOfDamageCauseCover = true;
	Template.AddTargetEffect(WorldDamage);
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	return Template;
}

static function X2AbilityTemplate SuperShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Damage_UseAllAmmo			WeaponDamageEffect;
	
	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSuperShot',"img:///UILibrary_MZChimeraIcons.Ability_SprayAndPray");
	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;	//minimum to provide any bonus.
	AmmoCost.bConsumeAllAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SuperShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_UseAllAmmo';
	WeaponDamageEffect.bPerRoundDamage = true;
	WeaponDamageEffect.Scalar = default.SuperShot_PerRoundDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate SuperShredShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Damage_UseAllAmmo			WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSuperShredShot',"img:///UILibrary_PerkIcons.UIPerk_shredder");
	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;	//minimum to provide any bonus.
	AmmoCost.bConsumeAllAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SuperShred_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_UseAllAmmo';
	WeaponDamageEffect.bPerRoundShred = true;
	WeaponDamageEffect.Scalar = default.SuperShred_PerRoundShred;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate SurefireShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSurefireShot',"img:///UILibrary_MZChimeraIcons.WeaponMod_Scope");
	Template.ShotHUDPriority = 325;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.SurefireShot_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = 1.0f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1));

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	return Template;
}

static function X2AbilityTemplate FondFarewell() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_FondFarewell				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFondFarewell');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_FondFarewell";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_FondFarewell';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}