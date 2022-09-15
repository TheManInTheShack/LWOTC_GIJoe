class X2Effect_RefundConcealmentBreakingAction extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Relocation', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityStateQuickFeet;
	local int EventChainStartHistoryIndex;
    local bool bRefundAction;

    bRefundAction = false;

	History = `XCOMHISTORY;
	EventChainStartHistoryIndex = History.GetEventChainStartIndex();

	if(SourceUnit.WasConcealed(EventChainStartHistoryIndex))
	{
        if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
        {
            // Handles movement case
		    if(!SourceUnit.IsConcealed())
		    {
			    bRefundAction = true;
		    }
            else if(!kAbility.RetainConcealmentOnActivation(AbilityContext)) // Handles activated ability case
            {
                bRefundAction = true;
            }
        }
	}

    if(bRefundAction)
    {
        AbilityStateQuickFeet = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

		EventMgr = `XEVENTMGR;
		EventMgr.TriggerEvent('Relocation', AbilityStateQuickFeet, SourceUnit, NewGameState);

		`LOG("X2Effect_RefundConcealmentBreakingAction Success");
		return true;
    }

	`LOG("X2Effect_RefundConcealmentBreakingAction Failed: Was: "  @ SourceUnit.WasConcealed(EventChainStartHistoryIndex) @ " Is: " @ SourceUnit.IsConcealed());

	return false;
}