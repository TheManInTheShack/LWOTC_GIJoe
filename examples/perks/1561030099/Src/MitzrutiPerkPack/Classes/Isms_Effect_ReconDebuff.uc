class Isms_Effect_ReconDebuff extends X2Effect_Persistent
	config(IsmsRogue);

var config int ACCURACY_CHANCE_BONUS;
var config int CRIT_CHANCE_BONUS;
var config int CRIT_DAMAGE_BONUS;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
 
	if (CurrentDamage > 3)  
	{
			DamageMod = max(int(float(CurrentDamage) * (0.20f)),1);
		return DamageMod;	
	}
	return 0;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo, CritInfo;

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = 5;
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);

	CritInfo.ModType = eHit_Crit;
	CritInfo.Value = 0;
	CritInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(CritInfo);
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	if( XComGameState_Unit(ActionMetadata.StateObject_NewState) != none )
	{
		// Must be a unit in order to have this occur
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Bad);
	}
}