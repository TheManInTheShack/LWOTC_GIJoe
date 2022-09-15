class X2Effect_Supercharge extends XMBEffect_AddAbilityCharges;

function bool IsValidAbility(XComGameState_Ability AbilityState)
{
    if(AbilityState.GetSourceWeapon().GetMyTemplate().IsA('X2GremlinTemplate'))
    {
        if(AbilityState.GetMyTemplate().AbilityCharges != none)
        {
            return true;
        }
    }
	
    return false;
}