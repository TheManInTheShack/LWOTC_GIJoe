class MZBloodMagic_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);
	
var config int DropByDrop_HPCostDown, DarkPotency_HPCostUp, DarkPotency_MaxBonusDamage, Curseball_Range, Curseball_HPCost, CurseBreath_HPCost, CurseLance_HPCost, LifeBalancer_Cooldown, FleshOfMyFlesh_Range, FleshOfMyFlesh_HPCost, FleshOfMyFlesh_HealHP;
var config int DevouringShadow_HPCost, DevouringShadow_InitialDamage, DevouringShadow_PulseDamage, DevouringShadow_Stun, FromBelowItDevours_HPCost, FromBelowItDevours_InitialDamage, FromBelowItDevours_PulseDamage, FromBelowItDevours_Stun, FromBelowItDevours_Charges;
var config float BloodyMadness_BonusMult, DarkPotency_BonusMult, AbyssalHunger_VampBonus, Curseball_Radius, DevouringShadow_LifeDrainMod, FromBelowItDevours_LifeDrainMod;


struct HPCostAbility
{
	var name AbilityName;
	var int FlatCost;
	var float PercentCost;
};

struct LifeStealAbility
{
	var name AbilityName;
	var float Lifesteal;
	var float LowHPSteal;
	var float MultiLifeSteal;
	var float MultiLowHPSteal;
};

var config array<name> CURSE_TARGET, CURSE_MULTITARGET, CURSE_WORLD, AddCurseEffectToWeapons;
var config array<HPCostAbility> ADD_HPCOST_TO_ABILITY;
var config array<LifeStealAbility> ADD_LIFESTEAL_TO_ABILITY;

//to apply bloodcost colour
//Template.AbilityIconColor = "C34144";

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddBloodyMadness());
	Templates.AddItem(AddDropByDrop());
	Templates.AddItem(AddDarkPotency());
	Templates.AddItem(PurePassive('MZAbyssalHunger',"img:///UILibrary_XPACK_Common.PerkIcons.str_soulstealer"));
	Templates.AddItem(AddCurseball());

	Templates.AddItem(CurseBreath());
	Templates.AddItem(CurseLance());
	Templates.AddItem(DevouringShadow());
	Templates.AddItem(FromBelowItDevours());

	Templates.AddItem(LifeBalancer());
	Templates.AddItem(FleshOfMyFlesh());

	Templates.AddItem(BloodStar());

	return Templates;
}

static function AddCurseToAbilities()
{
	local X2AbilityTemplateManager		AbilityManager;
	local X2AbilityTemplate				Template;
	local name							AbilityName;
	local MZ_Effect_ApplyCurseToWorld	PoisonCloudEffect;
	local HPCostAbility					HPCostStruct;
	local LifeStealAbility				LifeStealStruct;
	local Grimy_AbilityCost_HP          HPCost;
	local MZ_Effect_LifeSteal			LifeSteal;
	local X2ItemTemplateManager			ItemManager;
	local array<X2DataTemplate>			DifficultyTemplates;
	local X2DataTemplate				DifficultyTemplate;
	local Name							TemplateName;
	local X2WeaponTemplate				WeaponTemplate;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.CURSE_TARGET(AbilityName)
	{
		Template = AbilityManager.FindAbilityTemplate(AbilityName);
		if(Template != none )
		{
			Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
		}
	}

	foreach default.CURSE_MULTITARGET(AbilityName)
	{
		Template = AbilityManager.FindAbilityTemplate(AbilityName);
		if(Template != none )
		{
			Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
		}
	}

	foreach default.CURSE_WORLD(AbilityName)
	{
		Template = AbilityManager.FindAbilityTemplate(AbilityName);
		if(Template != none )
		{
			Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
			PoisonCloudEffect = new class'MZ_Effect_ApplyCurseToWorld';
			PoisonCloudEffect.Duration = 3;
			Template.AddMultiTargetEffect(PoisonCloudEffect);
		}
	}

	foreach default.ADD_HPCOST_TO_ABILITY(HPCostStruct)
	{
		Template = AbilityManager.FindAbilityTemplate(HPCostStruct.AbilityName);
		if(Template != none )
		{
			Template.AbilityIconColor = "C34144";
			HPCost = new class'Grimy_AbilityCost_HP';
			HPCost.Cost = HPCostStruct.FlatCost;
			HPCost.PercentCost = HPCostStruct.PercentCost;
			Template.AbilityCosts.AddItem(HPCost);
		}
	}

	foreach default.ADD_LIFESTEAL_TO_ABILITY(LifeStealStruct)
	{
		Template = AbilityManager.FindAbilityTemplate(LifeStealStruct.AbilityName);
		if(Template != none )
		{
			if ( LifeStealStruct.Lifesteal > 0 || LifeStealStruct.LowHPSteal > 0 )
			{
				LifeSteal = new class'MZ_Effect_LifeSteal';
				LifeSteal.FlatVamp = LifeStealStruct.Lifesteal;
				LifeSteal.LowHealthVamp = LifeStealStruct.LowHPSteal;
				Template.AddTargetEffect(LifeSteal);
			}

			if ( LifeStealStruct.MultiLifesteal > 0 || LifeStealStruct.MultiLowHPSteal > 0 )
			{
				LifeSteal = new class'MZ_Effect_LifeSteal';
				LifeSteal.FlatVamp = LifeStealStruct.MultiLifeSteal;
				LifeSteal.LowHealthVamp = LifeStealStruct.MultiLowHPSteal;
				LifeSteal.Flyover = !( LifeStealStruct.Lifesteal > 0 || LifeStealStruct.LowHPSteal > 0 );
				Template.AddMultiTargetEffect(LifeSteal);
			}
		}
	}


	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	Foreach default.AddCurseEffectToWeapons(TemplateName)
	{
		ItemManager.FindDataTemplateAllDifficulties(TemplateName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			WeaponTemplate = X2WeaponTemplate(DifficultyTemplate);
			if ( WeaponTemplate != none) {
				WeaponTemplate.BonusWeaponEffects.AddItem(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());
			}
		}
	}
}

static function X2AbilityTemplate AddBloodyMadness() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_BloodyMadness	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodyMadness');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_BloodyMadness';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.BonusMult = default.BloodyMadness_BonusMult;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddDropByDrop()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('MZDropByDrop', "img:///UILibrary_PerkIcons.UIPerk_adrenalneurosympathy");
	Template.AbilityIconColor = "C34144";

	return Template;
}

static function X2AbilityTemplate AddDarkPotency() {
	local X2AbilityTemplate						Template;
	local MZ_Effect_DarkPotency					DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDarkPotency');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_DarkPotency';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.BonusMult = default.DarkPotency_BonusMult;
	DamageEffect.MaxBonusDamage = default.DarkPotency_MaxBonusDamage;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddCurseball()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local Grimy_AbilityCost_HP              HPCost;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Aim_PsiAttack					AimType;
	local MZ_Effect_ApplyCurseToWorld		WorldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCurseball');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.Curseball_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Curseball_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Curseball_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZCurseball';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	WorldEffect = new class'MZ_Effect_ApplyCurseToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psibomb";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'FF_MZBlood_RHandCast';

	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";
	Template.AbilityIconColor = "C34144";

	Template.LostSpawnIncreasePerUse = 50;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate CurseBreath()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage	        WeaponDamageEffect;
	local Grimy_AbilityCost_HP              HPCost;

	Template = class'MZPsiAmp_AbilitySet'.static.PsiBreath( 'MZCurseBreath', 'FF_MZCurseDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_torch", -1);
	Template.AbilityIconColor = "C34144";

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.CurseBreath_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZCurseBreath';
	WeaponDamageEffect.DamageTypes.AddItem('psi');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect(class'MZ_Effect_Bloodcurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate CurseLance()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Aim_PsiAttack					AimType;
	local MZ_Effect_ApplyCurseToWorld		WorldEffect;
	local Grimy_AbilityCost_HP              HPCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCurseLance');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityIconColor = "C34144";

	Template.CustomFireAnim = 'FF_MZBlood_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.CurseLance_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZCurseLance';
	WeaponDamageEffect.DamageTypes.AddItem('psi');
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	Template.AddMultiTargetEffect(class'MZ_Effect_Bloodcurse'.static.CreateBloodCurse());

	WorldEffect = new class'MZ_Effect_ApplyCurseToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = true;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Line';
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActivationSpeech = 'NullLance';

	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'NullLance'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'NullLance'

	return Template;
}

static function X2AbilityTemplate LifeBalancer()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	//local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLifeBalancer');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulsteal";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "C34144";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LifeBalancer_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	//StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = default.DeadEye; // StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_LifeBalancer');

	Template.AbilityTargetEffects.AddItem(new class'MZ_Effect_LifeBalancer');
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;
	
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZBlood_RHandCast';
	Template.CustomFireKillAnim = 'FF_MZBlood_RHandCast';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate DevouringShadow()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local MZ_Effect_VoidPrison				PersistentEffect;
	local MZ_Effect_VoidPrison_BloodDrain	TickEffect;
	local X2Condition_UnitEffects			EffectCondition;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local Grimy_AbilityCost_HP				HPCost;
	//local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDevouringShadow');

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZBlood_GhostCast';
	Template.CustomFireKillAnim = 'FF_MZBlood_GhostCast';
	Template.ActivationSpeech = 'VoidConduit';
	Template.CinescriptCameraType = "Templar_VoidConduit";
//END AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_VoidConduit";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.DevouringShadow_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	/*
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.VoidConduit_Cooldown;
	Template.AbilityCooldown = Cooldown;
	*/

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// block having more than one conduit ability active at a time.
	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeHostileToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeCivilian = true;
	TargetCondition.ExcludeCosmetic = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeAlien = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	//	don't allow a target to be affected by this more than one at a time
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	//	build the persistent effect
	PersistentEffect = new class'MZ_Effect_VoidPrison';
	PersistentEffect.InitialDamage = default.DevouringShadow_InitialDamage;
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	PersistentEffect.bRemoveWhenTargetDies = true;
	PersistentEffect.StunActions = default.DevouringShadow_Stun;
	PersistentEffect.ScaleStunWithWeaponTier = 0; //default.VoidConduit_StunPerTier;
	//	build the per tick damage effect
	TickEffect = new class'MZ_Effect_VoidPrison_BloodDrain';
	TickEffect.DamagePerAction = default.DevouringShadow_PulseDamage;
	TickEffect.HealthReturnMod = default.DevouringShadow_LifeDrainMod;
	TickEffect.bRed = true;
	PersistentEffect.ApplyOnTick.AddItem(TickEffect);
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = DevouringShadowDamagePreview;

	return Template;
}
function bool DevouringShadowDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	MinDamagePreview.Damage = default.DevouringShadow_InitialDamage;
	MaxDamagePreview.Damage = default.DevouringShadow_InitialDamage + default.DevouringShadow_Stun * default.DevouringShadow_PulseDamage;
	return true;
}

static function X2AbilityTemplate FromBelowItDevours()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local MZ_Effect_VoidPrison				PersistentEffect;
	local MZ_Effect_VoidPrison_BloodDrain	TickEffect;
	local X2Condition_UnitEffects			EffectCondition;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local Grimy_AbilityCost_HP				HPCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFromBelowItDevours');

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZBlood_GhostCast';
	Template.CustomFireKillAnim = 'FF_MZBlood_GhostCast';
	Template.ActivationSpeech = 'VoidConduit';
	Template.CinescriptCameraType = "Templar_VoidConduit";
//END AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_VoidConduit";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = 15; //default.Disable_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 5.0; //default.Disable_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.FromBelowItDevours_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.FromBelowItDevours_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// block having more than one conduit ability active at a time.
	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeHostileToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeCivilian = true;
	TargetCondition.ExcludeCosmetic = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeAlien = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	//	don't allow a target to be affected by this more than one at a time
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsImmune');
	Template.AbilityMultiTargetConditions.AddItem(EffectCondition);

	//	build the persistent effect
	PersistentEffect = new class'MZ_Effect_VoidPrison';
	PersistentEffect.InitialDamage = default.FromBelowItDevours_InitialDamage;
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	PersistentEffect.bRemoveWhenTargetDies = true;
	PersistentEffect.StunActions = default.FromBelowItDevours_Stun;
	PersistentEffect.ScaleStunWithWeaponTier = 0; //default.VoidConduit_StunPerTier;
	//	build the per tick damage effect
	TickEffect = new class'MZ_Effect_VoidPrison_BloodDrain';
	TickEffect.DamagePerAction = default.FromBelowItDevours_PulseDamage;
	TickEffect.HealthReturnMod = default.FromBelowItDevours_LifeDrainMod;
	TickEffect.bRed = true;
	PersistentEffect.ApplyOnTick.AddItem(TickEffect);
	Template.AddMultiTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = DevouringShadowDamagePreview;

	return Template;
}

static function X2AbilityTemplate FleshOfMyFlesh()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Effect_RemoveEffects            RemoveEffects;
	local X2Effect_TriggerEvent             InsanityEvent;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local X2Condition_UnitStatCheck			UnitStatCheckCondition;
	local Grimy_AbilityCost_HP				HPCost;
	local X2Effect_ApplyMedikitHeal         MedikitHeal;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFleshOfMyFlesh');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.FleshOfMyFlesh_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	Template.AbilityIconColor = "C34144";

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_chosenrevive";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.FleshOfMyFlesh_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//shooter has to have 3+ HP in order to transfer any with life balance.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 2, eCheck_GreaterThan);
	Template.AbilityShooterConditions.AddItem(UnitStatCheckCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	//UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.IsBleedingOut = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.FleshOfMyFlesh_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Remove Bleedout
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true));

	//Heal effects - flat amount? transfer HP?
	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = default.FleshOfMyFlesh_HealHP;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(class'MZPsiAmp_AbilitySet'.static.RemoveAllEffectsByDamageType());

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'MZRestoreLifeChaser';
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);	

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'StabilizingAlly';

	Template.bShowActivation = true;
	Template.CustomFireAnim =  'FF_MZBlood_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	Template.AdditionalAbilities.AddItem('MZRestoreLifeChaser');

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}


static function X2AbilityTemplate BloodStar()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodStar');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZFireWhip';
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Grenade_Fire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZBlood_PsiBomb';
	Template.CustomFireKillAnim = 'FF_MZBlood_PsiBomb';

	Template.ActivationSpeech = 'Mindblast';

	Template.ActionFireClass = class'MZ_Action_PerkPinion';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = MeteorCast_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}
simulated function MeteorCast_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local Array<X2Action>					arrFoundActions;
	local X2Action							FoundAction;
	local X2Action_Fire						FireAction;
	local X2Action_WaitForAbilityEffect		WaitAction;
	local VisualizationActionMetadata		ShooterMetadata;
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				InteractingUnitRef;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	//	Spawning Meteors (Psi Pinions) is a Fire Action.
	//	However, we need the actual Fire Action to play the ability animation and use its Notify Targets animnotify to trigger the meteors.
	//	Apply weapon damage effects that are visualized for targets listen to the first (or random, if several) Fire Actions that are added before them
	//	We need enemies and environment react to Psi Pinions action. 
	//	So we have to get tricky with the visualization. We call the Typical Ability Build Visualization with Action Fire Class set to Psi Pinions.
	//	Then we insert a second Fire Action before it and use a Wait Action in the middle to make Psi Pinions trigger on Notify Targets in HL_SoulStorm

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	ShooterMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ShooterMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ShooterMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	//	Find Exit Cover action
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', arrFoundActions);

	//	insert a second Fire Action after it
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(ShooterMetadata, Context, false, arrFoundActions[0]));
	//	followed by a Wait Action
	WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ShooterMetadata, Context, false, FireAction));

	//	then we look for all Fire Actions
	//	which will find both the Fire Action and Psi Pinions. But we only need Psi Pinions.
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_Fire', arrFoundActions);
	foreach arrFoundActions(FoundAction)
	{
		if (MZ_Action_PerkPinion(FoundAction) != None)	// so we chack if the found action can be cast to it
		{
			VisMgr.DisconnectAction(FoundAction);	//	if it is, then it is the Psi Pinions action. We disconnect it from its parents
			VisMgr.ConnectAction(FoundAction, VisMgr.BuildVisTree,, WaitAction);	//	and set it as a child of the Wait Action so that it comes after it
		}
	}
}