class X2Effect_KVImpEvasion extends X2Effect_GrantActionPoints;

function bool GiveActionPoints(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local int i;
	local Name SkipEffect;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState.HasSoldierAbility('KVImpEvasionPassive'))
	{
		foreach SkipWithEffect(SkipEffect)
		{
			if( UnitState.IsUnitAffectedByEffectName(SkipEffect) )
			{
				return false;
			}
		}
		if( !bApplyOnlyWhenOut || (UnitState.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint) == 0) )
		{
			for( i = 0; i < NumActionPoints; ++i )
			{
				UnitState.ActionPoints.AddItem(PointType);
			}
		}
	}
	else
	{
		return false;
	}

}


