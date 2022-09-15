class X2Effect_RefundAmmoCost extends X2Effect_Persistent;

var bool bAppliesToSecondaries;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', RefundAmmoCostListener, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn RefundAmmoCostListener(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Effect RefundAmmoCostEffectState;
	local X2Effect_RefundAmmoCost RefundAmmoCostEffect;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item SourceWeapon;

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		RefundAmmoCostEffectState = XComGameState_Effect(CallbackData);
		if (RefundAmmoCostEffectState != none)
		{
			RefundAmmoCostEffect = X2Effect_RefundAmmoCost(RefundAmmoCostEffectState.GetX2Effect());
			if (RefundAmmoCostEffect != none)
			{
				AbilityState = XComGameState_Ability(EventData);
				SourceWeapon = AbilityState.GetSourceWeapon();
				if (SourceWeapon != none && (SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon || (RefundAmmoCostEffect.bAppliesToSecondaries && SourceWeapon.InventorySlot == eInvSlot_SecondaryWeapon)))
				{
					if(SourceWeapon.Ammo < SourceWeapon.GetClipSize())
					{
						SourceWeapon.Ammo += AbilityState.iAmmoConsumed;
					}
				}
			}
		}
    }

	return ELR_NoInterrupt;
}
