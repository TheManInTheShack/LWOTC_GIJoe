class MZ_Effect_Provoke extends X2Effect_Persistent;

var int Provoker_HitMod, Other_HitMod; 

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Unit	SourceUnit;
	local ShotModifierInfo		AimShotModifier;

	SourceUnit = EffectState.GetSourceUnitAtTimeOfApplication();

	if ( SourceUnit.ObjectID == Target.ObjectID )
	{
		AimShotModifier.ModType = eHit_Success;
		AimShotModifier.Value = Provoker_HitMod;
		AimShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(AimShotModifier);
	}
	else
	{
		AimShotModifier.ModType = eHit_Success;
		AimShotModifier.Value = Other_HitMod;
		AimShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(AimShotModifier);
	}
}

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	//RandRoll = `SYNC_RAND(100);
	//if (RandRoll <= Chance)
	//{
	switch (CurrentResult)
	{
		case eHit_Crit:
			NewHitResult = eHit_Success;
			return true;
		case eHit_Success:
			NewHitResult = eHit_Graze;
			return true;
	}

	return false;
}


defaultproperties
{
	EffectName = "MZProvoke"
}