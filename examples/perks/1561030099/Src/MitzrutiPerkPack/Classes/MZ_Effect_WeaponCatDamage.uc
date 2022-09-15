class MZ_Effect_WeaponCatDamage extends X2Effect_Persistent;

var array<name> WeaponCats;
var int DamagePerTier, DamageBase;

var int ShredPerTier, ShredBase;

function bool IsRightWeaponCat(XComGameState_Item SourceWeapon)
{
	return (SourceWeapon != none && WeaponCats.Find(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponCat) != INDEX_NONE);
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (IsRightWeaponCat(SourceWeapon))
	{
		Switch ( X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponTech )
		{
			case 'Beam':
				return DamageBase + 2*DamagePerTier;
			case 'Magnetic':
				return DamageBase + 1*DamagePerTier;
			default:
				return DamageBase;
		}
	}
	return 0;
}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) {
	local XComGameState_Item SourceWeapon;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (IsRightWeaponCat(SourceWeapon))
	{
		Switch ( X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponTech )
		{
			case 'Beam':
				return ShredBase + 2*ShredPerTier;
			case 'Magnetic':
				return ShredBase + 1*ShredPerTier;
			default:
				return ShredBase;
		}
	}
	return 0;
}