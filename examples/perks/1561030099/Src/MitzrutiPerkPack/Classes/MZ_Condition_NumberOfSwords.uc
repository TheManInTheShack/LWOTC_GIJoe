class MZ_Condition_NumberOfSwords extends X2Condition config(MZPerkWeapons);

var int MinSwords, MaxSwords;
var config array<name> SwordWeaponCats, SwordItemTemplateNames;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit SourceUnit;
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item ItemState;
	local int SwordCount;
	local X2WeaponTemplate Weapon;

	SourceUnit = XComGameState_Unit(kSource);
	if ( SourceUnit == none ) { return 'AA_NotAUnit'; }

	SwordCount = 0;

	ItemStates = SourceUnit.GetAllInventoryItems();
	foreach ItemStates(ItemState) {
		Weapon = X2WeaponTemplate(ItemState.GetMyTemplate());
		If ( Weapon != none && SwordWeaponCats.Find( Weapon.WeaponCat ) != INDEX_NONE )
		{
			SwordCount += 1 ;
		}
		else if ( SwordItemTemplateNames.Find(ItemState.GetMyTemplateName() ) != INDEX_NONE )
		{
			SwordCount += 1;
		}
	}

	If ( SwordCount >= MinSwords && SwordCount <= MaxSwords )
	{
		return 'AA_Success';
	}
	else
	{
		return 'AA_ValueCheckFailed';
	}
}