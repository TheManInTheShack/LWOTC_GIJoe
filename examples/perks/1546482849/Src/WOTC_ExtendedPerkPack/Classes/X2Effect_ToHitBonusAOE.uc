class X2Effect_ToHitBonusAOE extends X2Effect_PersistentAOE;

var int ToHitBonus;
var int ToHitBonusWithShieldWall;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;
	local XComGameState_Unit SourceUnit;

	if (Target != none && IsEffectCurrentlyRelevant(EffectState, Attacker))
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		if (SourceUnit.IsUnitAffectedByEffectName('ShieldWall'))
		{
			ShotMod.Value = ToHitBonusWithShieldWall;
		}
		else
		{
			ShotMod.Value = ToHitBonus;
		}

		ShotMod.ModType = eHit_Success;
		ShotMod.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotMod);
	}
}

DefaultProperties
{
	EffectName="ToHitBonusAOE"
}

