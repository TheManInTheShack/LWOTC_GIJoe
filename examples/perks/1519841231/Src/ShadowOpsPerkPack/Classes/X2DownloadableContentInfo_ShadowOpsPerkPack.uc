class X2DownloadableContentInfo_ShadowOpsPerkPack extends X2DownloadableContentInfo;

var config name ModVersion;
var localized string ModUpgradeLabel;
var localized string ModUpgradeSummary;
var localized string ModUpgradeAcceptLabel;

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	class'XComGameState_KillTracker'.static.InitializeWithGameState(StartState);
}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{

}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local array<object> DefaultObjects;
	local object Obj;

    `LOG("WOTC ShadowOpsPerkPack is installed");

	class'TemplateEditors'.static.EditTemplates();
	class'TemplateEditors_CombatEngineer'.static.EditTemplates();
	class'TemplateEditors_Dragoon'.static.EditTemplates();
	class'TemplateEditors_Hunter'.static.EditTemplates();
	class'TemplateEditors_Infantry'.static.EditTemplates();
	class'TemplateEditors_Items'.static.EditTemplates();

	DefaultObjects = class'XComEngine'.static.GetClassDefaultObjects(class'X2DownloadableContentInfo');
	foreach DefaultObjects(Obj)
	{
		`Log("Found X2DownloadableContentInfo" @ Obj.class);
	}
	DefaultObjects = class'XComEngine'.static.GetClassDefaultObjects(class'X2DataSet');
	foreach DefaultObjects(Obj)
	{
		`Log("Found X2DataSet" @ Obj.class);
	}
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	switch (locs(InString))
	{
	case "ecmdetectionmodifier":
		OutString = string(int(class'X2Ability_DragoonAbilitySet'.default.ECMDetectionModifier * 100));
		return true;
	case "eatthismaxtiles":
		OutString = string(class'X2Ability_DragoonAbilitySet'.default.EatThisMaxTiles);
		return true;
	case "shieldbatterybonuscharges":
		OutString = string(class'X2Ability_DragoonAbilitySet'.default.ShieldBatteryBonusCharges);
		return true;
	case "inspirationmaxtiles":
		OutString = string(class'X2Ability_DragoonAbilitySet'.default.InspirationMaxTiles);
		return true;
	case "zoneofcontrollw2shots":
		OutString = string(class'X2Ability_InfantryAbilitySet'.default.ZoneOfControlLW2Shots);
		return true;
	case "NoiseMakerCharges":
		OutString = string(class'X2Ability_InfantryAbilitySet'.default.NoiseMakerCharges);
		return true;
	case "ExpandedSmokeBonusRadius":
		OutString = string(int(class'X2Ability_EngineerAbilitySet'.default.DenseSmokeBonusRadius));
		return true;
	}

	return false;
}
