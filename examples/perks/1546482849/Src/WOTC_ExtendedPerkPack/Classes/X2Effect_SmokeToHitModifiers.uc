// Provides an aim and/or critical chance bonus to shots fired from within smoke

class X2Effect_SmokeToHitModifiers extends X2Effect_Persistent;

var int AimMod;
var int CritMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;

    if (Attacker.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
    {
        AimShotModifier.ModType = eHit_Success;
        AimShotModifier.Value = AimMod;
        AimShotModifier.Reason = FriendlyName;
        ShotModifiers.AddItem(AimShotModifier);

        CritShotModifier.ModType = eHit_Crit;
        CritShotModifier.Value = CritMod;
        CritShotModifier.Reason = FriendlyName;
        ShotModifiers.AddItem(CritShotModifier);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return TargetUnit.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name);
}

static function SmokeGrenadeVisualizationTickedOrRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local X2Action_UpdateUI UpdateUIAction;

    UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
    UpdateUIAction.SpecificID = ActionMetadata.StateObject_NewState.ObjectID;
    UpdateUIAction.UpdateType = EUIUT_UnitFlag_Buffs;
}

DefaultProperties
{
    EffectName = "F_SmokeToHitModifiers"
    DuplicateResponse = eDupe_Refresh
    EffectTickedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;
    EffectRemovedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;
}