// This is an Unreal Script
class MZ_Effect_Zombify extends X2Effect_Persistent;

var localized string ZombifyEffectName, ZombifyEffectDesc;

defaultproperties
{
	DamageTypes(0)="Poison"
	DuplicateResponse=eDupe_Refresh
	EffectAppliedEventName="MZZombifyApplied"
}

static function MZ_Effect_Zombify CreateZombifyEffect(int Turns, optional bool Infinite = false)
{
	local MZ_Effect_Zombify			Effect;
	local X2Condition_UnitProperty	UnitCondition;

	Effect = new class'MZ_Effect_Zombify';
	Effect.BuildPersistentEffect(Turns, Infinite, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.ZombifyEffectName, default.ZombifyEffectDesc, "img:///UILibrary_XPACK_Common.PerkIcons.weakx_fearoflost", , , 'eAbilitySource_Psionic');
	//Effect.AddPersistentStatChange(eStat_SightRadius, SightRadiusPostMultMod, MODOP_PostMultiplication);
	Effect.EffectName = 'MZZombify';
	Effect.VisualizationFn = ZombifyVisualization;

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeCosmetic = true;
	UnitCondition.ExcludeCivilian = true;
	//UnitCondition.ExcludeLargeUnits= true; //not sure bout this one
	UnitCondition.ExcludeTurret = true;
	UnitCondition.ExcludeFriendlyToSource= true;
	Effect.TargetConditions.AddItem(UnitCondition);

	/*if (class'X2StatusEffects'.default.BlindedParticle_Name != "")
	{
		Effect.VFXTemplateName = class'X2StatusEffects'.default.BlindedParticle_Name;
		Effect.VFXSocket = class'X2StatusEffects'.default.BlindedSocket_Name;
		Effect.VFXSocketsArrayName = class'X2StatusEffects'.default.BlindedSocketsArray_Name;
	}*/

	return Effect;
}

static function ZombifyVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
		return;
	if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	//'Acid' here is a speech cue. not sure what to use instead.
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.ZombifyEffectName, 'Acid', eColor_Bad, "img:///UILibrary_XPACK_Common.target_lostgroup_bg");
}