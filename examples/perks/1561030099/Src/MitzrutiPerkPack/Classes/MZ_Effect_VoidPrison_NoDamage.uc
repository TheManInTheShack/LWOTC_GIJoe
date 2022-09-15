class MZ_Effect_VoidPrison_NoDamage extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue ConduitValue;
	local int ActionsToTick, ActionsLeft;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	
	TargetUnit.GetUnitValue(class'X2Effect_PersistentVoidConduit'.default.VoidConduitActionsLeft, ConduitValue);
	if (ConduitValue.fValue > 0)
	{
		//	make an assumption here that the unit would otherwise have the full amount of actions this turn
		//	this effect should pre-empt other similar effects, so hopefully this is "safe" but I guess we'll find out.
		ActionsToTick = TargetUnit.GetMyTemplate().bCanTickEffectsEveryAction ? 1 : class'X2CharacterTemplateManager'.default.StandardActionsPerTurn;
		if (ActionsToTick > ConduitValue.fValue)
			ActionsToTick = ConduitValue.fValue;
		ActionsLeft = ConduitValue.fValue - ActionsToTick;

		TargetUnit.SetUnitFloatValue(class'X2Effect_PersistentVoidConduit'.default.StolenActionsThisTick, ActionsToTick, eCleanup_BeginTurn);
		TargetUnit.SetUnitFloatValue(class'X2Effect_PersistentVoidConduit'.default.VoidConduitActionsLeft, ActionsLeft, eCleanup_BeginTactical);
	}
	else
	{
		TargetUnit.ClearUnitValue(class'X2Effect_PersistentVoidConduit'.default.StolenActionsThisTick);
		TargetUnit.ClearUnitValue(class'X2Effect_PersistentVoidConduit'.default.VoidConduitActionsLeft);
		return;
	}
}