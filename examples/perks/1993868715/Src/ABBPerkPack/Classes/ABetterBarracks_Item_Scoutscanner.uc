class ABetterBarracks_Item_Scoutscanner extends X2Item_DefaultUtilityItems;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateScoutScanner());
	Items.AddItem(CreateHeistArtistItem());

	return Items;
}

static function X2WeaponTemplate CreateScoutScanner()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ScoutScanner');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Battle_Scanner";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_Grenade_BattleScanner.WP_Grenade_BattleScanner";
	Template.Abilities.AddItem('ScoutScanner');
	Template.ItemCat = 'tech';
	Template.WeaponCat = 'utility';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.bMergeAmmo = true;
	Template.iClipSize = 1;
	Template.Tier = 1;

	Template.iRadius = default.BATTLESCANNER_RADIUS;
	Template.iRange = default.BATTLESCANNER_RANGE;

	Template.CanBeBuilt = false;

	Template.bShouldCreateDifficultyVariants = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.BATTLESCANNER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.BATTLESCANNER_RADIUS);

	return Template;
}

static function X2DataTemplate CreateHeistArtistItem()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'HeistArtistItem');

	Template.WeaponCat = 'utility';
	Template.ItemCat = 'utility';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Advent_Datapad";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.Abilities.AddItem('HeistArtistItemStats');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechLabel, eStat_Hacking, class'ABBPerkPack_Perks'.default.ABB_Infiltrator_Hacking, true);

	return Template;
}