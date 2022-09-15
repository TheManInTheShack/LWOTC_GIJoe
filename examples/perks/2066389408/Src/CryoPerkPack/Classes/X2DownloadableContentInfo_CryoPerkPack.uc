//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_CryoPerkPack.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_CryoPerkPack extends X2DownloadableContentInfo;

var config array<name> IncludeTemplateNames;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated() 
{
	`LOG("Mitzruti DLC Perk Pack: OPTC starting.");

	class'MZJetpack_AbilitySet'.static.ModifyJetPackAbilities();

	`LOG("Mitzruti DLC Perk Pack: OPTC completed.");
}

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	if( default.IncludeTemplateNames.Find(UnitState.GetMyTemplateName()) == INDEX_NONE )
	{
		return;
	}
	
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("FX_MZCryomancer.Anims.AS_MZCryomancer")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("FX_MZGeomancer.Anims.AS_GeoTeleport")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("FX_MZGeomancer.Anims.AS_MZGeomancer")));
	CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("FX_MZSlingBlade.Anims.AS_Icebreaker")));
	//core pack takes care of blood magic anims.

	return;
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);
	switch (TagText)
	{
		case 'NatureWrathCRITCHANCE':
			OutString =  string(class'MZGeomancer_AbilitySet'.default.NaturesWrath_CritPerAbility);
			return true;
		case 'NatureWrathCRITDAMAGE':
			OutString =  string(class'MZGeomancer_AbilitySet'.default.NaturesWrath_CritDmgPerAbility);
			return true;
		case 'ULTIMAJETSHOTCOST':
			OutString = string(class'MZJetpack_AbilitySet'.default.UltimaShot_JetChargeCost);
			return true;
		case 'MZSHIVERCHANCE':
			OutString =  string(class'MZCryoshot_AbilitySet'.default.Shiver_Chance) $"%";
			return true;
		case 'MZSHIVERONCRITCHANCE':
			OutString =  string(class'MZCryoshot_AbilitySet'.default.ShiverOnCrit_Chance) $"%";
			return true;
		case 'MZSHIVERSUPPRESSCHANCE':
			OutString =  string(class'MZCryoshot_AbilitySet'.default.ShiverSuppress_Chance) $"%";
			return true;

		default:
			return false;
	}

}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
	local name					TagText;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate		AbilityTemplate;
	local int					Idx;
	local MZ_Damage_AddElemental ElemDamage;
	
	TagText = name(InString);
	switch (TagText)
	{
		case 'MZAddElemTargetDamageDLC':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityTargetEffects.Length; ++Idx)
				{
					ElemDamage = MZ_Damage_AddElemental(AbilityTemplate.AbilityTargetEffects[Idx]);
					if ( ElemDamage != none )
					{
						OutString = string(Round(ElemDamage.BonusDamageScalar *100)) $ "%";
						return true;
					}
				}
			}
			return true;

		case 'MZAddElemMultiDamageDLC':
			OutString = "0";
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					ElemDamage = MZ_Damage_AddElemental(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( ElemDamage != none )
					{
						OutString = string(Round(ElemDamage.BonusDamageScalar *100)) $ "%";
						return true;
					}
				}
			}
			return true;

		default:
			return false;
	}
}