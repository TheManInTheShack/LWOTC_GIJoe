class X2StrategyElement_XpackRewards_MFSC extends X2StrategyElement_XpackRewards;

static function GenerateFactionSoldierReward_MFSC(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Unit NewUnitState;
	local XComGameState_ResistanceFaction FactionState;
	local name nmCountry, nmCharacterClass;

	History = `XCOMHISTORY;
	ActionState = XComGameState_CovertAction(NewGameState.GetGameStateForObjectID(AuxRef.ObjectID));
	FactionState = XComGameState_ResistanceFaction(History.GetGameStateForObjectID(AuxRef.ObjectID));
	if (ActionState != none) // If this is a covert action reward, the action's faction determines the character type
	{
		nmCharacterClass = ActionState.GetFaction().GetChampionCharacterName();
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActionState.Region.ObjectID));
	}
	else if (FactionState != none) // If this is a Res Op mission for a faction, give the associated soldier
	{
		nmCharacterClass = FactionState.GetChampionCharacterName();
		RegionState = FactionState.GetHomeRegion();
	}

	if (nmCharacterClass == '')
	{
		`RedScreen("@jweinhoffer Failed to find a soldier class when generating a Faction Soldier Reward.");
	}
	
	// Grab the region and pick a random country
	nmCountry = '';
	if (RegionState != none)
	{
		nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();
	}	

	NewUnitState = CreatePersonnelUnit_MFSC(NewGameState, nmCharacterClass, nmCountry);
	RewardState.RewardObjectReference = NewUnitState.GetReference();
}

static function XComGameState_Unit CreatePersonnelUnit_MFSC(XComGameState NewGameState, name nmCharacter, name nmCountry, optional bool bIsRookie)
{
	local XComGameStateHistory History;
	local XComGameState_Unit NewUnitState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local name CharacterPoolClass;
	local int idx, NewRank, StartingIdx;

	History = `XCOMHISTORY;

	//Use the character pool's creation method to retrieve a unit
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, nmCharacter, nmCountry);
	NewUnitState.RandomizeStats();

	`log("MFSC DEBUG: Executing CREATEPERSONNELUNIT_MFSC");

	if (NewUnitState.IsSoldier())
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

		if (!NewGameState.GetContext().IsStartState())
		{
			ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
		}

		// if a class was specified in the character pool, use it
		CharacterPoolClass = class'XComGameState_Unit_MFSC'.static.DetermineCharacterPoolClassForUnit(NewUnitState);
		if (CharacterPoolClass != '') {
			`log("MFSC DEBUG: CharacterPoolClass found -- " $ CharacterPoolClass);

			NewUnitState.SetSoldierClassTemplate(CharacterPoolClass);

			// force the template class to be this class!
			NewUnitState.GetMyTemplate().DefaultSoldierClass = CharacterPoolClass;
		} else {
			`log("MFSC DEBUG: No character pool class found! Using default!");
		}

		NewUnitState.ApplyInventoryLoadout(NewGameState);
		NewRank = GetPersonnelRewardRank(true, bIsRookie);
		NewUnitState.SetXPForRank(NewRank);
		NewUnitState.StartingRank = NewRank;
		StartingIdx = 0;

		// character pool classes are squaddies
		if (CharacterPoolClass != '') {
	
			StartingIdx = 1;

		} else if (NewUnitState.GetMyTemplate().DefaultSoldierClass != '' &&
			NewUnitState.GetMyTemplate().DefaultSoldierClass != class'X2SoldierClassTemplateManager'.default.DefaultSoldierClass)
		{
			// Some character classes start at squaddie on creation
			StartingIdx = 1;
		}

		for (idx = StartingIdx; idx < NewRank; idx++)
		{
			// SINCE THIS CODE APPLIES TO FACTION SOLDIERS IT SHOULD ACTUALLY NEVER HAPPEN
			if (idx == 0)
			{
				NewUnitState.RankUpSoldier(NewGameState, ResistanceHQ.SelectNextSoldierClass());
				NewUnitState.ApplySquaddieLoadout(NewGameState);
				NewUnitState.bNeedsNewClassPopup = false;
			}
			else
			{
				NewUnitState.RankUpSoldier(NewGameState, NewUnitState.GetSoldierClassTemplate().DataName);
			}
		}

		// Set an appropriate fame score for the unit
		NewUnitState.StartingFame = XComHQ.AverageSoldierFame;
		NewUnitState.bIsFamous = true;
	}
	else
	{
		NewUnitState.SetSkillLevel(GetPersonnelRewardRank(false));
	}

	return NewUnitState;
}
