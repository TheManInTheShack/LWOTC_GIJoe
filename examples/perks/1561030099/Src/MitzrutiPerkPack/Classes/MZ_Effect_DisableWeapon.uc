class MZ_Effect_DisableWeapon extends X2Effect_DisableWeapon;

var localized string FailedEffectRoll;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if( XComGameState_Unit(ActionMetadata.StateObject_NewState) != none )
	{
		if (default.HideVisualizationOfResults.Find(EffectApplyResult) != INDEX_NONE)
		{
			return;
		}

		if (EffectApplyResult == 'AA_Success' || EffectApplyResult == 'AA_UnitIsImmune' || EffectApplyResult == 'AA_EffectChanceFailed')
		{
			// No flyover if the effect just straight up fails to apply.
			// Must be a unit in order to have this occur
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

			Switch ( EffectApplyResult )
			{
				case 'AA_Success':
					SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.DisabledWeapon, '', eColor_Bad);
					break;
				case 'AA_EffectChanceFailed':
				case 'AA_UnitIsImmune':
					SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.FailedDisable, '', eColor_Good);
					break;
			}
		}
	}
}

function name RollAndCheckWeaponImmunities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState == none || WeaponState.Ammo == 0 || default.WeaponsImmuneToDisable.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE)
		{ 
			return 'AA_UnitIsImmune';	
		}

		if (WeaponState.GetMyTemplate().bInfiniteItem == True)
		{
			return 'AA_UnitIsImmune';
		}

		if (`SYNC_RAND(100) <= self.ApplyChance)
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_EffectChanceFailed';
		}
	}

	return 'AA_Failure';
}

defaultproperties
{
	ApplyChance=100
	ApplyChanceFn=RollAndCheckWeaponImmunities
}