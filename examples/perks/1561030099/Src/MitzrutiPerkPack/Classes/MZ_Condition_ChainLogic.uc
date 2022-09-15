class MZ_Condition_ChainLogic extends X2Condition;

var XComGameState_Unit Caster;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);

	if ( TargetUnit == none || Caster == none ) { return 'AA_NotAUnit'; }

	if ( TargetUnit.GetMyTemplate().bIsCivilian || TargetUnit.GetMyTemplate().bIsCosmetic || TargetUnit.GetMyTemplate().bIsHostileCivilian || TargetUnit.IsFriendlyUnit(Caster) ) { return 'AA_NotInRange'; }
	if ( TargetUnit.IsDead() || TargetUnit.IsBleedingOut() || TargetUnit.IsUnconscious() || TargetUnit.IsInStasis() ) { return 'AA_UnitIsDead'; }

	return 'AA_Success';
}