class XComGameState_Unit_MFSC extends XComGameState_Unit;

static function X2CharacterTemplate GetCharTemplateForUnit(XComGameState_Unit UnitState) {
	return UnitState.m_CharTemplate;
}

static function name GetCharTemplateNameForUnit(XComGameState_Unit UnitState) {
	return UnitState.m_CharTemplate.DataName;
}

static function name DetermineCharacterPoolClassForUnit(XComGameState_Unit UnitState) {
	local CharacterPoolManager PoolManager;
	local XComGameState_Unit UnitFromPool;
	
	PoolManager = CharacterPoolManager( `XENGINE.GetCharacterPoolManager() );

	UnitFromPool = PoolManager.GetCharacter(UnitState.GetFullName());

	if (UnitFromPool != none ) {
		return UnitFromPool.GetSoldierClassTemplateName();
	}

	return '';
}

static function name ResetSoldierRankForUnit(XComGameState_Unit UnitState, name ClassName) {
	UnitState.m_SoldierRank = 0;
	UnitState.SetXPForRank(1);
	UnitState.StartingRank = 1;
	UnitState.RankUpSoldier(UnitState.GetParentGameState(), ClassName);

	UnitState.AbilityPoints = 0;

	return ClassName;
}