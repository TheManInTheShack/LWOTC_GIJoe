class MZ_Effect_DoubleGrip extends X2Effect_Persistent;

var array<name> DoubleGripWeaponCats, DoubleGripEmptyCats;
var int Bonus, PerTier, APBonus, APPerTier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local X2WeaponTemplate			Weapon;
	local X2WeaponTemplate			Offhand;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1 || !class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0) { return 0; }

	if ( AbilityState.GetSourceWeapon() == Attacker.GetPrimaryWeapon() )
	{
		Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if ( DoubleGripWeaponCats.Find(Weapon.WeaponCat) != INDEX_NONE )
		{
			Offhand = X2WeaponTemplate(Attacker.GetSecondaryWeapon().GetMyTemplate());
			if ( Offhand == none || DoubleGripEmptyCats.Find(Offhand.WeaponCat) != INDEX_NONE )
			{
				Switch (Weapon.WeaponTech)
				{
					case 'Beam':
						return 2*PerTier + Bonus;
					case 'Coil':
					case 'Magnetic':
						return PerTier + Bonus;
					default:
						return Bonus;
				}
			}
		}
	}
	
	return 0;	
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	local X2WeaponTemplate			Weapon;
	local X2WeaponTemplate			Offhand;

	if ( AbilityState.GetSourceWeapon() == Attacker.GetPrimaryWeapon() )
	{
		Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if ( DoubleGripWeaponCats.Find(Weapon.WeaponCat) != INDEX_NONE )
		{
			Offhand = X2WeaponTemplate(Attacker.GetSecondaryWeapon().GetMyTemplate());
			if ( Offhand == none || DoubleGripEmptyCats.Find(Offhand.WeaponCat) != INDEX_NONE )
			{
				Switch (Weapon.WeaponTech)
				{
					case 'Beam':
						return 2*APPerTier + APBonus;
					case 'Coil':
					case 'Magnetic':
						return APPerTier + APBonus;
					default:
						return APBonus;
				}
			}
		}
	}
	
	return 0;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}