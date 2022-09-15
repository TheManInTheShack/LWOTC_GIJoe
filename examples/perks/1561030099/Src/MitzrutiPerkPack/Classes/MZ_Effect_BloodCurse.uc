class MZ_Effect_BloodCurse extends X2Effect_PersistentStatChange config(MZPerkWeapons);

var config int		BloodCurse_Turns, Curse_Psi, Curse_Will;
var config name		BloodCurseSocketName, BloodCurseSocketsArrayName;
var config string	BloodCurseParticleName, BloodCursePerkName;
var config WeaponDamageValue	BloodCurseDamage;

var localized string BloodCurseFriendlyName, BloodCurseFriendlyDesc, BloodCurseEffectAcquiredString, BloodCurseEffectTickedString, BloodCurseEffectLostString, BloodCurseTitle;

DefaultProperties
{
	DamageTypes(0)="Psi"
	DuplicateResponse=eDupe_Refresh
	bCanTickEveryAction=true
	//EffectAddedFn=EffectAddedCallback
	EffectAppliedEventName="MZBloodCurseApplied"
	EffectName = "MZBloodCurse"
}

static function MZ_Effect_BloodCurse CreateBloodCurse()
{
	local MZ_Effect_BloodCurse BurningEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	BurningEffect = new class'MZ_Effect_BloodCurse';
	BurningEffect.BuildPersistentEffect(default.BloodCurse_Turns, , true, , eGameRule_PlayerTurnBegin);
	BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.BloodCurseFriendlyName, default.BloodCurseFriendlyDesc, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller", , , 'eAbilitySource_Psionic');
	BurningEffect.SetBurnDamage();
	BurningEffect.AddPersistentStatChange(eStat_Will, default.Curse_Will);
	BurningEffect.AddPersistentStatChange(eStat_PsiOffense, default.Curse_Psi);
	BurningEffect.VisualizationFn = BloodCurseVisualization;
	BurningEffect.EffectTickedVisualizationFn = BloodCurseVisualizationTicked;
	BurningEffect.EffectRemovedVisualizationFn = BloodCurseVisualizationRemoved;
	BurningEffect.bRemoveWhenTargetDies = true;
	BurningEffect.bDupeForSameSourceOnly = true;

	if (default.BloodCurseParticleName != "")
	{
		BurningEffect.VFXTemplateName = default.BloodCurseParticleName;
		BurningEffect.VFXSocket = default.BloodCurseSocketName;
		BurningEffect.VFXSocketsArrayName = default.BloodCurseSocketsArrayName;
	}
	BurningEffect.PersistentPerkName = default.BloodCursePerkName;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	BurningEffect.TargetConditions.AddItem(UnitPropCondition);

	return BurningEffect;
}

simulated function SetBurnDamage()
{
	local X2Effect_ApplyWeaponDamage BurnDamage;

	BurnDamage = new class'X2Effect_ApplyWeaponDamage';
	BurnDamage.bAllowFreeKill = false;
	BurnDamage.bIgnoreArmor = true;
	BurnDamage.bBypassSustainEffects=true;
	BurnDamage.bBypassShields= true;
	BurnDamage.EffectDamageValue = default.BloodCurseDamage;
	BurnDamage.bIgnoreBaseDamage = true;
	//BurnDamage.DamageTag = self.Name;

	ApplyOnTick.InsertItem(0, BurnDamage);
}

simulated function X2Effect_ApplyWeaponDamage GetBurnDamage()
{
	return X2Effect_ApplyWeaponDamage(ApplyOnTick[0]);
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
	local MZ_Effect_BloodCurse ExistingBloodCurseEffectTemplate;

	ExistingBloodCurseEffectTemplate = MZ_Effect_BloodCurse(ExistingEffect.GetX2Effect());
	`assert( ExistingBloodCurseEffectTemplate != None );

	if( ExistingBloodCurseEffectTemplate.GetBurnDamage().EffectDamageValue.Damage < GetBurnDamage().EffectDamageValue.Damage )
	{
		return true;
	}

	return false;
}

//Cool effect, but gets obnoxious if using more than 1 dood with curse attacks.
/*function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local int APIndex;

	// Can't do a RemoveItem, otherwise all action points of type ActionPointType will be removed at once.
	APIndex = ActionPoints.Find('standard');
	if (APIndex != INDEX_NONE)
	{
		ActionPoints.Remove(APIndex, 1);
	}
}

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		ModifyTurnStartActionPoints(UnitState, UnitState.ActionPoints, none);
	}
}*/



/////	Visualization stuff here	/////
static function BloodCurseVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
		return;
	if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	//'Acid' here is a speech cue. not sure what to use instead.
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.BloodCurseFriendlyName, 'Acid', eColor_Purple, class'UIUtilities_Image'.const.UnitStatus_Poisoned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		default.BloodCurseEffectAcquiredString,
		VisualizeGameState.GetContext(),
		default.BloodCurseTitle,
		"img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller",
		eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function BloodCurseVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (UnitState == None || UnitState.IsDead())
		return;

	class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		default.BloodCurseEffectTickedString,
		VisualizeGameState.GetContext(),
		default.BloodCurseTitle,
		"img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller",
		eUIState_Warning);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function BloodCurseVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (UnitState == None || UnitState.IsDead())
		return;

	class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		default.BloodCurseEffectLostString,
		VisualizeGameState.GetContext(),
		default.BloodCurseTitle,
		"img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller",
		eUIState_Good);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}