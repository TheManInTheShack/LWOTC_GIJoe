class MZ_Effect_BladeGrasp extends X2Effect_Persistent;

var bool bDeflectNonMelee, bDeflectAOE;
var int MinDeflect, MaxDeflect;
var float WillMod;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local int								Chance, RandRoll;
	//local X2AbilityToHitCalc_StandardAim	AttackToHit;
	local UnitValue							ParryUnitValue;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	if (!TargetUnit.IsAbleToAct())
		return false;

	//	check for parry first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Parry') && TargetUnit.GetUnitValue('Parry', ParryUnitValue))
	{
		if (ParryUnitValue.fValue > 0)
		{
			return false;
		}		
	}

	//	check for untouchable first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Untouchable') && TargetUnit.Untouchable > 0)
	{
		return false;		
	}

	if ((AbilityState.IsMeleeAbility() || bDeflectNonMelee) && (bIsPrimaryTarget || bDeflectAOE))
	{
		//WillPercent = 100.0 * (TargetUnit.GetCurrentStat(eStat_Will) / TargetUnit.GetMaxStat(eStat_Will))
		Chance = Clamp(WillMod * TargetUnit.GetCurrentStat(eStat_Will), MinDeflect, MaxDeflect);
		RandRoll = `SYNC_RAND(100);
		if (RandRoll <= Chance)
		{
			NewHitResult = eHit_LightningReflexes; //eHit_Deflect;
			return true;
		}
	}
}