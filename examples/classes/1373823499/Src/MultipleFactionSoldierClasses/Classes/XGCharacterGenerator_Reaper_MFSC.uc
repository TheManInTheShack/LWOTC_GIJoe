class XGCharacterGenerator_Reaper_MFSC extends XGCharacterGenerator_Reaper;

function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
{
	local X2SoldierClassTemplateManager ClassMgr;
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2SoldierClassTemplate ClassTemplate;
	local X2CharacterTemplate CharacterTemplate;
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	
	ThisInstance = class'OrderControl'.static.GetThisInstance();

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterTemplate = CharacterTemplateManager.FindCharacterTemplate('ReaperSoldier');

	kSoldier = super.CreateTSoldier('ReaperSoldier', eForceGender, nmCountry, iRace, ArmorName);
	SetCountry('Country_Reaper');
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassMgr.FindSoldierClassTemplate(CharacterTemplate.DefaultSoldierClass);
	kSoldier.strNickName = GenerateNickname(ClassTemplate, kSoldier.kAppearance.iGender);
	ThisInstance.ReaperSet = false;
	
	class'MultipleFactionSoldierClassController'.static.RandomizeReaperClasses(CharacterTemplateManager);

	return kSoldier;
}