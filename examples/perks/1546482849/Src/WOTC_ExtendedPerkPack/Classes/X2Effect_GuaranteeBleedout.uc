class X2Effect_GuaranteeBleedout extends X2Effect_Persistent;

var protectedwrite name GuaranteeBleedoutUsed;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
    local UnitValue GuaranteeBleedoutValue;

    //`LOG("EmergencyLifeSupport: Starting PreDeath Check.");

    if (UnitState.GetUnitValue(default.GuaranteeBleedoutUsed, GuaranteeBleedoutValue))
    {
        if (GuaranteeBleedoutValue.fValue > 0)
        {
            //`LOG("EmergencyLifeSupport: Already used, failing.");
            return false;
        }
    }
    //`LOG("EmergencyLifeSupport: Triggered, setting unit value.");
    UnitState.SetUnitFloatValue(default.GuaranteeBleedoutUsed, 1, eCleanup_BeginTactical);
    if (ApplyBleedingOut(UnitState, NewGameState ))
    {
        //`LOG("EmergencyLifeSupport: Successfully applied bleeding-out.");
        UnitState.LowestHP = 1; // makes wound times correct if ELS gets used
        return true;
    }
    //`LOG("EmergencyLifeSupport : Unit" @ UnitState.GetFullName() @ "should have bled out but ApplyBleedingOut failed. Killing it instead.");

    return false;
}

function bool ApplyBleedingOut(XComGameState_Unit UnitState, XComGameState NewGameState)
{
    local EffectAppliedData ApplyData;
    local X2Effect BleedOutEffect;

    if (NewGameState != none)
    {
        BleedOutEffect = GetBleedOutEffect();
        ApplyData.PlayerStateObjectRef = UnitState.ControllingPlayer;
        ApplyData.SourceStateObjectRef = UnitState.GetReference();
        ApplyData.TargetStateObjectRef = UnitState.GetReference();
        ApplyData.EffectRef.LookupType = TELT_BleedOutEffect;
        if (BleedOutEffect.ApplyEffect(ApplyData, UnitState, NewGameState) == 'AA_Success')
        {
            //`LOG("Emergency Life Support : Triggered ApplyBleedingOut.");
            return true;
        }
    }
    return false;
}

DefaultProperties
{
    EffectName = "GuaranteeBleedout"
    GuaranteeBleedoutUsed = "GuaranteeBleedoutUsed"
}
