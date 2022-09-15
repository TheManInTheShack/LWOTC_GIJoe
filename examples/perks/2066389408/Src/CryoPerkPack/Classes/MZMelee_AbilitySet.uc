class MZMelee_AbilitySet extends X2Ability config(MZCryoPerkPack);

var config int DoubleGrip_Dmg, DoubleGrip_DmgPerTier, DoubleGrip_Pierce, DoubleGrip_PiercePerTier;
var config array<name> DoubleGrip_WeaponCats, DoubleGrip_EmptyCats;

var config int FrostKnife_Cooldown, FrostKnife_DoT_Duration, ParivirBlade_BonusChargePerAbility, HoarfrostBlade_Charges, IceDragonBreath_Cooldown, IceDragonBreath_Length, IceDragonBreath_Width, SnowFlakeDraft_Cooldown, Icebreaker_Cooldown, SlingBlade_Cooldown, SlingBlade_Range;
var config int VapourBlade_Cooldown, VapourBlade_Range, LavaAxe_BurnDamage, LavaAxe_BurnSpread;
var config float SnowflakeDraft_Radius, Icebreaker_Length, Icebreaker_Width, FrostSabre_BonusDamage;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FrostKnife());
	Templates.AddItem(HoarfrostBlade());
	Templates.AddItem(IceDragonBreath());
	Templates.AddItem(SnowFlakeDraft());
	Templates.AddItem(Icebreaker());
	Templates.AddItem(SlingBlade());
	Templates.AddItem(VapourBlade());
	Templates.AddItem(LavaAxe());
	Templates.AddItem(StormHammer());
	Templates.AddItem(FrostSabre());

	return Templates;
}

static function X2AbilityTemplate CreateBaseSlashAbility(Name AbilityName = 'MZNonStandardSlash', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash")
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = IconImage;
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 330;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// No Target Effects - added by the actual ability creation.

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate FrostKnife()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			AdjacencyCondition;	
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFrostKnife');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MPP.shinysabre";
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
	Cooldown.iNumTurns = default.FrostKnife_Cooldown;
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
	UnitImmunityCondition.AddExcludeDamageType('Frost');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'frost';
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);
	Template.AddTargetEffect(class'MZ_Effect_Hypothermia'.static.CreateHypothermiaEffect(default.FrostKnife_DoT_Duration));
	
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

static function X2AbilityTemplate HoarfrostBlade()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHoarfrostBlade');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MPP.shinysabre";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.HoarfrostBlade_Charges;
	Charges.AddBonusCharge('MZLifethreadBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZShimmeringBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZSkyfuryBlade', default.ParivirBlade_BonusChargePerAbility);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('MZLifethreadBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZShimmeringBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZSkyfuryBlade');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Frost');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);
	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate IceDragonBreath()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local MZ_Cooldown_AbilitySetReduces		Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZIceDragonBreath');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'MZ_Cooldown_AbilitySetReduces';
	Cooldown.iNumTurns = default.IceDragonBreath_Cooldown;
	Cooldown.AbilityInSet.AddItem('MZFireDragonBreath');
	Cooldown.AbilityInSet.AddItem('MZThunderDragonBreath');
	Cooldown.AbilityInSet.AddItem('MZAcidDragonBreath');
	Cooldown.AbilityInSet.AddItem('MZPoisonDragonBreath');
	Template.AbilityCooldown = Cooldown;
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.IceDragonBreath_Length;
	Template.AbilityTargetStyle = CursorTarget;
	
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.IceDragonBreath_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.IceDragonBreath_Length * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage ="img:///UILibrary_MPP.icewave";
	Template.ShotHUDPriority = 330;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.CustomFireAnim = 'FF_MZIceDragonBreath';
	Template.ActionFireClass = class'MZ_FireAction_IceDragonBreath';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;	

	return Template;	
}

static function X2AbilityTemplate SnowFlakeDraft()
{
	local X2AbilityTemplate						Template;
	local X2AbilityMultiTarget_Radius           MultiTargetRadius;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee		StandardMelee;
	local X2AbilityCooldown						Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSnowFlakeDraft');
//BEGIN AUTOGENERATED CODE: Template Overrides 'IonicStorm'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.ActivationSpeech = 'IonicStorm';
	//Template.CinescriptCameraType = "Templar_IonicStorm";
//END AUTOGENERATED CODE: Template Overrides 'IonicStorm'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 330;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_MPP.snowflakeheavy";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bFriendlyFireWarning = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SnowFlakeDraft_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_PathTarget';

	//Appears to be failing to apply.
	MultiTargetRadius = new class'X2AbilityMultiTarget_Radius';
	MultiTargetRadius.fTargetRadius = default.SnowFlakeDraft_Radius;
	MultiTargetRadius.bExcludeSelfAsTargetIfWithinRadius = true;
	MultiTargetRadius.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTargetRadius;

	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	//Just Uses Weapon Damage. nothing fancy.
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bSkipExitCoverWhenFiring = false;

	Template.CustomFireAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomFireKillAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingFireAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingFireKillAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeDragonStrikeA';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeDragonStrikeA';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate Icebreaker()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitEffects			ChillDegreeCondition;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZIcebreaker');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MPP.Shatter";
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Icebreaker_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('frost');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	ChillDegreeCondition = new class'X2Condition_UnitEffects';
	ChillDegreeCondition.AddRequireEffect('Freeze', 'AA_MissingRequiredEffect'); // name effect, name reason
	Template.AbilityTargetConditions.AddItem(ChillDegreeCondition);

	//Multitarget stuff.
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.IceBreaker_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.Icebreaker_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);
	Template.AddTargetEffect(class'BitterfrostHelper'.static.UnChillEffect());

	Template.PostActivationEvents.AddItem('RendActivated');

	Template.bAllowBonusWeaponEffects = true;

	Template.bSkipMoveStop = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZIcebreaker';
	Template.CustomFireKillAnim = 'FF_MZIcebreaker';
	Template.CustomMovingFireAnim = 'MV_MZIcebreaker';
	Template.CustomMovingFireKillAnim = 'MV_MZIcebreaker';
	Template.CustomMovingTurnLeftFireAnim = 'MV_RunTun90LeftMZIcebreaker';
	Template.CustomMovingTurnLeftFireKillAnim = 'MV_RunTun90LeftMZIcebreaker';
	Template.CustomMovingTurnRightFireAnim = 'MV_RunTun90RightMZIcebreaker';
	Template.CustomMovingTurnRightFireKillAnim = 'MV_RunTun90RightMZIcebreaker';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Soldier_RageStrike";
	Template.bSkipExitCoverWhenFiring = false;

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.ActivationSpeech = 'Rend';
//END AUTOGENERATED CODE: Template Overrides 'Rend'

	return Template;
}

static function X2AbilityTemplate SlingBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSlingBlade');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_throwaxe";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//  Normal effect restrictions (except disoriented)
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.SlingBlade_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bAllowAmmoEffects = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SlingBlade_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_DLC_2ThrowAxe';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";
	Template.bUsesFiringCamera = true;

	Template.CustomFireAnim = 'NO_MZSlingBlade';
	Template.CustomFireKillAnim = 'NO_MZSlingBlade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ThrowAxe'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ThrowAxe'

	return Template;
}

static function X2AbilityTemplate VapourBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local MZ_Cooldown_AbilitySetReduces		Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZVapourBlade');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_throwaxe";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//  Normal effect restrictions (except disoriented)
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.VapourBlade_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Frost');
	UnitImmunityCondition.AddExcludeDamageType('Melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowAmmoEffects = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'MZ_Cooldown_AbilitySetReduces';
	Cooldown.iNumTurns = default.VapourBlade_Cooldown;
	Cooldown.AbilityInSet.AddItem('MZLavaAxe');
	Cooldown.AbilityInSet.AddItem('MZStormHammer');
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_DLC_2ThrowAxe';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";
	Template.bUsesFiringCamera = true;

	Template.CustomFireAnim = 'NO_MZSlingBlade';
	Template.CustomFireKillAnim = 'NO_MZSlingBlade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ThrowAxe'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ThrowAxe'

	return Template;
}

static function X2AbilityTemplate LavaAxe()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local MZ_Cooldown_AbilitySetReduces		Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLavaAxe');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_throwaxe";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//  Normal effect restrictions (except disoriented)
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.VapourBlade_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.AddExcludeDamageType('Melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowAmmoEffects = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'MZ_Cooldown_AbilitySetReduces';
	Cooldown.iNumTurns = default.VapourBlade_Cooldown;
	Cooldown.AbilityInSet.AddItem('MZVapourBlade');
	Cooldown.AbilityInSet.AddItem('MZStormHammer');
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.AddItem('Fire');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.LavaAxe_BurnDamage, default.LavaAxe_BurnSpread));

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_DLC_2ThrowAxe';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";
	Template.bUsesFiringCamera = true;

	Template.CustomFireAnim = 'NO_MZSlingBlade';
	Template.CustomFireKillAnim = 'NO_MZSlingBlade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ThrowAxe'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ThrowAxe'

	return Template;
}

static function X2AbilityTemplate StormHammer()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local MZ_Cooldown_AbilitySetReduces		Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStormHammer');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_throwaxe";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//  Normal effect restrictions (except disoriented)
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.VapourBlade_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.AddExcludeDamageType('Melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowAmmoEffects = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'MZ_Cooldown_AbilitySetReduces';
	Cooldown.iNumTurns = default.VapourBlade_Cooldown;
	Cooldown.AbilityInSet.AddItem('MZVapourBlade');
	Cooldown.AbilityInSet.AddItem('MZLavaAxe');
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(false, 0, false));

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_DLC_2ThrowAxe';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";
	Template.bUsesFiringCamera = true;

	Template.CustomFireAnim = 'NO_MZSlingBlade';
	Template.CustomFireKillAnim = 'NO_MZSlingBlade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ThrowAxe'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ThrowAxe'

	return Template;
}

static function X2AbilityTemplate FrostSabre()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;

	Template = CreateBaseSlashAbility('MZFrostSabre', "img:///UILibrary_MPP.shinysabre");
	Template.ShotHUDPriority = 320;

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Frost';
	WeaponDamageEffect.BonusDamageScalar = default.FrostSabre_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	return Template;
}