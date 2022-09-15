class MZ_Action_Meteor extends X2Action_BlazingPinionsStage2; // config(IriPsiOverhaul);
//based on the iridar's soulstorm one. Modified to hit a single location.

var private int TimeDelayIndexB;

//Cached info for the unit performing the action
//*************************************
/*
var private CustomAnimParams Params;
var private AnimNotify_FireWeaponVolley FireWeaponNotify;
var private int TimeDelayIndex;

var bool		ProjectileHit;
var XGWeapon	UseWeapon;
var XComWeapon	PreviousWeapon;
var XComUnitPawn FocusUnitPawn;
*/
//*************************************

//	This function fires a projectile between two points
function AddProjectile()
{
	local TTile SourceTile;
	local XComWorldData World;
	local vector SourceLocation, ImpactLocation;
	local int ZValue;
	local StateObjectReference	TargetRef;
	local XComGameState_Unit	TargetState;

	World = `XWORLD;

	// Calculate the upper z position for the projectile
	// Move it above the top level of the world a bit with *2
	ZValue = World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * 2;

	TargetRef = AbilityContext.InputContext.PrimaryTarget;

	TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));

	if (TargetState != none)
	{
		//ImpactLocation = AbilityContext.InputContext.TargetLocations[ProjectileIndex];	//	this just returns zero vector??? why is this necessary?
																						//	there is only one Target Location, probably returns zero because of non-zero ProjectileIndex
		//SourceTile = World.GetTileCoordinatesFromPosition(ImpactLocation);

		SourceTile = TargetState.TileLocation;
		ImpactLocation = World.GetPositionFromTileCoordinates(SourceTile);
		SourceTile.Z = ZValue;
		SourceLocation = World.GetPositionFromTileCoordinates(SourceTile);
		
		//ImpactLocation = SourceLocation;
		//ImpactLocation.Z = 0;
		
		//World.GetFloorPositionForTile(SourceTile, ImpactLocation);
		
		//`LOG("SourceLocation: " @ SourceLocation,, 'IRIDAR');
		//`LOG("ImpactLocation: " @ ImpactLocation,, 'IRIDAR');

		AddPsiPinionProjectile(SourceLocation, ImpactLocation, Unit);

	//		`SHAPEMGR.DrawSphere(SourceLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
	//		`SHAPEMGR.DrawSphere(ImpactLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
	}
	else
	{
		ImpactLocation = AbilityContext.InputContext.TargetLocations[0];
		SourceLocation = TargetLocation;
		SourceLocation.Z = ZValue;
	}
}

function AddPsiPinionProjectile(vector SourceLocation, vector TargetImpactLocation, XGUnit XGUnitVar)
{
	local XComWeapon WeaponEntity;
	local XComUnitPawn UnitPawnn;
	local X2UnifiedProjectile NewProjectile;
	local AnimNotify_FireWeaponVolley FireVolleyNotify;
	local Actor ProjectileActor;
	
	UnitPawnn = XGUnitVar.GetPawn();

	//The archetypes for the projectiles come from the weapon entity archetype
	WeaponEntity = XComWeapon(UnitPawnn.Weapon);

	if (WeaponEntity != none)
	{
		FireVolleyNotify = new class'AnimNotify_FireWeaponVolley';
		FireVolleyNotify.NumShots = 1;
		FireVolleyNotify.ShotInterval = 0.0f;
		FireVolleyNotify.bCosmeticVolley = true;
		
		/*
		//use this to set up projectiles for specific storm skills.
		Switch (AbilityContext.InputContext.AbilityTemplateName)
		{
			case 'woloowoloo':
		}
		*/

		ProjectileActor = Actor(`CONTENT.RequestGameArchetype("ANIM_MZPsi_BloodMagic.Projectile.PJ_Mindblast"));

		NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , ProjectileActor);
		NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContext, , , XGUnitVar.CurrentFireAction, SourceLocation, TargetImpactLocation, true);
		NewProjectile.GotoState('Executing');
	}
}

simulated state Executing
{
Begin:
	PreviousWeapon = XComWeapon(UnitPawn.Weapon);
	UnitPawn.SetCurrentWeapon(XComWeapon(UseWeapon.m_kEntity));

	Unit.CurrentFireAction = self;

	Sleep(`SYNC_FRAND() * 0.3f * GetDelayModifier());
	AddProjectile();

	while (!ProjectileHit)
	{
		Sleep(0.01f);
	}

	UnitPawn.SetCurrentWeapon(PreviousWeapon);

	Sleep(0.5f * GetDelayModifier()); // Sleep to allow destruction to be seenw

	CompleteAction();
}