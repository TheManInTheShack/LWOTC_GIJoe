class MZHolotargeter_AbilitySet extends X2Ability config(MZPerkPack);

var config int HoloConceal_Duration, HoloConceal_Cooldown, HoloBlind_BlindTurns, HoloDecoy_Cooldown, HoloReveal_Cooldown, HoloReveal_Duration;
var config int HoloWill_Turns, HoloWill_Debuff, HoloBurnDamage, HoloBurnSpread, HoloBurnChance;
var config float HoloBlind_VisionMult, HoloReveal_Radius, Floodlight_RevealRadius;

var config array<name> HoloAbilities, BlindEffectsToRemove;

var localized string HoloWillDebuffEffectName, HoloWillDebuffEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( HoloConceal());
	Templates.AddItem( PurePassive('MZHoloBlind', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", false) );
	Templates.AddItem( PurePassive('MZHoloWillDebuff', "img:///UILibrary_MZChimeraIcons.Ability_Stupor", false) );
	Templates.AddItem( PurePassive('MZHoloBurn', "img:///UILibrary_PerkIcons.UIPerk_burn", false) );
	Templates.AddItem( PurePassive('MZHoloFloodlight', "img:///UILibrary_MZChimeraIcons.Ability_Flashlight", false) );
	Templates.AddItem( HoloDecoy());
	Templates.AddItem( HoloReveal());


	return Templates;
}

static function AddEffectsToHoloAbilities()
{
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local name									AbilityName;
	local X2Effect_Blind						BlindEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2Effect_Burning						BurnEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	foreach default.HoloAbilities(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		if ( AbilityTemplate != none )
		{
			BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.HoloBlind_BlindTurns, default.HoloBlind_VisionMult);
			BlindEffect.ApplyChance = 100;
			BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.HoloBlind_VisionMult, MODOP_PostMultiplication);
			AbilityCondition = new class'X2Condition_AbilityProperty';
			AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloBlind');
			BlindEffect.TargetConditions.AddItem(AbilityCondition);
			AbilityTemplate.AddTargetEffect(BlindEffect);
			AbilityTemplate.AddMultiTargetEffect(BlindEffect);

			StatChangeEffect = new class'X2Effect_PersistentStatChange';
			StatChangeEffect.EffectName = 'MZHoloWillDebuff';
			StatChangeEffect.DuplicateResponse = eDupe_Refresh;
			StatChangeEffect.BuildPersistentEffect(default.HoloWill_Turns, false, true, false, eGameRule_PlayerTurnBegin);
			StatChangeEffect.bRemoveWhenTargetDies = true;
			StatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.HoloWillDebuffEffectName, default.HoloWillDebuffEffectDesc, "img:///UILibrary_MZChimeraIcons.Ability_Stupor", true);
			StatChangeEffect.AddPersistentStatChange(eStat_Will, default.HoloWill_Debuff);
			AbilityCondition = new class'X2Condition_AbilityProperty';
			AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloWillDebuff');
			StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
			AbilityTemplate.AddTargetEffect(StatChangeEffect);
			AbilityTemplate.AddMultiTargetEffect(StatChangeEffect);

			BurnEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.HoloBurnDamage, default.HoloBurnSpread);
			BurnEffect.ApplyChance = default.HoloBurnChance;
			AbilityCondition = new class'X2Condition_AbilityProperty';
			AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloBurn');
			BurnEffect.TargetConditions.AddItem(AbilityCondition);
			AbilityTemplate.AddTargetEffect(BurnEffect);
			AbilityTemplate.AddMultiTargetEffect(BurnEffect);
		}
	}
}

static function X2AbilityTemplate HoloConceal()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			TargetProperty;
	local X2Effect_RangerStealth			StealthEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHoloConceal');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;
	//Template.ActivationSpeech = 'TracerBeams';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Holotargeter_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HoloConceal_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Visibility/Range restrictions and Targeting
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_HolotargeterSquadsightEffect');

	//Only for friends.
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	TargetProperty.RequireSquadmates = true;
	TargetProperty.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
		
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(default.HoloConceal_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());


    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate HoloDecoy()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2Effect_SpawnMimicBeacon     SpawnMimicBeacon;
	local X2AbilityTarget_Cursor		CursorTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHoloDecoy');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_MeleeStance";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;
	//Template.ActivationSpeech = 'TracerBeams';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Holotargeter_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HoloDecoy_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Visibility/Range restrictions and Targeting
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_HolotargeterSquadsightEffect');

	// Can't target dead; Can't target friendlies, can't target inanimate objects
	//Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	/*
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	*/
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.5;			//small to select only 1 tile.
	RadiusMultiTarget.bIgnoreBlockingCover = true; // we don't need this, the squad viewer will do the appropriate things once thrown
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'Grimy_TargetingMethod_RocketLauncher';
		
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	SpawnMimicBeacon = new class'X2Effect_SpawnMimicBeacon';
	SpawnMimicBeacon.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(SpawnMimicBeacon);


    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = MimicBeacon_BuildVisualization;

	return Template;
}
simulated function MimicBeacon_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata SourceTrack, MimicBeaconTrack;
	local XComGameState_Unit MimicSourceUnit, SpawnedUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnMimicBeacon SpawnMimicBeaconEffect;
	local X2Action_MimicBeaconThrow FireAction;
	local X2Action_PlayAnimation AnimationAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context);
	FireAction = X2Action_MimicBeaconThrow(class'X2Action_MimicBeaconThrow'.static.AddToVisualizationTree(SourceTrack, Context));
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context);

	// Configure the visualization track for the mimic beacon
	//******************************************************************************************
	MimicSourceUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
	`assert(MimicSourceUnit != none);
	MimicSourceUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

	MimicBeaconTrack = EmptyTrack;
	MimicBeaconTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	MimicBeaconTrack.StateObject_NewState = MimicBeaconTrack.StateObject_OldState;
	SpawnedUnit = XComGameState_Unit(MimicBeaconTrack.StateObject_NewState);
	`assert(SpawnedUnit != none);
	MimicBeaconTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

	// Set the Throwing Unit's FireAction to reference the spawned unit
	FireAction.MimicBeaconUnitReference = SpawnedUnit.GetReference();
	// Set the Throwing Unit's FireAction to reference the spawned unit
	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(MimicBeaconTrack, Context);

	// Only one target effect and it is X2Effect_SpawnMimicBeacon
	SpawnMimicBeaconEffect = X2Effect_SpawnMimicBeacon(Context.ResultContext.ShooterEffectResults.Effects[0]);
	
	if( SpawnMimicBeaconEffect == none )
	{
		`RedScreenOnce("MimicBeacon_BuildVisualization: Missing X2Effect_SpawnMimicBeacon -dslonneger @gameplay");
		return;
	}

	SpawnMimicBeaconEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, MimicBeaconTrack, MimicSourceUnit, SourceTrack);

	class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(MimicBeaconTrack, Context);

	AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(MimicBeaconTrack, Context));
	AnimationAction.Params.AnimName = 'LL_MimicStart';
	AnimationAction.Params.BlendTime = 0.0f;
}

static function X2AbilityTemplate HoloReveal()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_PersistentSquadViewer    ViewerEffect;
	local X2Effect_ScanningProtocol			ScanningEffect;
	local X2Condition_UnitProperty			CivilianProperty;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2Effect_Blind						BlindEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2Effect_Burning						BurnEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHoloReveal');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Flashlight";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;
	//Template.ActivationSpeech = 'TracerBeams';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Holotargeter_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HoloReveal_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Visibility/Range restrictions and Targeting
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_HolotargeterSquadsightEffect');

	// Can't target dead; can't target inanimate objects
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);	

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.HoloReveal_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true; // we don't need this, the squad viewer will do the appropriate things once thrown
	RadiusMultiTarget.AddAbilityBonusRadius('MZHoloFloodLight', default.FloodLight_RevealRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';
		
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(default.HoloReveal_Duration, false, false, false, eGameRule_PlayerTurnEnd);
	ScanningEffect.TargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	ScanningEffect = new class'X2Effect_ScanningProtocol';
	ScanningEffect.BuildPersistentEffect(default.HoloReveal_Duration, false, false, false, eGameRule_PlayerTurnEnd);
	CivilianProperty = new class'X2Condition_UnitProperty';
	CivilianProperty.ExcludeNonCivilian = true;
	CivilianProperty.ExcludeHostileToSource = false;
	CivilianProperty.ExcludeFriendlyToSource = false;
	ScanningEffect.TargetConditions.AddItem(CivilianProperty);
	Template.AddMultiTargetEffect(ScanningEffect);

	ViewerEffect = new class'X2Effect_PersistentSquadViewer';
	ViewerEffect.BuildPersistentEffect(default.HoloReveal_Duration, false, false, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(ViewerEffect);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.HoloBlind_BlindTurns, default.HoloBlind_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.HoloBlind_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloBlind');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BlindEffect);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'MZHoloWillDebuff';
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.BuildPersistentEffect(default.HoloWill_Turns, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.bRemoveWhenTargetDies = true;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.HoloWillDebuffEffectName, default.HoloWillDebuffEffectDesc, "img:///UILibrary_MZChimeraIcons.Ability_Stupor", true);
	StatChangeEffect.AddPersistentStatChange(eStat_Will, default.HoloWill_Debuff);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloWillDebuff');
	StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(StatChangeEffect);

	BurnEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.HoloBurnDamage, default.HoloBurnSpread);
	BurnEffect.ApplyChance = default.HoloBurnChance;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZHoloBurn');
	BurnEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BurnEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}