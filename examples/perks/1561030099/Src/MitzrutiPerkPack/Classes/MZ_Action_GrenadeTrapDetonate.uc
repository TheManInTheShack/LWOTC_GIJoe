class MZ_Action_GrenadeTrapDetonate extends X2Action_Fire;

var protected AnimNotify_FireWeaponVolley   Volley;
var protected Weapon OriginalWeapon;
var private bool bReceivedDetonationMessage;

function Init()
{
	local XComGameState_Ability AbilityState;	
	local XComGameState_Item WeaponItem;

	super.Init();

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	WeaponItem = AbilityState.GetSourceWeapon();
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	bReceivedDetonationMessage = false;
}

function NotifyTargetsAbilityApplied()
{
	if( !bReceivedDetonationMessage )
	{
		DoNotifyTargetsAbilityAppliedWithMultipleHitLocations(VisualizeGameState, AbilityContext, StateChangeContext.AssociatedState.HistoryIndex, ProjectileHitLocation, 
															  allHitLocations, PrimaryTargetID, bNotifyMultiTargetsAtOnce);

		bReceivedDetonationMessage = true;
	}
}

function AddProjectile()
{
	//local TTile SourceTile;
	//local XComWorldData World;
	local vector SourceLocation, ImpactLocation;
	//local int ZValue;
	//local StateObjectReference	TargetRef;
	//local XComGameState_Unit	TargetState;

	//World = `XWORLD;

	// Calculate the upper z position for the projectile
	// Move it above the top level of the world a bit with *2
	//ZValue = World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * 2;

	ImpactLocation = AbilityContext.InputContext.TargetLocations[0];
	SourceLocation = AbilityContext.InputContext.TargetLocations[0];

	Unit.AddBlazingPinionsProjectile(SourceLocation, ImpactLocation, AbilityContext);
}

simulated state Executing
{
	simulated function BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
	}

	simulated event Tick( float fDeltaT )
	{
		//  nothing
	}

Begin:
	OriginalWeapon = UnitPawn.Weapon;
	UnitPawn.Weapon = WeaponVisualizer.GetEntity();
	Sleep(0.1f);        //  make sure weapon is attached properly
	//Volley = new class'AnimNotify_FireWeaponVolley';
	//Unit.AddProjectileVolley(Volley);

	AddProjectile();

	//while (!bReceivedDetonationMessage && !IsTimedOut())
	//	Sleep(0.0f);

	Sleep(0.3f);

	//Volley = none;
	UnitPawn.Weapon = OriginalWeapon;
	CompleteAction();
}

/*
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


	SourceLocation = AbilityContext.InputContext.TargetLocations[0];
}

function AddProjectiles(int ProjectileIndex)
{
	local TTile SourceTile;
	local XComWorldData World;
	local vector SourceLocation, ImpactLocation;
	local int ZValue;

	World = `XWORLD;

	// Move it above the top level of the world a bit with *2
	ZValue = 1; //World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * 2;

	ImpactLocation = AbilityContext.InputContext.TargetLocations[ProjectileIndex];

	// Calculate the upper z position for the projectile
	SourceTile = World.GetTileCoordinatesFromPosition(ImpactLocation);
	
	World.GetFloorPositionForTile(SourceTile, ImpactLocation);

	SourceTile.Z = ZValue;
	SourceLocation = World.GetPositionFromTileCoordinates(SourceTile);

	Unit.AddBlazingPinionsProjectile(SourceLocation, ImpactLocation, AbilityContext);

//		`SHAPEMGR.DrawSphere(SourceLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
//		`SHAPEMGR.DrawSphere(ImpactLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
}

simulated state Executing
{
Begin:
	PreviousWeapon = XComWeapon(UnitPawn.Weapon);
	UnitPawn.SetCurrentWeapon(XComWeapon(UseWeapon.m_kEntity));

	Unit.CurrentFireAction = self;

	//Sleep(`SYNC_FRAND() * 0.3f * GetDelayModifier());
	AddProjectile();

	while (!ProjectileHit)
	{
		Sleep(0.01f);
	}

	UnitPawn.SetCurrentWeapon(PreviousWeapon);

	Sleep(0.5f * GetDelayModifier()); // Sleep to allow destruction to be seen

	CompleteAction();
}
*/