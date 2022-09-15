class MZCryoshot_AbilitySet extends X2Ability config(MZCryoPerkPack);

var config int FrostBullet_Charges, FrostBullet_Cooldown, FrostBulletX_DoT_Duration, BulletBleed_Damage, BulletBleed_Turns, Shiver_Chance, ShiverOnCrit_Chance, ShiverSuppress_Chance, ShatterShot_Cooldown, FreezingSpear_Charges, FreezingSpear_Cooldown, IcyBurst_Cooldown;
var config float ExplosiveArts_Radius, ShatterShot_Radius, FrostRuneshot_BonusDamage, FrostFusil_BonusDamage;

var config array<name> SUPPRESSION_SKILLS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FrostBullet());
	Templates.AddItem(FrostBulletX());
	Templates.AddItem(Shiver());
	/*>>>*/Templates.AddItem(ApplyShiver());
	Templates.AddItem(ShiverOnCrit());
	Templates.AddItem(ShiverSuppress());
	Templates.AddItem(ShatterShot());
	Templates.AddItem(FreezingSpear());
	Templates.AddItem(IcyBurst());
	/*>>>*/Templates.AddItem(IcyBurst2());

	Templates.AddItem(FrostRuneshot());
	Templates.AddItem(FrostFusil());

	return Templates;
}

static function X2AbilityTemplate Add_MZNonStandardShot( Name AbilityName='MZNonStandardShot', string IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard", bool DontShowInPerkList = false, bool bNoAmmoCost = false, bool bAllowBurning = true, bool bAllowDisoriented = false)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            VisibilityCondition;
	local X2AbilityToHitCalc_StandardAim	AimType;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = DontShowInPerkList;
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = 380;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (bAllowDisoriented)
		SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	if (bAllowBurning)
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	if( !bNoAmmoCost )
	{
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = false;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//note: the goal with this is a standard shot that DOES NOT HAVE any target effects. they'll hve to be added by the effect that creates them.

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	//Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	//Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	//Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	//Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	AimType = new class'X2AbilityToHitCalc_StandardAim';
	AimType.bOnlyMultiHitWithSuccess = true;
	Template.AbilityToHitCalc = AimType;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.PostActivationEvents.AddItem('StandardShotActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//not currently using for anything valid to headshot with.
	// Template.AlternateFriendlyNameFn = class'X2Ability_WeaponCommon'.static.StandardShot_AlternateFriendlyName;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;	
}

static function X2AbilityTemplate FrostBullet() {
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius		TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Effect_Persistent				BleedingEffect;
	local X2Effect_ManualOverride			ChronoEffect;
	local MZ_Effect_Hypothermia				HypothermiaEffect;

	Template = Add_MZNonStandardShot('MZFrostBullet', "img:///UILibrary_MPP.icestar");
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.FrostBullet_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FrostBullet_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);
	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

	HypothermiaEffect = class'MZ_Effect_Hypothermia'.static.CreateHypothermiaEffect(default.FrostBulletX_DoT_Duration);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFrostBulletX');
	HypothermiaEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(HypothermiaEffect);
	Template.AddMultiTargetEffect(HypothermiaEffect);

	//ChronoTrigger causes all skills to recharge.
	ChronoEffect = new class'X2Effect_ManualOverride';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZChronoTrigger');
	ChronoEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(ChronoEffect);

	//Bleeding Arts effect
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(BleedingEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZBleedingBulletArts');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BulletBleed_Turns, default.BulletBleed_Damage);
	BleedingEffect.DuplicateResponse = eDupe_Allow;
	BleedingEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(BleedingEffect);
	
	//Explosive Arts AOE effect
	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = 0.1;
	TargetStyle.bIgnoreBlockingCover = true;
	TargetStyle.AddAbilityBonusRadius('MZExplosiveBulletArts', default.ExplosiveArts_Radius);
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(KnockbackEffect);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	//More Daka bonus hit
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMoreDakka');
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZExplosiveBulletArts');
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Frost';
	WeaponDamageEffect.DamageTypes.Length=0;
	WeaponDamageEffect.DamageTypes.AddItem('Frost');
	WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	

	return Template;
}
static function X2AbilityTemplate FrostBulletX() {
	local X2AbilityTemplate					Template;

	Template = PurePassive('MZFrostBulletX', "img:///UILibrary_MPP.icestar");
	Template.PrerequisiteAbilities.AddItem('MZFrostBullet');

	return Template;
}

//Slightly modified variant on Iridar's Singe Ability
static function X2AbilityTemplate Shiver()
{
	local X2AbilityTemplate	Template;
	local MZ_Effect_Shiver	SingeEffect;

	Template = PurePassive('MZShiver', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");

	SingeEffect = new class'MZ_Effect_Shiver';
	SingeEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(SingeEffect);

	Template.AdditionalAbilities.AddItem('MZApplyShiver');

	return Template;
}
static function X2AbilityTemplate ApplyShiver()
{
	local X2AbilityTemplate					Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZApplyShiver');

	Template.IconImage = "img:///UILibrary_DLC2Images.UIPerk_freezingbreath";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//	Singe is triggered by an Event Listener registered in X2Effect_Singe
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = Shiver_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	return Template;
}

//variant that only works on crits.
static function X2AbilityTemplate ShiverOnCrit()
{
	local X2AbilityTemplate			Template;
	local MZ_Effect_ShiverOnCrit	SingeEffect;

	Template = PurePassive('MZShiverOnCrit', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");

	SingeEffect = new class'MZ_Effect_ShiverOnCrit';
	SingeEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(SingeEffect);

	Template.AdditionalAbilities.AddItem('MZApplyShiver');

	return Template;
}

static function X2AbilityTemplate ShiverSuppress()
{
	local X2AbilityTemplate			Template;
	local MZ_Effect_ShiverSuppress	SingeEffect;

	Template = PurePassive('MZShiverSuppress', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");

	SingeEffect = new class'MZ_Effect_ShiverSuppress';
	SingeEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(SingeEffect);

	Template.AdditionalAbilities.AddItem('MZApplyShiver');

	return Template;
}

// Merge the Singe Vis Tree with Triggering Shot Vis Tree
function Shiver_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local array<X2Action>					arrActions;
	local X2Action_MarkerTreeInsertBegin	MarkerStart;
	local X2Action_MarkerTreeInsertEnd		MarkerEnd;
	local X2Action							WaitAction;
	local X2Action_MarkerNamed				MarkerAction;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local bool bFoundHistoryIndex;
	local int i;

	/* This is very much iridar's stuff. idk much about viz.*/

	VisMgr = `XCOMVISUALIZATIONMGR;
	
	// Find the start of the Singe's Vis Tree
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	AbilityContext = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	//	Find all Fire Actions in the Triggering Shot's Vis Tree
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', arrActions);

	//	Cycle through all of them to find the Fire Action we need, which will have the same History Index as specified in Singe's Context, which gets set in the Event Listener
	for (i = 0; i < arrActions.Length; i++)
	{
		if (arrActions[i].StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			bFoundHistoryIndex = true;
			break;
		}
	}
	//	If we didn't find the correct action, we call the failsafe Merge Vis Function, which will make both Singe's Target Effects apply seperately after the ability finishes.
	//	Looks bad, but at least nothing is broken.
	if (!bFoundHistoryIndex)
	{
		AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
		return;
	}

	//`LOG("Num of Fire Actions: " @ arrActions.Length,, 'IRISINGE');

	//	Add a Wait For Effect Action after the Triggering Shot's Fire Action. This will allow Singe's Effects to visualize the moment the Triggering Shot connects with the target.
	AbilityContext = XComGameStateContext_Ability(arrActions[i].StateChangeContext);
	ActionMetaData = arrActions[i].Metadata;
	WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext,, arrActions[i]);

	//	Insert the Singe's Vis Tree right after the Wait For Effect Action
	VisMgr.ConnectAction(MarkerStart, VisualizationTree,, WaitAction);

	//	Main part of Merge Vis is done, now we just tidy up the ending part. As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
	//	which tbh sounds like a super edge case, but okay
	//	Find all marker actions in the Triggering Shot Vis Tree.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

	//	Cycle through them and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
	for (i = 0; i < arrActions.Length; i++)
	{
		MarkerAction = X2Action_MarkerNamed(arrActions[i]);

		if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			//	Grab the last Action in the Singe Vis Tree
			MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

			//	TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
			if (MarkerEnd != none)
			{
				//	"tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are not fully visualized.
				VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
			}
			else
			{
				//	not sure what this does
				VisMgr.GetAllLeafNodes(BuildTree, arrActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,,, arrActions);
			}

			//VisMgr.ConnectAction(MarkerAction, VisualizationTree,, MarkerEnd);
			break;
		}
	}
}

static function EventListenerReturn AbilityTriggerEventListener_Shiver(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Ability			AbilityState, SlagAbilityState;
	local XComGameState_Unit			SourceUnit, TargetUnit;
	local XComGameStateContext			FindContext;
    local int							VisualizeIndex;
	local XComGameStateHistory			History;
	local X2AbilityTemplate				AbilityTemplate;
	local X2Effect						Effect;
	local bool bDealsDamage;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener
	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find Singe ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('MZApplyShiver', AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none &&  AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			//	check if the ability deals damage
			if ( TargetUnit != none && TargetUnit.IsAlive() && AbilityContext.IsResultContextHit())
			{
				foreach AbilityTemplate.AbilityTargetEffects(Effect)
				{
					if (X2Effect_ApplyWeaponDamage(Effect) != none)
					{
						bDealsDamage = true;
						break;
					}
				}
				if (bDealsDamage)
				{
					// Triggering ability if it passes a chance check
					if (`SYNC_RAND_STATIC(100) < default.Shiver_Chance)
					{
						//	pass the Visualize Index to the Context for later use by Merge Vis Fn
						VisualizeIndex = GameState.HistoryIndex;
						FindContext = AbilityContext;
						while (FindContext.InterruptionHistoryIndex > -1)
						{
							FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
							VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
						}
						//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
						SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
					}
				}
			}

			bDealsDamage = false;
			foreach AbilityTemplate.AbilityMultiTargetEffects(Effect)
			{
				if (X2Effect_ApplyWeaponDamage(Effect) != none)
				{
					bDealsDamage = true;
					break;
				}
			}
			if ( bDealsDamage )
			{
				i = AbilityContext.ResultContext.MultiTargetHitResults.Length;
				for ( i = 0; i <= AbilityContext.InputContext.MultiTargets.Length; i++ )
				{
					TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i-1].ObjectID));
					if ( TargetUnit != none && TargetUnit.IsAlive() && ( AbilityContext.ResultContext.MultiTargetHitResults[i-1] == eHit_Crit || AbilityContext.ResultContext.MultiTargetHitResults[i-1] == eHit_Success ) )
					{
						// Triggering ability if it passes a chance check
						if (`SYNC_RAND_STATIC(100) < default.Shiver_Chance)
						{
							//	pass the Visualize Index to the Context for later use by Merge Vis Fn
							VisualizeIndex = GameState.HistoryIndex;
							FindContext = AbilityContext;
							while (FindContext.InterruptionHistoryIndex > -1)
							{
								FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
								VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
							}
							//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
							SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[i-1], false, VisualizeIndex);
						}
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_ShiverOnCrit(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Ability			AbilityState, SlagAbilityState;
	local XComGameState_Unit			SourceUnit, TargetUnit;
	local XComGameStateContext			FindContext;
    local int							VisualizeIndex;
	local XComGameStateHistory			History;
	local X2AbilityTemplate				AbilityTemplate;
	local X2Effect						Effect;
	local bool bDealsDamage;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener
	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find Singe ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('MZApplyShiver', AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none &&  AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			//	check if the ability deals damage
			if ( TargetUnit != none && TargetUnit.IsAlive() && AbilityContext.ResultContext.HitResult == eHit_Crit)
			{
				foreach AbilityTemplate.AbilityTargetEffects(Effect)
				{
					if (X2Effect_ApplyWeaponDamage(Effect) != none)
					{
						bDealsDamage = true;
						break;
					}
				}
				if (bDealsDamage)
				{
					// Triggering ability if it passes a chance check
					if (`SYNC_RAND_STATIC(100) < default.ShiverOnCrit_Chance)
					{
						//	pass the Visualize Index to the Context for later use by Merge Vis Fn
						VisualizeIndex = GameState.HistoryIndex;
						FindContext = AbilityContext;
						while (FindContext.InterruptionHistoryIndex > -1)
						{
							FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
							VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
						}
						//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
						SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
					}
				}
			}

			bDealsDamage = false;
			foreach AbilityTemplate.AbilityMultiTargetEffects(Effect)
			{
				if (X2Effect_ApplyWeaponDamage(Effect) != none)
				{
					bDealsDamage = true;
					break;
				}
			}
			if ( bDealsDamage )
			{
				i = AbilityContext.ResultContext.MultiTargetHitResults.Length;
				for ( i = 0; i <= AbilityContext.InputContext.MultiTargets.Length; i++ )
				{
					TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i-1].ObjectID));
					if ( TargetUnit != none && TargetUnit.IsAlive() && ( AbilityContext.ResultContext.MultiTargetHitResults[i-1] == eHit_Crit) )
					{
						// Triggering ability if it passes a chance check
						if (`SYNC_RAND_STATIC(100) < default.ShiverOnCrit_Chance)
						{
							//	pass the Visualize Index to the Context for later use by Merge Vis Fn
							VisualizeIndex = GameState.HistoryIndex;
							FindContext = AbilityContext;
							while (FindContext.InterruptionHistoryIndex > -1)
							{
								FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
								VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
							}
							//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
							SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[i-1], false, VisualizeIndex);
						}
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_ShiverSuppress(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Ability			AbilityState, SlagAbilityState;
	local XComGameState_Unit			SourceUnit, TargetUnit;
	local XComGameStateContext			FindContext;
    local int							VisualizeIndex;
	local XComGameStateHistory			History;
	local X2AbilityTemplate				AbilityTemplate;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener

	if ( default.SUPPRESSION_SKILLS.Find( AbilityState.GetMyTemplateName() ) == INDEX_NONE ){ return ELR_NoInterrupt;	}

	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find Singe ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('MZApplyShiver', AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none &&  AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			//	check if the ability hit
			if ( TargetUnit != none && TargetUnit.IsAlive() && AbilityContext.IsResultContextHit() && AbilityTemplate.AbilityTargetEffects.Length > 0)
			{
				// Triggering ability if it passes a chance check
				if (`SYNC_RAND_STATIC(100) < default.ShiverSuppress_Chance)
				{
					//	pass the Visualize Index to the Context for later use by Merge Vis Fn
					VisualizeIndex = GameState.HistoryIndex;
					FindContext = AbilityContext;
					while (FindContext.InterruptionHistoryIndex > -1)
					{
						FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
						VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
					}
					//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
					SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
				}
			}

			if ( AbilityTemplate.AbilityMultiTargetEffects.Length > 0 )
			{
				i = AbilityContext.ResultContext.MultiTargetHitResults.Length;
				for ( i = 0; i <= AbilityContext.InputContext.MultiTargets.Length; i++ )
				{
					TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i-1].ObjectID));
					if ( TargetUnit != none && TargetUnit.IsAlive() && ( AbilityContext.ResultContext.MultiTargetHitResults[i-1] == eHit_Success || AbilityContext.ResultContext.MultiTargetHitResults[i-1] == eHit_Crit) )
					{
						// Triggering ability if it passes a chance check
						if (`SYNC_RAND_STATIC(100) < default.ShiverSuppress_Chance)
						{
							//	pass the Visualize Index to the Context for later use by Merge Vis Fn
							VisualizeIndex = GameState.HistoryIndex;
							FindContext = AbilityContext;
							while (FindContext.InterruptionHistoryIndex > -1)
							{
								FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
								VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
							}
							//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
							SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[i-1], false, VisualizeIndex);
						}
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function X2AbilityTemplate ShatterShot()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityMultiTarget_Radius			TargetStyle;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local X2Condition_UnitEffects			ChillDegreeCondition;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2Condition_Visibility			VisibilityCondition;

	Template = Add_MZNonStandardShot('MZShatterShot', "img:///UILibrary_MPP.Shatter");
	Template.bDontDisplayInAbilitySummary = false;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bGuaranteedHit = true;
	StandardMelee.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardMelee;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ShatterShot_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Radius';
	TargetStyle.fTargetRadius = default.ShatterShot_Radius;
	TargetStyle.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = TargetStyle;

	// Targeting Details
	Template.AbilityTargetConditions.Length = 0;
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('frost');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	ChillDegreeCondition = new class'X2Condition_UnitEffects';
	ChillDegreeCondition.AddRequireEffect('Freeze', 'AA_MissingRequiredEffect'); // name effect, name reason
	Template.AbilityTargetConditions.AddItem(ChillDegreeCondition);

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'frost';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);
	Template.AddTargetEffect(class'BitterfrostHelper'.static.UnChillEffect());

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	return Template;
}

static function X2AbilityTemplate FreezingSpear()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityToHitCalc_StandardAim	StandardMelee;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line			TargetStyle;

	Template = Add_MZNonStandardShot('MZFreezingSpear', "img:///UILibrary_MPP.icearrow");
	Template.bDontDisplayInAbilitySummary = false;

	StandardMelee = new class'X2AbilityToHitCalc_StandardAim';
	StandardMelee.bIgnoreCoverBonus = true;
	Template.AbilityToHitCalc = StandardMelee;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FreezingSpear_Cooldown;
	Template.AbilityCooldown = Cooldown;

	if ( default.FreezingSpear_Charges > 0 )
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.FreezingSpear_Charges;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	TargetStyle = new class'X2AbilityMultiTarget_Line';
	TargetStyle.bSightRangeLimited = true;				//seems to be possible to make it draw past your sight range, but doesn't actually target them?
	Template.AbilityMultiTargetStyle = TargetStyle;

	Template.TargetingMethod = class'X2TargetingMethod_Line';

	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'frost';
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);

	return Template;
}

static function X2AbilityTemplate IcyBurst()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZIcyBurst');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//  require 3 ammo to be present so that both shots can be taken
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	//  actually charge 2 ammo for this shot. the 2nd shot will charge the extra ammo.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.IcyBurst_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//ToHitCalc.BuiltInHitMod = default.RAPIDFIRE_AIM;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('frost');
	UnitImmunityCondition.bOnlyOnCharacterTemplate=false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'frost';
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	Template.bAllowAmmoEffects = false;
	Template.bAllowBonusWeaponEffects = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MPP.snowflaketension";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('MZIcyBurst2');
	Template.PostActivationEvents.AddItem('MZIcyBurst2');

	Template.DamagePreviewFn = IcyBurstDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RapidFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'RapidFire'

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}
function bool IcyBurstDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference ChainShot2Ref;
	local XComGameState_Ability ChainShot2Ability;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	ChainShot2Ref = AbilityOwner.FindAbility('MZIcyBurst2');
	ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
	if (ChainShot2Ability != none)
	{
		ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}
	return true;
}
static function X2AbilityTemplate IcyBurst2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZIcyBurst2');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//ToHitCalc.BuiltInHitMod = default.RAPIDFIRE_AIM;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	WeaponDamageEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	WeaponDamageEffect.EffectDamageValue.DamageType = 'frost';
	WeaponDamageEffect.DamageTypes.AddItem('frost');
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	Template.bAllowAmmoEffects = false;
	Template.bAllowBonusWeaponEffects = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'MZIcyBurst2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MPP.snowflaketension";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RapidFire2'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'RapidFire2'

	return Template;
}

static function X2AbilityTemplate FrostRuneshot()
{
	local X2AbilityTemplate						Template;
	local MZ_Damage_AddElemental		WeaponDamageEffect;

	Template = Add_MZNonStandardShot('MZFrostRuneshot', "img:///UILibrary_MPP.icestar");
	Template.bDontDisplayInAbilitySummary = false;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Frost';
	WeaponDamageEffect.BonusDamageScalar = default.FrostRuneshot_BonusDamage;
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	return Template;
}

static function X2AbilityTemplate FrostFusil()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local MZ_Damage_AddElemental		WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	//local X2Effect_Knockback				KnockbackEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFrostFusil');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_MPP.icestar";
	Template.ShotHUDPriority = 320; //class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	//SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MZQuickFusil');
	ActionPointCost.AllowedTypes.AddItem('GrimyGunpoint');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);	

	WeaponDamageEffect = new class'MZ_Damage_AddElemental';
	WeaponDamageEffect.Element = 'Frost';
	WeaponDamageEffect.BonusDamageScalar = default.FrostFusil_BonusDamage;
	WeaponDamageEffect.bNoShredder = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	//KnockbackEffect = new class'X2Effect_Knockback';
	//KnockbackEffect.KnockbackDistance = 2;
	//Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'PistolStandardShot'

	return Template;	
}