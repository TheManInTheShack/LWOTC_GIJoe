class MZIsmsRogue_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(IsmsRogue);

var config float Shadowborn_DetectionReduction, GrandFinale_DamagePerFocus, Recon_ConeWidth, Recon_ConeLength;
var config int Shadowborn_Aim, Shadowborn_Crit, Recon_Cooldown, RogueAndGun_Cooldown, KeepYourHeadDown_Aim;

var localized string Recon_Scouted, Recon_ScoutedDesc, Relocate_Invisible, Riposte_Parried, Riposte_Taunt;
var localized string ScoutingReport_Intel, ScoutingReport_IntelDesc, NBK_Focus, NBK_FocusDesc, RushOfBattle_Adrenaline, RushOfBattle_AdrenalineDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Blindside());
	Templates.AddItem(Upside());

	Templates.AddItem(GhostPack());
	Templates.AddItem(Recon());
	Templates.AddItem(ConcussiveShot());
	/*>>*/Templates.AddItem(ConcussiveStun());
	/*>>*/Templates.AddItem(RogueSap());
	Templates.AddItem(ShadowBorn());
	Templates.AddItem(NaturalBornKiller());
	/*>>*/Templates.AddItem(NBKGrandFinale());
	Templates.AddItem(LastWish());
	/*>>*/Templates.AddItem(LastWishTriggered());

	Templates.AddItem(LoneWolfPack());
	Templates.AddItem(RogueAndGun());
	/*>>*/Templates.AddItem(RogueAndGunMomentum());
	Templates.AddItem(Riposte());
	/*>>*/Templates.AddItem(RiposteShot());
	Templates.AddItem(KeepYourHeadDown());
	Templates.AddItem(RushOfBattle());
	/*>>*/Templates.AddItem(CoolOff());
	Templates.AddItem(BlazeOfGlory());
	/*>>*/Templates.AddItem(BlazeOfGlorySustain());

	Templates.AddItem(ScoutPack());
	Templates.AddItem(ScoutVision());
	Templates.AddItem(ScoutsOverwatch());
	/*>>*/Templates.AddItem(ScoutsOverwatchShot());
	Templates.AddItem(Flush());
	/*>>*/Templates.AddItem(class'MZGrimyHeadHunter_AbilitySet'.static.GrimyBonusDamage('IsmsFlushDamage','IsmsFlush', -0.50));
	Templates.AddItem(OnTheMove());
	Templates.AddItem(ScoutingReport());
	/*>>*/Templates.AddItem(DecisiveAction());
	Templates.AddItem(Relocate());
	/*>>*/Templates.AddItem(RelocateStealth());

	Templates.AddItem(Inflitrator());

	//Templates.AddItem(SelfSufficient);
	//Templates.AddItem(CheapShot);
	//Templates.AddItem(Ambush);


	return Templates;
}

static function X2AbilityTemplate Blindside() {
	local X2AbilityTemplate			Template;
	local Isms_Effect_Blindside		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsBlindside');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Isms_Effect_Blindside';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate Upside() {
	local X2AbilityTemplate			Template;
	local Isms_Effect_Blindside		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsUpside');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Isms_Effect_Blindside';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Upside = true;
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate GhostPack()
{
	local X2AbilityTemplate			Template;
	local Isms_Effect_GhostFragile		DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsGhostPack');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Ghost";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'Isms_Effect_GhostFragile';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.AdditionalAbilities.AddItem('Phantom');
	Template.AdditionalAbilities.AddItem('Stealth');

	return Template;
}

static function X2AbilityTemplate Recon()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
 	local X2AbilityCooldown_PerPlayerType	Cooldown;
	local Isms_Effect_ReconDebuff			MarkedEffect; 
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Condition_UnitProperty			UnitPropertyCondition;
//	local X2Condition_UnitEffects			UnitEffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRecon');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fire_control";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;		
 	Template.BuildVisualizationFn = class'X2Ability_AdventCaptain'.static.TargetGettingMarked_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Mark_Target";
	
	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;    
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown_PerPlayerType';
	Cooldown.iNumTurns = default.Recon_Cooldown;
	Cooldown.iNumTurnsForAI = default.Recon_Cooldown;
	cooldown.NumGlobalTurns = default.Recon_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 15;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.Recon_ConeWidth * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.Recon_ConeLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);
 
 	// Target cannot already be marked
//	UnitEffectsCondition = new class'X2Condition_UnitEffects';
//	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.MarkedName, 'AA_UnitIsMarked');
//	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	//// Create the Marked effect
	MarkedEffect = new class 'Isms_Effect_ReconDebuff';
	MarkedEffect.EffectName = 'Scouted';
	MarkedEffect.DuplicateResponse = eDupe_Ignore;
	MarkedEffect.BuildPersistentEffect(2, false, true,,eGameRule_PlayerTurnEnd);
	MarkedEffect.SetDisplayInfo(ePerkBuff_Penalty, default.Recon_Scouted, default.Recon_ScoutedDesc, "img:///UILibrary_PerkIcons.UIPerk_mark");
	//MarkedEffect.VisualizationFn = ScoutedVisualization;
	//MarkedEffect.EffectTickedVisualizationFn = MarkedVisualizationTicked;
	//MarkedEffect.EffectRemovedVisualizationFn = MarkedVisualizationRemoved;
	MarkedEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(MarkedEffect); //BMU - changing to an immediate execution for evaluation
	Template.AddMultiTargetEffect(MarkedEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'TargetSpottedHidden';

	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;
	Template.ConcealmentRule = eConceal_Always;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
//	Template.BuildVisualizationFn = TargetGettingMarked_BuildVisualization;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
 	Template.CinescriptCameraType = "Mark_Target";	
	return Template;
}

static function X2AbilityTemplate ShadowBorn()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ToHitModifier                Effect;
	local X2Condition_Visibility                VisCondition;
	local X2Effect_PersistentStatChange			PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsShadowBorn');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Stealth";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'X2Effect_PersistentStatChange';
	PersistentEffect.EffectName = 'IsmsShadowBornDetectReduce';
	PersistentEffect.DuplicateResponse = eDupe_Ignore;
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.AddPersistentStatChange(eStat_DetectionModifier, default.Shadowborn_DetectionReduction);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Effect = new class'X2Effect_ToHitModifier';
	Effect.EffectName = 'IsmsShadowBornAimBoost';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	//Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.AddEffectHitModifier(eHit_Success, default.Shadowborn_Aim, Template.LocFriendlyName);
	Effect.AddEffectHitModifier(eHit_Crit, default.Shadowborn_Crit, Template.LocFriendlyName);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bExcludeGameplayVisible = true;
	Effect.ToHitConditions.AddItem(VisCondition);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate RogueAndGun()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRogueAndGun');
 
	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
 	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_quadricepshypertrophy";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
 
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RogueAndGun_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;    
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
          
    Template.AbilityToHitCalc = default.SimpleStandardAim;  
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
 	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
 
	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	//KnockbackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockbackEffect);
 
	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;

	Template.AdditionalAbilities.AddItem('IsmsRogueAndGunMomentum');

	return Template;
}
static function X2AbilityTemplate RogueAndGunMomentum()
{
	local X2AbilityTemplate Template;
	local X2Effect_GrantActionPoints GrantActionPoints;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRogueAndGunMomentum');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_quadricepshypertrophy";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = IsmsRogueAndGunMomentumEventListener;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	GrantActionPoints = new class'X2Effect_GrantActionPoints';
	GrantActionPoints.bApplyOnMiss = true;
	GrantActionPoints.NumActionPoints = 1;
	GrantActionPoints.PointType = 'Momentum';
	Template.AddShooterEffect(GrantActionPoints);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bSkipFireAction = true;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Momentum'
	Template.bShowActivation = true;
	Template.bShowPostActivation = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Momentum'

	return Template;
}
static function EventListenerReturn IsmsRogueAndGunMomentumEventListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
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
        if (AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplateName() == 'IsmsRogueAndGun')
        {
			//Attempt to fire Reblossom.
			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'IsmsRogueAndGunMomentum', SourceUnit.GetReference());
		}
    }
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate KeepYourHeadDown()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LowProfile					LowProfileEffect;
	local X2Effect_ToHitModifier                Effect;
	local MZ_Condition_ShooterIsInCoverType		CoverCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsKeepYourHeadDown');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_LowProfile";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	//try this AbilityShooterConditions
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
 	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	LowProfileEffect = new class'X2Effect_LowProfile';
	LowProfileEffect.BuildPersistentEffect(1, true, false, false);
	LowProfileEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(LowProfileEffect);

	CoverCondition = new class'MZ_Condition_ShooterIsInCoverType';
	CoverCondition.MatchCover = CT_MidLevel;

	Effect = new class'X2Effect_ToHitModifier';
	Effect.EffectName = 'IsmsKeepYourHeadDownAimMalus';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.AddEffectHitModifier(eHit_Success, default.KeepYourHeadDown_Aim, Template.LocFriendlyName);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Effect.ToHitConditions.AddItem(CoverCondition);
	Template.AddTargetEffect(Effect);
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ScoutPack()
{
	local X2AbilityTemplate					Template;
 	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local Isms_Effect_Blindside				DamageModifier;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsScoutPack');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_rifle_overwatch";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, 6);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	DamageModifier = new class'Isms_Effect_Blindside';
 	DamageModifier.BuildPersistentEffect(1, true, true, true);
	DamageModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageModifier.Upside = true;
	Template.AddTargetEffect(DamageModifier);

	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'BattleScanner';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.OverrideAbilities.AddItem('IsmsBlindside');


	return Template;
}

static function X2AbilityTemplate ScoutVision()
{
	local X2AbilityTemplate					Template;
 	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsScoutVision');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_rifle_overwatch";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, 6);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'BattleScanner';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate OnTheMove()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect; 
	local X2Effect_TurnStartActionPoints		ThreeActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsOnTheMove');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_move_command";	//UIPerk_move_command

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -6);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentStatChangeEffect);
  
 	ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
	ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ThreeActionPoints.NumActionPoints = 1;
	ThreeActionPoints.bInfiniteDuration = true;
	Template.AddTargetEffect(ThreeActionPoints);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate Relocate()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost; 
	local X2Condition_UnitProperty				TargetCondition;
	local X2AbilityCooldown						Cooldown;
	//local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_AllAllies		MultiTargetingStyle;	
	local X2AbilityTrigger_PlayerInput			InputTrigger;
	local MZ_Effect_MusashiZeroDetection		DetectDown;		
	local Isms_Effect_RelocateConvertPoints		ActionPointsEffect;
	local X2Effect_ImmediateAbilityActivation	ImpairingAbilityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRelocate');

	// Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_stealth_move2";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.DisplayTargetHitChance = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 10;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SelfTarget;
	MultiTargetingStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetingStyle.bAllowSameTarget = true;
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	DetectDown = new class'MZ_Effect_MusashiZeroDetection';
	DetectDown.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	DetectDown.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	DetectDown.DuplicateResponse = eDupe_Ignore;
	DetectDown.TargetConditions.AddItem(TargetCondition);
	DetectDown.EffectName = 'IsmsRelocateDetectDown';
	Template.AddMultiTargetEffect( DetectDown );
	Template.AddTargetEffect( DetectDown );

	ActionPointsEffect = new class'Isms_Effect_RelocateConvertPoints';
	//ActionPointsEffect.NumActionPoints = 2;
	ActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointsEffect.bApplyOnMiss = true;
 	Template.AddMultiTargetEffect(ActionPointsEffect);
	Template.AddTargetEffect( ActionPointsEffect );

	//Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.AdditionalAbilities.AddItem('IsmsRelocateStealth');

	ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
	ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	ImpairingAbilityEffect.EffectName = 'IsmsRelocateStealth';
	ImpairingAbilityEffect.AbilityName = 'IsmsRelocateStealth';
	ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(ImpairingAbilityEffect);

	Template.bCrossClassEligible = false;

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";

	return Template;
}

static function X2AbilityTemplate RelocateStealth()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost; 
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityCooldown					Cooldown;
	//local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_AllAllies	MultiTargetingStyle;	
	local X2AbilityTrigger_PlayerInput		InputTrigger;
	local Isms_Effect_TempConcealment		MarkedEffect; 

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRelocateStealth');

	// Icon Properties
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;	
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_stealth_move2";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.DisplayTargetHitChance = false;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 3;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	/*
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	*/

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
 
	MarkedEffect = new class 'Isms_Effect_TempConcealment';
	MarkedEffect.EffectName = 'RelocateStealth';
	MarkedEffect.DuplicateResponse = eDupe_Ignore;
	MarkedEffect.BuildPersistentEffect(2, false, true,,eGameRule_PlayerTurnBegin);
	MarkedEffect.SetDisplayInfo(ePerkBuff_Bonus, default.Relocate_Invisible, default.Relocate_Invisible, "img:///UILibrary_PerkIcons.UIPerk_Riposte");
	MarkedEffect.bRemoveWhenTargetDies = true;
	Template.AddMultiTargetEffect(MarkedEffect); 
	Template.AddTargetEffect(MarkedEffect); 

	Template.AbilityTargetStyle = default.SelfTarget;
	MultiTargetingStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetingStyle.bAllowSameTarget = true;
//	MultiTargetingStyle.NumTargetsRequired = 1; //At least someone must need healing
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

 	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeConcealed = true;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	Template.bSkipFireAction = true;
	  
	Template.bCrossClassEligible = false;
	//Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";

	return Template;
}

static function x2abilitytemplate Inflitrator()
{
	local X2AbilityTemplate						Template;
	local x2effect_persistentstatchange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsInfiltrator');
	
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_holdtheline";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'x2effect_persistentstatchange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.addpersistentstatchange(estat_Hacking, 40);
	PersistentStatChangeEffect.EffectName = 'IsmsInfiltrator';
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddShooterEffect(PersistentStatChangeEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, 40, true);
		
	Template.AdditionalAbilities.AddItem('LightningReflexes');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return template;
}

static function X2AbilityTemplate ConcussiveShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ImmediateAbilityActivation ImpairingAbilityEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges             ChargesCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsConcussiveShot');

	//Template.AdditionalAbilities.AddItem('Deadeye2Damage'); (set up as -25% damage, but without blindside kind of pointless)
	Template.AdditionalAbilities.AddItem('IsmsConcussiveStun');
	Template.AdditionalAbilities.AddItem('IsmsRogueSap');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bringemon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 4; 
	Template.AbilityCharges = Charges;

	ChargesCost = new class'X2AbilityCost_Charges';
	ChargesCost.NumCharges = 1;
	ChargesCost.SharedAbilityCharges.AddItem('IsmsRogueSap');
	Template.AbilityCosts.AddItem(ChargesCost);

	Template.AbilityToHitCalc = default.SimpleStandardAim;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

	Template.bAllowAmmoEffects = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	//Impairing effects need to come before the damage. This is needed for proper visualization ordering.
	//Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
	ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
	ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
	ImpairingAbilityEffect.AbilityName = 'ConcussiveStun';
	ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
	ImpairingAbilityEffect.VisualizationFn = class'X2Ability_StunLancer'.static.ImpairingAbilityEffectTriggeredVisualization;
	Template.AddTargetEffect(ImpairingAbilityEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.ActivationSpeech = 'DisablingShot'; 
 
	return Template;
}
static function X2DataTemplate ConcussiveStun()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit    StatContest;
	local X2AbilityTarget_Single            SingleTarget;
	local X2Effect_Persistent               DisorientedEffect;
	local X2Effect_Persistent               DisorientedEffect3;	
	local X2Effect_Stunned				    StunnedEffect;
	local X2Effect_Persistent               UnconsciousEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsConcussiveStun');
	Template.ConcealmentRule = eConceal_Always;
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// This will be a stat contest
	StatContest = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatContest.AttackerStat = eStat_Will;
	//	StatContest.AttackerStat = eStat_Offense;
	Template.AbilityToHitCalc = StatContest;

	// On hit effects
	//  Stunned effect for 1 or 2 unblocked hit
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.BuildPersistentEffect(2,, false,,eGameRule_PlayerTurnBegin);
	DisorientedEffect.MinStatContestResult = 1;
	DisorientedEffect.MaxStatContestResult = 2;
	DisorientedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(DisorientedEffect);

	//  Stunned effect for 3 or 4 unblocked hit
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
	StunnedEffect.MinStatContestResult = 3;
	StunnedEffect.MaxStatContestResult = 4;
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	UnconsciousEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
	UnconsciousEffect.MinStatContestResult = 5;
	UnconsciousEffect.MaxStatContestResult = 0;
	UnconsciousEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(UnconsciousEffect);
	//Unconscious effect for 5 unblocked hits

	DisorientedEffect3 = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect3.BuildPersistentEffect(3,, false,,eGameRule_PlayerTurnBegin);
	DisorientedEffect3.MinStatContestResult = 5;
	DisorientedEffect3.MaxStatContestResult = 0;
	DisorientedEffect3.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(DisorientedEffect3);

	
	// UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(true);
	// UnconsciousEffect.MinStatContestResult = 5;
	// UnconsciousEffect.MaxStatContestResult = 0;
	// UnconsciousEffect.bRemoveWhenSourceDies = false;
	// Template.AddTargetEffect(UnconsciousEffect);

	Template.bSkipPerkActivationActions = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = StunLancerImpairing_BuildVisualization;

	return Template;
}
simulated function StunLancerImpairing_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

}

static function X2AbilityTemplate RogueSap()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetPropertyCondition;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2Effect_ImmediateAbilityActivation ImpairingAbilityEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_Charges             ChargesCost;
	local X2AbilityCharges              Charges;
	local X2Condition_UnitProperty          ShooterCondition;	 //here

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRogueSap');

	Template.ConcealmentRule = eConceal_Always;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_mindspin";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";


	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 4;
	Template.AbilityCharges = Charges;

	ChargesCost = new class'X2AbilityCost_Charges';
	ChargesCost.NumCharges = 2;
	ChargesCost.SharedAbilityCharges.AddItem('IsmsConcussiveShot');
	Template.AbilityCosts.AddItem(ChargesCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	ShooterCondition = new class'X2Condition_UnitProperty';
	//ShooterCondition.IsUnspotted = true;  //fix this here needs to only be activateable while concealed.
	ShooterCondition.IsConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	Template.AbilityToHitCalc = default.SimpleStandardAim;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

	Template.bAllowAmmoEffects = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;

	// Target Conditions
	//
	TargetPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetPropertyCondition.ExcludeDead = true;                     //Can't target dead
	TargetPropertyCondition.ExcludeFriendlyToSource = true;         //Can't target friendlies
	Template.AbilityTargetConditions.AddItem(TargetPropertyCondition);

	// Shooter Conditions
	//
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	//Impairing effects need to come before the damage. This is needed for proper visualization ordering.
	//Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
	ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
	ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
	ImpairingAbilityEffect.AbilityName = 'IsmsConcussiveStun';
	ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
	ImpairingAbilityEffect.VisualizationFn = class'X2Ability_StunLancer'.static.ImpairingAbilityEffectTriggeredVisualization;
	Template.AddTargetEffect(ImpairingAbilityEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.ActivationSpeech = 'DisablingShot'; 

	return Template;
}

static function X2AbilityTemplate Riposte()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;
	local X2AbilityCost_ActionPoints        ActionPointCost; 
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Persistent				MarkedEffect; 
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	//local X2Effect_Marked                   MarkedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRiposte');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Riposte";

	Template.AdditionalAbilities.AddItem('IsmsConcussiveStun');
	Template.AdditionalAbilities.AddItem('IsmsRiposteShot');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_ShowIfAvailable;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	//Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(Trigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);

 	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't shoot while dead
	//ShooterPropertyCondition.ExcludePanicked = true;
	ShooterPropertyCondition.ExcludeInStasis = true;
	ShooterPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.AbilityToActivate = 'IsmsRiposteShot';  //here here here here here below false to true
	FireEffect.bPreEmptiveFire = true;
	FireEffect.MaxPointsPerTurn = 1;
	FireEffect.GrantActionPoint = 'IsmsRiposte';
	FireEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);
	
	//MarkedEffect = class'X2Effect_RogueCreateMarkedEffect'.static.CreateTauntEffect(2, false);
	MarkedEffect = new class 'Isms_Effect_RogueTaunt';
	MarkedEffect.EffectName = 'IsmsRogueTaunt';
	MarkedEffect.DuplicateResponse = eDupe_Ignore;
	MarkedEffect.BuildPersistentEffect(1, false, true,,eGameRule_PlayerTurnBegin);
	MarkedEffect.SetDisplayInfo(ePerkBuff_Bonus, default.Riposte_Taunt, default.Riposte_Taunt, "img:///UILibrary_PerkIcons.UIPerk_Riposte");
	//MarkedEffect.VisualizationFn = MarkedVisualization;
	//MarkedEffect.EffectTickedVisualizationFn = MarkedVisualizationTicked;
	//MarkedEffect.EffectRemovedVisualizationFn = MarkedVisualizationRemoved;
	MarkedEffect.bRemoveWhenTargetDies = true; 
	Template.AddTargetEffect(MarkedEffect); 

	Template.CustomFireAnim = 'HL_SignalBark';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//	Template.BuildVisualizationFn = None;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	//Template.BuildVisualizationFn = TargetGettingMarked_BuildVisualization;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = false;       //  this can only work with pistols, which only sharpshooters have

	return Template;
}
static function X2AbilityTemplate RiposteShot()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_Visibility            TargetVisibilityCondition;
 	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_UnitProperty          TargetPropertyCondition;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2Effect_ImmediateAbilityActivation ImpairingAbilityEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_ToHitModifier			Effect;
 
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRiposteShot');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Riposte";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bAllowCrit = true;
	ToHitCalc.BuiltInHitMod = 20;
	Template.AbilityToHitCalc = ToHitCalc;
 
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

 	Template.bDontDisplayInAbilitySummary = true;
 	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
 	ReserveActionPointCost.iNumPoints = 1;
 	ReserveActionPointCost.AllowedTypes.AddItem('IsmsRiposte'); //here here
 	Template.AbilityCosts.AddItem(ReserveActionPointCost);
 
 	RemoveEffects = new class'X2Effect_RemoveEffects';
 	RemoveEffects.EffectNamesToRemove.AddItem('IsmsRogueTaunt');
 	Template.AddShooterEffect(RemoveEffects);
 
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

	Template.bAllowAmmoEffects = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = false;

	// Target Conditions
	//
	TargetPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetPropertyCondition.ExcludeDead = true;                     //Can't target dead
	TargetPropertyCondition.ExcludeFriendlyToSource = true;         //Can't target friendlies
	Template.AbilityTargetConditions.AddItem(TargetPropertyCondition);

	// Shooter Conditions
	//
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	//Impairing effects need to come before the damage. This is needed for proper visualization ordering.
	//Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
	ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
	ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
	ImpairingAbilityEffect.AbilityName = 'IsmsConcussiveStun';
	ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
	ImpairingAbilityEffect.VisualizationFn = class'X2Ability_StunLancer'.static.ImpairingAbilityEffectTriggeredVisualization;
	Template.AddTargetEffect(ImpairingAbilityEffect);

	Effect = new class'X2Effect_ToHitModifier';
	Effect.EffectName = 'IsmsRiposteParryMark';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.bApplyAsTarget = true;
	Effect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.Riposte_Parried, default.Riposte_Parried, "img:///UILibrary_PerkIcons.UIPerk_mark");
	Effect.AddEffectHitModifier(eHit_Success, 10, Template.LocFriendlyName);
	Effect.AddEffectHitModifier(eHit_Crit, 10, Template.LocFriendlyName);
	Template.AddTargetEffect(Effect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('Electrical');
	Template.AddTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate ScoutingReport()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_Focus					Effect;
	local MZ_Effect_FocusAimModFromSource	DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsScoutingReport');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_LeadByExample";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = 0;
	Effect.FocusMax = 5;
	Effect.FocusRecovery = 1;
	//Effect.AddNextFocusLevel(array<StatChanges);
	Effect.GainFocusEveryTurn = true;
	Effect.sFocusColour = "27aae1"; // Blue science
	Effect.sFocusLabel = default.ScoutingReport_Intel;
	Effect.sFocusTooltip = default.ScoutingReport_IntelDesc;
	Effect.sFocusIconPath ="img:///UILibrary_IsmsRogue.RogueFocus"; // "img:///UILibrary_Common.UIEvent_science";
	Template.AddTargetEffect(Effect);

	DamageEffect = new class'MZ_Effect_FocusAimModFromSource';
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	DamageEffect.EffectName = 'IsmsScoutingReport';
	DamageEffect.AimMod = 1.0f;
	DamageEffect.DefenseMod = 1.0f;
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	Template.AdditionalAbilities.AddItem('IsmsDecisiveAction');

	Template.PrerequisiteAbilities.AddItem('NOT_IsmsNaturalBornKiller');
	Template.PrerequisiteAbilities.AddItem('NOT_IsmsRushOfBattle');

	return Template;
}
static function X2AbilityTemplate DecisiveAction()
{
	local X2AbilityTemplate                 Template;
//	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local X2Condition_UnitEffects			UnitEffectsCondition;
	local X2Effect_RestoreActionPoints      RestoreEffect;
	local MZ_Cost_Focus						FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsDecisiveAction');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_LeadByExample";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_Major_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.DisplayTargetHitChance = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'MZ_Cost_Focus';
	FocusCost.ManaAmount = 5;
	FocusCost.ConsumeAllFocus = true;
	FocusCost.FocusAmount = 3;
	Template.AbilityCosts.AddItem(FocusCost);

	// The shooter cannot be mind controlled, bound, or carrying a unit.
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	UnitEffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	UnitEffectsCondition.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	//Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	// Only at single targets that are in range.

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
 
	RestoreEffect = new class'X2Effect_RestoreActionPoints';
//	RestoreEffect.TargetConditions.AddItem(new class'X2Condition_RevivalProtocol');
	Template.AddTargetEffect(RestoreEffect);

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = class'X2Ability_AdventCaptain'.static.TargetGettingMarked_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";

	Template.bCrossClassEligible = false;  

	return Template;
}

static function X2AbilityTemplate NaturalBornKiller()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;
	local array<StatChange>				StatChanges;
	local StatChange					NewStatChange;
	local MZ_Effect_FocusBonusDamage	DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsNaturalBornKiller');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_move_blaze";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = 0;
	Effect.FocusMax = 5;
	Effect.FocusRecovery = 1;
	//Effect.AddNextFocusLevel(array<StatChanges);
	Effect.GainFocusEveryTurn = true;
	Effect.sFocusColour = "27aae1"; // Blue science
	Effect.sFocusLabel = default.NBK_Focus;
	Effect.sFocusTooltip = default.NBK_FocusDesc;
	Effect.sFocusIconPath ="img:///UILibrary_IsmsRogue.RogueFocus";

	//	focus 0
	StatChanges.Length = 0;
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 1
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 1;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 2
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 2;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 3
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 3;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 4
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 4;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 5
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = 5;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);

	Template.AddTargetEffect(Effect);

	DamageEffect = new class'MZ_Effect_FocusBonusDamage';
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	DamageEffect.DamagePerFocus = default.GrandFinale_DamagePerFocus;
	DamageEffect.AbilityNames.AddItem('IsmsNBKGrandFinale');
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.ConcealmentRule = eConceal_Always;

	Template.AdditionalAbilities.AddItem('IsmsNBKGrandFinale');

	Template.PrerequisiteAbilities.AddItem('NOT_IsmsScoutingReport');
	Template.PrerequisiteAbilities.AddItem('NOT_IsmsRushOfBattle');

	return Template;
}
static function X2AbilityTemplate NBKGrandFinale()
{
	local X2AbilityTemplate					Template;
    local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_Visibility            TargetVisibilityCondition;
	//local X2Effect_NBKMobility2 Effect; 
	local MZ_Cost_Focus						FocusCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsNBKGrandFinale');

	Template.ConcealmentRule = eConceal_Never;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Executioner";
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_rifle_blaze";	

	Template.AbilityToHitCalc = default.SimpleStandardAim;

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = 2;
    Template.AbilityCooldown = Cooldown;

	FocusCost = new class'MZ_Cost_Focus';
	FocusCost.ManaAmount = 2;
	FocusCost.FocusAmount = 1;
	FocusCost.ConsumeAllFocus = true;
	Template.AbilityCosts.AddItem(FocusCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
 
 	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	Template.bAllowAmmoEffects = true;

	/*
	Effect = new class'X2Effect_NBKMobility2';
 	//Effect.AddPersistentStatChange(eStat_Mobility, 0);
	Effect.EffectName = 'Exhausted';
	Effect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.DuplicateResponse = eDupe_ignore;
	Effect.bApplyOnMiss = true;	
	Effect.SetDisplayInfo(ePerkBuff_Passive, "Exhausted", "Unit is exhausted and cannot gain focus.", "img:///UILibrary_IsmsRogue.UIPerk_stabilize_move2",,,Template.AbilitySourceName);
	Template.AddShooterEffect(Effect);
	*/
 
	Template.bShowActivation = true;
//	Template.ActivationSpeech = 'CombatStim';
 	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.ConcealmentRule = eConceal_KillShot;


	return Template;
}

static function X2AbilityTemplate RushOfBattle()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;
	local array<StatChange>				StatChanges;
	local StatChange					NewStatChange;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsRushOfBattle');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Adrenaline";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = 0;
	Effect.FocusMax = 18;
	Effect.FocusRecovery = 3;
	//Really should be enemy deaths only.
	Effect.GainFocusOnKill = true;
	Effect.GainOneFocusOnAssist = true;
	Effect.sFocusColour = "e69831"; // Orange
	Effect.sFocusLabel = default.RushOfBattle_Adrenaline;
	Effect.sFocusTooltip = default.RushOfBattle_AdrenalineDesc;
	Effect.sFocusIconPath ="img:///UILibrary_IsmsRogue.RogueFocus";

	//	focus 0
	StatChanges.Length = 0;
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 1
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 1;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 2
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 3;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 3
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 5;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 4
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 6;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 5
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 8;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 6
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 10;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 7
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 11;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 8
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 13;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 9
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 15;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 10
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 16;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 11
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 18;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 12
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 20;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 13
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 21;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 14
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 23;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 15
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 25;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 16
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 26;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 17
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 28;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);
	//	focus 18
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = 30;
	StatChanges.AddItem(NewStatChange);
	Effect.AddNextFocusLevel(StatChanges);

	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	Template.AdditionalAbilities.AddItem('IsmsCoolOff');

	Template.PrerequisiteAbilities.AddItem('NOT_IsmsScoutingReport');
	Template.PrerequisiteAbilities.AddItem('NOT_IsmsNaturalBornKiller');

	return Template;
}
static function X2AbilityTemplate CoolOff()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local Isms_Effect_AdrenalineHeal		HealEffect;
	local MZ_Cost_Focus						FocusCost;
	local X2Condition_UnitProperty			UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsCoolOff');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_Adrenaline";
	Template.Hostility = eHostility_Neutral;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Wraith_Armor";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = 5;
    Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'MZ_Cost_Focus';
	FocusCost.ManaAmount = 3;
	FocusCost.ConsumeAllFocus = true;
	FocusCost.FocusAmount = 99; //Ability won't work with templar focus.
	Template.AbilityCosts.AddItem(FocusCost);
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AddShooterEffectExclusions();

	HealEffect = new class'Isms_Effect_AdrenalineHeal';
	HealEffect.PercentHealthPerMana = 5.0f;
	Template.AddTargetEffect(HealEffect);

	Template.ActivationSpeech = 'CombatStim';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate LoneWolfPack() {
	local X2AbilityTemplate			Template;
	local X2Effect_LW2WotC_LoneWolf		DamageEffect;
	local X2Effect_PersistentStatChange	 PersistentStatChangeEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsLoneWolf');

	Template.IconImage = "img:///UILibrary_IsmsRogue.wc3";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_LW2WotC_LoneWolf';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageEffect.LONEWOLF_DEF_BONUS = 20;
	DamageEffect.LONEWOLF_MIN_DIST_TILES = 5;
	Template.AddTargetEffect(DamageEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_SightRadius, 2);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


static function X2AbilityTemplate BlazeOfGlory()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsBlazeOfGlory');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserk";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 8;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	AmmoCost.bFreeCost = false;
	AmmoCost.bConsumeAllAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
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

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Faceoff_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Faceoff'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'PanickedBreathing';
//END AUTOGENERATED CODE: Template Overrides 'Faceoff'

	Template.PostActivationEvents.AddItem('IsmsBlazeOfGloryTrigger');
	Template.AdditionalAbilities.AddItem('IsmsBlazeOfGlorySustain');

	return Template;
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
	for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
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

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex )
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
static function X2DataTemplate BlazeOfGlorySustain()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityTrigger_EventListener    EventTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsBlazeOfGlorySustain');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Sustain";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	// Use this to set up the special sustain anim.
	StasisEffect.StunStartAnim = 'HL_PsiSustainStart'; 
	StasisEffect.CustomIdleOverrideAnim = 'HL_CarryBodyLoop';
	StasisEffect.StunStopAnim = 'HL_GetUp';
	//StasisEffect.StunStartAnim='HL_SustainStart';
	//StasisEffect.StunStopAnim='HL_SustainStop';
	//StasisEffect.CustomIdleOverrideAnim='HL_SustainLoop';
	//
	StasisEffect.bSkipFlyover = true;
	Template.AddTargetEffect(StasisEffect);

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'IsmsBlazeOfGloryTrigger';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	//EventTrigger.ListenerData.Priority = 100; //High priority to help it trigger more reliably. Not sure how often this will matter tho.
	Template.AbilityTriggers.AddItem(EventTrigger);
	
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate LastWish()
{
	local X2AbilityTemplate             Template;
	local Isms_Effect_LastWish          SustainEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsLastWish');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Sustain";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SustainEffect = new class'Isms_Effect_LastWish';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	SustainEffect.EffectName = 'IsmsLastWish';
	Template.AddTargetEffect(SustainEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.AdditionalAbilities.AddItem('IsmsLastWishTriggered');

	return Template;
}
static function X2DataTemplate LastWishTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityTrigger_EventListener    EventTrigger;
	local X2Effect_DelayedAbilityActivation DelayedPsiExplosionEffect;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsLastWishTriggered');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Sustain";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow; // eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//	check that the unit is still alive.
	//	it's possible that multiple event listeners responded to the same event, and some of those other listeners
	//	went ahead and killed the unit before we got to trigger sustain.
	//	it would look weird to do the sustain visualization and then have the unit die, so just don't trigger sustain.
	//	e.g. a unit with a homing mine on it that takes a kill shot wants to have the death stopped, but the
	//	homing mine explosion can trigger before the sustain trigger goes off, killing the unit before it would be sustained
	//	and making things look really weird. now the unit will just die without "sustaining" the corpse.
	//	-jbouscher
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	// Use this to set up the special sustain anim.
	StasisEffect.StunStartAnim = 'HL_PsiSustainStart'; 
	StasisEffect.CustomIdleOverrideAnim = 'HL_CarryBodyLoop';
	StasisEffect.StunStopAnim = 'HL_GetUp';
	//StasisEffect.StunStartAnim='HL_SustainStart';
	//StasisEffect.StunStopAnim='HL_SustainStop';
	//StasisEffect.CustomIdleOverrideAnim='HL_SustainLoop';
	//
	StasisEffect.bSkipFlyover = true;
	Template.AddTargetEffect(StasisEffect);

	/*
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, 20);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, 20);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	*/

	DelayedPsiExplosionEffect = new class 'X2Effect_DelayedAbilityActivation';
	DelayedPsiExplosionEffect.BuildPersistentEffect(2, false, false, , eGameRule_PlayerTurnBegin);
	DelayedPsiExplosionEffect.EffectName = 'EffectEnterUnitConcealment';
	DelayedPsiExplosionEffect.TriggerEventName = 'EffectEnterUnitConcealment';
	DelayedPsiExplosionEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(DelayedPsiExplosionEffect);

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'SustainTriggered';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	//EventTrigger.ListenerData.Priority = 100; //High priority to help it trigger more reliably. Not sure how often this will matter tho.
	Template.AbilityTriggers.AddItem(EventTrigger);

	Template.PostActivationEvents.AddItem('SustainSuccess');
		
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate ScoutsOverwatch()
{
 
    local X2AbilityTemplate				 Template;
    local X2AbilityCooldown				 Cooldown;
    local X2AbilityCost_Ammo			 AmmoCost;
    local X2AbilityCost_ActionPoints	 ActionPointCost;
    local X2AbilityTarget_Cursor		 CursorTarget;
    local X2AbilityMultiTarget_Cone		 ConeMultiTarget;
    local X2Effect_ReserveActionPoints		ReservePointsEffect;
    local X2Effect_MarkValidActivationTiles MarkTilesEffect;
    local X2Condition_UnitEffects           SuppressedCondition;
//  local X2AbilityCharges                      Charges;
 
    `CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsScoutsOverwatch');

	//Template.ConcealmentRule = eConceal_Always;
 	Template.OverrideAbilities.AddItem('Overwatch');

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    AmmoCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(AmmoCost);
 
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;   //  this will guarantee the unit has at least 1 action point
    ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
    Template.AbilityCosts.AddItem(ActionPointCost);
 
    Template.AbilityToHitCalc = default.DeadEye;
 
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);
 
    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = 1;
    Template.AbilityCooldown = Cooldown;
 
 
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = false;
    Template.AbilityTargetStyle = CursorTarget;
 
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.bUseWeaponRadius = false;
    ConeMultiTarget.ConeEndDiameter = 8* class'XComWorldData'.const.WORLD_StepSize;  //LOOK HERE
    ConeMultiTarget.ConeLength = 22 * class'XComWorldData'.const.WORLD_StepSize;		//LOOK HERE
    Template.AbilityMultiTargetStyle = ConeMultiTarget;
 
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
 
    ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
    ReservePointsEffect.ReserveType = 'IsmScoutOverwatch';
    ReservePointsEffect.NumPoints = 1;  //# of shots in overwatch
    Template.AddShooterEffect(ReservePointsEffect);
 
    // Call var int m_iMovePipsTouched  from dependson(XComGameState_Unit);
 
    MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
    MarkTilesEffect.AbilityToMark = 'IsmsScoutsOverwatchShot';    //here
    Template.AddShooterEffect(MarkTilesEffect);
 
    Template.AdditionalAbilities.AddItem('IsmsScoutsOverwatchShot');  

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.bSkipFireAction = true;
    Template.bShowActivation = true;
 
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
 
    Template.ActivationSpeech = 'KillZone';
 	
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.TargetingMethod = class'X2TargetingMethod_Cone';
 
    Template.bCrossClassEligible = false;
 
    return Template;
}

static function X2AbilityTemplate ScoutsOverwatchShot()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityTrigger_Event            Trigger;
    local X2Effect_Persistent               KillZoneEffect;
    local X2Condition_UnitEffectsWithAbilitySource  KillZoneCondition;
    local X2Condition_Visibility            TargetVisibilityCondition;
 

    `CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsScoutsOverwatchShot');
 
// 	Template.ConcealmentRule = eConceal_Always;

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);
   
//    Template.AdditionalAbilities.AddItem('DeadeyeDamage');    //testing
   
    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;              //here?
    ReserveActionPointCost.bFreeCost = false;
    ReserveActionPointCost.AllowedTypes.AddItem('IsmScoutOverwatch');                
    Template.AbilityCosts.AddItem(ReserveActionPointCost);
 
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bReactionFire = false;              // aim is here. this is causing the camera to disappear
 // StandardAim.bAllowCrit = true; 
    StandardAim.bGuaranteedHit = false;    
    StandardAim.bHitsAreCrits = false;      // change this if you want all hits to be crits            
    Template.AbilityToHitCalc = StandardAim;                            // You can mess around above here to change the aim
	 
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bDisablePeeksOnMovement = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.TargetMustBeInValidTiles = true;
    Template.AbilityTargetConditions.AddItem(AbilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
 
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
 
	//  Do not shoot targets that were already hit by this unit this turn with this ability
	KillZoneCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	KillZoneCondition.AddExcludeEffect('KillZoneTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(KillZoneCondition);
	//  Mark the target as shot by this unit so it cannot be shot again this turn
	KillZoneEffect = new class'X2Effect_Persistent';
	KillZoneEffect.EffectName = 'KillZoneTarget';
	KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	KillZoneEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(KillZoneEffect); 
  
    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;
 
    //  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
    // holo or shredder here?
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
 	Template.AssociatedPassives.AddItem('HoloTargeting');
    Template.bAllowAmmoEffects = true;
 	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    //Trigger on movement - interrupt the move
    Trigger = new class'X2AbilityTrigger_Event';
    Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
    Trigger.MethodName = 'InterruptGameState';
    Template.AbilityTriggers.AddItem(Trigger);

    //Trigger = new class'X2AbilityTrigger_Event';
    //Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
    //Trigger.MethodName = 'InterruptGameState';
    //Template.AbilityTriggers.AddItem(Trigger);
 
 	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring"; 
    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
 
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
 
    return Template;
}

static function X2AbilityTemplate Flush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility			VisibilityCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Effect_GrantActionPoints		ActionPointsEffect;
	local X2Effect_RunBehaviorTree			FlushBehaviorEffect;
	local X2AbilityCooldown					Cooldown;
  
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IsmsFlush');
	
	Template.AdditionalAbilities.AddItem('IsmsFlushDamage');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_IsmsRogue.UIPerk_flush";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_Corporal_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//  Normal effect restrictions (except disoriented)
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
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
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = 1;
    Template.AbilityCooldown = Cooldown;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true; // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Allows this attack to work with the Holo-Targeting and Shredder perks, in case of AWC perkage
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// There's some nice stuff built into the standard aim calculations, including a place to apply the aim bonus
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = 30;
	Template.AbilityToHitCalc = StandardAim;
		
	// Targeting Method. There's other ones that let you do grenade spheres, cones, etc. This is the standard, single-target selection
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// Give the enemy a move action point
	ActionPointsEffect = new class'X2Effect_GrantActionPoints';
	ActionPointsEffect.NumActionPoints = 1;
	ActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointsEffect.bApplyOnMiss = true;
 	Template.AddTargetEffect(ActionPointsEffect);
	
	// Make the enemy scamper
	FlushBehaviorEffect = new class'X2Effect_RunBehaviorTree';
	FlushBehaviorEffect.BehaviorTreeName = 'Fallback'; 
//	FlushBehaviorEffect.BehaviorTreeName = 'IsmsBluff'; //PanickedFallBackUnsafe
	FlushBehaviorEffect.bApplyOnMiss = true;
 	Template.AddTargetEffect(FlushBehaviorEffect);
	
	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bCrossClassEligible = false;

	return Template;	
}