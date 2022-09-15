class MZPistol_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);

var config int TheBusiness_Cooldown, ShootOut_Cooldown, FranticFire_Cooldown, AbyssalPistolShot_HPCost, BigFortyFive_Cooldown, PistolRave_Cooldown;
var config int Faceoff_Charges, FACEOFF_COOLDOWN;
var config float AbyssalPistolShot_BonusDamage, BigFortyFive_BonusDamage, PistolRave_FinalAimMod;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(TheBusiness());
	Templates.AddItem(AddShootOut());
	/*>>*/Templates.AddItem(ShootOutChaser());
	Templates.AddItem(FranticFire());
	Templates.AddItem(WildPistolStrafe());
	/*>>*/Templates.AddItem(AddStrafeAP());
	Templates.AddItem(AddIMeantToDoThat());
	/*>>*/Templates.AddItem(AddIMeantToDoThatShot());
	Templates.AddItem(ChimeraFaceOff());
	Templates.AddItem(KillerFlow());
	/*>>*/Templates.AddItem(KillerFlowShot());
	Templates.AddItem(AbyssalPistolShot());
	Templates.AddItem(BigFortyFive());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZQuickFortyFive', "img:///UILibrary_MZChimeraIcons.Ability_LancerShot", 'MZBigFortyFive'));
	Templates.AddItem(PistolRave());

	return Templates;
}

//function sets up a basic pistol shot. handles boilerplate for new pistol abilities.
static function X2AbilityTemplate CreateBasePistolShot(Name AbilityName = 'MZPistolNonStandardShot', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_standardpistol")
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

static function X2AbilityTemplate TheBusiness() {
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local int								i;

	Template = CreateBasePistolShot('MZTheBusiness', "img:///UILibrary_PerkIcons.UIPerk_quickdraw");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.TheBusiness_Cooldown;
	Template.AbilityCooldown = Cooldown;

	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[i]);

		if (AmmoCost != None) {
			AmmoCost.iAmmo = 2;
			break;
		}
	}

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	class'MZGrimyHeadHunter_AbilitySet'.static.MakeAbilityRandomFire(Template,1,false);

	return Template;
}

static function X2AbilityTemplate AddShootOut() {
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local int								i;

	Template = CreateBasePistolShot('MZShootOut', "img:///UILibrary_PerkIcons.UIPerk_faceoff");
	Template.ShotHUDPriority = 340;
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShootOut_Cooldown;
	Template.AbilityCooldown = Cooldown;

	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[i]);

		if (AmmoCost != None) {
			AmmoCost.iAmmo = 3;
			break;
		}
	}

	// Fake Ammo Cost (to also cover the chaser)
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 6;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	class'MZGrimyHeadHunter_AbilitySet'.static.MakeAbilityRandomFire(Template,2,false);

	Template.AdditionalAbilities.AddItem('MZShootOutChaser');

	return Template;
}
static function X2AbilityTemplate ShootOutChaser() {
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityTrigger_EventListener	Listener;

	Template = CreateBasePistolShot('MZShootOutChaser', "img:///UILibrary_PerkIcons.UIPerk_faceoff");
	Template.ShotHUDPriority = 500;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	
	Template.AbilityCosts.Length=0;
	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	class'MZGrimyHeadHunter_AbilitySet'.static.MakeAbilityRandomFire(Template,2,false);

	Template.AbilityTriggers.Length = 0;
	Listener = new class'X2AbilityTrigger_EventListener';
    Listener.ListenerData.Filter = eFilter_Unit;
    Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
    Listener.ListenerData.EventFn = ShootOutEventListener;
    Listener.ListenerData.EventID = 'AbilityActivated';
    Listener.ListenerData.Priority = 40;    //  default Priority is 50, lowering the value so this ability triggers AFTER the attack goes through
    Template.AbilityTriggers.AddItem(Listener);

	return Template;
}
static function EventListenerReturn ShootOutEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Unit            SourceUnit;
	local array<StateObjectReference>	PossibleTargets;
	local StateObjectReference			Target;
   
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    SourceUnit = XComGameState_Unit(EventSource);
 
    if (AbilityContext != none && AbilityState != none && SourceUnit != none)
    {   
        if (AbilityState.GetMyTemplateName() == 'MZShootOut')
        {
			// pick a random target
			class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(SourceUnit.ObjectID, PossibleTargets);
			if (PossibleTargets.length > 0)
			{
				Target = PossibleTargets[`SYNC_RAND_STATIC(PossibleTargets.length)];
				class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZShootOutChaser', Target);
			}
		}
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate FranticFire() {
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local int								i;
	local X2AbilityCost_ActionPoints		APCost;

	Template = CreateBasePistolShot('MZFranticFire', "img:///UILibrary_PerkIcons.UIPerk_lightninghands");
	Template.ShotHUDPriority = 320;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FranticFire_Cooldown;
	Template.AbilityCooldown = Cooldown;

	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[i]);

		if (AmmoCost != None) {
			AmmoCost.iAmmo = 2;
			continue;
		}

		APCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);

		if (APCost != None)
		{
			APCost.bFreeCost = true;
		}
	}

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	class'MZGrimyHeadHunter_AbilitySet'.static.MakeAbilityRandomFire(Template,1,false);

	return Template;
}

static function X2AbilityTemplate WildPistolStrafe() {
	local X2AbilityTemplate                 Template;
	local int i;
	local X2AbilityCost_ActionPoints ActionPointsCost;

	Template = CreateBasePistolShot('MZWildPistolStrafe', "img:///UILibrary_PerkIcons.UIPerk_standardpistol");

	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		ActionPointsCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);

		if (ActionPointsCost != None) {
			ActionPointsCost.bConsumeAllPoints = false;
			ActionPointsCost.AllowedTypes.Length = 0;
			ActionPointsCost.AllowedTypes.AddItem('Strafe');
			ActionPointsCost.AllowedTypes.AddItem('GrimyGunpoint');
			ActionPointsCost.AllowedTypes.AddItem('runandgun');
			break;
		}
	}

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.AdditionalAbilities.AddItem('MZStrafeAP');

	Template.BuildNewGameStateFn = class'MZGrimyHeadHunter_AbilitySet'.static.RandomSingleTarget_BuildGameState;

	return Template;
}
static function X2AbilityTemplate AddStrafeAP() {
	local X2AbilityTemplate						Template;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZStrafeAP');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bulletswarm";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bUniqueSource = true;

	Template.AddTargetEffect(new class'Grimy_Effect_StrafePoint');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddIMeantToDoThat()
{
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZIMeantToDoThat', "img:///UILibrary_PerkIcons.UIPerk_returnfire");
	Template.AdditionalAbilities.AddItem('MZIMeantToDoThatShot');

	return Template;
}
static function X2AbilityTemplate AddIMeantToDoThatShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityTrigger_EventListener	EventListener;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZIMeantToDoThatShot');

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'KillMail';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = IMeantToDoThatListener;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
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
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = false;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

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
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.bShowActivation = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'


	return Template;	
}
static function EventListenerReturn IMeantToDoThatListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local X2WeaponTemplate	Weapon;
	local XComGameState_Unit Killer;
	local array<StateObjectReference> PossibleTargets;
	local StateObjectReference Target;
	//local array<X2Condition> Conditions;

	History = `XCOMHISTORY;
	//  if the kill was made with a pistol, fire ability.
	Killer = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	Weapon = X2WeaponTemplate(XComGameState_Ability(History.GetGameStateForObjectId(AbilityContext.InputContext.AbilityRef.ObjectID)).GetSourceWeapon().GetMyTemplate());
	if (Killer != None && Weapon != None && ( Weapon.WeaponCat == 'pistol' || Weapon.WeaponCat == 'sidearm') )
	{
		// pick a random target
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(Killer.ObjectID, PossibleTargets);
		if (PossibleTargets.length > 0)
		{
			Target = PossibleTargets[`SYNC_RAND_STATIC(PossibleTargets.length)];
			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(Killer.GetReference(), 'MZIMeantToDoThatShot', Target);
		}
	}

	return ELR_NoInterrupt;
}

/////Based on BlueBlood's version of Faceoff - works nicer for primary pistols. actually, might be fucky.
static function X2AbilityTemplate ChimeraFaceoff()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Cost_AmmoPerTarget				AmmoCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFaceoff');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_FaceOff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";  // DEPRECATED: Use X2AbilityTemplate's PerObjectConfig in DefaultGameCore.ini

	If ( default.Faceoff_Charges > 0 )
	{
		//Charges
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.Faceoff_Charges;
		Template.AbilityCharges = Charges;

		//Charge Cost
		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	if ( default.FACEOFF_COOLDOWN > 0 )
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.FACEOFF_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}

	AmmoCost = new class'MZ_Cost_AmmoPerTarget';
	AmmoCost.iAmmo = 1;
	AmmoCost.MinAmmoToFire = 3;
	AmmoCost.AmmoPerTarget = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	MultiTargetUnits = new class'X2AbilityMultiTarget_AllUnits';
	MultiTargetUnits.bUseAbilitySourceAsPrimaryTarget = true;
	MultiTargetUnits.bAcceptEnemyUnits = true;
	Template.AbilityMultiTargetStyle = MultiTargetUnits;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	//class'X2Ability_WeaponCommon'.static.AddWarmWelcomeDisorientationToTargetEffects(Template, true);

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = ClampTargetsByAmmo_BuildGameState;
	Template.BuildVisualizationFn = Faceoff_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Faceoff';
	Template.CustomFireAnim = 'FF_Faceoff';

	return Template;
}

function XComGameState ClampTargetsByAmmo_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory			History;
	local XComGameState					NewGameState;
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Item			ItemState;
	local int							TargetLimit;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(Context);
	ItemState = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	If ( !ItemState.HasInfiniteAmmo() )
	{
		TargetLimit = ItemState.Ammo;

		While (AbilityContext.InputContext.MultiTargets.Length > TargetLimit + 1)
		{
			AbilityContext.InputContext.MultiTargets.Remove(`SYNC_RAND_STATIC(AbilityContext.InputContext.MultiTargets.length),1);
		}
	}

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

static function X2AbilityTemplate KillerFlow()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZKillerFlow', "img:///UILibrary_MZChimeraIcons.Ability_TwinStrike");
	Template.AdditionalAbilities.AddItem('MZKillerFlowShot');

	return Template;
}
static function X2AbilityTemplate KillerFlowShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2AbilityToHitCalc_StandardAim  StandardMelee;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKillerFlowShot');

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TwinStrike";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = KillerFlowEventListener;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
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


	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = false;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//Prevent repeatedly hammering on a unit with Bladestorm triggers.
	//(This effect does nothing, but enables many-to-many marking of which Bladestorm attacks have already occurred each turn.)
	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'KillerFlowTarget';
	BladestormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('KillerFlowTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bReactionFire = true;
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityToHitOwnerOnMissCalc = StandardMelee;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'


	return Template;	
}
static function EventListenerReturn KillerFlowEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Item            WeaponState;
   
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
    SourceUnit = XComGameState_Unit(EventSource);
    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
 
    if (AbilityContext != none && AbilityState != none && WeaponState != none && SourceUnit != none && TargetUnit != none)
    {   //  if this is an offensive ability that actually hit the enemy, and the enemy is still alive
        if (AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
        {
			// if the source weapon is an autopistol, and this is not reaction fire.
			if ( WeaponState.GetWeaponCategory() == 'sidearm' && !X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire ) /*&& X2WeaponTemplate(WeaponState.GetMyTemplate()).InventorySlot == eInvSlot_PrimaryWeapon*/ 
			{
				//Attempt to fire Killer Flow.
				class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'MZKillerFlowShot', AbilityContext.InputContext.PrimaryTarget);
			}
		}
    }
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate AbyssalPistolShot()
{
	local X2AbilityTemplate				Template;
	local Grimy_AbilityCost_HP			HPCost;
	local X2Effect_Blind				BlindEffect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local MZ_Damage_AddElemental		WeaponDamageEffect;

	Template = CreateBasePistolShot('MZAbyssalPistolShot', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bloodtrail");
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityIconColor = "C34144";
	Template.ShotHUDPriority = 320;

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.AbyssalPistolShot_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Psi';
	WeaponDamageEffect.BonusDamageScalar = default.AbyssalPistolShot_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	//have to block vamp ammo.
	Template.bAllowAmmoEffects = false; //

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(class'MZTrickShot_AbilitySet'.default.FightInTheShade_BlindTurns, class'MZTrickShot_AbilitySet'.default.FightInTheShade_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, class'MZTrickShot_AbilitySet'.default.FightInTheShade_VisionMult, MODOP_PostMultiplication);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFightInTheShade');
	BlindEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BlindEffect);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	return Template;
}

static function X2AbilityTemplate BigFortyFive()
{
	local X2AbilityTemplate				Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCooldown             Cooldown;

	Template = CreateBasePistolShot('MZBigFortyFive', "img:///UILibrary_MZChimeraIcons.Ability_LancerShot");
	Template.bDontDisplayInAbilitySummary = false;

	Template.ShotHUDPriority = 315;

	Template.AbilityCosts.Length = 0;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MZQuickFortyFive');
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	//this free costs exists only to make it require having more than 1 ap.
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BigFortyFive_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Explosion';
	WeaponDamageEffect.BonusDamageScalar = default.BigFortyFive_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate PistolRave()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;

	Template = CreateBasePistolShot('MZPistolRave', "img:///UILibrary_MZChimeraIcons.Ability_PinDown");
	Template.ShotHUDPriority = 330;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.FinalMultiplier = default.PistolRave_FinalAimMod;
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityToHitOwnerOnMissCalc = StandardMelee;

	Template.AbilityCosts.Length = 0;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PistolRave_Cooldown;
	Template.AbilityCooldown = Cooldown;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	return Template;
}