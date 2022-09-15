// based on lw2 hyperreactive pupils

class MZ_Effect_AimBoostOnMiss extends X2Effect_Persistent;

var int AIM_BONUS;
var int ANTIDODGE_BONUS;
var int Crit_Bonus;

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Gene_HyperReactivePupils"
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', HyperReactivePupilsListener, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn HyperReactivePupilsListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;
	local XComGameState_Item SourceWeapon;

    //`LOG("HyperReactivePupils: Triggered");

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	`assert(AbilityContext != none);
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	`assert(AbilityState != none);
	UnitState = XComGameState_Unit(EventSource);
	`assert(UnitState != none);
	
    //`LOG("HyperReactivePupils: Past asserts");

	if (AbilityState.IsAbilityInputTriggered())
	{
        //`LOG("HyperReactivePupils: Triggered ability");
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && SourceWeapon != none ) //&& SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
		{
            //`LOG("HyperReactivePupils: Valid ability");
            
            if (AbilityContext.IsResultContextMiss())
            {
                //`LOG("HyperReactivePupils: Miss");
			    UnitState.SetUnitFloatValue('MZHyperReactivePupilsMiss', 1, eCleanup_BeginTactical);
            }
            else
            {
                //`LOG("HyperReactivePupils: Hit");
			    UnitState.SetUnitFloatValue('MZHyperReactivePupilsMiss', 0, eCleanup_BeginTactical);
            }
		}
	}
	return ELR_NoInterrupt;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item						SourceWeapon;
    local ShotModifierInfo ShotInfo1, ShotInfo2, ShotInfo3;
	local int DodgeReduction;
	local UnitValue                                 MissValue;

	//if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
	//	return;
	if (AbilityState == none)
		return;

    SourceWeapon = AbilityState.GetSourceWeapon();    
	//if (SourceWeapon == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
	//{
		if ((SourceWeapon != none) && (Target != none))
		{
		    Attacker.GetUnitValue('MZHyperReactivePupilsMiss', MissValue);
            
			if (MissValue.fValue > 0)
			{
				ShotInfo1.ModType = eHit_Success;
				ShotInfo1.Reason = FriendlyName;
				ShotInfo1.Value = default.AIM_BONUS;
				ShotModifiers.AddItem(ShotInfo1);

				DodgeReduction = Min (default.ANTIDODGE_BONUS, Target.GetCurrentStat(eStat_Dodge));

				ShotInfo2.ModType = eHit_Graze;
				ShotInfo2.Reason = FriendlyName;
				ShotInfo2.Value = -1 * DodgeReduction;
				ShotModifiers.AddItem(ShotInfo2);

				ShotInfo3.ModType = eHit_Crit;
				ShotInfo3.Reason = FriendlyName;
				ShotInfo3.Value = default.Crit_Bonus;
				ShotModifiers.AddItem(ShotInfo3);
			}
        }
    //}    
}