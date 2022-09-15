class MZ_Effect_DistanceAimBonus extends X2Effect_Persistent;

var float CritMod, GrazeMod, AimMod;
var int  CritBase, GrazeBase, AimBase;

var float AntiCritMod, DodgeMod, DefMod;
var int AntiCritBase, DodgeBase, DefBase;

var name AbilityName;
var bool bPrimaryTargetOnly; //not functional atm. not sure how to check if primary target.

//THIS IS THE WRONG ONE LOL
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	local ShotModifierInfo GrazeShotModifier;
	local int TileDistance;

	if (AbilityName != '' && (AbilityState.GetMyTemplateName() != AbilityName)) {return;}

	//if (Target == none || (bPrimaryTargetOnly && AppliedData.AbilityInputContext.PrimaryTarget.ObjectID != Target.ObjectID)) { return; }
	
	TileDistance = Attacker.TileDistanceBetween(Target);
	
	if (Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
	{
		if ( AimMod != 0){
			AimShotModifier.ModType = eHit_Success;
			AimShotModifier.Value = AimBase + Round(AimMod*TileDistance);
			AimShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(AimShotModifier);
		}
		
		if ( CritMod != 0){
			CritShotModifier.ModType = eHit_Crit;
			CritShotModifier.Value = CritBase + Round(CritMod*TileDistance);
			CritShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(CritShotModifier);
		}

		if ( GrazeMod != 0){
			GrazeShotModifier.ModType = eHit_Graze;
			GrazeShotModifier.Value = GrazeBase + Round(GrazeMod*TileDistance);
			GrazeShotModifier.Reason = FriendlyName;
			ShotModifiers.AddItem(GrazeShotModifier);
		}

	}
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;
	local ShotModifierInfo GrazeShotModifier;
	local int TileDistance;

	if (AbilityName != '' && (AbilityState.GetMyTemplateName() != AbilityName)) {return;}

	//if (Target == none || (bPrimaryTargetOnly && AppliedData.AbilityInputContext.PrimaryTarget.ObjectID != Target.ObjectID)) { return; }
	
	TileDistance = Attacker.TileDistanceBetween(Target);
	
	if ( DefMod != 0){
		AimShotModifier.ModType = eHit_Success;
		AimShotModifier.Value = -DefBase - Round(DefMod*TileDistance);
		AimShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(AimShotModifier);
	}
		
	if ( AntiCritMod != 0){
		CritShotModifier.ModType = eHit_Crit;
		CritShotModifier.Value = -AntiCritBase - Round(AntiCritMod*TileDistance);
		CritShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(CritShotModifier);
	}

	if ( DodgeMod != 0){
		GrazeShotModifier.ModType = eHit_Graze;
		GrazeShotModifier.Value = DodgeBase + Round(DodgeMod*TileDistance);
		GrazeShotModifier.Reason = FriendlyName;
		ShotModifiers.AddItem(GrazeShotModifier);
	}
}