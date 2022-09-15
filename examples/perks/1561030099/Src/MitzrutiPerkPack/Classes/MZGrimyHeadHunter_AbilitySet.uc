class MZGrimyHeadHunter_AbilitySet extends X2Ability config(GrimyPerkPorts);

var config int PIERCING_SHOT_CHARGES, PIERCING_SHOT_COOLDOWN;
var config int TWIN_FANG_CHARGES, TWIN_FANG_COOLDOWN;
var config int THUNDERCLAP_CHARGES, THUNDERCLAP_COOLDOWN;
var config int POINT_BLANK_AIM, POINT_BLANK_CRIT, POINT_BLANK_TILES;

var config int BUCKSHOT_CHARGES, BUCKSHOT_COOLDOWN;
var config int INCENDIARY_SHOT_CHARGES, INCENDIARY_SHOT_COOLDOWN;
var config int DOUBLE_TAP_COOLDOWN;
var config int HEXHUNTER_CHARGES;

var config float THUNDERCLAP_BONUS, INCENDIARY_SHOT_RADIUS, BUCKSHOT_DIAMETER, POINT_BLANK_BONUS, HEXHUNTER_BONUS, BUCKSHOT_BONUS, PIERCING_SHOT_BONUS;

var config int BLADE_OIL_CHARGES, BLADE_OIL_COOLDOWN;
var config float EXECUTE_BONUS;
var config int RAPIDSLASH_COOLDOWN, MULTIHOOK_RANGE;

var localized string PointBlankBonusName, ThunderclapBonusName, HexHunterBonusName, PiercingShotBonusName, BuckshotBonusName;

static function array<X2DataTemplate> CreateTemplates() {
	local array<X2DataTemplate> Templates;

	// SQUADDIE
	Templates.AddItem(GrimyPiercingShot('GrimyPiercingShot','GrimyPiercingShotBonus',"img:///GrimyClassHHPackage.UIPerk_PiercingShot",default.PIERCING_SHOT_CHARGES,default.PIERCING_SHOT_COOLDOWN,class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY));
	// CORPORAL
	Templates.AddItem(AddRushedShot());
	// SERGEANT	
	Templates.AddItem(GrimyThunderclap('GrimyThunderclap','GrimyThunderclapBonus',"img:///GrimyClassHHPackage.UIPerk_Thunderclap",default.THUNDERCLAP_CHARGES,default.THUNDERCLAP_COOLDOWN,class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY));
	Templates.AddItem(GrimyPointBlank('GrimyPointBlank',"img:///UILibrary_PerkIcons.UIPerk_scope", default.POINT_BLANK_TILES,class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY));
	
	// CAPTAIN
	Templates.AddItem(GrimyIncendiaryShot('GrimyIncendiaryShot',"img:///GrimyClassHHPackage.UIPerk_IncendiaryShot",default.INCENDIARY_SHOT_CHARGES,default.INCENDIARY_SHOT_COOLDOWN,default.INCENDIARY_SHOT_RADIUS,class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY));
	// MAJOR
	Templates.AddItem(GrimyTwinFangs('GrimyTwinFangs',"img:///GrimyClassHHPackage.UIPerk_TwinFangs",default.TWIN_FANG_CHARGES,default.TWIN_FANG_COOLDOWN,class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY));
	//Templates.AddItem(GrimyTwinFangsShot('GrimyTwinFangsShot'));
	// COLONEL
	Templates.AddItem(GrimyBuckshot('GrimyBuckshot','GrimyBuckshotBonus',"img:///GrimyClassHHPackage.UIPerk_Buckshot",default.BUCKSHOT_CHARGES,default.BUCKSHOT_COOLDOWN,default.BUCKSHOT_DIAMETER,class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY));
	Templates.AddItem(GrimyDoubleTap('GrimyDoubleTap',"img:///UILibrary_PerkIcons.UIPerk_doubletap", class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY));
	
	// GTS
	Templates.AddItem(GrimyHexHunter('GrimyHexHunter','GrimyHexHunterBonus',"img:///UILibrary_PerkIcons.UIPerk_deathblossom",default.HEXHUNTER_CHARGES,class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY));
	
	// PASSIVES
	Templates.AddItem(GrimyPointBlankBonus('GrimyPointBlankBonus','GrimyPointBlank',default.POINT_BLANK_AIM, default.POINT_BLANK_CRIT, default.POINT_BLANK_BONUS));
	Templates.AddItem(GrimyThunderclapBonus('GrimyThunderclapBonus', 'GrimyThunderclap', default.THUNDERCLAP_BONUS));
	Templates.AddItem(GrimyHexHunterBonus('GrimyHexHunterBonus', 'GrimyHexHunter',"img:///UILibrary_PerkIcons.UIPerk_deathblossom", default.HEXHUNTER_BONUS, default.HexHunterBonusName));
	Templates.AddItem(GrimyBonusDamage('GrimyPiercingShotBonus','GrimyPiercingShot', default.PIERCING_SHOT_BONUS, default.PiercingShotBonusName));
	Templates.AddItem(GrimyBonusDamage('GrimyBuckshotBonus','GrimyBuckshot', default.BUCKSHOT_BONUS, default.BuckshotBonusName));

	// CORPORAL
	Templates.AddItem(GrimyBladeOil('GrimyBladeOil',"img:///GrimyClassHHPackage.UIPerk_BladeOil",default.BLADE_OIL_CHARGES, default.BLADE_OIL_COOLDOWN, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY));
	// MAJOR
	Templates.AddItem(GrimyRapidSlashHH('GrimyRapidSlashHH',"img:///UILibrary_PerkIcons.UIPerk_charge",default.RAPIDSLASH_COOLDOWN, class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY));
	// PASSIVES
	Templates.AddItem(GrimyExecuteBonus('GrimyExecuteBonus',"img:///GrimyClassHHPackage.UIPerk_mark",default.EXECUTE_BONUS));
	Templates.AddItem(PurePassive('GrimyEntangle',"img:///UILibrary_PerkIcons.UIPerk_disoriented",false));

	Templates.AddItem(GrimyMultiHook());

	return Templates;
}

static function X2AbilityTemplate GrimyHexHunter(name TemplateName, name BonusAbility, string IconImage, int BonusCharges, int HUDPriority) {
	local X2AbilityTemplate					Template;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);
	
	Template.AbilityCosts.length = 0;

	Template.AdditionalAbilities.AddItem(BonusAbility);
	

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	//Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.IconImage = IconImage; 
	Template.ShotHUDPriority = HUDPriority;


	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate GrimyDoubleTap(name TemplateName, string IconImage, int HUDPriority)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local Grimy_Cost_ActionPoints	ActionPointCost;
	
	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName, false, true, false);
	Template.bCrossClassEligible = false;
	
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;

	Template.AbilityCosts.length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'standard';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DOUBLE_TAP_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.bAllowFreeFireWeaponUpgrade = false; 

	return Template;
}

static function X2AbilityTemplate GrimyCursorShot(name TemplateName, string IconImage, int BonusCharges, int BonusCooldown, int HUDPriority) {
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	// Macro to do localisation and stuffs
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

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = IconImage; // 
	Template.ShotHUDPriority = HUDPriority;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects
	
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;	
}

static function X2AbilityTemplate GrimyPiercingShot(name TemplateName, name BonusAbility, string IconImage, int BonusCharges, int BonusCooldown, int HUDPriority) {
	local X2AbilityTemplate                 Template;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line			TargetStyle;

	Template = GrimyCursorShot(TemplateName, IconImage, BonusCharges, BonusCooldown, HUDPriority);
	Template.bCrossClassEligible = false;
	
	Template.AdditionalAbilities.AddItem(BonusAbility);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Line';
	TargetStyle.bSightRangeLimited = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddMultiTargetEffect(new class'Grimy_Effect_ShredTier');

	Template.AbilityToHitCalc = default.Deadeye;
		
	Template.TargetingMethod = class'X2TargetingMethod_Line';
	Template.BuildNewGameStateFn = PiercingShotAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate GrimyBuckShot(name TemplateName, name BonusAbility, string IconImage, int BonusCharges, int BonusCooldown, float BonusDiameter, int HUDPriority) {
	local X2AbilityTemplate                 Template;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone			TargetStyle;
	
	Template = GrimyCursorShot(TemplateName, IconImage, BonusCharges, BonusCooldown, HUDPriority);
	Template.bCrossClassEligible = false;

	Template.AdditionalAbilities.AddItem(BonusAbility);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Cone';
	TargetStyle.bUseWeaponRangeForLength = true;
	TargetStyle.ConeEndDiameter = BonusDiameter * class'XComWorldData'.const.WORLD_StepSize;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddMultiTargetEffect(new class'Grimy_Effect_ShredTier');
	
	Template.AbilityToHitCalc = default.Deadeye;
		
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	return Template;	
}

static function X2AbilityTemplate GrimyIncendiaryShot(name TemplateName, string IconImage, int BonusCharges, int BonusCooldown, float BonusRadius, int HUDPriority) {
	local X2AbilityTemplate                 Template;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	
	Template = GrimyCursorShot(TemplateName, IconImage, BonusCharges, BonusCooldown, HUDPriority);
	Template.bCrossClassEligible = false;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = BonusRadius;
	TargetStyle.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect(); 
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Fire';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bAllowWeaponUpgrade = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1));

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
		
	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';

	return Template;	
}

static function X2AbilityTemplate GrimyPointBlank(name TemplateName, string IconImage, int MaxDistance, int HUDPriority) {
	local X2AbilityTemplate						Template;	
	local Grimy_Condition_PointBlank		PointBlankCondition;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);
	Template.bCrossClassEligible = false;
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;
	Template.AdditionalAbilities.AddItem('GrimyPointBlankBonus');

	PointBlankCondition = new class'Grimy_Condition_PointBlank';
	PointBlankCondition.MaxDistance = MaxDistance;
	Template.AbilityTargetConditions.AddItem(PointBlankCondition);

	return Template;
}

static function X2AbilityTemplate GrimyTwinFangs(name TemplateName, string IconImage, int BonusCharges, int BonusCooldown, int HUDPriority) {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local int								i;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;

	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot(TemplateName, IconImage, true);
	//Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[i]);

		if (AmmoCost != None) {
			AmmoCost.iAmmo = 2;
			break;
		}
	}

	if ( BonusCharges > 0 )	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);

		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	}

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}
		
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	MakeAbilityRandomFire(Template, 1);
	
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// passive abilities
static function X2AbilityTemplate GrimyHexHunterBonus(name TemplateName, name AbilityName, string IconImage, float BonusDamage, optional string BonusName = "Hex Hunter") {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusHexHunter	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = IconImage;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusHexHunter';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = BonusDamage;
	DamageEffect.AbilityName = AbilityName;
	DamageEffect.FriendlyName = BonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimyThunderclapBonus(name TemplateName, name AbilityName, float BonusDamage) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusThunderclap	DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusThunderclap';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = BonusDamage;
	DamageEffect.AbilityName.AddItem(AbilityName);
	DamageEffect.FriendlyName = default.ThunderclapBonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimyPointBlankBonus(name TemplateName, name AbilityName, int AimBonus, int CritBonus, float DamageBonus) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusPointBlank	ShotEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ShotEffect = new class'Grimy_Effect_BonusPointBlank';
	ShotEffect.BuildPersistentEffect(1, true, false, false);
	ShotEffect.AimBonus = AimBonus;
	ShotEffect.CritBonus = CritBonus;
	ShotEffect.MaxRange = default.POINT_BLANK_TILES;
	ShotEffect.DamageBonus = DamageBonus;
	ShotEffect.AbilityName = AbilityName;
	ShotEffect.FriendlyName = default.PointBlankBonusName;
	Template.AddTargetEffect(ShotEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2AbilityTemplate GrimyBonusDamage(name TemplateName, name AbilityName, float BonusDamage, optional string LocBonusName = "Ability") {
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
	DamageEffect.FriendlyName = LocBonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function XComGameState PiercingShotAbility_BuildGameState(XComGameStateContext Context) {
	local XComGameState NewGameState;
	
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
	TypicalAbility_FillOutGameState(NewGameState);

	return NewGameState;
}

static function X2AbilityTemplate GrimyBladeOil(name TemplateName, string IconImage, int BonusCharges, int BonusCooldown, int HUDPriority)
{
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility(TemplateName);
	Template.bCrossClassEligible = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Poison';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
	
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

	return Template;
}

static function X2AbilityTemplate GrimyRapidSlashHH(name TemplateName, string IconImage, int BonusCooldown, int HUDPriority)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local Grimy_Cost_ActionPoints	ActionPointCost;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility(TemplateName);
	
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;

	Template.AbilityCosts.length = 0;

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'standard';
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = BonusCooldown;
	Template.AbilityCooldown = Cooldown;

	return Template;
}

// passive abilities

static function X2AbilityTemplate GrimyExecuteBonus(name TemplateName, string IconImage, float BonusDamage) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusExecute		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.IconImage = IconImage;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusExecute';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = BonusDamage;
	DamageEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddRushedShot()
{
	local X2AbilityTemplate					Template;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('GrimyRushedShot', false, true, true);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_targetpaint";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	//need to reselect the target before firing.
	Template.BuildNewGameStateFn = RandomSingleTarget_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyThunderClap(name TemplateName, name BonusAbility, string IconImage, int BonusCharges, int BonusCooldown, int HUDPriority) {
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	
	Template = class'MZBulletArt_AbilitySet'.static.Add_MZNonStandardShot(TemplateName, IconImage, false, false, false, false);
	Template.bCrossClassEligible = false;
	Template.ShotHUDPriority = HUDPriority;

	if ( BonusCharges > 0 )	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);

		Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
		Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	}

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect(); 
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Electrical';
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.BuildNewGameStateFn = RandomSingleTarget_BuildGameState;

	Template.AdditionalAbilities.AddItem(BonusAbility);

	return Template;
}

static function XComGameState RandomSingleTarget_BuildGameState(XComGameStateContext Context)
{
	local XComGameState					NewGameState;
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	AbilityContext;
	local X2AbilityTemplate AbilityTemplate;
	local array<StateObjectReference>	VisibleTargets;

	History = `XCOMHISTORY;	

	AbilityContext = XComGameStateContext_Ability(Context);
	AbilityTemplate = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();
	
	class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(AbilityContext.InputContext.SourceObject.ObjectID,VisibleTargets,AbilityTemplate.AbilityTargetConditions);

	AbilityContext.InputContext.PrimaryTarget = VisibleTargets[`SYNC_RAND_STATIC(VisibleTargets.length)];

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
	TypicalAbility_FillOutGameState(NewGameState);

	return NewGameState;
}

static function X2AbilityTemplate GrimyMultiHook()
{
	local X2AbilityTemplate			Template;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddGrapple('GrimyMultiHook');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_grapple";

	Template.TargetingMethod = class'Grimy_TargetingMethod_RocketLauncher';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1.0;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.MULTIHOOK_RANGE;
	Template.AbilityTargetStyle = CursorTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts[0] = ActionPointCost;

	Template.AbilityCooldown = none;

	Template.AbilityShooterConditions.Remove(1,1);

	//Template.BuildVisualizationFn = class'MZUnspecific_AbilitySet'.static.MZTeleport_BuildVisualization;
	Template.BuildVisualizationFn = MultiHook_BuildVisualization;

	return Template;
}

simulated function MultiHook_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local StateObjectReference MovingUnitRef;	
	local VisualizationActionMetadata ActionMetadata;
	local VisualizationActionMetadata EmptyTrack;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_EnvironmentDamage EnvironmentDamage;
	local X2Action_PlaySoundAndFlyOver CharSpeechAction;
	local MZ_Action_Grapple GrappleAction;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_RevealArea RevealAreaAction;
	local X2Action_UpdateFOW FOWUpdateAction;
	
	History = `XCOMHISTORY;
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	MovingUnitRef = AbilityContext.InputContext.SourceObject;
	
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(MovingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(MovingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(MovingUnitRef.ObjectID);

	CharSpeechAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	CharSpeechAction.SetSoundAndFlyOverParameters(None, "", 'GrapplingHook', eColor_Good);

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	RevealAreaAction.TargetLocation = AbilityContext.InputContext.TargetLocations[0];
	RevealAreaAction.AssociatedObjectID = MovingUnitRef.ObjectID;
	RevealAreaAction.ScanningRadius = class'XComWorldData'.const.WORLD_StepSize * 4;
	RevealAreaAction.bDestroyViewer = false;

	FOWUpdateAction = X2Action_UpdateFOW(class'X2Action_UpdateFOW'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	FOWUpdateAction.BeginUpdate = true;

	ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	ExitCoverAction.bUsePreviousGameState = true;

	GrappleAction = MZ_Action_Grapple(class'MZ_Action_Grapple'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	GrappleAction.DesiredLocation = AbilityContext.InputContext.TargetLocations[0];

	// destroy any windows we flew through
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
	{
		ActionMetadata = EmptyTrack;

		//Don't necessarily have a previous state, so just use the one we know about
		ActionMetadata.StateObject_OldState = EnvironmentDamage;
		ActionMetadata.StateObject_NewState = EnvironmentDamage;
		ActionMetadata.VisualizeActor = History.GetVisualizer(EnvironmentDamage.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());
	}

	FOWUpdateAction = X2Action_UpdateFOW(class'X2Action_UpdateFOW'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	FOWUpdateAction.EndUpdate = true;

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	RevealAreaAction.AssociatedObjectID = MovingUnitRef.ObjectID;
	RevealAreaAction.bDestroyViewer = true;
}


static function MakeAbilityRandomFire(X2AbilityTemplate Template, optional int iExtraTargets=0, optional bool bCanHitSameTarget)
{
	local Grimy_MultiTarget GrimyTargetStyle;

	if ( iExtraTargets == 0 )
	{
		Template.BuildNewGameStateFn = RandomSingleTarget_BuildGameState;
	}
	else
	{
		GrimyTargetStyle = new class'Grimy_MultiTarget';
		//GrimyTargetStyle.bAllowDestructibleObjects = true;
		GrimyTargetStyle.NumTargets = iExtraTargets +1;
		GrimyTargetStyle.bAllowSameTarget = bCanHitSameTarget;
		Template.AbilityTargetStyle = GrimyTargetStyle;
		Template.BuildNewGameStateFn = RandomMultiTarget_BuildGameState;
		Template.BuildVisualizationFn = Faceoff_BuildVisualization;
	}

	return;
}

static function XComGameState RandomMultiTarget_BuildGameState(XComGameStateContext Context)
{
	local XComGameState					NewGameState;
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	AbilityContext;
	local X2AbilityTemplate				AbilityTemplate;
	local array<StateObjectReference>	VisibleTargets, FinalTargetList;
	local Grimy_MultiTarget				GrimyTarget;
	local int							i;

	History = `XCOMHISTORY;	

	AbilityContext = XComGameStateContext_Ability(Context);
	AbilityTemplate = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID)).GetMyTemplate();
	GrimyTarget = Grimy_MultiTarget(AbilityTemplate.AbilityTargetStyle);
	
	class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(AbilityContext.InputContext.SourceObject.ObjectID, VisibleTargets, AbilityTemplate.AbilityTargetConditions);

	//AbilityContext.InputContext.PrimaryTarget = VisibleTargets[`SYNC_RAND_STATIC(VisibleTargets.length)];

	if ( GrimyTarget.bAllowSameTarget ) {
		for ( i=0; i<GrimyTarget.NumTargets; i++ ) {
			FinalTargetList.AddItem(VisibleTargets[`SYNC_RAND_STATIC(VisibleTargets.length)]);
		}
	}
	else {
		FinalTargetList = VisibleTargets;
		while ( FinalTargetList.length > GrimyTarget.NumTargets ) {
			FinalTargetList.Remove(`SYNC_RAND_STATIC(FinalTargetList.length),1);
		}
	}

	AbilityContext.InputContext.PrimaryTarget = FinalTargetList[0];
	FinalTargetList.Remove(0,1);
	AbilityContext.InputContext.MultiTargets = FinalTargetList;
	

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
	TypicalAbility_FillOutGameState(NewGameState);

	return NewGameState;
}
function Faceoff_BuildVisualization(XComGameState VisualizeGameState)
{
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;
	local X2Action_Fire                 FireAction;
	local X2Action_Fire_Faceoff         FireFaceoffAction;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	

	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface;
	local int                       EffectIndex, TargetIndex;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local VisualizationActionMetadata        SourceTrack;
	local XComGameStateHistory      History;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local name         ApplyResult;

	local X2Action_StartCinescriptCamera CinescriptStartAction;
	local X2Action_EndCinescriptCamera   CinescriptEndAction;
	local X2Camera_Cinescript            CinescriptCamera;
	local string                         PreviousCinescriptCameraType;
	local X2Effect                       TargetEffect;

	local X2Action_MarkerNamed				JoinActions;
	local array<X2Action>					LeafNodes;
	local XComGameStateVisualizationMgr		VisualizationMgr;
	local X2Action_ApplyWeaponDamageToUnit	ApplyWeaponDamageAction;


	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;

	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if( SourceTrack.StateObject_NewState == none )
		SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	SourceTrack.VisualizeActor = ShooterVisualizer;

	if( AbilityTemplate.ActivationSpeech != '' )     //  allows us to change the template without modifying this function later
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(SourceTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}


	// Add a Camera Action to the Shooter's Metadata.  Minor hack: To create a CinescriptCamera the AbilityTemplate 
	// must have a camera type.  So manually set one here, use it, then restore.
	PreviousCinescriptCameraType = AbilityTemplate.CinescriptCameraType;
	AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
	CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
	CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptStartAction.CinescriptCamera = CinescriptCamera;
	AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;


	class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	//  Fire at the primary target first
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	FireAction.SetFireParameters(Context.IsResultContextHit(), , false);
	//  Setup target response
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
	ActionMetadata = EmptyTrack;
	ActionMetadata.VisualizeActor = TargetVisualizer;
	TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
	if( TargetStateObject != none )
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID,
														   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
														   eReturnType_Reference,
														   VisualizeGameState.HistoryIndex);
		`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
	}
	else
	{
		//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
		//and show no change.
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	}

	for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
	{
		ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

		// Target effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

		// Source effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
	}
	if( TargetVisualizerInterface != none )
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
	if ( ApplyWeaponDamageAction != None)
	{
		VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
		VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireAction);
	}

	//  Now configure a fire action for each multi target
	for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; TargetIndex++ )
	{
		// Add an action to pop the previous CinescriptCamera off the camera stack.
		CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptEndAction.CinescriptCamera = CinescriptCamera;
		CinescriptEndAction.bForceEndImmediately = true;

		// Add an action to push a new CinescriptCamera onto the camera stack.
		AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
		CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
		CinescriptCamera.TargetObjectIdOverride = AbilityContext.MultiTargets[TargetIndex].ObjectID;
		CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptStartAction.CinescriptCamera = CinescriptCamera;
		AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;

		// Add a custom Fire action to the shooter Metadata.
		TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		FireFaceoffAction = X2Action_Fire_Faceoff(class'X2Action_Fire_Faceoff'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		FireFaceoffAction.SetFireParameters(Context.IsResultContextMultiHit(TargetIndex), AbilityContext.MultiTargets[TargetIndex].ObjectID, false);
		FireFaceoffAction.vTargetLocation = TargetVisualizer.Location;


		//  Setup target response
		TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = TargetVisualizer;
		TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		if( TargetStateObject != none )
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID,
															   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
															   eReturnType_Reference,
															   VisualizeGameState.HistoryIndex);
			`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
		}
		else
		{
			//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			//and show no change.
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; EffectIndex++ )
		{
			TargetEffect = AbilityTemplate.AbilityMultiTargetEffects[EffectIndex];
			ApplyResult = Context.FindMultiTargetEffectApplyResult(TargetEffect, TargetIndex);

			// Target effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

			// Source effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		}
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}

		ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
		if( ApplyWeaponDamageAction != None )
		{
			VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
			VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireFaceoffAction);
		}
	}
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	// Add an action to pop the last CinescriptCamera off the camera stack.
	CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptEndAction.CinescriptCamera = CinescriptCamera;

	//Add a join so that all hit reactions and other actions will complete before the visualization sequence moves on. In the case
	// of fire but no enter cover then we need to make sure to wait for the fire since it isn't a leaf node
	VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

	if( VisualizationMgr.BuildVisTree.ChildActions.Length > 0 )
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceTrack, Context, false, none, LeafNodes));
		JoinActions.SetName("Join");
	}
}