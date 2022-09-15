class OPTC_Perks extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()

{

	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					AbilityTemplate;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('AidProtocol');

		if (AbilityTemplate != none)
		{
		AbilityTemplate.PostActivationEvents.AddItem('MultitaskingTrigger');
		}

	return;
}