class X2Effect_IradicationProtocol_BonusDamage extends X2Effect_Persistent;

var int iExDamage, iExCritDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local int ExtraDamage;

    //set basic damage modifier
    ExtraDamage = 0;

    //on successful hit
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        //add this much damage to a normal shot
        ExtraDamage += iExDamage;
    }

    //on successful crit
    if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        //add this much more damage if it was a crit shot
        ExtraDamage += iExCritDamage;
    }

    return ExtraDamage;
}

defaultproperties
{
    bDisplayInSpecialDamageMessageUI = true
}