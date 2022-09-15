// This is an Unreal Script
class MZGeneMods_AbilitySet extends X2Ability config(GeneMods);

var config int		AdrenalNeurosympathy_Crit, AdrenalNeurosympathy_Mobility, AdrenalNeurosympathy_Aim, AdrenalNeurosympathy_Duration, AdrenalNeurosympathy_Cooldown, RegenPheremones_Duration, RegenPheremones_Cooldown, RegenPheremones_HealPerTurn, DANGERSENSE_RADIUS;
var config float	AdrenalNeurosympathy_Range, NeuralFeedback_DamagePerRank, ViperBlood_Range, RegenPheremones_Range, NictitatingMembranes_BonusMod, NeuralDamping_BonusMult;
var config int		AdaptiveBoneMarrow_PercentToHeal, AdaptiveBoneMarrow_HealPerTurn, AdaptiveBoneMarrow_MaxHealPerTurn, NeuralDamping_DeflectChance, ViperBlood_AimMod, ViperBlood_CritMod, ViperBlood_DodgeMod, ViperBlood_DefMod, Psyber_Hack, Psyber_AimMod, Psyber_CritMod;
var config int		DepthPerception_Crit, DepthPerception_AntiDodge, DepthPerception_Aim, HyperreactivePupils_Crit, HyperreactivePupils_Aim, HyperreactivePupils_AntiDodge, Wiredreflexes_AtkChance, Wiredreflexes_DefChance;
var config bool		AdrenalNeurosympathy_ExcludeSparks, RegenPheremones_ExcludeSparks;
var config WeaponDamageValue	NeuralFeedback_BaseDamage;
var config array<name>	ViperBlood_ImmuneTypes, AdrenalNeurosympathy_Cleanse, RegenPheremones_Cleanse, NeuralDamping_ImmuneTypes;

var localized string AdrenalNeurosympathyEffectName, NeuralFeedbackEffectName, RegenPheremonesEffectName;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddAdrenalNeurosympathy());
	/*>>*/Templates.AddItem(AddAdrenalNeurosympathyTrigger());
	Templates.AddItem(AddNeuralDamping());
	Templates.AddItem(AddNeuralFeedback());
	/*>>*/Templates.AddItem(AddNeuralFeedbackTrigger());
	Templates.AddItem(AddAdaptiveBoneMarrow());
	Templates.AddItem(AddViperBlood());
	/*>>*/Templates.AddItem(AddViperBloodTrigger());
	Templates.AddItem(AddRegenPheremones());
	/*>>*/Templates.AddItem(AddRegenPheremonesTrigger());
	Templates.AddItem(AddNictatingMembranes());
	Templates.AddItem(AddImplantedPsyberInterface());
	Templates.AddItem(AddWiredreflexes());

	//wall climb and Memeskin by reality machina
	Templates.AddItem(CreateGeneWallClimb());
	Templates.AddItem(CreateMimeticSkinPassive());
	Templates.AddItem(CreateMimeticSkin());
	//bioelectric skin by musashi
	Templates.AddItem(DangerSense());
	Templates.AddItem(DangerSenseTrigger());
	Templates.AddItem(DangerSenseSpawnTrigger());
	//these two are slightly different than thier lw2 counterparts.
	Templates.AddItem(AddDepthPerception());
	Templates.AddItem(AddHyperreactivePupils());

	return Templates;
}

static function X2AbilityTemplate AddAdrenalNeurosympathy()
{
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZAdrenalNeurosympathy', "img:///UILibrary_PerkIcons.UIPerk_adrenalneurosympathy");
	Template.AdditionalAbilities.AddItem('MZAdrenalNeurosympathyTrigger');

	return Template;
}

static function X2AbilityTemplate AddAdrenalNeurosympathyTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_PersistentStatChange		StatChangeEffect;
	local X2Condition_UnitProperty			FriendCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_removeEffects			Cleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAdrenalNeurosympathyTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adrenalneurosympathy";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.AdrenalNeurosympathy_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.AdrenalNeurosympathy_Range;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'KillMail';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FriendCondition.Excluderobotic = default.AdrenalNeurosympathy_ExcludeSparks;

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(default.AdrenalNeurosympathy_Duration, false, false, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, default.AdrenalNeurosympathy_Aim);
	StatChangeEffect.AddPersistentStatChange(eStat_CritChance, default.AdrenalNeurosympathy_Crit);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.AdrenalNeurosympathy_Mobility);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	StatChangeEffect.VisualizationFn = AdrenalNeurosympathyVisualization;
	StatChangeEffect.EffectName = 'MZAdrenalNeurosympathyBuff';
	StatChangeEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect( StatChangeEffect );
	Template.AddMultiTargetEffect( StatChangeEffect );

	Cleanse = new class'X2Effect_removeEffects';
	Cleanse.EffectNamesToremove = default.AdrenalNeurosympathy_Cleanse;
	Cleanse.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect( Cleanse );
	Template.AddMultiTargetEffect( Cleanse );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.CustomFireAnim = 'HL_SignalAngry';
	//Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

static function AdrenalNeurosympathyVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
		return;
	if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.AdrenalNeurosympathyEffectName, '', eColor_Good, "img:///UILibrary_PerkIcons.UIPerk_adrenalneurosympathy");
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2AbilityTemplate AddNeuralDamping()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_NeuralDamping                  Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNeuralDamping');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_neuraldamping";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_NeuralDamping';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.BonusMult = default.NeuralDamping_BonusMult;
	Effect.ImmuneTypes = default.NeuralDamping_ImmuneTypes;
	Template.AddTargetEffect(Effect);

	//mental immunity, reduce psi damage

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddNeuralFeedback()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_NeuralFeedbackDamageBonus   Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNeuralFeedback');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_neuralfeedback";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//effect that boosts the trigger's damage
	Effect = new class'MZ_Effect_NeuralFeedbackDamageBonus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AbilityName = 'MZNeuralFeedbackTrigger';
	Effect.DamagePerRank = default.NeuralFeedback_DamagePerRank;
	//Effect.bDisplayInSpecialDamageMessageUI = true;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	Template.AdditionalAbilities.AddItem('MZNeuralFeedbackTrigger');

	return Template;
}

static function X2AbilityTemplate AddNeuralFeedbackTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local MZ_Effect_NeuralFeedbackCoolPsi	CoolPsiEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNeuralFeedbackTrigger');

	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_neuralfeedback";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerFeedbackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	//Damage effect, o/
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = default.NeuralFeedback_BaseDamage;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(DamageEffect);

	//Put Psi Abilities on cooldown.
	//needs a modified version of ManualOverride
	CoolPsiEffect = new class'MZ_Effect_NeuralFeedbackCoolPsi';
	CoolPsiEffect.EffectAppliedName = default.NeuralFeedbackEffectName;
	Template.AddTargetEffect(CoolPsiEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddAdaptiveBoneMarrow()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_PostCombatHeal		Effect;
	local X2Effect_Regeneration			RegenerationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAdaptiveBoneMarrow');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rapidregeneration";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_PostCombatHeal';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.PercentToHeal = default.AdaptiveBoneMarrow_PercentToHeal;
	Template.AddTargetEffect(Effect);

	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(1,  true, true, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.HealAmount = default.AdaptiveBoneMarrow_HealPerTurn;
	RegenerationEffect.MaxHealAmount = default.AdaptiveBoneMarrow_MaxHealPerTurn;
	Template.AddTargetEffect(RegenerationEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddViperBlood()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ViperBlood                 Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZViperBlood');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_getoverhere";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//immunity to poision... actually let's just roll it into the other effect.
	Effect = new class'MZ_Effect_ViperBlood';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AimMod = default.ViperBlood_AimMod;
	Effect.CritMod = default.ViperBlood_CritMod;
	Effect.GrazeMod = default.ViperBlood_DodgeMod;
	Effect.DefMod=default.ViperBlood_DefMod;
	Effect.ImmuneTypes = default.ViperBlood_ImmuneTypes;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	Template.AdditionalAbilities.AddItem('MZViperBloodTrigger');

	return Template;
}

static function X2AbilityTemplate AddViperBloodTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local MZ_Effect_PoisonTrail				PoisonTrailEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZViperBloodTrigger');

	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_getoverhere";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.ViperBlood_Range;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	//Poison Nearby foes
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
	//Apply PoisonTrail To Self
	PoisonTrailEffect = new class'MZ_Effect_PoisonTrail';
	PoisonTrailEffect.radius = default.ViperBlood_Range;
	Template.AddTargetEffect(PoisonTrailEffect);
	
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddRegenPheremones()
{
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZRegenPheremones', "img:///UILibrary_PerkIcons.UIPerk_pheromones");
	Template.AdditionalAbilities.AddItem('MZRegenPheremonesTrigger');

	return Template;
}

static function X2AbilityTemplate AddRegenPheremonesTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_Regeneration				RegenerationEffect;
	local X2Condition_UnitProperty			FriendCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_removeEffects			Cleanse;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRegenPheremonesTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_pheromones";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RegenPheremones_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.RegenPheremones_Range;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'KillMail';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FriendCondition.Excluderobotic = default.RegenPheremones_ExcludeSparks;

	//switch to Regen effect
	RegenerationEffect = new class'X2Effect_Regeneration';
	RegenerationEffect.BuildPersistentEffect(default.RegenPheremones_Duration, false, false, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.DuplicateResponse = eDupe_Refresh;
	RegenerationEffect.bRemoveWhenTargetDies = true;
	RegenerationEffect.HealAmount = default.RegenPheremones_HealPerTurn;
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	RegenerationEffect.VisualizationFn = RegenPheremonesVisualization;
	RegenerationEffect.EffectName = 'MZRegenPheremonesBuff';
	RegenerationEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect( RegenerationEffect );
	Template.AddMultiTargetEffect( RegenerationEffect );

	Cleanse = new class'X2Effect_removeEffects';
	Cleanse.EffectNamesToremove= default.RegenPheremones_Cleanse;
	Cleanse.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect( Cleanse );
	Template.AddMultiTargetEffect( Cleanse );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.CustomFireAnim = 'HL_SignalBark';
	//Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

static function RegenPheremonesVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
		return;
	if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.RegenPheremonesEffectName, '', eColor_Good, "img:///UILibrary_PerkIcons.UIPerk_pheromones");
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2AbilityTemplate AddNictatingMembranes()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_NictitatingMembranes	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNictitatingMembranes');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_lowvisibility";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//effect.
	Effect = new class'MZ_Effect_NictitatingMembranes';
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.BonusMod = default.NictitatingMembranes_BonusMod;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddImplantedPsyberInterface()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_PsyberInterface        Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPsyberInterface');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_squadsightprotocol";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//deflect doesn't workon nonstandard aim
	Effect = new class'MZ_Effect_PsyberInterface';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Hacking, default.Psyber_Hack);
	Effect.AimMod=default.Psyber_AimMod;
	Effect.CritMod=default.Psyber_CritMod;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate CreateGeneWallClimb()
{
	local X2AbilityTemplate Template;	
	local X2Effect_PersistentTraversalChange	JumpServosEffect;
	//local X2Effect_AdditionalAnimSets			IcarusAnimSet;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_GeneWallClimb');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_wraith";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_musclefiberdensity";

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AbilityToHitCalc = default.DeadEye;


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bSkipPerkActivationActions = true; // we'll trigger related perks as part of the movement action

	// Give the unit the JumpUp traversal type
	JumpServosEffect = new class'X2Effect_PersistentTraversalChange';
	JumpServosEffect.BuildPersistentEffect( 1, true, true, false, eGameRule_PlayerTurnBegin );
	JumpServosEffect.SetDisplayInfo( ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText( ), Template.IconImage, true );
	JumpServosEffect.AddTraversalChange( eTraversal_WallClimb, true );
	JumpServosEffect.EffectName = 'MOCX_Agility';
	JumpServosEffect.DuplicateResponse = eDupe_Refresh;

	Template.AddTargetEffect( JumpServosEffect );


	return Template;
}

static function X2AbilityTemplate CreateMimeticSkinPassive()
{
	local X2AbilityTemplate						Template;
	Template = PurePassive('RM_GeneMimeticSkin', "img:///UILibrary_PerkIcons.UIPerk_quadricepshypertrophy", false);
	Template.AdditionalAbilities.AddItem('RM_GeneMimeticSkinTrigger');

	return Template;
}

static function X2AbilityTemplate CreateMimeticSkin()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	//local X2AbilityCharges                      Charges;
	local X2AbilityTrigger_EventListener    EventTrigger;
	//local X2Condition_Visibility            CoverCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'RM_GeneMimeticSkinTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_quadricepshypertrophy";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// loot will also automatically trigger at the end of a move if it is possible
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventTrigger.ListenerData.EventID = 'UnitMoveFinished';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'rm_Condition_MimeticSkin');

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	//StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());
	Template.Hostility = eHostility_Movement;

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate DangerSense()
{
	local X2AbilityTemplate						Template;
	Template = PurePassive('Musashi_BioelectricSkin', "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin", false);
	Template.AdditionalAbilities.AddItem('Musashi_BioelectricSkinTrigger');
	Template.AdditionalAbilities.AddItem('Musashi_BioelectricSkinSpawnTrigger');

	return Template;
}

static function X2AbilityTemplate DangerSenseTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local xyl_Effect_RevealUnit				TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2Condition_UnitEffects			EffectsCondition;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Musashi_BioelectricSkinTrigger');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsNotPlayerControlled');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.DANGERSENSE_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(TargetProperty);

	//EffectsCondition = new class'X2Condition_UnitEffects';
	//EffectsCondition.AddExcludeEffect(class'X2Effect_Burrowed'.default.EffectName, 'AA_UnitIsBurrowed');
	//Template.AbilityMultiTargetConditions.AddItem(EffectsCondition);

	TrackingEffect = new class'xyl_Effect_RevealUnit';
	TrackingEffect.EffectName = 'BioeletricDetection';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddMultiTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'PlayerTurnBegun';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Movement;

	return Template;
}

// This triggers whenever a unit is spawned within tracking radius. The most likely
// reason for this to happen is a Faceless transforming due to tracking being applied.
// The newly spawned Faceless unit won't have the tracking effect when this happens,
// so we apply it here.
static function X2AbilityTemplate DangerSenseSpawnTrigger()
{
	local X2AbilityTemplate					Template;
	local xyl_Effect_RevealUnit				TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Musashi_BioelectricSkinSpawnTrigger');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = default.DANGERSENSE_RADIUS * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	TrackingEffect = new class'xyl_Effect_RevealUnit';
	TrackingEffect.EffectName = 'BioeletricDetection';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitSpawned';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Movement;

	return Template;
}

static function X2AbilityTemplate AddDepthPerception()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_HeightAimBonus	Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDepthPerception');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_depthperception";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//effect.
	Effect = new class'MZ_Effect_HeightAimBonus';
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AIM_BONUS=default.DepthPerception_Aim;
	Effect.ANTIDODGE_BONUS=default.DepthPerception_AntiDodge;
	Effect.Crit_Bonus=default.DepthPerception_Crit;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddHyperreactivePupils()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_AimBoostOnMiss		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHyperreactivePupils');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hyperactivepupils";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//effect.
	Effect = new class'MZ_Effect_AimBoostOnMiss';
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AIM_BONUS=default.HyperreactivePupils_Aim;
	Effect.ANTIDODGE_BONUS=default.HyperreactivePupils_AntiDodge;
	Effect.Crit_Bonus=default.HyperreactivePupils_Crit;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddWiredreflexes()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_Wiredreflexes                  Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZWiredreflexes');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Wiredreflexes';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AtkChance = default.Wiredreflexes_AtkChance;
	Effect.DefChance = default.Wiredreflexes_DefChance;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}