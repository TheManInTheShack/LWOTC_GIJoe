class MZShield_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);

var config int PowerCrush_Cooldown, PowerCrush_Rupture, MindCrush_Cooldown, MindCrush_Turns, MindCrush_Will, MindCrush_HackDef, ShieldCharge_Cooldown, ShieldCharge_Knockback, TargeSmash_Cooldown;
var config int RaptorWhirlwind_Range, RaptorCyclone_Range, RaptorCyclone_Cooldown, RaptorCyclone_Radius, ShieldStability_PointBlankAimMod, ShieldStability_AimMod, ShieldStability_CritPerTier;
var config int Castling_Cooldown, RaptorHurricane_Cooldown, RaptorHurricane_Range, SoulCrush_Cooldown, SoulCrush_Focus, SoulCrush_Mana, ViperCrush_Cooldown, Sandblast_Turns, ShakeTheEarth_TraumaChance;
var config float SoulCrush_ShieldSteal_VampRate, ShakeTheEarth_Radius, ShakeTheEarth_Mobility, TargeSmash_Damage, ViperCrush_Damage, Sandblast_VisionMult, ShroudedBulwark_Radius;

var config array<name> MentalBulwark_ImmuneTypes, FortifiedWall_ImmuneTypes;

var localized string MindCrushEffectName, MindCrushEffectDesc, MentalBulwarkEffectName, MentalBulwarkEffectDesc, FortifiedWallEffectName, FortifiedWallEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddPowerCrush());
	Templates.AddItem(AddMindCrush());
	Templates.AddItem(AddShieldCharge());
	Templates.AddItem(AddEnGarde());
	/*>>>*/Templates.AddItem(AddEnGardeAttack());
	Templates.AddItem(AddRaptorWhirlwind());
	/*>>>*/Templates.AddItem(AddRaptorWhirlwindPassive());
	Templates.AddItem(AddRaptorCyclone());
	Templates.AddItem(AddShieldStability());

	Templates.AddItem(ShakeTheEarth());
	/*>>>*/Templates.AddItem(ShakeTheEarthTrigger());
	Templates.AddItem(TargeSmash());
	Templates.AddItem(Castling());
	Templates.AddItem(RaptorHurricane());
	/*>>>*/Templates.AddItem(RaptorHurricaneAttack());
	Templates.AddItem(ViperCrush());
	Templates.AddItem(SoulCrush());

	Templates.AddItem(PurePassive('MZMentalBulwark', "img:///UILibrary_PerkIcons.UIPerk_solace"));
	Templates.AddItem(PurePassive('MZFortifiedWall', "img:///UILibrary_PerkIcons.UIPerk_fortress"));
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZRaptorSandblast', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", 'MZRaptorWhirlwind'));

	Templates.AddItem(ShroudedBulwark());
	/*>>>*/Templates.AddItem(ShroudedBulwarkTrigger());

	return Templates;
}

static function ModifyShieldWall()
{
	local X2AbilityTemplateManager		AbilityManager;
	local X2AbilityTemplate				Template;
	local int							i;
	local X2AbilityCost_ActionPoints	ActionPointsCost;
	local X2Effect_DamageImmunity		ImmunityEffect;
	local X2Condition_AbilityProperty	TraumaCondition;
	
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityManager.FindAbilityTemplate('ShieldWall');
	if(Template != none )
	{
		for (i = 0; i <  Template.AbilityCosts.Length; i++) {
			ActionPointsCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
			if (ActionPointsCost != None) {
				ActionPointsCost.AllowedTypes.AddItem('MZShieldCharge');
				break;
			}
		}

		ImmunityEffect = new class'X2Effect_DamageImmunity';
		ImmunityEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		ImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, default.MentalBulwarkEffectName, default.MentalBulwarkEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_solace");
		ImmunityEffect.ImmuneTypes = default.MentalBulwark_ImmuneTypes;
		TraumaCondition = new class'X2Condition_AbilityProperty';
		TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZMentalBulwark');
		ImmunityEffect.TargetConditions.AddItem(TraumaCondition);
		ImmunityEffect.EffectName = 'MZMentalBulwarkEffect';
		ImmunityEffect.DuplicateResponse = eDupe_Refresh;
		Template.AddTargetEffect(ImmunityEffect);

		ImmunityEffect = new class'X2Effect_DamageImmunity';
		ImmunityEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		ImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, default.FortifiedWallEffectName, default.FortifiedWallEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_fortress");
		ImmunityEffect.ImmuneTypes = default.FortifiedWall_ImmuneTypes;
		TraumaCondition = new class'X2Condition_AbilityProperty';
		TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZFortifiedWall');
		ImmunityEffect.TargetConditions.AddItem(TraumaCondition);
		ImmunityEffect.EffectName = 'MZFortifiedWallEffect';
		ImmunityEffect.DuplicateResponse = eDupe_Refresh;
		Template.AddTargetEffect(ImmunityEffect);

		Template.PostActivationEvents.AddItem('ShieldWallActivated');
	}
	
}


static function X2AbilityTemplate AddPowerCrush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPowerCrush');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_barage";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PowerCrush_Cooldown;
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

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.Rupture = default.PowerCrush_Rupture;
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}

static function X2AbilityTemplate AddMindCrush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_PersistentStatChange		StatChange;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMindCrush');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_mindblast";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MindCrush_Cooldown;
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

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	StatChange = new class'X2Effect_PersistentStatChange';
	StatChange.BuildPersistentEffect(default.MindCrush_Turns, false, false, false, eGameRule_PlayerTurnEnd);
	StatChange.AddPersistentStatChange(eStat_Will, default.MindCrush_Will);
	StatChange.AddPersistentStatChange(eStat_HackDefense, default.MindCrush_HackDef);
	StatChange.SetDisplayInfo(ePerkBuff_Penalty, default.MindCrushEffectName , default.MindCrushEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_mindblast", true);
	Template.AddTargetEffect(StatChange);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}

static function X2AbilityTemplate AddShieldCharge()
{
	local X2AbilityTemplate                 Template;
	local Grimy_Cost_ActionPoints	        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local X2Effect_ImmediateAbilityActivation	AutoShieldWall;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShieldCharge');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_electrostaticplating";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'MZShieldCharge';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShieldCharge_Cooldown;
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
	UnitImmunityCondition.AddExcludeDamageType('melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.ShieldCharge_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	AutoShieldWall = new class'X2Effect_ImmediateAbilityActivation';
	AutoShieldWall.AbilityName = 'ShieldWall';
	AutoShieldWall.bApplyOnHit = true;
	AutoShieldWall.bApplyOnMiss = true;
	Template.AddShooterEffect(AutoShieldWall);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}


static function X2AbilityTemplate AddEnGarde()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZEnGarde', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZEnGardeAttack');

	return Template;
}
static function X2AbilityTemplate AddEnGardeAttack()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitEffects			EffectCondition;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;

	Template = class'X2Ability_RangerAbilitySet'.static.BladestormAttack('MZEnGardeAttack');

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddRequireEffect('ShieldWall', 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectCondition);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}

static function X2AbilityTemplate AddRaptorWhirlwind()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			TargetCondition;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local X2Effect_Blind					BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRaptorWhirlwind');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_stunstrike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('MZRaptorWhirlwindActionPoint');
	Template.AbilityCosts.AddItem(ActionPointCost);
		
	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.RaptorWhirlwind_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.Sandblast_Turns, default.Sandblast_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.Sandblast_VisionMult, MODOP_PostMultiplication);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZRaptorSandblast');
	BlindEffect.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(BlindEffect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	Template.AdditionalAbilities.AddItem('MZRaptorWhirlwindPassive');

	return Template;
}

static function X2AbilityTemplate AddRaptorWhirlwindPassive()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_RaptorWhirlwindAP			RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRaptorWhirlwindPassive');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_stunstrike";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_RaptorWhirlwindAP';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.FriendlyName = class'MZBulletArt_AbilitySet'.default.MeleeBulletVsSectoidEffectName;
	//RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.bUniqueSource = true;

	return Template;
}

static function X2AbilityTemplate AddRaptorCyclone()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	//local X2Condition_UnitProperty			TargetCondition;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2Effect_Blind					BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRaptorCyclone');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_remotestart";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 340;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('MZRaptorWhirlwindActionPoint');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RaptorCyclone_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardMelee;
	
	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.RaptorCyclone_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.fTargetRadius = default.RaptorCyclone_Radius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	/*
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.RaptorWhirlwind_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	*/
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	//Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.Sandblast_Turns, default.Sandblast_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.Sandblast_VisionMult, MODOP_PostMultiplication);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZRaptorSandblast');
	BlindEffect.TargetConditions.AddItem(TraumaCondition);
	Template.AddMultiTargetEffect(BlindEffect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	//Template.AddTargetEffect(TraumaStun);
	Template.AddMultiTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	Template.PrerequisiteAbilities.AddItem('MZRaptorWhirlwind');

	return Template;
}

static function X2AbilityTemplate AddShieldStability()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_ShieldStabilized			RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShieldStability');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ShieldBearer";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_ShieldStabilized';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	RegenEffect.AimMod = default.ShieldStability_AimMod;
	RegenEffect.PointBlankAimMod = default.ShieldStability_PointBlankAimMod;
	RegenEffect.CritPerTier = default.ShieldStability_CritPerTier;
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.bUniqueSource = true;

	return Template;
}

static function X2AbilityTemplate ShakeTheEarth()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZShakeTheEarth', "img:///UILibrary_MZChimeraIcons.Ability_FearFactor", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZShakeTheEarthTrigger');

	return Template;
}
static function X2AbilityTemplate ShakeTheEarthTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_PersistentStatChange		Effect;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShakeTheEarthTrigger');

	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_FearFactor";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ShakeTheEarth_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'ShieldWallActivated';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Mobility, default.ShakeTheEarth_Mobility, MODOP_PostMultiplication);
	Effect.EffectName = 'MZShakeTheEarthEffect';
	Effect.DuplicateResponse = eDupe_Refresh;
	Template.AddMultiTargetEffect(Effect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, default.ShakeTheEarth_TraumaChance, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddMultiTargetEffect(TraumaStun);
	
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate TargeSmash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTargeSmash');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ShieldBash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 330;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.TargeSmash_Cooldown;
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

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Melee';
	WeaponDamageEffect.BonusDamageScalar = default.TargeSmash_Damage;
	WeaponDamageEffect.bNoShredder = true;
	WeaponDamageEffect.bIgnoreBaseDamage = false;
	Template.AddTargetEffect(WeaponDamageEffect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}

static function X2AbilityTemplate Castling()
{
	local X2AbilityTemplate				Template;
	local Grimy_Cost_ActionPoints		ActionPointCost;
	local X2Effect_ImmediateAbilityActivation AutoShieldWall;

	Template = class'MZUnspecific_AbilitySet'.static.AddTranspositionAbility('MZCastling', true, false, default.Castling_Cooldown);

	Template.AbilityCosts.Length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'MZShieldCharge';
	Template.AbilityCosts.AddItem(ActionPointCost);

	AutoShieldWall = new class'X2Effect_ImmediateAbilityActivation';
	AutoShieldWall.AbilityName = 'ShieldWall';
	AutoShieldWall.bApplyOnHit = true;
	AutoShieldWall.bApplyOnMiss = true;
	Template.AddShooterEffect(AutoShieldWall);

	Template.Hostility = eHostility_Movement;

	return Template;
}

static function X2DataTemplate RaptorHurricane()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitEffects		UnitEffectsCondition;
	local X2AbilityTrigger_PlayerInput	InputTrigger;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_Persistent		HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRaptorHurricane');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Guardian";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Neutral;

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.RaptorHurricane_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.length = 0;
	ActionPointCost.AllowedTypes.AddItem('MZRaptorWhirlwindActionPoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	// The shooter cannot be mind controlled
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//// Create the Marked effect
	HitModEffect = new class'X2Effect_Persistent';
	HitModEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	HitModEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	HitModEffect.EffectName = 'MZRaptorHurricane';
	Template.AddTargetEffect(HitModEffect);
	
	Template.CustomFireAnim = 'HL_SignalAngry';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
//BEGIN AUTOGENERATED CODE: Template Overrides 'MarkTarget'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'MarkTarget'

	Template.AdditionalAbilities.AddItem('MZRaptorHurricaneAttack');
	Template.PrerequisiteAbilities.AddItem('MZRaptorWhirlwind');
	
	return Template;
}
static function X2AbilityTemplate RaptorHurricaneAttack()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			TargetCondition;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local X2Condition_UnitEffects			EffectCondition;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_Blind					BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRaptorHurricaneAttack');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Guardian";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 380;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

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

	// Target Conditions
	//
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.RaptorHurricane_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

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

	// The shooter cannot be mind controlled
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddRequireEffect('MZRaptorHurricane', 'AA_MissingRequiredEffect');
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(EffectCondition);

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.Sandblast_Turns, default.Sandblast_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.Sandblast_VisionMult, MODOP_PostMultiplication);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZRaptorSandblast');
	BlindEffect.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(BlindEffect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	//Template.AdditionalAbilities.AddItem('MZRaptorWhirlwindPassive');

	return Template;
}

static function X2AbilityTemplate ViperCrush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local MZ_Damage_AddElemental	        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZViperCrush');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 330;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ViperCrush_Cooldown;
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
	UnitImmunityCondition.AddExcludeDamageType('poison');
	UnitImmunityCondition.AddExcludeDamageType('melee');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Poison';
	WeaponDamageEffect.BonusDamageScalar = default.ViperCrush_Damage;
	WeaponDamageEffect.bNoShredder = true;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('Melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}

static function X2AbilityTemplate SoulCrush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Stunned					TraumaStun;
	local X2Condition_AbilityProperty		TraumaCondition;
	local MZ_Effect_FocusRestore			FocusRestoreEffect;
	local MZ_Effect_ShieldSteal				ShieldStealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSoulCrush');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_mindblast";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SoulCrush_Cooldown;
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

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	ShieldStealEffect = new class'MZ_Effect_ShieldSteal';
	ShieldStealEffect.FlatVamp = default.SoulCrush_ShieldSteal_VampRate;
	Template.AddTargetEffect(ShieldStealEffect);

	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ModifyFocus = -default.SoulCrush_Focus;
	FocusRestoreEffect.ManaRestore = -default.SoulCrush_Mana;
	Template.AddTargetEffect(FocusRestoreEffect);

	TraumaStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	TraumaStun.TargetConditions.AddItem(TraumaCondition);
	Template.AddTargetEffect(TraumaStun);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';

	return Template;
}


static function X2AbilityTemplate ShroudedBulwark()
{
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZShroudedBulwark', "img:///UILibrary_PerkIcons.UIPerk_smokebomb");
	Template.AdditionalAbilities.AddItem('MZShroudedBulwarkTrigger');

	return Template;
}
static function X2AbilityTemplate ShroudedBulwarkTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShroudedBulwarkTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_smokebomb";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ShroudedBulwark_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'ShieldWallActivated';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	//Smoke stuff.
	Template.AddMultiTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	Template.AddTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	Template.AddMultiTargetEffect(new class'X2Effect_ApplySmokeGrenadeToWorld');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}