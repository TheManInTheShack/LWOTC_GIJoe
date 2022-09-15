// This is an Unreal Script
class MZ_Effect_PsiHeal extends X2Effect config(MZPerkWeapons);

var int PerUseHP;       //  amount of HP to heal for any application of the effect
var int HealSpread;
var float PsiFactor;	// Typical psi unit has between 40 and 140 psi
var ECharStatType	UseStat;
var localized string HealedMessage;
var config int PersistHealPercent;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability Ability;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local int SourceObjectID, HealAmount;
	local XComGameStateHistory History;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;

	History = `XCOMHISTORY;
	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (Ability == none)
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (Ability != none && TargetUnit != none)
	{

		SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
		
		HealAmount = PerUseHP + (SourceUnit.GetCurrentStat(UseStat) * PsiFactor);
		HealAmount += `SYNC_RAND(HealSpread);

		ItemState = Ability.GetSourceWeapon();
		if (ItemState != none)
		{
			GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
			if (GremlinTemplate != none)
				HealAmount += GremlinTemplate.HealingBonus;
		}

		TargetUnit.ModifyCurrentStat(eStat_HP, HealAmount);
		`TRIGGERXP('XpHealDamage', ApplyEffectParameters.SourceStateObjectRef, kNewTargetState.GetReference(), NewGameState);

		
		if ((SourceObjectID != TargetUnit.ObjectID) && SourceUnit.CanEarnSoldierRelationshipPoints(TargetUnit)) // pmiller - so that you can't have a relationship with yourself
		{
			SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceObjectID));
			SourceUnit.AddToSquadmateScore(TargetUnit.ObjectID, class'X2ExperienceConfig'.default.SquadmateScore_MedikitHeal);
			TargetUnit.AddToSquadmateScore(SourceUnit.ObjectID, class'X2ExperienceConfig'.default.SquadmateScore_MedikitHeal);
		}

		if ( default.PersistHealPercent > 100 ) {
			default.PersistHealPercent = 100;
		}

		HealAmount =   int(float(HealAmount) * ( float(default.PersistHealPercent) / 100 ));

		TargetUnit.LowestHP += HealAmount;

		// sanity check, to prevent unit's hit points from growing over time
		if ( TargetUnit.LowestHP > TargetUnit.HighestHP ) {
			TargetUnit.LowestHP = TargetUnit.HighestHP;
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
		if (Healed != 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(default.HealedMessage, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}		
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}

defaultproperties
{
	UseStat = eStat_PsiOffense
}