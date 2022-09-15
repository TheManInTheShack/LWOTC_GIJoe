class MZ_Condition_RequireAbility extends X2Condition_AbilityProperty;
//this condition is used to prevent an ability from being initialized if the unit doesn't also have some other ability.
//for example, GrenadeTrap.

var name RequireAbilityName;

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	return SourceUnit.HasSoldierAbility(RequireAbilityName, true);
}