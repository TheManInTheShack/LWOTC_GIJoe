class MonkAbility extends X2Ability config(GameData_SoldierSkills);

var config int FlurryMobilityBonus, FlyingKickMobilityBonus, EvasionDefense, EvasionDodge;
var config int MartialArtsCrit, MartialArtsDmg, MartialArtsAim;
var config int GarroteDmg;
var config int UpgradeStealthCharges, StartStealthCharges;
var config int StunningFistCooldown, StunningFistDuration;
var config int HealAmount, HealCooldown;
var config int PhasingCooldown, WALL_PHASING_DURATION;
var config int TumbleMobility, TumbleCooldown;
var config int SpinKickLength, SpinKickDiameter, SpinKickCooldown;
var config float SpinKickDamageBonus;
var config int TimelessBodyWill;
var config float UpgradeDetection, BaseDetection;
var config array<name> MedikitHealEffectTypes;
var privatewrite name WraithActivationDurationEventName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;	

	Templates.AddItem(AddKVMonkFlurry());
	//Templates.AddItem(AddKVMonkFlurryStandardAP());
	Templates.AddItem(AddKVFlyingKickAbility());
	Templates.AddItem(AddKVFlyingKickBuff());
	Templates.AddItem(AddKVEvasion());
	Templates.AddItem(AddKVMartialArts());
	Templates.AddItem(AddKVGarrote());
	Templates.AddItem(AddKVStealth());
	Templates.AddItem(AddKVStealthDetection());
	Templates.AddItem(AddKVUpgradeStealth());
	Templates.AddItem(AddKVUpgradeStealthDetection());
	Templates.AddItem(AddKVUpgradeStealth());
	Templates.AddItem(AddKVStunningFist());
	Templates.AddItem(AddKVReStealth());
	Templates.AddItem(AddKVMonkHeal());
	Templates.AddItem(AddKVWallPhasing());
	Templates.AddItem(AddKVWraithActivation());
	Templates.AddItem(AddKVTumble());
	Templates.AddItem(AddKVSpinKickPassive());
	Templates.AddItem(AddKVSpinKick());
	Templates.AddItem(AddKVSpinKick2());
	Templates.AddItem(AddKVTimelessBody());
	Templates.AddItem(AddKVImpEvasionPassive());
	Templates.AddItem(AddKVMonkFlurryBuff());
	Templates.AddItem(AddKVReStealthPassive());

	return Templates;
}




static function X2AbilityTemplate AddKVMonkFlurry()
{
	local X2AbilityTemplate             Template;
	local KVFlurry						Effect;
	//local X2Effect_FlurryAction			FlurryAction;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVMonkFlurry');

	Template.IconImage = "img:///IRIBrawler.UI.UIPerk_WindcallerLegacy_Alt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.PostActivationEvents.AddItem('KVMonkFlurry');

	Effect = new class'KVFlurry';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);


	//PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	//PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 4);
	//PersistentStatChangeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); //(1, true, false, false);
	//PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	//PersistentStatChangeEffect.EffectName = 'Sprint';
	//PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	//Template.AddTargetEffect(PersistentStatChangeEffect);	

	//FlurryAction = new class'X2Effect_FlurryAction';
	//FlurryAction.DuplicateResponse = eDupe_Ignore;
	//FlurryAction.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); 
	//FlurryAction.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	//FlurryAction.bRemoveWhenTargetDies = true;
	//FlurryAction.FlurryMobilityBonus = default.FlurryMobilityBonus;
	//Template.AddTargetEffect(FlurryAction);



	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AdditionalAbilities.AddItem('KVMonkFlurryBuff');

	return Template;
}

static function X2AbilityTemplate AddKVMonkFlurryBuff()
{
	local X2AbilityTemplate					Template;
	//local KVFlyingKick						Effect;
	//local X2Effect_FlurryAction			FlurryAction;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVMonkFlurryBuff');

	Template.IconImage = "img:///IRIBrawler.UI.UIPerk_WindcallerLegacy_Alt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.PostActivationEvents.AddItem('KVMonkFlurry');
	EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventID = 'KVMonkFlurryBuffEffect';
    //EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Filter = eFilter_None;
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(EventListener);


	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.FlurryMobilityBonus);
	PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd); //(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PersistentStatChangeEffect.EffectName = 'MonkFlurryBuff';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);	

	//FlurryAction = new class'X2Effect_FlurryAction';
	//FlurryAction.DuplicateResponse = eDupe_Ignore;
	//FlurryAction.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); 
	//FlurryAction.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	//FlurryAction.bRemoveWhenTargetDies = true;
	//FlurryAction.FlurryMobilityBonus = default.FlurryMobilityBonus;
	//Template.AddTargetEffect(FlurryAction);



	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddKVFlyingKickAbility()
{
	local X2AbilityTemplate             Template;
	local KVFlyingKick						Effect;
	//local X2Effect_FlurryAction			FlurryAction;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVFlyingKickAbility');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_FullThrottle";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.PostActivationEvents.AddItem('KVMonkFlurry');

	Effect = new class'KVFlyingKick';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);


	//PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	//PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 4);
	//PersistentStatChangeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); //(1, true, false, false);
	//PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	//PersistentStatChangeEffect.EffectName = 'Sprint';
	//PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	//Template.AddTargetEffect(PersistentStatChangeEffect);	

	//FlurryAction = new class'X2Effect_FlurryAction';
	//FlurryAction.DuplicateResponse = eDupe_Ignore;
	//FlurryAction.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); 
	//FlurryAction.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	//FlurryAction.bRemoveWhenTargetDies = true;
	//FlurryAction.FlurryMobilityBonus = default.FlurryMobilityBonus;
	//Template.AddTargetEffect(FlurryAction);


	Template.AdditionalAbilities.AddItem('KVFlyingKickBuff');
	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddKVFlyingKickBuff()
{
	local X2AbilityTemplate             Template;
	//local KVFlyingKick						Effect;
	//local X2Effect_FlurryAction			FlurryAction;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVFlyingKickBuff');

	Template.IconImage = "img:///IRIBrawler.UI.UIPerk_WindcallerLegacy_Alt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.PostActivationEvents.AddItem('KVMonkFlurry');
	EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventID = 'KVFlyingKickEffect';
    //EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Filter = eFilter_None;
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(EventListener);


	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.FlyingKickMobilityBonus);
	PersistentStatChangeEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd); //(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PersistentStatChangeEffect.EffectName = 'FlyingKick';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(PersistentStatChangeEffect);	

	//FlurryAction = new class'X2Effect_FlurryAction';
	//FlurryAction.DuplicateResponse = eDupe_Ignore;
	//FlurryAction.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); 
	//FlurryAction.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	//FlurryAction.bRemoveWhenTargetDies = true;
	//FlurryAction.FlurryMobilityBonus = default.FlurryMobilityBonus;
	//Template.AddTargetEffect(FlurryAction);



	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//static function bool KVImpEvasionTrigger(XComGameStateContext Context)
//{
//
	//
	//local XComGameState					NewGameState;
	//local XComGameStateContext_Ability	AbilityContext;
	////local X2AbilityCost_ActionPoints	ActionPointCostOnMiss;
	//local XComGameStateHistory			History;
	////local XComGameState_Ability			AbilityState;
	//local XComGameState_Unit			SourceUnit;
	////local X2Effect_GrantActionPoints	ActionPointEffect;
//
	//History = `XCOMHISTORY;
	//NewGameState = History.CreateNewGameState(true, Context);
//
	//AbilityContext = XComGameStateContext_Ability(Context);
	//if( AbilityContext != none )
	//{
		////AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
		//SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, AbilityContext.InputContext.SourceObject.ObjectID));
		////SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
//
		//if (SourceUnit.HasSoldierAbility('KVImpEvasion'))
		//{
	//
			////ActionPointEffect = new class'X2Effect_GrantActionPoints';
			////ActionPointEffect.NumActionPoints = 1;
			////ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
			////ActionPointEffect.bSelectUnit = true;
			////Template.AddShooterEffect(ActionPointEffect);
			//return true;
	//
		//}
		//// finalize the movement portion of the ability
		////class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false); //Do not apply costs at this time.
//
		//// on a miss, this needs to actually cost an action point, so remove the "free" from the cost
		////AbilityContext = XComGameStateContext_Ability(Context);
		////if( AbilityContext.ResultContext.HitResult == eHit_Miss )
		////{
			////ActionPointCostOnMiss = new class'X2AbilityCost_ActionPoints';
			////ActionPointCostOnMiss.iNumPoints = 1;
	////
			////AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
			////SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, AbilityContext.InputContext.SourceObject.ObjectID));
	////
			////ActionPointCostOnMiss.ApplyCost(AbilityContext, AbilityState, SourceUnit, None, NewGameState);
		////}
	////
	//// build the "fire" animation for the skulljack
	////class'X2Ability_DefaultAbilitySet'.static.HackAbility_FillOutGameState(NewGameState); //Costs applied here.
	//}
	////return NewGameState;
	//return false;
//}
//


static function X2AbilityTemplate AddKVEvasion()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_GrantActionPoints			ActionPointEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	//local X2Effect_KVImpEvasion					ActionPointEffect;
	//local XComGameState_Unit					ShooterUnit;
	////local XComGameState_Unit					SourceUnit;
	////local XComGameStateContext_Ability			AbilityContext;
	////local XComGameState							NewGameState;
	////local XComGameStateContext					Context;
	//local XComGameState_Ability					AbilityState;
	//local XComGameStateHistory					History;




	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVEvasion');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ParryActivate'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'ParryActivate'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Parry";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
 	Template.AddShooterEffectExclusions();

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	//ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.AllowedTypes.AddItem('Move');
	Template.AbilityCosts.AddItem(ActionPointCost);

	//ShooterUnit = XComGameState_Unit(ActivationContext.AssociatedState.GetGameStateForObjectID(OwnerStateObject.ObjectID));
	//History = `XCOMHISTORY;
	//AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('KVImpEvasion').ObjectID));
	//SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	//AbilityContext = XComGameStateContext_Ability(Context);
	//NewGameState = TypicalAbility_BuildGameState(Context);
	//ShooterUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	//if (ShooterUnit.HasSoldierAbility('KVImpEvasion'))
	//if (SourceUnit.HasSoldierAbility('KVImpEvasion'))
	//if (KVImpEvasionTrigger(SourceUnit.HasSoldierAbility('KVImpEvasion'))
	//{
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('KVImpEvasionPassive');
		

		ActionPointEffect = new class'X2Effect_GrantActionPoints';
		ActionPointEffect.NumActionPoints = 1;
		ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
		ActionPointEffect.bSelectUnit = false;
		ActionPointEffect.TargetConditions.AddItem(AbilityCondition);
		//ActionPointEffect.OwnerHasSoldierAbilities.AddItem('KVImpEvasionPassive');
		Template.AddShooterEffect(ActionPointEffect);

		//ActionPointEffect = new class'X2Effect_KVImpEvasion';
		//ActionPointEffect.NumActionPoints = 1;
		//ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
		//ActionPointEffect.bSelectUnit = true;
		//Template.AddShooterEffect(ActionPointEffect);

	//}

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, default.EvasionDefense);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.EvasionDodge);
	PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	PersistentStatChangeEffect.EffectName = 'Evasion';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	return Template;
}

//static function X2Effect_HoloTarget HoloTargetEffect()
//{
	//local X2Effect_HoloTarget           Effect;
	//local X2Condition_AbilityProperty   AbilityCondition;
	//local X2AbilityTag                  AbilityTag;
//
	//Effect = new class'X2Effect_HoloTarget';
	//Effect.HitMod = default.HOLOTARGET_BONUS;
	//Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	//Effect.bRemoveWhenTargetDies = true;
	//Effect.bUseSourcePlayerState = true;
//
	//AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
	//AbilityTag.ParseObj = Effect;
//
	//Effect.SetDisplayInfo(ePerkBuff_Penalty, default.HoloTargetEffectName, `XEXPAND.ExpandString(default.HoloTargetEffectDesc), "img:///UILibrary_PerkIcons.UIPerk_holotargeting", true);
//
	//AbilityCondition = new class'X2Condition_AbilityProperty';
	//AbilityCondition.OwnerHasSoldierAbilities.AddItem('HoloTargeting');
	//Effect.TargetConditions.AddItem(AbilityCondition);
//
	//// bsg-dforrest (7.27.17): need to clear out ParseObject
	//AbilityTag.ParseObj = none;
	//// bsg-dforrest (7.27.17): end
//
	//return Effect;
//}

static function X2AbilityTemplate AddKVImpEvasionPassive()
{
	local X2AbilityTemplate AbilityTemplate;

	AbilityTemplate = PurePassive('KVImpEvasionPassive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadowrising", false, 'eAbilitySource_Perk', true);

	return AbilityTemplate;
}

static function X2AbilityTemplate AddKVMartialArts()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BonusWeaponDamage            DamageEffect;
	local X2Effect_ToHitModifier                HitModEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVMartialArts');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_BonusWeaponDamage';
	DamageEffect.BonusDmg = default.MartialArtsDmg;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, default.MartialArtsAim, Template.LocFriendlyName, class'X2AbilityToHitCalc_StandardMelee', true, false);
	HitModEffect.AddEffectHitModifier(eHit_Crit, default.MartialArtsCrit, Template.LocFriendlyName, class'X2AbilityToHitCalc_StandardMelee', true, false);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'MartialArts';
	Template.AddTargetEffect(HitModEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddKVGarrote()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BonusWeaponDamage            DamageEffect;
	//local X2Condition_Visibility                VisCondition;
	local X2AbilityTrigger_EventListener		Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVGarrote');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///CombatKnifeMod.UI.UIPerk_backstabber";
	Template.AdditionalAbilities.AddItem('MusashiKnifeSpecialistCooldown');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_Immediate;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.EventID = 'EffectEnterUnitConcealment';
	Template.AbilityTriggers.AddItem(Trigger);


	DamageEffect = new class'X2Effect_BonusWeaponDamage';
	DamageEffect.BonusDmg = default.GarroteDmg;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageEffect.EffectName = 'Garrote';
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	DamageEffect.bRemoveWhenTargetConcealmentBroken = true;
	//VisCondition = new class'X2Condition_Visibility';
	//VisCondition.bExcludeGameplayVisible = true;
	//DamageEffect.ToHitConditions.AddItem(VisCondition);
	Template.AddTargetEffect(DamageEffect);

	//Effect = new class'X2Effect_ToHitModifier';
	//Effect.EffectName = 'Shadowstrike';
	//Effect.DuplicateResponse = eDupe_Ignore;
	//Effect.BuildPersistentEffect(1, true, false);
	//Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	//Effect.AddEffectHitModifier(eHit_Success, default.SHADOWSTRIKE_AIM, Template.LocFriendlyName);
	//Effect.AddEffectHitModifier(eHit_Crit, default.SHADOWSTRIKE_CRIT, Template.LocFriendlyName);
	//VisCondition = new class'X2Condition_Visibility';
	//VisCondition.bExcludeGameplayVisible = true;
	//Effect.ToHitConditions.AddItem(VisCondition);
	//Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddKVStealth(name AbilityName = 'KVStealth')
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_ActionPoints			ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');


	ActionPointCost =  new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	//if (ShooterUnit.HasSoldierAbility('KVUpgradeStealth'))
	Charges.InitialCharges = default.StartStealthCharges;
	Charges.AddBonusCharge('KVUpgradeStealth', default.UpgradeStealthCharges);
	Template.AbilityCharges = Charges;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	Template.AddShooterEffectExclusions();

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
	Template.AddTargetEffect(ShadowAnimEffect());

	Template.ActivationSpeech = 'Shadow';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.AdditionalAbilities.AddItem('KVStealthDetection');
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddKVStealthDetection()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	//local X2AbilityCost_ActionPoints			ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVStealthDetection');

Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_FullThrottle";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.BaseDetection);
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PersistentStatChangeEffect.EffectName = 'BaseStealthDetection';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.Hostility = eHostility_Neutral;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	// No Visualization
	return Template;
}

static function X2Effect ShadowAnimEffect()
{
	local X2Effect_AdditionalAnimSets			Effect;

	Effect = new class'X2Effect_AdditionalAnimSets';
	Effect.EffectName = 'ShadowAnims';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	Effect.bRemoveWhenTargetConcealmentBroken = true;
	Effect.AddAnimSetWithPath("Reaper.Anims.AS_ReaperShadow");

	return Effect;
}

static function X2AbilityTemplate AddKVUpgradeStealth()
{
	local X2AbilityTemplate AbilityTemplate;
	AbilityTemplate = PurePassive('KVUpgradeStealth', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadowrising", false, 'eAbilitySource_Perk', true);
	AbilityTemplate.ActivationSpeech = 'ShadowRising';
	AbilityTemplate.AdditionalAbilities.AddItem('KVUpgradeStealthDetection');
	AbilityTemplate.PrerequisiteAbilities.AddItem('KVStealth');

	return AbilityTemplate;
}

static function X2AbilityTemplate AddKVUpgradeStealthDetection()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	//local X2AbilityCost_ActionPoints			ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVUpgradeStealthDetection');

Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_FullThrottle";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.UpgradeDetection);
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin); //(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	PersistentStatChangeEffect.EffectName = 'StealthDetection';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.Hostility = eHostility_Neutral;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	// No Visualization
	return Template;
}

static function X2AbilityTemplate AddKVStunningFist()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Stunned					StunnedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVStunningFist');
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_punch";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = 320;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.StunningFistCooldown;
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
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.StunningFistDuration, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = true;
	StunnedEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(StunnedEffect);
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}




static function X2AbilityTemplate AddKVReStealthPassive()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('KVReStealthPassive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction");
	Template.AdditionalAbilities.AddItem('KVReStealth');

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate AddKVReStealth()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_RangerStealth            StealthEffect;
	local X2Condition_Stealth				StealthCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealth');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bSkipExitCoverWhenFiring = true;
	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.CustomFireAnim = 'NO_ShadowStart';
	Template.ActivationSpeech = 'Shadow';

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	StealthCondition = new class'X2Condition_Stealth';
	StealthCondition.bCheckFlanking = false;
	Template.AbilityShooterConditions.AddItem(StealthCondition);


	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(ShadowAnimEffect());
	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}

//static function X2AbilityTemplate AddKVReStealthPassive()
//{
//
	//local X2AbilityTemplate					Template;
	//local X2Effect_ReStealth				ConcealEffect;
	////local X2AbilityCooldown_LocalAndGlobal	Cooldown;
		//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealthPassive');
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	////Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');
//
	//// Setup effect triggering reconceal events
	//ConcealEffect = new class'X2Effect_ReStealth';
	//ConcealEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnEnd);
	//Template.AddTargetEffect(ConcealEffect);
//
	////Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	////Cooldown.iNumTurns = 1;
	////Cooldown.NumGlobalTurns = 0;
	////Template.AbilityCooldown = Cooldown;
//
	//Template.AddTargetEffect(ShadowAnimEffect());
	//Template.ActivationSpeech = 'Distraction';
	//Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	////  NOTE: No visualization on purpose!
	//Template.ActivationSpeech = 'Distraction';
//
	//return Template;
//}


//ignore this garbage


////add trigger
//static function X2AbilityTemplate AddKVReStealthPassive()
//{
	//local X2AbilityTemplate				Template;
	//local X2Effect_GrantCharges			AddCharge;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealthPassive');
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
//
	////Template.ConcealmentRule = eConceal_Always;
//
	//AddCharge = new class'X2Effect_GrantCharges';
	//AddCharge.NumCharges = 1;
	//AddCharge.AbilityName = 'KVStealth';
	////Template.AddShooterEffect(AddCharge);
	//Template.AddTargetEffect(AddCharge);
//
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	////  NOTE: No visualization on purpose!
	//Template.ActivationSpeech = 'Distraction';
//
	//return Template;
//}
//


//static function X2AbilityTemplate AddKVReStealthPassive()
//{
	//local X2AbilityTemplate				Template;
	//local X2Effect_ReStealth			ConcealEffect;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealthPassive');
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
//
	//Template.ConcealmentRule = eConceal_Always;
//
	//ConcealEffect = new class'X2Effect_ReStealth';
	//ConcealEffect.BuildPersistentEffect(1, true, false, false);
	////ConcealEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	//Template.AddTargetEffect(ConcealEffect);
//
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	////  NOTE: No visualization on purpose!
	//Template.ActivationSpeech = 'Distraction';
//
	//return Template;
//}
//


//static function X2AbilityTemplate AddKVReStealthPassive()
//{
	//local X2AbilityTemplate						Template;
	//local X2Effect_Distraction                  Effect;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealthPassive');
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
//
	//Effect = new class'X2Effect_ReStealth';
	//Effect.BuildPersistentEffect(1, true, false, false);
	//Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	//Template.AddTargetEffect(Effect);
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	////  NOTE: No visualization on purpose!
//
	//Template.AdditionalAbilities.AddItem('KVReStealth');
////BEGIN AUTOGENERATED CODE: Template Overrides 'Distraction'
	//Template.ActivationSpeech = 'Distraction';
////END AUTOGENERATED CODE: Template Overrides 'Distraction'
	//Template.AddTargetEffect(ShadowAnimEffect());
	//Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
//
	//return Template;	
//}

//static function X2AbilityTemplate AddKVReStealth()
//{
	//local X2AbilityTemplate						Template;
	//local X2Effect_RangerStealth                StealthEffect;
	//local X2Condition_Stealth					StealthCondition;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVReStealth');
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
////BEGIN AUTOGENERATED CODE: Template Overrides 'DistractionShadow'
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
	//Template.bSkipExitCoverWhenFiring = true;
	//Template.FrameAbilityCameraType = eCameraFraming_Always;
	//Template.CustomFireAnim = 'NO_ShadowStart';
	//Template.ActivationSpeech = 'Shadow';
////END AUTOGENERATED CODE: Template Overrides 'DistractionShadow'
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
//
	//Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//Template.AddShooterEffectExclusions();
	//StealthCondition = new class'X2Condition_Stealth';
	//StealthCondition.bCheckFlanking = false;
	//Template.AbilityShooterConditions.AddItem(StealthCondition);
	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
//
	//StealthEffect = new class'X2Effect_RangerStealth';
	//StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	//StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	//StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	//StealthEffect.EffectRemovedFn = ShadowEffectRemoved;
	//Template.AddTargetEffect(StealthEffect);
//
	//Template.AddTargetEffect(ShadowAnimEffect());
	//Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
//
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.bSkipFireAction = true;
//
	//return Template;
//}


//static function X2AbilityTemplate AddKVReStealth(name AbilityName = 'KVReStealth')
//{
	//local X2AbilityTemplate						Template;
	//local X2Effect_RangerStealth                StealthEffect;
	//local X2AbilityTrigger_EventListener		EventListenerTrigger;
	//local X2Condition_Stealth					StealthCondition;
//
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
//
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	//Template.Hostility = eHostility_Neutral;
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow";
	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	//Template.bDisplayInUITacticalText = true;
	//Template.bDisplayInUITooltip = true;
	//Template.bDontDisplayInAbilitySummary = true;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
//
    //EventListenerTrigger = new class'X2AbilityTrigger_EventListener';
	//EventListenerTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	//EventListenerTrigger.ListenerData.EventID = 'KillMail';
	//EventListenerTrigger.ListenerData.Filter = eFilter_None;
	//EventListenerTrigger.ListenerData.Priority = 10;
	//EventListenerTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.FullThrottleListener;
	//Template.AbilityTriggers.AddItem(EventListenerTrigger);
//
//
	////Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	////Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	////Template.AddShooterEffectExclusions();
//
	//Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//Template.AddShooterEffectExclusions();
	//StealthCondition = new class'X2Condition_Stealth';
	//StealthCondition.bCheckFlanking = false;
	//Template.AbilityShooterConditions.AddItem(StealthCondition);
	////Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
//
	//StealthEffect = new class'X2Effect_RangerStealth';
	//StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	//StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	//StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	//StealthEffect.DuplicateResponse = eDupe_Ignore;
	//Template.AddTargetEffect(StealthEffect);
//
	//Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
	//Template.AddTargetEffect(ShadowAnimEffect());
//
	//Template.ActivationSpeech = 'Shadow';
	//Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.bSkipFireAction = true;
//
	//Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
//
	//return Template;
//}

static function X2AbilityTemplate AddKVMonkHeal(name AbilityName = 'KVMonkHeal')
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Effect_ApplyMedikitHeal         MedikitHeal;
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;
	local X2AbilityCooldown					Cooldown;
	local array<name>                       SkipExclusions;
	local name                              HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_medkit";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HealCooldown;
	Template.AbilityCooldown = Cooldown;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = default.HealAmount;
	Template.AddTargetEffect(MedikitHeal);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.MEDIKIT_HEAL_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;

	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddKVWallPhasing()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_PersistentTraversalChange	WallPhasing;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_TriggerEvent					ActivationWindowEvent;
	local X2Condition_UnitEffects               EffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVWallPhasing');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_wraith";
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Wraith_Armor";

	Template.AdditionalAbilities.AddItem( 'KVWraithActivation' );

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );
	Template.AbilityTriggers.AddItem( default.PlayerInputTrigger );
	Template.AbilityToHitCalc = default.DeadEye;
	
	ActionPointCost =  new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PhasingCooldown;
	Template.AbilityCooldown = Cooldown;

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	EffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	ActivationWindowEvent = new class'X2Effect_TriggerEvent';
	ActivationWindowEvent.TriggerEventName = default.WraithActivationDurationEventName;
	Template.AddTargetEffect( ActivationWindowEvent );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bSkipPerkActivationActions = true; // we'll trigger related perks as part of the movement action

	WallPhasing = new class'X2Effect_PersistentTraversalChange';
	WallPhasing.BuildPersistentEffect( default.WALL_PHASING_DURATION, false, true, false, eGameRule_PlayerTurnBegin );
	WallPhasing.SetDisplayInfo( ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText( ), Template.IconImage, true );
	WallPhasing.AddTraversalChange( eTraversal_Phasing, true );
	WallPhasing.EffectName = 'PhasingEffect';
	WallPhasing.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect( WallPhasing );

	return Template;
}

static function X2AbilityTemplate AddKVWraithActivation()
{
	local X2AbilityTemplate		Template;
	local X2Effect_Persistent	ActivationDuration;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVWraithActivation');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityCosts.AddItem( default.FreeActionCost );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = default.WraithActivationDurationEventName;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.WallPhasingActivation;
	Template.AbilityTriggers.AddItem( EventListener );

	ActivationDuration = new class'X2Effect_Persistent';
	ActivationDuration.BuildPersistentEffect( default.WALL_PHASING_DURATION, false, true, false, eGameRule_PlayerTurnBegin );
	ActivationDuration.EffectName = 'ActivationDuration';
	ActivationDuration.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect( ActivationDuration );

	return Template;
}

static function X2AbilityTemplate AddKVTumble()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_Persistent                   ReflexesEffect;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_GrantActionPoints			ActionPointEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVTumble');

//BEGIN AUTOGENERATED CODE: Template Overrides 'ParryActivate'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'ParryActivate'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
 	Template.AddShooterEffectExclusions();

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.TumbleCooldown;
	Template.AbilityCooldown = Cooldown;
	
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 2;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointEffect.bSelectUnit = false;
	Template.AddShooterEffect(ActionPointEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.TumbleMobility);
	PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	PersistentStatChangeEffect.EffectName = 'Tumble';
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	ReflexesEffect = new class'X2Effect_Persistent';
	ReflexesEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	ReflexesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	ReflexesEffect.EffectTickedFn = ReflexesEffectTicked;
	ReflexesEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ReflexesEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_VanishingWind';
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	return Template;
}

function bool ReflexesEffectTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit SourceUnit, NewSourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (SourceUnit != none)
	{
		if (!SourceUnit.bLightningReflexes)
		{
			NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
			NewSourceUnit.bLightningReflexes = true;
		}
	}

	return false;           //  do not end the effect
}

static function X2AbilityTemplate AddKVSpinKickPassive()
{

	local X2AbilityTemplate						Template;
	//local X2Effect_BonusWeaponDamage							DamageEffect;
	local X2Effect_SpinKickDamage				DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVSpinKickPassive');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//DamageEffect = new class'X2Effect_BonusWeaponDamage';
	//DamageEffect.BonusDmg = default.SpinKickDamagePenalty;
	//DamageEffect.ValidAbilities.AddItem('KVSpinKick');
	//DamageEffect.BuildPersistentEffect(1, true, false, false);
	//DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	//Template.AddTargetEffect(DamageEffect);

	DamageEffect = new class'X2Effect_SpinKickDamage';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.AdditionalAbilities.AddItem('KVSpinKick');
	//Template.AdditionalAbilities.AddItem('KVSpinKick2');
	
	return Template;
}


static function X2AbilityTemplate AddKVSpinKick()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee	MeleeHitCalc;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local array<name> SkipExclusions;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	//local MZ_Damage_AddElemental			WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVSpinKick');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_chryssalid_chargeandslash";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SpinKickCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = MeleeHitCalc;

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	//WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	//WeaponDamageEffect.Element = 'Melee';
	//WeaponDamageEffect.BonusDamageScalar = default.SpinKickDamageBonus;
	//WeaponDamageEffect.bIgnoreArmor = false;
	//WeaponDamageEffect.bNoShredder = true;
	//Template.AddTargetEffect(WeaponDamageEffect);


	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = default.SpinKickLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.SpinKickDiameter * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.SpinKickLength * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt( Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength) ) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	// May attack if the unit is burning or disoriented
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Primary Target
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeCosmetic = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	// Multi Targets
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MeleeAttackA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Faceless_ScythingClaws";
//BEGIN AUTOGENERATED CODE: Template Overrides 'ScythingClaws'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ScythingClaws'
	
	
	//Template.PostActivationEvents.AddItem('KVSpinKick2');
	
	return Template;
}

static function X2AbilityTemplate AddKVSpinKick2()
{
	local X2AbilityTemplate					Template;
	//local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee	MeleeHitCalc;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local array<name> SkipExclusions;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTrigger_EventListener    Trigger;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVSpinKick2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_chryssalid_chargeandslash";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bConsumeAllPoints = true;
	//Template.AbilityCosts.AddItem(ActionPointCost);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'KVSpinKick2';
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = MeleeHitCalc;

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = default.SpinKickLength * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.SpinKickDiameter * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.SpinKickLength * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt( Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength) ) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	// May attack if the unit is burning or disoriented
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Primary Target
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeCosmetic = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.DamageTypes.AddItem('melee');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	// Multi Targets
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);	

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MeleeAttackA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Faceless_ScythingClaws";
//BEGIN AUTOGENERATED CODE: Template Overrides 'ScythingClaws'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ScythingClaws'
	
	
	return Template;
}


static function X2AbilityTemplate AddKVTimelessBody()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         PersistentStatChangeEffect;
	local X2Effect_DamageImmunity               ImmunityEffect;
	local X2Effect_DamageImmunity				DamageImmunity;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'KVTimelessBody');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stasisshield";
	//Template.IconImage = "UILibrary_XPACK_Common.PerkIcons.UIPerk_mindshield";
	Template.bDisplayInUITacticalText = true;
	Template.bDisplayInUITooltip = true;
	Template.bDontDisplayInAbilitySummary = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, default.TimelessBodyWill);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	ImmunityEffect = new class'X2Effect_DamageImmunity';
	ImmunityEffect.EffectName = 'TimelessBody';
	ImmunityEffect.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
	ImmunityEffect.ImmuneTypes.AddItem('stun');
	ImmunityEffect.BuildPersistentEffect(1, true, false, false);
	ImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(ImmunityEffect);

	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.BuildPersistentEffect(1, true, false, false);
	DamageImmunity.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}


//
//static function X2AbilityTemplate AddKVMonkFlurryStandardAP()
//{
	//local X2AbilityTemplate             Template;
	////local X2Effect_FlurryAction			FlurryAction;
	//local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	////local X2AbilityTrigger				Trigger, ListenerData;
	////local AbilityEventListener			;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'KVMonkFlurryStandardAP');
//
	//Template.IconImage = "img:///IRIBrawler.UI.UIPerk_WindcallerLegacy_Alt";
	//Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
//
	//Template.bDisplayInUITacticalText = false;
	//Template.bDisplayInUITooltip = false;
	//Template.bDontDisplayInAbilitySummary = true;
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	////Trigger = new class 'X2AbilityTrigger_OnAbilityActivated';
    ////Trigger.SetListenerData('KVMonkFlurry');
    ////Template.AbilityTriggers.AddItem(Trigger);
//
	//PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	//PersistentStatChangeEffect.EffectName = 'GuardianAngel';
	//PersistentStatChangeEffect.DuplicateResponse = eDupe_Allow;
	//PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	//PersistentStatChangeEffect.BuildPersistentEffect(2, , , , eGameRule_PlayerTurnBegin);
	//PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	//PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 12);
	//Template.AddTargetEffect(PersistentStatChangeEffect);
//
	////FlurryAction = new class'X2Effect_FlurryAction';
	////FlurryAction.DuplicateResponse = eDupe_Ignore;
	////FlurryAction.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin); 
	////FlurryAction.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
	////FlurryAction.bRemoveWhenTargetDies = true;
	////FlurryAction.FlurryMobilityBonus = default.FlurryMobilityBonus;
	////Template.AddTargetEffect(FlurryAction);
//
	//Template.Hostility = eHostility_Neutral;
	//Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//
	//return Template;
//}
//




////	Make the kick activatable only with Move actions
	//Template.AbilityCosts.Length = 0;
	//ActionPointCost = new class'X2AbilityCost_ActionPoints';
	//ActionPointCost.AllowedTypes.Length = 0;
	//ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
	//ActionPointCost.bMoveCost = true;
	//ActionPointCost.iNumPoints = 1;
	//ActionPointCost.bConsumeAllPoints = false;
	//Template.AbilityCosts.AddItem(ActionPointCost);
//
//
	////Knockback
	//KnockbackEffect = new class'X2Effect_Knockback';
	//KnockbackEffect.KnockbackDistance = 1;
	//KnockbackEffect.bKnockbackDestroysNonFragile = false;
	//KnockbackEffect.OnlyOnDeath = true;
	//Template.AddTargetEffect(KnockbackEffect);
//
	////	Allows knockback animation to play
	//Template.bOverrideMeleeDeath = true;

	DefaultProperties
{
	WraithActivationDurationEventName="WraithActivationEvent"
}