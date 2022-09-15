class X2Condition_AbilityCostsAmmo extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;

    SourceWeapon = kAbility.GetSourceWeapon();
    if(SourceWeapon == none)
    {
        return 'AA_WeaponIncompatible';
    }

    if(kAbility.iAmmoConsumed <= 0)
    {
        `LOG("X2Condition_AbilityCostsAmmo costs no ammo.");
        return 'AA_WeaponIncompatible';
    }

    if (SourceWeapon.Ammo == SourceWeapon.GetClipSize())
	{
		return 'AA_AmmoAlreadyFull';
	}

	return 'AA_Success';
}