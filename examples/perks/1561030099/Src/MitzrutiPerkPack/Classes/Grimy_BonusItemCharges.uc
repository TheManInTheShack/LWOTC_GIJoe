class Grimy_BonusItemCharges extends X2Effect_Persistent;

var int AmmoCount;
var array<name> ItemTemplateNames;
var bool bUtilityGrenades;
var bool bPocketGrenades;
var bool bLooseGrenades;
var bool bExcluderockets;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player) {
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item ItemState, NewItemState;
			
	// Check all of the unit's inventory items
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	ItemStates = UnitState.GetAllInventoryItems(NewGameState);

	if ( bUtilityGrenades ) {
		foreach ItemStates(ItemState) {
			// If a grenade in utility slot, add ammo
			if ( ItemState.InventorySlot == eInvSlot_Utility && ItemState.GetMyTemplate().IsA('X2GrenadeTemplate') ) {
				if ( !bExcluderockets || !ItemState.GetMyTemplate().IsA('X2RocketTemplate') ) {
					NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
					NewItemState.Ammo = ItemState.Ammo + AmmoCount * ItemState.MergedItemCount;
					NewGameState.AddStateObject(NewItemState);
				}
			}
		}
	}

	if ( bPocketGrenades ) {
		foreach ItemStates(ItemState) {
			// If a grenade in pocket slot, add ammo
			if ( ItemState.InventorySlot == eInvSlot_GrenadePocket && ItemState.GetMyTemplate().IsA('X2GrenadeTemplate') ) {
				if ( !bExcluderockets || !ItemState.GetMyTemplate().IsA('X2RocketTemplate') ) {
					NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
					NewItemState.Ammo = ItemState.Ammo + AmmoCount * ItemState.MergedItemCount;
					NewGameState.AddStateObject(NewItemState);
				}
			}
		}
	}

	if ( bLooseGrenades ) {
		foreach ItemStates(ItemState) {
			// If a grenade isn't in a grenade or secondary slot, add ammo
			if ( ItemState.InventorySlot != eInvSlot_GrenadePocket && ItemState.InventorySlot != eInvSlot_Utility && ItemState.GetMyTemplate().IsA('X2GrenadeTemplate') ) {
				if ( !bExcluderockets || !ItemState.GetMyTemplate().IsA('X2RocketTemplate') ) {
					NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
					NewItemState.Ammo = ItemState.Ammo + AmmoCount * ItemState.MergedItemCount;
					NewGameState.AddStateObject(NewItemState);
				}
			}
		}
	}

	if ( ItemTemplateNames.length > 0 ) {
		foreach ItemStates(ItemState) {
			// If the item's template name was specified, add ammo
			if (ItemTemplateNames.Find(ItemState.GetMyTemplateName()) != INDEX_NONE) {
				NewItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
				NewItemState.Ammo = ItemState.Ammo + AmmoCount * ItemState.MergedItemCount;
				NewGameState.AddStateObject(NewItemState);
			}
		}
	}

//	AddGrenades(NewGameState, UnitState);

	return false;
}
/*
simulated function AddGrenades(XComGameState NewGameState, XComGameState_Unit UnitState) {
	local X2AbilityTemplate		AbilityTemplate;
	local XComGameState_Item	NewGrenadeState;
	local X2EquipmentTemplate	EquipmentTemplate;

	NewGrenadeState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item'));
	NewGrenadeState.OnCreation(GetRandomGrenadeTemplate());
	
	EquipmentTemplate = X2EquipmentTemplate(NewGrenadeState.GetMyTemplate());
	UnitState.GetPawnArchetype("").SpawnCosmeticUnitPawn(none, eInvSlot_GrenadePocket, EquipmentTemplate.CosmeticUnitTemplate, UnitState, false);

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('LaunchGrenade');

	`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, UnitState.GetPrimaryWeapon().GetReference(), NewGrenadeState.GetReference());

	NewGameState.AddStateObject(NewGrenadeState);
}

simulated function X2GrenadeTemplate GetRandomGrenadeTemplate() {
	return X2GrenadeTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate('GasGrenade'));
}*/

defaultproperties
{
	bUtilityGrenades = false
	bPocketGrenades = false
	bLooseGrenades = false
	bExcluderockets = false
}