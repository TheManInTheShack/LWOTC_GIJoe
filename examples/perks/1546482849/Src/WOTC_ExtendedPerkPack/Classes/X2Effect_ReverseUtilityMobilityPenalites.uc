class X2Effect_ReverseUtilityMobilityPenalites extends X2Effect_ModifyStats;

var array<EInventorySlot> SlotsToCheck;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> Items;
	local XComGameState_Item Item;
	local X2EquipmentTemplate EquipmentTemplate;
	local int MobilityOffset;
	local StatChange EffectStatChange;
	local EInventorySlot Slot;

	MobilityOffset = 0;

	UnitState = XComGameState_Unit(kNewTargetState);

	foreach SlotsToCheck(Slot)
	{
		Items = UnitState.GetAllItemsInSlot(Slot);
		foreach Items(Item)
		{
			EquipmentTemplate = X2EquipmentTemplate(Item.GetMyTemplate());
			if(EquipmentTemplate != none)
			{
				if(EquipmentTemplate.Abilities.Find('SmallItemWeight') != -1)
				{
					MobilityOffset++;
				}
			}
		}
	}
	
	EffectStatChange.StatType = eStat_Mobility;
	EffectStatChange.StatAmount = MobilityOffset;
	EffectStatChange.ModOp = MODOP_Addition;

	NewEffectState.StatChanges.AddItem(EffectStatChange);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}