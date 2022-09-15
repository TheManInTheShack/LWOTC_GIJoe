class X2Effect_GrantShields extends X2Effect_ModifyStats;

var int ConventionalAmount, MagneticAmount, BeamAmount;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ShieldsExpended', EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Item SourceItem;
	local X2WeaponTemplate WeaponTemplate;
	local StatChange Change;

	Change.StatType = eStat_ShieldHP;
	Change.StatAmount = ConventionalAmount;

	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if (SourceItem == none)
		SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

	if (SourceItem != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceItem.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			if (WeaponTemplate.WeaponTech == 'magnetic')
				Change.StatAmount = MagneticAmount;
			else if (WeaponTemplate.WeaponTech == 'beam')
				Change.StatAmount = BeamAmount;
		}
	}
	NewEffectState.StatChanges.AddItem(Change);
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultproperties
{
	DuplicateResponse=eDupe_Refresh
}