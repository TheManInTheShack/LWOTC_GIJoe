class MZ_Effect_DamageByTargetCount extends X2Effect_Persistent;

var int DMG_INCREMENT;

var array<name> AbilityNames;
var bool MaxBonusToAllTargets;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int DamageMod, TargetIndex;
	local array<StateObjectReference> AbilityTargets;
	local array<StateObjectReference> UnitAbilityTargets;
	local StateObjectReference AbilityTarget;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	
	History = `XCOMHISTORY;

	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
		return 0;

	if ( AbilityNames.Length > 0 && AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE ) { return 0; }

	// only limit this when actually applying damage (not previewing)
	if (NewGameState != none)
	{
		AbilityTargets = AppliedData.AbilityInputContext.MultiTargets;

		if ( !MaxBonusToAllTargets && XComGameState_Unit(History.GetGameStateForObjectID(AppliedData.AbilityInputContext.PrimaryTarget.ObjectID)) != none )
		{
			UnitAbilityTargets.AddItem(AppliedData.AbilityInputContext.PrimaryTarget);
		}

		foreach AbilityTargets(AbilityTarget)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityTarget.ObjectID));
			if (UnitState != None)
			{
				UnitAbilityTargets.AddItem(AbilityTarget);
			}
		}

		if ( MaxBonusToAllTargets )
		{
			return UnitAbilityTargets.Length * DMG_INCREMENT;
		}

		TargetIndex = UnitAbilityTargets.Find('ObjectID', AppliedData.TargetStateObjectRef.ObjectID);
		DamageMod = max(0,TargetIndex) * DMG_INCREMENT;
		if ( AbilityState.GetMyTemplateName() == 'MZVoltaicArcAttack')
		{
			DamageMod = DamageMod/2;
		}
		return  DamageMod;
	}

	return 0;
}