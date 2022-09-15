class MZ_Effect_Unscarred extends X2Effect_Persistent;

var int Bonus, PerTier, DRMult;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local X2ArmorTemplate			Armour;
	local XComGameState_Unit		SourceUnit;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) { return 0; }

	SourceUnit = XComGameState_Unit(TargetDamageable);

	if( SourceUnit.GetCurrentStat(eStat_HP) >= SourceUnit.GetMaxStat(eStat_HP) )
	{
		Armour = X2ArmorTemplate(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());

		Switch (Armour.ArmorTechCat)
		{
			case 'Powered':
				return 2*PerTier + Bonus;
			case 'Plated':
				return PerTier + Bonus;
			default:
				return Bonus;
		}
	}

	return 0;	
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit	Target;
	local X2ArmorTemplate			Armour;

	Target = XComGameState_Unit(TargetDamageable);

	if (Target.GetCurrentStat(eStat_HP) >= Target.GetMaxStat(eStat_HP))
	{
		Armour = X2ArmorTemplate(Target.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());
		
		Switch (Armour.ArmorTechCat)
		{
			case 'Powered':
				return -3 * DRMult;
			case 'Plated':
				return -2 * DRMult;
			default:
				return -1 * DRMult;
		}
	}
	return 0;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return TargetUnit.GetCurrentStat(eStat_HP) >= TargetUnit.GetMaxStat(eStat_HP) ;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}