class X2Condition_WeaponCategory extends X2Condition;

var array<name> IncludeWeaponCategories;
var array<name> ExcludeWeaponCategories;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = kAbility.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if (IncludeWeaponCategories.Length > 0)
	{
		if (IncludeWeaponCategories.Find(WeaponTemplate.WeaponCat) == INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}

	if (ExcludeWeaponCategories.Length > 0)
	{
		if (ExcludeWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}