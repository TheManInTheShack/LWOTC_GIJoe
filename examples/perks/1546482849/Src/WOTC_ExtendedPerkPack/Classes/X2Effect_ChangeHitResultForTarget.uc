class X2Effect_ChangeHitResultForTarget extends XMBEffect_ChangeHitResultForAttacker;

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
    return false;
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local X2EventManager EventMgr;
	local UnitValue CountUnitValue;

	if (ValidateAttack(EffectState, Attacker, TargetUnit, AbilityState) != 'AA_Success')
		return false;

	`Log(self @ "[" $ EffectName $ "]:" @ CurrentResult);

	if (IncludeHitResults.Length > 0 && IncludeHitResults.Find(CurrentResult) == INDEX_NONE)
		return false;
	if (ExcludeHitResults.Length > 0 && ExcludeHitResults.Find(CurrentResult) != INDEX_NONE)
		return false;

	if (bRequireHit && !class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;
	if (bRequireMiss && !class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult))
		return false;

	if (CountValueName != '')
	{
		TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
		if (MaxChangesPerTurn >= 0 && CountUnitValue.fValue >= MaxChangesPerTurn)
			return false;

		TargetUnit.SetUnitFloatValue(CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
	}

	if (TriggeredEvent != '')
	{
		EventMgr = `XEVENTMGR;
		EventMgr.TriggerEvent(TriggeredEvent, AbilityState, TargetUnit);
	}

	NewHitResult = NewResult;
	return true;
}