class MZ_Effect_VoidPrison extends X2Effect_Persistent;

var int InitialDamage;
var privatewrite name VoidConduitActionsLeft, StolenActionsThisTick;

var int StunActions, ScaleStunWithWeaponTier;
//var bool b;

var localized string FailedText, FailedImmune;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit, SourceUnit;
	local X2WeaponTemplate SourceWeapon;
	local int Focus;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	if ( InitialDamage != 0 )
	{
		TargetUnit.TakeEffectDamage(self, InitialDamage, 0, 0, ApplyEffectParameters, NewGameState);
	}

	//	get the previous version of the source unit to record the correct focus level
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID, , NewGameState.HistoryIndex - 1));
	`assert(SourceUnit != none);

	Focus = StunActions;

	if ( ScaleStunWithWeaponTier > 0 )
	{
		SourceWeapon = X2WeaponTemplate(XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID, , NewGameState.HistoryIndex - 1)).GetMyTemplate());
		Switch ( SourceWeapon.WeaponTech )
		{
			case 'beam':
				Focus += 2*ScaleStunWithWeaponTier;
			case 'magnetic':
				Focus += ScaleStunWithWeaponTier;
		}
	}

	TargetUnit.SetUnitFloatValue(VoidConduitActionsLeft, Focus, eCleanup_BeginTactical);
	TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 1);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( TargetUnit != None )
	{
		TargetUnit.ClearUnitValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName);
	}
}

function bool TickVoidConduit(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue ConduitValue;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	`assert(TargetUnit != none);

	TargetUnit.GetUnitValue(VoidConduitActionsLeft, ConduitValue);
	return ConduitValue.fValue <= 0;
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue ActionsValue;
	local int Limit;

	UnitState.GetUnitValue(StolenActionsThisTick, ActionsValue);
	Limit = ActionsValue.fValue;

	if (Limit > ActionPoints.Length)
	{
		//`RedScreen("MZVoidPrison thought it restricted" @ Limit @ "actions, but the unit only has" @ ActionPoints.Length @ "this turn -- oops. @gameplay");
		ActionPoints.Length = 0;
	}
	else
	{
		ActionPoints.Remove(0, Limit);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_PlayAnimation PlayAnimation;
	local X2Action_ApplyWeaponDamageToUnit DamageAction;
	local XGUnit Unit;
	local XComUnitPawn UnitPawn;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if( EffectApplyResult == 'AA_Success' )
	{
		Unit = XGUnit(ActionMetadata.VisualizeActor);
		if( Unit != None )
		{
			UnitPawn = Unit.GetPawn();
			if( UnitPawn != None && UnitPawn.GetAnimTreeController().CanPlayAnimation('HL_VoidConduitTarget_Start') )
			{
				// Play the start stun animation
				PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				PlayAnimation.Params.AnimName = 'HL_VoidConduitTarget_Start';
				PlayAnimation.bResetWeaponsToDefaultSockets = true;
			}
		}

		super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);

		if ( InitialDamage != 0 )
		{
			DamageAction = X2Action_ApplyWeaponDamageToUnit(class'X2Action_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			DamageAction.OriginatingEffect = self;
		}
	}
	else
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		if( EffectApplyResult == 'AA_UnitIsImmune')
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.FailedImmune, '', eColor_Good);
		}
		else
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.FailedText, '', eColor_Good);
		}
		super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
	}
}

simulated function AddX2ActionsForVisualization_Sync(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	//We assume 'AA_Success', because otherwise the effect wouldn't be here (on load) to get sync'd
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}

simulated private function AddX2ActionsForVisualization_Removed_Internal(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlayAnimation PlayAnimation;
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if( TargetUnit.IsAlive() && !TargetUnit.IsIncapacitated() ) //Don't play the animation if the unit is going straight to killed
	{
		// The unit is not a turret and is not dead/unconscious/bleeding-out
		PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		PlayAnimation.Params.AnimName = 'HL_VoidConduitTarget_End';
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	AddX2ActionsForVisualization_Removed_Internal(VisualizeGameState, ActionMetadata, EffectApplyResult);
}

function bool AllowDodge(XComGameState_Unit Attacker, XComGameState_Ability AbilityState) { return false; }

DefaultProperties
{
	EffectName = "VoidConduit"
	DuplicateResponse = eDupe_Ignore
	bIsImpairing = true
	VoidConduitActionsLeft = "VoidConduitActionsLeft"
	StolenActionsThisTick = "StolenActionsThisTick"
	EffectTickedFn = TickVoidConduit
	DamageTypes(0) = "Psi"
	bCanTickEveryAction = true
	CustomIdleOverrideAnim = "HL_VoidConduitTarget_Loop"
}