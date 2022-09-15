// This is an Unreal Script

class MZ_Effect_BloodyMadness extends X2Effect_Persistent;

var float BonusMult;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	//local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate			MyTemplate;
	local Grimy_AbilityCost_HP		AbilityCost;
	local int						i;
	local int						BloodCost;
	local int						HPCostFlat;
	local float						HPCostPercent;
	local float						HealthPercent;
	local float						PowerMult;

	MyTemplate = AbilityState.GetMyTemplate();

	for (i = 0; i < MyTemplate.AbilityCosts.Length; ++i)
	{	
		AbilityCost = Grimy_AbilityCost_HP(MyTemplate.AbilityCosts[i]);
		if( AbilityCost != none ) {
			HPCostFlat = AbilityCost.Cost;
			HPCostPercent = AbilityCost.PercentCost;
		}
	}

	if ( HPCostFlat < 1  && HPCostPercent <= 0) { return 0; }

	BloodCost = 0;
	if ( HPCostPercent  > 0 )
	{
		BloodCost = Attacker.GetCurrentStat(eStat_HP) * HPCostPercent ;
	}

	if ( BloodCost < HPCostFlat )
	{
		BloodCost = HPCostFlat;
	}

	if ( Attacker.HasSoldierAbility('MZDropByDrop') )
	{
		if ( BloodCost > 1 )
		{
			BloodCost = BloodCost - class'MZBloodMagic_AbilitySet'.default.DropByDrop_HPCostDown;
			if ( BloodCost <= 0 ) { BloodCost = 1; }
		}
	}

	if ( Attacker.HasSoldierAbility('MZDarkPotency') && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		BloodCost = BloodCost + class'MZBloodMagic_AbilitySet'.default.DarkPotency_HPCostUp;
	}

	if ( BloodCost >= Attacker.GetCurrentStat(eStat_HP) )
	{
		BloodCost = Attacker.GetCurrentStat(eStat_HP) - 1;
	}

	

	HealthPercent = (Attacker.GetCurrentStat(eStat_HP) - BloodCost) / Attacker.GetMaxStat(eStat_HP);
	PowerMult = ((( 2 - Healthpercent ) * ( 2 - HealthPercent )) - 1) * BonusMult;

	return CurrentDamage * PowerMult;
		
}

defaultproperties
{
	BonusMult = 1.0
	bDisplayInSpecialDamageMessageUI = true
}