class ABetterBarracks_Condition_TargetNotArmored extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;
	local int CurrentArmor;
	
	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	//CurrentArmor = TargetUnit.GetArmorMitigation();
	CurrentArmor = TargetUnit.GetArmorMitigationForUnitFlag();

	if (CurrentArmor > 0)
		return 'AA_Armored';

	return 'AA_Success';
}