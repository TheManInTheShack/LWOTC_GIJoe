class MZZFocusMelee_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkFocus);

var config int HolyExplosion_Cooldown, HolyExplosion_Length, HolyExplosion_Width, HolyExplosion_Knockback, HolyExplosion_ConfuseTurns, HolyExplosion_ConfuseChance, HolyExplosion_FocusCost, HolyExplosion_ManaCost;
var config float HolyExplosion_DamageMod, DrainSabre_LifeSteal, DrainSabre_LowLifeSteal, AirSabre_Damage, SabreVitality_HPPerSabre, SabreShield_ShieldPerSabre, SabreMobility_MobilityPerSabre, LeechSabre_ShieldSteal;
var config int DarkSword_Cooldown, DarkSword_RestoreMana, DrainSabre_ManaCost, AirSabre_ManaCost, AirSabre_Range, CleaveSabre_ManaCost, CleaveSabre_Length, CleaveSabre_Width;
var config int Bladestorm_FocusCost, Bladestorm_ManaCost, LeechSabre_ManaCost;

var config int FlameSabre_ManaCost, AcidSabre_ManaCost, StormSabre_ManaCost, VenomSabre_ManaCost;
var config float FlameSabre_BonusDamage, AcidSabre_BonusDamage, StormSabre_BonusDamage, VenomSabre_BonusDamage;

var config array<name> SabreAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(DarkSword());
	Templates.AddItem(HolyExplosion());
	Templates.AddItem(Bladestorm());
	/*>>*/Templates.AddItem(BladestormAttack());

	Templates.AddItem(FlameSabre());
	Templates.AddItem(AcidSabre());
	Templates.AddItem(StormSabre());
	Templates.AddItem(VenomSabre());
	Templates.AddItem(DrainSabre());
	Templates.AddItem(AirSabre());
	Templates.AddItem(LeechSabre());

	Templates.AddItem(CleaveSabre());
	Templates.AddItem(SabreVitality());
	Templates.AddItem(SabreShielding());
	Templates.AddItem(SabreMobility());

	return Templates;
}

static function X2AbilityTemplate CreateBaseSlashAbility(Name AbilityName = 'MZNonStandardSlash', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash")
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;

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
	Template.AddShooterEffectExclusions();

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

static function X2AbilityTemplate DarkSword()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Effect_FocusRestore			FocusRestoreEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2AbilityCooldown					Cooldown;

	Template = CreateBaseSlashAbility('MZDarkSword', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_overcharge");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DarkSword_Cooldown;
	Template.AbilityCooldown = Cooldown;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Acid';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	Template.AddTargetEffect(WeaponDamageEffect);

	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ModifyFocus = -1;
	FocusRestoreEffect.ManaRestore = -default.DarkSword_RestoreMana;
	Template.AddTargetEffect(FocusRestoreEffect);

	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ManaRestore = default.DarkSword_RestoreMana;
	Template.AddShooterEffect(FocusRestoreEffect);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('acid');
	UnitImmunityCondition.AddExcludeDamageType('melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	return Template;
}

static function X2AbilityTemplate HolyExplosion()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_PersistentStatChange		ConfuseEffect;
	local MZ_Effect_Knockback				KnockbackEffect;

	Template = CreateBaseSlashAbility('MZHolyExplosion', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave");
	Template.ShotHUDPriority = 370;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.FocusAmount = default.HolyExplosion_FocusCost;
	ManaCost.ManaAmount = default.HolyExplosion_ManaCost;
	ManaCost.ConsumeAllFocus = false;
	Template.AbilityCosts.AddItem(ManaCost);

	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.HolyExplosion_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.AddMultiTargetEffect(KnockbackEffect);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Explosion';
	WeaponDamageEffect.BonusDamageScalar = default.HolyExplosion_DamageMod;
	WeaponDamageEffect.bNoShredder = true;
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('explosion');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ConfuseEffect = class'X2StatusEffects'.static.CreateConfusedStatusEffect(default.HolyExplosion_ConfuseTurns);
	ConfuseEffect.ApplyChance = default.HolyExplosion_ConfuseChance;
	Template.AddTargetEffect(ConfuseEffect);
	Template.AddMultiTargetEffect(ConfuseEffect);

	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.HolyExplosion_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.HolyExplosion_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

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

	return Template;
}

static function X2AbilityTemplate Bladestorm()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZFocusBladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZFocusBladestormAttack');

	return Template;
}
static function X2AbilityTemplate BladestormAttack()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2Condition_UnitProperty          SourceNotConcealedCondition;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			UnitEffectsCondition;
	local X2Condition_UnitProperty			ExcludeSquadmatesCondition;
	local MZ_Cost_Focus						FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFocusBladestormAttack');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bladestorm";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	ToHitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	FocusCost = new class'MZ_Cost_Focus';
	FocusCost.FocusAmount = default.Bladestorm_FocusCost;
	FocusCost.ManaAmount = default.Bladestorm_ManaCost;
	FocusCost.ConsumeAllFocus = false;
	Template.AbilityCosts.AddItem(FocusCost);

	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	//  it may be the case that enemy movement caused a concealment break, which made Bladestorm applicable - attempt to trigger afterwards
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'X2Ability_RangerAbilitySet'.static.BladestormConcealmentListener;
	Trigger.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	// Adding exclusion condition to prevent friendly bladestorm fire when panicked.
	ExcludeSquadmatesCondition = new class'X2Condition_UnitProperty';
	ExcludeSquadmatesCondition.ExcludeSquadmates = true;
	Template.AbilityTargetConditions.AddItem(ExcludeSquadmatesCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	// Don't trigger if the unit has vanished
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('Vanish', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect('VanishingWind', 'AA_UnitIsConcealed');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.bAllowBonusWeaponEffects = true;
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

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


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'BladestormAttack'
	Template.bFrameEvenWhenUnitIsHidden = true;
	//END AUTOGENERATED CODE: Template Overrides 'BladestormAttack'

	return Template;
}


static function X2AbilityTemplate FlameSabre()
{
	local X2AbilityTemplate             Template;
	local MZ_Damage_AddElemental        WeaponDamageEffect;
	local MZ_Cost_Focus					ManaCost;

	Template = CreateBaseSlashAbility('MZFlameSabre', "img:///UILibrary_MZChimeraIcons.Grenade_Fire");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.FlameSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Fire';
	WeaponDamageEffect.BonusDamageScalar = default.FlameSabre_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate AcidSabre()
{
	local X2AbilityTemplate             Template;
	local MZ_Damage_AddElemental        WeaponDamageEffect;
	local MZ_Cost_Focus					ManaCost;

	Template = CreateBaseSlashAbility('MZAcidSabre', "img:///UILibrary_MZChimeraIcons.Grenade_Acid");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.AcidSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Acid';
	WeaponDamageEffect.BonusDamageScalar = default.AcidSabre_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2, 1));

	return Template;
}

static function X2AbilityTemplate VenomSabre()
{
	local X2AbilityTemplate             Template;
	local MZ_Damage_AddElemental        WeaponDamageEffect;
	local MZ_Cost_Focus					ManaCost;

	Template = CreateBaseSlashAbility('MZVenomSabre', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.VenomSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'ParthenogenicPoison';
	WeaponDamageEffect.BonusDamageScalar = default.VenomSabre_BonusDamage;
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bBypassSustainEffects = true;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	return Template;
}

static function X2AbilityTemplate StormSabre()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseSlashAbility('MZStormSabre', "img:///UILibrary_MZChimeraIcons.Grenade_EMP");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.StormSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Electrical';
	WeaponDamageEffect.BonusDamageScalar = default.StormSabre_BonusDamage;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate DrainSabre()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Effect_Lifesteal				Lifesteal;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseSlashAbility('MZDrainSabre', "img:///UILibrary_PerkIcons.UIPerk_soulsteal");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.DrainSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Lifesteal = new class'MZ_Effect_LifeSteal';
	Lifesteal.FlatVamp = default.DrainSabre_Lifesteal;
	Lifesteal.LowHealthVamp = default.DrainSabre_LowLifeSteal;
	Template.AddTargetEffect(Lifesteal);

	return Template;
}

static function X2AbilityTemplate AirSabre()
{
	local X2AbilityTemplate                 Template;
	local MZ_Damage_AddElemental			WeaponDamageEffect;
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseSlashAbility('MZAirSabre', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_stunstrike");
	Template.ShotHUDPriority = 320;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetConditions.Length = 0;
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.AirSabre_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.AirSabre_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Melee';
	WeaponDamageEffect.BonusDamageScalar = default.AirSabre_Damage;
	WeaponDamageEffect.bNoShredder = true;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate CleaveSabre()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;

	Template = CreateBaseSlashAbility('MZCleaveSabre', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.CleaveSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.CleaveSabre_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.CleaveSabre_Length * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

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

	return Template;
}

static function X2AbilityTemplate SabreVitality()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_LifeByAbilityCount           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSabreVitality');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defend_health";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_LifeByAbilityCount';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.Stat = eStat_HP;
	Effect.BonusMod = default.SabreVitality_HPPerSabre;
	Effect.AbilityNames = default.SabreAbilities;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate SabreShielding()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_LifeByAbilityCount           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSabreShielding');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defend_health";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_LifeByAbilityCount';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.Stat = eStat_ShieldHP;
	Effect.BonusMod = default.SabreShield_ShieldPerSabre;
	Effect.AbilityNames = default.SabreAbilities;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate SabreMobility()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_LifeByAbilityCount           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSabreMobility');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defend_health";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_LifeByAbilityCount';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.Stat = eStat_Mobility;
	Effect.BonusMod = default.SabreMobility_MobilityPerSabre;
	Effect.AbilityNames = default.SabreAbilities;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate LeechSabre()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Effect_ShieldSteal				Lifesteal;
	local MZ_Cost_Focus						ManaCost;

	Template = CreateBaseSlashAbility('MZLeechSabre', "img:///UILibrary_PerkIcons.UIPerk_soulsteal");
	Template.ShotHUDPriority = 320;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.LeechSabre_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Lifesteal = new class'MZ_Effect_ShieldSteal';
	Lifesteal.FlatVamp = default.LeechSabre_Shieldsteal;
	//Lifesteal.LowHealthVamp = default.DrainSabre_LowLifeSteal;
	Template.AddTargetEffect(Lifesteal);

	return Template;
}


//Still need to decide what i actually want to do with split/crush/etc.
static function X2AbilityTemplate SplitPunch()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;

	Template = CreateBaseSlashAbility('MZSplitPunch', "img:///UILibrary_MZChimeraIcons.Ability_Scythe");
	Template.ShotHUDPriority = 340;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 1;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}