class X2AbilityCost_GrenadeActionPoints extends X2AbilityCost_ActionPoints config(GameData_SoldierSkills);

var config array<name> FlashbangTemplates;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	if (AbilityOwner.IsUnitAffectedByEffectName('Fastball'))
		return 0;

	return super.GetPointCost(AbilityState, AbilityOwner);
}

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local XComGameState_Item ItemState;
	local int i;
	local bool bHasFlashyPlays;

	ItemState = AbilityState.GetSourceAmmo();
	if (ItemState == none)
		ItemState = AbilityState.GetSourceWeapon();

	bHasFlashyPlays = AbilityOwner.HasSoldierAbility('FlashyPlays') || AbilityOwner.HasSoldierAbility('FlashyPlays');

	if (ItemState != none)
	{
		if (default.FlashbangTemplates.Find(ItemState.GetMyTemplateName()) != INDEX_NONE && bHasFlashyPlays)
			return false;
	}
	else
		`RedScreen("No ItemState for" @ AbilityState.GetMyTemplateName());

	if (bConsumeAllPoints)
	{
		for (i = 0; i < DoNotConsumeAllEffects.Length; ++i)
		{
			if (AbilityOwner.IsUnitAffectedByEffectName(DoNotConsumeAllEffects[i]))
				return false;
		}
		for (i = 0; i < DoNotConsumeAllSoldierAbilities.Length; ++i)
		{
			if (DoNotConsumeAllSoldierAbilities[i] == 'FlashyPlays' || DoNotConsumeAllSoldierAbilities[i] == 'FlashyPlays')
				continue;
			if (AbilityOwner.HasSoldierAbility(DoNotConsumeAllSoldierAbilities[i]))
				return false;
		}
	}

	return bConsumeAllPoints;
}

