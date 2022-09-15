// This is an Unreal Script
class MZ_Effect_PostCombatHeal extends X2Effect_Persistent;
//note: largely based on smart macrophages from lw2

var int PercentToHeal;

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnitState; 
	local int						HealAmount;

    History = `XCOMHISTORY;
    SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    //`LOG("Smart Macrophages: TargetUnit=" $ UnitState.GetFullName() $ ", SourceUnit=" $ SourceUnitState.GetFullName());

    if(!PostCombatHealEffectIsValidForSource(SourceUnitState)) { return; }

    //`LOG("Smart Macrophages: Source Unit Valid.");

    if(UnitState == none) { return; }
    if(UnitState.IsDead()) { return; }
    if(UnitState.IsBleedingOut()) { return; }
    if(!CanBeHealed(UnitState)) { return; }

    //`LOG("Smart Macrophages: Target Unit Can Be Healed.");

    //`LOG("Smart Macrophages : Pre update LowestHP=" $ UnitState.LowestHP);
	HealAmount = (UnitState.HighestHP - UnitState.LowestHP) * PercentToHeal / 100;
    UnitState.LowestHP += HealAmount;
    //`LOG("Smart Macrophages : Post update LowestHP=" $ UnitState.LowestHP);
	If ( UnitState.LowestHP < UnitState.GetMaxStat(eStat_HP) )
	{
		If ( UnitState.GetCurrentStat(eStat_HP) < UnitState.LowestHP )
		{
			UnitState.ModifyCurrentStat(eStat_HP, (UnitState.LowestHP - UnitState.GetCurrentStat(eStat_HP)) );
		}
	}
	else
	{
		UnitState.ModifyCurrentStat(eStat_HP, (UnitState.GetMaxStat(eStat_HP) - UnitState.GetCurrentStat(eStat_HP)) );
	}

    super.UnitEndedTacticalPlay(EffectState, UnitState);
}

function bool CanBeHealed(XComGameState_Unit UnitState)
{
     return (UnitState.LowestHP < UnitState.HighestHP && UnitState.LowestHP > 0); //GetMaxStat(eStat_HP) && UnitState.LowestHP > 0);
}

function bool PostCombatHealEffectIsValidForSource(XComGameState_Unit SourceUnit)
{
    if(SourceUnit == none) { return false; }
    if(SourceUnit.IsDead()) { return false; }
    if(SourceUnit.bCaptured) { return false; }
    if(SourceUnit.LowestHP == 0) { return false; }
    return true;
}

DefaultProperties
{
    EffectName="AdaptiveBoneMarrow"
    DuplicateResponse=eDupe_Ignore
}