class MZ_Effect_BlastWaveDamageFromDebuffs extends X2Effect_Persistent;

var float BonusScalar;
var float FirstDebuffBonusScalar;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local StateObjectReference		EffectObjectRefrence;
	local XComGameStateHistory		History;
	local X2Effect_Persistent		Effect;
	local int						DebuffCount;
	
	if ( AbilityNames.Length > 0 && AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE) {return 0;}
	
	History = `XCOMHISTORY;
	DebuffCount = 0;

	foreach Attacker.AffectedByEffects(EffectObjectRefrence)
	{
		Effect = XComGameState_Effect(History.GetGameStateForObjectId(EffectObjectRefrence.ObjectID)).GetX2Effect();
		If ( Effect.BuffCategory == ePerkBuff_Penalty && Effect.bDisplayInUI == true ) { DebuffCount += 1; }
	}

	if ( DebuffCount > 0 )
	{
		return Round(CurrentDamage * ( FirstDebuffBonusScalar + BonusScalar * float(DebuffCount) ));
	}

	return 0;
}