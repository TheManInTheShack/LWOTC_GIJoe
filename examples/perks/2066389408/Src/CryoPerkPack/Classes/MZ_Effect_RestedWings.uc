class MZ_Effect_RestedWings extends X2Effect_Persistent;

var int NumJetCharges, MaxJetCharges, MaxFlightCharges;
var array<name> AbilityNames;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit		TargetUnit;
	local XComGameState_Ability		AbilityState;

	if ( AbilityNames.Find(kAbility.GetMyTemplateName()) != INDEX_NONE )
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.FindAbility('IRI_JetShot').ObjectID));
		if ( AbilityState != none && (AbilityState.iCharges < MaxJetCharges || MaxJetCharges < 1 ) )
		{
			if ( MaxJetCharges > 0 && (AbilityState.iCharges + NumJetCharges) >= MaxJetCharges )
			{
				AbilityState.iCharges = MaxJetCharges;
			}
			else
			{
				AbilityState.iCharges += NumJetCharges;
			}
			return true;
		}
	}

	if (SourceUnit.IsUnitAffectedByEffectName('IRI_JetShot_Effect'))
	{	
		//  check for a direct kill shot
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (TargetUnit != none && TargetUnit.IsDead())
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.FindAbility('IRI_JetShot').ObjectID));
			if ( AbilityState != none && AbilityState.iCharges < MaxFlightCharges )
			{
				AbilityState.iCharges += 1;
				return true;
			}
		}
	}

	return false;
}