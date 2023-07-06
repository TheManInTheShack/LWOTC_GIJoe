class XComGameState_HeadquartersXCom_MFSC extends  XComGameState_HeadquartersXCom;

static function bool AddSoldierUnlockTemplateForHQAlt(XComGameState_HeadquartersXCom OrigXComHQ,
	XComGameState NewGameState, X2SoldierUnlockTemplate UnlockTemplate, bool bNoReqOrCost, array<StrategyRequirement> AltReq)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	//`assert(NewGameState != none);
	if (!OrigXComHQ.HasSoldierUnlockTemplate(UnlockTemplate.DataName))
	{
		if(bNoReqOrCost ||
			OrigXComHQ.MeetsRequirmentsAndCanAffordCost(UnlockTemplate.Requirements, UnlockTemplate.Cost,
				OrigXComHQ.OTSUnlockScalars, OrigXComHQ.GTSPercentDiscount, AltReq))
		{
			if(!bNoReqOrCost)
			{
				OrigXComHQ.PayStrategyCost(NewGameState, UnlockTemplate.Cost, OrigXComHQ.OTSUnlockScalars, OrigXComHQ.GTSPercentDiscount);
			}
			
			NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', OrigXComHQ.ObjectID));
			NewXComHQ.SoldierUnlockTemplates.AddItem(UnlockTemplate.DataName);
			UnlockTemplate.OnSoldierUnlockPurchased(NewGameState);
			return true;
		}
	}
	return false;
}
