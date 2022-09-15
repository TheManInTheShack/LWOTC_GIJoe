class MZ_Effect_RaptorWhirlwindAP extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState) {
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'RefundActionPoint', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints) {
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;

	if ( kAbility.GetMyTemplateName() == 'ShieldWall' ) {
		SourceUnit.ActionPoints.AddItem('MZRaptorWhirlwindActionPoint');

		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		EventMgr = `XEVENTMGR;
		EventMgr.TriggerEvent('RefundActionPoint', AbilityState, SourceUnit, NewGameState);

		return true;
	}

	return false;
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit Target;

	if ( AbilityState.GetMyTemplateName() == 'MZRaptorWhirlwind' || AbilityState.GetMyTemplateName() == 'MZRaptorCyclone' || AbilityState.GetMyTemplateName() == 'MZRaptorHurricaneAttack' )
	{
		Target = XComGameState_Unit(TargetDamageable);

		if (Target.HasSoldierAbility('VulnerabilityMelee', true) )
		{
			return class'X2Ability_Vulnerabilities'.default.MELEE_DAMAGE_MODIFIER;
		}
	}

	return 0;
}



defaultproperties
{
	EffectName = "MZRaptorWhirlwindAP"
	DuplicateResponse = eDupe_Ignore
}