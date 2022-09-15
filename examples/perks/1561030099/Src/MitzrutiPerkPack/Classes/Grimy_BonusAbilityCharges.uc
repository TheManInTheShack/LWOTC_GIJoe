class Grimy_BonusAbilityCharges extends X2Effect_Persistent;

var int NumCharges;
var array<name> AbilityNames;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player) {
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local name AbilityName;
			
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	foreach AbilityNames(AbilityName){
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(UnitState.FindAbility(AbilityName).ObjectID ));
	
		if ( AbilityState != none) {
			AbilityState.iCharges += NumCharges;
		}
	}

	return false;
}
