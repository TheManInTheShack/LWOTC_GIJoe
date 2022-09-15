class MZ_Effect_RandomStatChange extends X2Effect_ModifyStats;

var array<StatChange>	m_aStatChanges;

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
	local int					idx;
	local StatChange			Change;

	NewEffectState.StatChanges = m_aStatChanges;

	for (idx = 0; idx < NewEffectState.StatChanges.Length; ++idx)
	{
		Change = NewEffectState.StatChanges[ idx ];

		NewEffectState.StatChanges[ idx ].StatAmount = (NewEffectState.StatChanges[ idx ].StatAmount * `SYNC_RAND(100)) / 100;

		if (`SecondWaveEnabled('BetaStrike') && (Change.StatType == eStat_HP) && (Change.ModOp == MODOP_Addition))
		{
			NewEffectState.StatChanges[ idx ].StatAmount *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}