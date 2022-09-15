class OPTC_ProtectAndServe extends X2DownloadableContentInfo;
 
static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager  AbilityTemplateManager;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
 
    AdjustProtectAndServeAbility(AbilityTemplateManager.FindAbilityTemplate('F_ProtectAndServe'));
}
 
static function AdjustProtectAndServeAbility(X2AbilityTemplate Template)
{
	local XMBCondition_AbilityName NameCondition;
    //  Check if the Ability Template was successfully found by the manager.
    if (Template != none)
    {
		NameCondition.IncludeAbilityNames.AddItem('OneForAll');
    }
}