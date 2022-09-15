// This is an Unreal Script

class MZ_Effect_PsiBoostedStatChange extends X2Effect_ModifyStats;

var array<StatChange>	m_aStatChanges;
var int PreScalarAdjust;
var int PostScalarAdjust;
var float PsiFactor;

defaultproperties
{
	PreScalarAdjust=-50
	PostScalarAdjust=+100
	PsiFactor=2.23
}

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
	local float					StatChangeScalar;
	local XComGameState_Unit	SourceUnitState;

	NewEffectState.StatChanges = m_aStatChanges;

	SourceUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	StatChangeScalar = ((SourceUnitState.GetCurrentStat(eStat_PsiOffense) + PreScalarAdjust)*PsiFactor + PostScalarAdjust)/100;

	for (idx = 0; idx < NewEffectState.StatChanges.Length; ++idx)
	{
		Change = NewEffectState.StatChanges[ idx ];

		NewEffectState.StatChanges[ idx ].StatAmount *= StatChangeScalar;

		if (`SecondWaveEnabled('BetaStrike') && (Change.StatType == eStat_HP) && (Change.ModOp == MODOP_Addition))
		{
			NewEffectState.StatChanges[ idx ].StatAmount *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}