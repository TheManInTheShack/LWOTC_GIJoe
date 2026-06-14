class X2StrategyElement_AcademyUnlocks_MFSC extends X2StrategyElement_AcademyUnlocks;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.Length = 0;
	
	if (class'MultipleFactionSoldierClassController'.default.ReplaceGTSTemplates == true) {
		Templates.AddItem(MFSC_MeditationPreparationUnlock());
		Templates.AddItem(MFSC_ParkourUnlock());
		Templates.AddItem(MFSC_InfiltrationUnlock());
	}

	return Templates;
}

static function X2SoldierUnlockTemplate MFSC_MeditationPreparationUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;
	local string AddAllowedClass;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'MeditationPreparationUnlock');

	Template.AllowedClasses.AddItem('Templar');
	if (class'MultipleFactionSoldierClassController'.default.GetTemplarGTSBonus.Length > 0) {
		foreach class'MultipleFactionSoldierClassController'.default.GetTemplarGTSBonus(AddAllowedClass) {
			Template.AllowedClasses.AddItem(name(AddAllowedClass));
		}
	}

	Template.AbilityName = 'MeditationPreparation';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.GTS_Templar";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Templar';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierUnlockTemplate MFSC_ParkourUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;
	local string AddAllowedClass;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'ParkourUnlock');

	Template.AllowedClasses.AddItem('Skirmisher');
	if (class'MultipleFactionSoldierClassController'.default.GetSkirmisherGTSBonus.Length > 0) {
		foreach class'MultipleFactionSoldierClassController'.default.GetSkirmisherGTSBonus(AddAllowedClass) {
			Template.AllowedClasses.AddItem(name(AddAllowedClass));
		}
	}

	Template.AbilityName = 'Parkour';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.GTS_Skirmisher";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Skirmisher';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2SoldierUnlockTemplate MFSC_InfiltrationUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;
	local string AddAllowedClass;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'InfiltrationUnlock');

	Template.AllowedClasses.AddItem('Reaper');
	if (class'MultipleFactionSoldierClassController'.default.GetReaperGTSBonus.Length > 0) {
		foreach class'MultipleFactionSoldierClassController'.default.GetReaperGTSBonus(AddAllowedClass) {
			Template.AllowedClasses.AddItem(name(AddAllowedClass));
		}
	}

	Template.AbilityName = 'Infiltration';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.GTS_Reaper";

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = 5;
	Template.Requirements.RequiredSoldierClass = 'Reaper';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}