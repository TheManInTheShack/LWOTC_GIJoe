class X2Condition_NonReactionFire extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local X2AbilityToHitCalc_StandardAim StandardAim;

	StandardAim = X2AbilityToHitCalc_StandardAim(kAbility.GetMyTemplate().AbilityToHitCalc);
	if (StandardAim == none || StandardAim.bReactionFire)
		return 'AA_ReactionFire';  // NOTE: Nonstandard AA code

	return 'AA_Success';
}