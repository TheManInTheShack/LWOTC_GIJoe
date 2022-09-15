class MZ_Condition_HasOneEffect extends X2Condition;
//for when the target needs to have one of several effects, but not nessecarily all of them
//for example, something like MZLiquidMagic can ony be used if the target has a valid focus effect.

var array<name> EffectNames;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{ 
	local XComGameState_Unit	TargetUnit;
	local name					TestName;

	TargetUnit = XComGameState_Unit(kTarget);

	foreach EffectNames(TestName)
	{
		if ( TargetUnit.IsUnitAffectedByEffectName(TestName) )
		{
			return 'AA_Success';
		}
	}

	return 'AA_MissingRequiredEffect';
}