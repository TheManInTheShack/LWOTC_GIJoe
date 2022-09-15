class MZZFocusPistol_AbilitySet extends X2Ability config(MZPerkFocus);

var config int FlameFusil_ManaCost, AcidFusil_ManaCost, VenomFusil_ManaCost, CurseFusil_ManaCost, StormFusil_ManaCost;
var config float FlameFusil_BonusDamage, AcidFusil_BonusDamage, VenomFusil_BonusDamage, CurseFusil_BonusDamage, StormFusil_BonusDamage;
var config int TripleFusil_ManaCost, LightningFusil_ManaCost, SilentFusil_ManaCost, FuseFusil_ManaCost, ShadowfallFusil_ManaCost;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FlameFusil());
	Templates.AddItem(AcidFusil());
	Templates.AddItem(VenomFusil());
	Templates.AddItem(CurseFusil());
	Templates.AddItem(StormFusil());

	Templates.AddItem(TripleFusil());
	Templates.AddItem(LightningFusil());

	Templates.AddItem(SilentFusil());
	Templates.AddItem(ShadowfallFusil());
	/*>>*/Templates.AddItem(ShadowfallFusilConceal());
	Templates.AddItem(FuseFusil());

	Templates.AddItem(PurePassive('MZFusilier', "img:///UILibrary_PerkIcons.UIPerk_quickdraw", false));

	return Templates;
}

//function sets up a basic pistol shot. handles boilerplate for new pistol abilities.
static function X2AbilityTemplate CreateBaseFusilAbility(Name AbilityName = 'MZPistolNonStandardShot', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_standardpistol")
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	//local X2Effect_Knockback				KnockbackEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = 320; //class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
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
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MZQuickFusil');
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	//WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//Template.AddTargetEffect(WeaponDamageEffect);

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

	//KnockbackEffect = new class'X2Effect_Knockback';
	//KnockbackEffect.KnockbackDistance = 2;
	//Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'

	return Template;	
}

static function X2AbilityTemplate FlameFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseFusilAbility('MZFlameFusil', "img:///UILibrary_MZChimeraIcons.Grenade_Fire");

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.FlameFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = default.FlameFusil_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate AcidFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;
	
	Template = CreateBaseFusilAbility('MZAcidFusil', "img:///UILibrary_MZChimeraIcons.Grenade_Acid");

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.AcidFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Acid';
	WeaponDamageEffect.BonusDamageScalar = default.AcidFusil_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate StormFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseFusilAbility('MZStormFusil', "img:///UILibrary_MZChimeraIcons.Grenade_EMP");

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.StormFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Electrical';
	WeaponDamageEffect.BonusDamageScalar = default.StormFusil_BonusDamage;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate VenomFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseFusilAbility('MZVenomFusil', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite");

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.VenomFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'ParthenogenicPoison';
	WeaponDamageEffect.BonusDamageScalar = default.VenomFusil_BonusDamage;
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	return Template;
}

static function X2AbilityTemplate CurseFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseFusilAbility('MZCurseFusil', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodtrail");

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.CurseFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.CurseFusil_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate TripleFusil()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;

	Template = CreateBaseFusilAbility('MZTripleFusil', "img:///UILibrary_PerkIcons.UIPerk_fanfire");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Template.AbilityCosts.Length = 0;
	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	
	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.TripleFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	return Template;
}

static function X2AbilityTemplate LightningFusil()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityCooldown             Cooldown;

	Template = CreateBaseFusilAbility('MZLightningFusil', "img:///UILibrary_PerkIcons.UIPerk_lightninghands");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	Template.AbilityCosts.Length = 0;
	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.LightningFusil_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	return Template;
}

static function X2AbilityTemplate SilentFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;
	local X2Condition_UnitProperty          ConcealedCondition;

	Template = CreateBaseFusilAbility('MZSilentFusil', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_sting");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.SilentFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	Template.AbilityShooterConditions.AddItem(ConcealedCondition);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.ConcealmentRule = eConceal_KillShot;

	return Template;
}

static function X2AbilityTemplate ShadowfallFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;
	local X2Condition_UnitProperty          ConcealedCondition;

	Template = CreateBaseFusilAbility('MZShadowfallFusil', "img:///UILibrary_DLC2Images.UIPerk_shadowfall");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.ShadowfallFusil_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ConcealedCondition);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.ConcealmentRule = eConceal_KillShot;

	return Template;
}
static function X2AbilityTemplate ShadowfallFusilConceal()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ConcealOnKill        ConcealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShadowfallFusilConceal');
	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_shadowfall";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ConcealEffect = new class'MZ_Effect_ConcealOnKill';
	ConcealEffect.BuildPersistentEffect(1, true, false, false);
	ConcealEffect.AbilityName = 'MZShadowfallFusil';
	Template.AddTargetEffect(ConcealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FuseFusil()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;
	local X2Effect_TriggerEvent             InsanityEvent;

	Template = CreateBaseFusilAbility('MZFuseFusil', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade");
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.FuseFusil_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.TargetingMethod = class'X2TargetingMethod_Fuse';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);

	Template.ConcealmentRule = eConceal_KillShot;
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