class MultipleFactionSoldierClassController extends Object config(FactionClasses);

struct GTSBonus {
	var name Unlock;
	var name AddClass;
};

var config array<string> ReaperClasses;
var config array<string> HiddenReaperClasses;
var config array<string> SkirmisherClasses;
var config array<string> TemplarClasses;

var config array<string> GetReaperGTSBonus;
var config array<string> GetSkirmisherGTSBonus;
var config array<string> GetTemplarGTSBonus;

var config array<string> PatchReaperGTS;
var config array<string> PatchSkirmisherGTS;
var config array<string> PatchTemplarGTS;

var config array<name> TotalDarknessAbilities;

var config array<GTSBonus> NewClassForBonus;

var config bool FavorNewClasses;
var config bool ReplaceGTSTemplates;
var config bool DontOverrideSchematicTemplates;
var config bool ReaperShadowAnimationFix;

var config bool UnrestrictVektorRifle;
var config bool UnrestrictBullpup;
var config bool UnrestrictRipjack;
var config bool UnrestrictGauntlet;
var config bool UnrestrictAutopistol;

static function RandomizeAllFactionsClasses(optional bool NewClasses = false) {
	local X2CharacterTemplateManager CharacterTemplateManager;

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	RandomizeReaperClasses(CharacterTemplateManager, NewClasses);
	RandomizeSkirmisherClasses(CharacterTemplateManager, NewClasses);
	RandomizeTemplarClasses(CharacterTemplateManager, NewClasses);
}

static function RandomizeReaperClasses(X2CharacterTemplateManager CharacterTemplateManager, optional bool NewClasses = false) {
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	ThisInstance = class'OrderControl'.static.GetThisInstance();
	if (!ThisInstance.ReaperSet)
		RandomizeClasses(CharacterTemplateManager, 'Reaper', default.ReaperClasses, NewClasses);
}

static function RandomizeSkirmisherClasses(X2CharacterTemplateManager CharacterTemplateManager, optional bool NewClasses = false) {
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	ThisInstance = class'OrderControl'.static.GetThisInstance();
	if (!ThisInstance.SkirmisherSet)
		RandomizeClasses(CharacterTemplateManager, 'Skirmisher', default.SkirmisherClasses, NewClasses);
}

static function RandomizeTemplarClasses(X2CharacterTemplateManager CharacterTemplateManager, optional bool NewClasses = false) {
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	ThisInstance = class'OrderControl'.static.GetThisInstance();
	if (!ThisInstance.TemplarSet)
		RandomizeClasses(CharacterTemplateManager, 'Templar', default.TemplarClasses, NewClasses);
}

static function string RandomizeClasses(X2CharacterTemplateManager CharacterTemplateManager,
	name TemplateNameBase, array<string> ValidClasses, bool NewClasses)
{
	local X2CharacterTemplate Template;
	local string NewClassName;
	local name TemplateName;
	local int R, RBase;

	if (CharacterTemplateManager == none)
		CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	TemplateName = name(string(TemplateNameBase) $ "Soldier");

	RBase = ValidClasses.Length;
	do {
		Template = CharacterTemplateManager.FindCharacterTemplate(TemplateName);
		if (RBase > 1)
			R = `SYNC_RAND_STATIC(RBase);
		else
			R = 0;

		NewClassName = ValidClasses[R];
	}
	until (RBase <= 1 || NewClasses == false || (NewClassName != string(TemplateNameBase)));

	`log("MFSC: New randomized class is [" $ NewClassName $ "]:(" $ string(R) $ ")");

	// constantly changing the template is how we generate random classes
	Template.DefaultSoldierClass = name(NewClassName);

	return NewClassName;
}

static function PatchStrategyTemplates() {
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local bool ReaperModClasses;
	local bool SkirmisherModClasses;
	local bool TemplarModClasses;	
	local bool UnrestrictReaperUpgrades;
	local bool UnrestrictSkirmisherUpgrades;
	local bool UnrestrictTemplarUpgrades;
	local bool unrestrict;
	local array<X2StrategyElementTemplate> StratTemplates;
	local X2TechTemplate Template;
	local name TName;
	local int i;

	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	PatchFactionSoldierReward(StrategyTemplateManager, 'Reward_FactionSoldier');
	PatchFactionSoldierReward(StrategyTemplateManager, 'Reward_ExtraFactionSoldier');
	PatchFactionSoldierReward(StrategyTemplateManager, 'Reward_FindFaction');
	
	if (class'MultipleFactionSoldierClassController'.default.ReplaceGTSTemplates == false) {
		PatchStrategyElementsFor(StrategyTemplateManager, 'Reaper', default.PatchReaperGTS, default.GetReaperGTSBonus);
		PatchStrategyElementsFor(StrategyTemplateManager, 'Skirmisher', default.PatchSkirmisherGTS, default.GetSkirmisherGTSBonus);
		PatchStrategyElementsFor(StrategyTemplateManager, 'Templar', default.PatchTemplarGTS, default.GetTemplarGTSBonus);
	}

	// fix this
	//PatchXCOMStrategyElements(StrategyTemplateManager, default.NewClassForBonus);

	UnrestrictReaperUpgrades = default.UnrestrictVektorRifle;
	UnrestrictSkirmisherUpgrades = default.UnrestrictBullpup; //|| default.UnrestrictRipjack;
	UnrestrictTemplarUpgrades = default.UnrestrictAutopistol; //|| default.UnrestrictGauntlet;

	if (UnrestrictReaperUpgrades) {
		if (default.ReaperClasses.Length > 1 || default.ReaperClasses[0] != "Reaper")
			ReaperModClasses = true;
	}

	if (UnrestrictSkirmisherUpgrades) {
		if (default.SkirmisherClasses.Length > 1 || default.SkirmisherClasses[0] != "Skirmisher")
			SkirmisherModClasses = true;
	}

	if (UnrestrictTemplarUpgrades) {
		if (default.TemplarClasses.Length > 1 || default.TemplarClasses[0] != "Templar")
			TemplarModClasses = true;
	}

	if (ReaperModClasses || SkirmisherModClasses || TemplarModClasses) {
		StratTemplates = StrategyTemplateManager.GetAllTemplatesOfClass(class'X2TechTemplate');

		for(i=0; i < StratTemplates.Length; i++) {
			Template = X2TechTemplate(StratTemplates[i]);
			TName = Template.DataName;
			unrestrict = false;

			if (ReaperModClasses) {
				if (default.UnrestrictVektorRifle) {
					if (TName == 'BreakthroughVektorRifleDamage' || TName == 'BreakthroughVektorRifleWeaponUpgrade') {
						unrestrict = true;
					}
				}
			}

			if (SkirmisherModClasses) {
				if (default.UnrestrictBullpup) {
					if (TName == 'BreakthroughBullpupDamage' || TName == 'BreakthroughBullpupWeaponUpgrade') {
						unrestrict = true;
					}
				}
			}

			if (TemplarModClasses) {
				if (default.UnrestrictAutoPistol) {
					if (TName == 'BreakthroughSidearmDamage') {
						unrestrict = true;
					}
				}
			}


			if (unrestrict == true) {
				X2TechTemplate(StratTemplates[i]).Requirements.RequiredSoldierClass = '';
			}
		}
	}
}

static function PatchFactionSoldierReward(X2StrategyElementTemplateManager StrategyTemplateManager, name TemplateName)
{
	local X2StrategyElementTemplate SETemplate;

	SETemplate = StrategyTemplateManager.FindStrategyElementTemplate(TemplateName);

	if (SETemplate != none) {
		X2RewardTemplate(SETemplate).GenerateRewardFn = class'X2StrategyElement_XpackRewards_MFSC'.static.GenerateFactionSoldierReward_MFSC;
	} else {
		`log("ERROR: Could not patch X2StrategyElementTemplate " $ TemplateName);
	}
}

static function PatchStrategyElementsFor(X2StrategyElementTemplateManager StrategyTemplateManager,
	name Faction, const array<string> GTSAbilities, const array<string> BonusHavers)
{
	local string CurrentAbility;
	local string CurrentBonusHaver;
	local X2StrategyElementTemplate SETemplate;
	local X2SoldierAbilityUnlockTemplate Template;

	if (BonusHavers.Length > 0) {
		foreach GTSAbilities(CurrentAbility) {
			SETemplate = StrategyTemplateManager.FindStrategyElementTemplate(name(CurrentAbility));
			if (SETemplate != none) {
				Template = X2SoldierAbilityUnlockTemplate(SETemplate);
				if (Template != none) {
					if (Template.Requirements.RequiredSoldierClass == Faction) {
						foreach BonusHavers(CurrentBonusHaver) {
							Template.AllowedClasses.AddItem(name(CurrentBonusHaver));
							`log("MFSC: " $ CurrentBonusHaver $ " now gets bonus");
						}
					}
				}
			}
		}	
	}
}

// FIX THIS AT SOME POINT
static function PatchXCOMStrategyElements(X2StrategyElementTemplateManager StrategyTemplateManager, const array<GTSBonus> NCFB_Struct) {
	local X2StrategyElementTemplate SETemplate;
	local X2SoldierAbilityUnlockTemplate Template;
	local GTSBonus CurGTSBonus;

	if (NCFB_Struct.Length > 0) {
		foreach NCFB_Struct(CurGTSBonus) {
			SETemplate = StrategyTemplateManager.FindStrategyElementTemplate(CurGTSBonus.Unlock);
			if (SETemplate != none) {
				Template = X2SoldierAbilityUnlockTemplate(SETemplate);
				if (Template != none) {
					Template.Requirements.RequiredSoldierClass = '';
					Template.Requirements.RequiredSoldierRankClassCombo = false;
					Template.AllowedClasses.AddItem(CurGTSBonus.AddClass);
				}
			}
		}
	}
}

static function PatchChosenRivalries() {
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate Template;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityTemplateManager.FindAbilityTemplate('ChosenReaperAdversary');
	AddHostileClassesExcept(Template, default.ReaperClasses, 'Reaper');
	if (default.HiddenReaperClasses.Length > 0)
		AddHostileClassesExcept(Template, default.HiddenReaperClasses, 'Reaper');

	Template = AbilityTemplateManager.FindAbilityTemplate('ChosenSkirmisherAdversary');
	AddHostileClassesExcept(Template, default.SkirmisherClasses, 'Skirmisher');

	Template = AbilityTemplateManager.FindAbilityTemplate('ChosenTemplarAdversary');
	AddHostileClassesExcept(Template, default.TemplarClasses, 'Templar');
}

static function AddHostileClassesExcept(X2AbilityTemplate Template, const array<string> HostileTo, const name BaseFactionClassName)
{
	local string CurrentClass;
	local string BaseFactionClass;
	local int i;

	BaseFactionClass = string(BaseFactionClassName);

	foreach HostileTo(CurrentClass) {
		if (CurrentClass != BaseFactionClass) {
			for(i=0; i < Template.AbilityTargetEffects.Length; i++) {
				if (X2Effect_AdverseSoldierClasses(Template.AbilityTargetEffects[i]) != none) {

					`log("MFSC: Chosen weak against " $ BaseFactionClass $ " also weak against " $ CurrentClass);

					X2Effect_AdverseSoldierClasses(Template.AbilityTargetEffects[i]).AdverseClasses.AddItem(name(CurrentClass));
				}
			}			
		}
	}

}