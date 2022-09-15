// Grobobobo wrote most of this code

class X2Effect_PerfectPlan extends X2Effect_Persistent config (ABBPerkPackEdit);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config array<name> VALID_PERFECTPLAN_ABILITIES;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local name						AbilityName;
	local XComGameState_Ability		AbilityState;
	local bool						bFreeActivation;

	if (kAbility == none)
		return false;

	AbilityName = kAbility.GetMyTemplateName();

	if (default.VALID_PERFECTPLAN_ABILITIES.Find(AbilityName) != -1)
	{
		bFreeActivation = true;
	}
	if (bFreeActivation)
	{
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				SourceUnit.ActionPoints = PreCostActionPoints;
				return true;
			}
		}
	}
	return false;
}
