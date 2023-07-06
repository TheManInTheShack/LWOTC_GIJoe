class UIOfficerTrainingSchool_MFSC_Override extends UIOfficerTrainingSchool;

static function StrategyRequirement GenerateAlternateRequirement(string CurrentClass, StrategyRequirement BaseReq) {
	local StrategyRequirement req;

	req.RequiredHighestSoldierRank = BaseReq.RequiredHighestSoldierRank;
	req.RequiredSoldierClass = name(CurrentClass);
	req.RequiredSoldierRankClassCombo = true;
	req.bVisibleIfSoldierRankGatesNotMet = BaseReq.bVisibleIfSoldierRankGatesNotMet;

	return req;
}

static function array<StrategyRequirement> GenerateAlternateRequirementsFor(StrategyRequirement BaseReq) {
	local array<StrategyRequirement> AltReq;
	local string CurrentClass;

	AltReq.Length = 0;

	if (BaseReq.RequiredSoldierClass == 'Templar') {
		foreach class'MultipleFactionSoldierClassController'.default.TemplarClasses(CurrentClass) {
			if (CurrentClass != "Templar") {
				AltReq.AddItem(GenerateAlternateRequirement(CurrentClass, BaseReq));
			}
		}

	} else if (BaseReq.RequiredSoldierClass == 'Skirmisher') {
		foreach class'MultipleFactionSoldierClassController'.default.SkirmisherClasses(CurrentClass) {
			if (CurrentClass != "Skirmisher") {
				AltReq.AddItem(GenerateAlternateRequirement(CurrentClass, BaseReq));
			}
		}

	} else if (BaseReq.RequiredSoldierClass == 'Reaper') {
		foreach class'MultipleFactionSoldierClassController'.default.ReaperClasses(CurrentClass) {
			if (CurrentClass != "Reaper") {
				AltReq.AddItem(GenerateAlternateRequirement(CurrentClass, BaseReq));
			}
		}
	}


	return AltReq;
}

simulated function bool CanAffordItem(int iOption)
{
	return XComHQ.MeetsRequirmentsAndCanAffordCost(m_arrUnlocks[iOption].Requirements,
		m_arrUnlocks[iOption].Cost, XComHQ.OTSUnlockScalars, XComHQ.GTSPercentDiscount,
		GenerateAlternateRequirementsFor(m_arrUnlocks[iOption].Requirements));
}

function bool OnUnlockOption(int iOption)
{
	local XComGameState NewGameState;
	local array<StrategyRequirement> AltReq;

	AltReq = GenerateAlternateRequirementsFor(m_arrUnlocks[iOption].Requirements);

	if (XComHQ.MeetsRequirmentsAndCanAffordCost(m_arrUnlocks[iOption].Requirements,
		m_arrUnlocks[iOption].Cost, XComHQ.OTSUnlockScalars, XComHQ.GTSPercentDiscount, AltReq))
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("OTS Ability Unlock -" @ m_arrUnlocks[iOption].DisplayName);

		// UGLY!
		if (class'XComGameState_HeadquartersXCom_MFSC'.static.AddSoldierUnlockTemplateForHQAlt(XComHQ, NewGameState, m_arrUnlocks[iOption], false, AltReq))
		{			
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

			//update the stored HQ to our current game state after unlocking the training
			XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ(); 
		}
		else
		{
			`XCOMHISTORY.CleanupPendingGameState(NewGameState);
		}

		return true;
	}

	return false;
}

simulated function bool MeetsItemReqs(int ItemIndex)
{
	local array<StrategyRequirement> AltReq;
	local StrategyRequirement req;

	if( ItemIndex > -1 && ItemIndex < arrItems.Length )
	{
		if (XComHQ.MeetsAllStrategyRequirements(arrItems[ItemIndex].Requirements)) {
			return true;
		} else {
			AltReq = GenerateAlternateRequirementsFor(arrItems[ItemIndex].Requirements);
			if (AltReq.Length > 0) {
				foreach AltReq(req) {
					if (XComHQ.MeetsAllStrategyRequirements(req)) {
						return true;
					}
				}
			}
			return false;
		}
	}
	else
	{
		return false;
	}
}
