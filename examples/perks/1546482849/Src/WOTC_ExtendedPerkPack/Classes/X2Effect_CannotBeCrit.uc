class X2Effect_CannotBeCrit extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

	ShotInfo.ModType = eHit_Crit;
	ShotInfo.Reason = FriendlyName;
	ShotInfo.Value = -100;
	ShotModifiers.AddItem(ShotInfo);
}

defaultproperties
{
    DuplicateResponse=eDupe_Refresh
}