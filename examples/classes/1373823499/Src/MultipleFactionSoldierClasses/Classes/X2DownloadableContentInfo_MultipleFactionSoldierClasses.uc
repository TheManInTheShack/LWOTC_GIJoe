class X2DownloadableContentInfo_MultipleFactionSoldierClasses extends X2DownloadableContentInfo;

var bool ReaperSet;
var bool SkirmisherSet;
var bool TemplarSet;

static event OnPostTemplatesCreated() {
	local X2AbilityTemplateManager AbilityTemplateManager;

	class'MultipleFactionSoldierClassController'.static.RandomizeAllFactionsClasses(class'MultipleFactionSoldierClassController'.default.FavorNewClasses);

	class'MultipleFactionSoldierClassController'.static.PatchStrategyTemplates();
	class'MultipleFactionSoldierClassController'.static.PatchChosenRivalries();

	if (class'MultipleFactionSoldierClassController'.default.ReaperShadowAnimationFix) {
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		class 'X2AbilityTemplate_ShadowPatcher'.static.PatchShadow(AbilityTemplateManager, 'Shadow');
		class 'X2AbilityTemplate_ShadowPatcher'.static.PatchShadow(AbilityTemplateManager, 'ShadowPassive');
		class 'X2AbilityTemplate_ShadowPatcher'.static.PatchShadow(AbilityTemplateManager, 'DistractionShadow');
	}
}

static event InstallNewCampaign(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> CurrentSoldiers;
	local name CharTemplateName;
	local name PoolClass;
	local int i;

	class'MultipleFactionSoldierClassController'.static.RandomizeAllFactionsClasses(class'MultipleFactionSoldierClassController'.default.FavorNewClasses);

	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	
	CurrentSoldiers = XComHQ.GetSoldiers();	
	for (i=0;i<CurrentSoldiers.Length;i++) {
		CharTemplateName = class'XComGameState_Unit_MFSC'.static.GetCharTemplateNameForUnit(CurrentSoldiers[i]);
		if (CharTemplateName == 'ReaperSoldier' || CharTemplateName == 'SkirmisherSoldier' || CharTemplateName == 'TemplarSoldier')
		{
			PoolClass = class'XComGameState_Unit_MFSC'.static.DetermineCharacterPoolClassForUnit(CurrentSoldiers[i]);

			if (PoolClass != '') {
				CurrentSoldiers[i].SetSoldierClassTemplate(PoolClass);
				class'XComGameState_Unit_MFSC'.static.ResetSoldierRankForUnit(CurrentSoldiers[i], PoolClass);
				CurrentSoldiers[i].ApplySquaddieLoadout(StartState, XComHQ);
			}
		}
	}

}

exec function ForceFactionRandomize(optional bool NewClassesOnly) {
	class'MultipleFactionSoldierClassController'.static.RandomizeAllFactionsClasses(NewClassesOnly);
}

exec function NextClassForFaction(name FactionID, name ChosenClass) {
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;

	ThisInstance = class'OrderControl'.static.GetThisInstance();

	if (FactionID == 'Reaper') {
		if (SetupNextClass(FactionID, class'MultipleFactionSoldierClassController'.default.ReaperClasses, ChosenClass)) {
			ThisInstance.ReaperSet = true;
		}
	} else if (FactionID == 'Skirmisher') {
		if (SetupNextClass(FactionID, class'MultipleFactionSoldierClassController'.default.SkirmisherClasses, ChosenClass)) {
			ThisInstance.SkirmisherSet = true;
		}
	} else if (FactionID == 'Templar') {
		if (SetupNextClass(FactionID, class'MultipleFactionSoldierClassController'.default.TemplarClasses, ChosenClass)) {
			ThisInstance.TemplarSet = true;
		}
	}
}

static function bool SetupNextClass(name FactionID, array<string> ListOfClasses, name ChosenClass) {
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2CharacterTemplate CharacterTemplate;
	local string CClass;
	local name FactionSoldierTemplateName;
	local bool found;

	foreach ListOfClasses(CClass) {
		if (ChosenClass == name(CClass)) {
			found = true;
			break;
		}
	}

	if (found == true) {
		CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

		FactionSoldierTemplateName = name(string(FactionID) $ "Soldier");
		CharacterTemplate = CharacterTemplateManager.FindCharacterTemplate(FactionSoldierTemplateName);

		if (CharacterTemplate != none) {
			CharacterTemplate.DefaultSoldierClass = ChosenClass;
			return true;
		} else {
			`log("MFSC: CharacterTemplate ERROR???");
		}
	}

	return false;
} 

exec function MakeFactionSoldierAClass(string UnitName, name ClassName)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local name TemplateName;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Turn Solier Into Class Cheat");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
				
		if (UnitState != none)
		{
			TemplateName = UnitState.GetMyTemplateName();

			if (TemplateName == 'ReaperSoldier' || TemplateName == 'SkirmisherSoldier' || TemplateName == 'TemplarSoldier')
			{
				if (UnitState.GetFullName() == UnitName) 
				{
					UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

					UnitState.ResetSoldierRank(); // Clear their rank
					UnitState.ResetSoldierAbilities(); // Clear their current abilities
			
					UnitState.bRolledForAWCAbility = false; // reroll their AWC abilities
			
					UnitState.RankUpSoldier(NewGameState, ClassName); // The class template name
					UnitState.ApplySquaddieLoadout(NewGameState, XComHQ);
				}
			}
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}
