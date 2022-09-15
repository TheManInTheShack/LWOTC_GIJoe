// based on lw2 Depth Perception
class MZ_Effect_HeightAimBonus extends X2Effect_Persistent;

var int AIM_BONUS;
var int ANTIDODGE_BONUS;
var int Crit_Bonus;

defaultproperties
{
    DuplicateResponse=eDupe_Allow
    EffectName="DepthPerception"
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo1, ShotInfo2, ShotInfo3;
	local int DodgeReduction;

		if (Attacker.HasHeightAdvantageOver(Target, true) || Attacker.IsUnitAffectedByEffectName('IRI_JetShot_Effect'))
		{
		    ShotInfo1.ModType = eHit_Success;
            ShotInfo1.Reason = FriendlyName;
			ShotInfo1.Value = default.AIM_BONUS;
            ShotModifiers.AddItem(ShotInfo1);

			DodgeReduction = Min (default.ANTIDODGE_BONUS, Target.GetCurrentStat(eStat_Dodge));

			ShotInfo2.ModType = eHit_Graze;
			ShotInfo2.Reason = FriendlyName;
			ShotInfo2.Value = -1 * DodgeReduction;
			ShotModifiers.AddItem(ShotInfo2);

			ShotInfo3.ModType = eHit_Crit;
            ShotInfo3.Reason = FriendlyName;
			ShotInfo3.Value = default.Crit_Bonus;
            ShotModifiers.AddItem(ShotInfo3);
		}   
}