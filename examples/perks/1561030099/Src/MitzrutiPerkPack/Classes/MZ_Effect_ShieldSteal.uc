class MZ_Effect_ShieldSteal extends X2Effect;

var float				LowHealthVamp, FlatVamp;
var bool				b, Flyover;

var localized string	HealedMessage, AbyssalMessage;

defaultproperties
{
	LowHealthVamp = 0.0
	FlatVamp = 100.0
	Flyover = true
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability		Ability;
	local XComGameState_Unit		TargetUnit, OldTargetUnit, SourceUnit;
	local int						SourceObjectID;
	local XComGameStateHistory		History;
	local int						LifeAmount;
	local float				LifeAmountMultiplier;

	History = `XCOMHISTORY;

	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if( Ability == none )
	{
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	}

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if( (Ability != none) && (TargetUnit != none) )
	{
		SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
		OldTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));
		
		if( (SourceUnit != none) && (OldTargetUnit != none) )
		{
			b = true;
			//calculate the lifesteal multiplier
			LifeAmountMultiplier = ((LowHealthVamp * SourceUnit.GetCurrentStat(eStat_HP) / SourceUnit.GetMaxStat(eStat_HP)) + FlatVamp)/100;

			/*
			If (SourceUnit.HasSoldierAbility('MZAbyssalHunger'))
			{
				LifeAmountMultiplier = LifeAmountMultiplier * class'MZBloodMagic_AbilitySet'.default.AbyssalHunger_VampBonus;
			}
			*/

			if( LifeAmountMultiplier != 0.0f )
			{
				LifeAmount = Round(LifeAmountMultiplier * (OldTargetUnit.GetCurrentStat(eStat_HP) - TargetUnit.GetCurrentStat(eStat_HP)));
			}

			SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceObjectID));
			SourceUnit.ModifyCurrentStat(eStat_ShieldHP,LifeAmount);
		}
	}
}

simulated function AddX2ActionsForVisualizationSource(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	if (EffectApplyResult != 'AA_Success')
		return;

	if ( b && Flyover )
	{
		b = false;

		// Grab the current and previous gatekeeper unit and check if it has been healed
		OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
		NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

		Healed = NewUnit.GetCurrentStat(eStat_ShieldHP) - OldUnit.GetCurrentStat(eStat_ShieldHP);
	
		if( Healed > 0 )
		{
			/*
			if( OldUnit.HasSoldierAbility('MZAbyssalHunger') )
			{
				Msg = Repl(default.AbyssalMessage, "<Heal/>", Healed);
			}
			else
			{
			*/
				Msg = Repl(default.HealedMessage, "<Heal/>", Healed);	
			//}
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
	}
}