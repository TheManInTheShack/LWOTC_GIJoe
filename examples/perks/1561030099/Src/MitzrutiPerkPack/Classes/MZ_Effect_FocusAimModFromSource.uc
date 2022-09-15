class MZ_Effect_FocusAimModFromSource extends X2Effect_Persistent;

var float AimMod, CritMod;
var float DefenseMod, DodgeMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Unit SourceUnit;
	local MZ_EffectState_Focus ManaEffectState;
	local ShotModifierInfo AimShotModifier, CritShotModifier;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	ManaEffectState = MZ_EffectState_Focus(SourceUnit.GetUnitAffectedByEffectState('FocusLevel'));

	if ( ManaEffectState != none && ManaEffectState.FocusLevel > 0)
	{
		if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = AimMod * ManaEffectState.FocusLevel;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		if ( CritMod != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritMod * ManaEffectState.FocusLevel;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
	}
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Unit SourceUnit;
	local MZ_EffectState_Focus ManaEffectState;
	local ShotModifierInfo AimShotModifier, DodgeShotModifier;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	ManaEffectState = MZ_EffectState_Focus(SourceUnit.GetUnitAffectedByEffectState('FocusLevel'));

	if ( ManaEffectState != none && ManaEffectState.FocusLevel > 0)
	{
		if ( DefenseMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = -DefenseMod * ManaEffectState.FocusLevel;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		if ( DodgeMod != 0){
			DodgeShotModifier.ModType = eHit_Graze;
			DodgeShotModifier.Value = DodgeMod * ManaEffectState.FocusLevel;
			DodgeShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(DodgeShotModifier);
		}
	}
}
