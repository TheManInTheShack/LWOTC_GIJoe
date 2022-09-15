class X2Effect_IncrementUntouchable extends X2Effect;

var int UntouchableCharges;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit, NewTargetState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
	    NewTargetState = XComGameState_Unit(NewGameState.CreateStateObject(TargetUnit.Class, TargetUnit.ObjectID));

        `LOG("Before Immunize: " $ string(TargetUnit.Untouchable));
		NewTargetState.Untouchable++;
        `LOG("After Immunize: " $ string(TargetUnit.Untouchable));
	}
}