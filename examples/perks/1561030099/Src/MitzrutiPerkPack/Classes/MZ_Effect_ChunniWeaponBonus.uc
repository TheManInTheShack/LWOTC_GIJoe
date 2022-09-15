class MZ_Effect_ChunniWeaponBonus extends X2Effect_Persistent;
//provides a bonus to weapons with nicknames exceeding a certain length.

var int ChunniNameLength;
var int CritDamage;
var int CritChance;
var bool UseBaseCritDamage;
var bool NonCritInvertsBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none &&  Len(SourceWeapon.Nickname) >= ChunniNameLength)
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{		
			if ( UseBaseCritDamage )
			{
				return X2WeaponTemplate(SourceWeapon.GetMyTemplate()).BaseDamage.Crit;
			}
			else
			{
				return CritDamage * Min(Len(SourceWeapon.Nickname), 20) / 10;
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
				return -CritDamage * Min(Len(SourceWeapon.Nickname), 20) / 10;
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
	
	if (SourceWeapon != none && Len(SourceWeapon.Nickname) >= ChunniNameLength)
	{
		if ( CritChance != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritChance * Min(Len(SourceWeapon.Nickname), 20) / 10;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
    }
}