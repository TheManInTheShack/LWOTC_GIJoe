class X2Effect_NoSquadsightPenalties extends XMBEffect_Extended;

function bool IgnoreSquadsightPenalty(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	return true;
}
