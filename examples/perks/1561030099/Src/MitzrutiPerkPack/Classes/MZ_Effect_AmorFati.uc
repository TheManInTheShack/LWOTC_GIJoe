// This is an Unreal Script

class MZ_Effect_AmorFati extends X2Effect_Persistent;

var float BonusMult;
var float PsiMult;
var int	BonusFlat;
var int AimMod;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	return EffectState.GetSourceUnitAtTimeOfApplication().GetCurrentStat(eStat_PsiOffense) * PsiMult + CurrentDamage * BonusMult;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;

	if ( AimMod != 0){
		AimShotModifier.ModType = eHit_Success;
		AimShotModifier.Value = AimMod;
		AimShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(AimShotModifier);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if( XComGameState_Unit(ActionMetadata.StateObject_NewState) != none )
	{

		// Must be a unit in order to have this occur
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

		if (EffectApplyResult == 'AA_Success')
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Good);
		}
		
	}
}

DefaultProperties
{
	BonusMult = 0.0
	BonusFlat = 0
	DuplicateResponse = eDupe_Refresh
}