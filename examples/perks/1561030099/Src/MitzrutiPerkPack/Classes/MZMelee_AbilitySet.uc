class MZMelee_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);

var config int CatsMeow_AimBonus, CatsMeow_CritBonus;
var config int Sledgehammer_Knockback, Sledgehammer_Cooldown, DivingSlash_Cooldown, BurialBlade_Cooldown, DaySword_Cooldown, NineSmash_Cooldown, BladeRave_Cooldown;
var config int BladeDance_Cooldown, NightSword_Cooldown, Shellbust_Cooldown, Shellbust_Shred, Shellbust_AP;
var config float Sledgehammer_DamageMod, BowlingBash_radius, BladeDance_Radius, BladeArtist_BonusMult, Blastar_VisionMult, SweepingSpin_Radius, Bonecrusher_Range, FullAssault_BonusDamage, DaySword_ShieldSteal, BladeRave_FinalAimMod, BladeRave_DamageScalar, NineSmash_FinalAimMod, NineSmash_DamageScalar;
var config int BlitzAttack_Cooldown, BlitzAttackConeEndDiameterTiles, BlitzAttackConeLengthTiles;
var config int Hellcry_Cooldown, Hellcry_Debuff, Hellcry_Turns, Blastar_Cooldown, Blastar_Turns, BladeArtist_MinCooldown, BladeArtist_BonusFlat;
var config array<name> BladeArtist_IncludeAbility, DoubleGrip_WeaponCats, DoubleGrip_EmptyCats;
var config int AbyssalBlade_HPCost, CrimsonTide_Length, CrimsonTide_Width, CrimsonTide_HPCost, HarvestScythe_Width, HarvestScythe_Length, DragonBreath_Cooldown, DragonBreath_Length, DragonBreath_Width;
var config float AbyssalBlade_DamageMod, HarvestScythe_MultiTargetLifeSteal, KillingStroke_BonusMult, KillingStroke_BetaBonusMult, AhrimansDemense_Radius, AhrimansDemense_VisionMult, BlastWave_BonusScalar, BlastWave_FirstBonusScalar;
var config int MacabreWaltz_HPCost, MacabreWaltz_ChaserHPCost, MacabreWaltz_Width, MacabreWaltz_Length, ShadeScratch_HPCost, AhrimansDemense_CloudDuration, AhrimansDemense_BlindTurns;
var config int FrostwolfBite_Cooldown, FrostwolfBite_Range, ShadowThorn_Range, ShadowThorn_Cooldown, ShadowThorn_HPCost, KillingStroke_Charges, KillingStroke_MinHPCost, KillingStroke_AimMod, KillingStroke_CritMod, KillingStroke_GrazeMod;
var config int DoubleGrip_Dmg, DoubleGrip_DmgPerTier, DoubleGrip_Pierce, DoubleGrip_PiercePerTier, FullAssault_Cooldown, FullAssault_SelfStun, SweepingSpin_Cooldown, BlastWave_Cooldown, BlastWave_Range;
var config int SacredTetrad_Cooldown, SacredTetrad_Range, ParivirBlade_BonusChargePerAbility, ShimmeringBlade_Charges, ShimmeringBlade_ConfuseTurns, ShimmeringBlade_ConfuseChance, SkyfuryBlade_Charges, SkyfuryBlade_PanicChance, LifethreadBlade_Charges, LifethreadBlade_ZombifyTurns, LifethreadBlade_LureTurns;
var config bool DeadCutter_AlwaysShow;
var config array<name> DragonBreathNames;

var localized string HellcryEffectName, HellcryEffectDesc, KillingStrokeBonusName, BlastWaveDebuffBonusName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddCatsMeowAbility());
	Templates.AddItem(AddSledgehammerAbility());
	/*>>*/Templates.AddItem(AddSledgehammerChaser());	
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZBowlingBash', "img:///UILibrary_PerkIcons.UIPerk_beserker_punch", 'MZSledgehammer'));
	/*>>*/Templates.AddItem(class'MZGrimyHeadHunter_AbilitySet'.static.GrimyBonusDamage('MZSledgehammerBonus','MZSledgehammer', default.Sledgehammer_DamageMod));
	Templates.AddItem(AddBladeDanceAbility());
	/*>>*/Templates.AddItem(AddChaserSlash());
	/*>>*/Templates.AddItem(AddConsumeMomentum());
	Templates.AddItem(AddBlitzAttack());
	Templates.AddItem(AddNightSword());
	Templates.AddItem(MZHarvestScythe());
	Templates.AddItem(AddShellbustStab());
	/*>>*/Templates.AddItem(AddShellbustStabBonus());
	Templates.AddItem(AddHellcryPunch());
	Templates.AddItem(AddBlastarPunch());
	Templates.AddItem(AddBladeArtist());
	Templates.AddItem(AddDoubleGrip());
	Templates.AddItem(AddAbyssalBlade());
	Templates.AddItem(AddMacabreWaltz());
	/*>>*/Templates.AddItem(AddMacabreChaser());
	Templates.AddItem(MZCrimsonTide());
	Templates.AddItem(AddShadeScratch());
	/*>>*/Templates.AddItem(AddShadeScratchConceal());
	Templates.AddItem(AddFrostwolfBite());
	Templates.AddItem(AddShadowThorn());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZAhrimansDemense', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", 'MZShadowThorn'));
	Templates.AddItem(AddKillingStroke());
	/*>>*/Templates.AddItem(AddKillingStrokeBonus());
	Templates.AddItem(AddFullAssault());
	Templates.AddItem(AddBonecrusher());
	/*>>*/Templates.AddItem(AddBonecrusherAttack());
	Templates.AddItem(AddSweepingSpin());
	Templates.AddItem(AddBlastWave());
	/*>>*/Templates.AddItem(AddBlastWavePassive());
	Templates.AddItem(DivingSlash());
	/*>>>*/Templates.AddItem(DivingSlashReset());
	Templates.AddItem(Reblossom());
	/*>>*/Templates.AddItem(ReblossomAttack());
	Templates.AddItem(ShimmeringBlade());
	Templates.AddItem(SkyfuryBlade());
	Templates.AddItem(LifethreadBlade());
	Templates.AddItem(RollingCutter());
	Templates.AddItem(DeadCutter());
	Templates.AddItem(BurialBlade());
	Templates.AddItem(DashingMomentum());
	Templates.AddItem(DaySword());
	Templates.AddItem(BladeRave());

	Templates.AddItem(AddSacredTetrad());
	Templates.AddItem(AddSacredTetradChaser());

	Templates.AddItem(FireDragonBreath());
	Templates.AddItem(PoisonDragonBreath());
	Templates.AddItem(AcidDragonBreath());
	Templates.AddItem(ThunderDragonBreath());

	Templates.AddItem(PurePassive('MZRipjackBleed', "img:///UILibrary_XPACK_Common.UIPerk_bleeding"));

	return Templates;
}

static function X2AbilityTemplate CreateBaseSlashAbility(Name AbilityName = 'MZNonStandardSlash', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash", optional bool bAllowBurning=false)
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
	if ( bAllowBurning)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
		Template.AddShooterEffectExclusions(SkipExclusions);
	}
	else
	{
		Template.AddShooterEffectExclusions();
	}

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

static function X2AbilityTemplate AddCatsMeowAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ToHitModifier        CritModEffect;
	local X2Effect_ToHitModifier        HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCatsMeow');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	//this is the same icon as blademaster. they shouldn't be present on the same class, so is fine.
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, default.CatsMeow_AimBonus, Template.LocFriendlyName, , true, false, true, true);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'CatsMeowAim';
	Template.AddTargetEffect(HitModEffect);

	CritModEffect = new class'X2Effect_ToHitModifier';
	CritModEffect.AddEffectHitModifier(eHit_Crit, default.CatsMeow_CritBonus, Template.LocFriendlyName, , true, false, true, true);
	CritModEffect.BuildPersistentEffect(1, true, false, false);
	CritModEffect.EffectName = 'CatsMeowCrit';
	Template.AddTargetEffect(CritModEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;

}

static function X2AbilityTemplate AddSledgehammerAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSledgehammer');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_punch";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Sledgehammer_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
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

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('KnockbackDamage');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.Sledgehammer_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.AdditionalAbilities.AddItem('MZSledgehammerChaser');
	Template.AdditionalAbilities.AddItem('MZSledgehammerBonus');
	Template.PostActivationEvents.AddItem('FireMZSledgehammerChaser');

	Template.DamagePreviewFn = SledgehammerDamagePreview;

	return Template;
}

function bool SledgehammerDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZSledgehammerChaser');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddSledgehammerChaser()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSledgehammerChaser');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'FireMZSledgehammerChaser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.ChainShotListener;
	EventListener.ListenerData.Priority = 40; //hopefully, wait until after KB
	Template.AbilityTriggers.AddItem(EventListener);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.AddAbilityBonusRadius('MZBowlingBash', default.BowlingBash_radius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
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

static function X2AbilityTemplate AddBladeDanceAbility()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_TriggerEvent             InsanityEvent;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBladeDance');

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BladeDance_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BladeDance_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.NumTargetsRequired = 1;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'FireMZChaserSlash';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bladestorm";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bShowActivation = true;

	Template.TargetingMethod = class'X2TargetingMethod_PathTarget';

	Template.ActivationSpeech = 'Rend';

	Template.PostActivationEvents.AddItem('MZConsumeMomentum');

	Template.AdditionalAbilities.AddItem('MZChaserSlash');
	Template.AdditionalAbilities.AddItem('MZConsumeMomentum');

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

	Template.DamagePreviewFn = ChaserSlashDamagePreview;
	Template.bPreventsTargetTeleport = true;
	Template.bFriendlyFireWarning = false;

	return Template;
}

function bool ChaserSlashDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	//AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZChaserSlash');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate AddChaserSlash()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZChaserSlash');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'FireMZChaserSlash';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
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

	Template.bUniqueSource = true;	//used by both blade dance and blitz attack. better to not have duplicates around.

	return Template;
}

static function X2AbilityTemplate AddConsumeMomentum()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2AbilityCost_ActionPoints        ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZConsumeMomentum');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'MZConsumeMomentum';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Priority = 30; //low to try to let most other stuff resolve first.
	Template.AbilityTriggers.AddItem(EventListener);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTargetConditions.Length = 0;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bUniqueSource = true;		//Used by multiple abilities. Better to not have duplicates around.

	return Template;
}

static function X2AbilityTemplate AddBlitzAttack()
{
	local X2AbilityTemplate					Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_TriggerEvent             InsanityEvent;

	Template = class'X2Ability_TemplarAbilitySet'.static.Rend('MZBlitzAttack');
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ShotHUDPriority = 340;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlitzAttack_Cooldown;
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
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_CrowdControl";

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.BlitzAttackConeEndDiameterTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.BlitzAttackConeLengthTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'FireMZChaserSlash';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.bFriendlyFireWarning = false;

	Template.PostActivationEvents.AddItem('MZConsumeMomentum');

	Template.AdditionalAbilities.AddItem('MZChaserSlash');
	Template.AdditionalAbilities.AddItem('MZConsumeMomentum');
	
	return Template;
}

static function X2AbilityTemplate AddNightSword()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZNightSword', "img:///UILibrary_MZChimeraIcons.Ability_Scythe");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.NightSword_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(new class'MZ_Effect_LifeSteal');

	return Template;
}

static function X2AbilityTemplate AddShellbustStab()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZShellbustStab', "img:///UILibrary_PerkIcons.UIPerk_damagecover");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Shellbust_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassShields = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_EnergyShield'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	Template.AdditionalAbilities.AddItem('MZShellbustStabBonus');

	return Template;
}
static function X2AbilityTemplate AddShellbustStabBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_Shellbust				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShellbustStabBonus');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_Shellbust';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName= 'MZShellbustStab';
	DamageEffect.BonusShred = default.Shellbust_Shred;
	DamageEffect.BonusAP = default.Shellbust_AP;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddHellcryPunch()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Effect_ReduceDamage				DamageEffect;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZHellcryPunch', "img:///UILibrary_MZChimeraIcons.Ability_DisarmingSlash");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Hellcry_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.AddTargetEffect(new class'MZ_Effect_DisableWeapon');

	DamageEffect = new class'Grimy_Effect_ReduceDamage';
	DamageEffect.BonusDamage = default.Hellcry_Debuff;
	DamageEffect.BuildPersistentEffect(default.Hellcry_Turns, true, false, false, eGameRule_PlayerTurnEnd);
	DamageEffect.SetDisplayInfo(ePerkBuff_Penalty, default.HellcryEffectName , default.HellcryEffectDesc, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	return Template;
}

static function X2AbilityTemplate AddBlastarPunch()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Blind					BlindEffect;
	local X2Effect_PersistentStatChange        	DisorientedEffect;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZBlastarPunch', "img:///UILibrary_MZChimeraIcons.Ability_CripplingBlow");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Blastar_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.Blastar_Turns, default.Blastar_VisionMult);
	BlindEffect.ApplyChance = 100;
	Template.AddTargetEffect(BlindEffect);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = default.Blastar_Turns;
	DisorientedEffect.DamageTypes.length = 0;    
	DisorientedEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(DisorientedEffect);

	return Template;
}

static function X2AbilityTemplate AddBladeArtist() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_BladeArtist	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBladeArtist');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_BladeArtist';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.BonusMult = default.BladeArtist_BonusMult;
	DamageEffect.MinCooldown = default.BladeArtist_MinCooldown;
	DamageEffect.BonusFlat = default.BladeArtist_BonusFlat;
	DamageEffect.IncludeAbility = default.BladeArtist_IncludeAbility;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddDoubleGrip() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_DoubleGrip	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDoubleGrip');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_meleevulnerability";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_DoubleGrip';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.DoubleGrip_Dmg;
	DamageEffect.PerTier = default.DoubleGrip_DmgPerTier;
	DamageEffect.APBonus = default.DoubleGrip_Pierce;
	DamageEffect.APPerTier = default.DoubleGrip_PiercePerTier;
	DamageEffect.DoubleGripWeaponCats = default.DoubleGrip_WeaponCats;
	DamageEffect.DoubleGripEmptyCats = default.DoubleGrip_EmptyCats;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate AddAbyssalBlade()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;
	local Grimy_AbilityCost_HP				HPCost;

	Template = CreateBaseSlashAbility('MZAbyssalBlade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_rend");
	Template.ShotHUDPriority = 340;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "C34144";

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.AbyssalBlade_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	// Damage Effect
	//
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.AbyssalBlade_DamageMod;
	WeaponDamageEffect.bBypassSustainEffects=true;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate AddMacabreWaltz()
{
	local X2AbilityTemplate					Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_TriggerEvent             InsanityEvent;
	local Grimy_AbilityCost_HP				HPCost;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	Template = class'X2Ability_TemplarAbilitySet'.static.Rend('MZMacabreWaltz');
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ShotHUDPriority = 340;
	Template.AbilityIconColor = "C34144";

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);	

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.MacabreWaltz_HPCost + default.MacabreWaltz_ChaserHPCost;
	HPCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(HPCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.MacabreWaltz_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	//	These are all handled in the editor if you want to change them!
//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
	Template.bSkipExitCoverWhenFiring = false;
//END AUTOGENERATED CODE: Template Overrides 'ArcWave'
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_CrowdControl";

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.MacabreWaltz_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.MacabreWaltz_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'FireMZMacabreChaserSlash';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	Template.AbilityTargetEffects.Length = 0;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.bFriendlyFireWarning = false;
	
	Template.PostActivationEvents.AddItem('MZConsumeMomentum');

	Template.AdditionalAbilities.AddItem('MZMacabreChaser');
	Template.AdditionalAbilities.AddItem('MZConsumeMomentum');
	
	return Template;
}

static function X2AbilityTemplate AddMacabreChaser()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;
	local Grimy_AbilityCost_HP				HPCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMacabreChaser');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'FireMZMacabreChaserSlash';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Priority = 60; //incresed to try and trigger before pod scampers when alerted.
	Template.AbilityTriggers.AddItem(EventListener);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.MacabreWaltz_ChaserHPCost;
	Template.AbilityCosts.AddItem(HPCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityTargetStyle =  new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "StandardMelee";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'

	return Template;
}

static function X2AbilityTemplate MZCrimsonTide()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local Grimy_AbilityCost_HP				HPCost;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCrimsonTide');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.CrimsonTide_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	//	no more cooldown for now
	//Template.AbilityCooldown = new class'X2AbilityCooldown_Rend';

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.CrimsonTide_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.CrimsonTide_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.bBypassSustainEffects=true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
	Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.PostActivationEvents.AddItem('RendActivated');

	Template.bAllowBonusWeaponEffects = true;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bSkipMoveStop = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'FF_ArcWave_MeleeA';
	Template.CustomFireKillAnim = 'FF_ArcWave_MeleeKillA';
	Template.CustomMovingFireAnim = 'MV_ArcWave_MeleeA';
	Template.CustomMovingFireKillAnim = 'MV_ArcWave_MeleeKillA';
	Template.CustomMovingTurnLeftFireAnim = 'MV_ArcWave_RunTurn90LeftMeleeA';
	Template.CustomMovingTurnLeftFireKillAnim = 'MV_ArcWave_RunTurn90LeftMeleeKillA';
	Template.CustomMovingTurnRightFireAnim = 'MV_ArcWave_RunTurn90RightMeleeA';
	Template.CustomMovingTurnRightFireKillAnim = 'MV_ArcWave_RunTurn90RightMeleeKillA';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
	Template.bSkipExitCoverWhenFiring = false;
	//END AUTOGENERATED CODE: Template Overrides 'ArcWave'

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bSkipExitCoverWhenFiring = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
//END AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bFriendlyFireWarning = false;

	return Template;
}

static function X2AbilityTemplate MZHarvestScythe()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Effect_LifeSteal				LifeSteal;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHarvestScythe');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Scythe";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.NightSword_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	//StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.HarvestScythe_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.HarvestScythe_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.DamageTypes.AddItem('Acid');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	LifeSteal = new class'MZ_Effect_LifeSteal';
	LifeSteal.FlatVamp = default.HarvestScythe_MultiTargetLifeSteal;
	LifeSteal.Flyover = false;
	Template.AddMultiTargetEffect(LifeSteal);
	Template.AddTargetEffect(new class'MZ_Effect_LifeSteal');

	//Template.PostActivationEvents.AddItem('RendActivated');

	Template.bAllowBonusWeaponEffects = true;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bSkipMoveStop = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'FF_ArcWave_MeleeA';
	Template.CustomFireKillAnim = 'FF_ArcWave_MeleeKillA';
	Template.CustomMovingFireAnim = 'MV_ArcWave_MeleeA';
	Template.CustomMovingFireKillAnim = 'MV_ArcWave_MeleeKillA';
	Template.CustomMovingTurnLeftFireAnim = 'MV_ArcWave_RunTurn90LeftMeleeA';
	Template.CustomMovingTurnLeftFireKillAnim = 'MV_ArcWave_RunTurn90LeftMeleeKillA';
	Template.CustomMovingTurnRightFireAnim = 'MV_ArcWave_RunTurn90RightMeleeA';
	Template.CustomMovingTurnRightFireKillAnim = 'MV_ArcWave_RunTurn90RightMeleeKillA';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
	Template.bSkipExitCoverWhenFiring = false;
	//END AUTOGENERATED CODE: Template Overrides 'ArcWave'

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Rend'
	Template.bFriendlyFireWarning = false;

	Template.PrerequisiteAbilities.AddItem('MZNightSword');
	Template.OverrideAbilities.AddItem('MZNightSword');

	return Template;
}

static function X2AbilityTemplate AddShadeScratch()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local Grimy_AbilityCost_HP					HPCost;
	local X2Condition_Visibility			VisCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShadeScratch');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'Momentum';
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.ShadeScratch_HPCost;
	Template.AbilityCosts.AddItem(HPCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible=true;
	//VisCondition.bVisibleToAnyAlly=true;
	VisCondition.bExcludeGameplayVisible=true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;
	Template.LostSpawnIncreasePerUse = 0;
	Template.ConcealmentRule = eConceal_Always;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.AdditionalAbilities.AddItem('MZShadeScratchConceal');

	return Template;
}

static function X2AbilityTemplate AddShadeScratchConceal()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ConcealOnKill        ConcealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShadeScratchConceal');
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_shadowfall";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ConcealEffect = new class'MZ_Effect_ConcealOnKill';
	ConcealEffect.BuildPersistentEffect(1, true, false, false);
	ConcealEffect.AbilityName = 'MZShadeScratch';
	Template.AddTargetEffect(ConcealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddFrostwolfBite()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			TargetCondition;
	local X2Effect_TriggerEvent             InsanityEvent;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFrostwolfBite');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FrostwolfBite_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_Fuse'; //class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.FrostwolfBite_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.DamagePreviewFn = FrostWolfBiteDamagePreview;

	return Template;
}

function bool FrostWolfBiteDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
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

static function X2AbilityTemplate AddShadowThorn()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			TargetCondition;
	local Grimy_AbilityCost_HP					HPCost;
	local X2Condition_AbilityProperty		AbilityCondition;
	local MZ_Effect_ApplyCurseToWorld		PoisonCloudEffect;
	local X2Effect_Blind						BlindEffect;
	local X2AbilityMultiTarget_Radius		MultiTargetStyle;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShadowThorn');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_poisonclaws";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShadowThorn_Cooldown;
	Template.AbilityCooldown = Cooldown;

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.ShadeScratch_HPCost;
	Template.AbilityCosts.AddItem(HPCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	MultiTargetStyle = new class'X2AbilityMultiTarget_Radius';
	MultiTargetStyle.fTargetRadius = 0;
	MultiTargetStyle.bIgnoreBlockingCover = true;
	MultiTargetStyle.AddAbilityBonusRadius('MZAhrimansDemense', default.AhrimansDemense_Radius);
	Template.AbilityMultiTargetStyle = MultiTargetStyle;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.ShadowThorn_Range * class'XComWorldData'.const.WORLD_StepSize;
	TargetCondition.IsConcealed = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.AhrimansDemense_BlindTurns, default.AhrimansDemense_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.AhrimansDemense_VisionMult, MODOP_PostMultiplication);
	Template.AddTargetEffect(BlindEffect);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAhrimansDemense');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.AhrimansDemense_BlindTurns, default.AhrimansDemense_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.AhrimansDemense_VisionMult, MODOP_PostMultiplication);
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BlindEffect);

	PoisonCloudEffect = new class'MZ_Effect_ApplyCurseToWorld';
	PoisonCloudEffect.Duration = default.AhrimansDemense_CloudDuration;
	//PoisonCloudEffect.BonusTileEnteredEffects.AddItem(BlindEffect);
	//PoisonCloudEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(PoisonCloudEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;
	Template.LostSpawnIncreasePerUse = 0;
	Template.ConcealmentRule = eConceal_Always;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate AddKillingStroke()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local Grimy_AbilityCost_HP				HPCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKillingStroke');
	
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 399;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.KillingStroke_MinHPCost;
	HPCost.PercentCost = 1.0;
	Template.AbilityCosts.AddItem(HPCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.KillingStroke_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
	
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

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;

	Template.AdditionalAbilities.AddItem('MZKillingStrokeBonus');
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate AddKillingStrokeBonus() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_KillingStroke				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKillingStrokeBonus');

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
	DamageEffect.AbilityName= 'MZKillingStroke';
	DamageEffect.BonusMult = default.KillingStroke_BonusMult;
	DamageEffect.BetaBonusMult = default.KillingStroke_BetaBonusMult;
	DamageEffect.AimMod = default.KillingStroke_AimMod;
	DamageEffect.CritMod = default.KillingStroke_CritMod;
	DamageEffect.GrazeMod = default.KillingStroke_GrazeMod;
	DamageEffect.FriendlyName = default.KillingStrokeBonusName;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate AddFullAssault()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local MZ_Damage_AddElemental		    WeaponDamageEffect;
	local X2Effect_Stunned					DazedEffect;

	Template = CreateBaseSlashAbility('MZFullAssault', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_chosendazed");
	Template.ShotHUDPriority = 360;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FullAssault_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = '';
	WeaponDamageEffect.BonusDamageScalar = default.FullAssault_BonusDamage;
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	DazedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.FullAssault_SelfStun, 100, false);
	//class'X2StatusEffects_XPack'.static.CreateDazedStatusEffect(10, 100);
	DazedEffect.TargetConditions.Length = 0;
	DazedEffect.DamageTypes.Length = 0;
	DazedEffect.bApplyOnHit = true;
	DazedEffect.bApplyOnMiss = true;
	Template.AddShooterEffect(DazedEffect);

	// Voice events
	Template.ActivationSpeech = 'FanFire';
	Template.SourceMissSpeech = 'SwordMiss';

	Template.CustomFireAnim = 'FF_MeleeKill';
	Template.CustomMovingFireAnim = 'MV_MeleeKill';
	Template.CustomMovingTurnLeftFireAnim = 'MV_RunTurn90LeftMeleeKill';
	Template.CustomMovingTurnRightFireAnim = 'MV_RunTurn90RightMeleeKill';

	return Template;
}

static function X2AbilityTemplate AddBonecrusher()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZBonecrusher', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZBonecrusherAttack');

	return Template;
}
static function X2AbilityTemplate AddBonecrusherAttack()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyReflectDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityTrigger_EventListener	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBonecrusherAttack');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_CounterAttack";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bReactionFire = true;
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = BonecrusherListener;
	Template.AbilityTriggers.AddItem(Trigger);

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.Bonecrusher_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyReflectDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	WeaponDamageEffect.bIgnoreBaseDamage=false;
	WeaponDamageEffect.DamageTypes.Length = 0;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;
	Template.LostSpawnIncreasePerUse = 0;
	Template.ConcealmentRule = eConceal_Always;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}
static function EventListenerReturn BonecrusherListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState						NewGameState;
	local XComGameState_Unit				UnitState, SourceUnit; //, Attacker;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		SourceUnit = XComGameState_Unit(EventSource);
		//If (SourceUnit.IsEnemyUnit()){}

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Templar Reflect Data");
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceUnit.ObjectID));
		UnitState.ReflectedAbilityContext = AbilityContext;
		`TACTICALRULES.SubmitGameState(NewGameState);

		class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZBonecrusherAttack', AbilityContext.InputContext.SourceObject);
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddSweepingSpin()
{
	local X2AbilityTemplate						Template;
	local X2AbilityMultiTarget_Radius           MultiTargetRadius;
	local X2Effect_ApplyWeaponDamage            DamageEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;
	local X2AbilityCooldown						Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSweepingSpin');
//BEGIN AUTOGENERATED CODE: Template Overrides 'IonicStorm'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.ActivationSpeech = 'IonicStorm';
	Template.CinescriptCameraType = "Templar_IonicStorm";
//END AUTOGENERATED CODE: Template Overrides 'IonicStorm'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 320;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_IonicStorm";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bFriendlyFireWarning = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SweepingSpin_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_PathTarget';

	//Appears to be failing to apply.
	MultiTargetRadius = new class'X2AbilityMultiTarget_Radius';
	MultiTargetRadius.fTargetRadius = default.SweepingSpin_Radius;
	MultiTargetRadius.bExcludeSelfAsTargetIfWithinRadius = true;
	MultiTargetRadius.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTargetRadius;

	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	//Just Uses Weapon Damage. nothing fancy.
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.DamageTypes.AddItem( 'Melee' );
	Template.AddMultiTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bSkipExitCoverWhenFiring = false;
	//Template.CustomFireAnim = 'HL_IonicStorm';
	//Template.DamagePreviewFn = LashOutDamagePreview;

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


static function X2AbilityTemplate AddBlastWave()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local array<name>                       SkipExclusions;
	//local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityMultiTarget_Line			LineMultiTarget;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBlastWave');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Quake";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlastWave_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardMelee;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.BlastWave_Range;
	Template.AbilityTargetStyle = CursorTarget;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.TileWidthExtension = 1;
	Template.AbilityMultiTargetStyle = LineMultiTarget;
	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.BlastWave_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.bExplosiveDamage = true;
	//Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;

	Template.CustomFireAnim = 'HL_MZBlastWave';
	Template.bShowActivation = true;
	Template.ActionFireClass = class'X2Action_Fire_Wave';
	//Template.CinescriptCameraType = "ChosenAssassin_HarborWave";
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.AdditionalAbilities.AddItem('MZBlastWavePassive');

	return Template;
}
static function X2AbilityTemplate AddBlastWavePassive()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_BlastWaveDamageFromDebuffs			RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBlastWavePassive');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave";;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_BlastWaveDamageFromDebuffs';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.AbilityNames.AddItem('MZBlastWave');
	RegenEffect.BonusScalar = default.BlastWave_BonusScalar;
	RegenEffect.FirstDebuffBonusScalar = default.BlastWave_FirstBonusScalar;
	RegenEffect.FriendlyName = default.BlastWaveDebuffBonusName;
	//RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.bUniqueSource = true;

	return Template;
}

static function X2AbilityTemplate Reblossom()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZReblossom', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZReblossomAttack');

	return Template;
}
static function X2AbilityTemplate ReblossomAttack()
{
	local X2AbilityTemplate                 Template;
	//local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2AbilityTrigger_EventListener	Listener;
	local X2Condition_UnitProperty			AdjacencyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZReblossom');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bladestorm";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bReactionFire = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	//Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');
	Listener = new class'X2AbilityTrigger_EventListener';
    Listener.ListenerData.Filter = eFilter_Unit;
    Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
    Listener.ListenerData.EventFn = ReblossomEventListener;
    Listener.ListenerData.EventID = 'AbilityActivated';
    Listener.ListenerData.Priority = 40;    //  default Priority is 50, lowering the value so this ability triggers AFTER the attack goes through
    Template.AbilityTriggers.AddItem(Listener);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	//Prevent repeatedly hammering on a unit with Bladestorm triggers.
	//(This effect does nothing, but enables many-to-many marking of which Bladestorm attacks have already occurred each turn.)
	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'BladestormTarget';
	BladestormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('BladestormTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

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
static function EventListenerReturn ReblossomEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Item            WeaponState;
   
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
    SourceUnit = XComGameState_Unit(EventSource);
    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
 
    if (AbilityContext != none && AbilityState != none && WeaponState != none && SourceUnit != none && TargetUnit != none)
    {   //  if this is an offensive ability that actually hit the enemy, and the enemy is still alive
        if (AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
        {
			// if the ability is considered melee. may have some odd interations with some modded abilities.
			if ( X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bMeleeAttack && !X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire) /*&& X2WeaponTemplate(WeaponState.GetMyTemplate()).InventorySlot == eInvSlot_PrimaryWeapon*/ 
			{
				//Attempt to fire Reblossom.
				class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZReblossom', AbilityContext.InputContext.PrimaryTarget);
			}
		}
    }
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddSacredTetrad()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSacredTetrad');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DualSword";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SacredTetrad_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.SacredTetrad_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityMultiTargetConditions.AddItem(new class'MZ_Condition_DualWield');

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.TargetConditions.AddItem(new class'MZ_Condition_DualWield');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.AdditionalAbilities.AddItem('MZSacredTetradChaser');
	Template.PostActivationEvents.AddItem('FireMZSacredTetradChaser');

	Template.DamagePreviewFn = SacredTetradDamagePreview;

	return Template;
}
static function X2AbilityTemplate AddSacredTetradChaser()
{
	local X2AbilityTemplate                 Template;
	//local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTrigger_EventListener		EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSacredTetradChaser');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DualSword";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'FireMZSacredTetradChaser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.ChainShotListener;
	EventListener.ListenerData.Priority = 40; //hopefully, wait until after KB
	Template.AbilityTriggers.AddItem(EventListener);

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

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
function bool SacredTetradDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	ChainShot2Ref = AbilityOwner.FindAbility('MZSacredTetradChaser');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	return true;
}

static function X2AbilityTemplate ShimmeringBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2Effect_PersistentStatChange		ConfuseEffect;

	Template = CreateBaseSlashAbility('MZShimmeringBlade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk");
	
	Template.ShotHUDPriority = 320;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.ShimmeringBlade_Charges;
	Charges.AddBonusCharge('MZHoarfrostBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZLifethreadBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZSkyfuryBlade', default.ParivirBlade_BonusChargePerAbility);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('MZHoarfrostBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZShimmeringBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZSkyfuryBlade');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ConfuseEffect = class'X2StatusEffects'.static.CreateConfusedStatusEffect(default.ShimmeringBlade_ConfuseTurns);
	ConfuseEffect.ApplyChance = default.ShimmeringBlade_ConfuseChance;
	Template.AddTargetEffect(ConfuseEffect);
	Template.AddMultiTargetEffect(ConfuseEffect);

	return Template;
}

static function X2AbilityTemplate SkyfuryBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2Effect_Panicked					ConfuseEffect;

	Template = CreateBaseSlashAbility('MZSkyfuryBlade', "img:///UILibrary_MZChimeraIcons.Grenade_Acid");
	
	Template.ShotHUDPriority = 320;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.SkyfuryBlade_Charges;
	Charges.AddBonusCharge('MZHoarfrostBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZShimmeringBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZLifethreadBlade', default.ParivirBlade_BonusChargePerAbility);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('MZHoarfrostBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZShimmeringBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZSkyfuryBlade');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'electrical';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('electrical');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ConfuseEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	ConfuseEffect.ApplyChance = default.SkyfuryBlade_PanicChance;
	Template.AddTargetEffect(ConfuseEffect);
	Template.AddMultiTargetEffect(ConfuseEffect);

	return Template;
}

static function X2AbilityTemplate LifethreadBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2Effect_Persistent				LureEffect;

	Template = CreateBaseSlashAbility('MZLifethreadBlade', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk");
	
	Template.ShotHUDPriority = 320;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.LifethreadBlade_Charges;
	Charges.AddBonusCharge('MZHoarfrostBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZShimmeringBlade', default.ParivirBlade_BonusChargePerAbility);
	Charges.AddBonusCharge('MZSkyfuryBlade', default.ParivirBlade_BonusChargePerAbility);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('MZHoarfrostBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZShimmeringBlade');
	ChargeCost.SharedAbilityCharges.AddItem('MZSkyfuryBlade');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('acid');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'acid';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.LifethreadBlade_ZombifyTurns));

	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.iNumTurns = default.LifethreadBlade_LureTurns;
	Template.AddMultiTargetEffect(LureEffect);
	Template.AddMultiTargetEffect(new class'X2Effect_AlertTheLost');

	return Template;
}

static function X2AbilityTemplate DivingSlash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZDivingSlash', "img:///UILibrary_MZChimeraIcons.Ability_EvasiveStrike");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bMoveCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DivingSlash_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AdditionalAbilities.AddItem('MZDivingSlashReset');

	return Template;
}
static function X2AbilityTemplate DivingSlashReset()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_DivingSlashReset            Effect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDivingSlashReset');
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_EvasiveStrike";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'MZ_Effect_DivingSlashReset ';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate RollingCutter()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

	Template = CreateBaseSlashAbility('MZRollingCutter', "img:///UILibrary_PerkIcons.UIPerk_swordSlash", true);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bMoveCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardMelee;

	//Prevent repeatedly hammering on a unit with Bladestorm triggers.
	//(This effect does nothing, but enables many-to-many marking of which Bladestorm attacks have already occurred each turn.)
	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'BladestormTarget';
	BladestormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('BladestormTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate DeadCutter()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Cost_AP_FreeIfLethal			ActionPointsCost;

	Template = CreateBaseSlashAbility('MZDeadCutter', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes", true);
	Template.ShotHUDPriority = 310;
	if ( !default.DeadCutter_AlwaysShow )
	{
		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	}
	Template.AbilityIconColor = "acd373";

	Template.AbilityCosts.Length = 0;
	ActionPointsCost = new class'MZ_Cost_AP_FreeIfLethal';
	ActionPointsCost.iNumPoints = 1;
	ActionPointsCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointsCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_TurnUndead');

	return Template;
}

static function X2AbilityTemplate BurialBlade()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Cost_AP_FreeIfLethal			ActionPointsCost;

	Template = CreateBaseSlashAbility('MZBurialBlade', "img:///UILibrary_PerkIcons.UIPerk_reaper");
	Template.ShotHUDPriority = 360;

	Template.AbilityCosts.Length = 0;
	ActionPointsCost = new class'MZ_Cost_AP_FreeIfLethal';
	ActionPointsCost.iNumPoints = 1;
	ActionPointsCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointsCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BurialBlade_Cooldown;
	Template.AbilityCooldown = Cooldown;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate DashingMomentum()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_DashingMomentum				Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDashingMomentum');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_DashingMomentum';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate DaySword()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Effect_ShieldSteal				Lifesteal;

	Template = CreateBaseSlashAbility('MZDaySword', "img:///UILibrary_MZChimeraIcons.Ability_Scythe");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DaySword_Cooldown;
	Template.AbilityCooldown = Cooldown;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	Lifesteal = new class'MZ_Effect_ShieldSteal';
	Lifesteal.FlatVamp = default.DaySword_Shieldsteal;
	Template.AddTargetEffect(Lifesteal);

	return Template;
}

static function X2AbilityTemplate BladeRave()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2AbilityToHitCalc_StandardMelee	StandardMelee;

	Template = CreateBaseSlashAbility('MZBladeRave', "img:///UILibrary_MZChimeraIcons.Ability_Subdue");
	Template.ShotHUDPriority = 330;

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.FinalMultiplier = default.BladeRave_FinalAimMod;
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityToHitOwnerOnMissCalc = StandardMelee;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BladeRave_Cooldown;
	Template.AbilityCooldown = Cooldown;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.BonusDamageScalar = default.BladeRave_DamageScalar;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bNoDoubleGrip = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.CustomFireAnim = 'FF_MeleeKill';
	Template.CustomMovingFireAnim = 'MV_MeleeKill';
	Template.CustomMovingTurnLeftFireAnim = 'MV_RunTurn90LeftMeleeKill';
	Template.CustomMovingTurnRightFireAnim = 'MV_RunTurn90RightMeleeKill';

	return Template;
}

static function X2AbilityTemplate DragonBreath(name TemplateName, name FireAnimName, string IconImage)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local MZ_Cooldown_AbilitySetReduces		Cooldown;
	local name								BreathName;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'MZ_Cooldown_AbilitySetReduces';
	Cooldown.iNumTurns = default.DragonBreath_Cooldown;
	foreach default.DragonBreathNames(BreathName)
	{
		if ( TemplateName != BreathName )
		{
			Cooldown.AbilityInSet.AddItem(BreathName);
		}
	}
	Template.AbilityCooldown = Cooldown;
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.DragonBreath_Length;
	Template.AbilityTargetStyle = CursorTarget;
	
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	//ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.DragonBreath_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.DragonBreath_Length * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = 330;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.CustomFireAnim = FireAnimName;
	//May need to do a bunch of actionfireclasses. but first, try to not.
	Template.ActionFireClass = class'X2Action_Fire_Flamethrower';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;	

	return Template;	
}

static function X2AbilityTemplate FireDragonBreath()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;

	Template = DragonBreath( 'MZFireDragonBreath', 'FF_MZFireDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_torch");

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'fire';
	WeaponDamageEffect.BonusDamageScalar=1.0f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1) );

	return Template;
}

static function X2AbilityTemplate PoisonDragonBreath()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;

	Template = DragonBreath( 'MZPoisonDragonBreath', 'FF_MZPoisonDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit");

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'poison';
	WeaponDamageEffect.BonusDamageScalar=1.0f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('poison');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreatePoisonedStatusEffect() );

	return Template;
}

static function X2AbilityTemplate AcidDragonBreath()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;

	Template = DragonBreath( 'MZAcidDragonBreath', 'FF_MZAcidDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob");

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'acid';
	WeaponDamageEffect.BonusDamageScalar=1.0f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2,1) );

	return Template;
}

static function X2AbilityTemplate ThunderDragonBreath()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;

	Template = DragonBreath( 'MZThunderDragonBreath', 'FF_MZThunderDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_electro_pulse");

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'electrical';
	WeaponDamageEffect.BonusDamageScalar=1.0f;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('electrical');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}