class MZGeomancer_AbilitySet extends X2Ability config(MZCryoPerkPack);

var config int BiomeAOE_Cooldown, BiomeAOE_Range, AridBurn_Damage, AridBurn_Spread, VenomSquall_CloudDuration, MistStorm_Turns, MistStorm_Will, MistStorm_HackDef, CounterFlood_RobotStunActions;
var config int NaturesEmbrace_Cooldown, MistBlind_Turns, XenoZombie_Turns, CounterFlood_MaxShots, AngrySky_RobotStunActions, Urban_Knockback, AllCreation_Cooldown, AllCreation_Charges;
var config int SeismicShift_Cooldown, SeismicShift_Range, EarthSpike_Range, EarthSpike_Cooldown, EarthSpike_Duration;
var config float BiomeAOE_Radius, MistBlind_VisionMult, NaturesWrath_CritDmgPerAbility, NaturesWrath_CritPerAbility, SeismicShift_Radius, EarthSpike_Radius;
var config array<name> Geo_AbilityNames;


var localized string MistStormEffectName, MistStormEffectDesc;
var localized string NEAridDesc, NETundraDesc, NEXenoDesc, NETemperateDesc, NEUrbanDesc, NECaveDesc;
var localized string ACAridDesc, ACTundraDesc, ACXenoDesc, ACTemperateDesc, ACUrbanDesc, ACCaveDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddShiningFlare());			//Arid
	Templates.AddItem(AddVenomSquall());			//Xenoform
	Templates.AddItem(AddMistStorm());				//Temperate
	Templates.AddItem(AddAvalanche());				//Tundra
	Templates.AddItem(AddNaturesEmbrace());			//Bonus effect based on biome
	Templates.AddItem(AddCounterFlood());
	/*>>>*/Templates.AddItem(AddCounterFloodShot());
	Templates.AddItem(AddRockfall());				//Cave
	Templates.AddItem(AddAngrySky());				//Urban
	Templates.AddItem(AddAllCreation());
	Templates.AddItem(AddNaturesWrath());

	Templates.AddItem(AddSeismicShift());
	Templates.AddItem(EarthSpike());

	Templates.AddItem(PairedGeomancyAbility('MZGeoSkyPaired', "img:///UILibrary_PerkIcons.UIPerk_psi_drain", 'MZAngrySky', 'MZMistStorm'));
	Templates.AddItem(PairedGeomancyAbility('MZGeoTempPaired', "img:///UILibrary_PerkIcons.UIPerk_torch", 'MZShiningFlare', 'MZAvalanche'));
	Templates.AddItem(PairedGeomancyAbility('MZGeoDarkPaired', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit", 'MZRockfall', 'MZVenomSquall'));

	return Templates;
}

static function X2AbilityTemplate PairedGeomancyAbility(name TemplateName, string IconImage, name AbilityOne, name AbilityTwo)
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	//local X2AbilityTrigger						Trigger;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = IconImage;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.AdditionalAbilities.AddItem(AbilityOne);
	Template.AdditionalAbilities.AddItem(AbilityTwo);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	//AWC Allow
	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate AddShiningFlare()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_ApplyFireToWorld			WorldEffect;
	local MZ_Condition_NatureEmbrace		GeoCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShiningFlare');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Arid';
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.EffectDamageValue.DamageType = 'Fire';
	DamageEffect.DamageTypes.length = 0;
	DamageEffect.DamageTypes.AddItem('Fire');
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread));

	WorldEffect = new class'X2Effect_ApplyFireToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_MPP.burningmeteor";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddVenomSquall()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_ApplyPoisonToWorld           PoisonCloudEffect;
	local MZ_Condition_NatureEmbrace		GeoCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZVenomSquall');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Xeno';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue.DamageType = 'Poison';
	DamageEffect.DamageTypes.length = 0;
	DamageEffect.DamageTypes.AddItem('Poison');
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
	Template.AddMultiTargetEffect(class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false));

	PoisonCloudEffect = new class 'X2Effect_ApplyPoisonToWorld';
	PoisonCloudEffect.Duration = default.VenomSquall_CloudDuration;
	Template.AddMultiTargetEffect(PoisonCloudEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_MPP.skullbolt";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddMistStorm()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_PersistentStatChange		StatChange;
	local MZ_Condition_NatureEmbrace		GeoCondition;
	local X2Effect_Blind					MistBlind;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMistStorm');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Mist';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);

	StatChange = new class'X2Effect_PersistentStatChange';
	StatChange.BuildPersistentEffect(default.MistStorm_Turns, false, false, false, eGameRule_PlayerTurnEnd);
	StatChange.AddPersistentStatChange(eStat_Will, default.MistStorm_Will);
	StatChange.AddPersistentStatChange(eStat_HackDefense, default.MistStorm_HackDef);
	StatChange.SetDisplayInfo(ePerkBuff_Penalty, default.MistStormEffectName, default.MistStormEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_psi_drain", true);
	StatChange.DuplicateResponse = eDupe_Refresh;
	StatChange.EffectName = 'MZMistStormDebuff';
	Template.AddMultiTargetEffect(StatChange);

	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	Template.AddMultiTargetEffect(MistBlind);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psi_drain";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddAvalanche()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Condition_NatureEmbrace		GeoCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAvalanche');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Tundra';
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.EffectDamageValue.DamageType = 'Frost';
	DamageEffect.DamageTypes.length = 0;
	DamageEffect.DamageTypes.AddItem('Frost');
	Template.AddMultiTargetEffect(DamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_MPP.iceorb";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddNaturesEmbrace()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Condition_NatureEmbrace         GeoCondition;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Cooldown_NegatedByEffect       Cooldown;
	local X2Effect_Burning					AridBurn;
	local X2Effect_PersistentStatChange		XenoPoison;
	local X2Effect_Blind					MistBlind;
	local MZ_Effect_Zombify					XenoZombie;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_PersistentStatChange	ChillEffect;
	local X2Effect_PersistentStatChange	BitterChillEffect;
	local X2Effect_DLC_Day60Freeze		FreezeEffect;
	local X2Effect						FreezeCleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNaturesEmbrace');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = 320;

	Cooldown = new class'MZ_Cooldown_NegatedByEffect';
	Cooldown.iNumTurns = default.NaturesEmbrace_Cooldown;
	Cooldown.EffectNameNegates.AddItem('MZNaturesWrath');
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_Mist';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	//Burning in Arid Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	AridBurn = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread);
	AridBurn.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(AridBurn);

	//Bitterfrost in Tundra
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
	ChillEffect.TargetConditions.AddItem(GeoCondition);
	BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
	BitterChillEffect.TargetConditions.AddItem(GeoCondition);
	FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
	FreezeEffect.TargetConditions.AddItem(GeoCondition);
	FreezeCleanse = class'BitterfrostHelper'.static.FreezeCleanse();
	FreezeCleanse.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(FreezeCleanse);
	Template.AddTargetEffect(FreezeEffect);
	Template.AddTargetEffect(BitterChillEffect);
	Template.AddTargetEffect(ChillEffect);

	//Blind in Temperate Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	MistBlind.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(MistBlind);

	//Poison and Zombify in Xeno Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	XenoPoison = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	XenoPoison.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(XenoPoison);

	XenoZombie = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false);
	XenoZombie.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(XenoPoison);

	//double damage underground.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_CaveBonus';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	//Knockback in Urban Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Urban";
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.Urban_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	KnockbackEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_MZGeo_ProjectileMedium';
	Template.CustomFireKillAnim = 'HL_MZGeo_ProjectileMedium';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AlternateFriendlyNameFn = NaturesEmbrace_AlternateFriendlyName;
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function bool NaturesEmbrace_AlternateFriendlyName(out string AlternateDescription, XComGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	
	if (InStr(BattleData.MapData.PlotMapName, "_TUN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_CSH_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALH_") != INDEX_NONE)
	{
		AlternateDescription = default.NECaveDesc;
		return true;
	}
	
	if (InStr(BattleData.MapData.PlotMapName, "_CTY_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_SLM_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_RFT_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ABN_") != INDEX_NONE)
	{
		AlternateDescription = default.NEUrbanDesc;
		return true;
	}

	Switch (BattleData.MapData.Biome)
	{
		Case "Arid":
			AlternateDescription = default.NEAridDesc;
			return true;
		Case "Tundra":
			AlternateDescription = default.NETundraDesc;
			return true;
		Case "Xenoform":
			AlternateDescription = default.NEXenoDesc;
			return true;
		Case "Temperate":
			AlternateDescription = default.NETemperateDesc;
			return true;
	}
	
	return false;
}

static function X2AbilityTemplate AddCounterFlood() 
{
	local X2AbilityTemplate						Template;
	local Grimy_Effect_CoveringFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCounterFlood');
	Template.bCrossClassEligible = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	FireEffect = new class'Grimy_Effect_CoveringFire';
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.MaxPointsPerTurn = default.CounterFlood_MaxShots;
	FireEffect.bPreEmptiveFire = false;
	FireEffect.bOncePerTarget = true;
	FireEffect.GameStateEffectClass = class'Grimy_EffectState';
	FireEffect.AbilityToActivate = 'MZCounterFloodShot';
	FireEffect.GrantActionPoint = 'MZCounterFloodShot';
	FireEffect.EffectName = 'MZCounterFlood';
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.AdditionalAbilities.AddItem('MZCounterFloodShot');
	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate AddCounterFloodShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints        ReserveActionPointCost;
	local MZ_Condition_NatureEmbrace         GeoCondition;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_Burning					AridBurn;
	local X2Effect_PersistentStatChange		XenoPoison;
	local X2Effect_Blind					MistBlind;
	local MZ_Effect_Zombify					XenoZombie;
	local X2Effect_PersistentStatChange		Disorient;
	local X2Effect_Stunned					RoboStun;
	local X2Condition_UnitProperty			RoboCondition;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_PersistentStatChange	ChillEffect;
	local X2Effect_PersistentStatChange	BitterChillEffect;
	local X2Effect_DLC_Day60Freeze		FreezeEffect;
	local X2Effect						FreezeCleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCounterFloodShot');

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem('MZCounterFloodShot');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	//Template.ShotHUDPriority = 320;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_Mist';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = false;
	Template.AddTargetEffect(WeaponDamageEffect);

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	AridBurn = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread);
	AridBurn.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(AridBurn);

	//Bitterfrost In Tundra
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
	ChillEffect.TargetConditions.AddItem(GeoCondition);
	BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
	BitterChillEffect.TargetConditions.AddItem(GeoCondition);
	FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
	FreezeEffect.TargetConditions.AddItem(GeoCondition);
	FreezeCleanse = class'BitterfrostHelper'.static.FreezeCleanse();
	FreezeCleanse.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(FreezeCleanse);
	Template.AddTargetEffect(FreezeEffect);
	Template.AddTargetEffect(BitterChillEffect);
	Template.AddTargetEffect(ChillEffect);

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	MistBlind.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(MistBlind);

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	XenoPoison = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	XenoPoison.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(XenoPoison);

	XenoZombie = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false);
	XenoZombie.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(XenoPoison);

	//double damage underground.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_CaveBonus';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	//Knockback in Urban Biome.
	RoboCondition = new class'X2Condition_UnitProperty';
	RoboCondition.ExcludeOrganic = true;
	RoboCondition.ExcludeFriendlyToSource = false;

	Disorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(false, 0, true);
	Template.AddTargetEffect(Disorient);

	RoboStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect( default.CounterFlood_RobotStunActions, 100, false);
	RoboStun.TargetConditions.AddItem(RoboCondition);
	Template.AddTargetEffect(RoboStun);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.bShowPostActivation = TRUE;
	Template.CustomFireAnim = 'HL_MZGeo_ProjectileMedium';
	Template.CustomFireKillAnim = 'HL_MZGeo_ProjectileMedium';

	//Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate AddRockfall()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Condition_NatureEmbrace		GeoCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRockfall');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Cave';
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.EffectDamageValue.DamageType = 'Melee';
	DamageEffect.DamageTypes.length = 0;
	DamageEffect.DamageTypes.AddItem('Melee');
	Template.AddMultiTargetEffect(DamageEffect);
	//Template.AddMultiTargetEffect(DamageEffect);

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_demolition";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddAngrySky()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Condition_NatureEmbrace		GeoCondition;
	local X2Effect_PersistentStatChange		Disorient;
	local X2Effect_Stunned					RoboStun;
	local X2Condition_UnitProperty			RoboCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAngrySky');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BiomeAOE_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Urban";
	Template.AbilityShooterConditions.AddItem(GeoCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.BiomeAOE_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BiomeAOE_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZGeo_Urban';
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.EffectDamageValue.DamageType = 'Electrical';
	DamageEffect.DamageTypes.length = 0;
	DamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddMultiTargetEffect(DamageEffect);

	RoboCondition = new class'X2Condition_UnitProperty';
	RoboCondition.ExcludeOrganic = true;
	RoboCondition.ExcludeFriendlyToSource = false;

	Disorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(false, 0, true);
	Template.AddMultiTargetEffect(Disorient);

	RoboStun = class'X2StatusEffects'.static.CreateStunnedStatusEffect( default.AngrySky_RobotStunActions, 100, false);
	RoboStun.TargetConditions.AddItem(RoboCondition);
	Template.AddMultiTargetEffect(RoboStun);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_MPP.thunderstorm";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongBiome');
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim =  'HL_MZGeo_ProjectileMedium';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 10;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddAllCreation()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	//local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityCooldown					Cooldown;
	local MZ_Condition_NatureEmbrace         GeoCondition;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Effect_Burning					AridBurn;
	local X2Effect_PersistentStatChange		XenoPoison;
	local X2Effect_Blind					MistBlind;
	local MZ_Effect_Zombify					XenoZombie;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_PersistentStatChange	ChillEffect;
	local X2Effect_PersistentStatChange	BitterChillEffect;
	local X2Effect_DLC_Day60Freeze		FreezeEffect;
	local X2Effect						FreezeCleanse;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAllCreation');

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_IonicStorm";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( default.AllCreation_Cooldown > 0 )
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.AllCreation_Cooldown;
		Template.AbilityCooldown = Cooldown;
	}

	if ( default.AllCreation_Charges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.AllCreation_Charges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	
	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	//Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_Mist';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	//Template.AddTargetEffect(WeaponDamageEffect);

	//Burning in Arid Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	AridBurn = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread);
	AridBurn.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(AridBurn);
	//Template.AddTargetEffect(AridBurn);

	//Bitterfrost In Tundra
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
	ChillEffect.TargetConditions.AddItem(GeoCondition);
	BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
	BitterChillEffect.TargetConditions.AddItem(GeoCondition);
	FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
	FreezeEffect.TargetConditions.AddItem(GeoCondition);
	FreezeCleanse = class'BitterfrostHelper'.static.FreezeCleanse();
	FreezeCleanse.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(FreezeCleanse);
	Template.AddMultiTargetEffect(FreezeEffect);
	Template.AddMultiTargetEffect(BitterChillEffect);
	Template.AddMultiTargetEffect(ChillEffect);

	//Blind in Temperate Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	MistBlind.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(MistBlind);
	//Template.AddTargetEffect(MistBlind);

	//Poison and Zombify in Xeno Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	XenoPoison = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	XenoPoison.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);
	//Template.AddTargetEffect(XenoPoison);

	XenoZombie = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false);
	XenoZombie.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);
	//Template.AddTargetEffect(XenoPoison);

	//double damage underground.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_CaveBonus';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = false;
	WeaponDamageEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	//Template.AddTargetEffect(WeaponDamageEffect);

	//Knockback in Urban Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Urban";
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.Urban_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	KnockbackEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(KnockbackEffect);
	//Template.AddTargetEffect(KnockbackEffect);
	
	Template.ActivationSpeech = 'IonicStorm';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Geo_IonicStorm';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CinescriptCameraType = "Templar_IonicStorm";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AlternateFriendlyNameFn = AllCreation_AlternateFriendlyName;
	Template.DamagePreviewFn = AllCreation_DamagePreview;
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}

static function bool AllCreation_AlternateFriendlyName(out string AlternateDescription, XComGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	
	if (InStr(BattleData.MapData.PlotMapName, "_TUN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_CSH_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALH_") != INDEX_NONE)
	{
		AlternateDescription = default.ACCaveDesc;
		return true;
	}
	
	if (InStr(BattleData.MapData.PlotMapName, "_CTY_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_SLM_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_RFT_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ABN_") != INDEX_NONE)
	{
		AlternateDescription = default.ACUrbanDesc;
		return true;
	}

	Switch (BattleData.MapData.Biome)
	{
		Case "Arid":
			AlternateDescription = default.ACAridDesc;
			return true;
		Case "Tundra":
			AlternateDescription = default.ACTundraDesc;
			return true;
		Case "Xenoform":
			AlternateDescription = default.ACXenoDesc;
			return true;
		Case "Temperate":
			AlternateDescription = default.ACTemperateDesc;
			return true;
	}
	
	return false;
}

function bool AllCreation_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (InStr(BattleData.MapData.PlotMapName, "_TUN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_CSH_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALH_") != INDEX_NONE)
	{
		AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}
	else
	{
		AbilityState.GetMyTemplate().AbilityTargetEffects[0].GetDamagePreview(TargetRef, AbilityState, false, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}
	return true;
}

static function X2AbilityTemplate AddNaturesWrath()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_CritByAbilitySet			RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNaturesWrath');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aggression";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_CritByAbilitySet';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	RegenEffect.AbilityNames = default.Geo_AbilityNames;
	RegenEffect.CritPerAbility = default.NaturesWrath_CritPerAbility;
	RegenEffect.CritDamagePerAbility = default.NaturesWrath_CritDmgPerAbility;
	RegenEffect.EffectName = 'MZNaturesWrath';
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2DataTemplate AddSeismicShift()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal	Cooldown;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityTrigger_PlayerInput		InputTrigger;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Condition_NatureEmbrace        GeoCondition;
	local X2Effect_Burning					AridBurn;
	local X2Effect_PersistentStatChange		XenoPoison;
	local X2Effect_Blind					MistBlind;
	local MZ_Effect_Zombify					XenoZombie;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_PersistentStatChange		ChillEffect;
	local X2Effect_PersistentStatChange		BitterChillEffect;
	local X2Effect_DLC_Day60Freeze			FreezeEffect;
	local X2Effect							FreezeCleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSeismicShift');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.SeismicShift_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Neutral;

	Template.TargetingMethod = class'MZ_TargetingMethod_SeismicShift';

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = false;
	CursorTarget.FixedAbilityRange = default.SeismicShift_Range;     // yes there is.
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.SeismicShift_Radius; // small amount so it just grabs one tile
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//No vis condition because that's from cast tile, not arrival tile.
	//Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_Seismic';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//Burning in Arid Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	AridBurn = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread);
	AridBurn.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(AridBurn);

	//Bitterfrost in Tundra
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
	ChillEffect.TargetConditions.AddItem(GeoCondition);
	BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
	BitterChillEffect.TargetConditions.AddItem(GeoCondition);
	FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
	FreezeEffect.TargetConditions.AddItem(GeoCondition);
	FreezeCleanse = class'BitterfrostHelper'.static.FreezeCleanse();
	FreezeCleanse.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(FreezeCleanse);
	Template.AddMultiTargetEffect(FreezeEffect);
	Template.AddMultiTargetEffect(BitterChillEffect);
	Template.AddMultiTargetEffect(ChillEffect);

	//Blind in Temperate Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	MistBlind.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(MistBlind);

	//Poison and Zombify in Xeno Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	XenoPoison = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	XenoPoison.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);

	XenoZombie = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false);
	XenoZombie.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);

	//double damage underground.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_Seismic_Cave';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//Knockback in Urban Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Urban";
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.Urban_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	KnockbackEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(KnockbackEffect);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.CustomFireAnim='HL_MZGeoTeleportStart';
	Template.CustomFireKillAnim='HL_MZGeoQuakeTeleportEnd';

	Template.ModifyNewContextFn = class'X2Ability_Cyberus'.static.Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = class'X2Ability_Cyberus'.static.Teleport_BuildGameState;
	Template.BuildVisualizationFn = MZTeleport_BuildVisualization;
	Template.CinescriptCameraType = "Cyberus_Teleport";
//BEGIN AUTOGENERATED CODE: Template Overrides 'Teleport'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Teleport'

	return Template;
}
simulated function MZTeleport_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack, BuildTrack, ActionMetadata;
	local X2Action_MoveVisibleTeleport CasterTeleport;
	local XComGameStateVisualizationMgr VisMgr;
	//local X2Action_MoveBegin CasterMoveBegin;
	local X2Action_MoveEnd CasterMoveEnd;
	local X2AbilityTemplate AbilityTemplate;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local X2Action_MoveTurn MoveTurnAction;
	local int i, j;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local XComGameState_EnvironmentDamage	EnvironmentDamageEvent;
	local X2VisualizerInterface TargetVisualizerInterface;

	local Array<X2Action> NodesToParentToWait;
	local int ScanAction;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good);

	// Turn to face the target action. The target location is the center of the ability's radius, stored in the 0 index of the TargetLocations
	MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(BuildTrack, AbilityContext));
	MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];

	// move action
	class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, BuildTrack);

	CasterTeleport = X2Action_MoveVisibleTeleport(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveVisibleTeleport', BuildTrack.VisualizeActor));
	CasterTeleport.ParamsStart.AnimName = AbilityTemplate.CustomFireAnim;
	CasterTeleport.ParamsStop.AnimName = AbilityTemplate.CustomFireKillAnim;
	//CasterMoveBegin = X2Action_MoveBegin(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveBegin', BuildTrack.VisualizeActor));
	CasterMoveEnd = X2Action_MoveEnd(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveEnd', BuildTrack.VisualizeActor));

	//****************************************************************************************
	//Stuff for applying effects to multitargets (generally, around landing location for teleport)
	//****************************************************************************************
	//enviromental effects/damage
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		for (i = 0; i < AbilityTemplate.AbilityShooterEffects.Length; ++i)
		{
			AbilityTemplate.AbilityShooterEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');		
		}

		for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		for (i = 0; i < AbilityTemplate.AbilityShooterEffects.Length; ++i)
		{
			AbilityTemplate.AbilityShooterEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');		
		}

		for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
		}

		for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}

	}

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for( i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i )
	{
		InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
		for( j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	// Reparent all of the apply weapon damage actions to the CasterMoveEnd, so it happens on landing.
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', NodesToParentToWait);
	for( ScanAction = 0; ScanAction < NodesToParentToWait.Length; ++ScanAction )
	{
		VisMgr.DisconnectAction(NodesToParentToWait[ScanAction]);
		VisMgr.ConnectAction(NodesToParentToWait[ScanAction], VisMgr.BuildVisTree, false, CasterMoveEnd);
		//VisMgr.ConnectAction(CasterMoveEnd, VisMgr.BuildVisTree, false, NodesToParentToWait[ScanAction]);
	}

	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToTerrain', NodesToParentToWait);
	for( ScanAction = 0; ScanAction < NodesToParentToWait.Length; ++ScanAction )
	{
		VisMgr.DisconnectAction(NodesToParentToWait[ScanAction]);
		VisMgr.ConnectAction(NodesToParentToWait[ScanAction], VisMgr.BuildVisTree, false, CasterMoveEnd);
		//VisMgr.ConnectAction(CasterMoveEnd, VisMgr.BuildVisTree, false, NodesToParentToWait[ScanAction]);
	}
}

static function X2AbilityTemplate EarthSpike()
{
	local X2AbilityTemplate				Template;
	local X2AbilityTarget_Cursor		Cursor;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local MZ_Effect_Pillar				PillarEffect;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local MZ_Condition_NatureEmbrace        GeoCondition;
	local X2Effect_Burning					AridBurn;
	local X2Effect_PersistentStatChange		XenoPoison;
	local X2Effect_Blind					MistBlind;
	local MZ_Effect_Zombify					XenoZombie;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_PersistentStatChange		ChillEffect;
	local X2Effect_PersistentStatChange		BitterChillEffect;
	local X2Effect_DLC_Day60Freeze			FreezeEffect;
	local X2Effect							FreezeCleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZEarthSpike');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'MZ_TargetingMethod_GlacialSpike';

	Cursor = new class'X2AbilityTarget_Cursor';
	Cursor.bRestrictToSquadsightRange = true;
	Cursor.FixedAbilityRange = default.EarthSpike_Range;
	Template.AbilityTargetStyle = Cursor;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.EarthSpike_Radius; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints=true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.EarthSpike_Cooldown;
	Template.AbilityCooldown = Cooldown;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZGeo_PillarCast';
	Template.ActivationSpeech = 'Pillar';
//END AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Pillar";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ConcealmentRule = eConceal_Never;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	PillarEffect = new class'MZ_Effect_Pillar';
	PillarEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);	
	PillarEffect.DestructibleArchetype = "FX_Templar_Pillar.Pillar_Destructible";
	PillarEffect.Duration = default.EarthSpike_Duration;
	Template.AddShooterEffect(PillarEffect);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_ESpike';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//Burning in Arid Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Arid";
	AridBurn = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.AridBurn_Damage, default.AridBurn_Spread);
	AridBurn.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(AridBurn);

	//Bitterfrost in Tundra
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Tundra";
	ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
	ChillEffect.TargetConditions.AddItem(GeoCondition);
	BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
	BitterChillEffect.TargetConditions.AddItem(GeoCondition);
	FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
	FreezeEffect.TargetConditions.AddItem(GeoCondition);
	FreezeCleanse = class'BitterfrostHelper'.static.FreezeCleanse();
	FreezeCleanse.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(FreezeCleanse);
	Template.AddMultiTargetEffect(FreezeEffect);
	Template.AddMultiTargetEffect(BitterChillEffect);
	Template.AddMultiTargetEffect(ChillEffect);

	//Blind in Temperate Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Temperate";
	MistBlind = class'X2Effect_Blind'.static.CreateBlindEffect(default.MistBlind_Turns, default.MistBlind_VisionMult);
	MistBlind.AddPersistentStatChange(eStat_DetectionRadius, default.MistBlind_VisionMult, MODOP_PostMultiplication);
	MistBlind.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(MistBlind);

	//Poison and Zombify in Xeno Biome
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Xenoform";
	XenoPoison = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	XenoPoison.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);

	XenoZombie = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.XenoZombie_Turns, false);
	XenoZombie.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(XenoPoison);

	//double damage underground.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Cave";
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZGeo_ESpike_Cave';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//Knockback in Urban Biome.
	GeoCondition = new class'MZ_Condition_NatureEmbrace';
	GeoCondition.Biome = "Urban";
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.Urban_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	KnockbackEffect.TargetConditions.AddItem(GeoCondition);
	Template.AddMultiTargetEffect(KnockbackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GlacialSpike_BuildVisualization;

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	return Template;
}
function GlacialSpike_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Destructible DestructibleState;
	local VisualizationActionMetadata BuildTrack;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Destructible', DestructibleState)
	{
		break;
	}
	`assert(DestructibleState != none);

	BuildTrack.StateObject_NewState = DestructibleState;
	BuildTrack.StateObject_OldState = DestructibleState;
	BuildTrack.VisualizeActor = `XCOMHISTORY.GetVisualizer(DestructibleState.ObjectID);

	//class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext());
	class'X2Action_ShowSpawnedDestructible'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext());

}