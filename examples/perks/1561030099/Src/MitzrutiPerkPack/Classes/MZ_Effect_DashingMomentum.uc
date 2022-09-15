class MZ_Effect_DashingMomentum extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, EffectName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	//local XComGameState_Unit TargetUnit;
	local X2EventManager EventMgr;
	//local XComGameState_Ability AbilityState;

	// make sure it's a melee ability that cost more than one AP.
	if ( kAbility.IsMeleeAbility() && kAbility.GetMyTemplate().Hostility == eHostility_Offensive && SourceUnit.ActionPoints.Length == 0 && (PreCostActionPoints.Length - SourceUnit.ActionPoints.Length) > 1)
	{
		SourceUnit.ActionPoints.AddItem('Momentum');

		EventMgr = `XEVENTMGR;
		EventMgr.TriggerEvent(EffectName, kAbility, SourceUnit, NewGameState);

		return true;
	}

	return false;
}