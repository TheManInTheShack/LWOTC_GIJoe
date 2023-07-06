class XGCharacterGenerator_Templar_MFSC extends XGCharacterGenerator_Templar;

function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
{
	local X2SoldierClassTemplateManager ClassMgr;
	local X2CharacterTemplateManager CharacterTemplateManager;
	local X2SoldierClassTemplate ClassTemplate;
	local X2CharacterTemplate CharacterTemplate;
	local X2DownloadableContentInfo_MultipleFactionSoldierClasses ThisInstance;
	
	ThisInstance = class'OrderControl'.static.GetThisInstance();

	CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharacterTemplate = CharacterTemplateManager.FindCharacterTemplate('TemplarSoldier');

	kSoldier = super.CreateTSoldier('TemplarSoldier', eForceGender, nmCountry, iRace, ArmorName);
	SetCountry('Country_Templar');
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassMgr.FindSoldierClassTemplate(CharacterTemplate.DefaultSoldierClass);
	kSoldier.strNickName = GenerateNickname(ClassTemplate, kSoldier.kAppearance.iGender);
	ThisInstance.TemplarSet = false;

	class'MultipleFactionSoldierClassController'.static.RandomizeTemplarClasses(CharacterTemplateManager);

	return kSoldier;
}
