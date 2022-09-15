class MZ_Effect_ShieldStabilized extends X2Effect_Persistent;

var int AimMod, PointBlankAimMod, CritPerTier;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return DamageType == 'KnockbackDamage';
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	local X2WeaponTemplate Weapon;
	
	Weapon = X2WeaponTemplate(Attacker.GetSecondaryWeapon().GetMyTemplate());

    if ( Weapon != none && Weapon.WeaponCat == 'shield')
    {
		if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			if ( !bMelee && !bFlanking && Target.GetMyTemplate().bCanTakeCover && Attacker.TileDistanceBetween(Target) < 2 )
			{
				AimShotModifier.Value = PointBlankAimMod;
			}
			else
			{
				AimShotModifier.Value = AimMod;
			}
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		if ( CritPerTier != 0){
			CritShotModifier.ModType = eHit_Crit;
			Switch ( Weapon.WeaponTech ){
				case 'beam':
					CritShotModifier.Value = 3*CritPerTier;
					break;
				case 'magnetic':
					CritShotModifier.Value = 2*CritPerTier;
					break;
				default:
					CritShotModifier.Value = CritPerTier;
					break;
			}
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
    }
}