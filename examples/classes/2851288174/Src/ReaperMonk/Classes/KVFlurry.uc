class KVFlurry extends X2Effect_Persistent config(MonkAbility);

var config bool bIgnoreFreeCostAbilities;
var config bool bIgnoreMoveActionCostAbilities;
var config bool bCannotCombineWithReaper;
var config bool bStandardAPLimit;
var config array<name> AbilityBlacklist;
var config array<name> AbilityWhitelist;
var config array<name> EffectBlacklist;
var config array<name> FlurryActionEnable;
var config array<name> UnarmedWeapons;
var config array<name> MonkFlurryBuffList;

/*
Expected behavior:

Windcaller's Legacy by itself:
If you attack an enemy in melee:
- without moving: that costs 1 AP and doesn't end turn. 
- blue move: that gives Move AP.
- gold move: ends turn per usual.

Empty Secondary: always gain Move AP for any melee attack.
Windcaller's Fury: all attacks cost 1 AP and don't end turn.

*/

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'KVMonkFlurryEffect', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Player		PlayerState;
	local XComGameState_Ability		AbilityState;
	//local XComGameState_Item		InternalWeaponState, ItemState;
	local X2EventManager			EventMgr;
	local XComGameStateHistory		History;
	local int						i;
	//local StateObjectReference		EffectRef;
	//local XComGameState_Unit		UnitState;
	//local UnitValue					MoveValue;
	local bool						bEnemyTurn;
	local name						BlacklistedEffect;
	local name						MonkFlurryBuffEffect;
	//local name						EnableFlurryAction;
	local UnitValue					UV;
	//local XComGameStateHistory		History;
	local bool						bUnitHasKVMonkFlurry;
	local int						PreCostStandardActionPoints;
	local int						PreCostMoveActionPoints;
	local bool						bGrantStandardAP;
	local bool						bGrantMoveAP;
	local bool						bAttackedOnce;
	//local XComGameState_Item		SourceWeapon;
	//local bool						bOncePerTurn;
	//local bool						bMoveAction;
	

	//	========================================================================
	//			Initial Checks Start

	//	If the activated ability is blacklisted, do nothing. We blacklist Blitz Kick, since it costs only a Move Action Point, 
	//	so if Windcaller's Blessing would grant another Move action point, it would allow to reuse Blitz Kick indefinitely.
	//	Technically, Blitz Kick would be flitered out further below, but this is less performance intensive.
	if (default.AbilityBlacklist.Find(kAbility.GetMyTemplateName()) != INDEX_NONE) 
	{
		return false;
	}
	
	//	If the activated ability did not cost any Action Points, then do nothing, if configured so.
	if (default.bIgnoreFreeCostAbilities && !DoesAbilityCostActionPoints(kAbility.GetMyTemplate(), kAbility.GetSourceWeapon())) 
	{
		return false;
	}

	//	If the activated ability costs only Move action points, then do nothing, if configured so. 
	if (default.bIgnoreMoveActionCostAbilities && DoesAbilityCostOnlyMoveActionPoints(kAbility.GetMyTemplate())) 
	{
		return false;
	}

	foreach EffectBlacklist(BlacklistedEffect)
	{
		if (SourceUnit.IsUnitAffectedByEffectName(BlacklistedEffect)) 
		{
			return false;
		}
	}



    //if (InternalWeaponState == none)
    //{
        //InternalWeaponState = XComGameState_Item(History.GetGameStateForObjectID(WeaponArchetype.ObjectID));
    //}

	
		if (!HasDualKnucklesEquipped(SourceUnit))
		{
			return false;
		}

	//	If configured so, exit early if the soldier has used Reaper this turn.
	if (default.bCannotCombineWithReaper)
	{
		SourceUnit.GetUnitValue('Reaper_SuperKillCheck', UV);
		if (UV.fValue != 0) 
		{
			return false;
		}
	}
	
	//	Check if it's currently enemy turn or not.
	History = `XCOMHISTORY;
	PlayerState = XComGameState_Player(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.PlayerStateObjectRef.ObjectID));
	if (PlayerState != none)
	{
		bEnemyTurn = PlayerState.TeamFlag != `TACTICALRULES.GetUnitActionTeam();

		//	Proceed only if it is currently the turn of the player whose unit has applied this effect.
		//	Basically don't let Windcaller trigger during enemy turns.
		//if (PlayerState.TeamFlag != `TACTICALRULES.GetUnitActionTeam()) return false;
	}

	if (kAbility.GetMyTemplate().IsMelee() && kAbility.IsAbilityInputTriggered() || default.AbilityWhitelist.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
	{	
		//			Initial Checks End
		//	========================================================================

		//	========================================================================
		//			Collect information about the ability activation.

		//	Windcaller's Fury interaction. Melee attacks always cost 1 AP with Windcaller's Fury.
		if (SourceUnit.HasSoldierAbility('KVMonkFlurry'))
		{
			bUnitHasKVMonkFlurry = true;
		}
		
		//	Empty Secondary Weapon interaction. Melee attacks always grant a Move AP with Windcaller's Fury.
		//if (class'Help'.static.HasEmptySecondaryEquipped(SourceUnit))
		//{
			//bGrantMoveAP = true;
		//}

		//MoveCost = 1;
		////	This ability involved movement (e.g. running melee)
		//if (AbilityContext.InputContext.MovementPaths.Length > 0)
		//{
			////	Calculate how many Action Points' worth the unit has moved for this melee attack.
			//PathIndex = AbilityContext.GetMovePathIndex(SourceUnit.ObjectID);
			//
			//for (i = AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1; i >= 0; --i)
			//{
				//if (AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles[i] == SourceUnit.TileLocation)
				//{
					//FarthestTile = i;
					//break;
				//}
			//}
//
			//for (i = 0; i < AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases.Length; ++i)
			//{
				//if (AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases[i] <= FarthestTile)
					//MoveCost++;
			//}
		//
			//	Calculate how many Standard AP the unit had remaining before activating the ability.
			for (i = 0; i < PreCostActionPoints.Length; i++)
			{
				if (PreCostActionPoints[i] == class'X2CharacterTemplateManager'.default.StandardActionPoint)
				{
					PreCostStandardActionPoints++;
				}
				if (PreCostActionPoints[i] == class'X2CharacterTemplateManager'.default.MoveActionPoint)
				{
					PreCostMoveActionPoints++;
				}
			}
//
		//}
		//else	//	This ability didn't involve moving the soldier. 
		//{
			//SourceUnit.GetUnitValue('MovesThisTurn', MoveValue);
			//MoveCost += MoveValue.fValue;

		//}

		//	========================================================================
		//			Standard Windcaller's Legacy Procedure
		
		//switch (MoveCost)
		//{
			//case 1:
			//if (FarthestTile == 0)	//	No Move
			//{
				////	Attacks against adjacent targets always cost only 1 AP.
				//bRestoreAPExceptOne = true;
			//}
			//else	//	Blue Move
			//{
				//	Check if any standard AP
				//if (!bOncePerTurn && PreCostStandardActionPoints > 0 ) 
				//{
					//bGrantStandardAP = true;
				//}
				//if (bOncePerTurn && !bMoveAction && PreCostStandardActionPoints > 0)
				//{
					//bGrantMoveAP = true;
				//}
			foreach MonkFlurryBuffList(MonkFlurryBuffEffect)
			{
				if (SourceUnit.IsUnitAffectedByEffectName(MonkFlurryBuffEffect))
				 {
				 bAttackedOnce = true;
				 }
			}
		
				//if ((PreCostMoveActionPoints > 0 && PreCostStandardActionPoints >= 1 )  || (PreCostStandardActionPoints >= 2 ))
				if ((!bAttackedOnce && PreCostMoveActionPoints > 0 && PreCostStandardActionPoints >= 1 )  || (!bAttackedOnce && PreCostStandardActionPoints >= 2 ))
				//if (!bAttackedOnce && PreCostStandardActionPoints > 1)
					{
					bGrantStandardAP = true;
					}
				if (!bGrantStandardAP && PreCostStandardActionPoints > 0 ) 
					{				
					bGrantMoveAP = true;
					}
				
			
			//if (default.bStandardAPLimit)
				//{
					//History = `XCOMHISTORY;
					//for (UnitState.AffectedByEffects(EffectRef) >= 1 && PreCostStandardActionPoints > 0)
					//{
						//bGrantMoveAP = true;
					//}
					//for (UnitState.AffectedByEffects(EffectRef) = 0 )
					//{
						//bGrantStandardAP = true;
					//}
				//}
			
//{
    //EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
//
    //// Do stuff with EffectState
//}
				//else 
				//{
				//break;
				//}
			
			
			//case 2:	//	Gold Move or further
			//default:
				//break;
		//}

		//	========================================================================
		//			Grant / Restore AP
//
		//if (bRestoreAPExceptOne)
		//{
			//SourceUnit.ActionPoints = PreCostActionPoints;
			//SourceUnit.ReserveActionPoints = PreCostReservePoints;
//
			//for (i = 0; i < SourceUnit.ActionPoints.Length; i++)
			//{
				//if (SourceUnit.ActionPoints[i] == class'X2CharacterTemplateManager'.default.StandardActionPoint)
				//{
					//SourceUnit.ActionPoints.Remove(i, 1);
					//break;
				//}
			//}
		//}
		if (bGrantStandardAP)
		{
			SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('KVMonkFlurryBuffEffect', SourceUnit, SourceUnit, NewGameState);
		}

		if (bGrantMoveAP)
		{
			SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
		}


		//if (bGrantStandardAP)
		//{
			//SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			//bOncePerTurn = true;
			//bMoveAction = false;
		//}
//
		//if (bGrantMoveAP)
		//{
			//SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
			//bMoveAction = true;
		//}

		//	========================================================================
		//			Flyover

		//	Don't show flyover during enemy turn, it introduces undesirable delays in Intercept / Obsession visualization.
		//	Don't show flyover if after all is said and done the unit got no AP left. (this is what will happened if the unit just spent the last Standard AP on a Sword Slice or something)
		if (!bEnemyTurn && SourceUnit.ActionPoints.Length > 0 && (bGrantStandardAP || bGrantMoveAP))	
		{
			//	Show flyover for Windcaller's Fury, if relevant.
			if (bUnitHasKVMonkFlurry && bGrantStandardAP) 
			{
				AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('KVMonkFlurry').ObjectID));
			}
			//else	//	Otherwise show flyover for Windcaller's Legacy
			//{
				//AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('IRI_Windcaller_Passive').ObjectID));
			//}

			if (AbilityState != none)
			{
				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('KVMonkFlurryEffect', AbilityState, SourceUnit, NewGameState);
			}
		}
		return false;
	}
	return false;
}



//	Some heurestic to filter out abilities that cost only Move Action Points, such as Blitz Kick.
//	We want to filter them out, because if we granted a Move action for casting an ability that costs a Move action, this could continue indefinitely. 
//	We're doing an assumption that the ability has only one meaningful Action Point Cost. 
//	If ability has another Action Point Cost in addition to Move-only, we will still filter it out and not grant an Action Point.
static function bool DoesAbilityCostOnlyMoveActionPoints(const X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCost					AbilityCost;

	foreach Template.AbilityCosts(AbilityCost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
		if (ActionPointCost != none)
		{
			if (ActionPointCost.AllowedTypes.Length == 1 && 
				ActionPointCost.AllowedTypes[0] == class'X2CharacterTemplateManager'.default.MoveActionPoint &&
				ActionPointCost.iNumPoints > 0 &&
				!ActionPointCost.bFreeCost)
			{
				return true;
			}
		}
	}
	return false;
}

static function bool DoesAbilityCostActionPoints(const X2AbilityTemplate Template, const XComGameState_Item SourceWeapon)
{
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCost					AbilityCost;
	local bool							bWeaponHasCost;
	local X2WeaponTemplate				WeaponTemplate;

	//	Check if the weapon that the ability is attached to has Typical Action Cost set.
	//	Mostly we're just checking if the ability is attached to a weapon at all or not, 
	//	as vast majority of weapons will use the default iTypicalActionCost = 1.
	if (SourceWeapon != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate != none && WeaponTemplate.iTypicalActionCost > 0)
		{
			bWeaponHasCost = true;
		}
	}

	//	Cycle through all ability costs associated with this ability
	foreach Template.AbilityCosts(AbilityCost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
		if (ActionPointCost != none)
		{
			//	If this abiltiy cost is an Action Point Cost that's not free, and that costs at least one action point OR consumes all action points on use OR 
			//	set up to cost as many action points as firing the weapon normally does
			if (!ActionPointCost.bFreeCost && (ActionPointCost.iNumPoints > 0 || ActionPointCost.bConsumeAllPoints || bWeaponHasCost && ActionPointCost.bAddWeaponTypicalCost))
			{
				return true;
			}
		}
	}
	return false;
}

static function bool HasDualKnucklesEquipped(XComGameState_Unit UnitState)
{
	return HasPrimaryKnuckleEquipped(UnitState) && HasSecondaryKnuckleEquipped(UnitState);
}

static function bool HasPrimaryKnuckleEquipped(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	local XComGameState_Item	ItemState;
	local name					PrimaryWeaponName;

	ItemState = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, CheckGameState);
	if (ItemState != none)
	{
		PrimaryWeaponName = ItemState.GetMyTemplateName();
	}
	else return false;

	return default.UnarmedWeapons.Find(PrimaryWeaponName) != INDEX_NONE;
}

static function bool HasSecondaryKnuckleEquipped(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	local XComGameState_Item	ItemState;
	local name					SecondaryWeaponName;

	ItemState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, CheckGameState);
	if (ItemState != none)
	{
		SecondaryWeaponName = ItemState.GetMyTemplateName();
	}
	else return false;

	return default.UnarmedWeapons.Find(SecondaryWeaponName) != INDEX_NONE;
}	


DefaultProperties
{
	DuplicateResponse = eDupe_Allow
	EffectName = "KVMonkFlurryEffect"
}

//local XComGameState_Effect EffectState;
//
//EffectState = UnitState.GetUnitAffectedByEffectState('NameOfTheEffect');
//
//if (EffectState != none)
//{
    //// Do stuff
//}

//extends X2Effect_PersistentStatChange;
//local XComGameState_Unit TargetUnit, SourceUnit;
//local int SourceObjectID;
//SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	//SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
	//if(SourceUnit.HasSoldierAbility('Valhalla'))