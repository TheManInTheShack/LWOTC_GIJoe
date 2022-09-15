//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_MitzrutiPerkPack.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_MitzrutiPerkPack extends X2DownloadableContentInfo config(MZPerkPack);

var config int HOSTAGE_DURATION, HOSTAGE_CHANCE, SABOTAGE_CHANCE;
var config float AIRBURST_RADIUS;
var config int REACTION_ARMOR, REACTION_ARMOR_DURATION, INTIMIDATION_BONUS;
var config array<name> GUNPOINT_SKILLS;

var config array<name> HEALING_SKILLS, SUPPRESSION_SKILLS;

var config int BLINDSUPPRESS_NUM_TURNS, CONFUSESUPPRESS_NUM_TURNS, CONFUSESUPPRESS_CHANCE, BURNSUPPRESS_DAMAGE, BURNSUPPRESS_SPREAD, PANICSUPPRESS_NUM_TURNS, PANICSUPPRESS_CHANCE;
var config float BLINDSUPPRESS_SIGHTRADIUS_POSTMULTAMOUNT;

var config bool AllowCrossClassAbilities;
var config array<name> ExtraCrossClassAbilities, AddRayzeelAbility, AddClearTranquilToAbility;

static event OnPostTemplatesCreated()
{
	
	`LOG("Mitzruti Perk Pack OPTC Start");
	UpdateAbilities();

	class'MZBloodMagic_AbilitySet'.static.AddCurseToAbilities();
	class'MZShield_AbilitySet'.static.ModifyShieldWall();
	class'MZGremlin_AbilitySet'.static.AddBonusEffectsToGremlinAbilities();
	class'MZGrenade_AbilitySet'.static.AddEffectsToGrenades();
	class'MZHolotargeter_AbilitySet'.static.AddEffectsToHoloAbilities();
	//class'MZArcthrower_AbilitySet'.static.AddEffectsToArcthrowerAbilities(); doesn't do anything atm.
	if (class'MZZFocus_AbilitySet'.default.AddFocusCostToAbility.length > 0 || class'MZZFocus_AbilitySet'.default.PatchFocusCostOnAbility.length > 0)
	{
		class'MZZFocus_AbilitySet'.static.PatchFocusCosts();
	}

	if (class'MZ_Helper_Restrict'.default.PsiAim_TargetSkills.length > 0 || class'MZ_Helper_Restrict'.default.PsiAim_TargetReactionSkills.length > 0 || class'MZ_Helper_Restrict'.default.PsiAim_CursorSkills.length > 0)
	{
		class'MZ_Helper_Restrict'.static.ApplyPsiAimToSkills();
	}
	class'MZ_Helper_Restrict'.static.CreatePsiCritDamage(); //Actually the handling for storm shock and fanfire anims.
	`LOG("Mitzruti Perk Pack OPTC Complete");
}

static function GunPointActionPoints(X2AbilityTemplate Template, name ActionPointName)
{
	local int i;
	local X2AbilityCost_ActionPoints ActionPointsCost;
	
	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		ActionPointsCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointsCost != None) {
			ActionPointsCost.AllowedTypes.AddItem(ActionPointName);
			break;
		}
	}
}

static function UpdateAbilities()
{
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate, PistolAbility;
	local X2Condition_AbilityProperty			AbilityCondition;
	local MZ_Effect_DisableWeapon				DisableEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Effect_GenerateCover				CoverEffect;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local name									AbilityName;
	local X2Effect_GrantActionPoints			ActionPointEffect;
	local Grimy_AbilityCost_Reload				AbilityCost;
	local X2Effect_Burning						BurningEffect;
	local X2Effect_PersistentStatChange			PoisonedEffect, PersistentStatChangeEffect;
	local X2Effect_Blind						BlindEffect;
	local X2Effect_PersistentStatChange			ConfuseEffect;
	local X2Effect_Panicked						PanickedEffect;
	local X2Effect_Persistent					MarkedEffect;
	local X2Effect_ManualOverride				ChronoEffect;
	local int									i;
	local MZ_Effect_MultiAbilityDamage			FuseDamageEffect;
	
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//  ANARCHIST
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');

	AbilityTemplate = AbilityManager.FindAbilityTemplate('CombatProtocol');
	DisableEffect = new class'MZ_Effect_DisableWeapon';
	DisableEffect.ApplyChance = 100;
	DisableEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(DisableEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyHostageProtocol');
	
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.HOSTAGE_DURATION, default.HOSTAGE_CHANCE);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(StunnedEffect);
	
	CoverEffect = new class'X2Effect_GenerateCover';
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnEnd);
	CoverEffect.bRemoveWhenTargetDies = true;
	CoverEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(CoverEffect);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('CapacitorDischarge');
	AbilityTemplate.AddMultiTargetEffect(DisableEffect);

	AbilityTemplate = Abilitymanager.FindAbilityTemplate('LaunchGrenade');
	RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
	if ( RadiusMultiTarget != none ) {
		RadiusMultiTarget.AddAbilityBonusRadius('GrimyAirBurst', default.AIRBURST_RADIUS);
		AbilityTemplate.AbilityMultiTargetStyle = RadiusMultiTarget;
	}

	AbilityTemplate = Abilitymanager.FindAbilityTemplate('IRI_FireRocket');
	if ( AbilityTemplate != none )
	{
		RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
		if ( RadiusMultiTarget != none ) {
			RadiusMultiTarget.AddAbilityBonusRadius('GrimyAirBurst', default.AIRBURST_RADIUS);
			AbilityTemplate.AbilityMultiTargetStyle = RadiusMultiTarget;
		}
	}

	//BRUISER stuff.
	//gunpoint AP cost changes
	foreach default.GUNPOINT_SKILLS(AbilityName){
		if (AbilityManager.FindAbilityTemplate(AbilityName) != none)
		{
			GunpointActionPoints(AbilityManager.FindAbilityTemplate(AbilityName), 'GrimyGunpoint');
		}
	}

	// Reaction Ability Edits
	PistolAbility = AbilityManager.FindAbilityTemplate('PistolReturnFire');

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySpotter');
	MarkedEffect = class'X2StatusEffects'.static.CreateMarkedEffect(2, false);
	MarkedEffect.bApplyOnMiss = true;
	MarkedEffect.TargetConditions.AddItem(AbilityCondition);

	PistolAbility.AddTargetEffect(MarkedEffect);

	// Intimidation Effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyIntimidationPassive');
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.INTIMIDATION_BONUS);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);

	PistolAbility.AddTargetEffect(PersistentStatChangeEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySurvival');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(default.REACTION_ARMOR_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.REACTION_ARMOR);
	PersistentStatChangeEffect.bApplyOnMiss = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	
	PistolAbility.AddShooterEffect(PersistentStatChangeEffect);

	// FURY
	AbilityTemplate = AbilityManager.FindAbilityTemplate('Reload');
	AbilityCost = new class'Grimy_AbilityCost_Reload';
	AbilityCost.bConsumeAllPoints = false;
	AbilityCost.AllowedTypes.AddItem('WOTC_APA_TraverseFireAction');
	AbilityCost.AllowedTypes.AddItem('WOTC_APA_SustainedFireAction');
	AbilityCost.BonusType = 'Strafe';
	AbilityCost.BonusPassive = 'GrimySustainedFire';
	AbilityTemplate.AbilityCosts.length = 0;
	AbilityTemplate.AbilityCosts.AddItem(AbilityCost);

	AbilityTemplate = AbilityManager.FindAbilityTemplate('Overwatch');
	AbilityCost = new class'Grimy_AbilityCost_Reload';
	AbilityCost.bConsumeAllPoints = true;
	AbilityCost.bFreeCost = true;
	AbilityCost.DoNotConsumeAllEffects.Length = 0;
	AbilityCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	AbilityCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	AbilityCost.AllowedTypes.AddItem('WOTC_APA_TraverseFireAction');
	AbilityCost.AllowedTypes.AddItem('WOTC_APA_SustainedFireAction');
	AbilityCost.BonusType = 'Strafe';
	AbilityCost.BonusPassive = 'GrimySustainedFire';

	for (i = 0; i < AbilityTemplate.AbilityCosts.Length; i++)
    {
        if ( X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]) != none )
        {
			AbilityTemplate.AbilityCosts[i] = AbilityCost;
			break;
        }
    }
	
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyReinvigorate');
	ActionPointEffect.TargetConditions.AddItem(AbilityCondition);
	foreach default.HEALING_SKILLS(AbilityName) {
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		if ( AbilityTemplate !=none)
		{
			if ( AbilityTemplate.AbilityTargetEffects.length > 0 ) {
				AbilityTemplate.AddTargetEffect(ActionPointEffect);
			}
			if ( AbilityTemplate.AbilityMultiTargetEffects.length > 0 ) {
				AbilityTemplate.AddMultiTargetEffect(ActionPointEffect);
			}
			if ( AbilityTemplate.AbilityShooterEffects.length > 0 ) {
				AbilityTemplate.AddShooterEffect(ActionPointEffect);
			}
		}
	}

	// This fixes Arc wave causing an unessecary extra rend to show up when used with PZMelee
	AbilityTemplate = AbilityManager.FindAbilityTemplate('ArcWave');
	AbilityTemplate.OverrideAbilities.AddItem('PsiOpRend');

	// Perks apply extra status effects to suppressed targets
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBlindingSuppression');
	BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(default.BLINDSUPPRESS_NUM_TURNS, default.BLINDSUPPRESS_SIGHTRADIUS_POSTMULTAMOUNT);
	BlindEffect.ApplyChance = 100;
	BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.BLINDSUPPRESS_SIGHTRADIUS_POSTMULTAMOUNT, MODOP_PostMultiplication);
	BlindEffect.TargetConditions.AddItem(AbilityCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBurningSuppression');
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BURNSUPPRESS_DAMAGE,default.BURNSUPPRESS_SPREAD);
	BurningEffect.TargetConditions.AddItem(AbilityCondition);
	AbilityTemplate.AddTargetEffect(BurningEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZConfusingSuppression');
	ConfuseEffect = class'X2StatusEffects'.static.CreateConfusedStatusEffect(default.CONFUSESUPPRESS_NUM_TURNS);
	ConfuseEffect.ApplyChance = default.CONFUSESUPPRESS_CHANCE;
	ConfuseEffect.TargetConditions.AddItem(AbilityCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZDisablingSuppression');
	DisableEffect = new class'MZ_Effect_DisableWeapon';
	DisableEffect.ApplyChance = 100;
	DisableEffect.TargetConditions.AddItem(AbilityCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZPanicSuppression');
	PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanickedEffect.ApplyChance = default.PANICSUPPRESS_CHANCE;
	PanickedEffect.iNumTurns = default.PANICSUPPRESS_NUM_TURNS;
	PanickedEffect.TargetConditions.AddItem(AbilityCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZPoisoningSuppression');
	PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	PoisonedEffect.ApplyChance = 100;
	PoisonedEffect.TargetConditions.AddItem(AbilityCondition);
	
	foreach default.SUPPRESSION_SKILLS(AbilityName){
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		If ( AbilityTemplate != none )
		{
			if ( AbilityTemplate.AbilityMultiTargetEffects.length > 0 ) {
				AbilityTemplate.AddMultiTargetEffect(BlindEffect);
				AbilityTemplate.AddMultiTargetEffect(BurningEffect);
				AbilityTemplate.AddMultiTargetEffect(ConfuseEffect);
				AbilityTemplate.AddMultiTargetEffect(DisableEffect);
				AbilityTemplate.AddMultiTargetEffect(PoisonedEffect);
				AbilityTemplate.AddMultiTargetEffect(PanickedEffect);
			
			}
			AbilityTemplate.AddTargetEffect(BlindEffect);
			AbilityTemplate.AddTargetEffect(BurningEffect);
			AbilityTemplate.AddTargetEffect(ConfuseEffect);
			AbilityTemplate.AddTargetEffect(DisableEffect);
			AbilityTemplate.AddTargetEffect(PanickedEffect);
			AbilityTemplate.AddTargetEffect(PoisonedEffect);
		}
	}

	if (default.ExtraCrossClassAbilities.length != 0 && default.AllowCrossClassAbilities)
	{
		foreach default.ExtraCrossClassAbilities(AbilityName){
			AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
			If( AbilityTemplate != none ){	AbilityTemplate.bCrossClassEligible = true;	}
		}
	}

	if (default.AddRayzeelAbility.Length != 0)
	{
		foreach default.AddRayzeelAbility(AbilityName){
			AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
			If( AbilityTemplate != none ){	AbilityTemplate.PostActivationEvents.AddItem('MZRayzeelSong');	}
		}
	}

	if (default.AddClearTranquilToAbility.Length != 0)
	{
		foreach default.AddClearTranquilToAbility(AbilityName){
			AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
			If( AbilityTemplate != none ){
				//Clear Tranquil Effect
				ChronoEffect = new class'X2Effect_ManualOverride';
				AbilityCondition = new class'X2Condition_AbilityProperty';
				AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZClearTranquil');
				ChronoEffect.TargetConditions.AddItem(AbilityCondition);
				AbilityTemplate.AddTargetEffect(ChronoEffect);
			}
		}
	}

	foreach class'MZKnife_AbilitySet'.default.AMBULANCE_SKILLS(AbilityName){
		if (AbilityManager.FindAbilityTemplate(AbilityName) != none)
		{
			GunpointActionPoints(AbilityManager.FindAbilityTemplate(AbilityName), 'MZAmbulance');
		}
	}


	AbilityTemplate = AbilityManager.FindAbilityTemplate('Fuse');
	if(AbilityTemplate != none )
	{
		if ( class'MZPsiAmp_AbilitySet'.default.bPatchNormalFuse )
		{
			//Add damage boosting debuff
			FuseDamageEffect = new class'MZ_Effect_MultiAbilityDamage';
			FuseDamageEffect.BuildPersistentEffect(0, false, false, false, eGameRule_PlayerTurnBegin);
			FuseDamageEffect.AbilityNames.AddItem( 'GrenadeFuse');
			FuseDamageEffect.AbilityNames.AddItem( 'RocketFuse');
			FuseDamageEffect.AbilityNames.AddItem( 'MicroMissleFuse');
			FuseDamageEffect.Bonus = class'MZPsiAmp_AbilitySet'.default.Fuse_BonusMult;
			FuseDamageEffect.DuplicateResponse=eDupe_Refresh;
			//FuseDamageEffect.SetDisplayInfo(ePerkBuff_Penalty, AbilityTemplate.LocFriendlyName, AbilityTemplate.GetMyLongDescription(), AbilityTemplate.IconImage, true,,AbilityTemplate.AbilitySourceName);
			AbilityTemplate.AddTargetEffect(FuseDamageEffect);
		}

		if ( class'MZPsiAmp_AbilitySet'.default.bStealthNormalFuse )
		{
			AbilityTemplate.PostActivationEvents.RemoveItem('FusePostTriggered');
			AbilityTemplate.AdditionalAbilities.RemoveItem('FusePostActivationConcealmentBreaker');
		}
	}

}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

/*
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	//// might need to use this to set up Grenade Trap abilities correctly. check ability to slot reassignment for how to.
}
*/


static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);
	switch (TagText)
	{
		//HP Cost stuff for Blood Skills
		case 'MZMACABREWALTZ_CHASERHPCOST':
			OutString =  "<font color='#bf1e2e'>" $ string(class'MZMelee_AbilitySet'.default.MacabreWaltz_ChaserHPCost) $ "</font>";
			return true;
		case 'MZBLOODKILLZONESHOT_HPCOST':
			OutString =  "<font color='#bf1e2e'>" $ string(class'MZTrickShot_AbilitySet'.default.BloodKillZoneShot_HPCost) $ "</font>";
			return true;
		case 'MZREDMIST_HPCOSTPERCENT':
			OutString =  "<font color='#bf1e2e'>" $ string(round(class'MZTrickShot_AbilitySet'.default.BloodShot_PercentHPCost * 100)) $ "%</font>";
			return true;
		case 'MZDARKPOTENCY_HPCOST':
			OutString =  "<font color='#bf1e2e'>" $ string(class'MZBloodMagic_AbilitySet'.default.DarkPotency_HPCostUp) $ "</font>";
			return true;
		case 'MZDROPBYDROP_HPCOST':
			OutString =  "<font color='#bf1e2e'>" $ string(class'MZBloodMagic_AbilitySet'.default.DropByDrop_HPCostDown) $ "</font>";
			return true;

		case 'AdviceCritBonus':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Advice_Crit);
			return true;
		case 'AdviceTurns':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Advice_Turns);
			return true;
		case 'BattleCryTurns':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.BattleCry_Turns);
			return true;
		case 'BlastWaveLength':
			OutString =  string(class'MZMelee_AbilitySet'.default.BlastWave_Range);
			return true;
		case 'BlastWaveFirstDebuff':
			OutString =  string(100*(class'MZMelee_AbilitySet'.default.BlastWave_BonusScalar + class'MZMelee_AbilitySet'.default.BlastWave_FirstBonusScalar));
			return true;
		case 'BlastWaveMoreDebuff':
			OutString =  string(100*(class'MZMelee_AbilitySet'.default.BlastWave_BonusScalar));
			return true;
		case 'BonecrusherRange':
			OutString =  string(class'MZMelee_AbilitySet'.default.Bonecrusher_Range);
			return true;
		case 'DoubleGripDamage':
			OutString =  string(class'MZMelee_AbilitySet'.default.DoubleGrip_Dmg) $ "-" $ string(class'MZMelee_AbilitySet'.default.DoubleGrip_Dmg + 2*(class'MZMelee_AbilitySet'.default.DoubleGrip_DmgPerTier));
			return true;
		case 'DoubleGripPierce':
			OutString =  string(class'MZMelee_AbilitySet'.default.DoubleGrip_Pierce) $ "-" $ string(class'MZMelee_AbilitySet'.default.DoubleGrip_Pierce + 2*(class'MZMelee_AbilitySet'.default.DoubleGrip_PiercePerTier));
			return true;
		case 'FullAssaultStun':
			OutString =  string(class'MZMelee_AbilitySet'.default.FullAssault_SelfStun);
			return true;
		case 'MindCrushWill':
			OutString =  string(class'MZShield_AbilitySet'.default.MindCrush_Will);
			return true;
		case 'MindCrushHackDefense':
			OutString =  string(class'MZShield_AbilitySet'.default.MindCrush_HackDef);
			return true;
		case 'PowerCrushRupture':
			OutString =  string(class'MZShield_AbilitySet'.default.PowerCrush_Rupture);
			return true;
		case 'RaptorCycloneRange':
			OutString =  string(class'MZShield_AbilitySet'.default.RaptorCyclone_Range);
			return true;
		case 'RaptorCycloneRadius':
			OutString =  string(class'MZShield_AbilitySet'.default.RaptorCyclone_Radius);
			return true;
		case 'RaptorWhirlwindRange':
			OutString =  string(class'MZShield_AbilitySet'.default.RaptorWhirlwind_Range);
			return true;
		case 'RegenerateMissingHealthPercent':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Regenerate_PercentHeal);
			return true;
		case 'RegenerateFlatHealth':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Regenerate_FlatHeal);
			return true;
		case 'SonicBoomRadius':
			OutString =  string(class'MZTrickShot_AbilitySet'.default.SonicBoom_Radius);
			return true;
		case 'SonicBoomHitBonus':
			OutString =  string(class'MZTrickShot_AbilitySet'.default.SonicBoom_AimMod);
			return true;
		case 'SweepingSpinRadius':
			OutString =  string(class'MZMelee_AbilitySet'.default.SweepingSpin_Radius);
			return true;
		case 'UnscarredBonusDamage':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Unscarred_Dmg) $"-"$ string(class'MZUnspecific_AbilitySet'.default.Unscarred_Dmg + 2*(class'MZUnspecific_AbilitySet'.default.Unscarred_DmgPerTier));
			return true;
		case 'UnscarredDamageReduction':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.Unscarred_DRMult) $"-"$ string(3*(class'MZUnspecific_AbilitySet'.default.Unscarred_DRMult));
			return true;
		case 'MZARMORSYSTEMARMORGAIN':
			OutString =  string(class'MZGremlin_AbilitySet'.default.ArmourSystem_Armour);
			return true;
		case 'MZHoloWillDebuff':
			OutString =  string(class'MZHolotargeter_AbilitySet'.default.HoloWill_Debuff);
			return true;
		case 'MZTransposeDefenseBonus':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.TransposeDefense_Defense);
			return true;
		case 'MZFierceMienRange':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.FierceMien_Range);
			return true;
		case 'MZFierceMienAimDown':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.FierceMien_AimMod);
			return true;
		case 'MZFierceMienDefDown':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.FierceMien_DefMod);
			return true;
		case 'ManuForti_Duration':
			OutString =  string(class'MZPsiAmp_AbilitySet'.default.ManuForti_Duration);
			return true;
		case 'ManuForti_BaseMult':
			OutString =  string(Round(class'MZPsiAmp_AbilitySet'.default.ManuForti_BaseMult*100)) $"%";
			return true;
		case 'ManuForti_PsiMult':
			OutString =  string(Round(class'MZPsiAmp_AbilitySet'.default.ManuForti_PsiMult*100)) $"%";
			return true;
		case 'AmorFati_Duration':
			OutString =  string(class'MZPsiAmp_AbilitySet'.default.AmorFati_Duration);
			return true;
		case 'AmorFati_PercentDR':
			OutString =  string(Round(class'MZPsiAmp_AbilitySet'.default.AmorFati_BonusMult*-100)) $"%";
			return true;
		case 'AmorFati_PsiDR':
			OutString =  string(Round(class'MZPsiAmp_AbilitySet'.default.AmorFati_PsiMult*-100)) $"%";
			return true;
		case 'MZHoloBurnChance':
			OutString =  string(class'MZHolotargeter_AbilitySet'.default.HoloBurnChance) $"%";
			return true;
		case 'MZShimmeringBladeConfuseChance':
			OutString =  string(class'MZMelee_AbilitySet'.default.ShimmeringBlade_ConfuseChance)$"%";
			return true;
		case 'MZSkyfuryBladePanicChance':
			OutString =  string(class'MZMelee_AbilitySet'.default.SkyfuryBlade_PanicChance)$"%";
			return true;
		case 'MZStormForce_DamageBonus':
			OutString =  string(round(class'MZPsiShard_AbilitySet'.default.StormForce_Bonus*100)) $"%";
			return true;
		case 'MZAccurateReaction_Aim':
			OutString =  string(class'MZTrickshot_AbilitySet'.default.AccurateReaction_Bonus);
			return true;
		case 'Sabrestorm_ManaCost':
			OutString =  string(class'MZZFocusMelee_AbilitySet'.default.Bladestorm_ManaCost);
			return true;
			

		case 'MZShiftAim':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.AimShift_Aim);
			return true;
		case 'MZShiftDefense':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.DefenseShift_Defense);
			return true;
		case 'MZShiftLife':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.LifeShift_HP);
			return true;
		case 'MZShiftMove':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.SpeedShift_Mobility);
			return true;
		case 'MZShiftHack':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.TechShift_Hack);
			return true;
		case 'MZShiftHackDefense':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.TechShift_HackDef);
			return true;
		case 'MZShiftPsi':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.PsiShift_Psi);
			return true;
		case 'MZShiftVision':
			OutString =  string(class'MZUnspecific_AbilitySet'.default.SightShift_Vision);
			return true;
		case 'MZHardShieldResist':
			OutString =  string(round(class'MZUnspecific_AbilitySet'.default.HardenedShield_ShieldDamageResistMod*100)) $"%";
			return true;

		default:
			return false;
	}
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
	local name					TagText;
	local MZ_Cost_Focus			ManaCost;
	local Grimy_AbilityCost_HP	HPCost;
	local X2AbilityCharges		Charges;
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect	EffectState;
	local X2AbilityTemplate		AbilityTemplate;
	local int					Idx;
	local MZ_Damage_AddElemental ElemDamage;
	local MZ_Effect_VoidPrison	PrisonEffect;
	
	TagText = name(InString);
	switch (TagText)
	{
		//HP Cost stuff for Blood Skills
		case 'SelfHealthCost':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityCosts.Length; ++Idx)
				{
					HPCost = Grimy_AbilityCost_HP(AbilityTemplate.AbilityCosts[Idx]);
					if (HPCost != none)
					{
						OutString = "<font color='#bf1e2e'>" $ string(HPCost.Cost) $ "</font>";
						return true;
					}
				}
			}
			return true;

		case 'SelfPercentHealthCost':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityCosts.Length; ++Idx)
				{
					HPCost = Grimy_AbilityCost_HP(AbilityTemplate.AbilityCosts[Idx]);
					if (HPCost != none)
					{
						OutString = "<font color='#bf1e2e'>" $ string(round(HPCost.PercentCost * 100)) $ "%</font>";
						return true;
					}
				}
			}
			return true;

		case 'SelfManaCost':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityCosts.Length; ++Idx)
				{
					ManaCost = MZ_Cost_Focus(AbilityTemplate.AbilityCosts[Idx]);
					if (ManaCost != none)
					{
						OutString = string(ManaCost.ManaAmount);
						return true;
					}
				}
			}
			return true;

		case 'SelfCharges':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				Charges = AbilityTemplate.AbilityCharges;
				if ( Charges != none)
				{
					OutString = string(Charges.InitialCharges);
					return true;
				}
			}
			return true;

		case 'MZAddElemTargetDamage':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					ElemDamage = MZ_Damage_AddElemental(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( ElemDamage != none )
					{
						OutString = string(Round(ElemDamage.BonusDamageScalar *100)) $ "%";
						return true;
					}
				}
			}
			return true;

		case 'MZAddElemMultiDamage':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					ElemDamage = MZ_Damage_AddElemental(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( ElemDamage != none )
					{
						OutString = string(Round(ElemDamage.BonusDamageScalar *100)) $ "%";
						return true;
					}
				}
			}
			return true;

		case 'MZVoidPrisonTickDamage':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(MZ_Effect_VoidPrison_BloodDrain(PrisonEffect.ApplyOnTick[0]).DamagePerAction);
						return true;
					}
				}

				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(MZ_Effect_VoidPrison_BloodDrain(PrisonEffect.ApplyOnTick[0]).DamagePerAction);
						return true;
					}
				}
			}
			return true;

		case 'MZVoidPrisonTickPsiPercent':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(round(100*(MZ_Effect_VoidPrison_BloodDrain(PrisonEffect.ApplyOnTick[0]).PsiToDamageMod))) $ "%";
						return true;
					}
				}

				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(round(100*(MZ_Effect_VoidPrison_BloodDrain(PrisonEffect.ApplyOnTick[0]).PsiToDamageMod))) $ "%";
						return true;
					}
				}
			}
			return true;

		case 'MZVoidPrisonMaxStun':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(PrisonEffect.StunActions + 2*PrisonEffect.ScaleStunWithWeaponTier);
						return true;
					}
				}

				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = String(PrisonEffect.StunActions + 2*PrisonEffect.ScaleStunWithWeaponTier);
						return true;
					}
				}
			}
			return true;

		case 'MZVoidPrisonDamage':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = string(PrisonEffect.InitialDamage);
						return true;
					}
				}

				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					PrisonEffect = MZ_Effect_VoidPrison(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( PrisonEffect != none )
					{
						OutString = string(PrisonEffect.InitialDamage);
						return true;
					}
				}
			}
			return true;
		
		case 'SourceWeaponFriendlyName':
			AbilityState = XComGameState_Ability(ParseObj);
			if (AbilityState != none)
			{
				OutString = AbilityState.GetSourceWeapon().GetMyTemplate().GetItemFriendlyNameNoStats();
				return true;
			}
			EffectState = XComGameState_Effect(ParseObj);
			if (EffectState != none)
			{
				OutString = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)).GetSourceWeapon().GetMyTemplate().GetItemFriendlyNameNoStats();
				return true;
			}

		/*
		case 'SelfSourceWeapon':
			AbilityState = XComGameState_Ability(ParseObj);
			if (AbilityState != none)
			{
				OutString = AbilityState.GetSourceWeapon().GetMyTemplate().GetItemAbilityDescName();
				return true;
			}
			EffectState = XComGameState_Effect(ParseObj);
			if (EffectState != none)
			{
				OutString = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)).GetSourceWeapon().GetMyTemplate().GetItemAbilityDescName();
				return true;
			}

			//not happy with this part.. but dunno how to grab source weapon otherwise.
			if (StrategyParseObj != none)
				TargetUnitState = XComGameState_Unit(StrategyParseObj);
			else
			{
				AbilityTemplate = X2AbilityTemplate(ParseObj);
				OutString = AbilityTemplate.LocDefaultPrimaryWeapon;
			}
			if (TargetUnitState != none)
			{
				// Use the GameState check here because in Multiplayer games there is no History
				OutString = TargetUnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, GameState).GetMyTemplate().GetItemAbilityDescName();
			}
			break;
		*/

		default:
			return false;
	}
}