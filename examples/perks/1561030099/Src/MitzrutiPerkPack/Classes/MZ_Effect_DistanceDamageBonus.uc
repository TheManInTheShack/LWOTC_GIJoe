// This is an Unreal Script
class MZ_Effect_DistanceDamageBonus extends X2Effect_Persistent;

var name AbilityName;
var float BaseMod, BonusMod;
var EStatModOp BonusModType;
var bool bPrimaryTargetOnly;
var bool bDOTOnly;
var bool bMainOnly;

defaultproperties
{
	BonusModType = MODOP_Addition
	bPrimaryTargetOnly = false;
	bDOTOnly = false
	bMainOnly = false
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local XComGameState_Unit TargetUnitState;
	local int TileDistance;

	if (AbilityName != '' && (AbilityState.GetMyTemplateName() != AbilityName)) {return 0;}
	if ( bDOTOnly && AppliedData.EffectRef.ApplyOnTickIndex < 0 ) { return 0; }
	if ( bMainOnly && AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	TargetUnitState = XComGameState_Unit(TargetDamageable);
	
	if (TargetUnitState != none)
	{
		if (bPrimaryTargetOnly && AppliedData.AbilityInputContext.PrimaryTarget.ObjectID != TargetUnitState.ObjectID)
			return 0;

		TileDistance = Attacker.TileDistanceBetween(TargetUnitState);

		if (BonusModType == MODOP_Addition)
		{
				return BaseMod + (BonusMod * TileDistance);
		}
		else if (BonusModType == MODOP_Multiplication)
		{
				return CurrentDamage * (BaseMod + (BonusMod * TileDistance));
		}
	}

	return 0;
}