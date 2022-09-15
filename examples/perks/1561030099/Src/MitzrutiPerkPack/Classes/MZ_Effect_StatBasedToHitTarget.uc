Class MZ_Effect_StatBasedToHitTarget extends X2Effect_Persistent;

var ECharStatType UseStat;
var float AimMod, CritMod, GrazeMod;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item	ItemState;
	local X2GremlinTemplate		GremlinTemplate;
	local int					StatAmount;
	local ShotModifierInfo		AimShotModifier;
    local ShotModifierInfo		CritShotModifier;
	local ShotModifierInfo		GrazeShotModifier;
	local XComGameState_Unit	SourceUnit;

	SourceUnit = EffectState.GetSourceUnitAtTimeOfApplication();
		
	ItemState = AbilityState.GetSourceWeapon();
	if (ItemState != none && UseStat == eStat_Hacking)
	{
		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
		if (GremlinTemplate != none)
		{
			
			StatAmount = GremlinTemplate.HackingAttemptBonus + SourceUnit.GetCurrentStat(eStat_Hacking);
		}
		else
		{
			StatAmount = SourceUnit.GetCurrentStat(UseStat);
		}
	}
	else
	{
		StatAmount = SourceUnit.GetCurrentStat(UseStat);
	}

	if ( AimMod != 0){
		AimShotModifier.ModType = eHit_Success;
		AimShotModifier.Value = AimMod * StatAmount;
		AimShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(AimShotModifier);
	}
	
	if ( CritMod != 0){
		CritShotModifier.ModType = eHit_Crit;
		CritShotModifier.Value = CritMod * StatAmount;
		CritShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(CritShotModifier);
	}
	
	if ( GrazeMod != 0){
		GrazeShotModifier.ModType = eHit_Graze;
		GrazeShotModifier.Value = GrazeMod * StatAmount;
		GrazeShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(GrazeShotModifier);
	}
	
}