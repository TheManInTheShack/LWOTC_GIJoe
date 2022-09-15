class MZ_Cost_AmmoPerTarget extends X2AbilityCost_Ammo;

var int AmmoPerTarget;
var int MinAmmoToFire;

simulated function int CalcFullAmmoCost(XComGameStateContext_Ability Context, XComGameState_Item ItemState)
{
	if (bConsumeAllAmmo)
	{
		if (ItemState.Ammo > 0)
			return ItemState.Ammo;
		return 1;
	}

	//min here is a sanity check to prevent negative ammo wierdness
	return Min(iAmmo + AmmoPerTarget*Context.InputContext.MultiTargets.Length, ItemState.Ammo);
}

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local XComGameState_Item Weapon, SourceAmmo;

	if (UseLoadedAmmo)
	{
		SourceAmmo = kAbility.GetSourceAmmo();
		if (SourceAmmo != None)
		{
			if (SourceAmmo.HasInfiniteAmmo() || SourceAmmo.Ammo >= MinAmmoToFire)
				return 'AA_Success';
		}
	}
	else
	{
		Weapon = kAbility.GetSourceWeapon();
		if (Weapon != none)
		{
			// If the weapon has infinite ammo, the weapon must still have an ammo value
			// of at least one. This could happen if the weapon becomes disabled.
			if ((Weapon.HasInfiniteAmmo() && (Weapon.Ammo > 0)) || Weapon.Ammo >= MinAmmoToFire)
				return 'AA_Success';
		}	
	}

	if (bReturnChargesError)
		return 'AA_CannotAfford_Charges';

	return 'AA_CannotAfford_AmmoCost';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Item LoadedAmmoState;
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local int Cost;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	
	if (bFreeCost || AffectWeapon.HasInfiniteAmmo() || (`CHEATMGR != none && `CHEATMGR.bUnlimitedAmmo && Unit.GetTeam() == eTeam_XCom))	
		return;

	Cost = CalcFullAmmoCost(AbilityContext, AffectWeapon);

	kAbility.iAmmoConsumed = Cost;

	//  loaded ammo (aka grenades in a grenade launcher) track their own ammo, and we ignore the launcher's
	if (UseLoadedAmmo)
	{
		LoadedAmmoState = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceAmmo.ObjectID));
		if (LoadedAmmoState != None)
		{
			LoadedAmmoState = XComGameState_Item(NewGameState.ModifyStateObject(LoadedAmmoState.Class, LoadedAmmoState.ObjectID));
			LoadedAmmoState.Ammo -= Cost;
		}
	}
	else
	{
		AffectWeapon.Ammo -= Cost;
	}
}


defaultproperties
{
	MinAmmoToFire=1
	AmmoPerTarget=1
}