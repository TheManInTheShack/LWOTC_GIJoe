// This is an Unreal Script

class MZ_Effect_ManuForti extends X2Effect_Persistent;

var float BaseMult, PsiMult;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	return EffectState.GetSourceUnitAtTimeOfApplication().GetCurrentStat(eStat_PsiOffense) * PsiMult + CurrentDamage * BaseMult;
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
	DuplicateResponse = eDupe_Refresh
}