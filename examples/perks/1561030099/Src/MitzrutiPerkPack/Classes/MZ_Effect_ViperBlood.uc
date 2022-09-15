// This is an Unreal Script
class MZ_Effect_ViperBlood extends X2Effect_Persistent;

var int AimMod, CritMod, GrazeMod, DefMod;
var array<name> ImmuneTypes;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	
    if (Attacker.IsInWorldEffectTile(class'X2Effect_ApplyPoisonToWorld'.default.Class.Name) || Attacker.IsInWorldEffectTile(class'MZ_Effect_ApplyCurseToWorld'.default.Class.Name))
    {
		if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = AimMod;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		if ( CritMod != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritMod;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
    }
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo GrazeShotModifier;
	local ShotModifierInfo AimShotModifier;
	
    if (Target.IsInWorldEffectTile(class'X2Effect_ApplyPoisonToWorld'.default.Class.Name) || Target.IsInWorldEffectTile(class'MZ_Effect_ApplyCurseToWorld'.default.Class.Name))
    {
		if ( GrazeMod != 0){
			GrazeShotModifier.ModType = eHit_Graze;
			GrazeShotModifier.Value = GrazeMod;
			GrazeShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(GrazeShotModifier);
		}

		if ( DefMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = -DefMod;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}
    }
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return (ImmuneTypes.Find(DamageType) != INDEX_NONE);
}