class OPTC_Magnum_LW extends X2DownloadableContentInfo;
 
static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager  AbilityTemplateManager;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
 
    AdjustMagnum_LWAbility(AbilityTemplateManager.FindAbilityTemplate('Magnum_LW'));
}
 
static function AdjustMagnum_LWAbility(X2AbilityTemplate Template)
{
	local XMBCondition_AbilityName NameCondition;
    //  Check if the Ability Template was successfully found by the manager.
    if (Template != none)
    {
		NameCondition.IncludeAbilityNames.AddItem('PistolStandardShot_Secondary');
		NameCondition.IncludeAbilityNames.AddItem('PistolOverwatchShot_Secondary');
    }
}