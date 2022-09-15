class Isms_Effect_RogueTaunt extends X2Effect_Persistent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	return -(CurrentDamage * 0.66); 
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo, CritInfo;
	local XComGameState_Unit Targeted;

	Targeted =  XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (class'Helpers'.static.IsTileInRange(Attacker.TileLocation, Targeted.TileLocation, 114))
	{
		AccuracyInfo.ModType = eHit_Success;
		AccuracyInfo.Value = 100;
		AccuracyInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(AccuracyInfo);

		CritInfo.ModType = eHit_Crit;
		CritInfo.Value = -50;
		CritInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(CritInfo);
	}
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	if (bIsPrimaryTarget )
	{
		NewHitResult = eHit_Parry;
		return True;
	}

	return false;
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
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Attention);
		}
		
	}
}