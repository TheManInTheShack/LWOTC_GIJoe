class MZ_TargetingMethod_SeismicShift extends X2TargetingMethod_Grenade;

var private X2Actor_InvalidTarget InvalidTileActor;
var private XComActionIconManager IconManager;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XGBattle Battle;

	super.Init(InAction, NewTargetIndex);

	Battle = `BATTLE;

	AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile", class'StaticMesh')));

	InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');
	ExplosionEmitter.SetHidden(true);

	IconManager = `PRES.GetActionIconMgr();
	IconManager.UpdateCursorLocation(true);
}

function Canceled()
{
	super.Canceled();

	// clean up the ui
	InvalidTileActor.Destroy();

	IconManager.ShowIcons(false);
}

function Update(float DeltaTime)
{
	local vector NewTargetLocation;
	local array<vector> TargetLocations;
	local array<TTile> Tiles;
	local XComWorldData World;
	local TTile TeleportTile;
	local array<Actor> CurrentlyMarkedTargets;
	
	NewTargetLocation = GetSplashRadiusCenter();

	if( NewTargetLocation != CachedTargetLocation )
	{
		TargetLocations.AddItem(NewTargetLocation);
		if( ValidateTargetLocations(TargetLocations) == 'AA_Success' )
		{
			// The current tile the cursor is on is a valid tile
			// Show the ExplosionEmitter
			InvalidTileActor.SetHidden(true);

			World = `XWORLD;
		
			TeleportTile = World.GetTileCoordinatesFromPosition(TargetLocations[0]);
			Tiles.AddItem(TeleportTile);

			GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
			CurrentlyMarkedTargets.RemoveItem(GetTargetedActor());

			MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
			//DrawSplashRadius();
			DrawAOETiles(Tiles);

			//would like to draw the tile you teleport to as blue or something.

			IconManager.UpdateCursorLocation(, true);
		}
		else
		{
			DrawInvalidTile();
			ClearTargetedActors();
		}
	}

	super.UpdateTargetLocation(DeltaTime);
}

simulated protected function DrawInvalidTile()
{
	local Vector Center;

	Center = GetSplashRadiusCenter();

	// Hide the ExplosionEmitter
	
	InvalidTileActor.SetHidden(false);
	InvalidTileActor.SetLocation(Center);
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local name AbilityAvailability;
	local TTile TeleportTile;
	local XComWorldData World;
	local bool bFoundFloorTile;

	AbilityAvailability = super.ValidateTargetLocations(TargetLocations);
	if( AbilityAvailability == 'AA_Success' )
	{
		// There is only one target location and visible by squadsight
		World = `XWORLD;
		
		`assert(TargetLocations.Length == 1);
		bFoundFloorTile = World.GetFloorTileForPosition(TargetLocations[0], TeleportTile);
		if( bFoundFloorTile && !World.CanUnitsEnterTile(TeleportTile) )
		{
			AbilityAvailability = 'AA_TileIsBlocked';
		}
	}

	return AbilityAvailability;
}

static function bool UseGrenadePath() { return false; }

defaultproperties
{
	bRestrictToSquadsightRange = true;
	SnapToTile = true;
}