//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_AkimboClassLWOTC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AkimboClassLWOTC extends X2DownloadableContentInfo config(Game);

var config array<name> IncludedAkimboClasses;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool UnitIsAkimbo(const XComGameState_Unit UnitState)
{
	return default.IncludedAkimboClasses.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE;
}

static function bool CanAddItemToInventory_CH_Improved(
    out int bCanAddItem,                   // out value for XComGameState_Unit
    const EInventorySlot Slot,             // Inventory Slot you're trying to equip the Item into
    const X2ItemTemplate ItemTemplate,     // Item Template of the Item you're trying to equip
    int Quantity, 
    XComGameState_Unit UnitState,          // Unit State of the Unit you're trying to equip the Item on
    optional XComGameState CheckGameState, 
    optional out string DisabledReason,    // out value for the UIArmory_Loadout
    optional XComGameState_Item ItemState) // Item State of the Item we're trying to equip
{
	local XGParamTag	LocTag;

	local bool OverrideNormalBehavior;
    local bool DoNotOverrideNormalBehavior;

    // Prepare return values to make it easier for us to read the code.
    OverrideNormalBehavior = CheckGameState != none;
    DoNotOverrideNormalBehavior = CheckGameState == none;

	if(DisabledReason != "")
    return DoNotOverrideNormalBehavior;

	// do the filtering only if trying to...
	if(UnitIsAkimbo(UnitState) &&	//	equip something on your Akimbo class
		Slot == eInvSlot_PrimaryWeapon || Slot == eInvSlot_SecondaryWeapon)	// into the primary or secondary slot
	{
		if (ItemTemplate.DataName == 'WHIPPITSHOTGUN')
		{

			// if we're trying to equip one of these items
			// we build a message that will be shown to the player stating that this item is not available to the Akimbo class
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate(UnitState.GetSoldierClassTemplateName()).DisplayName;
			DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strNeedsSoldierClass));

			bCanAddItem = 0;

			return OverrideNormalBehavior; // and disallow equipping the item
		}

	}

	 // in all other cases don't do any filtering.
	return DoNotOverrideNormalBehavior;
}