class MZ_Effect_CKHeal extends X2Effect config(MZPerkWeapons);

var bool IsCritBased;	//if critdamage should be used instead of base damage
var config int PersistHealPercent;
var localized string HealedMessage;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability Ability;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Item ItemState;
	local X2WeaponTemplate SourceWeapon;
	local int SourceObjectID, HealAmount, HealBase;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (Ability == none)
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (Ability != none && TargetUnit != none)
	{

		ItemState = Ability.GetSourceWeapon();
		if (ItemState != none)
		{
			//this healing type needs a weapon to do anything
			SourceWeapon = X2WeaponTemplate(ItemState.GetMyTemplate());
			if (SourceWeapon != none)
			{
				if (IsCritBased)
				{
					HealBase = SourceWeapon.BaseDamage.Crit;
					if ( SourceUnit.HasSoldierAbility('MZLikeAScalpel')  && SourceWeapon.WeaponCat == 'combatknife')
					{
						HealBase += class'MZKnife_AbilitySet'.default.LikeAScalpel_HealBonus;
					}
				}
				else
				{
					HealBase = SourceWeapon.BaseDamage.Damage;
				}

				if ( `SYNC_RAND(100) < SourceWeapon.BaseDamage.PlusOne )
				{
					HealBase += 1;
				}

				HealAmount = HealBase - SourceWeapon.BaseDamage.Spread +  `SYNC_RAND(SourceWeapon.BaseDamage.Spread * 2 + 1);
			}
		}

		TargetUnit.ModifyCurrentStat(eStat_HP, HealAmount);
		`TRIGGERXP('XpHealDamage', ApplyEffectParameters.SourceStateObjectRef, kNewTargetState.GetReference(), NewGameState);

		SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
		if ((SourceObjectID != TargetUnit.ObjectID) && SourceUnit.CanEarnSoldierRelationshipPoints(TargetUnit)) // pmiller - so that you can't have a relationship with yourself
		{
			SourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', SourceObjectID));
			SourceUnit.AddToSquadmateScore(TargetUnit.ObjectID, class'X2ExperienceConfig'.default.SquadmateScore_MedikitHeal);
			NewGameState.AddStateObject(SourceUnit);
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

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(BuildTrack.StateObject_OldState);
	NewUnit = XComGameState_Unit(BuildTrack.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
		
		if ( Healed > 0 )
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
			Msg = Repl(default.HealedMessage, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, 'AA_Success');
}

defaultproperties
{
	IsCritBased = false
}