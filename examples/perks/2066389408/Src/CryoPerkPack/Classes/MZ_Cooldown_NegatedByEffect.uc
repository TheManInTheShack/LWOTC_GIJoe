class MZ_Cooldown_NegatedByEffect extends X2AbilityCooldown;

var array<name> EffectNameNegates;

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local XComGameState_Unit Caster;
	local name EffectName;

	// For debug only
	if(`CHEATMGR != None && `CHEATMGR.strAIForcedAbility ~= string(kAbility.GetMyTemplateName()))
		iNumTurns = 0;

	History = `XCOMHISTORY;
	Caster= XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	foreach EffectNameNegates(EffectName)
	{
		If( Caster.IsUnitAffectedByEffectName(EffectName) ) { return; }
	}

	if(bDoNotApplyOnHit)
	{
		AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
		if(AbilityContext != None && AbilityContext.IsResultContextHit())
			return;
	}
	kAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);

	ApplyAdditionalCooldown(kAbility, AffectState, AffectWeapon, NewGameState);
}