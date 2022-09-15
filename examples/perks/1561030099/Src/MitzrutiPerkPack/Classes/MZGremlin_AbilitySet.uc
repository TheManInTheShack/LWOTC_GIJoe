class MZGremlin_AbilitySet extends X2Ability_SpecialistAbilitySet config(MZPerkPack);

var const config int SHOCKTHERAPY_STUN_LEVEL, SHOCKTHERAPY_STUN_CHANCE;
var config int ChainingJolt_Cooldown, ChainingJolt_MaxChain, ChainingJolt_ChainRange, StormGenerator_BonusRange, VoltaicArc_ReactionRange, StormGenerator_ReactionRangeBonus, HighVoltage_DmgIncrement, ChainDischarge_Cooldown;
var config bool HighVoltage_MaxBonusToAll;
var config int GremlinStasis_Cooldown, HackRobot_Cooldown, HackRobot_Control_Duration, ArmourSystem_Armour, HealingAid_PerUseHP, HealingAid_Spread, CombatScanner_Duration, CombatScanner_Cooldown, MassAidProtocol_Cooldown;
var config float HealingAid_HackScalar, ChainDischarge_Radius, StormGenerator_DischargeRadius, CombatScanner_Radius, MassAidProtocol_Radius, ImprovedScanner_MassAidRadius, ImprovedScanner_CombatScanRadius, ImprovedScanner_CritScalar;
var config int FlameProtocol_Cooldown, ToxicProtocol_Cooldown, AcidProtocol_Cooldown, NapalmProtocol_Charges, SabotageProtocol_Charges, HostageProtocol_Charges, HOSTAGE_DURATION;
var config float NapalmProtocol_Radius;

var config array<name> HighVoltageChainAbilities;

var localized string ArmorSystemEffectName, ArmorSystemEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(ChainingJolt());
	Templates.AddItem( PurePassive('MZShockTherapy', "img:///UILibrary_MZChimeraIcons.Ability_ChainingJolt", false) );
	Templates.AddItem( PurePassive('MZStormGenerator', "img:///UILibrary_MZChimeraIcons.Ability_StormGenerator", false) );
	Templates.AddItem(VoltaicArc());
	/*>>*/Templates.AddItem(VoltaicArcAttack());
	Templates.AddItem(HighVoltage());
	Templates.AddItem(ChainDischarge());
	Templates.AddItem(Stasis('MZGremlinStasis'));
	Templates.AddItem(Sustain());
	/*>>*/Templates.AddItem(SustainTriggered());
	Templates.AddItem(RobotInsanity());
	Templates.AddItem( PurePassive('MZArmourSystem', "img:///UILibrary_MZChimeraIcons.Ability_ArmorSystem", false) );
	Templates.AddItem( PurePassive('MZAidProtocolHeal', "img:///UILibrary_MZChimeraIcons.Ability_Safeguard", false) );
	Templates.AddItem( CombatScanner() );
	Templates.AddItem( MassAidProtocol() );
	Templates.AddItem( PurePassive('MZImprovedScanner', "img:///UILibrary_MZChimeraIcons.Ability_ThreatRecognition", false) );

	Templates.AddItem(FlameProtocol());
	Templates.AddItem(AcidProtocol());
	Templates.AddItem(ToxicProtocol());
	Templates.AddItem(SabotageProtocol());
	Templates.AddItem(HostageProtocol());

	Templates.AddItem(NapalmProtocol());

	return Templates;
}

static function AddBonusEffectsToGremlinAbilities()
{
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	//local name									AbilityName;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local MZ_Effect_FixArmour					FixArmourEffect;
	local MZ_Effect_PsiHeal						MedikitHeal;
	local X2Effect_RemoveEffects				RemoveEffects;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	AbilityTemplate = AbilityManager.FindAbilityTemplate('AidProtocol');
	if ( AbilityTemplate != none )
	{
		//Armour System grants temporary armour and mends shredded armour
		StatChangeEffect = new class'X2Effect_PersistentStatChange';
		StatChangeEffect.EffectName = 'MZArmourSystem';
		StatChangeEffect.DuplicateResponse = eDupe_Ignore;            //  Gremlin effects should always be setup such that a target already under the effect is invalid.
		StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
		StatChangeEffect.bRemoveWhenTargetDies = true;
		StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.ArmorSystemEffectName, default.ArmorSystemEffectDesc, "img:///UILibrary_MZChimeraIcons.Ability_ArmorSystem", true);
		StatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.ArmourSystem_Armour);

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZArmourSystem');
		StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
		AbilityTemplate.AddTargetEffect(StatChangeEffect);

		FixArmourEffect = new class'MZ_Effect_FixArmour';
		FixArmourEffect.TargetConditions.AddItem(AbilityCondition);
		AbilityTemplate.AddTargetEffect(FixArmourEffect);

		//Healing Aid heals based on hack and cures elemental effects
		MedikitHeal = new class'MZ_Effect_PsiHeal';
		MedikitHeal.PerUseHP = default.HealingAid_PerUseHP;
		MedikitHeal.HealSpread = default.HealingAid_Spread;
		MedikitHeal.UseStat = eStat_Hacking;
		MedikitHeal.PsiFactor = default.HealingAid_HackScalar;

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAidProtocolHeal');
		MedikitHeal.TargetConditions.AddItem(AbilityCondition);
		AbilityTemplate.AddTargetEffect(MedikitHeal);

		RemoveEffects = class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType();
		RemoveEffects.TargetConditions.AddItem(AbilityCondition);
		AbilityTemplate.AddTargetEffect(RemoveEffects);
	}
}

function name RollAndCheckWeaponImmunities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState == none)
		{ 
			return  'AA_UnitIsImmune';	
		}

		if (class'X2Effect_DisableWeapon'.default.WeaponsImmuneToDisable.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE)
		{
			return 'AA_UnitIsImmune';
		}

		return 'AA_Success';
	}

	return 'AA_Failure';
}

static function X2AbilityTemplate CreateBaseSingleAttackProtocol(name TemplateName, string IconImage="img:///UILibrary_PerkIcons.UIPerk_combatprotocol")
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_Visibility        VisCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);	
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.ActivationSpeech = 'CombatProtocol';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Insanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Insanity'
	
	return Template;
}

static function X2AbilityTemplate ChainingJolt()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCooldown                     Cooldown;
	local X2Effect_ApplyWeaponDamage			DamageEffect;
	local X2Condition_UnitProperty				DamageCondition;
	local X2Condition_Visibility                VisCondition;
	local X2Condition_AbilityProperty			ShockTherapyCondition;
	local X2Effect_Persistent					DisorientedEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Effect_SetUnitValue					UnitValueEffect;
	local X2Condition_UnitValue					UnitValueCondition;
	local X2Effect_DisableWeapon				DisableEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZChainingJolt');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ChainingJolt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	//Template.bFeatureInCharacterUnlock = true;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ChainingJolt_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	// Apply the damage to the triggering enemy, and subsequent ones
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZChainingJolt';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeRobotic = true;
	DamageCondition.ExcludeFriendlyToSource = true;
	DamageCondition.ExcludeHostileToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZChainingJolt_Robo';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeOrganic = true;
	DamageCondition.ExcludeFriendlyToSource = true;
	DamageCondition.ExcludeHostileToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');
	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisableEffect);
	Template.AddMultiTargetEffect(DisableEffect);

	ShockTherapyCondition = new class'X2Condition_AbilityProperty';
	ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

	// Stun effect
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = Stun_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);
	Template.AddMultiTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.SHOCKTHERAPY_STUN_LEVEL, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	// Disorient effect
	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	// remove the result value, so other Shock Therapy abilities will roll correctly.
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 0;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(UnitValueEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Volt';

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = ChainingJolt_BuildGameState;
	Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	//Template.CinescriptCameraType = "Specialist_CombatProtocol";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//Template.ActivationSpeech = 'AbilCombatProtocol';

	return Template;
}

function name Stun_ApplyChanceCheck(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	if(`SYNC_RAND(100) <= default.SHOCKTHERAPY_STUN_CHANCE)
	{
		return 'AA_Success';
	}

	return 'AA_EffectChanceFailed';
}

static function XComGameState ChainingJolt_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	AbilityContext;
	local int							i;
	local array<X2Condition>			TargetConditions;
	local X2Condition_UnitEffects       EffectsCondition;
	local MZ_Condition_VariableRange	RangeCondition;
	local MZ_Condition_ChainLogic		ChainCondition;
	local array<StateObjectReference>	VisibleTargets;
	local StateObjectReference			TargetRef, ActiveUnit;
	
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(Context);
	ActiveUnit = AbilityContext.InputContext.PrimaryTarget;

	ChainCondition = new class'MZ_Condition_ChainLogic';
	ChainCondition.Caster = XComGameState_Unit(History.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID) );
	TargetConditions.AddItem(ChainCondition);

	TargetConditions.AddItem(default.GameplayVisibilityCondition);

	If ( XComGameState_Unit(History.GetGameStateForObjectID( AbilityContext.InputContext.SourceObject.ObjectID)).HasSoldierAbility('MZStormGenerator' ) )
	{
		RangeCondition = new class'MZ_Condition_VariableRange';
		if (AbilityContext.InputContext.AbilityTemplateName == 'MZVoltaicArcAttack')
		{
			RangeCondition.Range = default.ChainingJolt_ChainRange + default.StormGenerator_ReactionRangeBonus;
		}
		else
		{
			RangeCondition.Range = default.ChainingJolt_ChainRange + default.StormGenerator_BonusRange;
		}
		TargetConditions.AddItem(RangeCondition);
	}
	else
	{
		RangeCondition = new class'MZ_Condition_VariableRange';
		RangeCondition.Range = default.ChainingJolt_ChainRange;
		TargetConditions.AddItem(RangeCondition);
	}

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('MindControl', 'AA_UnitIsImmune');
	EffectsCondition.AddExcludeEffect('MimicBeaconEffect', 'AA_UnitIsImmune');
	TargetConditions.AddItem(EffectsCondition);
	
	//Rebuild the multitarget list
	AbilityContext.InputContext.MultiTargets.Length = 0;

	i=0;
	while(i < default.ChainingJolt_MaxChain)
	{
		class'MZ_Helper_Tactical'.static.GetAllVisibleUnitsForUnit(ActiveUnit.ObjectID,VisibleTargets,TargetConditions);
		
		if ( VisibleTargets.Length == 0 ) { break; }

		foreach VisibleTargets(TargetRef)
		{
			if ( TargetRef != AbilityContext.InputContext.PrimaryTarget && AbilityContext.InputContext.MultiTargets.Find('ObjectID', TargetRef.ObjectID) == INDEX_NONE)
			{
				AbilityContext.InputContext.MultiTargets.AddItem(TargetRef );
				ActiveUnit = TargetRef;
				break;
			}
		}

		if ( AbilityContext.InputContext.MultiTargets.Length <= i ) { break; }
		
		i++;
	}

	//pass off the new context to the normal gremlin game state function
	return class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState(Context);
}

simulated function ChainingJolt_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   ActionMetadata;
	local X2Action_CameraLookAt			CameraAction;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local Actor							TargetVisualizer;
	local XComGameState_Unit			AttachedUnitState;
	local XComGameState_Unit			TargetUnitState;
	local array<PathPoint>				Path;
	local TTile                         TargetTile;
	local TTile							StartTile;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_CameraLookAt			TargetCameraAction;
	local X2Action_AbilityPerkStart		PerkStartAction;
	local int							i, j;
	local X2VisualizerInterface			TargetVisualizerInterface;
	local X2Action_WaitForAbilityEffect DelayAction;
	local int							EffectIndex;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	TargetUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID));
	AttachedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.AttachedUnitRef.ObjectID));

	if (GremlinUnitState == none)
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
		return;
	}

	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
	CameraAction.BlockUntilActorOnScreen = true;

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AbilityTemplate.ActivationSpeech != '')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}

	// make sure he waits for the gremlin to come back, so that the cinescript camera doesn't pop until then
	X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded)).SetCustomTimeOutSeconds(30);

	//Configure the visualization track for the gremlin
	//****************************************************************************************

	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
	TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
	{
		// Given the target location, we want to generate the movement data.  

		//Handle tall units.
		TargetTile = TargetUnitState.GetDesiredTileForAttachedCosmeticUnit();
		StartTile = AttachedUnitState.GetDesiredTileForAttachedCosmeticUnit();

		class'X2PathSolver'.static.BuildPath(GremlinUnitState, StartTile, TargetTile, PathData.MovementTiles);
		class'X2PathSolver'.static.GetPathPointsFromPath(GremlinUnitState, PathData.MovementTiles, Path);
		class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);

		PathData.MovingUnitRef = GremlinUnitState.GetReference();
		PathData.MovementData = Path;
		Context.InputContext.MovementPaths.AddItem(PathData);

		class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID, PathData.MovementTiles, ResultData.PathTileData);
		Context.ResultContext.PathResults.AddItem(ResultData);

		class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);

		if (TargetVisualizer != none)
		{
			TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			TargetCameraAction.LookAtActor = TargetVisualizer;
			TargetCameraAction.BlockUntilActorOnScreen = true;
			TargetCameraAction.LookAtDuration = 10.0f;		// longer than we need - camera will be removed by tag below
			TargetCameraAction.CameraTag = 'TargetFocusCamera';
			TargetCameraAction.bRemoveTaggedCamera = false;
		}
	}

	PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PerkStartAction.NotifyTargetTracks = true;

	class'MZ_Action_ChainJolt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context);

	//****************************************************************************************

	//Configure the visualization track for the target(s)
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = TargetVisualizer;

	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context));
	DelayAction.ChangeTimeoutLength(default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if (TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context);
	
		for (j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}
	
		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	if (TargetCameraAction != none)
	{
		TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TargetCameraAction.CameraTag = 'TargetFocusCamera';
		TargetCameraAction.bRemoveTaggedCamera = true;
	}
}

static function EventListenerReturn TakeInitiativeListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit;
	local int i;
	local XComGameState_Ability AbilityState;
	local GameRulesCache_Unit UnitCache;

	//lifted from Iridar's akimbo class. you can tell because of the function name.
	//thanks to Robojumper for figuring out how to get this working

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(CallbackData);	//this is how we get the Ability State for the ability we want to re-trigger. If we used EventData, we would get the ability that cause this ability to trigger instead.
	//if(default.ENABLE_LOGGING) `Log("IRIDAR Trying to retrigger ability: " @ AbilityState.GetMyTemplateName(),, 'AkimboClass');
	
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		if (`TACTICALRULES.GetGameRulesCache_Unit(SourceUnit.GetReference(), UnitCache))	//we get UnitCache for the soldier that triggered this ability
		{
			for (i = 0; i < UnitCache.AvailableActions.Length; ++i)	//then in all actions available to him
			{

				if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == AbilityState.ObjectID)	//we find our ability
				{
					if (UnitCache.AvailableActions[i].AvailableCode == 'AA_Success')	//and trigger it on the first available target
					{
						class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], `SYNC_RAND_STATIC(UnitCache.AvailableActions[i].AvailableTargets.Length));
						break;
					}
					break;
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function X2AbilityTemplate VoltaicArc()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('MZVoltaicArc', "img:///UILibrary_MZChimeraIcons.Ability_VoltaicArc", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZVoltaicArcAttack');

	return Template;
}
static function X2AbilityTemplate VoltaicArcAttack()
{
	local X2AbilityTemplate Template;
	local X2AbilityToHitCalc_StandardAim			ToHitCalc;
	local X2AbilityTrigger_EventListener			Trigger;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Effect_Persistent						VoltaicArcTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource	VoltaicArcTargetCondition;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2Condition_UnitProperty      DamageCondition;
	local X2Condition_AbilityProperty				ShockTherapyCondition;
	local X2Effect_Persistent						DisorientedEffect;
	local X2Effect_Stunned							StunnedEffect;
	local X2Condition_UnitProperty					UnitPropertyCondition;
	local X2Effect_SetUnitValue						UnitValueEffect;
	local X2Condition_UnitValue						UnitValueCondition;
	local MZ_Condition_VariableRange				RangeCondition;

	// Ability boilerplate
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZVoltaicArcAttack');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_VoltaicArc";
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bStationaryWeapon = true;
	Template.bDontDisplayInAbilitySummary = true;

	// Basically a melee attack
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bReactionFire = true;
	ToHitCalc.bGuaranteedHit = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);

	// Trigger on operator movement end
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'UnitMoveFinished';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = TakeInitiativeListener;
	Template.AbilityTriggers.AddItem(Trigger);

	// Target conditions for overwatch
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//here's to prevent cross-map zappage
	RangeCondition = new class'MZ_Condition_VariableRange';
	RangeCondition.Range = default.VoltaicArc_ReactionRange;
	RangeCondition.AddBonusRange('MZStormGenerator', default.StormGenerator_ReactionRangeBonus);
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	// Be alive to do this
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Apply the damage to the triggering enemy, and subsequent ones
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZVoltaicArc';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeRobotic = true;
	DamageCondition.ExcludeFriendlyToSource = true;
	DamageCondition.ExcludeHostileToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZVoltaicArc_Robo';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeOrganic = true;
	DamageCondition.ExcludeFriendlyToSource = true;
	DamageCondition.ExcludeHostileToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	ShockTherapyCondition = new class'X2Condition_AbilityProperty';
	ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

	// Stun effect
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = Stun_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);
	Template.AddMultiTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.SHOCKTHERAPY_STUN_LEVEL, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	// Disorient effect
	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	// remove the result value, so other Shock Therapy abilities will roll correctly.
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 0;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(UnitValueEffect);
	
	Template.BuildNewGameStateFn = ChainingJolt_BuildGameState;
	Template.BuildVisualizationFn = VoltaicArc_BuildVisualization;
	
	// Dont firestart/proc turn, just do it during the fire
	Template.bSkipExitCoverWhenFiring = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	//Prevent repeatedly hammering on a unit with Voltaic Arc triggers.
	//(This effect does nothing, but enables many-to-many marking of which Bladestorm attacks have already occurred each turn.)
	VoltaicArcTargetEffect = new class'X2Effect_Persistent';
	VoltaicArcTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	VoltaicArcTargetEffect.EffectName = 'MZVoltaicArcTarget';
	VoltaicArcTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(VoltaicArcTargetEffect);
	
	VoltaicArcTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	VoltaicArcTargetCondition.AddExcludeEffect('MZVoltaicArcTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(VoltaicArcTargetCondition);
	
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

simulated function VoltaicArc_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   ActionMetadata;
	local Actor							TargetVisualizer;
	local XComGameState_Unit			AttachedUnitState;
	local XComGameState_Unit			TargetUnitState;
	local X2Action_CameraLookAt			TargetCameraAction;
	local X2Action_AbilityPerkStart		PerkStartAction;
	local int							i, j;
	local X2VisualizerInterface			TargetVisualizerInterface;
	local X2Action_WaitForAbilityEffect DelayAction;
	local int EffectIndex;
	//local MZ_Action_ChainJolt ChainingJoltAction;

	History = `XCOMHISTORY;

		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	TargetUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID));
	AttachedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.AttachedUnitRef.ObjectID));

	if (GremlinUnitState == none)
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
		return;
	}

	//Configure the visualization track for the gremlin
	//****************************************************************************************

	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
	TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
	{
		if (TargetVisualizer != none)
		{
			TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			TargetCameraAction.LookAtActor = TargetVisualizer;
			TargetCameraAction.BlockUntilActorOnScreen = true;
			TargetCameraAction.LookAtDuration = 10.0f;		// longer than we need - camera will be removed by tag below
			TargetCameraAction.CameraTag = 'TargetFocusCamera';
			TargetCameraAction.bRemoveTaggedCamera = false;
		}
	}

	PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PerkStartAction.NotifyTargetTracks = true;

	//ChainingJoltAction = MZ_Action_ChainJolt(class'MZ_Action_ChainJolt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	//ChainingJoltAction.AnimName = 'NO_VoltaicArc';
	class'MZ_Action_ChainJolt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context);

	//****************************************************************************************

	//Configure the visualization track for the target(s)
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = TargetVisualizer;

	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context));
	DelayAction.ChangeTimeoutLength(default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if (TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context);

		for (j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	if (TargetCameraAction != none)
	{
		TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TargetCameraAction.CameraTag = 'TargetFocusCamera';
		TargetCameraAction.bRemoveTaggedCamera = true;
	}
}

static function X2AbilityTemplate HighVoltage()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_DamageByTargetCount         Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHighVoltage');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_HighVoltage";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_DamageByTargetCount';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.DMG_INCREMENT = default.HighVoltage_DmgIncrement;
	Effect.MaxBonusToAllTargets = default.HighVoltage_MaxBonusToAll;
	Effect.AbilityNames = default.HighVoltageChainAbilities;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2DataTemplate ChainDischarge()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2Condition_UnitProperty      DamageCondition;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCooldown				Cooldown;
	local X2Condition_AbilityProperty			ShockTherapyCondition;
	local X2Effect_Persistent					DisorientedEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Effect_SetUnitValue					UnitValueEffect;
	local X2Condition_UnitValue					UnitValueCondition;
	local X2Effect_DisableWeapon				DisableEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZChainDischarge');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ChainDischarge_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ChainDischarge_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.AddAbilityBonusRadius('MZStormGenerator', default.StormGenerator_DischargeRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZChainDischarge';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeRobotic = true;
	DamageCondition.ExcludeFriendlyToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZChainDischarge_Robo';
	DamageEffect.bIgnoreArmor = true;
	DamageCondition = new class'X2Condition_UnitProperty';
	DamageCondition.ExcludeOrganic = true;
	DamageCondition.ExcludeFriendlyToSource = false;
	DamageEffect.TargetConditions.AddItem(DamageCondition);
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	//Sabotage~
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');
	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisableEffect);
	Template.AddMultiTargetEffect(DisableEffect);

	ShockTherapyCondition = new class'X2Condition_AbilityProperty';
	ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

	// Stun effect
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChanceFn = Stun_ApplyChanceCheck;
	Template.AddTargetEffect(UnitValueEffect);
	Template.AddMultiTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.SHOCKTHERAPY_STUN_LEVEL, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	// Disorient effect
	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	// remove the result value, so other Shock Therapy abilities will roll correctly.
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 0;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	/*
	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = CapacitorDischarge_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	*/

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = ChainDischarge_BuildGameState;
	Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_CapacitorDischarge";
	Template.Hostility = eHostility_Offensive;
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	
	Template.ActivationSpeech = 'CapacitorDischarge';
	Template.CustomSelfFireAnim = 'NO_CapacitorDischargeA';
	Template.DamagePreviewFn = CapacitorDischargeDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'

	return Template;
}

static function XComGameState ChainDischarge_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateContext_Ability	AbilityContext;

	AbilityContext = XComGameStateContext_Ability(Context);

	AbilityContext.InputContext.PrimaryTarget = AbilityContext.InputContext.MultiTargets[0];
	AbilityContext.InputContext.MultiTargets.RemoveItem(AbilityContext.InputContext.PrimaryTarget);

	//pass off the new context to the normal gremlin game state function
	return class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState(Context);
}

static function X2DataTemplate Stasis( Name TemplateName='MZGremlinStasis' )
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_RemoveEffects            RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stasis";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.GremlinStasis_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty); // new class'X2Condition_StasisTarget');
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability_Viper'.default.BindSustainedEffectName);
	Template.AddTargetEffect(RemoveEffects);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddTargetEffect(StasisEffect);

	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
		
	Template.bShowActivation = true;
	Template.CustomSelfFireAnim = 'NO_DefenseProtocol';
	Template.ActivationSpeech = 'NullShield';

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	//Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Stasis'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Stasis'

	return Template;
}

static function X2AbilityTemplate Sustain()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Sustain              SustainEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGremlinSustain');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Sustain";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SustainEffect = new class'X2Effect_Sustain';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SustainEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.AdditionalAbilities.AddItem('MZGremlinSustainTriggered');

	return Template;
}
static function X2DataTemplate SustainTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityTrigger_EventListener    EventTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGremlinSustainTriggered');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Sustain";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//	check that the unit is still alive.
	//	it's possible that multiple event listeners responded to the same event, and some of those other listeners
	//	went ahead and killed the unit before we got to trigger sustain.
	//	it would look weird to do the sustain visualization and then have the unit die, so just don't trigger sustain.
	//	e.g. a unit with a homing mine on it that takes a kill shot wants to have the death stopped, but the
	//	homing mine explosion can trigger before the sustain trigger goes off, killing the unit before it would be sustained
	//	and making things look really weird. now the unit will just die without "sustaining" the corpse.
	//	-jbouscher
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	//StasisEffect.StunStartAnim = 'HL_PsiSustainStart';
	// Use this to set up the special sustain anim.
	StasisEffect.StunStartAnim='HL_SustainStart';
	StasisEffect.StunStopAnim='HL_SustainStop';
	StasisEffect.CustomIdleOverrideAnim='HL_SustainLoop';
	//
	StasisEffect.bSkipFlyover = true;
	Template.AddTargetEffect(StasisEffect);

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'SustainTriggered';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	//EventTrigger.ListenerData.Priority = 100; //High priority to help it trigger more reliably. Not sure how often this will matter tho.
	Template.AbilityTriggers.AddItem(EventTrigger);

	Template.PostActivationEvents.AddItem('SustainSuccess');
		
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate RobotInsanity()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2Effect_Stunned				StunEffect;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_RemoveEffects        MindControlRemoveEffects;
	local X2AbilityCooldown             Cooldown;
	local MZ_Aim_GremlinHackStatCheck	StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGremlinInsanity');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HackRobot_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'MZ_Aim_GremlinHackStatCheck';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeTurret = false;
	UnitPropertyCondition.ExcludeLargeUnits = false;
	UnitPropertyCondition.ExcludeOrganic = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  Single action stun for 1 unblocked hack hit
	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	StunEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	StunEffect.MinStatContestResult = 1;
	StunEffect.MaxStatContestResult = 1;     
	StunEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(StunEffect);

	//  Full turn shutdown for 2-3 unblocked hack hits
	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	StunEffect.MinStatContestResult = 2;
	StunEffect.MaxStatContestResult = 3;     
	StunEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(StunEffect);
	
	//  Mind control effect for 4+ unblocked hack hits
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.HackRobot_Control_Duration, false, false);
	MindControlEffect.MinStatContestResult = 4;
	MindControlEffect.MaxStatContestResult = 0;
	MindControlEffect.DamageTypes.Length = 0;
	MindControlEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(MindControlEffect);

	MindControlRemoveEffects = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MindControlRemoveEffects.MinStatContestResult = 4;
	MindControlRemoveEffects.MaxStatContestResult = 0;
	MindControlRemoveEffects.DamageTypes.Length = 0;
	MindControlRemoveEffects.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(MindControlRemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_HaywireProtocol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.ActivationSpeech = 'HaywireProtocol';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Insanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Insanity'
	
	return Template;
}

static function X2DataTemplate CombatScanner()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_PersistentSquadViewer    ViewerEffect;
	local X2Effect_ScanningProtocol     ScanningEffect;
	local X2Condition_UnitProperty      CivilianProperty;
	local MZ_Effect_StatBasedToHitTarget	CritEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCombatScanner');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CombatScanner_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.CombatScanner_Radius;
	RadiusMultiTarget.AddAbilityBonusRadius('MZImprovedScanner', default.ImprovedScanner_CombatScanRadius);
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	ScanningEffect.TargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	CivilianProperty = new class'X2Condition_UnitProperty';
	CivilianProperty.ExcludeNonCivilian = true;
	CivilianProperty.ExcludeHostileToSource = false;
	CivilianProperty.ExcludeFriendlyToSource = false;
	ScanningEffect.TargetConditions.AddItem(CivilianProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	Template.AddMultiTargetEffect(HoloTargetEffect());

	CritEffect = new class'MZ_Effect_StatBasedToHitTarget';
	CritEffect.UseStat = eStat_Hacking;
	CritEffect.CritMod = default.ImprovedScanner_CritScalar;
	CritEffect.TargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAidProtocolHeal');
	CritEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(CritEffect);

	ViewerEffect = new class'X2Effect_PersistentSquadViewer';
	ViewerEffect.BuildPersistentEffect(default.CombatScanner_Duration, false, false, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(ViewerEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = CapacitorDischarge_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_CombatScanners";
	Template.Hostility = eHostility_Offensive;
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	
	Template.ActivationSpeech = 'ScanningProtocol';
	Template.CustomSelfFireAnim = 'NO_SensorSweepA';
	Template.Hostility = eHostility_Neutral;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'

	return Template;
}

static function X2Effect_HoloTarget HoloTargetEffect()
{
	local X2Effect_HoloTarget           Effect;
	local X2AbilityTag                  AbilityTag;

	//basic holotargeting effect without the requirement of the holotargeting ability.
	Effect = new class'X2Effect_HoloTarget';
	Effect.HitMod = class'X2Ability_GrenadierAbilitySet'.default.HOLOTARGET_BONUS;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.TargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
	AbilityTag.ParseObj = Effect;

	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Ability_GrenadierAbilitySet'.default.HoloTargetEffectName, `XEXPAND.ExpandString(class'X2Ability_GrenadierAbilitySet'.default.HoloTargetEffectDesc), "img:///UILibrary_PerkIcons.UIPerk_holotargeting", true);

	// bsg-dforrest (7.27.17): need to clear out ParseObject
	AbilityTag.ParseObj = none;
	// bsg-dforrest (7.27.17): end

	return Effect;
}

static function X2DataTemplate MassAidProtocol()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitEffects               EffectsCondition;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local MZ_Effect_FixArmour					FixArmourEffect;
	local MZ_Effect_PsiHeal						MedikitHeal;
	local X2Effect_RemoveEffects				RemoveEffects;
	local X2Effect_ThreatAssessment             CoveringFireEffect;
	local X2Condition_UnitProperty              UnitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMassAidProtocol');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MassAidProtocol_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('AidProtocol', 'AA_UnitIsImmune');
	EffectsCondition.AddExcludeEffect('MimicBeaconEffect', 'AA_UnitIsImmune');
	Template.AbilityMultiTargetConditions.AddItem(EffectsCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MassAidProtocol_Radius;
	RadiusMultiTarget.AddAbilityBonusRadius('MZImprovedScanner', default.ImprovedScanner_MassAidRadius);
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//Regular Defense effect
	Template.AddMultiTargetEffect(AidProtocolEffect());

	//  add covering fire effect if the soldier has threat assessment - this regular shot applies to all non-sharpshooters
	CoveringFireEffect = new class'X2Effect_ThreatAssessment';
	CoveringFireEffect.EffectName = 'ThreatAssessment_CF';
	CoveringFireEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
	CoveringFireEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('ThreatAssessment');
	CoveringFireEffect.TargetConditions.AddItem(AbilityCondition);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeSoldierClasses.AddItem('Sharpshooter');
	CoveringFireEffect.TargetConditions.AddItem(UnitCondition);
	Template.AddMultiTargetEffect(CoveringFireEffect);

	//  add covering fire effect if the soldier has threat assessment - this pistol shot only applies to sharpshooters
	CoveringFireEffect = new class'X2Effect_ThreatAssessment';
	CoveringFireEffect.EffectName = 'PistolThreatAssessment';
	CoveringFireEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	CoveringFireEffect.AbilityToActivate = 'PistolReturnFire';
	CoveringFireEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('ThreatAssessment');
	CoveringFireEffect.TargetConditions.AddItem(AbilityCondition);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.RequireSoldierClasses.AddItem('Sharpshooter');
	CoveringFireEffect.TargetConditions.AddItem(UnitCondition);
	Template.AddMultiTargetEffect(CoveringFireEffect);

	//Armour System grants temporary armour and mends shredded armour
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'MZArmourSystem';
	StatChangeEffect.DuplicateResponse = eDupe_Ignore;            //  Gremlin effects should always be setup such that a target already under the effect is invalid.
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.bRemoveWhenTargetDies = true;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.ArmorSystemEffectName, default.ArmorSystemEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_extrapadding", true);
	StatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.ArmourSystem_Armour);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZArmourSystem');
	StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(StatChangeEffect);

	FixArmourEffect = new class'MZ_Effect_FixArmour';
	FixArmourEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(FixArmourEffect);

	//Healing Aid heals based on hack and cures elemental effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.HealingAid_PerUseHP;
	MedikitHeal.HealSpread = default.HealingAid_Spread;
	MedikitHeal.UseStat = eStat_Hacking;
	MedikitHeal.PsiFactor = default.HealingAid_HackScalar;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAidProtocolHeal');
	MedikitHeal.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(MedikitHeal);

	RemoveEffects = class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType();
	RemoveEffects.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(RemoveEffects);

	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = CapacitorDischarge_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Phalanx";
	Template.Hostility = eHostility_Offensive;
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	
	Template.ActivationSpeech = 'ScanningProtocol';
	Template.CustomSelfFireAnim = 'NO_SensorSweepA';
	//Template.DamagePreviewFn = CapacitorDischargeDamagePreview;
	Template.Hostility = eHostility_Defensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'

	return Template;
}

static function X2AbilityTemplate FlameProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage	DamageEffect;

	Template=CreateBaseSingleAttackProtocol('MZFlameProtocol', "img:///UILibrary_PerkIcons.UIPerk_combatprotocol");

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FlameProtocol_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZFlameProtocol';
	//DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect( class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1) );
	
	return Template;
}

static function X2AbilityTemplate AcidProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage	DamageEffect;

	Template=CreateBaseSingleAttackProtocol('MZAcidProtocol', "img:///UILibrary_PerkIcons.UIPerk_combatprotocol");

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AcidProtocol_Cooldown;
	Template.AbilityCooldown = Cooldown;

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Acid');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZAcidProtocol';
	//DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect( class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2,1) );
	
	return Template;
}

static function X2AbilityTemplate ToxicProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage	DamageEffect;

	Template=CreateBaseSingleAttackProtocol('MZToxicProtocol', "img:///UILibrary_PerkIcons.UIPerk_combatprotocol");

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ToxicProtocol_Cooldown;
	Template.AbilityCooldown = Cooldown;

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Poison');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZToxicProtocol';
	//DamageEffect.bIgnoreArmor = true;
	DamageEffect.bBypassShields = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect( class'X2StatusEffects'.static.CreatePoisonedStatusEffect() );
	
	return Template;
}

static function X2AbilityTemplate SabotageProtocol()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2Effect_ApplyWeaponDamage            RobotDamage;
	local X2Condition_UnitProperty              RobotProperty;

	Template=CreateBaseSingleAttackProtocol('MZSabotageProtocol', "img:///UILibrary_PerkIcons.UIPerk_codex_techvulnerability");

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.SabotageProtocol_Charges;
	Template.AbilityCharges = Charges;
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	
	RobotDamage = new class'X2Effect_ApplyWeaponDamage';
	RobotDamage.bIgnoreBaseDamage = true;
	RobotDamage.DamageTag = 'CombatProtocol_Robotic';
	RobotProperty = new class'X2Condition_UnitProperty';
	RobotProperty.ExcludeOrganic = true;
	RobotDamage.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect(RobotDamage);

	Template.AddTargetEffect(new class'MZ_Effect_DisableWeapon');
	
	return Template;
}

static function X2AbilityTemplate HostageProtocol()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2Effect_Stunned				StunnedEffect;
	local X2Effect_GenerateCover				CoverEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitType			UnitTypeCondition;

	Template=CreateBaseSingleAttackProtocol('MZHostageProtocol', "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin");

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.SabotageProtocol_Charges;
	Template.AbilityCharges = Charges;
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenAssassin');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenWarlock');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenSniper');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Stun');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.HOSTAGE_DURATION, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);
	
	CoverEffect = new class'X2Effect_GenerateCover';
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnEnd);
	CoverEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(CoverEffect);

	Template.AddTargetEffect(new class'MZ_Effect_DisableWeapon');
	
	return Template;
}

static function X2DataTemplate NapalmProtocol()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2Effect_ApplyFireToWorld         FireToWorldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNapalmProtocol');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.NapalmProtocol_Charges;
	//Charges.AddBonusCharge('MZSuperColdStorage', default.SuperCold_Winter_Charges);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.NapalmProtocol_Radius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZNapalmProtocol';
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1) );

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.0f;
	FireToWorldEffect.FireChance_Level2 = 0.5f;
	FireToWorldEffect.FireChance_Level3 = 0.25f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);


	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = CapacitorDischarge_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.Hostility = eHostility_Offensive;
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	
	Template.ActivationSpeech = 'CapacitorDischarge';
	Template.CustomSelfFireAnim = 'NO_CapacitorDischargeA';
	//Template.DamagePreviewFn = CapacitorDischargeDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'CapacitorDischarge'

	return Template;
}