class X2Effect_ReduceSelfWoundTime extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local Object EffectObj;

    EffectObj = EffectGameState;

    // Remove the default UnitRemovedFromPlay registered by XComGameState_Effect. This is necessary so we can
    // suppress the usual behavior of the effects being removed when a unit evacs. We can't process field surgeon
    // at that time because we could evac a wounded unit and then have the surgeon get killed on a later turn. We
    // need to wait until the mission ends and then process FS.
    `XEVENTMGR.UnRegisterFromEvent(EffectObj, 'UnitRemovedFromPlay');
}

function ReduceWoundTime(XComGameState_Effect EffectState, XComGameState_Unit OrigUnitState, XComGameState NewGameState)
{
    local XComGameState_Unit        SourceUnitState, UnitState;

    UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(OrigUnitState.ObjectID));
    if (UnitState == none)
    {
        UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', OrigUnitState.ObjectID));
        NewGameState.AddStateObject(UnitState);
    }

    SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `LOG("X2Effect_ReduceSelfWoundTime: TargetUnit=" $ UnitState.GetFullName() $ ", SourceUnit=" $ SourceUnitState.GetFullName());

    if(!ReduceWoundTimeEffectIsValidForSource(SourceUnitState)) { return; }

    `LOG("X2Effect_ReduceSelfWoundTime: Source Unit Valid.");

    if(UnitState == none) { return; }
    if(UnitState.IsDead()) { return; }
    if(UnitState.IsBleedingOut()) { return; }
    if(!CanBeHealed(UnitState)) { return; }

    `LOG("X2Effect_ReduceSelfWoundTime: Target Unit Can Be Healed.");

    `LOG("X2Effect_ReduceSelfWoundTime: Pre update LowestHP=" $ UnitState.LowestHP);
    UnitState.LowestHP += 1;
    `LOG("X2Effect_ReduceSelfWoundTime: Post update LowestHP=" $ UnitState.LowestHP);

    // Armor HP may have already been removed, apparently healing the unit since we have not yet
    // executed EndTacticalHealthMod. We may only appear injured here for large injuries (or little
    // armor HP). Current HP is used in the EndTacticalHealthMod adjustment, so we should increase it
    // if it's less than the max, but don't exceed the max HP.
    if (UnitState.GetCurrentStat(eStat_HP) < UnitState.GetMaxStat(eStat_HP))
        UnitState.ModifyCurrentStat(eStat_HP, 1);
}

function bool CanBeHealed(XComGameState_Unit UnitState)
{
    // Note: Only test lowest/highest HP here: CurrentHP cannot be trusted in UnitEndedTacticalPlay because
    // armor HP may have already been removed, but we have not yet invoked the EndTacticalHealthMod adjustment.
     return (UnitState.LowestHP < UnitState.HighestHP && UnitState.LowestHP > 0);
}

function bool ReduceWoundTimeEffectIsValidForSource(XComGameState_Unit SourceUnit)
{
    if(SourceUnit == none) { return false; }
    if(SourceUnit.IsDead()) { return false; }
    if(SourceUnit.IsBleedingOut()) { return false; }
    if(SourceUnit.bCaptured) { return false; }
    if(SourceUnit.LowestHP == 0) { return false; }
    if(SourceUnit.IsUnconscious()) { return false; }
    return true;
}

DefaultProperties
{
    EffectName="ReduceWoundTime"
}
