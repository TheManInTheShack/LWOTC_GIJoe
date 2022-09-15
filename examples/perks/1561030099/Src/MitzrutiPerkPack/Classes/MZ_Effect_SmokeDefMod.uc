class MZ_Effect_SmokeDefMod extends X2Effect_Persistent;

var int CritMod;
var int GrazeMod;
var int AimMod;
var array<name> ImmuneTypes;
var bool FogWall;
var float FogMod;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	local ShotModifierInfo GrazeShotModifier;
	local ShotModifierInfo FogShotModifier;
	
    if (Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
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

		if ( GrazeMod != 0){
			GrazeShotModifier.ModType = eHit_Graze;
			GrazeShotModifier.Value = GrazeMod;
			GrazeShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(GrazeShotModifier);
		}

		if ( FogWall )
		{
			if (bFlanking && !bMelee)
			{
				FogShotModifier.ModType = eHit_Success;
				FogShotModifier.Value = -( class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS * FogMod);
				FogShotModifier.Reason = FriendlyName;
				ShotModifiers.AddItem(FogShotModifier);
			}
		}
    }
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{ 
	local XComGameState_Unit	Target;
	local XComGameStateHistory	History;

	if (ImmuneTypes.Length != 0)
	{
		History = `XCOMHISTORY;
		Target = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		if (Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
		{
			return (ImmuneTypes.Find(DamageType) != INDEX_NONE);
		}

	}
	return false;
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

defaultproperties
{
	CritMod=0
	GrazeMod=0
	AimMod=0
	FogWall=false
	DuplicateResponse = eDupe_Refresh
    EffectTickedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;
    EffectRemovedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;
}