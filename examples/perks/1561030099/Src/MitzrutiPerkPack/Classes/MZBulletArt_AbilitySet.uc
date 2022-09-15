// This is an Unreal Script
class MZBulletArt_AbilitySet extends X2Ability dependson (XComGameStateContext_Ability) config(MZPerkPack);

var config int ExtraBullets_Charges, HighCalibre_Damage, HighAgony_Damage, BulletBleed_Turns, BulletBleed_Damage;
var config float MoreDakka_Damage, ExplosiveArts_Radius, PsiBullet_Blind_Vision, RuptureX_Radius, PsiBullet_VisionMult;
var config array<name> Bullet_Arts;
var config int BlazeBullet_Charges, BlazeBullet_Cooldown, BlazeBullet_Burn_Damage, BlazeBullet_Burn_Spread, BlazeBullet_TurboBlaze_Damage, BlazeBullet_TurboBlaze_Spread;
var config int ToxicBullet_Charges, ToxicBullet_Cooldown, ToxicBullet_Lure_Turns, ToxicX_Disorient_Turns, ToxicBullet_PoisonCloudDuration;
var config int AcidBullet_Charges, AcidBullet_Cooldown, AcidBullet_Acid_Damage, AcidBullet_Acid_Spread, AcidBullet_Shred, AcidX_DamageDown, AcidX_Turns;
var config int MeleeBullet_Charges, MeleeBullet_Cooldown, MeleeX_HexHuntBonus;
var config int PsiBullet_Charges, PsiBullet_Cooldown, PsiX_Stun, PsiX_MultiStun, PsiBullet_BlindTurns, PsiBullet_CloudDuration;
var config int ShockBullet_Charges, ShockBullet_Cooldown, ShockBullet_HackDown;
var config int RuptureBullet_Charges, RuptureBullet_Cooldown, RuptureBullet_Rupture, RuptureX_DemoChance;
var config int HailBullet_Charges;

var localized string RustEffectName, RustEffectDesc, MeleeBulletVsSectoidEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddMoreDakka());
	Templates.AddItem(AddBulletArtCharges());
	Templates.AddItem(AddHighCalibreBulletArts());
	Templates.AddItem(AddHighAgonyBulletArts());
	Templates.AddItem(PurePassive('MZExplosiveBulletArts', "img:///UILibrary_PerkIcons.UIPerk_biggestbooms"));
	Templates.AddItem(PurePassive('MZBleedingBulletArts', "img:///UILibrary_XPACK_Common.UIPerk_bleeding"));
	Templates.AddItem(PurePassive('MZChronoTrigger', "img:///UILibrary_PerkIcons.UIPerk_timeshift"));
	Templates.AddItem(AddBlazeBullet());
	Templates.AddItem(PrereqPassive('MZBlazeBulletX', "img:///UILibrary_PerkIcons.UIPerk_burn", 'MZBlazeBullet'));
	Templates.AddItem(AddToxicBullet());
	Templates.AddItem(PrereqPassive('MZToxicBulletX', "img:///UILibrary_PerkIcons.UIPerk_sedation", 'MZToxicBullet'));
	Templates.AddItem(AddAcidBullet());
	Templates.AddItem(PrereqPassive('MZAcidBulletX', "img:///GrimyClassAN_Icons.UIPerk_ToxicCloud", 'MZAcidBullet'));
	Templates.AddItem(AddMeleeBullet());
	Templates.AddItem(AddMeleeBulletVsSectoid());
	Templates.AddItem(AddMeleeBulletX("img:///UILibrary_PerkIcons.UIPerk_deathblossom"));
	Templates.AddItem(AddPsiBullet());
	Templates.AddItem(PrereqPassive('MZPsiBulletX', "img:///UILibrary_PerkIcons.UIPerk_disoriented", 'MZPsiBullet'));
	Templates.AddItem(AddShockBullet());
	Templates.AddItem(PrereqPassive('MZShockBulletX', "img:///UILibrary_PerkIcons.UIPerk_codex_techvulnerability", 'MZShockBullet'));
	Templates.AddItem(AddRuptureBullet());
	Templates.AddItem(AddRuptureBulletPassive());
	Templates.AddItem(PrereqPassive('MZRuptureBulletX', "img:///UILibrary_PerkIcons.UIPerk_demolition", 'MZRuptureBullet'));
	Templates.AddItem(AddHailBullet());

	return Templates;
}


static function X2AbilityTemplate Add_MZNonStandardShot( Name AbilityName='MZNonStandardShot', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard", bool DontShowInPerkList = false, bool bNoAmmoCost = false, bool bAllowBurning = false, bool bAllowDisoriented = false)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2AbilityToHitCalc_StandardAim	AimType;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = DontShowInPerkList;
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = 380;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
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

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = false;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//note: the goal with this is a standard shot that DOES NOT HAVE any target effects. they'll hve to be added by the effect that creates them.

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	//Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	//Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	//Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	//Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	AimType = new class'X2AbilityToHitCalc_StandardAim';
	AimType.bOnlyMultiHitWithSuccess = true;
	Template.AbilityToHitCalc = AimType;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
	
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	//class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);
	//Template.PostActivationEvents.AddItem('StandardShotActivated'); technically, no.

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//not currently using for anything valid to headshot with.
	// Template.AlternateFriendlyNameFn = class'X2Ability_WeaponCommon'.static.StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;	
}

static function X2AbilityTemplate AddBulletArtCharges() {
	local X2AbilityTemplate									Template;
	local Grimy_BonusAbilityCharges					AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBulletArtCharges');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_wholenineyards";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'Grimy_BonusAbilityCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.NumCharges = default.ExtraBullets_Charges;
	AmmoEffect.AbilityNames = default.Bullet_Arts;
	AmmoEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddHighCalibreBulletArts() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_MultiAbilityDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHighCalibreBulletArts');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_shelllauncher";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_MultiAbilityDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.BaseDamage = default.HighCalibre_Damage;
	DamageEffect.AbilityNames = default.Bullet_Arts;
	DamageEffect.bMainOnly = true;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddHighAgonyBulletArts() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_MultiAbilityDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHighAgonyBulletArts');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_poisoncloud";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_MultiAbilityDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.BaseDamage = default.HighAgony_Damage;
	DamageEffect.AbilityNames = default.Bullet_Arts;
	DamageEffect.bDOTOnly = true;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddMoreDakka() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_MultiAbilityDamage	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMoreDakka');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_MultiAbilityDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.MoreDakka_Damage;
	DamageEffect.AbilityNames = default.Bullet_Arts;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddBlazeBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_Burning							BurningEffect;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_ManualOverride			ChronoEffect;

	Template = Add_MZNonStandardShot('MZBlazeBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.BlazeBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BlazeBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Fire');
	Template.AddTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BlazeBullet_Burn_Damage, default.BlazeBullet_Burn_Spread);
	Template.AddTargetEffect(BurningEffect);

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBlazeBulletX');
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BlazeBullet_TurboBlaze_Damage, default.BlazeBullet_TurboBlaze_Spread);
	BurningEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BurningEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);
	
	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0.1;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BlazeBullet_Burn_Damage, default.BlazeBullet_Burn_Spread);
	BurningEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BurningEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Fire');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBlazeBulletX');
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BlazeBullet_TurboBlaze_Damage, default.BlazeBullet_TurboBlaze_Spread);
	BurningEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BurningEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Fire');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Fire');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	

	return Template;
}

static function X2AbilityTemplate AddToxicBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_PersistentStatChange		PoisonEffect;
	local X2Effect_PersistentStatChange		DisorientEffect;
	local X2Effect_Persistent				LureEffect;
	local X2Effect_AlertTheLost				LostActivateEffect;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Effect_ApplyPoisonToWorld		PoisonWorldEffect;

	Template = Add_MZNonStandardShot('MZToxicBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_fletchette");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.ToxicBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ToxicBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Poison');
	Template.AddTargetEffect(WeaponDamageEffect);

	PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	Template.AddTargetEffect(PoisonEffect);

	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.iNumTurns = default.ToxicBullet_Lure_Turns;
	Template.AddTargetEffect(LureEffect);

	LostActivateEffect = new class'X2Effect_AlertTheLost';
	Template.AddTargetEffect(LostActivateEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZToxicBulletX');
	DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientEffect.iNumTurns = default.ToxicX_Disorient_Turns;
	DisorientEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisorientEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0.1;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	PoisonEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(PoisonEffect);

	PoisonWorldEffect = new class'X2Effect_ApplyPoisonToWorld';
	PoisonWorldEffect.Duration = default.ToxicBullet_PoisonCloudDuration;
	Template.AddMultiTargetEffect(PoisonWorldEffect);

	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.iNumTurns = default.ToxicBullet_Lure_Turns;
	LureEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(LureEffect);

	LostActivateEffect = new class'X2Effect_AlertTheLost';
	LostActivateEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(LostActivateEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Poison');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZToxicBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientEffect.iNumTurns = default.ToxicX_Disorient_Turns;
	DisorientEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisorientEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Poison');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Poison');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddAcidBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Burning					AcidEffect;
	local Grimy_Effect_ReduceDamage			RustEffect;
	local X2Effect_ManualOverride			ChronoEffect;

	Template = Add_MZNonStandardShot('MZAcidBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_stiletto");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.AcidBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AcidBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.EffectDamageValue.Shred = WeaponDamageEffect.EffectDamageValue.Shred + default.AcidBullet_Shred;
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Acid');
	Template.AddTargetEffect(WeaponDamageEffect);

	AcidEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(default.AcidBullet_Acid_Damage, default.AcidBullet_Acid_Spread);
	Template.AddTargetEffect(AcidEffect);

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyAcidToWorld');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAcidBulletX');

	RustEffect = new class'Grimy_Effect_ReduceDamage';
	RustEffect.BonusDamage = default.AcidX_DamageDown;
	RustEffect.BuildPersistentEffect(default.AcidX_Turns, true, false, false, eGameRule_PlayerTurnBegin);
	RustEffect.TargetConditions.AddItem(AbilityCondition);
	RustEffect.SetDisplayInfo(ePerkBuff_Penalty, default.RustEffectName , default.RustEffectDesc, "img:///GrimyClassAN_Icons.UIPerk_ToxicCloud", true);
	Template.AddTargetEffect(RustEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AcidEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(default.BulletBleed_Damage, default.AcidBullet_Acid_Spread);
	AcidEffect.DuplicateResponse = eDupe_Allow;
	AcidEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(AcidEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	AcidEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(default.BulletBleed_Damage, default.AcidBullet_Acid_Spread);
	AcidEffect.DuplicateResponse = eDupe_Allow;
	AcidEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(AcidEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0.1;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.EffectDamageValue.Shred = WeaponDamageEffect.EffectDamageValue.Shred + default.AcidBullet_Shred;
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Acid');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	AcidEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(AcidEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAcidBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	RustEffect = new class'Grimy_Effect_ReduceDamage';
	RustEffect.BonusDamage = default.AcidX_DamageDown;
	RustEffect.BuildPersistentEffect(default.AcidX_Turns, true, false, false, eGameRule_PlayerTurnBegin);
	RustEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(RustEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Acid');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Acid');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddMeleeBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_PersistentStatChange		FlinchEffect;
	local X2Effect_ManualOverride			ChronoEffect;

	Template = Add_MZNonStandardShot('MZMeleeBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_ap");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.MeleeBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MeleeBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.bPreventsTargetTeleport = true;
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	FlinchEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	FlinchEffect.iNumTurns = 0;
	FlinchEffect.DamageTypes.Length = 0;
	FlinchEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(FlinchEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	FlinchEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	FlinchEffect.iNumTurns = 0;
	FlinchEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(FlinchEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AdditionalAbilities.AddItem('MZMeleeBulletVsSectoid');

	return Template;
}

static function X2AbilityTemplate AddMeleeBulletVsSectoid() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_SwordBulletVsSectoid	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMeleeBulletVsSectoid');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_ap";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_SwordBulletVsSectoid';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName = 'MZMeleeBullet';
	DamageEffect.FriendlyName = default.MeleeBulletVsSectoidEffectName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddMeleeBulletX(string IconImage) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusHexHunter	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMeleeBulletX');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = IconImage;
	Template.Hostility = eHostility_Neutral;

	Template.PrerequisiteAbilities.AddItem('MZMeleeBullet');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusHexHunter';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.MeleeX_HexHuntBonus;
	DamageEffect.AbilityName = 'MZMeleeBullet';
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddPsiBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Effect_Stunned					StunEffect;
	local MZ_Effect_ApplyCurseToWorld		PoisonCloudEffect;
	local X2Effect_Blind						BlindEffect;

	Template = Add_MZNonStandardShot('MZPsiBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_needle");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.PsiBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PsiBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Psi';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(WeaponDamageEffect);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.PsiBullet_BlindTurns, default.PsiBullet_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.PsiBullet_VisionMult, MODOP_PostMultiplication);
	Template.AddTargetEffect(BlindEffect);
	Template.AddMultiTargetEffect(BlindEffect);
	
	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
	Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.PsiX_Stun, 100, false);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZPsiBulletX');
	StunEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(StunEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	PoisonCloudEffect = new class'MZ_Effect_ApplyCurseToWorld';
	PoisonCloudEffect.Duration = default.PsiBullet_CloudDuration;
	Template.AddMultiTargetEffect(PoisonCloudEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Psi';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Psi');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.PsiX_MultiStun, 100, false);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZPsiBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	StunEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(StunEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Psi';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Psi');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Psi';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Psi');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddShockBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Effect_ApplyWeaponDamage		ShockDamageEffect;
	local X2Condition_UnitProperty          RobotProperty;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_PersistentStatChange		BluescreenEffect;
	local X2Effect_ManualOverride			ChronoEffect;

	Template = Add_MZNonStandardShot('MZShockBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_bluescreen");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.ShockBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShockBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_EnergyShield'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	RobotProperty = new class'X2Condition_UnitProperty';
	RobotProperty.ExcludeOrganic = true;
	RobotProperty.TreatMindControlledSquadmateAsHostile = true;
	BluescreenEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.ShockBullet_HackDown, RobotProperty);
	Template.AddTargetEffect(BluescreenEffect);
		
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZShockBulletX');
	ShockDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShockDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	ShockDamageEffect.DamageTypes.Length=0;
	ShockDamageEffect.DamageTypes.AddItem('Electrical');
	ShockDamageEffect.bIgnoreArmor = true;
	ShockDamageEffect.TargetConditions.AddItem(AbilityCondition);
	ShockDamageEffect.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect(ShockDamageEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	BluescreenEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.ShockBullet_HackDown, RobotProperty);
	BluescreenEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BluescreenEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_EnergyShield'.default.EffectName);
	RemoveEffects.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(RemoveEffects);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZShockBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	ShockDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShockDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	ShockDamageEffect.DamageTypes.Length=0;
	ShockDamageEffect.DamageTypes.AddItem('Electrical');
	ShockDamageEffect.bIgnoreArmor = true;
	ShockDamageEffect.TargetConditions.AddItem(AbilityCondition);
	ShockDamageEffect.TargetConditions.AddItem(RobotProperty);
	Template.AddMultiTargetEffect(ShockDamageEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZShockBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	ShockDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	ShockDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	ShockDamageEffect.DamageTypes.Length=0;
	ShockDamageEffect.DamageTypes.AddItem('Electrical');
	ShockDamageEffect.bIgnoreArmor = true;
	ShockDamageEffect.TargetConditions.AddItem(AbilityCondition);
	ShockDamageEffect.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect(ShockDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZShockBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	ShockDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	ShockDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	ShockDamageEffect.DamageTypes.Length=0;
	ShockDamageEffect.DamageTypes.AddItem('Electrical');
	ShockDamageEffect.bIgnoreArmor = true;
	ShockDamageEffect.TargetConditions.AddItem(AbilityCondition);
	ShockDamageEffect.TargetConditions.AddItem(RobotProperty);
	Template.AddMultiTargetEffect(ShockDamageEffect);

	return Template;
}

static function X2AbilityTemplate AddRuptureBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_ApplyDirectionalWorldDamage WorldDamage;
	local X2Effect_ManualOverride			ChronoEffect;

	Template = Add_MZNonStandardShot('MZRuptureBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_talon");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.RuptureBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RuptureBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Explosion');
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = default.RuptureBullet_Rupture;
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZRuptureBulletX');
	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 30;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = false;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = default.RuptureX_DemoChance;
	WorldDamage.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WorldDamage);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	TargetStyle.AddAbilityBonusRadius('MZRuptureBulletX', default.RuptureX_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Explosion');
	WeaponDamageEffect.EffectDamageValue.Rupture = default.RuptureBullet_Rupture;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZRuptureBulletX');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 30;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = false;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = false;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = default.RuptureX_DemoChance;
	WorldDamage.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WorldDamage);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Explosion');
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = default.RuptureBullet_Rupture;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Explosion');
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = default.RuptureBullet_Rupture;
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AdditionalAbilities.AddItem('MZRuptureBulletPassive');

	return Template;
}

static function X2AbilityTemplate AddRuptureBulletPassive() {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusDamage				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRuptureBulletPassive');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_ap";
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.AbilityName = 'MZRuptureBullet';
	DamageEffect.BaseDamage = -default.RuptureBullet_Rupture;
	DamageEffect.bMainOnly = true;
	//DamageEffect.FriendlyName = default.MeleeBulletVsSectoidEffectName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddHailBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local Grimy_Cost_ActionPoints       ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost; 
	local X2Effect_ManualOverride			ChronoEffect;
	local X2AbilityToHitCalc_StandardAim	StandardAim;

	Template = Add_MZNonStandardShot('MZHailBullet', "img:///UILibrary_PerkIcons.UIPerk_ammo_tracer");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');

	// Hail Bullet cannot crit. this helps limit the top end of it's power.
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('MZHailBulletContinue');
	ActionPointCost.BonusPoint = 'MZHailBulletContinue';
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.HailBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	Template.AddTargetEffect(WeaponDamageEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);

	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//More Dakka Bonus Hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate PrereqPassive(name AbilityName, string IconImage, name PrereqName) {
	local X2AbilityTemplate					Template;

	Template = PurePassive(AbilityName, IconImage);
	Template.PrerequisiteAbilities.AddItem(PrereqName);

	return Template;
}
