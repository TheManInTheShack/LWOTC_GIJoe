class X2Effect_OptimizationProtocol extends X2Effect_Persistent;

var int AimMod, CritMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ModInfo;
    
    // add to shot chance
    ModInfo.ModType = eHit_Success;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = AimMod;
    ShotModifiers.AddItem(ModInfo);
    
    // add to crit chance
    ModInfo.ModType = eHit_Crit;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = CritMod;
    ShotModifiers.AddItem(ModInfo);
}

DefaultProperties
{
    DuplicateResponse = eDupe_Ignore
}