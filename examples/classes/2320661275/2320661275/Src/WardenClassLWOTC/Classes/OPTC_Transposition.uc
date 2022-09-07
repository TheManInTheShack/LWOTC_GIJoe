class OPTC_Transposition extends X2DownloadableContentInfo config(Game);

var config name TranspositionAbility;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplate         Template;
    local X2AbilityTemplateManager  AbilityTemplateManager;
	local X2AbilityCost_ActionPoints		ActionPointCost;

    //  Get the Ability Template Manager.
    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    //  Access a specific ability template by name.
    Template = AbilityTemplateManager.FindAbilityTemplate(default.TranspositionAbility);

    //  Check if the Ability Template was successfully found by the manager.
    if (Template != none)
    {
        //  Modify template as you wish. 
        //  (In this case, make Transposition usable with Momentum action points.)
	    ActionPointCost.AllowedTypes.AddItem('Momentum');
    }
}