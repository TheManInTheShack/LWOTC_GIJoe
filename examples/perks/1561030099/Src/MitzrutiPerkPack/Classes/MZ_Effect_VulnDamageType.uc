class MZ_Effect_VulnDamageType extends X2Effect_Persistent;

var array<name> FireDamageTypes;
var float ExtraFireDamageMult;
var int ExtraFireDamageMin;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local array<name>					AppliedDamageTypes;
	local name							DamageType;
	local X2Effect_ApplyWeaponDamage	ApplyDamageEffect;
	local X2WeaponTemplate				Weapon;
	local WeaponDamageValue				WeaponDamage;
	//local X2AmmoTemplate				Ammo;
	//local int							i;

	if ( CurrentDamage == 0 ) { return 0; } 

	//We check for actual fire damage first, since it gets to do extra damage.
	ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (ApplyDamageEffect != none)
	{
		//downside with this approach is that it generally won't preview correctly. This will only trip when the effect is actually applied.
		ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);
		foreach AppliedDamageTypes(DamageType)
		{
			if (FireDamageTypes.Find(DamageType) != INDEX_NONE)
			{
				return GetDamageBonus(CurrentDamage);
			}
		}
	}
	else
	{
		//this is for previews, since the effect isn't actually being applied. so it's a lot more difficult to accurately predict damage types.
		//this should trip in previews for abilities that force the damage effect to have fire as an additional damage type.
		if (FireDamageTypes.Find(WeaponDamageEffect.EffectDamageValue.DamageType) != INDEX_NONE)
		{
			return GetDamageBonus(CurrentDamage);
		}

		foreach WeaponDamageEffect.DamageTypes(DamageType)
		{
			if (FireDamageTypes.Find(DamageType) != INDEX_NONE)
			{
				return GetDamageBonus(CurrentDamage);
			}
		}

		Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());

		if ( Weapon != none )
		{
			//this should catch weapons with fire base damage, but only when the ability uses base weapon damage.
			if ( !WeaponDamageEffect.bIgnoreBaseDamage && FireDamageTypes.Find(Weapon.BaseDamage.DamageType) != INDEX_NONE )
			{
				return GetDamageBonus(CurrentDamage);
			}

			//primarily used for psionic and gremlin abilities
			if ( WeaponDamageEffect.DamageTag != '' )
			{
				foreach Weapon.ExtraDamage(WeaponDamage)
				{
					if ( FireDamageTypes.Find(WeaponDamage.DamageType) != INDEX_NONE )
					{
						return GetDamageBonus(CurrentDamage);
					}
				}
			}

			/*
			if ( AbilityState.GetMyTemplate().bAllowAmmoEffects && AbilityState.GetSourceWeapon().HasLoadedAmmo() && !WeaponDamageEffect.bIgnoreBaseDamage)
			{
				Ammo = X2AmmoTemplate(AbilityState.GetSourceWeapon().GetLoadedAmmoTemplate(AbilityState));

				for (i=0; i < Ammo.DamageModifiers.Length; i++)
				{
					if (default.FireDamageTypes.Find(AmmoDamageModifier(Ammo.DamageModifiers[i]).DamageValue.DamageType))
					{
					}
				}
				//oh but we also need to check conditions. hrmph. on ice for now.
			}
			*/
		}
	}

	return 0;
}

function int GetDamageBonus(int CurrentDamage)
{
	return Max( ExtraFireDamageMin, Round(CurrentDamage * ExtraFireDamageMult));
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
	//should make it possible for hexes to replace each other with refresh mode.
	return true;
}

defaultproperties
{
	ExtraFireDamageMin=1
	bOffenseInstead=false
}