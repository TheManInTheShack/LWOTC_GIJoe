// This is an Unreal Script
class TemplateEditors_FlashyPlays extends Object config(GameCore);

var config array<name> GrenadeAbilities;

static function EditTemplates()
{
	local name DataName;

	`Log("TemplateEditors_FlashyPlays.EditTemplates");

	// Smoke and Mirrors, Fastball
	foreach default.GrenadeAbilities(DataName)
	{
		`Log("Flashyplays: Editing" @ DataName);
		AddPostActivationEvent(DataName, 'GrenadeUsed');
	}

	foreach class'X2AbilityCost_GrenadeActionPoints'.default.FlashbangTemplates(DataName)
	{
		`Log("Flashyplays: Editing" @ DataName);
	}		
}


static function AddPostActivationEvent(name AbilityName, name EventName)
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties(AbilityName, TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		if (Template.PostActivationEvents.Find(EventName) == INDEX_NONE)
			Template.PostActivationEvents.AddItem(EventName);
	}
}