class X2Effect_SpinKickDamage extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int SpinKickDamageBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local float ExtraDamage;

	if (AbilityState.GetMyTemplateName() == 'KVSpinKick' && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult)) //|| (AbilityState.GetMyTemplateName() == 'KVSpinKick2' && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult)))
	{
		ExtraDamage = (CurrentDamage) * SpinKickDamageBonus;
		//ExtraDamage = CurrentDamage + SpinKickDamageBonus;
	}
	return int (ExtraDamage);
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}