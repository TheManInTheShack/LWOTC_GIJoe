// This is an Unreal Script
class MZ_Effect_NictitatingMembranes extends X2Effect_Persistent;

var float BonusMod;

defaultproperties
{
	BonusMod = -1.0f
	EffectTickedFn = NictitatingTicked
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
	local int				AimMod;
	
	AimMod = 0;
    if (Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
    {
		AimMod = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD;
    }

	If (Attacker.AffectedByEffectNames.Find('Poisoned') != INDEX_NONE ){ AimMod += class'X2StatusEffects'.default.POISONED_AIM_ADJUST; }
	If (Attacker.AffectedByEffectNames.Find('Disoriented') != INDEX_NONE ){ AimMod += class'X2StatusEffects'.default.DISORIENTED_AIM_ADJUST; }

	if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = AimMod * BonusMod;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
	}
}

function bool NictitatingTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent CheckEffect;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		CheckEffect = EffectState.GetX2Effect();
		if (CheckEffect.EffectName == class'X2AbilityTemplateManager'.default.BlindedName)
		{
			EffectState.RemoveEffect(NewGameState, NewGameState, true);
		}
	}

	return false;
}