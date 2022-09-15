class MZ_Helper_Tactical extends X2TacticalVisibilityHelpers;

simulated static function GetAllVisibleUnitsForUnit(int SourceStateObjectID, out array<StateObjectReference> VisibleUnits, optional array<X2Condition> RequiredConditions, int HistoryIndex = -1)
{
	local X2GameRulesetVisibilityManager VisibilityMgr;	

	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	VisibleUnits.Length = 0;

	//Set default conditions (visible units need to be alive and game play visible) if no conditions were specified
	if( RequiredConditions.Length == 0 )
	{
		RequiredConditions = default.LivingGameplayVisibleFilter;
	}

	VisibilityMgr.GetAllVisibleToSource(SourceStateObjectID, VisibleUnits, class'XComGameState_Unit', HistoryIndex, RequiredConditions);
}