class X2AbilityCooldown_OnHitOnly extends X2AbilityCooldown;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    local XComGameStateContext_Ability AbilityContext;

    AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
    
    if (AbilityContext.IsResultContextHit())
    {
        return iNumTurns;
    }
    return 0;
}