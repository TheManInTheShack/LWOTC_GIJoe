class PetRockPerkPack_Perks extends XMBAbility config(GameData_SoldierSkills);

var config array<name> QUICKAID_ABILITIES;
var config array<name> BYMYCOMMAND_ABILITIES;
var config array<name> FLASHYPLAYS_ABILITIES;

var config float WEAPONSMASTER_MULTIPLIER;


var config int OPPRESSIVE_FIRE_OFFENSE_MALUS;
var config int KNIGHTSFORCE_DAMAGE;
var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;
var localized string LocOppressiveFire;
var localized string LocOppressiveFireMalus;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(KnightsCharge());
	Templates.AddItem(KnightsForce());
	Templates.AddItem(CrusaderStrike());
	Templates.AddItem(QuickAid());
	Templates.AddItem(WeaponsMaster());
	Templates.AddItem(HighNoon());
	Templates.AddItem(AddEagleEyeAbility());
	Templates.AddItem(AddEagleEyePassive());
	Templates.AddItem(ByMyCommand());
	Templates.AddItem(FlashyPlays());
	Templates.AddItem(WatchdogsProtection());
	Templates.AddItem(OppressiveFire());
	Templates.AddItem(ScanningTechnology());


	return Templates;
}

//Knights Charge

static function X2AbilityTemplate KnightsCharge()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	//local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KnightsCharge');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = 1;
	//Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
//	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);
    
	Template.OverrideAbilities.AddItem('ShieldBash');
	Template.OverrideAbilities.AddItem('F_ShieldTrauma');
	
	//Template.AdditionalAbilities.AddItem('ResetKnife');

	//Replace SwordSlice
	//Template.OverrideAbilities.AddItem('Slash_RS');
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	return Template;
}

//Eagle Eye

static function X2AbilityTemplate AddEagleEyeAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_PersistentStatChange		PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EagleEye');
	Template.IconImage = "img:///BetterIcons.Perks.Battlespace";
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PersistentEffect = new class'X2Effect_PersistentStatChange';
	PersistentEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentEffect.EffectName = 'ScoutVision';
	PersistentEffect.AddPersistentStatChange(eStat_SightRadius, 5);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.AdditionalAbilities.AddItem('EagleEyePassive');
	
	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;
	
	return Template;
}

static function X2AbilityTemplate AddEagleEyePassive()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		SightRadiusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EagleEyePassive');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///BetterIcons.Perks.Battlespace";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	SightradiusEffect = new class'X2Effect_PersistentStatChange';
	SightradiusEffect.BuildPersistentEffect(1,true,false);
	SightradiusEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	SightradiusEffect.AddPersistentStatChange(eStat_SightRadius, 5);
	Template.AddTargetEffect(SightradiusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// WeaponsMaster

static function X2AbilityTemplate WeaponsMaster()
{
	local X2Effect_ModifyRangePenalties Effect;

	Effect = new class'X2Effect_ModifyRangePenalties';
	Effect.RangePenaltyMultiplier = default.WEAPONSMASTER_MULTIPLIER;
	Effect.BaseRange = 18;
	Effect.bShortRange = true;
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	return Passive('WeaponsMaster', "img:///UILibrary_SOHunter.UIPerk_point_blank", false, Effect);
}

static function X2AbilityTemplate HighNoon()
{
	local X2Effect_ModifyRangePenalties Effect;
//	local XMBCondition_AbilityName	NameCondition;
	// Remove Long range penalties from pistols
	Effect = new class'X2Effect_ModifyRangePenalties';
	Effect.RangePenaltyMultiplier = -1;
	Effect.BaseRange = 11;
	Effect.bLongRange = true;
	Effect.EffectName = 'HighNoon';

//	NameCondition = new class'XMBCondition_AbilityName';
//	NameCondition.IncludeAbilityNames.AddItem('PistolStandardShot');
//	NameCondition.IncludeAbilityNames.AddItem('PistolOverwatchShot');
//	NameCondition.IncludeAbilityNames.AddItem('MZBigFortyFive');
//	NameCondition.IncludeAbilityNames.AddItem('FanFire');
//	NameCondition.IncludeAbilityNames.AddItem('Faceoff');
//	NameCondition.IncludeAbilityNames.AddItem('MZShootOut');
//	NameCondition.IncludeAbilityNames.AddItem('MZTheBusiness');
//	NameCondition.IncludeAbilityNames.AddItem('MZPistolRave');
//	NameCondition.IncludeAbilityNames.AddItem('MZBlazeBullet');
//	NameCondition.IncludeAbilityNames.AddItem('MZPsiBullet');
//	Effect.AbilityTargetConditions.AddItem(NameCondition);

	return Passive('HighNoon', "img:///UILibrary_XPerkIconPack.UIPerk_pistol_sniper", false, Effect);
}

//Knights Force

static function X2AbilityTemplate KnightsForce()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
//	local X2Effect_Persistent               DamageEffect;
	//local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KnightsForce');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = 1;
	//Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
//	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);
    
	Template.OverrideAbilities.AddItem('KnightsCharge');

	//Template.AdditionalAbilities.AddItem('ResetKnife');

	//Replace SwordSlice
	//Template.OverrideAbilities.AddItem('Slash_RS');
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	return Template;
}

static function X2AbilityTemplate CrusaderStrike()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CrusaderStrike');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityKnifeFighter";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
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
	AdjacencyCondition.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	if (!class'PetRockPerkPack_Perks'.default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

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

	return Template;
}


// Quick Aid

static function X2AbilityTemplate QuickAid()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	
	// Create an effect that will refund the cost of the action
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'QuickAid_Refund';
	Effect.TriggeredEvent = 'QuickAid_Refund';

	// Only refund once per turn
	Effect.CountValueName = 'QuickAid_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames = default.QUICKAID_ABILITIES;
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Create the template using a helper function
	return Passive('QuickAid', "img:///UILibrary_PerkIcons.UIPerk_aidprotocol", false, Effect);
}

//By My Command

static function X2AbilityTemplate ByMyCommand()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	
	// Create an effect that will refund the cost of the action
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'ByMyCommand_Refund';
	Effect.TriggeredEvent = 'ByMCommand_Refund';

	// Only refund once per turn
	Effect.CountValueName = 'ByMyCommand_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames = default.BYMYCOMMAND_ABILITIES;
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Create the template using a helper function
	return Passive('ByMyCommand', "img:///UILibrary_LW_PerkPack.LW_AbilityCommand", false, Effect);
}

//Flashy Plays

static function X2AbilityTemplate FlashyPlays()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	local XMBEffect_AddItemCharges BonusItemEffect;
	local X2AbilityTemplate Template;
	
	// Create an effect that will refund the cost of the action
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'FlashyPlays_Refund';
	Effect.TriggeredEvent = 'FlashyPlays_Refund';

	// Only refund once per turn
	Effect.CountValueName = 'FlashyPlays_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames = default.FLASHYPLAYS_ABILITIES;
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = 1;
	BonusItemEffect.ApplyToNames = class'X2AbilityCost_GrenadeActionPoints'.default.FlashbangTemplates;
	AddSecondaryEffect(Template, BonusItemEffect);

	// Create the template using a helper function
	return Passive('FlashyPlays', "img:///UILibrary_LW_PerkPack.LW_AbilityCommand", false, Effect);
}


// Watchdogs Protection

static function X2AbilityTemplate WatchdogsProtection()
{
	local X2AbilityTemplate			Template;

	Template = PurePassive('WatchdogsProtection', "img:///UILibrary_PerkIcons.UIPerk_aidprotocol",);
	Template.AdditionalAbilities.AddItem('MZAidProtocolHeal');
	Template.AdditionalAbilities.AddItem('MZArmourSystem');
	
	return Template;
}

// Oppressive Fire

static function X2AbilityTemplate OppressiveFire()
{
	local X2AbilityTemplate			Template;

	Template = PurePassive('OppressiveFire', "img:///UILibrary_PerkIcons.UIPerk_aidprotocol",);
	Template.AdditionalAbilities.AddItem('ShadowOps_Focus');
	Template.AdditionalAbilities.AddItem('F_Opportunist');
	
	return Template;
}

static function X2AbilityTemplate ScanningTechnology()
{
	local X2AbilityTemplate			Template;

	Template = PurePassive('ScanningTechnology', "img:///UILibrary_PerkIcons.UIPerk_aidprotocol",);
	Template.AdditionalAbilities.AddItem('MZCombatScanner');
	Template.AdditionalAbilities.AddItem('MZImprovedScanner');
	
	return Template;
}
