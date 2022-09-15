class MZZFocusShot_AbilitySet extends X2Ability config(MZPerkFocus);

var config int FlameRuneshot_ManaCost, AcidRuneshot_ManaCost, CurseRuneshot_ManaCost, StormRuneshot_ManaCost, VenomRuneshot_ManaCost, SnapRuneShot_ManaCost, QuickRuneShot_ManaCost, DrainRuneshot_ManaCost, ManaDrainShot_RestoreMana, ManaDrainShot_Cooldown, TwinRuneshot_ManaCost, TwinRuneShot_FirstShot_ManaCost, SupernalRay_ManaCost;
var config float FlameRuneshot_BonusDamage, AcidRuneshot_BonusDamage, CurseRuneshot_BonusDamage, StormRuneshot_BonusDamage, VenomRuneshot_BonusDamage, DrainRuneshot_Lifesteal, DrainRuneshot_LowHPSteal, SupernalRay_BonusDamage;
var config int BlindRuneShot_ManaCost, BlindRuneShot_BlindTurns, FearRuneShot_ManaCost, BlastRuneshot_ManaCost, LeechRuneshot_ManaCost;
var config float BlindRuneShot_VisionMult, BlastRuneshot_Radius, LeechRuneshot_ShieldSteal;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FlameRuneshot());
	Templates.AddItem(AcidRuneshot());
	Templates.AddItem(CurseRuneshot());
	Templates.AddItem(StormRuneshot());
	Templates.AddItem(VenomRuneshot());

	Templates.AddItem(SnapRuneshot());
	Templates.AddItem(QuickRuneshot());
	Templates.AddItem(TwinRuneshot());
	/*>>*/Templates.AddItem(TwinRuneshot2());
	Templates.AddItem(DrainRuneshot());
	Templates.AddItem(LeechRuneshot());
	Templates.AddItem(ManaDrainShot());

	Templates.AddItem(BlindRuneshot());
	Templates.AddItem(FearRuneshot());
	Templates.AddItem(BlastRuneshot());

	Templates.AddItem(SupernalRay());

	return Templates;
}

static function X2AbilityTemplate FlameRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZFlameRuneshot', "img:///UILibrary_MZChimeraIcons.Grenade_Fire");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.FlameRuneShot_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = default.FlameRuneshot_BonusDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate AcidRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZAcidRuneshot', "img:///UILibrary_MZChimeraIcons.Grenade_Acid");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.AcidRuneShot_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Acid';
	WeaponDamageEffect.BonusDamageScalar = default.AcidRuneshot_BonusDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate CurseRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZCurseRuneshot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodtrail");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.CurseRuneshot_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.CurseRuneshot_BonusDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate StormRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZStormRuneshot', "img:///UILibrary_MZChimeraIcons.Grenade_EMP");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.StormRuneShot_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Electrical';
	WeaponDamageEffect.BonusDamageScalar = default.StormRuneshot_BonusDamage;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate VenomRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZVenomRuneshot', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.VenomRuneShot_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'ParthenogenicPoison';
	WeaponDamageEffect.BonusDamageScalar = default.VenomRuneshot_BonusDamage;
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	return Template;
}

static function X2AbilityTemplate SnapRuneshot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSnapRuneshot', "img:///UILibrary_PerkIcons.UIPerk_snapshot");
	Template.bDontDisplayInAbilitySummary = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperStandardFire');
	Template.HideIfAvailable.AddItem('StandardShot');

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.SnapRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	return Template;
}

static function X2AbilityTemplate QuickRuneshot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZQuickRuneshot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_strike");
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.QuickRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	return Template;
}

static function X2AbilityTemplate BlindRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;
	local X2Effect_Blind					BlindEffect;
	local X2Effect_PersistentStatChange        	DisorientedEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBlindRuneshot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.BlindRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.BlindRuneshot_BlindTurns, default.BlindRuneshot_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.BlindRuneshot_VisionMult, MODOP_PostMultiplication);
	Template.AddTargetEffect(BlindEffect);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = default.BlindRuneshot_BlindTurns;  
	Template.AddTargetEffect(DisorientedEffect);

	return Template;
}

static function X2AbilityTemplate DrainRuneshot()
{
	local X2AbilityTemplate					Template;
	local MZ_Cost_Focus						ManaCost;
	local MZ_Effect_Lifesteal				Lifesteal;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZDrainRuneshot', "img:///UILibrary_PerkIcons.UIPerk_soulsteal");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.DrainRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	Lifesteal = new class'MZ_Effect_LifeSteal';
	Lifesteal.FlatVamp = default.DrainRuneshot_Lifesteal;
	Lifesteal.LowHealthVamp = default.DrainRuneshot_LowHPSteal;
	Template.AddTargetEffect(Lifesteal);

	return Template;
}

static function X2AbilityTemplate LeechRuneshot()
{
	local X2AbilityTemplate					Template;
	local MZ_Cost_Focus						ManaCost;
	local MZ_Effect_ShieldSteal				Lifesteal;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZLeechRuneshot', "img:///UILibrary_PerkIcons.UIPerk_soulsteal");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.LeechRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	Lifesteal = new class'MZ_Effect_ShieldSteal';
	Lifesteal.FlatVamp = default.LeechRuneshot_ShieldSteal;
	//Lifesteal.LowHealthVamp = default.DrainRuneshot_LowHPSteal;
	Template.AddTargetEffect(Lifesteal);

	return Template;
}

static function X2AbilityTemplate ManaDrainShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown					Cooldown;
	local MZ_Effect_FocusRestore			FocusRestoreEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZManaDrainShot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_overcharge");
	Template.bDontDisplayInAbilitySummary = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ManaDrainShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');
	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ModifyFocus = -1;
	FocusRestoreEffect.ManaRestore = -default.ManaDrainShot_RestoreMana;
	Template.AddTargetEffect(FocusRestoreEffect);

	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ManaRestore = default.ManaDrainShot_RestoreMana;
	Template.AddShooterEffect(FocusRestoreEffect);

	return Template;
}

static function X2AbilityTemplate TwinRuneshot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZTwinRuneshot', "img:///UILibrary_PerkIcons.UIPerk_rapidfire");
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//"free" costs are the fake ones used for previews. as such, it's the sum of this and the second shot's cost.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.TwinRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	ManaCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ManaCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.TwinRuneShot_FirstShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	Template.AdditionalAbilities.AddItem('MZTwinRuneshot2');
	Template.PostActivationEvents.AddItem('MZTwinRuneshot2');

	return Template;
}
static function X2AbilityTemplate TwinRuneshot2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityTrigger_EventListener    Trigger;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZTwinRuneshot2', "img:///UILibrary_PerkIcons.UIPerk_rapidfire");
	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityCosts.Length = 0; //need to get rid of AP cost.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.TwinRuneShot_ManaCost - default.TwinRuneShot_FirstShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AbilityTriggers.Length = 0;
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'MZTwinRuneshot2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');


	return Template;
}

static function X2AbilityTemplate FearRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZFearRuneshot', "img:///UILibrary_PerkIcons.UIPerk_panic");
	Template.bDontDisplayInAbilitySummary = false;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.FearRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePanickedStatusEffect());

	return Template;
}

static function X2AbilityTemplate BlastRuneshot()
{
	local X2AbilityTemplate					Template;
	local MZ_Cost_Focus						ManaCost;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityMultiTarget_Radius		TargetStyle;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZBlastRuneshot', "img:///UILibrary_PerkIcons.UIPerk_bigbooms");
	Template.bDontDisplayInAbilitySummary = false;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = default.BlastRuneshot_Radius;
	TargetStyle.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.BlastRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);
	
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Blast';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate SupernalRay()
{
	local X2AbilityTemplate						Template;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local MZ_Damage_AddElemental			WeaponDamageEffect;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZSupernalRay', "img:///UILibrary_MZChimeraIcons.Ability_PhaseLance");
	Template.bDontDisplayInAbilitySummary = false;
	Template.ShotHUDPriority = 380;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	ToHitCalc.bIgnoreCoverBonus = true;
	ToHitCalc.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	//In a line! Zap!
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_Line';
	Template.TargetingMethod = class'X2TargetingMethod_Line';

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.SupernalRay_ManaCost;
	ManaCost.FocusAmount = 3;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'BlazingPinions';
	WeaponDamageEffect.BonusDamageScalar = default.SupernalRay_BonusDamage;
	WeaponDamageEffect.bBypassSustainEffects = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

/*
static function X2AbilityTemplate HomingRuneshot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot('MZHomingRuneshot', "img:///UILibrary_PerkIcons.UIPerk_snapshot");
	Template.bDontDisplayInAbilitySummary = false;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = true;
	ToHitCalc.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.HomingRuneShot_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddTargetEffect(new class'X2Effect_Shredder');

	return Template;
}
*/