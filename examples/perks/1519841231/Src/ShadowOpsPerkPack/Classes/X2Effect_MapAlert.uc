class X2Effect_MapAlert extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability ActivatedAbilityStateContext;
	local XComGameState_Item WeaponState, AmmoState;
	local XComGameState_AIUnitData AIUnitDataState;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local AlertAbilityInfo AlertInfo;
	local int SoundRange;
	local vector SoundLocation;

	History = `XCOMHISTORY;

	ActivatedAbilityStateContext = XComGameStateContext_Ability(NewGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	WeaponState = AbilityState.GetSourceWeapon();
	AmmoState = AbilityState.GetSourceAmmo();

	if (AmmoState != none)
		SoundRange = AmmoState.GetItemSoundRange();
	else
		SoundRange = WeaponState.GetItemSoundRange();

	SoundLocation = ActivatedAbilityStateContext.InputContext.TargetLocations[0];

	AlertInfo.AlertTileLocation = `XWORLD.GetTileCoordinatesFromPosition(SoundLocation);
	AlertInfo.AlertRadius = SoundRange;
	AlertInfo.AlertUnitSourceID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	AlertInfo.AnalyzingHistoryIndex = History.GetCurrentHistoryIndex();

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState == none)
		return;

	if( UnitState != None && UnitState.IsAlive() )
	{
		AIUnitDataState = XComGameState_AIUnitData(NewGameState.ModifyStateObject(class'XComGameState_AIUnitData', UnitState.GetAIUnitDataID()));

		if( !AIUnitDataState.AddAlertData(AIUnitDataState.m_iUnitObjectID, eAC_MapwideAlert_Peaceful, AlertInfo, NewGameState) )
		{
			NewGameState.PurgeGameStateForObjectID(AIUnitDataState.ObjectID);
		}
	}
}
