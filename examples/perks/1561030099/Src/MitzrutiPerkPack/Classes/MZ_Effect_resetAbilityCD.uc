class MZ_Effect_resetAbilityCD extends X2Effect;

var array<name> AbilityNames;
var int Maxreduction;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local int i;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(kNewTargetState);
	for (i = 0; i < UnitState.Abilities.Length; ++i)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(UnitState.Abilities[i].ObjectID));
		if (AbilityState != none && AbilityState.iCooldown > 0)
		{
			if ( AbilityNames.Find( AbilityState.GetMyTemplateName() ) != INDEX_NONE )
			{
				AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
				If ( Maxreduction > 0 && Maxreduction > AbilityState.iCooldown )
				{
					AbilityState.iCooldown -= Maxreduction;
				}
				else
				{
					AbilityState.iCooldown = 0;
				}
			}
		}
	}
}

defaultproperties
{
	Maxreduction = 0
}