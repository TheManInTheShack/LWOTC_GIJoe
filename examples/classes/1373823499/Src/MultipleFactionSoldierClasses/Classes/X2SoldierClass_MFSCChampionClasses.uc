class X2SoldierClass_MFSCChampionClasses extends X2SoldierClass_DefaultChampionClasses;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2SoldierClassTemplate Template;
	local string NewClassName;

	foreach class'MultipleFactionSoldierClassController'.default.ReaperClasses(NewClassName)
	{
		if (NewClassName != "Reaper") {
			`CREATE_X2TEMPLATE(class'X2SoldierClassTemplate', Template, name(NewClassName));
			Templates.AddItem(Template);
			Template.GetTargetingMethodPostProcessFn = Reaper_GetTargetingMethodPostProcess;
		}
	}

	foreach class'MultipleFactionSoldierClassController'.default.HiddenReaperClasses(NewClassName)
	{
		if (NewClassName != "Reaper") {
			`CREATE_X2TEMPLATE(class'X2SoldierClassTemplate', Template, name(NewClassName));
			Templates.AddItem(Template);
			Template.GetTargetingMethodPostProcessFn = Reaper_GetTargetingMethodPostProcess;
		}
	}

	foreach class'MultipleFactionSoldierClassController'.default.SkirmisherClasses(NewClassName)
	{
		if (NewClassName != "Skirmisher") {
			`CREATE_X2TEMPLATE(class'X2SoldierClassTemplate', Template, name(NewClassName));
			Templates.AddItem(Template);
		}
	}

	foreach class'MultipleFactionSoldierClassController'.default.TemplarClasses(NewClassName)
	{
		if (NewClassName != "Templar") {
			`CREATE_X2TEMPLATE(class'X2SoldierClassTemplate', Template, name(NewClassName));
			Templates.AddItem(Template);
		}
	}

	return Templates;
}