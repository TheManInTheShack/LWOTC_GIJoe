class MZKnife_AbilitySet extends X2Ability config(MZPerkPack);

var config int LightningKnife_Cooldown, HealKnife_Cooldown, StabalizeKnife_Cooldown, KnifeFlurry_Cooldown, InfectedKnife_Cooldown, InfectedKnife_Zombify_Turns, FlameKnife_Cooldown, FlameKnife_BurnDamage, FlameKnife_BurnSpread, DancingDeath_Cooldown, ShockKnife_Cooldown, ShockKnife_HackDebuff;
var config int HealthHeist_Cooldown, HealthHeist_CritChance, SacrificialKnife_HPCost, SonicScrewdriver_Cooldown, ListonStyle_Cooldown, ListonStyle_CritChance, Ambulance_Cooldown, Butterfly_Cooldown, AcidKnife_Cooldown, AcidKnife_BurnDamage, AcidKnife_BurnSpread, AcidKnife_Shred, AcidKnife_Pierce;
var config int LikeAScalpel_CritChance, LikeAScalpel_CritDamage, LikeAScalpel_HealBonus, SerratedKnife_Cooldown, SerratedKnife_rupture, SerratedKnife_BleedTurns, SerratedKnife_BleedDamage, StingLikeABee_DamagePerStrafe, FinishingStroke_Cooldown, DriftingContact_CritChance, DriftingContact_Cooldown;
var config float KnifeFlurry_DamageMod, DancingDeath_DamageMod, DancingDeath_radius, ListonStyle_radius, StrafeKnife_DamageMod, FinishingStroke_DamageMod, ButterflySpeedster_MobilityMod;
var config array<name> AMBULANCE_SKILLS;

var localized string StingLikeABeeBonusName, KnifeFlurryBonusName, DancingDeathBonusName, StrafeKnifeBonusName, FinishingStrokeBonusName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddLightningKnife());
	Templates.AddItem(AddHealKnife());
	/*>>*/Templates.AddItem(AddStabilizeKnife());
	Templates.AddItem(AddKnifeFlurry());
	/*>>*/Templates.AddItem(AddKnifeFlurry2());
	/*>>*/Templates.AddItem(AddKnifeFlurry3());
	/*>>*/Templates.AddItem(AddKnifeFlurryBonus());
	Templates.AddItem(AddInfectedKnife());
	Templates.AddItem(AddSilverKnife());
	Templates.AddItem(AddFlameKnife());
	Templates.AddItem(AddDancingDeath());
	/*>>*/Templates.AddItem(AddDancingDeathChaser());
	/*>>*/Templates.AddItem(AddDancingDeathCloser());
	/*>>*/Templates.AddItem(AddDancingDeathBonus());
	Templates.AddItem(AddHealthHeist());
	Templates.AddItem(AddSacrificialKnife());
	Templates.AddItem(AddStichUp());
	Templates.AddItem(AddSonicScrewdriver());
	Templates.AddItem(AddListonStyle());
	/*>>*/Templates.AddItem(AddListonStyleChaserSlash());
	/*>>*/Templates.AddItem(AddListonStyleChaserHeal());
	Templates.AddItem(AddAmbulance());
	Templates.AddItem(AddStrafeKnife());
	/*>>*/Templates.AddItem(AddStrafeKnifeBonus());
	Templates.AddItem(AddStingLikeABee());
	/*>>*/Templates.AddItem(AddStingLikeABeeBonus());
	Templates.AddItem(AddAcidKnife());
	/*>>*/Templates.AddItem(AddAcidKnifeBonus());
	Templates.AddItem(AddFinishingStroke());
	/*>>*/Templates.Additem(AddFinishingStrokeBonus());
	Templates.AddItem(AddLikeAScalpel());
	Templates.AddItem(AddSerratedKnife());
	Templates.AddItem(AddDriftingContact());
	Templates.AddItem(AddFloatLikeAButterfly());
	Templates.AddItem(AddShockKnife());
	
	return Templates;
}

static function X2AbilityTemplate AddLightningKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLightningKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_charge";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LightningKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddHealKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local array<name>                       SkipExclusions;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_CKHeal					HealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHealKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Item_Medipatch";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 315;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
   // Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('MZAmbulance');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HealKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	HealEffect = new class'MZ_Effect_CKHeal';
	HealEffect.IsCritBased = true;
	Template.AddTargetEffect(HealEffect);
	Template.bAllowBonusWeaponEffects = false;
	
	// VGamepliz matters
	Template.bSkipMoveStop = true;

	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomFireAnim = 'HL_Revive';
	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Defensive;
	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('MZStabilizeKnife');

	return Template;
}

static function X2AbilityTemplate AddStabilizeKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local array<name>                       SkipExclusions;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_RemoveEffects            RemoveEffects;
	local X2Condition_UnitProperty          UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStabilizeKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_NoTargets');
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Stabilize";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 315;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    //Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('MZAmbulance');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.StabalizeKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.IsBleedingOut = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true));
	Template.bAllowBonusWeaponEffects = false;
	
	// VGamepliz matters
	Template.bSkipMoveStop = true;

	Template.ActivationSpeech = 'StabilizingAlly';

	Template.CustomFireAnim = 'HL_Revive';
	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Defensive;
	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddKnifeFlurry()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKnifeFlurry');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KnifeFlurry_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('MZKnifeFlurry2');
	Template.AdditionalAbilities.AddItem('MZKnifeFlurry3');
	Template.AdditionalAbilities.AddItem('MZKnifeFlurryBonus');
	Template.PostActivationEvents.AddItem('MZKnifeFlurry2');
	Template.PostActivationEvents.AddItem('Knifeperk');

	Template.DamagePreviewFn = KnifeFlurryDamagePreview;

	return Template;
}

function bool KnifeFlurryDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local StateObjectReference ChainShot3Ref;
	local XComGameState_Ability ChainShot3Ability;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZKnifeFlurry2');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	
	ChainShot3Ref = AbilityOwner.FindAbility('MZKnifeFlurry3');
	ChainShot3Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot3Ref.ObjectID));
	ChainShot3Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddKnifeFlurry2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKnifeFlurry2');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityKnifeFighter";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'MZKnifeFlurry2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('MZKnifeFlurry3');

	return Template;
}

static function X2AbilityTemplate AddKnifeFlurry3()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKnifeFlurry3');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityKnifeFighter";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 350;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'MZKnifeFlurry3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;


	return Template;
}

static function X2AbilityTemplate AddKnifeFlurryBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KnifeFlurryBonus	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKnifeFlurryBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_KnifeFlurryBonus';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.KnifeFlurry_DamageMod;
	DamageEffect.AbilityNames.AddItem('MZKnifeFlurry');
	DamageEffect.AbilityNames.AddItem('MZKnifeFlurry2');
	DamageEffect.AbilityNames.AddItem('MZKnifeFlurry3');
	DamageEffect.FriendlyName = default.KnifeFlurryBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddInfectedKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZInfectedKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_QuickBite";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.InfectedKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Poison');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'poison';
	WeaponDamageEffect.DamageTypes.AddItem('poison');
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(false, 0, false));
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
	Template.AddTargetEffect(class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.InfectedKnife_Zombify_Turns));
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddSilverKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSilverKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes";
	Template.AbilityIconColor = "acd373";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('MZDualFang');
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);
		
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bHitsAreCrits = true;
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_TurnUndead');

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddFlameKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFlameKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Burn";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FlameKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FlameKnife_BurnDamage, default.FlameKnife_BurnSpread));
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddDancingDeath()
{
	local X2AbilityTemplate					Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Radius			ConeMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_TriggerEvent             InsanityEvent;
	local X2AbilityTarget_MovingMelee		MeleeTarget;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('MZDancingDeath');
	Template.TargetingMethod = class'MZ_TargetMethod_MeleeWithRadius';
	Template.ShotHUDPriority = 340;

	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DancingDeath_Cooldown;
	Template.AbilityCooldown = Cooldown;

	//	These are all handled in the editor if you want to change them!
//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
	Template.bSkipExitCoverWhenFiring = false;
//END AUTOGENERATED CODE: Template Overrides 'ArcWave'
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bladestorm";

	ConeMultiTarget = new class'X2AbilityMultiTarget_Radius';
	ConeMultiTarget.fTargetRadius = default.DancingDeath_radius;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'MZDancingDeathChaser';
	InsanityEvent.ApplyChance = 100;
	InsanityEvent.bApplyOnMiss = true;
	InsanityEvent.bApplyOnHit = true;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.PostActivationEvents.AddItem('MZDancingDeathCloser');
	Template.PostActivationEvents.AddItem('Knifeperk');

	Template.AdditionalAbilities.AddItem('MZDancingDeathChaser');
	Template.AdditionalAbilities.AddItem('MZDancingDeathCloser');
	Template.AdditionalAbilities.AddItem('MZDancingDeathBonus');

	Template.DamagePreviewFn = DancingDeathDamagePreview;
	
	return Template;
}

function bool DancingDeathDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZDancingDeathCloser');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddDancingDeathChaser()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDancingDeathChaser');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MZDancingDeathChaser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	//StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityTargetStyle =  new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMelee";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'

	return Template;
}

static function X2AbilityTemplate AddDancingDeathCloser()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;
	local X2AbilityCost_ActionPoints        ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDancingDeathCloser');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MZDancingDeathCloser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	EventListener.ListenerData.Priority = 40; //low
	Template.AbilityTriggers.AddItem(EventListener);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	//StandardMelee.bGuaranteedHit = true;
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityTargetStyle =  new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMelee";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'

	return Template;
}

static function X2AbilityTemplate AddDancingDeathBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KnifeFlurryBonus	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDancingDeathBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_KnifeFlurryBonus';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.DancingDeath_DamageMod;
	DamageEffect.AbilityNames.AddItem('MZDancingDeath');
	DamageEffect.AbilityNames.AddItem('MZDancingDeathChaser');
	DamageEffect.AbilityNames.AddItem('MZDancingDeathCloser');
	DamageEffect.FriendlyName = default.DancingDeathBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddHealthHeist()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	//local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHealthHeist');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_horror";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HealthHeist_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInCritMod = default.HealthHeist_CritChance;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	/*
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	*/
	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	//WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(new class'MZ_Effect_LifeSteal');

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddSacrificialKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;
	local Grimy_AbilityCost_HP				HPCost;
	
	//local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSacrificialKnife');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityKnifeFighter";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;
	Template.AbilityIconColor = "C34144";

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.SacrificialKnife_HPCost;
	Template.AbilityCosts.AddItem(HPCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	/*
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	*/
	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//WeaponDamageEffect.EffectDamageValue.DamageType = 'fire';
	//WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	//Template.AdditionalAbilities.AddItem('MZSacraficialKnifeBonus');

	return Template;
}

static function X2AbilityTemplate AddStichUp()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStitchUp');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_battlefatigue";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('MZAmbulance');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.ExcludeHostileToSource = true;
	AdjacencyCondition.ExcludeFriendlyToSource = false;
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.BurningName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	Template.bAllowBonusWeaponEffects = false;

	Template.AddTargetEffect( new class'MZ_Effect_FixArmour');
	Template.AddTargetEffect( class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType() );
	
	// VGamepliz matters
	Template.bSkipMoveStop = true;

	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomFireAnim = 'HL_Revive';

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Defensive;
	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddSonicScrewdriver()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local array<name>                       SkipExclusions;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty          UnitCondition;
	local MZ_Effect_CKHeal					HealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSonicScrewdriver');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_repair";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 315;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
   // Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('MZAmbulance');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SonicScrewdriver_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.RequireWithinRange = true;
	UnitCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	HealEffect = new class'MZ_Effect_CKHeal';
	HealEffect.IsCritBased = true;
	Template.AddTargetEffect(HealEffect);
	Template.bAllowBonusWeaponEffects = false;
	
	// VGamepliz matters
	Template.bSkipMoveStop = true;

	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomFireAnim = 'HL_Revive';
	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Defensive;
	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddListonStyle()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_TriggerEvent             InsanityEvent;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZListonStyle');

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ListonStyle_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ListonStyle_radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.NumTargetsRequired = 1;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'MZListonStyleChaserSlash';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Refresh";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bShowActivation = true;

	Template.TargetingMethod = class'X2TargetingMethod_PathTarget';

	Template.ActivationSpeech = 'Rend';

	Template.PostActivationEvents.AddItem('MZConsumeMomentum');

	Template.AdditionalAbilities.AddItem('MZListonStyleChaserSlash');
	Template.AdditionalAbilities.AddItem('MZListonStyleChaserHeal');
	Template.AdditionalAbilities.AddItem('MZConsumeMomentum');
	Template.PostActivationEvents.AddItem('Knifeperk');

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.MoveAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMovement"; 

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentMoveLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'
Template.Hostility = eHostility_Neutral;

	return Template;
}

static function X2AbilityTemplate AddListonStyleChaserSlash()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZListonStyleChaserSlash');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MZListonStyleChaserSlash';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInCritMod = default.ListonStyle_CritChance;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityTargetStyle =  new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMelee";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Refresh";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'

	return Template;
}

static function X2AbilityTemplate AddListonStyleChaserHeal()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_CKHeal					HealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZListonStyleChaserHeal');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MZListonStyleChaserSlash';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Target Conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeTurret = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityTargetStyle =  new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Damage Effect
	HealEffect = new class'MZ_Effect_CKHeal';
	HealEffect.IsCritBased = true;
	Template.AddTargetEffect(HealEffect);
	Template.bAllowBonusWeaponEffects = false;

	Template.bSkipMoveStop = true;
	
	Template.CustomFireAnim = 'HL_Revive';
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMelee";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Refresh";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.Hostility = eHostility_Defensive;

	return Template;
}

static function X2AbilityTemplate AddAmbulance()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_GrantActionPoints    ActionPointEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Effect_Persistent			Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAmbulance');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flight";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Ambulance_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = 'MZAmbulance';
	Template.AddTargetEffect(ActionPointEffect);

	Effect = new class'X2Effect_Persistent';
	Effect.EffectName = 'Shadowstep';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddStrafeKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStrafeKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	//Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Knife";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority =class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('MZStrafeKnifeBonus');

	return Template;
}

static function X2AbilityTemplate AddStrafeKnifeBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KnifeFlurryBonus	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStrafeKnifeBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_KnifeFlurryBonus';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.StrafeKnife_DamageMod;
	DamageEffect.AbilityNames.AddItem('MZStrafeKnife');
	DamageEffect.FriendlyName = default.StrafeKnifeBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect(new class'Grimy_Effect_StrafePoint');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddStingLikeABee()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitEffectsOnSource	ButterflyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStingLikeABee');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_justice";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 326;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);
	
	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	ButterflyCondition = new class'X2Condition_UnitEffectsOnSource';
	ButterflyCondition.AddRequireEffect('MZFloatLikeAButterfly','AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ButterflyCondition);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PrerequisiteAbilities.AddItem('MZFloatLikeAButterfly');
	Template.AdditionalAbilities.AddItem('MZStingLikeABeeBonus');

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddStingLikeABeeBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_StrafeComboDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStingLikeABeeBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_StrafeComboDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.StingLikeABee_DamagePerStrafe;
	DamageEffect.AbilityNames.AddItem('MZStingLikeABee');
	DamageEffect.FriendlyName = default.StingLikeABeeBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddAcidKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAcidKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AcidKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('acid');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'acid';
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(default.AcidKnife_BurnDamage, default.AcidKnife_BurnSpread));
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.Additem('MZAcidKnifeBonus');
	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddAcidKnifeBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_Shellbust				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAcidKnifeBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_Shellbust';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName= 'MZAcidKnife';
	DamageEffect.BonusShred = default.AcidKnife_Shred;
	DamageEffect.BonusAP = default.AcidKnife_Pierce;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddFinishingStroke()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFinishingStroke');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reaper";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FinishingStroke_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.bPreventsTargetTeleport = true;

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('MZFinishingStrokeBonus');
	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddFinishingStrokeBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_FinishingStroke		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFinishingStrokeBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_FinishingStroke';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.DamageMod = default.FinishingStroke_DamageMod;
	DamageEffect.AbilityNames.AddItem('MZFinishingStroke');
	DamageEffect.FriendlyName = default.FinishingStrokeBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddLikeAScalpel() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_WeaponCritMod		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLikeAScalpel');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aggression";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_WeaponCritMod';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.CritDamage = default.LikeAScalpel_CritDamage;
	DamageEffect.CritChance = default.LikeAScalpel_CritChance;
	DamageEffect.NonCritInvertsBonus = true;
	DamageEffect.WeaponCats.AddItem('combatknife');
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddSerratedKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSerratedKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ceramicblade";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SerratedKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.Rupture = default.SerratedKnife_rupture;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.SerratedKnife_BleedTurns, default.SerratedKnife_BleedDamage));
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddDriftingContact()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	//local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDriftingContact');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.BonusPoint = 'momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DriftingContact_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInCritMod = default.DriftingContact_CritChance;
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}

static function X2AbilityTemplate AddFloatLikeAButterfly()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_GrantActionPoints    ActionPointEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local MZ_Effect_FloatLikeAButterfly			Effect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local X2Effect_PersistentStatChange	StatEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFloatLikeAButterfly');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_juggernaut";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Butterfly_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = 'momentum';
	Template.AddTargetEffect(ActionPointEffect);

	Effect = new class'MZ_Effect_FloatLikeAButterfly';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	StatEffect.AddPersistentStatChange(eStat_Mobility, default.ButterflySpeedster_MobilityMod, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySpeedster');
	StatEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(StatEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddShockKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitProperty			UnitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShockKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_volt";
	//Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 325;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;
	Template.bLimitTargetIcons = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShockKnife_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'electrical';
	WeaponDamageEffect.DamageTypes.AddItem('electrical');
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	//UnitCondition.IncludeWeakAgainstTechLikeRobot = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'electrical';
	WeaponDamageEffect.DamageTypes.AddItem('electrical');
	WeaponDamageEffect.TargetConditions.AddItem(UnitCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.ShockKnife_HackDebuff, UnitCondition));

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.PostActivationEvents.AddItem('Knifeperk');

	return Template;
}