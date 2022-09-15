class Grimy_Cost_ActionPoints extends X2AbilityCost_ActionPoints;

var name BonusPoint;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit ModifiedUnitState;
	local int i, j, iPointsConsumed, iPointsToTake, PathIndex, FarthestTile;

	ModifiedUnitState = XComGameState_Unit(AffectState);

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
		for (i = AllowedTypes.Length - 1; i >= 0 && iPointsConsumed < iPointsToTake; --i)
		{
			for (j = ModifiedUnitState.ActionPoints.Length - 1; j >= 0 && iPointsConsumed < iPointsToTake; --j)
			{
				if (ModifiedUnitState.ActionPoints[j] == AllowedTypes[i])
				{
					ModifiedUnitState.ActionPoints.Remove(j, 1);
					iPointsConsumed++;
				}
			}
		}
	}

	ModifiedUnitState.ActionPoints.AddItem(BonusPoint);
}

DefaultProperties
{
	AllowedTypes(0)="standard"
	AllowedTypes(1)="runandgun"
}