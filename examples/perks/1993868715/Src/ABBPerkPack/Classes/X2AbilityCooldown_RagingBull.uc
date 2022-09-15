class X2AbilityCooldown_RagingBull extends X2AbilityCooldown config (ABBPerkPackEdit);

var config int iRAGINGBULL_BASE_NUMBERTURNS;
 
simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    //pull the default number from the config
    iNumTurns = default.iRAGINGBULL_BASE_NUMBERTURNS;
 
    //if (XComGameState_Unit(AffectState).HasAbilityFromAnySource('Bullfighter'))
    //{
    //    iNumTurns = 0;
    //}
 
    //return the calculated number
    return iNumTurns;
}