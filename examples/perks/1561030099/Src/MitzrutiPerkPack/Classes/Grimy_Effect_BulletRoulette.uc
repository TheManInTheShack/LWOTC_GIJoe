class Grimy_Effect_BulletRoulette extends X2Effect_Persistent config(GrimyPerkPorts);

var config array<name> AmmoTemplateNames;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player) {
	local XComGameState_Unit					UnitState;
	local XComGameStateHistory					History;
	local Grimy_BulletRouletteState	ContainerState;
	local XComGameState_Item					AmmoState, NewAmmoState, NewWeaponState;
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local name									AbilityName;
	local X2AmmoTemplate						AmmoTemplate;
		
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit',ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	ContainerState = Grimy_BulletRouletteState(UnitState.FindComponentObject(class'Grimy_BulletRouletteState',false));
	if ( ContainerState == none ) {
		ContainerState = Grimy_BulletRouletteState(NewGameState.CreateStateObject(class'Grimy_BulletRouletteState'));
		UnitState.AddComponentObject(ContainerState);
	}

	NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', UnitState.GetPrimaryWeapon().ObjectID));

	AmmoState = XComGameState_Item(History.GetGameStateForObjectID(NewWeaponState.LoadedAmmo.ObjectID));
	if ( AmmoState != none ) {
		AmmoTemplate = X2AmmoTemplate(AmmoState.GetMyTemplate());
		foreach AmmoTemplate.Abilities(AbilityName) {
			UnitState.Abilities.RemoveItem(UnitState.FindAbility(AbilityName));
		}
	}

	if ( ContainerState.AmmoState != none ) {
		NewGameState.RemoveStateObject(AmmoState.ObjectID);
	}
	NewAmmoState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item'));
	AmmoTemplate = GetRandomAmmoTemplate();
	NewAmmoState.OnCreation(AmmoTemplate);

	ContainerState.AmmoState = NewAmmoState;
	
	NewWeaponState.LoadedAmmo = ContainerState.AmmoState.GetReference();

	foreach AmmoTemplate.Abilities(AbilityName) {
		AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
		`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState,AmmoState.GetReference());
	}
	
	NewGameState.AddStateObject(UnitState);
	NewGameState.AddStateObject(ContainerState);
	NewGameState.AddStateObject(NewAmmoState);
	NewGameState.AddStateObject(NewWeaponState);
	return false;
}

simulated function X2AmmoTemplate GetRandomAmmoTemplate() {
	return X2AmmoTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(AmmoTemplateNames[`SYNC_RAND(AmmoTemplateNames.length)]));
}