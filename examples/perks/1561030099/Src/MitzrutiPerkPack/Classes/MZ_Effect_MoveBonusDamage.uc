// This is an Unreal Script
// Its basically the same as for fleche in the lwotc pack, but I didn't feel like having to add a whole pile of nesting dolls of effects for one perk >.>

class MZ_Effect_MoveBonusDamage extends X2Effect_Persistent;

var float BonusDmgPerTile;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
    local XComWorldData WorldData;
    local XComGameState_Unit TargetUnit;
    local XComGameState_Destructible TargetObject;
    local float BonusDmg;
    local vector StartLoc, TargetLoc;

    TargetUnit = XComGameState_Unit(TargetDamageable);
    TargetObject = XComGameState_Destructible(TargetDamageable);

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if ((TargetUnit != none || TargetObject != none) && AbilityNames.Find(AbilityState.GetMyTemplate().DataName) != -1)
        {
            WorldData = `XWORLD;
            StartLoc = WorldData.GetPositionFromTileCoordinates(Attacker.TurnStartLocation);
            if (TargetUnit != none)
            {
                TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
            }
            else if (TargetObject != none)
            {
                TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetObject.TileLocation);
            }
            BonusDmg = BonusDmgPerTile * VSize(StartLoc - TargetLoc)/ WorldData.WORLD_StepSize;
            return int(BonusDmg);
        }
    }
    return 0; 
}