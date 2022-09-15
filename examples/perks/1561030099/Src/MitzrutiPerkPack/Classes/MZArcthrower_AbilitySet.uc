class MZArcthrower_AbilitySet extends X2Ability config(MZPerkPack);

var config int JoltAwake_Cooldown, ArcHaywire_Cooldown, ArcHaywire_GiveAP, ArcRobotInsanity_Cooldown, ArcRobotInsanity_Control_Duration, BoostMove_Cooldown, Repair_Charges, PhaseLance_Cooldown, CascadeLance_DamageBonus, Fuse_Cooldown;
var config int Electrocute_Cooldown;
var config array<name> ArcthrowerAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem( ArcJoltAwake());
	/*>>*/Templates.AddItem( ArcStabilize());
	Templates.AddItem( ArcHaywire());
	Templates.AddItem( ArcRobotInsanity());
	Templates.AddItem( ArcRepair());
	Templates.AddItem( ArcBlueActions());
	Templates.AddItem( ArcBoostMove());
	Templates.AddItem( ArcFuse());
	Templates.AddItem( ArcPhaseLance());
	Templates.AddItem( ArcCascadeLance());
	Templates.AddItem( ArcElectrocute());

	return Templates;
}

static function AddEffectsToArcthrowerAbilities()
{
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local name									AbilityName;
	//local X2Condition_AbilityProperty			AbilityCondition;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	foreach default.ArcthrowerAbilities(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		if ( AbilityTemplate != none )
		{

		}
	}
}

static function X2AbilityTemplate ArcStabilize()
{
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local X2Effect_RemoveEffects            RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcStabilize');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Stabilize";  
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STABILIZE_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_NoTargets');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.IsBleedingOut = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StabilizingAlly';
	Template.bUniqueSource = true;

	//Effects
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true));

	Template.bAllowBonusWeaponEffects = false;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.Hostility = eHostility_Defensive;

	return Template;	
}
static function X2AbilityTemplate ArcJoltAwake()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcJoltAwake');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_emphaticprojection";  
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.JoltAwake_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_RevivalProtocol');

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	//Template.ActivationSpeech = 'StabilizingAlly';
	Template.bUniqueSource = true;

	//Effects
	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ObsessedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BerserkName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ShatteredName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints'); 

	Template.bAllowBonusWeaponEffects = false;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.Hostility = eHostility_Defensive;

	return Template;	
}

static function X2AbilityTemplate ArcHaywire()
{
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2Effect_MindControl				MindControlEffect;
	local X2Effect_StunRecover				StunRecoverEffect;
	local X2Condition_UnitEffects			EffectCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcHaywire');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityEMPulser"; 
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ArcHaywire_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
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
	
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Targeting of desctrucibles is allowed.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(0, false, false);
	MindControlEffect.DamageTypes.Length = 0;
	MindControlEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	
	//Give Action Points, so it can act right away
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = default.ArcHaywire_GiveAP;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'TeslaCannon';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate ArcRobotInsanity()
{
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_Stunned					StunEffect;
	local X2Effect_MindControl				MindControlEffect;
	local X2Effect_RemoveEffects			MindControlRemoveEffects;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcRobotInsanity');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityEMPulser"; 
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ArcHaywire_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
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
	
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Targeting of desctrucibles is allowed.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	StatCheck.AttackerStat = eStat_Hacking;
	StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;
	Template.AbilityToHitOwnerOnMissCalc = StatCheck;

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  Single action stun for 1-2 unblocked hack hit
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
	
	//  Mind control effect for 5+ unblocked hack hits
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.ArcRobotInsanity_Control_Duration, false, false);
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
	

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'TeslaCannon';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate ArcRepair()
{
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges                  Charges;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local MZ_Effect_CKHeal					HealEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcRepair');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_repair";  
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.Repair_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StabilizingAlly';
	Template.bUniqueSource = true;

	//Effects
	HealEffect = new class'MZ_Effect_CKHeal';
	HealEffect.IsCritBased = false;
	Template.AddTargetEffect(HealEffect);
	Template.bAllowBonusWeaponEffects = false;

	Template.AddTargetEffect( class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType() );
	Template.AddTargetEffect( new class'MZ_Effect_FixArmour');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.Hostility = eHostility_Defensive;

	return Template;	
}

static function X2AbilityTemplate ArcBlueActions()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MZArcBlueActions');
	Template.IconImage =  "img:///UILibrary_LWSecondariesWOTC.LW_AbilityArcthrowerStun";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	IconEffect.EffectName = 'Arcthrower_DoNotConsumeAllActionsEffect';
	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate ArcBoostMove()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2Effect_Persistent				Shadowstep;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcBoostMove');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Blitz";  
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BoostMove_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeUnableToAct = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StabilizingAlly';
	Template.bUniqueSource = true;

	//Effects
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MomentumActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	Shadowstep = new class'X2Effect_Persistent';
	Shadowstep.EffectName = 'Shadowstep';
	Shadowstep.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	Shadowstep.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(Shadowstep);

	Template.bAllowBonusWeaponEffects = false;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.Hostility = eHostility_Defensive;

	return Template;	
}

static function X2AbilityTemplate ArcFuse()
{
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_Persistent				DisorientedEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitProperty			Condition_UnitProperty;
	local X2Effect_TriggerEvent             InsanityEvent;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcFuse');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade"; 
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Fuse_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Targeting of desctrucibles is allowed.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// same conditions as regular fuse.
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  effects
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = true;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	Template.AddTargetEffect(DisorientedEffect);

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_Fuse';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'TeslaCannon';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.DamagePreviewFn = FuseDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

function bool FuseDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
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

static function X2AbilityTemplate ArcPhaseLance()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2Effect_Persistent				DisorientedEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitProperty			Condition_UnitProperty;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcPhaseLance');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance";  
	Template.ShotHUDPriority = 355;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_Line';

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PhaseLance_Cooldown;
	Template.AbilityCooldown = Cooldown;

	//Effects
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = true;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	Template.AddMultiTargetEffect(DisorientedEffect);


	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	ToHitCalc.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_Line';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StunTarget';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate ArcCascadeLance()
{
	
	local X2AbilityTemplate					Template;
	local MZ_Effect_DamageByTargetCount         Effect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MZArcCascadeLance');
	Template.IconImage =  "img:///UILibrary_MZChimeraIcons.Ability_CascadeLance";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;

	//Effect
	Effect = new class'MZ_Effect_DamageByTargetCount';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.DMG_INCREMENT = default.CascadeLance_DamageBonus;
	Effect.MaxBonusToAllTargets = false;
	Effect.AbilityNames.AddItem('MZArcPhaseLance');
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate ArcElectrocute()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	//local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local X2Effect_Persistent				DisorientedEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitProperty			Condition_UnitProperty;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZArcElectrocute');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityStunGunner";  
	Template.ShotHUDPriority = 350;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Electrocute_Cooldown;
	Template.AbilityCooldown = Cooldown;

	//Effects
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = true;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	Template.AddTargetEffect(DisorientedEffect);


	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StunTarget';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}
