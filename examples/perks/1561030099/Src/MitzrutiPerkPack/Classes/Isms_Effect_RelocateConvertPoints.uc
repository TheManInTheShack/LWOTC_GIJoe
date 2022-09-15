class Isms_Effect_RelocateConvertPoints extends X2Effect;

var name PointType;

var bool bApplyOnlyWhenOut;
var array<Name> SkipWithEffect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local int i, NumActionPoints;
	local Name SkipEffect;

	UnitState = XComGameState_Unit(kNewTargetState);
	if( UnitState != none )
	{
		foreach SkipWithEffect(SkipEffect)
		{
			if( UnitState.IsUnitAffectedByEffectName(SkipEffect) )
			{
				return;
			}
		}

		NumActionPoints = UnitState.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint);

		if( !bApplyOnlyWhenOut || (UnitState.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint) == 0) )
		{
			UnitState.ActionPoints.length = 0;	
			for( i = 0; i < NumActionPoints; ++i )
			{
				
				UnitState.ActionPoints.AddItem(PointType);
			}
		}
	}
}