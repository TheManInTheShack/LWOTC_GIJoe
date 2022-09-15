class MZ_Effect_TurnStartActionPoint extends X2Effect_Persistent;
//strips the immediate application bit from the vanilla one

var name ActionPointType;
var int NumActionPoints;
var bool bActionPointsRemoved; // if true, this number of action points will be removed instead of added.

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local int i, APIndex;

	for (i = 0; i < NumActionPoints; ++i)
	{
		if (bActionPointsRemoved)
		{
			// Can't do a RemoveItem, otherwise all action points of type ActionPointType will be removed at once.
			APIndex = ActionPoints.Find(ActionPointType);
			if (APIndex != INDEX_NONE)
			{
				ActionPoints.Remove(APIndex, 1);
			}
		}
		else
		{
			ActionPoints.AddItem(ActionPointType);
		}
	}
}