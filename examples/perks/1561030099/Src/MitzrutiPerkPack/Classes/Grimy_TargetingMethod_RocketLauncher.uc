/*class Grimy_TargetingMethod_RocketLauncher extends X2TargetingMethod_Grenade;

static function bool UseGrenadePath() { return false; }

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local vector NewTargetLocation;
	local array<TTile> Tiles;
	local TTile SnapTile;

	NewTargetLocation = GetSplashRadiusCenter();
	World = `XWORLD;
	SnapTile = World.GetTileCoordinatesFromPosition( NewTargetLocation );

	if ( !class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(FiringUnit.ObjectID, SnapTile) ) {
		if( World.VoxelRaytrace_Locations(FiringUnit.Location, NewTargetLocation, Raytrace) ) {
			NewTargetLocation = RayTrace.TraceBlocked;
		}
	}

	if(NewTargetLocation != CachedTargetLocation)
	{		
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.Update(DeltaTime);
}*/

class Grimy_TargetingMethod_RocketLauncher extends X2TargetingMethod_RocketLauncher;
//this would prolly be better named multihook targeting method, but...

var private X2Actor_InvalidTarget InvalidTileActor;
var private XComActionIconManager IconManager;

function Update(float DeltaTime)
{
	local XComWorldData					World;
	local VoxelRaytraceCheckResult		Raytrace;
	//local array<Actor>					CurrentlyMarkedTargets;
	local int							Direction, CanSeeFromDefault;
	local UnitPeekSide					PeekSide;
	local int							OutRequiresLean;
	local TTile							BlockedTile, PeekTile, UnitTile, SnapTile, TargetTile, TeleportTile;
	local CachedCoverAndPeekData		PeekData;
	local array<TTile>					Tiles;
	local GameRulesCache_VisibilityInfo VisibilityInfo;
	local vector						FiringLocation;
	local array<vector>					TargetLocations;
	local bool							GoodView;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	if( NewTargetLocation != CachedTargetLocation )
	{
		FiringLocation = FiringUnit.Location;
		FiringLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;
		World = `XWORLD;
		GoodView = false;
		if( World.VoxelRaytrace_Locations(FiringLocation, NewTargetLocation, Raytrace) )
		{
			BlockedTile = Raytrace.BlockedTile; 
			//  check left and right peeks
			FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, VisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

			if (PeekSide != eNoPeek)
			{
				UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
				PeekData = World.GetCachedCoverAndPeekData(UnitTile);
				if (PeekSide == ePeekLeft)
					PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
				else
					PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

				TargetTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
				if (!World.VoxelRaytrace_Tiles(PeekTile, TargetTile, Raytrace))
					GoodView = true;
				else
					BlockedTile = Raytrace.BlockedTile;
			}				
		}		
		else
		{
			GoodView = true;
		}

		if( !GoodView )
		{
			NewTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
			Cursor.CursorSetLocation(NewTargetLocation);
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}
		else
		{
			if (SnapToTile)
			{
				SnapTile = `XWORLD.GetTileCoordinatesFromPosition(NewTargetLocation);
				`XWORLD.GetFloorPositionForTile(SnapTile, NewTargetLocation);
			}
		}

		TargetLocations.AddItem(Cursor.GetCursorFeetLocation());
		if( ValidateTargetLocations(TargetLocations) == 'AA_Success' )
		{
			// The current tile the cursor is on is a valid tile
			// Show the ExplosionEmitter
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
			InvalidTileActor.SetHidden(true);

			//World = `XWORLD;
		
			TeleportTile = World.GetTileCoordinatesFromPosition(TargetLocations[0]);
			Tiles.AddItem(TeleportTile);
			DrawAOETiles(Tiles);
			IconManager.UpdateCursorLocation(, true);
		}
		else
		{
			DrawInvalidTile();
		}

		//GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		//CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		//MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		//DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);
}

simulated protected function DrawInvalidTile()
{
	local Vector Center;

	Center = GetSplashRadiusCenter();

	// Hide the ExplosionEmitter
	ExplosionEmitter.ParticleSystemComponent.DeactivateSystem();
	
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

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XGBattle Battle;

	super.Init(InAction, NewTargetIndex);

	Battle = `BATTLE;

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


defaultproperties
{
	SnapToTile = true;
}