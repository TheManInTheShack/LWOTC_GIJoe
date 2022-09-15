// This is an Unreal Script

class MZ_Effect_KillingStroke extends X2Effect_Persistent;

var float BonusMult, BetaBonusMult;
var int AimMod, GrazeMod, CritMod;	//maximum value granted only when cosuming 100% HP. so real value will always be slightly lower
var name AbilityName;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	//local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate			MyTemplate;
	local Grimy_AbilityCost_HP		AbilityCost;
	local int						i;
	local int						BloodCost;
	local int						HPCostFlat;
	local float						HPCostPercent;

	if (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1 ) { return 0; }

	MyTemplate = AbilityState.GetMyTemplate();
	
	for (i = 0; i < MyTemplate.AbilityCosts.Length; ++i)
	{	
		AbilityCost = Grimy_AbilityCost_HP(MyTemplate.AbilityCosts[i]);
		if( AbilityCost != none ) {
			HPCostFlat = AbilityCost.Cost;
			HPCostPercent = AbilityCost.PercentCost;
		}
	}

	BloodCost = Attacker.GetCurrentStat(eStat_HP) * HPCostPercent ;

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
		BloodCost = Attacker.GetCurrentStat(eStat_HP) -1;
	}

	if ( `SecondWaveEnabled('BetaStrike') ) { return BloodCost * BetaBonusMult; }
	return BloodCost * BonusMult;
		
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local X2AbilityTemplate			MyTemplate;
	local Grimy_AbilityCost_HP		AbilityCost;
	local int						i;
	local int						BloodCost;
	local int						HPCostFlat;
	local float						HPCostPercent;
	local float						HPPaidPercent;
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	local ShotModifierInfo GrazeShotModifier;

	if (AbilityState.GetMyTemplateName() == AbilityName) {
	
		MyTemplate = AbilityState.GetMyTemplate();
	
		for (i = 0; i < MyTemplate.AbilityCosts.Length; ++i)
		{	
			AbilityCost = Grimy_AbilityCost_HP(MyTemplate.AbilityCosts[i]);
			if( AbilityCost != none ) {
				HPCostFlat = AbilityCost.Cost;
				HPCostPercent = AbilityCost.PercentCost;
			}
		}

		//if ( HPCostFlat < 1  && HPCostPercent <= 0) { return 0; }

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

		HPPaidPercent = BloodCost / Attacker.GetMaxStat(eStat_HP);

		if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = HPPaidPercent * AimMod;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		if ( CritMod != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = HPPaidPercent * CritMod;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}

		if ( GrazeMod != 0){
			GrazeShotModifier.ModType = eHit_Graze;
			GrazeShotModifier.Value = HPPaidPercent * GrazeMod;
			GrazeShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(GrazeShotModifier);
		}
	}

}

defaultproperties
{
	BonusMult = 1.0
	BetaBonusMult = 0.5
	AimMod = 0
	CritMod = 0
	GrazeMod = 0
	AbilityName = "MZKillingStroke"
	bDisplayInSpecialDamageMessageUI = true
}