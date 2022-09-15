class Grimy_AbilityCost_Reload extends X2AbilityCost_ActionPoints;

var name BonusType;
var name BonusPassive;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local XComGameState_Unit kUnit;
	local name Availability;
	local int i, PointCheck, PointSum;
	
	kUnit = ActivatingUnit;
	`assert(kUnit != none);

	Availability = 'AA_CannotAfford_ActionPoints';
		
	PointCheck = GetPointCost(kAbility, kUnit);
	PointSum = 0;
	for (i = 0; i < AllowedTypes.Length; ++i)
	{
		PointSum += kUnit.NumActionPoints(AllowedTypes[i]);
	}
	if ( kUnit.FindAbility(BonusPassive).ObjectID > 0 ) {
		PointSum += kUnit.NumActionPoints(BonusType);
	}

	if( PointSum >= PointCheck )
	{
		Availability = 'AA_Success';
	}

	return Availability;
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit ModifiedUnitState;
	local int i, j, iPointsConsumed, iPointsToTake, PathIndex, FarthestTile;
	local array<name> TempTypes;

	ModifiedUnitState = XComGameState_Unit(AffectState);

	TempTypes = AllowedTypes;
	if ( ModifiedUnitState.FindAbility(BonusPassive).ObjectID > 0 ) {
		TempTypes.AddItem(BonusType);
	}

	if (bFreeCost || ModifiedUnitState.GetMyTemplate().bIsCosmetic || (`CHEATMGR != none && `CHEATMGR.bUnlimitedActions))
		return;

	//Deduct the appropriate number of action points
	if( ConsumeAllPoints(kAbility, ModifiedUnitState) )
	{
		iPointsConsumed = ModifiedUnitState.NumAllActionPoints();
		ModifiedUnitState.ActionPoints.Length = 0;		
	}
	else
	{
		AbilityContext.PostBuildVisualizationFn.AddItem(kAbility.DidNotConsumeAll_PostBuildVisualization);

		if (bMoveCost)
		{
			PathIndex = AbilityContext.GetMovePathIndex(ModifiedUnitState.ObjectID);
			iPointsToTake = 1;
			
			for(i = AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1; i >= 0; --i)
			{
				if(AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles[i] == ModifiedUnitState.TileLocation)
				{
					FarthestTile = i;
					break;
				}
			}
			for (i = 0; i < AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases.Length; ++i)
			{
				if (AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases[i] <= FarthestTile)
					iPointsToTake++;
			}
		}
		else
		{
			iPointsToTake = GetPointCost(kAbility, ModifiedUnitState);
		}
		//  Assume that AllowedTypes is built with the most specific point types at the end, which we should
		//  consume before more general types. e.g. Consume "reflex" if that is allowed before "standard" if that is also allowed.
		//  If this isn't good enough we may want to provide a specific way of ordering the priority for action point consumption.
		for (i = TempTypes.Length - 1; i >= 0 && iPointsConsumed < iPointsToTake; --i)
		{
			for (j = ModifiedUnitState.ActionPoints.Length - 1; j >= 0 && iPointsConsumed < iPointsToTake; --j)
			{
				if (ModifiedUnitState.ActionPoints[j] == TempTypes[i])
				{
					ModifiedUnitState.ActionPoints.Remove(j, 1);
					iPointsConsumed++;
				}
			}
		}
	}
}

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int i;
	local bool bConsumeAll;

	bConsumeAll = bConsumeAllPoints;
	if ( AbilityOwner.FindAbility(BonusPassive).ObjectID > 0 ) {
		bConsumeAll = false;
	}

	if ( bConsumeAll )
	{
		for (i = 0; i < DoNotConsumeAllEffects.Length; ++i)
		{
			if (AbilityOwner.IsUnitAffectedByEffectName(DoNotConsumeAllEffects[i]))
				return false;
		}
		for (i = 0; i < DoNotConsumeAllSoldierAbilities.Length; ++i)
		{
			if (AbilityOwner.HasSoldierAbility(DoNotConsumeAllSoldierAbilities[i]))
				return false;
		}
	}

	return bConsumeAll;
}

DefaultProperties
{
	iNumPoints=1
	AllowedTypes(0)="standard"
	AllowedTypes(1)="runandgun"
	AllowedTypes(2)="skirmisherinterrupt"
	//bAddWeaponTypicalCosts = false
	bConsumeAllPoints = false
	// Added generic ConsumeAllPoints inhibitor.
	DoNotConsumeAllEffects(0) = "DoNotConsumeAllPoints"
	DoNotConsumeAllEffects(1) = "Berserk"
}