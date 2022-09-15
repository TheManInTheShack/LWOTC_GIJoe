class X2Effect_SuppressionDamage extends X2Effect_Shredder;

var array<int> Damage;
var array<name> WeaponTech;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local WeaponDamageValue ReturnDamageValue;
	local X2WeaponTemplate WeaponTemplate;
	local int Index;

	ReturnDamageValue = super.GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetRef);

	if ((SourceWeapon != none) &&
		(SourceUnit != none))
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			for (Index = 0; Index < WeaponTech.Length; Index++)
			{
				if (WeaponTech[Index] == WeaponTemplate.WeaponTech)
				{
					ReturnDamageValue.Damage += Damage[Index];
				}
			}
		}
	}

    return ReturnDamageValue;
}

DefaultProperties
{
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bIgnoreBaseDamage = true
}