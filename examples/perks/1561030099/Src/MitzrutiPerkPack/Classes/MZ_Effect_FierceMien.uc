class MZ_Effect_FierceMien extends X2Effect_Persistent;

var int EffectRangeSquared;  //SOLACE_DISTANCE_SQ=16
var int AimMod, CritMod, DefMod;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	
	if (SourceUnit == none || SourceUnit.IsDead() || SourceUnit.IsConcealed() || TargetUnit == none || TargetUnit.IsDead() || TargetUnit.HasSoldierAbility('MZFierceMien', true))
		return false;

	if (SourceUnit.ObjectID != TargetUnit.ObjectID && SourceUnit.IsEnemyUnit(TargetUnit))
	{
		//  jbouscher: uses tile range rather than unit range so the visual check can match this logic
		if (!class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, EffectRangeSquared))
			return false;
	}

	return true;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier, CritShotModifier;
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if ( Target.ObjectID != SourceUnit.ObjectID && IsEffectCurrentlyRelevant(EffectState, Attacker) )
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
	local ShotModifierInfo AimShotModifier; //, CritShotModifier;
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if ( Attacker.ObjectID != SourceUnit.ObjectID && IsEffectCurrentlyRelevant(EffectState, Target) && SourceUnit.HasSoldierAbility('MZFierceMienDefDown', true))
	{
		if ( DefMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = DefMod;
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}

		/*
		if ( CritMod != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritMod;
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}
		*/
	}
}