class MZ_Effect_ShieldGate extends X2Effect_Persistent;

function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local DamageResult DmgResult;
	local int TargetHP;

	if ( UnitState.GetCurrentStat(eStat_ShieldHP) <= 0 )
	{
		//no shields means they can't be saved by converting shields!
		return false;
	}

	//`LOG("FROSTDIVISION TEST: " $ UnitState.GetMyTemplateName() $ " -- " $ UnitState.GetCurrentStat(eStat_HP) $ " HP " $ UnitState.GetCurrentStat(eStat_ShieldHP) $ " SP" );

	DmgResult = UnitState.DamageResults[UnitState.DamageResults.Length - 1];

	//`LOG("Damage Taken: " $ DmgResult.DamageAmount $ " HP " $ DmgResult.ShieldHP $" SP");
	
	if ( DmgResult.bFreeKill == true )
	{
		//when executed, they still die.
		return false;
	}

	//tests suggested shield damage is applied before this gets called, and HP damage after.
	TargetHP = UnitState.GetCurrentStat(eStat_HP) + UnitState.GetCurrentStat(eStat_ShieldHP) - DmgResult.DamageAmount;

	if ( TargetHP < 1 )
	{
		//too much damage for this to save them.
		return false;
	}
	else if ( TargetHP < UnitState.GetMaxStat(eStat_HP) )
	{
		//shift all Shield to regular HP.
		UnitState.SetCurrentStat(eStat_HP, TargetHP);
		UnitState.SetCurrentStat(eStat_ShieldHP, 0);
	}
	else
	{
		//Max out HP, leave remainder as shield
		UnitState.SetCurrentStat(eStat_HP, UnitState.GetMaxStat(eStat_HP));
		UnitState.SetCurrentStat(eStat_ShieldHP, Max((TargetHP - UnitState.GetMaxStat(eStat_HP)), 0) );
	}

	return true;
}
function bool PreBleedoutCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	return PreDeathCheck(NewGameState, UnitState, EffectState);
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMan;
	local Object EffectObj;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', MZ_Helper_EffectGS(EffectGameState).FrostShieldAntiBypassListener, ELD_OnStateSubmitted, , UnitState);
}

defaultproperties
{
	EffectName = "MZ_ShieldGateEffect"
	GameStateEffectClass = class'MZ_Helper_EffectGS'
	DuplicateResponse = eDupe_Ignore
}