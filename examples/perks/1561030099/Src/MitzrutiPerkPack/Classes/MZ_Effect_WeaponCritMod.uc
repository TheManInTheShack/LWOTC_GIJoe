class MZ_Effect_WeaponCritMod extends X2Effect_Persistent;

var array<name> WeaponCats;
var int CritDamage;
var int CritChance;
var bool UseBaseCritDamage;
var bool NonCritInvertsBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && WeaponCats.Find(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponCat) != INDEX_NONE)
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{		
			if ( UseBaseCritDamage )
			{
				return X2WeaponTemplate(SourceWeapon.GetMyTemplate()).BaseDamage.Crit;
			}
			else
			{
				return CritDamage;
			}
		}
		else if ( NonCritInvertsBonus )
		{
			if ( UseBaseCritDamage )
			{
				return -X2WeaponTemplate(SourceWeapon.GetMyTemplate()).BaseDamage.Crit;
			}
			else
			{
				return -CritDamage;
			}
		}
	}



	return 0;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritShotModifier;
	local XComGameState_Item SourceWeapon;
	
    SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && WeaponCats.Find(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponCat) != INDEX_NONE)
	{
		if ( CritChance != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritChance;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
    }
}