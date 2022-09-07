class X2Ability_CC92MechanicAbilitySet extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(SupplicationProtocol());
	Templates.AddItem(EradicationProtocol());
	Templates.AddItem(OptimizationProtocol());
	Templates.AddItem(ResidentVirus());
	Templates.AddItem(DDoSVirus());
	Templates.AddItem(RootkitVirus());
	Templates.AddItem(HCFExploit());
	Templates.AddItem(FatalExceptionExploit());
	
	return Templates;
}

static function X2AbilityTemplate SupplicationProtocol()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityCharges              		Charges;
	local X2AbilityCost_Charges         		ChargeCost;
	local X2AbilityTarget_Single				TargetStyle;
	local X2Condition_UnitProperty				TargetProperty, RobotProperty;
	local X2Effect_PersistentStatChange 		SupplicationProtocolEffect, SuppProRoboShield;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SupplicationProtocol');
	
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.ArmorMod_MachWeave";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 4;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 12 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	SupplicationProtocolEffect = new class'X2Effect_PersistentStatChange';
	SupplicationProtocolEffect.EffectName = 'Supplication_Protocol';
	SupplicationProtocolEffect.DuplicateResponse = eDupe_Refresh;
	SupplicationProtocolEffect.bRemoveWhenTargetDies = true;
	SupplicationProtocolEffect.BuildPersistentEffect(4, , false, , eGameRule_PlayerTurnBegin);
	SupplicationProtocolEffect.AddPersistentStatChange (eStat_ShieldHP, 3);
	Template.AddTargetEffect (SupplicationProtocolEffect);
	
	RobotProperty = new class'X2Condition_UnitProperty';
    RobotProperty.ExcludeRobotic = false;
	RobotProperty.ExcludeTurret = false;
	RobotProperty.ExcludeHostileToSource = true;
	RobotProperty.ExcludeFriendlyToSource = false;
    RobotProperty.ExcludeOrganic = true;
	
	SuppProRoboShield = new class 'X2Effect_PersistentStatChange';
	SuppProRoboShield.EffectName = 'Supplicaiton_Protocol_Robotic';
	SuppProRoboShield.DuplicateResponse = eDupe_Refresh;
	SuppProRoboShield.bRemoveWhenTargetDies = true;
	SuppProRoboShield.BuildPersistentEffect(4, , false, , eGameRule_PlayerTurnBegin);
	SuppProRoboShield.AddPersistentStatChange (eStat_ShieldHP, 3);
	SuppProRoboShield.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect (SuppProRoboShield);
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CustomSelfFireAnim = 'NO_MedicalProtocol';
	Template.ActivationSpeech = 'HealingAlly';
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
	}
	
static function X2AbilityTemplate EradicationProtocol()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityCharges              		Charges;
	local X2AbilityCost_Charges         		ChargeCost;
	local X2AbilityTarget_Single				TargetStyle;
	local X2Condition_UnitProperty				TargetProperty;
	local X2Effect_IradicationProtocol_BonusDamage  BonusDamage;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'EradicationProtocol');
	
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Crowdsource";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 3;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 12 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	BonusDamage = new class'X2Effect_IradicationProtocol_BonusDamage';
	BonusDamage.BuildPersistentEffect(1, false , true, false , eGameRule_PlayerTurnBegin);
	BonusDamage.iExDamage = 2;
	BonusDamage.iExCritDamage = 1;
	BonusDamage.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	Template.AddTargetEffect(BonusDamage);
   
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.bOverrideWeapon = true;
	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}

static function X2AbilityTemplate OptimizationProtocol()
{
	
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityTarget_Single				TargetStyle;
	local X2Condition_UnitProperty				TargetProperty;
	local X2Effect_OptimizationProtocol  		Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'OptimizationProtocol');
	
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Hack";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 12 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	Effect = new class'X2Effect_OptimizationProtocol';
	Effect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnBegin);
	Effect.AimMod = 20;
	Effect.CritMod = 10;
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.bOverrideWeapon = true;
	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}
	
static function	X2AbilityTemplate ResidentVirus()
{

	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityTarget_Single					TargetStyle;
	local X2Condition_UnitProperty					TargetProperty;
	local X2Effect_IradicationProtocol_BonusDamage  ResDMGDebuff, ResVirRoboDMG;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit 	StatCheck;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ResidentVirus');
	
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DisarmingSlash";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 65;
	StatCheck.AttackerStat = eStat_Hacking;
    StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;
	
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 18 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	ResDMGDebuff = new class'X2Effect_IradicationProtocol_BonusDamage';
	ResDMGDebuff.BuildPersistentEffect(3, false , true, false , eGameRule_PlayerTurnBegin);
	ResDMGDebuff.iExDamage = -3;
	ResDMGDebuff.iExCritDamage = -1;
	ResDMGDebuff.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	Template.AddTargetEffect(ResDMGDebuff);
	
	ResVirRoboDMG = new class'X2Effect_IradicationProtocol_BonusDamage';
	ResVirRoboDMG.BuildPersistentEffect(3, false , true, false , eGameRule_PlayerTurnBegin);
	ResVirRoboDMG.iExDamage = -3;
	ResVirRoboDMG.iExCritDamage = -1;
	ResVirRoboDMG.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	ResVirRoboDMG.TargetConditions.AddItem(TargetProperty);
	Template.AddTargetEffect(ResVirRoboDMG);
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	Template.ActivationSpeech = 'HaywireProtocol';
	
	Template.bStationaryWeapon = true;
	
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}
	
static function	X2AbilityTemplate DDoSVirus()
{

	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityMultiTarget_Radius   			RadiusMultiTarget;
	local X2AbilityTarget_Cursor       				CursorTarget;
	local X2Effect_OptimizationProtocol  			DDoSDebuff;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'DDoSVirus');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ConcussiveBlast";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY; 
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;
	Template.AbilityTargetStyle = CursorTarget;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 9;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	DDoSDebuff = new class'X2Effect_OptimizationProtocol';
	DDoSDebuff.BuildPersistentEffect(3, false, true, false, eGameRule_PlayerTurnBegin);
	DDoSDebuff.AimMod = -20;
	DDoSDebuff.CritMod = -8;
	DDoSDebuff.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DDoSDebuff);
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.ActivationSpeech = 'CapacitorDischarge';
	Template.CustomSelfFireAnim = 'NO_CapacitorDischargeA';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}
	
static function X2AbilityTemplate RootkitVirus()
	{
	
	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityTarget_Single					TargetStyle;
	local X2Condition_UnitProperty					TargetProperty;
	local X2Effect_PersistentStatChange				RootkitDebuff;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit 	StatCheck;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'RootkitVirus');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Compel";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY; 
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;
	
	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	TargetProperty	= new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 24 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	TargetProperty.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 65;
	StatCheck.AttackerStat = eStat_Hacking;
    StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;
	
	RootkitDebuff = new class'X2Effect_PersistentStatChange';
	RootkitDebuff.BuildPersistentEffect(2, false , true, false , eGameRule_PlayerTurnBegin);
	RootkitDebuff.DuplicateResponse = eDupe_Refresh;
	RootkitDebuff.AddPersistentStatChange (eStat_Mobility, -9);
	RootkitDebuff.AddPersistentStatChange (eStat_HackDefense, -60);
	RootkitDebuff.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,true,,Template.AbilitySourceName);
	Template.AddTargetEffect (RootkitDebuff);
	
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	Template.ActivationSpeech = 'HaywireProtocol';
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}

static function X2AbilityTemplate FatalExceptionExploit()
	{
	
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2AbilityTarget_Single		TargetStyle;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'FatalExceptionExploit');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_HaywireProtocol";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY; 
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Cooldown.bDoNotApplyOnHit = true;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 15;
	StatCheck.AttackerStat = eStat_Hacking;
    StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = 32 * class'XComWorldData'.const.WORLD_StepSize;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeTurret = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, true);
	Template.AddTargetEffect(MindControlEffect);
	
	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);
	
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	
	Template.ActivationSpeech = 'HaywireProtocol';
	Template.SourceMissSpeech = 'SoldierFailsControl';
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}

static function X2AbilityTemplate HCFExploit()
	{
	
	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityCharges              			Charges;
	local X2AbilityCost_Charges         			ChargeCost;
	local X2AbilityTarget_Single					TargetStyle;
	local X2Condition_UnitProperty					TargetProperty;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit 	StatCheck;
	local X2Effect_Stunned							StunEffect;
	local X2Effect_PersistentStatChange				HCFDebuffs;	
	Local X2Effect_ApplyWeaponDamage            	HCFDamage;
		
	`CREATE_X2ABILITY_TEMPLATE(Template, 'HCFExploit');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.ArmorMod_FluxWeave";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY; 
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Cooldown.bDoNotApplyOnHit = false;
	Template.AbilityCooldown = Cooldown;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 3;
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	HCFDebuffs = new class'X2Effect_PersistentStatChange';
	HCFDebuffs.DuplicateResponse = eDupe_Refresh;
	HCFDebuffs.AddPersistentStatChange (eStat_Defense, -30);
	Template.AddTargetEffect (HCFDebuffs);
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 15;
	StatCheck.AttackerStat = eStat_Hacking;
    StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;
	
	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(3, 100); // # ACTIONS, % chance
	StunEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunEffect);

	TargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = TargetStyle;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	TargetProperty	= new class'X2Condition_UnitProperty';
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 24 * class'XComWorldData'.const.WORLD_StepSize;
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	TargetProperty.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	HCFDamage = new class'X2Effect_ApplyWeaponDamage';
	HCFDamage.bIgnoreBaseDamage = true;
	HCFDamage.EffectDamageValue.Rupture = 3;
	HCFDamage.EffectDamageValue.Shred = 2;
	HCFDamage.TargetConditions.AddItem(TargetProperty);
	Template.AddTargetEffect(HCFDamage);
	
	Template.ActivationSpeech = 'BulletShred';
	
	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.CustomSelfFireAnim = 'NO_RevivalProtocol';
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	return Template;
}











	
	

	
	