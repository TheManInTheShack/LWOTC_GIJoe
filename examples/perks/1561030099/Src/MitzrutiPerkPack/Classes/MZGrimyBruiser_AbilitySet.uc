class MZGrimyBruiser_AbilitySet extends X2Ability config(GrimyPerkPorts);

var config int DRAW_FIRE_DEFENSE_BOOST, DRAW_FIRE_DEFENSE_REDUCTION, DRAW_FIRE_COOLDOWN, DRAW_FIRE_DURATION, DRAW_FIRE_RADIUS, DRAW_FIRE_ARMOR;
var config int GUNPOINT_COOLDOWN, GUNPOINT_AIM, GUNPOINT_DAMAGE, GUNPOINT_SPREAD, GUNPOINT_STUN_DURATION, GUNPOINT_STUN_CHANCE;
var config int FLASHPOINT_DAMAGE, FLASHBANG_AMMO_BONUS, RETURN_FIRE_COUNT;
var config int BOLSTER_ARMOR, BOLSTER_ARMOR_DURATION;
var config bool GUNPOINT_GENERATES_HIGH_COVER;

var config int TASER_AMMO_COUNT, CAUSTIC_AMMO_COUNT, GRAPESHOT_AMMO_COUNT;
var config int GRAPESHOT_TILE_WIDTH, GRAPESHOT_TILE_LENGTH, GRAPE_BURN_DMG, GRAPE_BURN_SPREAD;
var config int TASER_STUN_DURATION, TASER_STUN_CHANCE, CAUSTIC_SLUG_SHRED; 
var config float TASER_DAMAGE_MULT, CAUSTIC_DAMAGE_MULT, GRAPESHOT_DAMAGE_MULT;

var config int MARKED_COOLDOWN, PREPARATION_COOLDOWN;

var config array<name> Flashbangs;

var localized string TaserShotBonusName, GrapeShotBonusName, CausticSlugBonusName;
var localized string DrawFireAllyEffectName, DrawFireAllyEffectDesc, DrawFireSelfEffectName, DrawFireSelfEffectDesc;

static function array<X2DataTemplate> CreateTemplates() {
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(GrimyDrawFire('GrimyDrawFire',default.DRAW_FIRE_COOLDOWN,default.DRAW_FIRE_DEFENSE_BOOST,default.DRAW_FIRE_DEFENSE_REDUCTION,default.DRAW_FIRE_DURATION,default.DRAW_FIRE_RADIUS, default.DRAW_FIRE_ARMOR));
	Templates.AddItem(GrimyGunPoint('GrimyGunPoint', "img:///UILibrary_PerkIcons.UIPerk_bullrush", default.GUNPOINT_COOLDOWN, default.GUNPOINT_DAMAGE, default.GUNPOINT_Spread, default.BOLSTER_ARMOR, default.BOLSTER_ARMOR_Duration));
	Templates.Additem(GrimyReturnFire('GrimySurvival', "img:///UILibrary_PerkIcons.UIPerk_battlefatigue"));
	Templates.AddItem(GrimyReturnFire('GrimySpotter', "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget"));
	Templates.AddItem(PurePassive('GrimyBolsterPassive', "img:///UILibrary_PerkIcons.UIPerk_body_shield"));
	Templates.AddItem(PurePassive('GrimyNeedlePointPassive', "img:///UILibrary_PerkIcons.UIPerk_ammo_fletchette"));
	Templates.AddItem(GrimyFlashpoint('GrimyFlashpoint', "img:///UILibrary_PerkIcons.UIPerk_ace_hole", default.FLASHPOINT_DAMAGE, default.FLASHBANG_AMMO_BONUS));
	Templates.AddItem(PurePassive('GrimyIntimidationPassive', "img:///UILibrary_PerkIcons.UIPerk_intimidate"));

	Templates.AddItem(GrimyEnrage('GrimyEnrage', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage"));

	Templates.AddItem(GrimyTaserShot('GrimyTaserShot', 'GrimyTaserShotDamage', "img:///UILibrary_PerkIcons.UIPerk_ammo_bluescreen",default.TASER_AMMO_COUNT));
	Templates.AddItem(GrimyGrapeShot('GrimyGrapeShot', 'GrimyGrapeShotDamage', "img:///UILibrary_PerkIcons.UIPerk_ammo_talon",default.GRAPESHOT_AMMO_COUNT));
	Templates.AddItem(GrimyCausticSlug('GrimyCausticSlug', 'GrimyCausticSlugDamage', "img:///UILibrary_PerkIcons.UIPerk_ammo_needle", default.CAUSTIC_AMMO_COUNT, default.CAUSTIC_SLUG_SHRED));

	Templates.AddItem(GrimyBonusDamage('GrimyTaserShotDamage','GrimyTaserShot',default.TASER_DAMAGE_MULT,false,true, default.TaserShotBonusName));
	Templates.AddItem(GrimyBonusDamage('GrimyGrapeShotDamage','GrimyGrapeShot',default.GRAPESHOT_DAMAGE_MULT,true,false, default.GrapeShotBonusName));
	Templates.AddItem(GrimyBonusDamage('GrimyCausticSlugDamage','GrimyCausticSlug',default.CAUSTIC_DAMAGE_MULT,false, false, default.CausticSlugBonusName));

	// this is actually a headhunter skill. shhhh.
	Templates.AddItem(GrimyPreparation('GrimyPreparation',"img:///UILibrary_PerkIcons.UIPerk_timeshift",default.PREPARATION_COOLDOWN, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, 0, false));

	return Templates;
}

static function X2AbilityTemplate GrimyDrawFire(name TemplateName, int ThisCooldown, int DefenseBoost, int DefenseReduction, int Duration, int Radius, int Armor) {
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput		InputTrigger;
	local X2Effect_PersistentStatChange		DefenseEffect;
	local X2AbilityMultiTarget_Radius		MultiTarget;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	// This ability is a free action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = ThisCooldown;
	Template.AbilityCooldown = Cooldown;

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = Radius;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = false;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield
	DefenseEffect = new class'X2Effect_PersistentStatChange';
	DefenseEffect.BuildPersistentEffect(Duration, false, true, , eGameRule_PlayerTurnBegin);
	DefenseEffect.AddPersistentStatChange(eStat_Defense, DefenseBoost);
	DefenseEffect.SetDisplayInfo(ePerkBuff_Bonus, default.DrawFireAllyEffectName, default.DrawFireAllyEffectDesc, Template.IconImage, true);
	Template.AddMultiTargetEffect(DefenseEffect);

	// Self Armor Effect
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(Duration, false, true, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, 100);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, DefenseReduction);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.DrawFireSelfEffectName, default.DrawFireSelfEffectDesc, Template.IconImage, true);
	Template.AddShooterEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TargetGettingMarked_BuildVisualization;
	
	return Template;
}

static function X2AbilityTemplate GrimyReturnFire(name TemplateName, string IconImage) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_CoveringFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.bCrossClassEligible = false;
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	FireEffect = new class'Grimy_Effect_CoveringFire';
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.MaxPointsPerTurn = default.RETURN_FIRE_COUNT;
	FireEffect.bPreEmptiveFire = true;
	FireEffect.bOncePerTarget = true;
	FireEffect.GameStateEffectClass = class'Grimy_EffectState';
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.OverrideAbilities.AddItem('ReturnFire');
	Template.bCrossClassEligible = false;       //  this can only work with pistols, which only sharpshooters have

	return Template;
}

static function X2DataTemplate GrimyGunPoint(name TemplateName, string IconImage, int ThisCooldown, int Damage, int Spread, int Armor, int ArmorDuration, optional int BonusCharges = 0) {
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints		ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2Effect_Stunned				    StunnedEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_GenerateCover			CoverEffect;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect, PoisonEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitType			UnitTypeCondition;
	
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.CustomFireAnim = 'FF_Melee';
	Template.IconImage = IconImage;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	// Action Points
	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'GrimyGunpoint';
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Cooldown
	if ( ThisCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = ThisCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	if ( BonusCharges > 0 )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}	
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = default.GUNPOINT_AIM;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'Grimy_ConditionCover');
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenAssassin');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenWarlock');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenSniper');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Stun');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	UnitEffectsCondition.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue.Damage = Damage;
	WeaponDamageEffect.EffectDamageValue.Spread = Spread;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Stunned effect
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.GUNPOINT_STUN_DURATION, default.GUNPOINT_STUN_CHANCE, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	// Cover Effect
	CoverEffect = new class'X2Effect_GenerateCover';
	if ( !default.GUNPOINT_GENERATES_HIGH_COVER ) {	CoverEffect.CoverType = CoverForce_Low; }
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	CoverEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(CoverEffect);

	// Poison Effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyNeedlePointPassive');
	PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	X2Effect_ApplyWeaponDamage(PoisonEffect.ApplyOnTick[0]).EffectDamageValue.Damage = 2;
	PoisonEffect.EffectTickedFn = none;
	PoisonEffect.TargetConditions.AddItem(AbilityCondition);
	X2Effect_ApplyWeaponDamage(PoisonEffect.ApplyOnTick[0]).bAllowFreeKill = false;
	Template.AddTargetEffect(PoisonEffect);

	// Armor Effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyBolsterPassive');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(ArmorDuration, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, Armor);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(PersistentStatChangeEffect);

	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowAmmoEffects = false;
	Template.bSkipMoveStop = true;
	
	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = BruiserMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	return Template;
}

// Updates the bruiser to take cover
static function XComGameState BruiserMoveEndAbility_BuildGameState(XComGameStateContext Context) {
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local X2EventManager EventManager;
	
	EventManager = `XEVENTMGR;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

	// finalize the movement portion of the ability
	class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false); //Do not apply costs at this time.

	// build the "fire" animation for the slash
	TypicalAbility_FillOutGameState(NewGameState); //Costs applied here.
	
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

	/*
	Context.InputContext.SourceObject.ObjectID

	if( UnitState.CanTakeCover() )
	{
		NewContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_ClaimCover);
		NewContext.UnitRef = UnitState.GetReference();
		`XCOMGAME.GameRuleset.SubmitGameStateContext(NewContext);
	}*/

	return NewGameState;
}

static function X2AbilityTemplate GrimyFlashpoint(name TemplateName, string IconImage, int BonusDamage, int Bonus) {
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local Grimy_Effect_BonusWeaponDamage	MixEffect;
	local Grimy_BonusItemCharges		AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	MixEffect = new class'Grimy_Effect_BonusWeaponDamage';
	MixEffect.BuildPersistentEffect(1, true, true, true);
	MixEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	MixEffect.Bonus = BonusDamage;
	MixEffect.WeaponNames = default.Flashbangs;
	Template.AddTargetEffect(MixEffect);

	AmmoEffect = new class'Grimy_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.ItemTemplateNames = default.Flashbangs;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyEnrage(name TemplateName, string IconImage) {
	local X2AbilityTemplate						Template;
	local Grimy_EnrageActionPoints			ThreeActionPoints;
	local X2Effect_Persistent				Dummy;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = IconImage;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ThreeActionPoints = new class'Grimy_EnrageActionPoints';
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	ThreeActionPoints.NumActionPoints = 1;
	ThreeActionPoints.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(ThreeActionPoints);

	Dummy = new class'X2Effect_Persistent';
	Dummy.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(Dummy);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyPreparation(name TemplateName, string IconImage, int BonusCooldown, int HUDPriority, optional int BonusCharges = 0 , optional bool CrossClass = false) {
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local MZ_Effect_TurnStartActionPoint	ThreeActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.bCrossClassEligible = CrossClass;
	Template.IconImage = IconImage;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	ThreeActionPoints = new class'MZ_Effect_TurnStartActionPoint';
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ThreeActionPoints.NumActionPoints = 1;
	ThreeActionPoints.BuildPersistentEffect(2,false,true,,eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(ThreeActionPoints);

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TargetGettingMarked_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate GrimyTaserShot(name TemplateName, name BonusName, string IconImage, int BonusCharges)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_PersistentStatChange		PoisonEffect;
	local X2Condition_UnitProperty			UnitPropCondition;
	local X2Effect_Stunned				    StunnedEffect;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AdditionalAbilities.AddItem(BonusName);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyNeedlePointPassive');
	PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	PoisonEffect.EffectTickedFn = none;
	PoisonEffect.TargetConditions.AddItem(AbilityCondition);
	X2Effect_ApplyWeaponDamage(PoisonEffect.ApplyOnTick[0]).bAllowFreeKill = false;
	Template.AddTargetEffect(PoisonEffect);
	
	// Stunned effect
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.TASER_STUN_DURATION, default.TASER_STUN_CHANCE);
	StunnedEffect.bRemoveWhenSourceDies = false;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeRobotic = true;
	StunnedEffect.TargetConditions.AddItem(UnitPropCondition);

	Template.AddTargetEffect(StunnedEffect);

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
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_QuickdrawActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	ACtionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.EffectDamageValue.Pierce = 1000;
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.OnlyOnDeath = false; 
	Template.AddTargetEffect(KnockbackEffect);

	return Template;	
}

static function X2AbilityTemplate GrimyGrapeShot(name TemplateName, name BonusName, string IconImage, int BonusCharges)
{
	local X2AbilityTemplate						Template;	
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Cone				ConeMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2Effect_ApplyDirectionalWorldDamage	WorldDamage;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	local X2AbilityCharges						Charges;
	local X2AbilityCost_Charges					ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	Template.AdditionalAbilities.AddItem(BonusName);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.Deadeye;

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bOverrideAim = true;
	
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.GRAPE_BURN_DMG,default.GRAPE_BURN_SPREAD));

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = true;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = true;
	WorldDamage.bApplyToWorldOnHit = false;
	WorldDamage.bApplyToWorldOnMiss = false;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = 100;
	Template.AddMultiTargetEffect(WorldDamage);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.GRAPESHOT_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength = default.GRAPESHOT_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.IconImage = IconImage;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.ActionFireClass = class'X2Action_Fire_SaturationFire';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;	
}

static function X2AbilityTemplate GrimyCausticSlug(name TemplateName, name BonusName, string IconImage, int BonusCharges, int BonusShred)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	Template.AdditionalAbilities.AddItem(BonusName);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Icon Properties
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Template.bAllowAmmoEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.EffectDamageValue.Shred = BonusShred;
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// Voice events
	Template.ActivationSpeech = 'BulletShred';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	Template.bCrossClassEligible = true;

	return Template;	
}


static function X2AbilityTemplate GrimyBonusDamage(name TemplateName, name AbilityName, float BonusDamage, optional bool ExcludeRobotic = false, optional bool ExcludeOrganic = false, optional string BonusName = "")
{
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = BonusDamage;
	DamageEffect.AbilityName = AbilityName;
	DamageEffect.bExcludeRobotic = ExcludeRobotic;
	DamageEffect.bExcludeOrganic = ExcludeOrganic;
	DamageEffect.FriendlyName = BonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

simulated function TargetGettingMarked_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				ShooterUnitRef;
	local StateObjectReference				TargetUnitRef;
	local XComGameState_Ability				Ability;
	local X2AbilityTemplate					AbilityTemplate;
	local AbilityInputContext				AbilityContext;
	
	local VisualizationActionMetadata		EmptyTrack;
	local VisualizationActionMetadata		ActionMetadata;

	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;	
	local X2Action_PlayAnimation            PlayAnimation;

	local Actor								TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface				TargetVisualizerInterface, ShooterVisualizerInterface;
	local int								EffectIndex;

	local name								ApplyResult;
	

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	AbilityContext = Context.InputContext;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	
	//Configure the visualization track for the shooter
	//****************************************************************************************
	ShooterUnitRef = Context.InputContext.SourceObject;
	ShooterVisualizer = History.GetVisualizer(ShooterUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(ShooterUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShooterUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(ShooterUnitRef.ObjectID);

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'HL_SignalPoint';

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Source effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, ActionMetadata, ApplyResult);
		}
	}

	if (ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

		//****************************************************************************************

	//Configure the visualization track for the target
	//****************************************************************************************
	TargetUnitRef = Context.InputContext.PrimaryTarget;
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);
					
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Target effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);
		}

		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	
		//****************************************************************************************
}