class MZPsiAmp_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);

//config variables to pull from config file
var config int Disable_Cooldown, Disable_Range, Disable_Radius, Disable_Stun_Duration, Disable_Stun_Chance, Fireball_Range, Fireball_Cooldown, Fireball_BurnDamage, Fireball_BurnSpread, Acidball_Range, Acidball_Cooldown, Acidball_BurnDamage, Acidball_BurnSpread, Poisonball_Range, Poisonball_Cooldown;
var config int Malaise_Cooldown, Malaise_Range, Malaise_Radius, Malaise_Disorient, Malaise_PoisonCloudDuration, KineticPush_Cooldown, KineticPush_Knockback;
var config int Fuse_Cooldown, Protection_Cooldown, Zombify_Cooldown, Zombify_Turns, HaltUndead_Range, HaltUndead_Cooldown, HaltUndead_Stun, DeadExplode_Cooldown, DeadExplode_BurnDamage, DeadExplode_BurnSpread, ControlDead_Cooldown, ControlDead_Duration, CurseLure_Cooldown, CurseLure_Turns;
var config int Panacea_APHeal, Panacea_Charges, Panacea_Cooldown, Panacea_PerUseHP, Panacea_Spread, Healer_Panacea_BonusCharges;
var config int MindSoothe_Cooldown, PsiPanic_Cooldown, MachinaPuppeteer_Cooldown, MachinaPuppeteer_Duration, KineticPull_Cooldown, KineticRescue_Cooldown;
var config WeaponDamageValue Schism_Damage;
var config int Betrayal_APHeal, Betrayal_Cooldown, MindControl_Cooldown, MindControl_Duration;
var config int KineticLance_Cooldown, KineticLance_Knockback, KineticLance_Range;
var config int PsiBlind_Cooldown, PsiBlind_BlindTurns, PsiBlind_Disorient, PsiBreath_Cooldown, PsiBreath_Length, PsiBreath_Width, SearingLance_Cooldown, CausticLance_Cooldown;
var config float PsiBlind_VisionMult, PsiHeal_PsiFactor, RestoreLife_PsiFactor, RayOfLife_PsiFactor, Panacea_PsiFactor, Rayzeel_PsiFactor, ManuForti_BaseMult, ManuForti_PsiMult, AmorFati_BonusMult, AmorFati_PsiMult, MindMerge_DEATH_DELAY_S, Fuse_BonusMult, HaltUndead_Radius, DeadExplode_Radius, Fireball_Radius, Acidball_Radius, Poisonball_Radius;
var config int PsiHeal_Cooldown, PsiHeal_PerUseHP, PsiHeal_Spread, PsiHeal_Charges, PsiHeal_Range, Healer_PsiHeal_BonusCharges;
var config int RestoreLife_PerUseHP, RestoreLife_Spread, RestoreLife_Cooldown, RestoreLife_Range, TransmitPrana_Range;
var config int RayOfLife_Cooldown, RayOfLife_PerUseHP, RayOfLife_Spread, RayOfLife_Charges, RayOfLife_Range, Healer_RayOfLife_BonusCharges;
var config int Magnus_Cooldown, Magnus_Range, Magnus_Radius, Rayzeel_PerUseHP, Rayzeel_Spread, Rayzeel_Range;
var config int ManuForti_Range, ManuForti_Cooldown, ManuForti_Duration, AmorFati_Range, AmorFati_BonusFlat, AmorFati_Cooldown, AmorFati_Duration, AmorFati_AimMod;
var config int AuroraWave_Range, AuroraWave_Cooldown, AuroraWave_Charges, AuroraWave_MF_BonusFlat, AuroraWave_AF_BonusFlat, AuroraWave_Duration;
var config int MindMerge_Mobility, MindMerge_Aim, MindMerge_Crit, MindMerge_Cooldown, MindMerge_Duration, MindMerge_Psi, MindMerge_Hack, MindMerge_Range;
var config int FireWhip_Cooldown, ShiningAir_Cooldown, ShiningAir_BlindTurns, EvilGaze_Cooldown, BoulderCrush_Cooldown, BoulderCrush_Stun, ThunderousRoar_Cooldown, EarthHeal_Cooldown, EarthHeal_Charges, Healer_EarthHeal_BonusCharges, EarthHeal_PerUseHP, EarthHeal_Spread, EarthHeal_RegenTurns, EarthHeal_RegenRate;
var config int WhiteFlame_Cooldown, WhiteFlame_Charges, WhiteFlame_Range, WhiteFlame_PerUseHP, WhiteFlame_Spread, WhiteFlame_RegenTurns, WhiteFlame_RegenRate;
var config float ShiningAir_VisionMult, EarthHeal_PsiFactor, WhiteFlame_PsiFactor, WhiteFlame_Radius;
var config bool bPatchNormalFuse, bStealthNormalFuse;

var config int PhantasmalPrison_Cooldown, PhantasmalPrison_Stun, PhantasmalKiller_Cooldown, PhantasmalKiller_InitialDamage, PhantasmalKiller_PulseDamage, PhantasmalKiller_Stun;
var config int PhantasmalWeird_InitialDamage, PhantasmalWeird_PulseDamage, PhantasmalWeird_Stun, PhantasmalWeird_Range, PhantasmalWeird_Charges, MassPanic_Cooldown, MassPanic_Range, MassSleep_Cooldown, MassSleep_Range;
var config float PhantasmalKiller_PsiToDamage, PhantasmalWeird_PsiToDamage, PhantasmalWeird_Radius, MassPanic_Radius, MassSleep_Radius;

var localized string ManuFortiEffectDesc, AmorFatiEffectDesc, ThunderousRoarSilenceEffectName;

var privatewrite name EndMZDisableDurationFXEventName;
var privatewrite name MZDisableDurationFXEffectName;
var privatewrite name MZFuseEventName;
var privatewrite name MZFusePostEventName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddDisableAbility());
	/*>>*/Templates.AddItem(MZDisableEndDurationFX());
	Templates.AddItem(AddMalaiseAbility());
	Templates.AddItem(AddFuseAbility());
	Templates.AddItem(AddPanaceaAbility());
	Templates.AddItem(AddMindSootheAbility());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZClearTranquil', "img:///UILibrary_PerkIcons.UIPerk_timeshift", 'MZMindSoothe'));
	Templates.AddItem(AddPsiPanicAbility());
	Templates.AddItem(AddBetrayalAbility());
	Templates.AddItem(AddMindControlAbility());
	Templates.AddItem(AddProtectionAbility());
	Templates.AddItem(AddKineticLanceAbility());
	Templates.AddItem(AddPsiBlindAbility());
	Templates.AddItem(AddPsiHeal());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZHealersMind', "img:///UILibrary_PerkIcons.UIPerk_fieldmedic", 'MZPsiHeal'));
	Templates.AddItem(AddRestoreLife());
	/*>>*/Templates.AddItem(AddRestoreLifeChaser());
	Templates.AddItem(AddRayOfLife());
	Templates.AddItem(AddTurnUndead());
	Templates.AddItem(AddMagnusExorcismus());
	Templates.AddItem(AddRayzeelSong());
	Templates.AddItem(AddManuForti());
	Templates.AddItem(AddTransmitPrana());
	Templates.AddItem(AddAuroraWave());
	Templates.AddItem(CreateMindMerge(default.MindMerge_Mobility, default.MindMerge_Aim, default.MindMerge_Crit));
	/*>>*/Templates.AddItem(CreatePriestRemoved());
	/*>>*/Templates.AddItem(CreateMindMerge2(default.MindMerge_Mobility, default.MindMerge_Aim, default.MindMerge_Crit));
	Templates.AddItem(CreateCongregation());
	Templates.AddItem(AddAmorFati());
	Templates.AddItem(AddZombifyAbility());
	Templates.AddItem(AddHaltUndead());
	Templates.AddItem(AddControlUndead());
	Templates.AddItem(AddDeadExplosion());
	Templates.AddItem(AddCurseLureAbility());
	Templates.AddItem(AddMachinaPuppeteer());
	Templates.AddItem(AddFireball());
	Templates.AddItem(AddKineticPushAbility());
	Templates.AddItem(FireWhip());
	Templates.AddItem(ShiningAir());
	Templates.AddItem(BoulderCrush());
	Templates.AddItem(ThunderousRoar());
	Templates.AddItem(EvilGaze());
	Templates.AddItem(EarthHeal());
	Templates.AddItem(WhiteFlame());

	Templates.AddItem(BurningHands());
	Templates.AddItem(AcidSpray());
	Templates.AddItem(StormBreath());
	Templates.AddItem(FetidBreath());
	Templates.AddItem(SearingLance());
	Templates.AddItem(AcidBall());
	Templates.AddItem(PoisonBall());
	Templates.AddItem(CausticLance());

	Templates.AddItem(HellishRebuke());
	/*>>>*/Templates.AddItem(HellishRebukeAttack());

	Templates.AddItem(PhantasmalPrison());
	Templates.AddItem(PhantasmalKiller());
	Templates.AddItem(PhantasmalWeird());
	Templates.AddItem(MassPanic());
	Templates.AddItem(MassSleep());
	Templates.AddItem(Sleep());

	Templates.AddItem(KineticPull());
	Templates.AddItem(KineticRescue());

	return Templates;
}

DefaultProperties
{
	MZFuseEventName="FuseTriggered"
	MZFusePostEventName="FusePostTriggered"
	//SoulStealEventName="SoulStealTriggered"
	//SoulStealUnitValue="SoulStealAmount"
	//VoidRiftInsanityEventName="VoidRiftInsanityTriggered"
	EndMZDisableDurationFXEventName="EndVoidRiftDurationFXEvent"
	MZDisableDurationFXEffectName="VoidRiftDurationFXEffect"
}

static function X2AbilityTemplate AddDisableAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_DisableWeapon        	DisableWeaponEffect;
	local X2Effect_Stunned		       		StunnedEffect;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDisable');

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Disable_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Disable_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Disable_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.MZDisableDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);

	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndMZDisableDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);

	DisableWeaponEffect = new class 'MZ_Effect_DisableWeapon';
	Template.AddMultiTargetEffect(DisableWeaponEffect);
	
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.Disable_Stun_Duration, default.Disable_Stun_Chance, false);
	StunnedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	Template.AddMultiTargetEffect(StunnedEffect);
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DisablingShot";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.AdditionalAbilities.AddItem('MZDisableEndDurationFX');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate MZDisableEndDurationFX()
{
	local X2AbilityTemplate             Template;
	local X2Effect_RemoveEffects        VoidRiftRemoveEffects;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDisableEndDurationFX');
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = default.EndMZDisableDurationFXEventName;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_VoidRiftEndDurrationFX;
	Template.AbilityTriggers.AddItem(EventListener);

	VoidRiftRemoveEffects = new class'X2Effect_RemoveEffects';
	VoidRiftRemoveEffects.EffectNamesToRemove.AddItem(default.MZDisableDurationFXEffectName);
	Template.AddShooterEffect(VoidRiftRemoveEffects);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bUniqueSource = true; //only need to get it once.
	
	return Template;
}

static function X2AbilityTemplate AddMalaiseAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_PersistentStatChange        	DisorientedEffect;
	local X2Effect_ApplyPoisonToWorld           PoisonCloudEffect;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMalaise');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Malaise_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Malaise_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Malaise_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.MZDisableDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);
	
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = default.Malaise_Disorient;     
	DisorientedEffect.DamageTypes.AddItem('Psi');
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	PoisonCloudEffect = new class 'X2Effect_ApplyPoisonToWorld';
	PoisonCloudEffect.Duration = default.Malaise_PoisonCloudDuration;
	Template.AddMultiTargetEffect(PoisonCloudEffect);
	
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndMZDisableDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_poisoncloud";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.AdditionalAbilities.AddItem('MZDisableEndDurationFX');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddFuseAbility()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local MZ_Effect_MultiAbilityDamage	DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFuse');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.ConcealmentRule = eConceal_Always;
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Fuse_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');	
	Template.AddShooterEffectExclusions();

	DamageEffect = new class'MZ_Effect_MultiAbilityDamage';
	DamageEffect.BuildPersistentEffect(0, false, false, false, eGameRule_PlayerTurnBegin);
	DamageEffect.AbilityNames.AddItem( 'GrenadeFuse');
	DamageEffect.AbilityNames.AddItem( 'RocketFuse');
	DamageEffect.AbilityNames.AddItem( 'MicroMissleFuse');
	DamageEffect.Bonus = default.Fuse_BonusMult;
	DamageEffect.DuplicateResponse=eDupe_Refresh;
	//DamageEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.PostActivationEvents.AddItem(default.MZFuseEventName);
	//Template.PostActivationEvents.AddItem(default.MZFusePostEventName);

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_MZPsi_SelfCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.TargetingMethod = class'X2TargetingMethod_Fuse';
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.DamagePreviewFn = MZFuseDamagePreview;
	
//BEGIN AUTOGENERATED CODE: Template Overrides 'Fuse'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Fuse'

	return Template;
}

function bool MZFuseDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameStateHistory History;
	local XComGameState_Ability FuseTargetAbility;
	local XComGameState_Unit TargetUnit;
	local StateObjectReference EmptyRef, FuseRef;

	History = `XCOMHISTORY;
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	if (TargetUnit != none)
	{
		if (class'X2Condition_FuseTarget'.static.GetAvailableFuse(TargetUnit, FuseRef))
		{
			FuseTargetAbility = XComGameState_Ability(History.GetGameStateForObjectID(FuseRef.ObjectID));
			if (FuseTargetAbility != None)
			{
				//  pass an empty ref because we assume the ability will use multi target effects.
				FuseTargetAbility.GetDamagePreview(EmptyRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
				return true;
			}
		}
	}
	return false;
}

static function X2AbilityTemplate AddPanaceaAbility()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_GrantActionPoints	ActionPointEffect;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local MZ_Effect_PsiHeal		HealEffect;
	local X2Effect_RemoveEffects                MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects                MindControlRemovalEffect;
	local X2Condition_UnitProperty              EnemyCondition;
	local X2Condition_UnitProperty              FriendCondition;
	local X2AbilityCharges				Charges;
	local X2AbilityCost_Charges			ChargeCost;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPanacea');

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Item_Nanomedikit";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Always;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Panacea_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.Panacea_Charges;
	Charges.AddBonusCharge('MZHealersMind', default.Healer_Panacea_BonusCharges);
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//possible it might result in wierd shit when used on a completely dead soldier.
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeDead=false;
	TargetCondition.ExcludeAlive=false;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = false;
	TargetCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	
	Template.AddTargetEffect(RemoveAdditionalEffectsForPanacea());
	//Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints');
	Template.AddTargetEffect(RemoveAllEffectsByDamageType());

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = default.Panacea_APHeal;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);
	
	HealEffect = new class'MZ_Effect_PsiHeal';
	HealEffect.PerUseHP = default.Panacea_PerUseHP;
	HealEffect.HealSpread = default.Panacea_Spread;
	HealEffect.PsiFactor = default.Panacea_PsiFactor;
	Template.AddTargetEffect(HealEffect);
	
	//This is basically Solace woo.
	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MentalEffectRemovalEffect.DamageTypes.Length = 0;		//	don't let an immunity to "mental" effects resist this cleanse
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(MentalEffectRemovalEffect);

	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	Template.AddTargetEffect(MindControlRemovalEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'HealingAlly';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2Effect_RemoveEffectsByDamageType RemoveAllEffectsByDamageType()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffectTypes;
	local name HealType;

	RemoveEffectTypes = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffectTypes.DamageTypesToRemove.AddItem(HealType);
	}
	return RemoveEffectTypes;
}

static function X2Effect_RemoveEffects RemoveAdditionalEffectsForPanacea()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;
	local name HealType;

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ObsessedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BerserkName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ShatteredName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability_Viper'.default.BindSustainedEffectName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);

	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}

	return RemoveEffects;
}

static function X2AbilityTemplate AddMindSootheAbility()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_RemoveEffects                MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects                MindControlRemovalEffect;
	local X2Condition_UnitProperty              EnemyCondition;
	local X2Condition_UnitProperty              FriendCondition;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMindSoothe');

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_emphaticprojection";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Always;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MindSoothe_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = false;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = false;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeUnableToAct = false;
	TargetCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_MindSoothe');

	//This is basically Solace woo
	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MentalEffectRemovalEffect.DamageTypes.Length = 0;		//	don't let an immunity to "mental" effects resist this cleanse
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(MentalEffectRemovalEffect);

	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	Template.AddTargetEffect(MindControlRemovalEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}

static function X2AbilityTemplate AddPsiPanicAbility()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2Effect_Panicked             PanicEffect;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage    RuptureEffect;
	local X2Condition_AbilityProperty   SchismCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPsiPanic');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PsiPanic_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
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

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  Panic effect
	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 1;
	PanicEffect.MaxStatContestResult = 0;
	PanicEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(PanicEffect);

	//  Rupture effect if the caster has Schism
	RuptureEffect = new class'X2Effect_ApplyWeaponDamage';
	RuptureEffect.EffectDamageValue = default.Schism_Damage;
	RuptureEffect.MinStatContestResult = 1;
	RuptureEffect.MaxStatContestResult = 0;
	RuptureEffect.bIgnoreArmor = true;
	RuptureEffect.bIgnoreBaseDamage = true;
	SchismCondition = new class'X2Condition_AbilityProperty';
	SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
	RuptureEffect.TargetConditions.AddItem(SchismCondition);
	Template.AddTargetEffect(RuptureEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Stupor";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	Template.ActivationSpeech = 'Insanity';

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.ConcealmentRule = eConceal_Always;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Insanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Insanity'
	
	return Template;
}

//Betrayal Ends at the end of your turn, but the victim can act immediatly for you.
static function X2AbilityTemplate AddBetrayalAbility()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	local X2Effect_GrantActionPoints	ActionPointEffect;
	local X2Effect_Persistent			ActionPointPersistEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBetrayal');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mindscorch";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Betrayal_Cooldown;
	Cooldown.bDoNotApplyOnHit = false;
	Template.AbilityCooldown = Cooldown;
	
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
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(0, false, false);
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	
	//Give Action Points, so it can act right away
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = default.Betrayal_APHeal;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);

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

static function X2AbilityTemplate AddMindControlAbility()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMindControl');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psi_mindcontrol";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MindControl_Cooldown;
	Cooldown.bDoNotApplyOnHit = false;
	Template.AbilityCooldown = Cooldown;
	
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
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.MindControl_Duration, false, false);
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

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

static function X2AbilityTemplate AddProtectionAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_RemoveEffects            RemoveEffects;
	local X2Condition_UnitProperty			TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZProtection');

	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stasisshield";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Protection_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = false;
	TargetCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability_Viper'.default.BindSustainedEffectName);
	Template.AddTargetEffect(RemoveEffects);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;          //  probably shouldn't be possible for them to die while in stasis, but just in case
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	Template.AddTargetEffect(StasisEffect);

	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
		
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_MZPsi_SelfCast';
	Template.ActivationSpeech = 'NullShield';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Stasis_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Stasis'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Stasis'

	return Template;
}
function Stasis_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Effect RemovedEffect;
	local VisualizationActionMetadata ActionMetadata, EmptyTrack;

	TypicalAbility_BuildVisualization(VisualizeGameState);
	History = `XCOMHISTORY;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', RemovedEffect)
	{
		if (RemovedEffect.bRemoved)
		{
			ActionMetadata = EmptyTrack;
			ActionMetadata.VisualizeActor = History.GetVisualizer(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID, , VisualizeGameState.HistoryIndex -1);
			ActionMetadata.StateObject_NewState = History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);

			RemovedEffect.GetX2Effect().AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, ActionMetadata, 'AA_Success', RemovedEffect);
		}
	}
}

static function X2AbilityTemplate AddKineticLanceAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Effect_Knockback				KnockbackEffect;
	local MZ_Aim_PsiAttack					AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKineticLance');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.CustomFireAnim = 'FF_MZPsi_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KineticLance_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.KineticLance_Range;
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
	DamageEffect.DamageTag = 'MZKineticLance';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);
	
	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.KineticLance_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddMultiTargetEffect(KnockbackEffect);

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

static function X2AbilityTemplate AddPsiBlindAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Effect_Blind					BlindEffect;
	local X2Effect_PersistentStatChange        	DisorientedEffect;
	local X2Effect_ApplyWeaponDamage    RuptureEffect;
	local X2Condition_AbilityProperty   SchismCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPsiBlind');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PsiBlind_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeTurret = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.PsiBlind_BlindTurns, default.PsiBlind_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.PsiBlind_VisionMult, MODOP_PostMultiplication);
	Template.AddTargetEffect(BlindEffect);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = default.PsiBlind_Disorient;     
	DisorientedEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(DisorientedEffect);

	//  Rupture effect if the caster has Schism
	RuptureEffect = new class'X2Effect_ApplyWeaponDamage';
	RuptureEffect.EffectDamageValue = default.Schism_Damage;
	RuptureEffect.MinStatContestResult = 1;
	RuptureEffect.MaxStatContestResult = 0;
	RuptureEffect.bIgnoreArmor = true;
	RuptureEffect.bIgnoreBaseDamage = true;
	SchismCondition = new class'X2Condition_AbilityProperty';
	SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
	RuptureEffect.TargetConditions.AddItem(SchismCondition);
	Template.AddTargetEffect(RuptureEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Always;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

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

static function X2AbilityTemplate AddPsiHeal()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityCost_Charges             ChargeCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_PsiHeal		        MedikitHeal;
	local X2AbilityCharges				Charges;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPsiHeal');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.PsiHeal_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_revive";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PsiHeal_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.PsiHeal_Charges;
	Charges.AddBonusCharge('MZHealersMind', default.Healer_PsiHeal_BonusCharges);
	Template.AbilityCharges = Charges;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.PsiHeal_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.PsiHeal_PerUseHP;
	MedikitHeal.HealSpread = default.PsiHeal_Spread;
	MedikitHeal.PsiFactor = default.PsiHeal_PsiFactor;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(RemoveAllEffectsByDamageType());

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);
	
	Template.ActivationSpeech = 'HealingAlly';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	Template.ConcealmentRule = eConceal_Always;

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2AbilityTemplate AddRestoreLife()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown             Cooldown;
	local MZ_Effect_PsiHeal		        MedikitHeal;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Effect_RemoveEffects            RemoveEffects;
	local X2Effect_TriggerEvent             InsanityEvent;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRestoreLife');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.RestoreLife_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

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

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RestoreLife_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	//UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.IsBleedingOut = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.RestoreLife_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Remove Bleedout
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	Template.AddTargetEffect(RemoveEffects);
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true));

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'MZRestoreLifeChaser';
	InsanityEvent.ApplyChance = 100;
	Template.AddTargetEffect(InsanityEvent);

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.RestoreLife_PerUseHP;
	MedikitHeal.HealSpread = default.RestoreLife_Spread;
	MedikitHeal.PsiFactor = default.RestoreLife_PsiFactor;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(RemoveAllEffectsByDamageType());

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'StabilizingAlly';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
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
static function X2AbilityTemplate AddRestoreLifeChaser()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRestoreLifeChaser');
	
	Template.AbilityToHitCalc = default.deadeye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MZRestoreLifeChaser';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAdditionalEffectsForRevivalProtocolAndRestorativeMist());

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_insanity";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Defensive;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'VoidRiftInsanity'

	return Template;
}

static function X2AbilityTemplate AddRayOfLife()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_PsiHeal		        MedikitHeal;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges      Charges;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRayOfLife');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.CustomFireAnim = 'FF_MZPsi_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;   // Updated 8/18/15 to 1 action point only per Jake request.  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RayOfLife_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.RayOfLife_Charges;
	Charges.AddBonusCharge('MZHealersMind', default.Healer_RayOfLife_BonusCharges);
	Template.AbilityCharges = Charges;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.RayOfLife_Range;
	Template.AbilityTargetStyle = CursorTarget;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.RayOfLife_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityMultiTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.RayOfLife_PerUseHP;
	MedikitHeal.HealSpread = default.RayOfLife_Spread;
	MedikitHeal.PsiFactor = default.RayOfLife_PsiFactor;
	Template.AddMultiTargetEffect(MedikitHeal);

	Template.AddMultiTargetEffect(RemoveAllEffectsByDamageType());

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Line';
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActivationSpeech = 'HealingAlly';

	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'NullLance'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'NullLance'

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2AbilityTemplate AddTurnUndead()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTurnUndead');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Template.AbilityToHitCalc = new class'MZ_Aim_PsiAttack';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_TurnUndead');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZTurnUndead';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = false;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "acd373";
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

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
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate AddMagnusExorcismus()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;
	local MZ_Aim_PsiAttack					AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMagnusExorcismus');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Magnus_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Magnus_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Magnus_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.MZDisableDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZTurnUndead';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.TargetConditions.AddItem(new class'MZ_Condition_TurnUndead');
	Template.AddMultiTargetEffect(DamageEffect);

	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndMZDisableDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "acd373";
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.AdditionalAbilities.AddItem('MZDisableEndDurationFX');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

static function X2AbilityTemplate AddRayzeelSong()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTrigger_EventListener EventListener;
	local MZ_Effect_PsiHeal				MedikitHeal;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;			

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRayzeelSong');
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'MZRayzeelSong';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Priority = 30; //low to let most other stuff resolve first.
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityTargetConditions.Length = 0;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.Rayzeel_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityMultiTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.Rayzeel_PerUseHP;
	MedikitHeal.HealSpread = default.Rayzeel_Spread;
	MedikitHeal.PsiFactor = default.Rayzeel_PsiFactor;
	Template.AddTargetEffect(MedikitHeal);
	Template.AddMultiTargetEffect(MedikitHeal);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flight";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate AddManuForti()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local MZ_Effect_ManuForti			MightEffect;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local X2Effect_ManualOverride				ChronoEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZManuForti');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.ManuForti_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_holywarrior";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ManuForti_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.ManuForti_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	MightEffect = new class'MZ_Effect_ManuForti';
	MightEffect.EffectName = 'ManuForti';
	MightEffect.BaseMult = default.ManuForti_BaseMult;
	MightEffect.PsiMult = default.ManuForti_PsiMult;
	MightEffect.BuildPersistentEffect( default.ManuForti_Duration, false, true, false, eGameRule_PlayerTurnBegin );
	MightEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ManuFortiEffectDesc, Template.IconImage, true);
	MightEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(MightEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( default.ManuForti_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}

static function X2AbilityTemplate AddTransmitPrana()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_GrantActionPoints	ActionPointEffect;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2Effect_ManualOverride		ChronoEffect;
	local X2Condition_AbilityProperty	AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTransmitPrana');

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_combatpresence";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.TransmitPrana_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd);
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}

static function X2AbilityTemplate AddAuroraWave()
{
	local X2AbilityTemplate					Template;
	local Grimy_Cost_ActionPoints			ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_RemoveEffects            MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects            MindControlRemovalEffect;
	local X2Condition_UnitProperty          EnemyCondition;
	local X2Condition_UnitProperty          FriendCondition;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local MZ_Effect_ManuForti				MightEffect;
	local X2Effect_Persistent				ActionPointPersistEffect;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local MZ_Effect_AmorFati				AmorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAuroraWave');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.AuroraWave_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psi_inspiration";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Always;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	//If you have congregation, also gives the free mind merge
	ActionPointCost.BonusPoint = 'MZCongregation';
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AuroraWave_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = false;
	TargetCondition.ExcludeTurret = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.AuroraWave_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);
	
	//This is basically Solace woo.
	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	Template.AddMultiTargetEffect(MindControlRemovalEffect);

	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MentalEffectRemovalEffect.DamageTypes.Length = 0;		//	don't let an immunity to "mental" effects resist this cleanse
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddMultiTargetEffect(MentalEffectRemovalEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	//Manu Forti Effect
	MightEffect = new class'MZ_Effect_ManuForti';
	MightEffect.EffectName = 'ManuForti';
	MightEffect.BaseMult = default.ManuForti_BaseMult;
	MightEffect.PsiMult = default.ManuForti_PsiMult;
	MightEffect.BuildPersistentEffect( default.AuroraWave_Duration, false, true, false, eGameRule_PlayerTurnBegin );
	MightEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ManuFortiEffectDesc, Template.IconImage, true);
	MightEffect.bRemoveWhenTargetDies = true;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZManuForti');
	MightEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(MightEffect);

	//Amor Fati Effect
	AmorEffect = new class'MZ_Effect_AmorFati';
	AmorEffect.EffectName = 'AmorFati';
	AmorEffect.BonusMult = default.AmorFati_BonusMult;
	AmorEffect.PsiMult = default.AmorFati_PsiMult;
	AmorEffect.AimMod = default.AmorFati_AimMod;
	AmorEffect.BuildPersistentEffect( default.AuroraWave_Duration, false, true, false, eGameRule_PlayerTurnBegin );
	AmorEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.AmorFatiEffectDesc, Template.IconImage, true);
	AmorEffect.bRemoveWhenTargetDies = true;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAmorFati');
	AmorEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(AmorEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( default.AuroraWave_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddMultiTargetEffect(ActionPointPersistEffect);
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_MZPsi_SelfCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2DataTemplate CreateMindMerge(int MobilityChange, int AimChange, int CritChange)
{
	local X2AbilityTemplate					Template;
	local Grimy_Cost_ActionPoints			ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local MZ_Effect_PsiBoostedStatChange		HolyWarriorEffect;
	local X2Condition_UnitEffects			ExcludeEffectsCondition;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMindMerge');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_mindmerge";
	Template.Hostility = eHostility_Defensive;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = 301;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('MZMindMerge2');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.MindMerge_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	Template.AdditionalAbilities.AddItem('MZPriestRemoved');

	ActionPointCost = new class'Grimy_Cost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.BonusPoint = 'MZCongregation';
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MindMerge_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();	// Discuss with Jake/Design what exclusions are allowed here

	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_AbilityUnavailable');
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlling');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	// Target Conditions
	//

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.MindMerge_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect('MindMergeEffect', 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	HolyWarriorEffect = new class'MZ_Effect_PsiBoostedStatChange';
	HolyWarriorEffect.EffectName = 'MindMergeEffect';
	HolyWarriorEffect.DuplicateResponse = eDupe_Ignore;
	HolyWarriorEffect.BuildPersistentEffect(default.MindMerge_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Mobility, MobilityChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Offense, AimChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_CritChance, CritChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_PsiOffense, default.MindMerge_Psi);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Hacking, default.MindMerge_Hack);
	//using default scaling for now
	//HolyWarriorEffect.PreScalarAdjust=0
	//HolyWarriorEffect.PostScalarAdjust=0
	//HolyWarriorEffect.PsiFactor=2
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.bFrameEvenWhenUnitIsHidden = true;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.bShowActivation = true;

	//	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2DataTemplate CreatePriestRemoved()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener, DeathEventListener;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveEffects RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPriestRemoved');
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// This ability fires when the unit dies
	DeathEventListener = new class'X2AbilityTrigger_EventListener';
	DeathEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DeathEventListener.ListenerData.EventID = 'UnitDied';
	DeathEventListener.ListenerData.Filter = eFilter_Unit;
	DeathEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfWithAdditionalTargets;
	Template.AbilityTriggers.AddItem(DeathEventListener);

	//	Trigger if the source is removed from play (e.g. evacs)
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitRemovedFromPlay';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfIgnoreCache;
	EventListener.ListenerData.Priority = 75;	// We need this to happen before the unit is actually removed from play
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect('MindMergeEffect', 'AA_UnitIsImmune');
	Template.AbilityMultiTargetConditions.AddItem(TargetEffectCondition);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('MindMergeEffect');
	Template.AddMultiTargetEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

static function X2DataTemplate CreateMindMerge2(int MobilityChange, int AimChange, int CritChange)
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local MZ_Effect_PsiBoostedStatChange		HolyWarriorEffect;
	local X2Condition_UnitEffects				ExcludeEffectsCondition;
	local X2Effect_ManualOverride				ChronoEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2AbilityPassiveAOE_WeaponRadius		PassiveRadius;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMindMerge2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_mindmerge";
	Template.Hostility = eHostility_Defensive;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = 301;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.MindMerge_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('MZCongregation');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();	// Discuss with Jake/Design what exclusions are allowed here

	// Target Conditions
	//

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.WithinRange = default.MindMerge_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect('MindMergeEffect', 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Ability_AdvPriest'.default.HolyWarriorEffectName, 'AA_DuplicateEffectIgnored');
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(ExcludeEffectsCondition);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	HolyWarriorEffect = new class'MZ_Effect_PsiBoostedStatChange';
	HolyWarriorEffect.EffectName = 'MindMergeEffect';
	HolyWarriorEffect.DuplicateResponse = eDupe_Ignore;
	HolyWarriorEffect.BuildPersistentEffect(default.MindMerge_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Mobility, MobilityChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Offense, AimChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_CritChance, CritChange);
	HolyWarriorEffect.AddPersistentStatChange(eStat_PsiOffense, default.MindMerge_Psi);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Hacking, default.MindMerge_Hack);
	//using default scaling for now
	//HolyWarriorEffect.PreScalarAdjust=0
	//HolyWarriorEffect.PostScalarAdjust=0
	//HolyWarriorEffect.PsiFactor=2
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CustomFireAnim = 'HL_MZPsi_MindControl';
	Template.bFrameEvenWhenUnitIsHidden = true;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.bShowActivation = true;

	return Template;
}

static function X2DataTemplate CreateCongregation()
{
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZCongregation', "img:///UILibrary_PerkIcons.UIPerk_mindmerge2");
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.PrerequisiteAbilities.AddItem('MZMindMerge');
	Template.AdditionalAbilities.AddItem('MZMindMerge2');

	return Template;
}

static function X2AbilityTemplate AddAmorFati()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local MZ_Effect_AmorFati			MightEffect;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local X2Effect_ManualOverride				ChronoEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAmorFati');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.AmorFati_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_divinearmor";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AmorFati_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.AmorFati_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	MightEffect = new class'MZ_Effect_AmorFati';
	MightEffect.EffectName = 'AmorFati';
	MightEffect.BonusMult = default.AmorFati_BonusMult;
	MightEffect.PsiMult = default.AmorFati_PsiMult;
	MightEffect.AimMod = default.AmorFati_AimMod;
	MightEffect.BuildPersistentEffect( default.AmorFati_Duration, false, true, false, eGameRule_PlayerTurnBegin );
	MightEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.AmorFatiEffectDesc, Template.IconImage, true);
	MightEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(MightEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( default.AmorFati_Duration, false, true, false, eGameRule_PlayerTurnBegin);
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.ActivationSpeech = 'Inspire';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}

static function X2AbilityTemplate AddZombifyAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Effect_ApplyWeaponDamage    RuptureEffect;
	local X2Condition_AbilityProperty   SchismCondition;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZZombify');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Zombify_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeTurret = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = false;
	TargetProperty.ExcludeCosmetic = true;
	TargetProperty.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Poison');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	Template.AddTargetEffect(class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.Zombify_Turns));
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	//  Rupture effect if the caster has Schism
	RuptureEffect = new class'X2Effect_ApplyWeaponDamage';
	RuptureEffect.EffectDamageValue = default.Schism_Damage;
	RuptureEffect.MinStatContestResult = 1;
	RuptureEffect.MaxStatContestResult = 0;
	RuptureEffect.bIgnoreArmor = true;
	RuptureEffect.bIgnoreBaseDamage = true;
	SchismCondition = new class'X2Condition_AbilityProperty';
	SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
	RuptureEffect.TargetConditions.AddItem(SchismCondition);
	Template.AddTargetEffect(RuptureEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

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

static function X2AbilityTemplate AddHaltUndead()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;
	local MZ_Aim_PsiAttack					AimType;
	local X2Effect_Stunned					StunEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHaltUndead');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HaltUndead_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.HaltUndead_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.HaltUndead_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.MZDisableDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.HaltUndead_Stun, 100, false);
	StunEffect.TargetConditions.AddItem(new class'MZ_Condition_TurnUndead');
	StunEffect.DamageTypes.Length=0;
	StunEffect.DamageTypes.AddItem('Psi');
	Template.AddMultiTargetEffect(StunEffect);

	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndMZDisableDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventpsiwitch_dimensionrift";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "acd373";
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.AdditionalAbilities.AddItem('MZDisableEndDurationFX');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddDeadExplosion()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local MZ_Aim_PsiAttack				StatCheck;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2Effect_ApplyFireToWorld		WorldEffect;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDeadExplosion');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DeadExplode_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'MZ_Aim_PsiAttack';
	StatCheck.bOnlyMultiHitWithSuccess = true;
	Template.AbilityToHitCalc = StatCheck;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.DeadExplode_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_TurnUndead');

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZCremation';
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.DeadExplode_BurnDamage, default.DeadExplode_BurnSpread));
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.DeadExplode_BurnDamage, default.DeadExplode_BurnSpread));

	WorldEffect = new class'X2Effect_ApplyFireToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_biggestbooms";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "acd373";
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.LostSpawnIncreasePerUse = 50; //like a rocket launcher

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate AddControlUndead()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
	local X2Condition_UnitType			UnitTypeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZControlUndead');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "acd373";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ControlDead_Cooldown;
	Cooldown.bDoNotApplyOnHit = false;
	Template.AbilityCooldown = Cooldown;
	
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
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.ExcludeLargeUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'MZ_Condition_TurnUndead');

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenAssassin');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenWarlock');
	UnitTypeCondition.ExcludeTypes.AddItem('ChosenSniper');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Psi');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.ControlDead_Duration, false, false);
	MindControlEffect.DamageTypes.Length = 0;
	MindControlEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

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

static function X2AbilityTemplate AddCurseLureAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage    RuptureEffect;
	local X2Condition_AbilityProperty   SchismCondition;
	local X2Effect_Persistent			LureEffect;
	local X2Condition_UnitType			UnitTypeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCurseLure');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CurseLure_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = new class'MZ_Aim_PsiAttack';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = false;
	TargetProperty.ExcludeTurret = false;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = false;
	TargetProperty.ExcludeCosmetic = true;
	TargetProperty.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	UnitTypeCondition.ExcludeTypes.AddItem('BioLost');
	UnitTypeCondition.ExcludeTypes.AddItem('PsiZombie');
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

	Template.AddTargetEffect(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	LureEffect = class'X2StatusEffects'.static.CreateUltrasonicLureTargetStatusEffect();
	LureEffect.iNumTurns = default.CurseLure_Turns;
	Template.AddTargetEffect(LureEffect);
	Template.AddTargetEffect(new class'X2Effect_AlertTheLost');

	//  Rupture effect if the caster has Schism
	RuptureEffect = new class'X2Effect_ApplyWeaponDamage';
	RuptureEffect.EffectDamageValue = default.Schism_Damage;
	RuptureEffect.bIgnoreArmor = true;
	RuptureEffect.bIgnoreBaseDamage = true;
	SchismCondition = new class'X2Condition_AbilityProperty';
	SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
	RuptureEffect.TargetConditions.AddItem(SchismCondition);
	Template.AddTargetEffect(RuptureEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.LostSpawnIncreasePerUse = 10000; //stupid high. should always trigger if possible.

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate AddMachinaPuppeteer()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit		StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMachinaPuppeteer');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_haywireprotocol";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MachinaPuppeteer_Cooldown;
	Cooldown.bDoNotApplyOnHit = false;
	Template.AbilityCooldown = Cooldown;
	
	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	StatCheck.AttackerStat = eStat_PsiOffense;
	StatCheck.DefenderStat = eStat_HackDefense;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeTurret = false;
	UnitPropertyCondition.ExcludeLargeUnits = false;
	UnitPropertyCondition.ExcludeOrganic = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Psi');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(default.MachinaPuppeteer_Duration, false, false);
	MindControlEffect.DamageTypes.Length = 0;
	MindControlEffect.DamageTypes.AddItem('Psi');
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

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

static function X2AbilityTemplate AddFireball()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Aim_PsiAttack					AimType;
	local X2Effect_ApplyFireToWorld			WorldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFireball');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Fireball_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Fireball_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Fireball_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZFireball';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.Fireball_BurnDamage, default.Fireball_BurnSpread));

	WorldEffect = new class'X2Effect_ApplyFireToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_torch";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 50;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate AddKineticPushAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2AbilityCooldown                 Cooldown;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local MZ_Aim_PsiAttack					AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKineticPush');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KineticPush_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeTurret = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('KnockbackDamage');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.KineticPush_Knockback;
	KnockbackEffect.OnlyOnDeath = false; 
	Template.AddTargetEffect(KnockbackEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Neutral;
	Template.ConcealmentRule = eConceal_Always;

	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_StunStrike";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

	Template.ActivationSpeech = 'StunStrike';
	//Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate FireWhip()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFireWhip');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FireWhip_Cooldown;
	Template.AbilityCooldown = Cooldown;

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

	Template.AddTargetEffect(new class'MZ_Effect_DisableWeapon');
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Grenade_Fire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.CustomFireKillAnim = 'FF_MZPsi_MindControl';

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

static function X2AbilityTemplate ShiningAir()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_Blind					BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShiningAir');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShiningAir_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Psi');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZShiningAir';
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.ShiningAir_BlindTurns, default.ShiningAir_VisionMult);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.ShiningAir_VisionMult, MODOP_PostMultiplication);
	Template.AddTargetEffect(BlindEffect);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.CustomFireKillAnim = 'FF_MZPsi_MindControl';

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

static function X2AbilityTemplate EvilGaze()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZEvilGaze');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.EvilGaze_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Acid');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZEvilGaze';
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePanickedStatusEffect());
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;
	
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Dazzle";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.CustomFireKillAnim = 'FF_MZPsi_MindControl';

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

static function X2AbilityTemplate BoulderCrush()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBoulderCrush');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BoulderCrush_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Heavy');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZBoulderCrush';
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.BoulderCrush_Stun, 100, false));
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Grenade_EMP";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.CustomFireKillAnim = 'FF_MZPsi_MindControl';

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

static function X2AbilityTemplate ThunderousRoar()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Effect_NeuralFeedbackCoolPsi	CoolPsiEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZThunderousRoar');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ThunderousRoar_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Electrical');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZThunderousRoar';
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	//Silence!
	CoolPsiEffect = new class'MZ_Effect_NeuralFeedbackCoolPsi';
	CoolPsiEffect.EffectAppliedName = default.ThunderousRoarSilenceEffectName;
	Template.AddTargetEffect(CoolPsiEffect);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Grenade_EMP";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.CustomFireKillAnim = 'FF_MZPsi_MindControl';

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

static function X2AbilityTemplate EarthHeal()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityCost_Charges             ChargeCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_PsiHeal		        MedikitHeal;
	local X2AbilityCharges				Charges;
	local X2AbilityPassiveAOE_WeaponRadius	PassiveRadius;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_Persistent				UnconcEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_Regeneration				RegenerationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZEarthHeal');

	PassiveRadius= new class'X2AbilityPassiveAOE_WeaponRadius';
	PassiveRadius.fTargetRadius=default.PsiHeal_Range * 1.5;
	Template.AbilityPassiveAOEStyle = PassiveRadius;

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Regeneration";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.EarthHeal_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.SharedAbilityCharges.AddItem('MZWhiteFlame');
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.EarthHeal_Charges;
	Charges.AddBonusCharge('MZHealersMind', default.Healer_EarthHeal_BonusCharges);
	Charges.AddBonusCharge('MZWhiteFlame', default.WhiteFlame_Charges);
	Template.AbilityCharges = Charges;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.WithinRange = default.PsiHeal_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead units. (want to stabilize if they're bleeding out)
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.EarthHeal_PerUseHP;
	MedikitHeal.HealSpread = default.EarthHeal_Spread;
	MedikitHeal.PsiFactor = default.EarthHeal_PsiFactor;
	Template.AddTargetEffect(MedikitHeal);

	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(default.EarthHeal_RegenTurns, false, false, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.DuplicateResponse = eDupe_Refresh;
	RegenerationEffect.bRemoveWhenTargetDies = true;
	RegenerationEffect.HealAmount = default.EarthHeal_RegenRate;
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	RegenerationEffect.EffectName = 'MZEarthHealRegen';
	Template.AddTargetEffect( RegenerationEffect );

	UnconcEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddRequireEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	UnconcEffect.TargetConditions.AddItem(UnitEffectsCondition);
	Template.AddTargetEffect(UnconcEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	RemoveEffects.TargetConditions.AddItem(UnitEffectsCondition);
	Template.AddTargetEffect(RemoveEffects);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);
	
	Template.ActivationSpeech = 'HealingAlly';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	Template.ConcealmentRule = eConceal_Always;

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2AbilityTemplate WhiteFlame()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local MZ_Effect_PsiHeal					MedikitHeal;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges					Charges;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_Regeneration				RegenerationEffect;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZWhiteFlame');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Refresh";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.CustomFireAnim = 'FF_MZPsi_MindControl';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;   // Updated 8/18/15 to 1 action point only per Jake request.  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.WhiteFlame_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 2;
	ChargeCost.SharedAbilityCharges.AddItem('MZEarthHeal');
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.WhiteFlame_Charges;
	Charges.AddBonusCharge('MZHealersMind', default.Healer_EarthHeal_BonusCharges);
	Charges.AddBonusCharge('MZEarthHeal', default.EarthHeal_Charges);
	Template.AbilityCharges = Charges;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.WhiteFlame_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.WhiteFlame_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityMultiTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityMultiTargetConditions.AddItem(UnitEffectsCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

	//Heal effects
	MedikitHeal = new class'MZ_Effect_PsiHeal';
	MedikitHeal.PerUseHP = default.WhiteFlame_PerUseHP;
	MedikitHeal.HealSpread = default.WhiteFlame_Spread;
	MedikitHeal.PsiFactor = default.WhiteFlame_PsiFactor;
	Template.AddMultiTargetEffect(MedikitHeal);

	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(default.WhiteFlame_RegenTurns, false, false, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.DuplicateResponse = eDupe_Refresh;
	RegenerationEffect.bRemoveWhenTargetDies = true;
	RegenerationEffect.HealAmount = default.WhiteFlame_RegenRate;
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	RegenerationEffect.EffectName = 'MZWhiteFlameRegen';
	Template.AddMultiTargetEffect( RegenerationEffect );

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ObsessedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BerserkName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ShatteredName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.BlindedName);
	RemoveEffects.DamageTypesToRemove.AddItem('mental');
	RemoveEffects.DamageTypesToRemove.AddItem('psi');
	Template.AddTargetEffect(RemoveEffects);

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(ChronoEffect);

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActivationSpeech = 'HealingAlly';

	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'NullLance'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'NullLance'

	Template.PostActivationEvents.AddItem('MZRayzeelSong');

	return Template;
}

static function X2AbilityTemplate PsiBreath(name TemplateName, name FireAnimName, string IconImage, int iCooldown)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local MZ_Aim_PsiAttack					AimType;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if ( iCooldown > 0 )
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = iCooldown;
		Template.AbilityCooldown = Cooldown;
	}
	
	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.PsiBreath_Length;
	Template.AbilityTargetStyle = CursorTarget;
	
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.PsiBreath_Width * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.PsiBreath_Length * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = 330;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.CustomFireAnim = FireAnimName;
	Template.ActionFireClass = class'X2Action_Fire_Flamethrower';

	Template.ActivationSpeech = 'Nulllance';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;	

	return Template;	
}

static function X2AbilityTemplate BurningHands()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage	        WeaponDamageEffect;

	Template = PsiBreath( 'MZBurningHands', 'FF_MZFireDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_torch", default.PsiBreath_Cooldown);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZBurningHands';
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1) );

	return Template;
}

static function X2AbilityTemplate FetidBreath()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	Template = PsiBreath( 'MZFetidBreath', 'FF_MZPoisonDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit", default.PsiBreath_Cooldown);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZFetidBreath';
	WeaponDamageEffect.DamageTypes.AddItem('poison');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreatePoisonedStatusEffect() );

	Template.AddMultiTargetEffect(class'MZ_Effect_Zombify'.static.CreateZombifyEffect(default.Zombify_Turns));

	return Template;
}

static function X2AbilityTemplate AcidSpray()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	Template = PsiBreath( 'MZAcidSpray', 'FF_MZAcidDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", default.PsiBreath_Cooldown);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'MZAcidSpray';
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.AddMultiTargetEffect( class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(3,1) );

	return Template;
}

static function X2AbilityTemplate StormBreath()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	Template = PsiBreath( 'MZStormBreath', 'FF_MZThunderDragonBreath', "img:///UILibrary_PerkIcons.UIPerk_electro_pulse", default.PsiBreath_Cooldown);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	WeaponDamageEffect.DamageTag = 'MZStormBreath';
	WeaponDamageEffect.DamageTypes.AddItem('electrical');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	return Template;
}

static function X2AbilityTemplate SearingLance()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Aim_PsiAttack					AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZSearingLance');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.CustomFireAnim = 'FF_MZPsi_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SearingLance_Cooldown;
	Template.AbilityCooldown = Cooldown;

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
	WeaponDamageEffect.DamageTag = 'MZSearingLance';
	WeaponDamageEffect.DamageTypes.AddItem('fire');
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2,1));

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

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

static function X2AbilityTemplate AcidBall()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Aim_PsiAttack					AimType;
	local X2Effect_ApplyAcidToWorld			WorldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAcidBall');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Acidball_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Fireball_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Acidball_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZAcidball';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(default.Acidball_BurnDamage, default.Acidball_BurnSpread));

	WorldEffect = new class'X2Effect_ApplyAcidToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 50;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate PoisonBall()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local MZ_Aim_PsiAttack					AimType;
	local X2Effect_ApplyPoisonToWorld			WorldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPoisonBall');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Poisonball_Cooldown;
	Template.AbilityCooldown = Cooldown;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bMultiTargetOnly = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.Poisonball_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.Poisonball_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'MZPoisonball';
	DamageEffect.bIgnoreArmor = false;
	DamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	WorldEffect = new class'X2Effect_ApplyPoisonToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.AddMultiTargetEffect(WorldEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = 340;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = true;
	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';

	Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';

	Template.ActivationSpeech = 'MindBlast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.LostSpawnIncreasePerUse = 50;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate CausticLance()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local MZ_Aim_PsiAttack					AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCausticLance');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.CustomFireAnim = 'FF_MZPsi_LanceCast';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CausticLance_Cooldown;
	Template.AbilityCooldown = Cooldown;

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
	WeaponDamageEffect.DamageTag = 'MZCausticLance';
	WeaponDamageEffect.DamageTypes.AddItem('acid');
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(4,1));

	Template.AddMultiTargetEffect(new class'X2Effect_ApplyAcidToWorld');

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

static function X2AbilityTemplate HellishRebuke()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;
	local MZ_Aim_PsiAttack						AimType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHellishRebuke');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	AimType = new class'MZ_Aim_PsiAttack';
	AimType.bReactionFire = true;
	AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = AimType;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	FireEffect.AbilityToActivate = 'MZHellishRebukeAttack';
	FireEffect.bPreEmptiveFire = false;
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	Template.AdditionalAbilities.AddItem('MZHellishRebukeAttack');

	return Template;
}
static function X2AbilityTemplate HellishRebukeAttack()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints        ReserveActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTrigger_EventListener	Trigger;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHellishRebukeAttack');

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.ReturnFireActionPoint);
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
	WeaponDamageEffect.DamageTag = 'MZHellishRebuke';
	WeaponDamageEffect.bBypassShields = false;
	WeaponDamageEffect.bIgnoreArmor = false;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(3,1));
		
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

	Template.CustomFireAnim = 'FF_MZPsi_RHandCast';
	Template.CustomFireKillAnim = 'FF_MZPsi_RHandCast';

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

static function X2AbilityTemplate PhantasmalPrison()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local MZ_Effect_VoidPrison				PersistentEffect;
	//local X2Effect_VoidConduit				TickEffect;
	local X2Condition_UnitEffects			EffectCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPhantasmalPrison');

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZPsi_GhostCast';
	Template.CustomFireKillAnim = 'FF_MZPsi_GhostCast';
	Template.ActivationSpeech = 'VoidConduit';
	Template.CinescriptCameraType = "Templar_VoidConduit";
//END AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_VoidConduit";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PhantasmalPrison_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// block having more than one conduit ability active at a time.
	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

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

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//	don't allow a target to be affected by this more than one at a time
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	//	build the persistent effect
	PersistentEffect = new class'MZ_Effect_VoidPrison';
	PersistentEffect.InitialDamage = 0;
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	PersistentEffect.bRemoveWhenTargetDies = true;
	PersistentEffect.StunActions = default.PhantasmalPrison_Stun;
	PersistentEffect.ScaleStunWithWeaponTier = 1;
	PersistentEffect.ApplyOnTick.AddItem(new class'MZ_Effect_VoidPrison_NoDamage');		//allows actions to tick down without doing damage.
	PersistentEffect.DamageTypes.Length = 0;
	PersistentEffect.DamageTypes.AddItem('mental');
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.DamagePreviewFn = VoidConduitDamagePreview;

	return Template;
}

static function X2AbilityTemplate PhantasmalKiller()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local MZ_Effect_VoidPrison				PersistentEffect;
	local MZ_Effect_VoidPrison_BloodDrain				TickEffect;
	local X2Condition_UnitEffects			EffectCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPhantasmalKiller');

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZPsi_GhostCast';
	Template.CustomFireKillAnim = 'FF_MZPsi_GhostCast';
	Template.ActivationSpeech = 'VoidConduit';
	Template.CinescriptCameraType = "Templar_VoidConduit";
//END AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_VoidConduit";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PhantasmalKiller_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// block having more than one conduit ability active at a time.
	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

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

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Panic');
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//	don't allow a target to be affected by this more than one at a time
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	//	build the persistent effect
	PersistentEffect = new class'MZ_Effect_VoidPrison';
	PersistentEffect.InitialDamage = default.PhantasmalKiller_InitialDamage;
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	PersistentEffect.bRemoveWhenTargetDies = true;
	PersistentEffect.StunActions = default.PhantasmalKiller_Stun;
	PersistentEffect.ScaleStunWithWeaponTier = 1;
	//PersistentEffect.ScaleStunWithWeaponTier = default.VoidConduit_StunPerTier;
	//	build the per tick damage effect
	TickEffect = new class'MZ_Effect_VoidPrison_BloodDrain';
	TickEffect.DamagePerAction = default.PhantasmalKiller_PulseDamage;
	TickEffect.PsiToDamageMod = default.PhantasmalKiller_PsiToDamage;
	TickEffect.HealthReturnMod = 0.0f; //default.VoidConduit_LifeDrainMod; thinking no life drain on PK.
	TickEffect.DamageTypes.Length = 0;
	TickEffect.DamageTypes.AddItem('panic');
	PersistentEffect.ApplyOnTick.AddItem(TickEffect);
	PersistentEffect.DamageTypes.Length = 0;
	PersistentEffect.DamageTypes.AddItem('panic');
	PersistentEffect.DamageTypes.AddItem('mental');
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = PhantasmalKillerDamagePreview;

	return Template;
}
function bool PhantasmalKillerDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local int ticks, tickdamage;

	Switch (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponTech)
	{
		case 'beam':
			ticks = default.PhantasmalKiller_Stun + 2;
		case 'magnetic':
			ticks = default.PhantasmalKiller_Stun + 1;
		default:
			ticks = default.PhantasmalKiller_Stun;
	}

	tickdamage = Round(default.PhantasmalKiller_PsiToDamage*XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID)).GetCurrentStat(eStat_PsiOffense)) + default.PhantasmalKiller_PulseDamage;
	
	MinDamagePreview.Damage = default.PhantasmalKiller_InitialDamage;
	MaxDamagePreview.Damage = default.PhantasmalKiller_InitialDamage + ticks * tickdamage;
	return true;
}

static function X2AbilityTemplate PhantasmalWeird()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetCondition;
	local MZ_Effect_VoidPrison				PersistentEffect;
	local MZ_Effect_VoidPrison_BloodDrain	TickEffect;
	local X2Condition_UnitEffects			EffectCondition;
	local X2Condition_UnitEffectsApplying	ApplyingEffectsCondition;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPhantasmalWeird');

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZPsi_GhostCast';
	Template.CustomFireKillAnim = 'FF_MZPsi_GhostCast';
	Template.ActivationSpeech = 'VoidConduit';
	Template.CinescriptCameraType = "Templar_VoidConduit";
//END AUTOGENERATED CODE: Template Overrides 'VoidConduit'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_VoidConduit";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.PhantasmalWeird_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.PhantasmalWeird_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.PhantasmalWeird_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// block having more than one conduit ability active at a time.
	ApplyingEffectsCondition = new class'X2Condition_UnitEffectsApplying';
	ApplyingEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ApplyingEffectsCondition);

	Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);

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
	PersistentEffect.InitialDamage = default.PhantasmalWeird_InitialDamage;
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	PersistentEffect.bRemoveWhenTargetDies = true;
	PersistentEffect.StunActions = default.PhantasmalWeird_Stun;
	//PersistentEffect.ScaleStunWithWeaponTier = default.VoidConduit_StunPerTier;
	//	build the per tick damage effect
	TickEffect = new class'MZ_Effect_VoidPrison_BloodDrain';
	TickEffect.DamagePerAction = default.PhantasmalWeird_PulseDamage;
	TickEffect.PsiToDamageMod = default.PhantasmalWeird_PsiToDamage;
	TickEffect.HealthReturnMod = 0.0f; //default.VoidConduit_LifeDrainMod; thinking no life drain on PK.
	TickEffect.DamageTypes.Length = 0;
	TickEffect.DamageTypes.AddItem('panic');
	PersistentEffect.ApplyOnTick.AddItem(TickEffect);
	PersistentEffect.DamageTypes.Length = 0;
	PersistentEffect.DamageTypes.AddItem('panic');
	PersistentEffect.DamageTypes.AddItem('mental');
	Template.AddMultiTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = PhantasmalWeirdDamagePreview;

	return Template;
}
function bool PhantasmalWeirdDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local int tickdamage;

	tickdamage = Round(default.PhantasmalWeird_PsiToDamage*XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID)).GetCurrentStat(eStat_PsiOffense)) + default.PhantasmalWeird_PulseDamage;
	
	MinDamagePreview.Damage = default.PhantasmalWeird_InitialDamage;
	MaxDamagePreview.Damage = default.PhantasmalWeird_InitialDamage + tickdamage * default.PhantasmalWeird_Stun;
	return true;
}

static function X2AbilityTemplate MassPanic()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit	StatCheck;
	local X2Effect_Panicked             PanicEffect;
	local X2Effect_ApplyWeaponDamage    RuptureEffect;
	local X2Condition_AbilityProperty   SchismCondition;
	local X2Effect_PerkAttachForFX          DurationFXEffect;
	local X2Effect_TriggerEvent             EndDurationFXEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMassPanic');

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = 50;
	Template.AbilityToHitCalc = StatCheck;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MassPanic_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_NonOffensive;
	Template.Hostility = eHostility_Offensive;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.MassPanic_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MassPanic_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//  Panic effect
	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 1;
	PanicEffect.MaxStatContestResult = 0;
	PanicEffect.DamageTypes.AddItem('Psi');
	Template.AddMultiTargetEffect(PanicEffect);

	//  Rupture effect if the caster has Schism
	RuptureEffect = new class'X2Effect_ApplyWeaponDamage';
	RuptureEffect.EffectDamageValue = default.Schism_Damage;
	RuptureEffect.MinStatContestResult = 1;
	RuptureEffect.MaxStatContestResult = 0;
	RuptureEffect.bIgnoreArmor = true;
	RuptureEffect.bIgnoreBaseDamage = true;
	SchismCondition = new class'X2Condition_AbilityProperty';
	SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
	RuptureEffect.TargetConditions.AddItem(SchismCondition);
	RuptureEffect.DamageTypes.AddItem('Panic');
	RuptureEffect.DamageTypes.AddItem('Psi');
	Template.AddMultiTargetEffect(RuptureEffect);

	DurationFXEffect = new class 'X2Effect_PerkAttachForFX';
	DurationFXEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnEnd);
	DurationFXEffect.EffectName = default.MZDisableDurationFXEffectName;
	Template.AddShooterEffect(DurationFXEffect);

	EndDurationFXEffect = new class'X2Effect_TriggerEvent';
	EndDurationFXEffect.TriggerEventName = default.EndMZDisableDurationFXEventName;
	Template.AddShooterEffect(EndDurationFXEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ImpendingDoom";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.AdditionalAbilities.AddItem('MZDisableEndDurationFX');

	return Template;
}

static function X2AbilityTemplate Sleep()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	//local X2AbilityCooldown                 Cooldown;
	local X2Effect_Blind					BlindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPsiSleep');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	/*
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PsiBlind_Cooldown;
	Template.AbilityCooldown = Cooldown;
	*/

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeNonCivilian = true;
	TargetProperty.ExcludeCivilian = false;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(1, 0);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, 0, MODOP_PostMultiplication);
	BlindEffect.bInfiniteDuration = true;
	BlindEffect.DamageTypes.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	BlindEffect.DamageTypes.AddItem('mental');
	Template.AddTargetEffect(BlindEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(true, false));

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Neutral;
	Template.ConcealmentRule = eConceal_Always;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'FF_MZPsi_MindControlCast';

	Template.ActivationSpeech = 'Insanity';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

//BEGIN AUTOGENERATED CODE: Template Overrides 'Soulfire'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Soulfire'

	return Template;
}

static function X2AbilityTemplate MassSleep()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Blind					BlindEffect;
	local X2Condition_UnitProperty          TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZMassSleep');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MassSleep_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.MassSleep_Range;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MassSleep_Radius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeNonCivilian = true;
	TargetProperty.ExcludeCivilian = false;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetProperty);

	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(1, 0);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, 0, MODOP_PostMultiplication);
	BlindEffect.bInfiniteDuration = true;
	BlindEffect.DamageTypes.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	BlindEffect.DamageTypes.AddItem('mental');
	Template.AddMultiTargetEffect(BlindEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(true, false));

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MZPsi_RiftCast';

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.ActivationSpeech = 'VoidRift';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";

//BEGIN AUTOGENERATED CODE: Template Overrides 'VoidRift'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'VoidRift'

	return Template;
}

static function X2AbilityTemplate KineticPull()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnblockedNeighborTile UnblockedNeighborTileCondition;
	//local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Effect_GetOverHere              GetOverHereEffect;
	//local X2Effect_TriggerEvent				PostAbilityMelee;
	local X2Effect_ApplyWeaponDamage		EnvironmentDamageForProjectile;
	local X2Effect_RemoveEffects			RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKineticPull');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Justice";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = New class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KineticPull_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// There must be a free tile around the source unit
	UnblockedNeighborTileCondition = new class'X2Condition_UnblockedNeighborTile';
	UnblockedNeighborTileCondition.RequireVisible = true;
	Template.AbilityShooterConditions.AddItem(UnblockedNeighborTileCondition);

	// The Target must be alive and a humanoid
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeNonHumanoidAliens = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinMinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	//	prevent various stationary units from being pulled inappropriately
	Template.AbilityTargetConditions.AddItem(class'X2Ability_TemplarAbilitySet'.static.InvertAndExchangeEffectsCondition());

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// This will attack using the standard aim
	/*
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.JUSTICE_HIT_BONUS;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	*/

	//AimType = new class'MZ_Aim_PsiAttack';
	//AimType.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = new class'MZ_Aim_PsiAttack';

	GetOverHereEffect = new class'X2Effect_GetOverHere';
 	GetOverHereEffect.OverrideStartAnimName = 'NO_GrapplePullStart';
 	GetOverHereEffect.OverrideStopAnimName = 'NO_GrapplePullStop';
	GetOverHereEffect.RequireVisibleTile = true;
	Template.AddTargetEffect(GetOverHereEffect);

	EnvironmentDamageForProjectile = new class'X2Effect_ApplyWeaponDamage';
	EnvironmentDamageForProjectile.bIgnoreBaseDamage = true;
	EnvironmentDamageForProjectile.EnvironmentalDamageAmount = 30;
	Template.AddTargetEffect(EnvironmentDamageForProjectile);

	/*
	PostAbilityMelee = new class'X2Effect_TriggerEvent';
	PostAbilityMelee.TriggerEventName = 'ActivateSkirmisherMelee';
	Template.AddTargetEffect(PostAbilityMelee);
	Template.AdditionalAbilities.AddItem('SkirmisherPostAbilityMelee');
	*/

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	Template.bForceProjectileTouchEvents = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Justice_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Offensive;
	//Template.DamagePreviewFn = PostAbilityMeleeDamagePreview;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Justice'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActionFireClass = class'XComGame.X2Action_ViperGetOverHere';
	Template.ActivationSpeech = 'Justice';
//END AUTOGENERATED CODE: Template Overrides 'Justice'
		
	return Template;
}
static function Justice_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_ViperGetOverHere GetOverHereAction;
	local X2Action_ExitCover ExitCover;

	VisMgr = `XCOMVISUALIZATIONMGR;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	ExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover'));
	ExitCover.bUsePreviousGameState = true;

	GetOverHereAction = X2Action_ViperGetOverHere(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ViperGetOverHere'));
	GetOverHereAction.StartAnimName = 'MZ_StranglePullStart';
	GetOverHereAction.StopAnimName = 'MZ_StranglePullStop';
}

static function X2AbilityTemplate KineticRescue()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnblockedNeighborTile UnblockedNeighborTileCondition;
	local X2Effect_GetOverHere              GetOverHereEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	//local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZKineticRescue');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Justice";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = New class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KineticRescue_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// There must be a free tile around the source unit
	UnblockedNeighborTileCondition = new class'X2Condition_UnblockedNeighborTile';
	UnblockedNeighborTileCondition.RequireVisible = true;
	Template.AbilityShooterConditions.AddItem(UnblockedNeighborTileCondition);

	// The Target must be alive and a humanoid
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeNonHumanoidAliens = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.RequireWithinMinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	//	prevent various stationary units from being pulled inappropriately
	Template.AbilityTargetConditions.AddItem(class'X2Ability_TemplarAbilitySet'.static.InvertAndExchangeEffectsCondition());

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	GetOverHereEffect = new class'X2Effect_GetOverHere';
 	GetOverHereEffect.OverrideStartAnimName = 'NO_GrapplePullStart';
 	GetOverHereEffect.OverrideStopAnimName = 'NO_GrapplePullStop';
	GetOverHereEffect.RequireVisibleTile = true;
	Template.AddTargetEffect(GetOverHereEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
	Template.AddTargetEffect(RemoveEffects);

	/*
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);
	*/

	//Clear Tranquil Effect
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ChronoEffect);

	Template.bForceProjectileTouchEvents = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Justice_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Defensive;
	//Template.DamagePreviewFn = PostAbilityMeleeDamagePreview;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Justice'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActionFireClass = class'XComGame.X2Action_ViperGetOverHere';
	Template.ActivationSpeech = 'Justice';
//END AUTOGENERATED CODE: Template Overrides 'Justice'
		
	return Template;
}