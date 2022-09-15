class MZ_TargetMethod_MeleeWithRadius extends X2TargetingMethod_MeleePath;

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local array<TTile> Tiles;

	super.Update(DeltaTime);

	GetTargetedActors(GetTargetedActor().Location, CurrentlyMarkedTargets, Tiles);
	CurrentlyMarkedTargets.RemoveItem(GetTargetedActor());

	MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);

	DrawAOETiles(Tiles);
}

function Canceled()
{
	super.Canceled();

	ClearTargetedActors();
}

protected function Vector GetPathDestination()
{
	local XComWorldData WorldData;
	local TTile Tile;

	WorldData = `XWORLD;
	if (PathingPawn.PathTiles.Length > 0)
	{
		Tile = PathingPawn.PathTiles[PathingPawn.PathTiles.Length - 1];
	}
	else
	{
		Tile = UnitState.TileLocation;
	}

	return WorldData.GetPositionFromTileCoordinates(Tile);
}