// This is an Unreal Script
class MZ_Effect_PsyberInterface extends X2Effect_PersistentStatChange;

var int AimMod, CritMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;

	if (Target.GetMyTemplate().bIsRobotic || Target.GetMyTemplate().bIsTurret)
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