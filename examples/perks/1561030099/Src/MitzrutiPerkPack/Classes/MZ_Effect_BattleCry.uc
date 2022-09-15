class MZ_Effect_BattleCry extends X2Effect_Persistent;

var int CritMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo CritShotModifier;

	if ( CritMod != 0){
		CritShotModifier.ModType = eHit_Crit;
		CritShotModifier.Value = CritMod;
		CritShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(CritShotModifier);
	}
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo CritShotModifier;

	if ( CritMod != 0){
		CritShotModifier.ModType = eHit_Crit;
		CritShotModifier.Value = CritMod;
		CritShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(CritShotModifier);
	}
}

function bool ShotsCannotGraze() { return true; }
function bool AllowDodge(XComGameState_Unit Attacker, XComGameState_Ability AbilityState) { return false; }
function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) { return true; }