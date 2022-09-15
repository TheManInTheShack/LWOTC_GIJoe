// This is an Unreal Script
class MZ_Effect_PoisonTrail extends X2Effect;

//Adpted from Iridar's Fire Trail
var float radius;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit	UnitState;
	local XComWorldData			WorldData;
	//local vector				TargetLocation;
	local array<TilePosPair>	OutTiles;
	local TilePosPair			TilePair;
	//local X2Effect_ApplyFireToWorld Effect;

	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none /*&& UnitState.IsUnitAffectedByEffectName('IRI_Effect_Wildfire') && UnitState.IsUnitAffectedByEffectName(class'X2StatusEffects'.default.BurningName)*/)
	{
		WorldData = `XWORLD;
		//TargetLocation = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);		
		//TargetLocation.X += class'XComWorldData'.const.WORLD_StepSize * 2;
		//TargetLocation.Y += class'XComWorldData'.const.WORLD_StepSize * 2;
		//WorldData.FindClosestValidLocation(WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation), true, true); //WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);		
		TilePair.WorldPos = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
		TilePair.Tile = UnitState.TileLocation;
		OutTiles.AddItem(TilePair);

		WorldData.CollectTilesInSphere(OutTiles, TilePair.WorldPos, class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER * radius);
		
		class'X2Effect_ApplyPoisonToWorld'.static.AddEffectToTiles('X2Effect_ApplyPoisonToWorld', X2Effect_ApplyPoisonToWorld(class'Engine'.static.FindClassDefaultObject("X2Effect_ApplyPoisonToWorld")), NewGameState, OutTiles, TilePair.WorldPos, 2.0, 100, UnitState);
		//class'X2Effect_ApplyPoisonToWorld'.static.SharedApplyFireToTiles('X2Effect_ApplyFireToWorld', X2Effect_ApplyFireToWorld(class'Engine'.static.FindClassDefaultObject("X2Effect_ApplyFireToWorld")), NewGameState, OutTiles, UnitState, 2);
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

/*simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Fire AddFireAction;
	local XComGameState_WorldEffectTileData GameplayTileUpdate;

	GameplayTileUpdate = XComGameState_WorldEffectTileData(ActionMetadata.StateObject_NewState);
	
	// since we also make smoke, we don't want to add fire effects for those track states
	if((GameplayTileUpdate != none) && (GameplayTileUpdate.WorldEffectClassName == class'X2Effect_ApplyFireToWorld'.Name) && (GameplayTileUpdate.SparseArrayIndex > -1))
	{
		AddFireAction = X2Action_UpdateWorldEffects_Fire(class'X2Action_UpdateWorldEffects_Fire'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		//AddFireAction.bCenterTile = true;	//	works along Z axis, methinks
		AddFireAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}*/

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Poison AddPoisonAction;
	if( ActionMetadata.StateObject_NewState.IsA('XComGameState_WorldEffectTileData') )
	{
		AddPoisonAction = X2Action_UpdateWorldEffects_Poison(class'X2Action_UpdateWorldEffects_Poison'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		//AddPoisonAction.bCenterTile = bCenterTile;
		AddPoisonAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}

event array<ParticleSystem> GetParticleSystem_Fill()
{
	local array<ParticleSystem> ParticleSystems;
	ParticleSystems.AddItem(none);
	ParticleSystems.AddItem(ParticleSystem(DynamicLoadObject(class'X2Effect_ApplyPoisonToWorld'.default.PoisonParticleSystemFill_Name, class'ParticleSystem')));
	return ParticleSystems;
}