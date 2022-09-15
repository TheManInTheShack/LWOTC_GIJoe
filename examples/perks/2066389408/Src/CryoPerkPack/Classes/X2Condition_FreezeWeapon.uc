class X2Condition_FreezeWeapon extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item PrimaryWeapon;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	PrimaryWeapon = TargetUnit.GetPrimaryWeapon();
	If (PrimaryWeapon == none || PrimaryWeapon.Ammo < 1 || class'X2Effect_DisableWeapon'.default.WeaponsImmuneToDisable.Find(PrimaryWeapon.GetMyTemplateName()) != INDEX_NONE || X2WeaponTemplate(PrimaryWeapon.GetMyTemplate()).InfiniteAmmo == true )
		return 'AA_UnitIsImmune';

	return 'AA_Success';
}