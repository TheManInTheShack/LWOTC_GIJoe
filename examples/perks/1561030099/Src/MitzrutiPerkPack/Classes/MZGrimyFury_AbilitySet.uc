class MZGrimyFury_AbilitySet extends X2Ability config(GrimyPerkPorts);

var config float STRAFE_BONUS, SPEEDSTER_MOBILITY;
var config int STRAFE_ACTIONS, SPEEDSTER_ACTIONS;
var config float WILLTOSURVIVE_MULT;
var config int STRAFE_MOBILITY;
var config int ARCANE_MISSILE_COUNT;
var config int SOUL_TAP_COST, SOUL_TAP_COOLDOWN;
var config int SPRAYPRAY_NUMTARGETS, SPRAYPRAY_COOLDOWN;
var config float REAVE_BONUS, SPRAYPRAY_BONUS;

var config int REAVE_COST, PYROKINESIS_COST, MADNESS_COST;
var config int REAVE_COOLDOWN, PYROKINESIS_COOLDOWN, MADNESS_COOLDOWN, MADNESS_DURATION;
var config int PYROKINESIS_BURN, PYROKINESIS_SPREAD, MADNESS_GRANTACTIONS, MADNESS_CHARGES;

var config array<name> EXCLUDE_CHARS;

var config int ANOMALY_COST, ANOMALY_CHARGES, ANOMALY_COOLDOWN, ANOMALY_RADIUS, ANOMALY_RANGE;

var localized string StrafeBonusName, SprayAndPrayBonusName, ReaveBonusName;

static function array<X2DataTemplate> CreateTemplates() {
	local array<X2DataTemplate> Templates;

	//Squaddie
	Templates.AddItem(GrimyStrafe('GrimyStrafe','GrimyStrafeBonus',"img:///GrimyClassFuryPackage.Strafe",class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY));
	//Corporal
	Templates.AddItem(GrimySustainedFire('GrimySustainedFire',"img:///GrimyClassFuryPackage.SustainedFire"));
	Templates.AddItem(GrimyPyrokinesis());
	//Sergeant
	Templates.AddItem(GrimySoulTap('GrimySoulTap',"img:///GrimyClassFuryPackage.UIPerk_Soultap",default.SOUL_TAP_COST,default.SOUL_TAP_COOLDOWN,class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY));
	//Lieutenant
	Templates.AddItem(PurePassive('GrimyReinvigorate',"img:///GrimyClassFuryPackage.Reinvigorate",true));
	Templates.AddItem(GrimyReave());
	Templates.AddItem(GrimyReaveBonus("img:///UILibrary_PerkIcons.UIPerk_Bloodcall", default.REAVE_BONUS));
	//Major
	Templates.AddItem(GrimyBulletRoulette('GrimyBulletRoulette',"img:///GrimyClassFuryPackage.BulletRoulette"));
	Templates.AddItem(GrimyMadness());
	//COLONEL
	Templates.AddItem(GrimySprayAndPray('GrimySprayAndPray',"img:///GrimyClassFuryPackage.SprayAndPray",default.SPRAYPRAY_NUMTARGETS, default.SPRAYPRAY_COOLDOWN, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY));
	Templates.AddItem(GrimyAnomaly('GrimyAnomaly',"img:///UILibrary_PerkIcons.UIPerk_psi_rift",default.ANOMALY_COST, default.ANOMALY_CHARGES,default.ANOMALY_COOLDOWN,default.ANOMALY_RADIUS,default.ANOMALY_RANGE,class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY));
	
	// Passive Bonuses
	Templates.AddItem(GrimyStrafeBonus('GrimySpeedster','',0, default.SPEEDSTER_MOBILITY,false, default.SPEEDSTER_ACTIONS));
	Templates.AddItem(GrimyStrafeBonus('GrimyStrafeBonus','GrimyStrafe',default.STRAFE_BONUS, default.STRAFE_MOBILITY, true, default.STRAFE_ACTIONS));
	Templates.AddItem(GrimyWillToSurvive('GrimyWillToSurvive',"img:///UILibrary_PerkIcons.UIPerk_star_will",default.WILLTOSURVIVE_MULT));
	//Templates.AddItem(GrimyBonusDamage('GrimySprayAndPrayShotBonus','GrimySprayAndPrayShot',default.SPRAYPRAY_BONUS));
	Templates.AddItem(GrimyBonusDamage('GrimySprayAndPrayBonus','GrimySprayAndPray',default.SPRAYPRAY_BONUS, 0, 0, default.SprayAndPrayBonusName));

	//Templates.AddItem(GrimySprayAndPrayShot());
	
	return Templates;
}

static function X2AbilityTemplate GrimyAnomaly(name TemplateName, string IconImage, int HPCost, int BonusCharges, int BonusCooldown, int BonusRadius, int BonusRange, int HUDPriority) {
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local Grimy_AbilityCost_HP		HealthCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.ShotHUDPriority = HUDPriority;
	Template.IconImage = IconImage;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Psi_MindControl';
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( HPCost > 0 ) {
		HealthCost = new class'Grimy_AbilityCost_HP';
		HealthCost.Cost = HPCost;
		Template.AbilityCosts.AddItem(HealthCost);
	}

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

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = BonusRange;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = BonusRadius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'GrimyAnomaly';
	Template.AddMultiTargetEffect(DamageEffect);


	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.BuildNewGameStateFn = AnomalyAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	return Template;
}

function XComGameState AnomalyAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState_MissionSite			MissionSite;
	local vector							TargetLocation;

	local XComGameState_AIReinforcementSpawner NewAIReinforcementSpawnerState;
	local XComTacticalMissionManager MissionManager;
	local ConfigurableEncounter Encounter;
	local Name EncounterID;
	
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);
		
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );
	MissionSite = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID) );
	TargetLocation = XComGameStateContext_Ability(NewGameState.GetContext()).InputContext.TargetLocations[0];

	//class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(GetReinforcementName(MissionSite), , true, TargetLocation, 0); //, NewGameState);

	EncounterID = GetReinforcementName(MissionSite);
	MissionManager = `TACTICALMISSIONMGR;
	MissionManager.GetConfigurableEncounter(EncounterID, Encounter);

	NewAIReinforcementSpawnerState = XComGameState_AIReinforcementSpawner(NewGameState.CreateStateObject(class'XComGameState_AIReinforcementSpawner'));
	//NewAIReinforcementSpawnerState.Countdown = 1;
	NewAIReinforcementSpawnerState.SpawnInfo.EncounterID = EncounterID;
	NewAIReinforcementSpawnerState.SpawnVisualizationType = 'PsiGate';

	NewAIReinforcementSpawnerState.SpawnInfo.SpawnLocation = TargetLocation;
	NewGameState.AddStateObject(NewAIReinforcementSpawnerState);

	TypicalAbility_FillOutGameState(NewGameState);

	return NewGameState;
}

function name GetReinforcementName(XComGameState_MissionSite MissionSite) {
	local name RetName;

	RetName = MissionSite.SelectedMissionData.SelectedEncounters[`SYNC_RAND(MissionSite.SelectedMissionData.SelectedEncounters.length)].SelectedEncounterName;
	if ( default.EXCLUDE_CHARS.find(RetName) == INDEX_NONE ) {
		return RetName;
	}
	else {
		return GetReinforcementName(MissionSite);
	}
}

static function X2AbilityTemplate GrimyBulletRoulette(name TemplateName, string IconImage) {
	local X2AbilityTemplate									Template;
	local Grimy_Effect_BulletRoulette				AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = IconImage;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;

	AmmoEffect = new class'Grimy_Effect_BulletRoulette';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(AmmoEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimyReaveBonus(string IconImage, float DamageMult) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusDamage		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimyReaveBonus');
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Grimy_Effect_BonusDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = DamageMult;
	DamageEffect.AbilityName = 'GrimyReave';
	DamageEffect.FriendlyName = default.ReaveBonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimySoulTap(name TemplateName, string IconImage, int HPCost, int BonusCooldown, int HUDPriority) {
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_GrantActionPoints	ActionPointEffect;
	local X2AbilityCooldown             Cooldown;
	local Grimy_AbilityCost_HP			HealthCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	Template.AbilityIconColor = "C34144";
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = False;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( HPCost > 0 ) {
		HealthCost = new class'Grimy_AbilityCost_HP';
		HealthCost.Cost = HPCost;
		Template.AbilityCosts.AddItem(HealthCost);
	}

	if ( BonusCooldown > 0 ) {
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = BonusCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 2;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	return Template;
}

static function X2AbilityTemplate GrimySustainedFire(name TemplateName, string IconImage) {
	local X2AbilityTemplate									Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = IconImage;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate GrimySprayAndPray(name TemplateName, string IconImage, int NumTargets, int BonusCooldown, int HUDPriority, optional int BonusCharges = 0) {
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName, false, false, false);
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = HUDPriority;

	Template.AbilityCosts.length = 0;

	if ( BonusCharges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = BonusCharges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = NumTargets;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.AdditionalAbilities.AddItem('GrimySprayAndPrayBonus');

	class'MZGrimyHeadHunter_AbilitySet'.static.MakeAbilityRandomFire(Template, NumTargets-1);

	return Template;
}

static function X2AbilityTemplate GrimyStrafe(name TemplateName, name BonusAbility, string IconImage, int HUDPriority) {
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot(TemplateName);

	Template.AdditionalAbilities.AddItem(BonusAbility);

	Template.IconImage = IconImage; 
	Template.ShotHUDPriority = HUDPriority;
	
	Template.AbilityCosts.length = 0;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	return Template;
}

static function X2AbilityTemplate GrimyStrafeBonus(name TemplateName, name AbilityName, float BonusDamage, float BonusMobility, optional bool bStrafe = true, optional int BonusAction = 1) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusDamage				DamageEffect;
	local X2Effect_TurnStartActionPoints		ActionPointEffect;
	local X2Effect_PersistentStatChange			StatEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psychosis";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	if ( BonusDamage != 0.0 ) {
		DamageEffect = new class'Grimy_Effect_BonusDamage';
		DamageEffect.BuildPersistentEffect(1, true, false, false);
		DamageEffect.Bonus = BonusDamage;
		DamageEffect.AbilityName = AbilityName;
		DamageEffect.FriendlyName = default.StrafeBonusName;
		Template.AddTargetEffect(DamageEffect);
	}
	
	if ( bStrafe ) {
		Template.AddTargetEffect(new class'Grimy_Effect_StrafePoint');
	}

	if ( BonusAction > 0 ) {
		ActionPointEffect = new class'X2Effect_TurnStartActionPoints';
		ActionPointEffect.BuildPersistentEffect(1, true, false, false);
		ActionPointEffect.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
		ActionPointEffect.NumActionPoints = BonusAction;
		Template.AddTargetEffect(ActionPointEffect);
	}

	if ( BonusMobility != 0 ) {
		StatEffect = new class'X2Effect_PersistentStatChange';
		StatEffect.BuildPersistentEffect(1, true, false, false);
		StatEffect.AddPersistentStatChange(eStat_Mobility, BonusMobility, MODOP_PostMultiplication);
		StatEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
		Template.AddTargetEffect(StatEffect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimyBonusDamage(name TemplateName, name AbilityName, float BonusDamage, optional int BaseDamage = 0, optional int TierDamage = 0, optional string BonusName) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_BonusDamage		DamageEffect;

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
	DamageEffect.BaseDamage = BaseDamage;
	DamageEffect.TierMult = TierDamage;
	DamageEffect.FriendlyName = BonusName;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimyWillToSurvive(name TemplateName, string IconImage, float WillMult) {
	local X2AbilityTemplate						Template;
	local Grimy_Effect_WillToSurvive	StatEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = IconImage;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	StatEffect = new class'Grimy_Effect_WillToSurvive';
	StatEffect.BuildPersistentEffect(1, true, false, false);
	StatEffect.WillMult = WillMult;
	Template.AddTargetEffect(StatEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GrimyPyrokinesis()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Burning					BurningEffect;
	local Grimy_AbilityCost_HP				HealthCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimyPyrokinesis');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityIconColor = "C34144";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PYROKINESIS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	HealthCost = new class'Grimy_AbilityCost_HP';
	HealthCost.Cost = default.PYROKINESIS_COST;
	Template.AbilityCosts.AddItem(HealthCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'Soulfire';
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.PYROKINESIS_BURN,default.PYROKINESIS_SPREAD);
	Template.AddTargetEffect(BurningEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim =  'FF_MZBlood_RHandCast';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.PostActivationEvents.AddItem(class'X2Ability_PsiOperativeAbilitySet'.default.SoulStealEventName);

	Template.AssociatedPassives.AddItem('SoulSteal');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate GrimyReave()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCooldown_PerPlayerType	Cooldown;
	local X2Effect_PersistentStatChange		PoisonedEffect;
	local Grimy_AbilityCost_HP				HealthCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimyReave');
	Template.AdditionalAbilities.AddItem('GrimyReaveBonus');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Bloodcall";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityIconColor = "C34144";

	Template.CustomFireAnim =  'FF_MZBlood_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;   // Updated 8/18/15 to 1 action point only per Jake request.  
	ActionCost.bConsumeAllPoints = true;
	ActionCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown_PerPlayerType';
	Cooldown.iNumTurns = default.REAVE_COOLDOWN;
	//Cooldown.iNumTurnsForAI = default.NULL_LANCE_COOLDOWN_AI;
	//cooldown.NumGlobalTurns = default.NULL_LANCE_GLOBAL_COOLDOWN_AI;
	Template.AbilityCooldown = Cooldown;
	
	HealthCost = new class'Grimy_AbilityCost_HP';
	HealthCost.Cost = default.REAVE_COST;
	Template.AbilityCosts.AddItem(HealthCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

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

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'NullLance';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);
	
	PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	Template.AddMultiTargetEffect(PoisonedEffect);

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

static function X2AbilityTemplate GrimyMadness()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	local Grimy_AbilityCost_HP				HealthCost;
	local X2Effect_GrantActionPoints				ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GrimyMadness');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_mindspin";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityIconColor = "C34144";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('Strafe');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.MADNESS_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MADNESS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	HealthCost = new class'Grimy_AbilityCost_HP';
	HealthCost.Cost = default.MADNESS_COST;
	Template.AbilityCosts.AddItem(HealthCost);
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.MADNESS_DURATION, false, false);
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = default.MADNESS_GRANTACTIONS;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ActivationSpeech = 'Domination';
	Template.SourceMissSpeech = 'SoldierFailsControl';

	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Domination'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Domination'
	
	return Template;
}