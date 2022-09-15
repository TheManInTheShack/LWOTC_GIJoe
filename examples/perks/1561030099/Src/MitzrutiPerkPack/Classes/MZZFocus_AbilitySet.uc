class MZZFocus_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkFocus);

var config int FlameFocus_StartFocus, FlameFocus_MaxFocus, FlameFocus_KillFocus, FlameFocus_MaxBoost, FlameFocus_StartBoost, FlameFocus_GainBoost;
var config int EarthFocus_StartFocus, EarthFocus_MaxFocus, EarthFocus_HunkerFocus, EarthFocus_MaxBoost, EarthFocus_StartBoost, EarthFocus_GainBoost;
var config int WaterFocus_StartFocus, WaterFocus_MaxFocus, WaterFocus_PerTurnFocus, WaterFocus_MaxBoost, WaterFocus_StartBoost, WaterFocus_GainBoost;
var config int NecroFocus_StartFocus, NecroFocus_MaxFocus, NecroFocus_DeathFocus, NecroFocus_MaxBoost, NecroFocus_StartBoost, NecroFocus_GainBoost;
var config int WindFocus_StartFocus, WindFocus_MaxFocus, WindFocus_DashFocus, WindFocus_MaxBoost, WindFocus_StartBoost, WindFocus_GainBoost;
var config int PhantomFocus_StartFocus, PhantomFocus_MaxFocus, PhantomFocus_PerTurnFocus, PhantomFocus_MaxBoost, PhantomFocus_StartBoost, PhantomFocus_GainBoost;
var config int VoidFocus_StartFocus, VoidFocus_MaxFocus, VoidFocus_MaxBoost, VoidFocus_StartBoost;
var localized string FlameFocus_Label, FlameFocus_Tooltip, WaterFocus_Label, WaterFocus_Tooltip, EarthFocus_Label, EarthFocus_Tooltip, WindFocus_Label, WindFocus_Tooltip, NecroFocus_Label, NecroFocus_Tooltip, VoidFocus_Label, VoidFocus_Tooltip;
var localized string PhantomFocus_Label, PhantomFocus_Tooltip;

var config int Teleport_ManaCost, Grapple_ManaCost, Conceal_Cooldown, Conceal_ManaCost, LiquidMagic_ManaCost, LiquidMagic_RestoreMana;

struct ManaCostStruct
{
	var name AbilityName;
	var int FocusCost;
	var int ManaCost;
	var int MaxManaCost;
	var bool ConsumeAllFocus;
	var bool GhostOnlyCost;
	var bool bFreeCost;
};
var config array<ManaCostStruct> AddFocusCostToAbility;
var config array<name> PatchFocusCostOnAbility;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(FlameFocus());	//gain from kills
	Templates.AddItem(WaterFocus());	//gain on turn start
	Templates.AddItem(EarthFocus());	//gain from hunkering down
	Templates.AddItem(AirFocus());	//dashing

	//Templates.AddItem(BloodFocus()); -gain from sacrificing health
	Templates.AddItem(VoidFocus());		//large pool, no inate recovery.
	Templates.AddItem(NecroFocus());	//(very low) gain from anything dieing.
	Templates.AddItem(PhantomFocus());

	Templates.AddItem(PurePassive('MZFocusMaxBoost', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_DeepFocus"));
	Templates.AddItem(PurePassive('MZFocusStartBoost', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_meditation"));
	Templates.AddItem(PurePassive('MZFocusGainBoost', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Channel"));

	Templates.AddItem(ManaTeleport());
	Templates.AddItem(ManaGrapple());
	Templates.AddItem(ManaConceal());
	Templates.AddItem(LiquidMagic());

	return Templates;
}

static function PatchFocusCosts()
{
	local X2AbilityTemplateManager	AbilityManager;
	local X2AbilityTemplate			AbilityTemplate;
	local name						AbilityName;
	local ManaCostStruct			ManaStruct;
	local MZ_Cost_Focus				ManaCost;
	local X2AbilityCost_Focus		FocusCost;
	local int						i;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.AddFocusCostToAbility(ManaStruct)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(ManaStruct.AbilityName);
		if ( AbilityTemplate != none )
		{
			ManaCost = new class'MZ_Cost_Focus';
			ManaCost.ManaAmount = ManaStruct.ManaCost;
			ManaCost.MaxManaCost = ManaStruct.MaxManaCost;
			ManaCost.FocusAmount = ManaStruct.FocusCost;
			ManaCost.bFreeCost = ManaStruct.bFreeCost;
			ManaCost.ConsumeAllFocus = ManaStruct.ConsumeAllFocus;
			ManaCost.GhostOnlyCost = ManaStruct.GhostOnlyCost;

			AbilityTemplate.AbilityCosts.AddItem(ManaCost);
		}
	}

	foreach default.PatchFocusCostOnAbility(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		if ( AbilityTemplate != none )
		{
			//`LOG("Mitzruti Perk Pack: Patching Focus Cost of" $ string(AbilityName));
			for (i = AbilityTemplate.AbilityCosts.Length; i > -1; i--)
			{
				FocusCost = X2AbilityCost_Focus( AbilityTemplate.AbilityCosts[i] );
				if( FocusCost != none && !FocusCost.bFreeCost ) 
				{ 
					//`LOG("Mitzruti Perk Pack: Patching Focus cost at index" $ string(i));
					ManaCost = new class'MZ_Cost_Focus';
					ManaCost.FocusAmount = FocusCost.FocusAmount;
					ManaCost.ManaAmount = FocusCost.FocusAmount * 3;
					ManaCost.bFreeCost = FocusCost.bFreeCost;
					ManaCost.GhostOnlyCost = FocusCost.GhostOnlyCost;
					ManaCost.ConsumeAllFocus = FocusCost.ConsumeAllFocus;

					AbilityTemplate.AbilityCosts.RemoveItem(FocusCost);
					AbilityTemplate.AbilityCosts.InsertItem(i, ManaCost);
					//break;
				}
			}

			if ( AbilityName == 'BowRend' )
			{
				AbilityTemplate.HideIfAvailable.RemoveItem('BowRend_APA');
				AbilityTemplate.AdditionalAbilities.RemoveItem('BowRend_APA');
			}
		}
	}
}

static function X2AbilityTemplate FlameFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFlameFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.FlameFocus_StartFocus;
	Effect.FocusMax = default.FlameFocus_MaxFocus;
	Effect.FocusRecovery = default.FlameFocus_KillFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.FlameFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.FlameFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.FlameFocus_GainBoost);
	Effect.GainFocusOnKill = true;
	Effect.sFocusColour = "e69831"; // Orange
	Effect.sFocusLabel = default.FlameFocus_Label;
	Effect.sFocusTooltip = default.FlameFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate WaterFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZWaterFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.WaterFocus_StartFocus;
	Effect.FocusMax = default.WaterFocus_MaxFocus;
	Effect.FocusRecovery = default.WaterFocus_PerTurnFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.WaterFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.WaterFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.WaterFocus_GainBoost);
	Effect.GainFocusEveryTurnWaterType = true;
	Effect.sFocusColour = "27aae1"; // Blue science
	Effect.sFocusLabel = default.WaterFocus_Label;
	Effect.sFocusTooltip = default.WaterFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate EarthFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZEarthFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.EarthFocus_StartFocus;
	Effect.FocusMax = default.EarthFocus_MaxFocus;
	Effect.FocusRecovery = default.EarthFocus_HunkerFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.EarthFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.EarthFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.EarthFocus_GainBoost);
	Effect.GainFocusOnHunker = true;
	Effect.sFocusColour = "53b45e"; //green
	Effect.sFocusLabel = default.EarthFocus_Label;
	Effect.sFocusTooltip = default.EarthFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AirFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZWindFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.WindFocus_StartFocus;
	Effect.FocusMax = default.WindFocus_MaxFocus;
	Effect.FocusRecovery = default.WindFocus_DashFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.WindFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.WindFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.WindFocus_GainBoost);
	Effect.GainFocusOnDash = true;
	Effect.sFocusColour = "aca68a"; //yellow
	Effect.sFocusLabel = default.WindFocus_Label;
	Effect.sFocusTooltip = default.WindFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate VoidFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZVoidFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.VoidFocus_StartFocus;
	Effect.FocusMax = default.VoidFocus_MaxFocus;
	Effect.FocusRecovery = 0;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.VoidFocus_MaxBoost);
	Effect.AddMaxFocusBoost('MZFocusStartBoost', default.VoidFocus_StartBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.VoidFocus_StartBoost);
	Effect.AddStartFocusBoost('MZFocusMaxBoost', default.VoidFocus_MaxBoost);
	Effect.sFocusColour = "b6b3e3"; //psi purple
	Effect.sFocusLabel = default.VoidFocus_Label;
	Effect.sFocusTooltip = default.VoidFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate NecroFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZNecroFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.NecroFocus_StartFocus;
	Effect.FocusMax = default.NecroFocus_MaxFocus;
	Effect.FocusRecovery = default.NecroFocus_DeathFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.NecroFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.NecroFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.NecroFocus_GainBoost);
	Effect.GainFocusOnAnyDeath = true;
	Effect.sFocusColour = "acd373"; //lost green
	Effect.sFocusLabel = default.NecroFocus_Label;
	Effect.sFocusTooltip = default.NecroFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate PhantomFocus()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_Focus               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPhantomFocus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_InnerFocus";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	//Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_Focus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.FocusStart = default.PhantomFocus_StartFocus;
	Effect.FocusMax = default.PhantomFocus_MaxFocus;
	Effect.FocusRecovery = default.PhantomFocus_PerTurnFocus;
	Effect.AddMaxFocusBoost('MZFocusMaxBoost', default.PhantomFocus_MaxBoost);
	Effect.AddStartFocusBoost('MZFocusStartBoost', default.PhantomFocus_StartBoost);
	Effect.AddGainFocusBoost('MZFocusGainBoost', default.PhantomFocus_GainBoost);
	Effect.GainFocusOnAnyDeath = true;
	Effect.sFocusColour = "a28752"; //reaper brown
	Effect.sFocusLabel = default.PhantomFocus_Label;
	Effect.sFocusTooltip = default.PhantomFocus_Tooltip;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2DataTemplate ManaTeleport()
{
	local X2AbilityTemplate	Template;
	local MZ_Cost_Focus		ManaCost;
	local X2AbilityCooldown             Cooldown;

	Template = X2AbilityTemplate(class'MZUnspecific_AbilitySet'.static.AddTeleportAbility('MZManaTeleport'));
	Template.AbilityCooldown = none;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.Teleport_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	return Template;
}

static function X2AbilityTemplate ManaGrapple()
{
	local X2AbilityTemplate			Template;
	local MZ_Cost_Focus						ManaCost;
	local X2AbilityCooldown             Cooldown;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddGrapple('MZManaGrapple');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_grapple";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.Grapple_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

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

static function X2AbilityTemplate ManaConceal()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local MZ_Cost_Focus						ManaCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZManaConceal');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.Conceal_ManaCost;
	ManaCost.FocusAmount = 2;
	Template.AbilityCosts.AddItem(ManaCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Conceal_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
	Template.AddShooterEffectExclusions();

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
	Template.AddTargetEffect(StealthEffect);

	Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.ActivationSpeech = 'ActivateConcealment';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate LiquidMagic()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_UnitProperty      TargetCondition;
	local X2AbilityCooldown             Cooldown;
	local MZ_Cost_Focus					ManaCost;
	local MZ_Condition_HasOneEffect		EffectsCondition;
	local MZ_Effect_FocusRestore		FocusRestoreEffect;
	local X2Effect_ManualOverride			ChronoEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLiquidMagic');

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_inspire";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ManaCost = new class'MZ_Cost_Focus';
	ManaCost.ManaAmount = default.LiquidMagic_ManaCost;
	ManaCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(ManaCost);

	//once per turn
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
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
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeUnableToAct = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectsCondition = new class'MZ_Condition_HasOneEffect';
	EffectsCondition.EffectNames.AddItem('MZFocusLevel'); //mana focus 
	EffectsCondition.EffectNames.AddItem('TemplarFocus'); //regular templar focus
	EffectsCondition.EffectNames.AddItem('WOTC_APA_Conduit_UpdateFocusListener'); //indicates Shiremct's Templar Focus
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	//defaults to +1 focus for regular/shiremct.
	FocusRestoreEffect = new class'MZ_Effect_FocusRestore';
	FocusRestoreEffect.ManaRestore = default.LiquidMagic_RestoreMana;
	Template.AddTargetEffect(FocusRestoreEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'Inspiration';
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
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
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Inspire'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Inspire'

	return Template;
}