class MZ_Effect_LifeByAbilityCount extends X2Effect_ModifyStats;
//bit of a misnomer, but the original idea was just for HP.
var array<StatChange>	m_aStatChanges;

var array<name> AbilityNames;
var ECharStatType Stat;
var float BonusMod;

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, optional EStatModOp InModOp=MODOP_Addition )
{
	local StatChange NewChange;
	
	NewChange.StatType = StatType;
	NewChange.StatAmount = StatAmount;
	NewChange.ModOp = InModOp;

	m_aStatChanges.AddItem(NewChange);
}


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit				UnitState;
	local int								Bonus;
	local name								AbilityName;

	//	Stat Changes array must be wiped before the Effect is added every time. Otherwise, AddPersistentStatChange will be used multiple times, changing the effect template every time, 
	//	so the Ablative HP bonuses would increase every time the effect is added to a new soldier.
	m_aStatChanges.Length = 0;
	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none)
	{
		foreach AbilityNames(AbilityName)
		{
			if ( UnitState.HasSoldierAbility(AbilityName, True) )
			{
				Bonus += 1;
			}
		}
		

		if (`SecondWaveEnabled('BetaStrike') && (Stat == eStat_HP || Stat == eStat_ShieldHP))
		{
			AddPersistentStatChange(Stat, Round(BonusMod*Bonus*(class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod)));
		}
		else
		{
			AddPersistentStatChange(Stat, Round(BonusMod*Bonus));
		}
		
	}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}