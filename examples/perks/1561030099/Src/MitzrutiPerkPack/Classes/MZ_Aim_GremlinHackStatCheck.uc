class MZ_Aim_GremlinHackStatCheck extends X2AbilityToHitCalc_StatCheck;

var() ECharStatType AttackerStat, DefenderStat;

function int GetAttackValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	ItemState = kAbility.GetSourceWeapon();
	if (ItemState != none && AttackerStat == eStat_Hacking)
	{
		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
		if (GremlinTemplate != none)
		{
			return GremlinTemplate.HackingAttemptBonus + UnitState.GetCurrentStat(eStat_Hacking);
		}
	}

	return UnitState.GetCurrentStat(AttackerStat);
}

function int GetDefendValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
	return UnitState.GetCurrentStat(DefenderStat);
}

function string GetAttackString() { return class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[AttackerStat]; }
function string GetDefendString() { return class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[DefenderStat]; }

DefaultProperties
{
	AttackerStat = eStat_Hacking
	DefenderStat = eStat_HackDefense
}