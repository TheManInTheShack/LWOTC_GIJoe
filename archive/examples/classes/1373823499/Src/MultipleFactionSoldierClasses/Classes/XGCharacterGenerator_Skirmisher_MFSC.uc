class XGCharacterGenerator_Skirmisher_MFSC extends XGCharacterGenerator_Skirmisher;

function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
{
	local X2SoldierClassTemplateManager ClassMgr;
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2SoldierClassTemplate ClassTemplate;
	local X2CharacterTemplate CharacterTemplate;
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	
	ThisInstance = class'OrderControl'.static.GetThisInstance();

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterTemplate = CharacterTemplateManager.FindCharacterTemplate('SkirmisherSoldier');

	kSoldier = super.CreateTSoldier('SkirmisherSoldier', eForceGender, nmCountry, iRace, ArmorName);
	SetCountry('Country_Skirmisher');
	GenerateName(kSoldier.kAppearance.iGender, kSoldier.nmCountry, kSoldier.strFirstName, kSoldier.strLastName, kSoldier.kAppearance.iRace);
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassMgr.FindSoldierClassTemplate(CharacterTemplate.DefaultSoldierClass);
	kSoldier.strNickName = GenerateNickname(ClassTemplate, kSoldier.kAppearance.iGender);
	ThisInstance.SkirmisherSet = false;

	class'MultipleFactionSoldierClassController'.static.RandomizeSkirmisherClasses(CharacterTemplateManager);

	return kSoldier;
}
