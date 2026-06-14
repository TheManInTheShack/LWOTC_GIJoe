class X2StrategyElement_XpackStaffSlots_MFSC extends X2StrategyElement_XpackStaffSlots;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> StaffSlots;

	StaffSlots.AddItem(MFSCCreateCovertActionSoldierStaffSlotTemplate('CovertActionSoldierStaffSlot'));

	return StaffSlots;
}

static function X2StaffSlotTemplate MFSCCreateCovertActionSoldierStaffSlotTemplate(Name TemplateName)
{
	local X2StaffSlotTemplate Template;

	Template = CreateCovertActionStaffSlotTemplate(TemplateName);
	Template.bSoldierSlot = true;
	Template.GetNameDisplayStringFn = GetCovertActionSoldierNameDisplayString;
	Template.IsUnitValidForSlotFn = MFSC_IsUnitValidForCovertActionSoldierSlot;
	
	return Template;
}

static function bool MFSC_IsUnitValidForCovertActionSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	local name CharacterTemplateName;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

	if (Unit.CanBeStaffed()
		&& Unit.IsSoldier() && !Unit.IsRobotic()
		&& Unit.IsActive(true) && Unit.GetMentalState(true) == eMentalState_Ready
		&& (SlotState.RequiredMinRank == 0 || Unit.GetRank() >= SlotState.RequiredMinRank)
		&& (!SlotState.bRequireFamous || Unit.bIsFamous))
	{
		if (SlotState.RequiredClass == '')
			return true;
			
		if (Unit.GetSoldierClassTemplateName() == SlotState.RequiredClass)
			return true;

		// allow any faction soldier class in a faction soldier slot
		if (SlotState.RequiredClass == 'Reaper' || SlotState.RequiredClass == 'Skirmisher' || SlotState.RequiredClass == 'Templar') {
			CharacterTemplateName = class'XComGameState_Unit_MFSC'.static.GetCharTemplateNameForUnit(Unit);
			if (CharacterTemplateName == name(string(SlotState.RequiredClass) $ "Soldier")) {
				return true;
			}
		}
	}

	return false;
}


