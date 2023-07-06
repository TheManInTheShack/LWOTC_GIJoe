class X2Character_DefaultCharacters_MFSC extends X2Character_DefaultCharacters;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_MFSC_ReaperSoldier());
	Templates.AddItem(CreateTemplate_MFSC_SkirmisherSoldier());
	Templates.AddItem(CreateTemplate_MFSC_TemplarSoldier());

	return Templates;
}

static function X2CharacterTemplate CreateTemplate_MFSC_ReaperSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('ReaperSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Reaper';
	CharTemplate.DefaultLoadout = 'SquaddieReaper';

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Reaper_MFSC';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.GetPawnNameFn = GetReaperPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MFSC_SkirmisherSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('SkirmisherSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Skirmisher';
	CharTemplate.DefaultLoadout = 'SquaddieSkirmisher';
	
	// Ensure only Skirmisher heads are available for customization
	CharTemplate.bHasCharacterExclusiveAppearance = true;

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Skirmisher_MFSC';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationHeadClass = class'UICustomize_SkirmisherHead';
	CharTemplate.GetPawnNameFn = GetSkirmisherPawnName;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MFSC_TemplarSoldier()
{
	local X2CharacterTemplate CharTemplate;

	CharTemplate = CreateSoldierTemplate('TemplarSoldier');

	CharTemplate.bIsResistanceHero = true;
	CharTemplate.DefaultSoldierClass = 'Templar';
	CharTemplate.DefaultLoadout = 'SquaddieTemplar';

	CharTemplate.strIntroMatineeSlotPrefix = "Templar";

	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator_Templar_MFSC';
	CharTemplate.CustomizationManagerClass = class'XComCharacterCustomization_FactionHero';
	CharTemplate.UICustomizationInfoClass = class'UICustomize_TemplarInfo';
	CharTemplate.GetPawnNameFn = GetTemplarPawnName;

	CharTemplate.strMatineePackages.AddItem("CIN_XP_Heroes");

	return CharTemplate;
}