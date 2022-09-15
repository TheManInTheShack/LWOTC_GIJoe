class MZJetpack_AbilitySet extends X2Ability dependson(XComGameStateContext_Ability) config(MZCryoPerkPack);

var config int RestedWings_RestoreJetCharges, RestedWings_MaxJetCharges, RestedWings_MaxFlightCharges, UltimaShot_JetChargeCost;
var config int ViciousFalcon_BonusDamage, ViciousFalcon_PerTierDamage, CometCracker_Stun, CometCracker_StunChance;
var config float CometCracker_BonusRadius;
var config array<name> RestedWingsHunkerAbilities, JetPackAttacks;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddUltimaShot());
	Templates.AddItem(AddRestedWings());

	Templates.AddItem(AddViciousFalcon());
	Templates.AddItem(PurePassive('MZCometCracker', "img:///UILibrary_MZChimeraIcons.Ability_PressurePoint"));
	Templates.AddItem(PurePassive('MZJetPunchCombo', "img:///JetPacks.UI.RocketPunch"));

	return Templates;
}

static function ModifyJetPackAbilities()
{
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local name									AbilityName;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Effect_Stunned						StunEffect;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	foreach default.JetPackAttacks(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		if ( AbilityTemplate != none )
		{
			StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect( default.CometCracker_Stun, default.CometCracker_StunChance, false );
			AbilityCondition = new class'X2Condition_AbilityProperty';
			AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZCometCracker');
			StunEffect.TargetConditions.AddItem(AbilityCondition);

			if ( AbilityTemplate.AbilityTargetEffects.Length > 0 )
			{
				AbilityTemplate.AddTargetEffect(StunEffect);
			}

			if ( AbilityTemplate.AbilityMultiTargetEffects.Length > 0 )
			{
				AbilityTemplate.AddMultiTargetEffect(StunEffect);

				RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
				if ( RadiusMultiTarget != none ) {
					RadiusMultiTarget.AddAbilityBonusRadius('MZCometCracker', default.CometCracker_BonusRadius);
					AbilityTemplate.AbilityMultiTargetStyle = RadiusMultiTarget;
				}
			}

		}
	}
}

static function X2AbilityTemplate AddUltimaShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointsCost;
	local int								i;
	local X2Condition_UnitEffects			JetCondition;
	local MZ_Cost_SoaringShot				ChargeCost;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2AbilityToHitCalc_StandardAim	HitCalc;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('MZUltimaShot', false, false, false);
	Template.bDontDisplayInAbilitySummary = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shotfocused";
	Template.ShotHUDPriority = 370;

	HitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//HitCalc.bHitsAreCrits = true;
	Template.AbilityToHitCalc = HitCalc;


	for (i = 0; i < Template.AbilityCosts.Length; i++) {
		ActionPointsCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);

		if (ActionPointsCost != None) {
			ActionPointsCost.bConsumeAllPoints = true;
			ActionPointsCost.DoNotConsumeAllEffects.length = 0;
			ActionPointsCost.DoNotConsumeAllSoldierAbilities.length = 0;
			ActionPointsCost.bAddWeaponTypicalCost = true;
			break;
		}
	}

	ChargeCost = new class'MZ_Cost_SoaringShot';
	ChargeCost.UseChargesFromAbilityName = 'IRI_JetShot';
	ChargeCost.NumCharges = default.UltimaShot_JetChargeCost;
	Template.AbilityCosts.AddItem(ChargeCost);

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	JetCondition = new class'X2Condition_UnitEffects';
	JetCondition.AddRequireEffect('IRI_JetShot_Effect', 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(JetCondition);

	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);	
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	return Template;
}

static function X2AbilityTemplate AddRestedWings()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_RestedWings		RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZRestedWings');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flight";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_RestedWings';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.AbilityNames = default.RestedWingsHunkerAbilities;
	RegenEffect.NumJetCharges = default.RestedWings_RestoreJetCharges;
	RegenEffect.MaxJetCharges = default.RestedWings_MaxJetCharges;
	RegenEffect.MaxFlightCharges = default.RestedWings_MaxFlightCharges;
	RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.bUniqueSource = true;
	
	return Template;
}

static function X2AbilityTemplate AddViciousFalcon()
{
	local X2AbilityTemplate				Template;
	local MZ_Effect_JetPackBonusDamage		RegenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZViciousFalcon');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

//BEGIN AUTOGENERATED CODE: Template Overrides 'Deflect'
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flight";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;
//END AUTOGENERATED CODE: Template Overrides 'Deflect'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	RegenEffect = new class'MZ_Effect_JetPackBonusDamage';
	RegenEffect.BuildPersistentEffect(1, true, false, false);
	RegenEffect.JetPackAbilities = default.JetPackAttacks;
	RegenEffect.Bonus = default.ViciousFalcon_BonusDamage;
	RegenEffect.PerTier = default.ViciousFalcon_PerTierDamage;
	RegenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(RegenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.bUniqueSource = true;
	
	return Template;
}