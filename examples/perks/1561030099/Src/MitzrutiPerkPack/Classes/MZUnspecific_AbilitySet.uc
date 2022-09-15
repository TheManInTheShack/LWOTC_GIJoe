class MZUnspecific_AbilitySet extends X2Ability	dependson (XComGameStateContext_Ability) config(MZPerkPack);
	
var config int Teleport_Cooldown, Blink_Cooldown, Blink_Range, Transposition_Cooldown, TransposeDefense_Defense, TransposeTimeShift_Stun, TerribleThought_HPCost, TerribleThought_Turns, TerribleThought_Cooldown, CloakOfShadows_Cooldown, BloodTeleport_HPCost, BloodiedShroud_PercentToHeal, BloodiedShroud_HP, BloodPillar_HPCost, BloodPillar_Duration, PILLAR_COOLDOWN, Pillar_Duration;
var config int CriticalX_Aim, CriticalX_Crit, CloakOfShadows_HPCost, WildTalentMaxPsi,  TenebrousForm_MinDeflectChance, TenebrousForm_MaxDeflectChance, TenebrousForm_MinreflectChance, TenebrousForm_MaxreflectChance, TenebrousForm_ReflectShotHitChance;
var config float BloodyMadness_BonusMult, BloodyMadness_DoTBonus, Obtenebration_DetectMod, Obtenebration_VisionPostMult, TenebrousForm_DeflectScalar, TenebrousForm_reflectScalar, TenebrousForm_LifeSteal, Regenerate_PercentHeal, BladeGrasp_WillMod;
var config bool TenebrousForm_DeflectMelee, TenebrousForm_DeflectAOE, TenebrousForm_reflectMelee, TenebrousForm_reflectAOE, BladeGrasp_DeflectNonMelee, BladeGrasp_DeflectAOE;
var config int ZombieGrenadeTurns, LuckyDayMaxAim, LuckyDayMaxCrit, LuckyNightMaxDodge, LuckyNightMaxMobility, FierceMien_Range, FierceMien_AimMod, FierceMien_DefMod, Unwavering_MaxArmourRestore, BarrierCharger_MaxShieldRestore;
var config int Unscarred_Dmg, Unscarred_DmgPerTier, Unscarred_DRMult, Advice_Cooldown, Advice_Turns, Advice_Crit, Advice_BondmateCrit, BattleCry_Cooldown, BattleCry_Turns, BattleCry_Crit, Regenerate_FlatHeal, Duel_Cooldown;
var config int BladeGrasp_MinDeflect, BladeGrasp_MaxDeflect, AchingBlood_CritDamage, AchingBlood_CritChance, AchingBlood_ChunniNameLength, DefenseShift_Defense, AimShift_Aim, TechShift_Hack, TechShift_HackDef, PsiShift_Psi, LifeShift_HP, SpeedShift_Mobility, SightShift_Vision; 
var config float LongRangeDefense_DefenseMod, LongRangeDefense_DodgeMod, HardenedShield_ShieldDamageResistMod, Shift_BondMateMult;

struct VulnPassiveSetup
{
	var name AbilityName;
	var string IconImage;
	var array<name> DamageTypes;
	var int DamageVulnMin;
	var float DamageVulnMult;
};
var config array<VulnPassiveSetup> VulnPassives;

var localized string TransposeDefenseEffectName, TransposeDefenseEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local VulnPassiveSetup		VulnPassive;
	
	Templates.AddItem(AddTeleportAbility());
	Templates.AddItem(AddBloodTeleportAbility());
	Templates.AddItem(AddBlinkAbility());
	Templates.AddItem(Transposition());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZTransposeDefense', "img:///UILibrary_MZChimeraIcons.Ability_Distortion", 'MZTransposition'));
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZTransposeTimeShift', "img:///UILibrary_MZChimeraIcons.Ability_TemporalShift", 'MZTransposition'));
	
	Templates.AddItem(AddCriticalXAbility());
	Templates.AddItem(AddObtenebration());
	Templates.AddItem(AddWildTalent());
	Templates.AddItem(AddBecomeATerribleThought());
	Templates.AddItem(AddCloakOfShadows());
	Templates.AddItem(AddTenebrousForm());
	Templates.AddItem(AddTenebrousReflect());
	/*>>*/Templates.AddItem(AddTenebrousReflectShot());
	Templates.AddItem(AddBloodiedShroud());
	Templates.AddItem(AddBloodPillar());
	Templates.AddItem(AddPillar());
	Templates.AddItem(AddLuckyDay());
	Templates.AddItem(AddLuckyNight());
	Templates.AddItem(AddUnscarred());
	Templates.AddItem(AddAdvice());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZAdviceSelfToo', "img:///UILibrary_XPACK_Common.PerkIcons.str_highcrit", 'MZAdvice'));
	Templates.AddItem(AddBattleCry());
	Templates.AddItem(AddRegenerate());
	/*>>*/Templates.AddItem(AddRegenerateTrigger());
	Templates.AddItem(Unwavering());
	Templates.AddItem(BarrierCharger());
	Templates.AddItem(AddBladeGrasp());
	Templates.AddItem(AchingBlood());
	Templates.AddItem(FierceMien());
	/*>>*/Templates.AddItem(FierceMienPulse());
	/*>>*/Templates.AddItem(FierceMienEnemyMove());
	Templates.AddItem(class'MZBulletArt_AbilitySet'.static.PrereqPassive('MZFierceMienDefDown', "img:///UILibrary_MZChimeraIcons.Ability_FearFactor", 'MZFierceMien'));
	Templates.AddItem(LongRangeDefense());
	Templates.AddItem(HardedShield());
	Templates.AddItem(AddStatShift('MZDefenseShift', 'MZDefenseShift', eStat_Defense, default.DefenseShift_Defense, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(AddStatShift('MZAimShift', 'MZAimShift', eStat_Offense, default.AimShift_Aim, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(AddStatShift('MZPsiShift', 'MZPsiShift', eStat_PsiOffense, default.PsiShift_Psi, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(AddStatShift('MZLifeShift', 'MZLifeShift', eStat_HP, default.LifeShift_HP, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(AddStatShift('MZSpeedShift', 'MZSpeedShift', eStat_Mobility, default.SpeedShift_Mobility, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(AddStatShift('MZSightShift', 'MZSightShift', eStat_SightRadius, default.SightShift_Vision, "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing"));
	Templates.AddItem(TechShift());
	Templates.AddItem(CreateDuelAbility());
	/*>>*/Templates.AddItem(CreateDuelInitiatedAbility());
	Templates.AddItem(ShieldGate());

	foreach default.VulnPassives(VulnPassive)
	{
		Templates.AddItem(AddVulnPassive(VulnPassive.AbilityName, VulnPassive.IconImage, VulnPassive.DamageTypes, VulnPassive.DamageVulnMin, VulnPassive.DamageVulnMult));
	}

	Templates.AddItem(LastStand());
	/*>>*/Templates.AddItem(LastStandTriggered());

	return Templates;
}

static function X2DataTemplate AddTeleportAbility(name AbilityName = 'MZTeleport')
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityTrigger_PlayerInput InputTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.Teleport_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Movement;

	Template.TargetingMethod = class'X2TargetingMethod_Teleport';

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
//	CursorTarget.FixedAbilityRange = default.Teleport_Range;     // yes there is.
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.CustomFireAnim='HL_MZPsiTeleportStart';
	Template.CustomFireKillAnim='HL_MZPsiTeleportStop';

	Template.ModifyNewContextFn = class'X2Ability_Cyberus'.static.Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = class'X2Ability_Cyberus'.static.Teleport_BuildGameState;
	Template.BuildVisualizationFn = MZTeleport_BuildVisualization;
	
	Template.CinescriptCameraType = "Cyberus_Teleport";
//BEGIN AUTOGENERATED CODE: Template Overrides 'Teleport'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Teleport'

	return Template;
}

static function X2DataTemplate AddBloodTeleportAbility()
{
	local X2AbilityTemplate	Template;
	local Grimy_AbilityCost_HP					HPCost;

	Template = X2AbilityTemplate(AddTeleportAbility('MZBloodTeleport'));
	Template.AbilityCooldown = none;
	Template.AbilityIconColor = "C34144";

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodTeleport_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Template.CustomFireAnim='HL_MZBloodTeleportStart';
	Template.CustomFireKillAnim='HL_MZBloodTeleportStop';

	Template.AbilityShooterConditions.AddItem(new class'MZ_Condition_Concealed');

	return Template;
}

static function X2DataTemplate AddBlinkAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2AbilityTrigger_PlayerInput InputTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBlink');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.Blink_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	Template.ConcealmentRule = eConceal_Always;
	Template.Hostility = eHostility_Movement;

	Template.TargetingMethod = class'X2TargetingMethod_Teleport';

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = false;
	CursorTarget.FixedAbilityRange = default.Blink_Range;     // yes there is.
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.CustomFireAnim='HL_MZPsiTeleportStart';
	Template.CustomFireKillAnim='HL_MZPsiTeleportStop';

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

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
		{
			AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[i]));
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

static function X2AbilityTemplate Transposition()
{
	local X2AbilityTemplate				Template;
	local X2Condition_UnitProperty      EnemyCondition;
	local X2Condition_UnitProperty      FriendCondition;
	local X2Effect_PersistentStatChange		StatChangeEffect;
	local X2Effect_Stunned				StunEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	Template = AddTranspositionAbility('MZTransposition', true, true, default.Transposition_Cooldown);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'MZTransposeDefenseEffect';
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.bRemoveWhenTargetDies = true;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.TransposeDefenseEffectName, default.TransposeDefenseEffectDesc, "img:///UILibrary_MZChimeraIcons.Ability_Distortion", true);
	StatChangeEffect.AddPersistentStatChange(eStat_Defense, default.TransposeDefense_Defense);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZTransposeDefense');
	StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(StatChangeEffect);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.EffectName = 'MZTransposeDefenseEffect';
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.bRemoveWhenTargetDies = true;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.TransposeDefenseEffectName, default.TransposeDefenseEffectDesc, "img:///UILibrary_MZChimeraIcons.Ability_Distortion", true);
	StatChangeEffect.AddPersistentStatChange(eStat_Defense, default.TransposeDefense_Defense);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZTransposeDefense');
	StatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	StatChangeEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(StatChangeEffect);

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.TransposeTimeShift_Stun, 100, false);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	StunEffect.TargetConditions.AddItem(EnemyCondition);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZTransposeTimeShift');
	StunEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(StunEffect);

	return Template;
}
//Transposition is essentialy invert and exchange merged into a single ability, and without a focus cosst.
static function X2AbilityTemplate AddTranspositionAbility(name TemplateName, bool bCanTargetFriendly, bool bCanTargetEnemy, int iCooldown)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		UnitCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

//BEGIN AUTOGENERATED CODE: Template Overrides 'TemplarInvert'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'HL_ExchangeStart';
	Template.ActivationSpeech = 'Invert';
	Template.CinescriptCameraType = "Templar_Invert";
//END AUTOGENERATED CODE: Template Overrides 'TemplarInvert'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Movement;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Relocate";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	if ( iCooldown > 0 )
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = iCooldown;
		Template.AbilityCooldown = Cooldown;
	}

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityToHitOwnerOnMissCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeAlive = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeFriendlyToSource = !bCanTargetFriendly;
	UnitCondition.ExcludeHostileToSource = !bCanTargetEnemy;
	UnitCondition.TreatMindControlledSquadmateAsHostile = false;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.ExcludeLargeUnits = true;
	UnitCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	Template.AbilityTargetConditions.AddItem(TranspositionEffectsCondition());

	Template.BuildNewGameStateFn = Transposition_BuildGameState;
	Template.BuildVisualizationFn = Transposition_BuildVisualization;
	Template.ModifyNewContextFn = class'X2Ability_TemplarAbilitySet'.static.InvertAndExchange_ModifyActivatedAbilityContext;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static simulated function XComGameState Transposition_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState	NewGameState;
	local XComGameState_Unit ShooterUnit, TargetUnit, ShooterOriginalState, TargetOriginalState;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item WeaponState;
	local X2EventManager EventManager;
	local TTile ShooterDesiredLoc;
	local TTile TargetDesiredLoc;
	local XComWorldData WorldData;
	local X2AbilityTemplate AbilityTemplate;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	NewGameState = History.CreateNewGameState(true, Context);
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

	ShooterOriginalState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference));
	TargetOriginalState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference));
	ShooterUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityContext.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();
	if (AbilityContext.InputContext.ItemObject.ObjectID > 0)
	{
		WeaponState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', AbilityContext.InputContext.ItemObject.ObjectID));
	}
	ShooterDesiredLoc = TargetUnit.TileLocation;
	TargetDesiredLoc = ShooterUnit.TileLocation;

	ShooterDesiredLoc.Z = WorldData.GetFloorTileZ(ShooterDesiredLoc, true);
	TargetDesiredLoc.Z = WorldData.GetFloorTileZ(TargetDesiredLoc, true);

	ShooterUnit.SetVisibilityLocation(ShooterDesiredLoc);
	TargetUnit.SetVisibilityLocation(TargetDesiredLoc);

	ShooterUnit.ReserveActionPoints.Length = 0;
	TargetUnit.ReserveActionPoints.Length = 0;

	EventManager = `XEVENTMGR;
	EventManager.TriggerEvent('ObjectMoved', ShooterUnit, ShooterUnit, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', ShooterUnit, ShooterUnit, NewGameState);
	EventManager.TriggerEvent('ObjectMoved', TargetUnit, TargetUnit, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', TargetUnit, TargetUnit, NewGameState);

	//  Apply effects to shooter
	if (AbilityTemplate.AbilityShooterEffects.Length > 0)
	{
		ApplyEffectsToTarget(
			AbilityContext,
			ShooterOriginalState,
			ShooterOriginalState,
			AbilityState,
			ShooterUnit,
			NewGameState,
			AbilityContext.ResultContext.HitResult,
			AbilityContext.ResultContext.ArmorMitigation,
			AbilityContext.ResultContext.StatContestResult,
			AbilityTemplate.AbilityShooterEffects,
			AbilityContext.ResultContext.ShooterEffectResults,
			AbilityTemplate.DataName,
			TELT_AbilityShooterEffects);
	}

	//  Apply effects to primary target
	if (AbilityTemplate.AbilityTargetEffects.Length > 0)
	{
		ApplyEffectsToTarget(
			AbilityContext,
			TargetOriginalState,
			ShooterOriginalState,
			AbilityState,
			TargetUnit,
			NewGameState,
			AbilityContext.ResultContext.HitResult,
			AbilityContext.ResultContext.ArmorMitigation,
			AbilityContext.ResultContext.StatContestResult,
			AbilityTemplate.AbilityTargetEffects,
			AbilityContext.ResultContext.TargetEffectResults,
			AbilityTemplate.DataName,
			TELT_AbilityTargetEffects);
	}
	
	AbilityState.GetMyTemplate().ApplyCost(AbilityContext, AbilityState, ShooterUnit, WeaponState, NewGameState);

	return NewGameState;
}
simulated function Transposition_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		AbilityContext;
	local StateObjectReference				InteractingUnitRef;
	local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local X2Action_MoveVisibleTeleport		CasterTeleport, TargetTeleport;
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action_MoveBegin				CasterMoveBegin, TargetMoveBegin;
	local X2Action_MoveEnd					CasterMoveEnd, TargetMoveEnd;
	local X2AbilityTemplate					AbilityTemplate;
	local int								EffectIndex;
	local name								ApplyResult;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	// move action
	class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, BuildTrack);

	CasterTeleport = X2Action_MoveVisibleTeleport(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveVisibleTeleport', BuildTrack.VisualizeActor));
	CasterTeleport.ParamsStart.AnimName = 'HL_ExchangeStart';
	CasterTeleport.ParamsStop.AnimName = 'HL_ExchangeEnd';
	CasterMoveBegin = X2Action_MoveBegin(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveBegin', BuildTrack.VisualizeActor));
	CasterMoveEnd = X2Action_MoveEnd(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveEnd', BuildTrack.VisualizeActor));

	//If there are effects added to the shooter, add the visualizer actions for them
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, AbilityContext.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));
	}

	//****************************************************************************************
	//Configure the visualization track for the target
	//****************************************************************************************
	InteractingUnitRef = AbilityContext.InputContext.PrimaryTarget;
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
	// move action
	class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, BuildTrack);

	TargetTeleport = X2Action_MoveVisibleTeleport(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveVisibleTeleport', BuildTrack.VisualizeActor));
	TargetTeleport.PlayAnim = false;
	TargetTeleport.WaitForTeleportEvent = true;
	TargetMoveBegin = X2Action_MoveBegin(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveBegin', BuildTrack.VisualizeActor));
	TargetMoveEnd = X2Action_MoveEnd(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveEnd', BuildTrack.VisualizeActor));

	//Add any X2Actions that are specific to this effect being applied
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		ApplyResult = AbilityContext.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

		// Target effect visualization
		if (!AbilityContext.bSkipAdditionalVisualizationSteps)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
		}
	}

	// Jwats: Sync the move begins
	VisMgr.DisconnectAction(TargetMoveBegin);
	VisMgr.ConnectAction(TargetMoveBegin, VisMgr.BuildVisTree, false, , CasterMoveBegin.ParentActions);

	// Jwats: Sync the teleports
	VisMgr.ConnectAction(TargetTeleport, VisMgr.BuildVisTree, false, CasterTeleport);

	// Jwats: Sync the MoveEnds
	VisMgr.ConnectAction(TargetMoveEnd, VisMgr.BuildVisTree, false, CasterMoveEnd);
}

static function X2Condition_UnitEffects TranspositionEffectsCondition()
{
	local X2Condition_UnitEffects ExcludeEffects;

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	ExcludeEffects.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage1EffectName, 'AA_UnitHasCocoonOnIt');
	ExcludeEffects.AddExcludeEffect(class'X2Ability_ChryssalidCocoon'.default.GestationStage2EffectName, 'AA_UnitHasCocoonOnIt');
	ExcludeEffects.AddExcludeEffect('IcarusDropGrabbeeEffect_Sustained', 'AA_UnitIsBound');
	ExcludeEffects.AddExcludeEffect('IcarusDropGrabberEffect', 'AA_UnitIsBound');

	return ExcludeEffects;
}

static function X2AbilityTemplate AddCriticalXAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ToHitModifier        CritModEffect;
	local X2Effect_ToHitModifier        HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCriticalX');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hyperactivepupils";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, default.CriticalX_Aim, Template.LocFriendlyName, , true, true, true, true);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'CriticalX_Aim';
	Template.AddTargetEffect(HitModEffect);

	CritModEffect = new class'X2Effect_ToHitModifier';
	CritModEffect.AddEffectHitModifier(eHit_Crit, default.CriticalX_Crit, Template.LocFriendlyName, , true, true, true, true);
	CritModEffect.BuildPersistentEffect(1, true, false, false);
	CritModEffect.EffectName = 'CriticalX_Crit';
	Template.AddTargetEffect(CritModEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;

}

static function X2AbilityTemplate AddCloakOfShadows()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RangerStealth                StealthEffect;
	local Grimy_AbilityCost_HP				HPCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown						Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZCloakOfShadows');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stealth";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.CloakOfShadows_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CloakOfShadows_Cooldown;
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

static function X2AbilityTemplate AddWildTalent()
{
	local X2AbilityTemplate Template;
	local MZ_Effect_RandomStatChange HolyWarriorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZWildTalent');
	
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.strx_psiresistance";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HolyWarriorEffect = new class'MZ_Effect_RandomStatChange';
	HolyWarriorEffect.DuplicateResponse = eDupe_Allow;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, false);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_PsiOffense, default.WildTalentMaxPsi);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddBecomeATerribleThought()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentTraversalChange	WallPhasing;
	local Grimy_AbilityCost_HP					HPCost;
	local X2Effect_TriggerEvent					ActivationWindowEvent;
	local X2Condition_UnitEffects               EffectsCondition;
	local MZ_Effect_MusashiZeroDetection		DetectDown;
	local X2AbilityCooldown						Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTerribleThought');

	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_wraith";
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Wraith_Armor";
	Template.AbilityIconColor = "C34144";

	Template.AdditionalAbilities.AddItem( 'WraithActivation' );

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	Template.AbilityShooterConditions.AddItem(new class'MZ_Condition_Concealed');

	Template.AbilityTriggers.AddItem( default.PlayerInputTrigger );
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.TerribleThought_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.TerribleThought_Cooldown;
	Template.AbilityCooldown = Cooldown;

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	EffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	ActivationWindowEvent = new class'X2Effect_TriggerEvent';
	ActivationWindowEvent.TriggerEventName = class'X2Ability_ItemGrantedAbilitySet'.default.WraithActivationDurationEventName;
	Template.AddTargetEffect( ActivationWindowEvent );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bSkipPerkActivationActions = true; // we'll trigger related perks as part of the movement action

	WallPhasing = new class'X2Effect_PersistentTraversalChange';
	WallPhasing.BuildPersistentEffect( default.TerribleThought_Turns, false, true, false, eGameRule_PlayerTurnEnd );
	WallPhasing.SetDisplayInfo( ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText( ), Template.IconImage, true );
	WallPhasing.AddTraversalChange( eTraversal_Phasing, true );
	WallPhasing.EffectName = 'PhasingEffect';
	WallPhasing.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect( WallPhasing );

	DetectDown = new class'MZ_Effect_MusashiZeroDetection';
	DetectDown.BuildPersistentEffect( default.TerribleThought_Turns, false, true, false, eGameRule_PlayerTurnEnd );
	DetectDown.DuplicateResponse = eDupe_Refresh;
	DetectDown.EffectName = 'MZTerribleThought';
	Template.AddTargetEffect( DetectDown );
	
	Template.ActivationSpeech = 'ActivateConcealment';

	return Template;
}

static function X2AbilityTemplate AddObtenebration()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent                   Effect;
	local X2Effect_PersistentStatChange			DetectDown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZObtenebration');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDontDisplayInAbilitySummary=false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_phantom";
	Template.AbilityIconColor = "C34144";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_StayConcealed';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	DetectDown = new class'X2Effect_PersistentStatChange';
	DetectDown.BuildPersistentEffect(1, true, false, false);
	DetectDown.DuplicateResponse = eDupe_Refresh;
	DetectDown.AddPersistentStatChange(eStat_DetectionModifier, default.Obtenebration_DetectMod);
	DetectDown.AddPersistentStatChange(eStat_SightRadius, default.Obtenebration_VisionPostMult, MODOP_PostMultiplication);
	Template.AddTargetEffect( DetectDown );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	//Template.bCrossClassEligible = true;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Phantom'
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'Phantom'

	return Template;
}

static function X2AbilityTemplate AddTenebrousForm()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_TenebrousForm                  Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTenebrousForm');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_deflectshot";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.AbilityIconColor = "C34144";
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_TenebrousForm';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.bDeflectMelee = default.TenebrousForm_DeflectMelee;
	Effect.bDeflectAOE = default.TenebrousForm_DeflectAOE;
	Effect.fDeflectScalar= default.TenebrousForm_DeflectScalar;
	Effect.iMinDeflectChance=default.TenebrousForm_MinDeflectChance;
	Effect.iMaxDeflectChance=default.TenebrousForm_MaxDeflectChance;
	Effect.breflectMelee=default.TenebrousForm_reflectMelee;
	Effect.breflectAOE=default.TenebrousForm_reflectAOE;
	Effect.freflectScalar=default.TenebrousForm_reflectScalar;
	Effect.iMaxreflectChance=default.TenebrousForm_MinreflectChance;
	Effect.iMaxreflectChance=default.TenebrousForm_MaxreflectChance;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddTenebrousReflect()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('MZTenebrousReflect', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ReflectShot", , 'eAbilitySource_Psionic');
	Template.AbilityIconColor = "C34144";
	Template.PrerequisiteAbilities.AddItem('MZTenebrousForm');
	Template.AdditionalAbilities.AddItem('MZTenebrousReflectShot');
//BEGIN AUTOGENERATED CODE: Template Overrides 'Reflect'	
	Template.CustomFireAnim = 'HL_Reflect';
//END AUTOGENERATED CODE: Template Overrides 'Reflect'

	return Template;
}

static function X2AbilityTemplate AddTenebrousReflectShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityToHitCalc_PercentChance		ChanceToHit;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ApplyReflectDamage			DamageEffect;
	local MZ_Effect_LifeSteal					LifeStealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTenebrousReflectShot');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ReflectShot";

	ChanceToHit = new class'X2AbilityToHitCalc_PercentChance';
	ChanceToHit.PercentToHit = default.TenebrousForm_ReflectShotHitChance;
	Template.AbilityToHitCalc = ChanceToHit;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.TemplarReflectListener;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	DamageEffect = new class'X2Effect_ApplyReflectDamage';
	DamageEffect.EffectDamageValue.DamageType = 'Psi';
	Template.AddTargetEffect(DamageEffect);

	LifeStealEffect = new class'MZ_Effect_LifeSteal';
	LifeStealEffect.FlatVamp = default.TenebrousForm_LifeSteal;
	Template.AddTargetEffect(LifeStealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.MergeVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.ReflectShotMergeVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'ReflectShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'HL_ReflectFire';
	Template.CustomFireKillAnim = 'HL_ReflectFire';
	//END AUTOGENERATED CODE: Template Overrides 'ReflectShot'

	return Template;
}

static function X2AbilityTemplate AddBloodiedShroud()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_PostCombatHeal		Effect;
	local X2Effect_PersistentStatChange			StatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodiedShroud');

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
	Effect.PercentToHeal = default.BloodiedShroud_PercentToHeal;
	Effect.EffectName = 'MZBloodiedShroud';
	Template.AddTargetEffect(Effect);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(1, true, false, false);
	StatChangeEffect.AddPersistentStatChange(eStat_HP, default.BloodiedShroud_HP);
	Template.AddTargetEffect( StatChangeEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddBloodPillar()
{
	local X2AbilityTemplate				Template;
	local X2AbilityTarget_Cursor		Cursor;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local MZ_Effect_Pillar				PillarEffect;
	local Grimy_AbilityCost_HP			HPCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBloodPillar');

	Template.AbilityIconColor = "C34144";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Pillar';

	Cursor = new class'X2AbilityTarget_Cursor';
	Cursor.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = Cursor;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints=false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	HPCost = new class'Grimy_AbilityCost_HP';
	HPCost.Cost = default.BloodPillar_HPCost;
	Template.AbilityCosts.AddItem(HPCost);

//BEGIN AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZPsi_GhostCast';
	Template.ActivationSpeech = 'Pillar';
//END AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Pillar";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ConcealmentRule = eConceal_Always;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PillarEffect = new class'MZ_Effect_Pillar';
	PillarEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);	
	PillarEffect.DestructibleArchetype = "FX_Templar_Pillar.Pillar_Destructible";
	PillarEffect.Duration = default.BloodPillar_Duration;
	Template.AddShooterEffect(PillarEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.Pillar_BuildVisualization;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;

	return Template;
}

static function X2AbilityTemplate AddPillar()
{
	local X2AbilityTemplate				Template;
	local X2AbilityTarget_Cursor		Cursor;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local MZ_Effect_Pillar				PillarEffect;
	local X2AbilityCooldown				Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPillar');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Pillar';

	Cursor = new class'X2AbilityTarget_Cursor';
	Cursor.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = Cursor;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints=false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PILLAR_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_MZPsi_GhostCast';
	Template.ActivationSpeech = 'Pillar';
//END AUTOGENERATED CODE: Template Overrides 'Pillar'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Pillar";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ConcealmentRule = eConceal_Always;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PillarEffect = new class'MZ_Effect_Pillar';
	PillarEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);	
	PillarEffect.DestructibleArchetype = "FX_Templar_Pillar.Pillar_Destructible";
	PillarEffect.Duration = default.Pillar_Duration;
	Template.AddShooterEffect(PillarEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.Pillar_BuildVisualization;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;

	return Template;
}

static function X2AbilityTemplate AddLuckyDay()
{
	local X2AbilityTemplate Template;
	local MZ_Effect_RandomStatChange HolyWarriorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLuckyDay');
	
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_highcrit";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HolyWarriorEffect = new class'MZ_Effect_RandomStatChange';
	HolyWarriorEffect.DuplicateResponse = eDupe_Allow;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, false);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Offense, default.LuckyDayMaxAim);
	HolyWarriorEffect.AddPersistentStatChange(eStat_CritChance, default.LuckyDayMaxCrit);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddLuckyNight()
{
	local X2AbilityTemplate Template;
	local MZ_Effect_RandomStatChange HolyWarriorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLuckyNight');
	
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_agile";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HolyWarriorEffect = new class'MZ_Effect_RandomStatChange';
	HolyWarriorEffect.DuplicateResponse = eDupe_Allow;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, false);
	HolyWarriorEffect.bRemoveWhenTargetDies = true;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Dodge, default.LuckyNightMaxDodge);
	HolyWarriorEffect.AddPersistentStatChange(eStat_Mobility, default.LuckyNightMaxMobility);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddUnscarred() 
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_Unscarred	DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZUnscarred');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defend_health";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'MZ_Effect_Unscarred';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = default.Unscarred_Dmg;
	DamageEffect.PerTier = default.Unscarred_DmgPerTier;
	DamageEffect.DRMult = default.Unscarred_DRMult;
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2DataTemplate AddAdvice()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		UnitPropertyCondition;
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Condition_UnitEffects		UnitEffectsCondition;
	local X2AbilityTarget_Single		SingleTarget;
	local X2AbilityTrigger_PlayerInput	InputTrigger;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_ToHitModifier		HitModEffect;
	local X2Condition_AbilityProperty		TraumaCondition;
	local MZ_Condition_IsBondMate				NotBondmateCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAdvice');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_highcrit";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Neutral;

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.Advice_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// The shooter cannot be mind controlled
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeTurret = true;
	UnitPropertyCondition.RequireWithinRange = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	// Target must be visible and may not use squad sight
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//// Create the Marked effect
	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Crit, default.Advice_Crit, Template.LocFriendlyName, , true, true, true, true);
	HitModEffect.BuildPersistentEffect(default.Advice_Turns, false, false, false, eGameRule_PlayerTurnBegin);
	HitModEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	HitModEffect.EffectName = 'AdviceCrit';
	NotBondmateCondition = new class'MZ_Condition_IsBondMate';
	NotBondmateCondition.Nope = true;
	HitModEffect.TargetConditions.AddItem(NotBondmateCondition);
	Template.AddTargetEffect(HitModEffect);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Crit, default.Advice_BondmateCrit, Template.LocFriendlyName, , true, true, true, true);
	HitModEffect.BuildPersistentEffect(default.Advice_Turns, false, false, false, eGameRule_PlayerTurnBegin);
	HitModEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	HitModEffect.EffectName = 'AdviceCrit';
	HitModEffect.TargetConditions.AddItem(new class'MZ_Condition_IsBondMate');
	Template.AddTargetEffect(HitModEffect);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Crit, default.Advice_Crit, Template.LocFriendlyName, , true, true, true, true);
	HitModEffect.BuildPersistentEffect(default.Advice_Turns, false, false, false, eGameRule_PlayerTurnBegin);
	HitModEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	HitModEffect.EffectName = 'AdviceCrit';
	TraumaCondition = new class'X2Condition_AbilityProperty';
	TraumaCondition.OwnerHasSoldierAbilities.AddItem('MZAdviceSelfToo');
	HitModEffect.TargetConditions.AddItem(TraumaCondition);
	Template.AddShooterEffect(HitModEffect);

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
//BEGIN AUTOGENERATED CODE: Template Overrides 'MarkTarget'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'MarkTarget'
	
	return Template;
}

static function X2DataTemplate AddBattleCry()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitEffects		UnitEffectsCondition;
	local X2AbilityTrigger_PlayerInput	InputTrigger;
	local X2AbilityCooldown				Cooldown;
	local MZ_Effect_BattleCry		HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBattleCry');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_WarCry";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Neutral;

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.BattleCry_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// The shooter cannot be mind controlled
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//// Create the Marked effect
	HitModEffect = new class'MZ_Effect_BattleCry';
	HitModEffect.CritMod = default.BattleCry_Crit;
	HitModEffect.BuildPersistentEffect(default.BattleCry_Turns, false, false, false, eGameRule_PlayerTurnBegin);
	HitModEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	HitModEffect.EffectName = 'MZBattleCry';
	Template.AddTargetEffect(HitModEffect);
	
	Template.CustomFireAnim = 'HL_SignalAngry';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
//BEGIN AUTOGENERATED CODE: Template Overrides 'MarkTarget'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'MarkTarget'
	
	return Template;
}

static function X2AbilityTemplate AddRegenerate()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('MZRegenerate', "img:///UILibrary_PerkIcons.UIPerk_regeneration", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('MZRegenerateTrigger');

	return Template;
}
static function X2AbilityTemplate AddRegenerateTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local MZ_Effect_HealMissingHealth		HealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRegenerateTrigger');

	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_regeneration";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	//Heal or Regen on Self.
	HealEffect = new class'MZ_Effect_HealMissingHealth';
	HealEffect.PercentHeal = default.Regenerate_PercentHeal;
	HealEffect.FlatHeal = default.Regenerate_FlatHeal;
	Template.AddTargetEffect(HealEffect);
	
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate Unwavering() 
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_AutoMendArmour		ArmourEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZUnwavering');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ArmourEffect = new class'MZ_Effect_AutoMendArmour';
	ArmourEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	ArmourEffect.DeShredPerTurn = 1;
	If ( default.Unwavering_MaxArmourRestore > 0 )
	{
		ArmourEffect.MaxDeShred = default.Unwavering_MaxArmourRestore;
	}
	ArmourEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(ArmourEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate BarrierCharger() 
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_AutoMendShield		ShieldEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBarrierCharger');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Generator";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ShieldEffect = new class'MZ_Effect_AutoMendShield';
	ShieldEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	ShieldEffect.HealAmount = 1;
	If ( default.BarrierCharger_MaxShieldRestore > 0 )
	{
		ShieldEffect.MaxHealAmount = default.BarrierCharger_MaxShieldRestore;
	}
	ShieldEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(ShieldEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddBladeGrasp()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_BladeGrasp                  Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZBladeGrasp');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_deflectshot";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_BladeGrasp';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.WillMod = default.BladeGrasp_WillMod;
	Effect.MinDeflect = default.BladeGrasp_MinDeflect;
	Effect.MaxDeflect = default.BladeGrasp_MaxDeflect;
	Effect.bDeflectNonMelee = default.BladeGrasp_DeflectNonMelee;
	Effect.bDeflectAOE = default.BladeGrasp_DeflectAOE;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate FierceMien()
{
	local X2AbilityTemplate						Template;
	Template = PurePassive('MZFierceMien', "img:///UILibrary_MZChimeraIcons.Ability_FearFactor", false);
	Template.AdditionalAbilities.AddItem('MZFierceMienPulse');
	Template.AdditionalAbilities.AddItem('MZFierceMienEnemyMove');

	return Template;
}
static function X2AbilityTemplate FierceMienPulse()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local MZ_Effect_FierceMien				Effect;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2Condition_UnitProperty			ExcludeSquadmatesCondition, SourceNotConcealedCondition;
	local X2Condition_UnitEffects			UnitEffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFierceMienPulse');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_FearFactor";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	// Don't trigger if the unit has vanished
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('Vanish', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect('VanishingWind', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_Burrowed'.default.EffectName, 'AA_UnitIsBurrowed');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius =  1.5 * default.FierceMien_Range;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	ExcludeSquadmatesCondition = new class'X2Condition_UnitProperty';
	ExcludeSquadmatesCondition.ExcludeSquadmates = true;
	Template.AbilityMultiTargetConditions.AddItem(ExcludeSquadmatesCondition);

	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('MZFierceMien', 'AA_DuplicateEffectIgnored');
	Template.AbilityMultiTargetConditions.AddItem(BladestormTargetCondition);

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

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);

	Effect = new class'MZ_Effect_FierceMien';
	Effect.EffectRangeSquared = default.FierceMien_Range * default.FierceMien_Range;
	Effect.AimMod = default.FierceMien_AimMod;
	Effect.DefMod = default.FierceMien_DefMod;
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.EffectName = 'MZFierceMien';
	Template.AddMultiTargetEffect(Effect);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Movement;

	return Template;
}
static function X2AbilityTemplate FierceMienEnemyMove()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local MZ_Effect_FierceMien				Effect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2Condition_UnitProperty          SourceNotConcealedCondition, TargetCondition, ExcludeSquadmatesCondition;
	local X2Condition_UnitEffects			UnitEffectsCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFierceMienEnemyMove');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage ="img:///UILibrary_MZChimeraIcons.Ability_FearFactor";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//  trigger on movement. this trigger only needs to cover enemies moving into range.
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	//Trigger.ListenerData.EventID = 'UnitMoveFinished'; //prolly only relevent if it ends it's move within range?
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = default.FierceMien_Range * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Adding exclusion condition to prevent friendly bladestorm fire when panicked.
	ExcludeSquadmatesCondition = new class'X2Condition_UnitProperty';
	ExcludeSquadmatesCondition.ExcludeSquadmates = true;
	Template.AbilityTargetConditions.AddItem(ExcludeSquadmatesCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	// Don't trigger if the unit has vanished
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('Vanish', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect('VanishingWind', 'AA_UnitIsConcealed');
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_Burrowed'.default.EffectName, 'AA_UnitIsBurrowed');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.bAllowBonusWeaponEffects = false;

	//no point creating an extra gamestate to do nothing.
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('MZFierceMien', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	Effect = new class'MZ_Effect_FierceMien';
	Effect.EffectRangeSquared = default.FierceMien_Range * default.FierceMien_Range;
	Effect.AimMod = default.FierceMien_AimMod;
	Effect.DefMod = default.FierceMien_DefMod;
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.EffectName = 'MZFierceMien';
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.Hostility = eHostility_Movement;

	//BEGIN AUTOGENERATED CODE: Template Overrides 'BladestormAttack'
	Template.bFrameEvenWhenUnitIsHidden = true;
	//END AUTOGENERATED CODE: Template Overrides 'BladestormAttack'

	return Template;
}

static function X2AbilityTemplate AchingBlood()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ChunniWeaponBonus           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZAchingBlood');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_highcrit";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_ChunniWeaponBonus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.ChunniNameLength = default.AchingBlood_ChunniNameLength;
	Effect.CritChance = default.AchingBlood_CritChance;
	Effect.CritDamage = default.AchingBlood_CritDamage;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate LongRangeDefense()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_DistanceAimBonus           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLongRangeDefense');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Distortion";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_DistanceAimBonus';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.DefMod = default.LongRangeDefense_DefenseMod;
	Effect.DodgeMod = default.LongRangeDefense_DodgeMod;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate HardedShield()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ShieldResistsDamage           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZHardenedShield');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_resilience";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_ShieldResistsDamage';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.ResistDamageMod = default.HardenedShield_ShieldDamageResistMod;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddStatShift(name TemplateName, name EffectName, ECharStatType StatType, int StatBoost, string IconImage)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         Effect;
	local MZ_Condition_IsBondMate				NotBondmateCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = IconImage;
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(StatType, -StatBoost);
	Effect.EffectName = EffectName;
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(StatType, StatBoost);
	Effect.EffectName = EffectName;
	Effect.DuplicateResponse = eDupe_Ignore;
	NotBondmateCondition = new class'MZ_Condition_IsBondMate';
	NotBondmateCondition.Nope = true;
	Effect.TargetConditions.AddItem(NotBondmateCondition);
	Template.AddMultiTargetEffect(Effect);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(StatType, Round(default.Shift_BondMateMult * StatBoost));
	Effect.EffectName = EffectName;
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.TargetConditions.AddItem(new class'MZ_Condition_IsBondMate');
	Template.AddMultiTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate TechShift()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         Effect;
	local MZ_Condition_IsBondMate				NotBondmateCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZTechShift');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_NetworkHealing";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Hacking, -default.TechShift_Hack);
	Effect.AddPersistentStatChange(eStat_HackDefense, -default.TechShift_HackDef);
	Effect.EffectName = 'MZTechShift';
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Hacking, default.TechShift_Hack);
	Effect.AddPersistentStatChange(eStat_HackDefense, default.TechShift_HackDef);
	Effect.EffectName = 'MZTechShift';
	Effect.DuplicateResponse = eDupe_Ignore;
	NotBondmateCondition = new class'MZ_Condition_IsBondMate';
	NotBondmateCondition.Nope = true;
	Effect.TargetConditions.AddItem(NotBondmateCondition);
	Template.AddMultiTargetEffect(Effect);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.AddPersistentStatChange(eStat_Hacking, Round(default.Shift_BondMateMult * default.TechShift_Hack));
	Effect.AddPersistentStatChange(eStat_HackDefense, Round(default.Shift_BondMateMult *default.TechShift_HackDef));
	Effect.EffectName = 'MZTechShift';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.TargetConditions.AddItem(new class'MZ_Condition_IsBondMate');
	Template.AddMultiTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2DataTemplate CreateDuelAbility()
{
	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2Condition_UnitProperty					UnitPropertyCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Condition_UnitEffects					UnitEffectsCondition;
	local X2Condition_UnitValue						IsNotImmobilized;
	local MZ_Effect_Duel							ToHitModifier;
	local X2Condition_UnitEffectsWithAbilitySource	EffectsWithSourceCondition;
	local X2Condition_UnitEffectsWithAbilityTarget	EffectsWithTargetCondition;
	local array<name> SkipExclusions;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDuel');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_DualSword";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;
	Template.AdditionalAbilities.AddItem('MZDuelInitiated');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.bShowActivation = true;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Duel_Cooldown;
	Template.AbilityCooldown = Cooldown;

	// The shooter cannot be mind controlled
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Shooter and target cannot already be dueling
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('MZDuelShooter', 'AA_DuplicateEffectIgnored');
	UnitEffectsCondition.AddExcludeEffect('MZDuelTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect('MZDuelShooter', 'AA_DuplicateEffectIgnored');
	UnitEffectsCondition.AddExcludeEffect('MZDuelTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityTargetConditions.AddItem(IsNotImmobilized);

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Target must be visible and may use squad sight
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');

	// Create the Duel effects
	EffectsWithSourceCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	EffectsWithSourceCondition.AddRequireEffect('MZDuelTarget', 'AA_MissingRequiredEffect');
	ToHitModifier = new class'MZ_Effect_Duel';
	ToHitModifier.DuplicateResponse = eDupe_Ignore;
	ToHitModifier.EffectName = 'MZDuelShooter';
	ToHitModifier.BuildPersistentEffect(1, true);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	ToHitModifier.AddEffectHitModifier( eHit_Success, 100, Template.LocFriendlyName );
	ToHitModifier.AddEffectHitModifier( eHit_Success, 100, Template.LocFriendlyName, class'X2AbilityToHitCalc_StandardMelee' );
	ToHitModifier.ToHitConditions.AddItem(EffectsWithSourceCondition);
	ToHitModifier.bRemoveWhenSourceDies = true;
	ToHitModifier.bRemoveWhenTargetDies = true;
	//ToHitModifier.bRemoveWhenSourceUnconscious = true;
	//ToHitModifier.bRemoveWhenTargetUnconscious = true;
	Template.AddShooterEffect(ToHitModifier);

	EffectsWithTargetCondition = new class'X2Condition_UnitEffectsWithAbilityTarget';
	EffectsWithTargetCondition.AddRequireEffect('MZDuelTarget', 'AA_MissingRequiredEffect');
	ToHitModifier = new class'MZ_Effect_Duel';
	ToHitModifier.DuplicateResponse = eDupe_Ignore;
	ToHitModifier.EffectName = 'MZDuelTarget';	//perk will add both target and shooter VFX
	ToHitModifier.BuildPersistentEffect(1, true);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	ToHitModifier.AddEffectHitModifier(eHit_Success, 100, Template.LocFriendlyName);
	ToHitModifier.AddEffectHitModifier( eHit_Success, 100, Template.LocFriendlyName, class'X2AbilityToHitCalc_StandardMelee' );
	ToHitModifier.ToHitConditions.AddItem(EffectsWithTargetCondition);
	ToHitModifier.bRemoveWhenSourceDies = true;
	ToHitModifier.bRemoveWhenTargetDies = true;
	//ToHitModifier.bRemoveWhenSourceUnconscious = true;
	//ToHitModifier.bRemoveWhenTargetUnconscious = true;
	ToHitModifier.EffectRemovedFn = DuelTargetEffect_Removed; //must remove the duel shooter effect when the target effect is removed from the target
	Template.AddTargetEffect(ToHitModifier);

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Duel_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
	Template.bFrameEvenWhenUnitIsHidden = true;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//Template.ActivationSpeech = 'AbilDuel';

	return Template;
}
//DuelTargetEffect_Removed
//removes the duel shooter effect from the shooter if the duel target effect is removed ( when the target dies for example )
static function DuelTargetEffect_Removed(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Effect EffectState;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		if (UnitState == none)
		{
			`RedScreen("DuelTargetEffect_Removed could not find source unit.");
			return;
		}
	}
	EffectState = UnitState.GetUnitAffectedByEffectState('MZDuelShooter');
	if( EffectState != None && !EffectState.bRemoved )
	{
		EffectState.RemoveEffect(NewGameState, NewGameState, true); //Cleansed
	}
}
simulated function Duel_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				ShooterUnitRef;
	local StateObjectReference				TargetUnitRef;
	local XComGameState_Ability				Ability;
	local X2AbilityTemplate					AbilityTemplate;
	local AbilityInputContext				AbilityContext;
	local VisualizationActionMetadata		EmptyTrack;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;	
	local X2Action_PlayAnimation            PlayAnimation;
	local Actor								TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface				TargetVisualizerInterface, ShooterVisualizerInterface;
	local int								EffectIndex;
	local name								ApplyResult;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	AbilityContext = Context.InputContext;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ShooterUnitRef = Context.InputContext.SourceObject;
	ShooterVisualizer = History.GetVisualizer(ShooterUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(ShooterUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShooterUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(ShooterUnitRef.ObjectID);

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

//	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
//	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = ( AbilityTemplate != None && AbilityTemplate.CustomFireAnim != '' ) ? AbilityTemplate.CustomFireAnim: 'FF_Duel';

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Source effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, ActionMetadata, ApplyResult);
		}
	}

	if (ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

	//****************************************************************************************
	//Configure the visualization track for the target
	//****************************************************************************************
	TargetUnitRef = Context.InputContext.PrimaryTarget;
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Target effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);
		}

		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
	//****************************************************************************************
}
// THIS IS A BOGUS ABILITY
// only used for AI code to verify that a particular target was targeted by the shooter for a duel
static function X2AbilityTemplate CreateDuelInitiatedAbility()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitEffectsWithAbilitySource	EffectsWithSourceCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZDuelInitiated');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_inspire";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 100;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//must have initiated a duel with the target
	EffectsWithSourceCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	EffectsWithSourceCondition.AddRequireEffect('MZDuelTarget', 'AA_MissingRequiredEffect');
	Template.AbilityTargetConditions.AddItem(EffectsWithSourceCondition);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = None;

	return Template;
}

static function X2AbilityTemplate ShieldGate()
{
	local X2AbilityTemplate						Template;
	local MZ_Effect_ShieldGate           Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZShieldGate');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Distortion";
	Template.AbilitySourceName = 'eAbilitySource_Passive';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	Effect = new class'MZ_Effect_ShieldGate';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate AddVulnPassive(name TemplateName, string IconImage, array<name> DamageTypes, int DamageMin, float DamageMult)
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_VulnDamageType      Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.IconImage = IconImage;
	Template.AbilitySourceName = 'eAbilitySource_Debuff';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
		
	Effect = new class'MZ_Effect_VulnDamageType';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Effect.FireDamageTypes = DamageTypes;
	Effect.ExtraFireDamageMult = DamageMult;
	Effect.ExtraFireDamageMin = DamageMin;
	Effect.EffectName = TemplateName;
	Effect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate LastStand()
{
	local X2AbilityTemplate             Template;
	local MZ_Effect_LastStand              SustainEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLastStand');

	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_LastStand";
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SustainEffect = new class'MZ_Effect_LastStand';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SustainEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.AdditionalAbilities.AddItem('MZLastStandTriggered');

	return Template;
}
static function X2DataTemplate LastStandTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventTrigger;
	local X2Effect_RemoveEffects				MentalEffectRemovalEffect;
	local X2Effect_SkirmisherInterrupt		InterruptEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZLastStandTriggered');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_LastStand";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

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

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'MZLastStandTriggered';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MentalEffectRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	MentalEffectRemovalEffect.DamageTypes.Length = 0;		//	don't let an immunity to "mental" effects resist this cleanse
	Template.AddTargetEffect(MentalEffectRemovalEffect);

	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType());

	InterruptEffect = new class'X2Effect_SkirmisherInterrupt';
	InterruptEffect.BuildPersistentEffect(1, false, , , eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(InterruptEffect);

	//Template.PostActivationEvents.AddItem(class'X2Effect_Sustain'.default.SustainTriggeredEvent);
		
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}