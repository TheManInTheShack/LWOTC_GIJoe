class MZ_Effect_CritByAbilitySet extends X2Effect_Persistent;

var array<name> AbilityNames;
var float CritPerAbility, CritDamagePerAbility;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local name	AbilityName;
	local int	Bonus;

	if ( AppliedData.AbilityResultContext.HitResult != eHit_Crit || AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE ) { return 0; }

	Bonus=0;
	foreach AbilityNames(AbilityName)
	{
		if ( Attacker.HasSoldierAbility(AbilityName, true) ) { Bonus += 1; }
	}

	return Bonus * CritDamagePerAbility;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritShotModifier;
	local name	AbilityName;
	local int	Bonus;

	if (AbilityNames.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		Bonus=0;
		foreach AbilityNames(AbilityName)
		{
			if ( Attacker.HasSoldierAbility(AbilityName, true) ) { Bonus += 1; }
		}

		if ( Bonus != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = Bonus * CritPerAbility;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
    }
}