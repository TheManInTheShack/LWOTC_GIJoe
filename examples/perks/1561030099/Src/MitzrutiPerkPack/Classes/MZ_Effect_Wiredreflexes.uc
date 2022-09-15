class MZ_Effect_Wiredreflexes extends X2Effect_Persistent;

var int AtkChance, DefChance;

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local X2AbilityToHitCalc_StandardAim Aim;

	Aim = X2AbilityToHitCalc_StandardAim( AbilityState.GetMyTemplate().AbilityToHitCalc);
	If ( Aim == none || Aim.bReactionFire == false ) { return false;}

	If ( `SYNC_RAND(100) < AtkChance )
	{
		switch (CurrentResult)
		{
		case eHit_Deflect:
		case eHit_Miss:
			NewHitResult = eHit_Graze;
			return true;
		case eHit_Graze:
			NewHitResult = eHit_Success;
			return true;
		case eHit_Success:
			NewHitResult = eHit_Crit;
			return true;
		default:
			break;
		}
	}

	return false; 
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{ 
	local X2AbilityToHitCalc_StandardAim Aim;

	Aim = X2AbilityToHitCalc_StandardAim( AbilityState.GetMyTemplate().AbilityToHitCalc);
	If ( Aim == none || Aim.bReactionFire == false ) { return false;}

	If ( `SYNC_RAND(100) < DefChance )
	{
		switch (CurrentResult)
		{
		case eHit_Crit:
			NewHitResult = eHit_Success;
			return true;
		case eHit_Success:
			NewHitResult = eHit_Graze;
			return true;
		case eHit_Graze:
			NewHitResult = eHit_Miss;
			return true;
		default:
			break;
		}
	}

	return false; 
}
