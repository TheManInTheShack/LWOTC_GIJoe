class MZ_Effect_FocusRestore extends X2Effect;

var int ManaRestore;
var int ModifyFocus;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit	TargetUnit;
	local XComGameState_Effect_TemplarFocus FocusState;
	local MZ_EffectState_Focus	ManaEffectState;
	local UnitValue				CurrentFocusValue, MaxFocusValue;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if ( TargetUnit == none) { return; }

	ManaEffectState = MZ_EffectState_Focus(TargetUnit.GetUnitAffectedByEffectState('FocusLevel'));
	if ( ManaEffectState != none ) 
	{
		ManaEffectState = MZ_EffectState_Focus(NewGameState.ModifyStateObject(ManaEffectState.Class, ManaEffectState.ObjectID));
		ManaEffectState.SetFocusLevel(ManaEffectState.FocusLevel + ManaRestore, TargetUnit, NewGameState);
	}
	else
	{
		FocusState = TargetUnit.GetTemplarFocusEffectState();
		if (FocusState != none)
		{
			FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
			FocusState.SetFocusLevel(FocusState.FocusLevel + ModifyFocus, TargetUnit, NewGameState);		
		}
		else if ( TargetUnit.GetUnitValue('WOTC_APA_Templar_CurrentFocusLevel', CurrentFocusValue) )
		{
			TargetUnit.GetUnitValue('WOTC_APA_Templar_MaxFocusLevel', MaxFocusValue);

			If ( CurrentFocusValue.fValue + ModifyFocus > MaxFocusValue.fValue)
			{
				TargetUnit.SetUnitFloatValue('WOTC_APA_Templar_CurrentFocusLevel', MaxFocusValue.fValue, eCleanup_BeginTactical);
			}
			else if ( CurrentFocusValue.fValue + ModifyFocus < 0 )
			{
				TargetUnit.SetUnitFloatValue('WOTC_APA_Templar_CurrentFocusLevel', 0, eCleanup_BeginTactical);
			}
			else
			{
				TargetUnit.SetUnitFloatValue('WOTC_APA_Templar_CurrentFocusLevel', CurrentFocusValue.fValue + ModifyFocus, eCleanup_BeginTactical);
			}
		}
	}
}

defaultproperties
{
	ModifyFocus = 1;
	ManaRestore = 3
}