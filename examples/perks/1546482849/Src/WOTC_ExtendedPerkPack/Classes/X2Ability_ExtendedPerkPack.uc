class X2Ability_ExtendedPerkPack extends XMBAbility config (ExtendedPerkPack);

var config int CHIPAWAY_SHRED_CV;
var config int CHIPAWAY_SHRED_LS;
var config int CHIPAWAY_SHRED_MG;
var config int CHIPAWAY_SHRED_CL;
var config int CHIPAWAY_SHRED_BM;
var config int CHIPAWAY_COOLDOWN;
var config int CHIPAWAY_AMMO_COST;
var config bool CHIPAWAY_AWC;
var config bool CONCENTRATION_AWC;
var config bool LIKELIGHTNING_AWC;
var config int STATIONARYTHREAT_DAMAGE_PER_TURN;
var config int STATIONARYTHREAT_DAMAGE_MAX_TURNS;
var config bool STATIONARYTHREAT_AWC;
var config bool OPPORTUNIST_AWC;
var config int MAIM_AMMO_COST;
var config int MAIM_COOLDOWN;
var config int MAIM_DURATION;
var config bool MAIM_AWC;
var config array<name> QUICKPATCH_ABILITIES;
var config bool QUICKPATCH_AWC;
var config int PRESERVATION_DEFENSE_BONUS;
var config int PRESERVATION_DURATION;
var config bool PRESERVATION_AWC;
var config int LICKYOURWOUNDS_HEALAMOUNT;
var config int LICKYOURWOUNDS_MAXHEALAMOUNT;
var config bool LICKYOURWOUNDS_AWC;
var config int MOMENTUM_AIM_BONUS;
var config int MOMENTUM_CRIT_BONUS;
var config bool MOMENTUM_AWC;
var config int THOUSANDSTOGO_ACTIVATIONS_PER_TURN;
var config bool THOUSANDSTOGO_AWC;
var config int RECHARGE_COOLDOWN_AMOUNT;
var config bool RECHARGE_AWC;
var config int PIERCETHEVEIL_AIM_BONUS;
var config int PIERCETHEVEIL_DAMAGE_BONUS;
var config int PIERCETHEVEIL_ARMOR_PIERCING;
var config int PIERCETHEVEIL_INCREASE_COOLDOWN_AMOUNT;
var config int PIERCETHEVEIL_COOLDOWN;
var config bool PIERCETHEVEIL_AWC;
var config int THEBIGGERTHEYARE_AIM_BONUS;
var config bool THEBIGGERTHEYARE_AWC;
var config int CALLFORFIRE_RADIUS;
var config int CALLFORFIRE_COOLDOWN;
var config bool CALLFORFIRE_AWC;
var config int LOCKNLOAD_AMMO_TO_RELOAD;
var config bool LOCKNLOAD_AWC;
var config int IMPOSITION_DURATION;
var config int IMPOSITION_AIM_PENALTY;
var config bool IMPOSITION_AWC;
var config bool TRENCHWARFARE_AWC;
var config bool COMPENSATION_AWC;
var config int FIRSTSTRIKE_CONCEALED_DAMAGE_BONUS;
var config int FIRSTSTRIKE_FLANKING_DAMAGE_BONUS;
var config bool FIRSTSTRIKE_AWC;
var config int DISABLINGSHOT_STUN_ACTIONS;
var config int DISABLINGSHOT_AMMO_COST;
var config int DISABLINGSHOT_COOLDOWN;
var config bool DISABLINGSHOT_AWC;
var config int BLEND_TURNS_CONCEALED;
var config bool BLEND_AWC;
var config int BOTNET_HACK_DEFENSE_PENALTY;
var config int BOTNET_COOLDOWN;
var config bool BOTNET_AWC;
var config bool READYFORANYTHING_AWC;
var config int RESUPPLY_AMMO_TO_RELOAD;
var config int RESUPPLY_CHARGES;
var config bool RESUPPLY_AWC;
var config int IMMUNIZE_CHARGES;
var config bool IMMUNIZE_AWC;
var config bool RUSH_AWC;
var config int AMMOCONSERVATION_COOLDOWN;
var config bool AMMOCONSERVATION_APPLIES_TO_SECONDARIES;
var config bool AMMOCONSERVATION_AWC;
var config bool WELLPROTECTED_AWC;
var config int DEDICATION_MOBILITY;
var config int DEDICATION_COOLDOWN;
var config bool DEDICATION_AWC;
var config int TRIAGE_RADIUS;
var config int TRIAGE_HEAL_AMOUNT;
var config int TRIAGE_CHARGES;
var config bool TRIAGE_AWC;
var config bool STEADFAST_AWC;
var config bool CORPSMAN_AWC;
var config int FIELDMEDIC_BONUS_ITEMS;
var config bool FIELDMEDIC_AWC;
var config int STIMULATE_RANGE_IN_TILES;
var config bool STIMULATE_AWC;
var config int BLOODLET_DURATION;
var config int BLOODLET_TICK_DAMAGE;
var config int BLOODLET_BLEEDING_CHANCE_PERCENT;
var config bool BLOODLET_AWC;
var config int BLINDINGFIRE_AMMO_COST;
var config int BLINDINGFIRE_COOLDOWN;
var config int BLINDINGFIRE_CONE_TILE_WIDTH;
var config int BLINDINGFIRE_CONE_LENGTH;
var config int BLINDINGFIRE_SOURCE_AIM_PENALTY;
var config int BLINDINGFIRE_TARGET_AIM_PENALTY;
var config bool BLINDINGFIRE_AWC;
var config bool QUICKFEET_AWC;
var config int COMBATDRUGS_AIM;
var config int COMBATDRUGS_CRIT;
var config bool COMBATDRUGS_AWC;
var config int SALTINTHEWOUND_DAMAGE_BONUS;
var config bool SALTINTHEWOUND_AWC;
var config int UNLOAD_AIM_BONUS;
var config bool UNLOAD_ALLOW_CRIT;
var config int UNLOAD_COOLDOWN;
var config int UNLOAD_DAMAGE_PERCENT_MALUS;
var config bool UNLOAD_AWC;
var config int AMBUSH_COOLDOWN;
var config bool AMBUSH_AWC;
var config int RENEWAL_HEALAMOUNT;
var config int RENEWAL_MAXHEALAMOUNT;
var config int RENEWAL_RADIUS;
var config bool RENEWAL_AWC;
var config int WARNINGSHOT_AMMO_COST;
var config int WARNINGSHOT_CHARGES;
var config bool WARNINGSHOT_AWC;
var config int OPENFIRE_AIM;
var config int OPENFIRE_CRIT;
var config bool OPENFIRE_AWC;
var config array<int> HAVOC_DAMAGE;
var config array<name> HAVOC_WEAPON_TECH;
var config bool HAVOC_AWC;
var config bool FINESSE_AWC;
var config int SHOULDERTOLEANON_RADIUS;
var config int SHOULDERTOLEANON_AIM_BONUS;
var config int SHOULDERTOLEANON_AIM_BONUS_WITH_SHIELDWALL;
var config bool SHOULDERTOLEANON_AWC;
var config int BOLSTEREDWALL_DODGE_BONUS;
var config bool BOLSTEREDWALL_AWC;
var config bool PROTECTANDSERVE_AWC;
var config bool FAULTLESSDEFENSE_AWC;
var config int ADRENALINE_SHIELD;
var config int ADRENALINE_ACTIVATIONS_PER_MISSION;
var config bool ADRENALINE_AWC;
var config int WATCHTHEMRUN_ACTIVATIONS_PER_TURN;
var config bool WATCHTHEMRUN_AWC;
var config float COVERAREA_EXPLOSIVE_DAMAGE_REDUCTION;
var config int COVERAREA_RADIUS;
var config bool COVERAREA_AWC;
var config float RALLY_RADIUS;
var config int RALLY_CHARGES;
var config int RALLY_SHIELD_CV;
var config int RALLY_SHIELD_MG;
var config int RALLY_SHIELD_BM;
var config int AVENGER_RADIUS;
var config int FLATLINE_RUPTURE;
var config int FLATLINE_AMMO_COST;
var config int FLATLINE_COOLDOWN;
var config int FLATLINE_DAMAGE_BONUS;
var config bool FLATLINE_AWC;
var config bool COLDBLOODED_AWC;
var config int PREDATOR_AIM_BONUS;
var config int PREDATOR_CRIT_BONUS;
var config bool PREDATOR_AWC;
var config bool SURVIVOR_AWC;
var config int REGENERATIVEMIST_HEAL_PER_TURN;
var config int REGENERATIVEMIST_MAX_HEAL_AMOUNT;
var config bool REGENERATIVEMIST_AWC;
var config bool CONTROLLEDFIRE_AWC;
var config int STILETTO_ARMOR_PIERCING;
var config bool STILETTO_AWC;
var config int STAYCOVERED_DEFENSE_BONUS;
var config int STAYCOVERED_DODGE_BONUS;
var config bool STAYCOVERED_AWC;
var config int INDOMITABLE_CHARGES;
var config bool INDOMITABLE_AWC;
var config int PERFECTGUARD_ARMOR_BONUS;
var config bool PERFECTGUARD_AWC;
var config int SHIELDREGENERATION_SHIELD;
var config int SHIELDREGENERATION_SHIELD_MAX;
var config bool SHIELDREGENERATION_AWC;
var config int CALMMIND_PSI;
var config int CALMMIND_WILL;
var config bool CALMMIND_AWC;
var config bool SUPPRESSINGFIRE_AWC;
var config int PUTEMDOWN_AIM;
var config bool PUTEMDOWN_AWC;
var config int WILLTOSURVIVE_ARMOR;
var config int WILLTOSURVIVE_DODGE;
var config bool WILLTOSURVIVE_AWC;
var config bool WATCHFULEYE_AWC;
var config int GUARD_COOLDOWN;
var config bool GUARD_AWC;
var config int SAFEGUARD_RADIUS;
var config int SAFEGUARD_AIM_MODIFIER;
var config int SAFEGUARD_AIM_MODIFIER_WITH_SHIELDWALL;
var config bool SAFEGUARD_AWC;
var config int TRADEFIRE_COOLDOWN;
var config bool TRADEFIRE_AWC;
var config int INTIMIDATE_TIER1_STRENGTH;
var config int INTIMIDATE_TIER2_STRENGTH;
var config int INTIMIDATE_TIER3_STRENGTH;
var config bool INTIMIDATE_AWC;
var config float RAMPART_DAMAGE_MODIFIER;
var config int RAMPART_RADIUS;
var config int RAMPART_COOLDOWN;
var config bool RAMPART_AWC;
var config bool STRONGBACK_AWC;
var config int COORDINATEFIRE_COOLDOWN;
var config int COORDINATEFIRE_RADIUS;
var config bool COORDINATEFIRE_AWC;
var config int PACKTACTICS_RADIUS;
var config bool PACKTACTICS_AWC;
var config int PARRY_COUNTERATTACK_DODGE;
var config bool PARRY_AWC;
var config int MINDBLAST_COOLDOWN;
var config int MINDBLAST_STUN_ACTIONS;
var config bool MINDBLAST_AWC;
var config bool SENSEPANIC_AWC;
var config int OVEREXERTION_CHARGES;
var config int OVEREXERTION_COOLDOWN;
var config bool OVEREXERTION_AWC;
var config bool RIOTCONTROL_AWC;

var localized string LocCombatDrugsEffect;
var localized string LocCombatDrugsEffectDescription;

var localized string LocBolsteredWallEffect;
var localized string LocBolsteredWallEffectDescription;

var localized string LocFaultlessDefenseEffect;
var localized string LocFaultlessDefenseEffectDescription;

var localized string LocRegenerativeMistEffect;
var localized string LocRegenerativeMistEffectDescription;

var localized string LocStayCoveredEffect;
var localized string LocStayCoveredEffectDescription;

var localized string LocPerfectGuardEffect;
var localized string LocPerfectGuardEffectDescription;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
    
	Templates.AddItem(ShootAnyone());

	Templates.AddItem(ChipAway());
	Templates.AddItem(Concentration());
	Templates.AddItem(LikeLightning());
	Templates.AddItem(StationaryThreat());
	Templates.AddItem(Opportunist());
	Templates.AddItem(Maim());
    Templates.AddItem(QuickPatch());
    Templates.AddItem(Preservation());
    Templates.AddItem(LickYourWounds());
    Templates.AddItem(Momentum());
    Templates.AddItem(ThousandsToGo());
    Templates.AddItem(Recharge());
    Templates.AddItem(PierceTheVeil());
    Templates.AddItem(TheBiggerTheyAre());
    Templates.AddItem(CallForFire());
    Templates.AddItem(LockNLoad());
    Templates.AddItem(Imposition());
    Templates.AddItem(TrenchWarfare());
    Templates.AddItem(Compensation());
    Templates.AddItem(FirstStrike());
    Templates.AddItem(DisablingShot());
    Templates.AddItem(Blend());
    Templates.AddItem(Botnet());
    Templates.AddItem(ReadyForAnything());
    Templates.AddItem(Resupply());
    Templates.AddItem(Immunize());
    Templates.AddItem(Rush());
    Templates.AddItem(AmmoConservation());
    Templates.AddItem(WellProtected());
    Templates.AddItem(Dedication());
    Templates.AddItem(Triage());
    Templates.AddItem(Steadfast());
    Templates.AddItem(Corpsman());
    Templates.AddItem(FieldMedic());
    Templates.AddItem(Stimulate());
    Templates.AddItem(Bloodlet());
    Templates.AddItem(BlindingFire());
    Templates.AddItem(QuickFeet());
    Templates.AddItem(CombatDrugs());
    Templates.AddItem(SaltInTheWound());
    Templates.AddItem(Unload());
    Templates.AddItem(Unload2());
    Templates.AddItem(UnloadDamageBonus());
    Templates.AddItem(Ambush());
    Templates.AddItem(AmbushShot());
    Templates.AddItem(Renewal());
    Templates.AddItem(WarningShot());
    Templates.AddItem(OpenFire());
    Templates.AddItem(Havoc());
    Templates.AddItem(Finesse());
    Templates.AddItem(ShoulderToLeanOn());
    Templates.AddItem(ShoulderToLeanOnPassive());
    Templates.AddItem(BolsteredWall());
    Templates.AddItem(ProtectAndServe());
    Templates.AddItem(FaultlessDefense());
    Templates.AddItem(Adrenaline());
    Templates.AddItem(WatchThemRun());
    Templates.AddItem(CoverArea());
    Templates.AddItem(CoverAreaPassive());
    Templates.AddItem(Rally());
    Templates.AddItem(ShieldTrauma());
    Templates.AddItem(Avenger());
    Templates.AddItem(FireFirst());
    Templates.AddItem(Flatline());
    Templates.AddItem(ColdBlooded());
    Templates.AddItem(Predator());
	Templates.AddItem(Survivor());
	Templates.AddItem(RegenerativeMist());
	Templates.AddItem(ControlledFire());
	Templates.AddItem(Stiletto());
	Templates.AddItem(StayCovered());
	Templates.AddItem(Indomitable());
	Templates.AddItem(PerfectGuard());
	Templates.AddItem(ShieldRegeneration());
	Templates.AddItem(CalmMind());
	Templates.AddItem(SuppressingFire());
	Templates.AddItem(SuppressingFireAddActions());
	Templates.AddItem(PutEmDown());
	Templates.AddItem(WillToSurvive());
	Templates.AddItem(WatchfulEye());
	Templates.AddItem(Guard());
	Templates.AddItem(GuardActivate());
	Templates.AddItem(TradeFire());
	Templates.AddItem(TradeFireShot());
	Templates.AddItem(Safeguard());
	Templates.AddItem(SafeguardPassive());
	Templates.AddItem(Intimidate());
	Templates.AddItem(IntimidateTrigger());
	Templates.AddItem(Rampart());
	Templates.AddItem(StrongBack());
	Templates.AddItem(CoordinateFire());
	Templates.AddItem(CoordinateFirePassive());
	Templates.AddItem(CoordinateFireFollowup());
	Templates.AddItem(PackTactics());
	Templates.AddItem(ParryAttack());
	Templates.AddItem(ParryPreparation());
	Templates.AddItem(ParryCounterattack());
	Templates.AddItem(Parry());
	Templates.AddItem(MindBlast());
	Templates.AddItem(SensePanic());
	Templates.AddItem(OverExertion());
	Templates.AddItem(RiotControl());

	return Templates;
}

// For testing purposes. Useful for seeing if defensive bonuses apply properly
static function X2AbilityTemplate ShootAnyone()
{
	local X2AbilityTemplate Template;
	local X2Condition_Visibility            VisibilityCondition;
    //local X2Effect_Persistent DisorientedEffect;

	// Create a standard attack that doesn't cost an action.
	Template = Attack('F_ShootAnyone', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free, 1);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;

	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetOnlyProperty);

    //DisorientedEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect();
    //Template.AddTargetEffect(DisorientedEffect);

	return Template;
}

// Chip Away
// (AbilityName="F_ChipAway", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire a shot that shreds additional armor. Cooldown-based.
static function X2AbilityTemplate ChipAway()
{
	local X2AbilityTemplate Template;

	// Create the template using a helper function
	Template = Attack('F_ChipAway', "img:///UILibrary_FavidsPerkPack.UIPerk_ChipAway", default.CHIPAWAY_AWC, none, default.AUTO_PRIORITY, eCost_WeaponConsumeAll, default.CHIPAWAY_AMMO_COST);
	
    // Cooldown
	AddCooldown(Template, default.CHIPAWAY_COOLDOWN);
	
	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, ChipAwayBonuses());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate ChipAwayBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'F_ChipAway_Bonuses';

	// The bonus adds shred damage dependent on tech level
	Effect.AddShredModifier(default.CHIPAWAY_SHRED_CV, eHit_Success, 'conventional');
	Effect.AddShredModifier(default.CHIPAWAY_SHRED_LS, eHit_Success, 'laser_lw');
	Effect.AddShredModifier(default.CHIPAWAY_SHRED_MG, eHit_Success, 'magnetic');
	Effect.AddShredModifier(default.CHIPAWAY_SHRED_CL, eHit_Success, 'coilgun_lw');
	Effect.AddShredModifier(default.CHIPAWAY_SHRED_BM, eHit_Success, 'beam');
	
	// The bonus only applies to the Chip Away ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('F_ChipAway');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('F_ChipAway_Bonuses', "img:///UILibrary_FavidsPerkPack.UIPerk_ChipAway", false, Effect);

	// The Chip Away ability will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Concentration
// (AbilityName="F_Concentration")
// Your grazing shots are automatically upgraded to normal hits. Passive.
static function X2AbilityTemplate Concentration()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ChangeHitResultForAttacker Effect;

	// Create an effect that will change attack hit results
	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.EffectName = 'Concentration';
    Effect.IncludeHitResults.AddItem(eHit_Graze);
	Effect.NewResult = eHit_Success;

	// Create the template using a helper function
	Template = Passive('F_Concentration', "img:///UILibrary_FavidsPerkPack.UIPerk_Concentration", default.CONCENTRATION_AWC, Effect);

	return Template;
}

// Like Lightning
// (AbilityName="F_LikeLightning", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// When Run and Gun is activated, your Arc Thrower cooldown is immediately removed and your next Arc Thrower shot that turn does not cost an action. Passive.
static function X2AbilityTemplate LikeLightning()
{
	local X2Effect_ReduceCooldowns ReduceCooldownEffect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;

	// Effect that reduces the cooldown of arc thrower abilities
	ReduceCooldownEffect = new class'X2Effect_ReduceCooldowns';
	ReduceCooldownEffect.ReduceAll = true;
	ReduceCooldownEffect.AbilitiesToTick.AddItem('ArcthrowerStun');
	ReduceCooldownEffect.AbilitiesToTick.AddItem('EMPulser');

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('F_LikeLightning', "img:///UILibrary_XPerkIconPack.UIPerk_lightning_chevron", default.LIKELIGHTNING_AWC, ReduceCooldownEffect, 'AbilityActivated');

	// Only when Run and Gun abilities are used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('RunAndGun');
	NameCondition.IncludeAbilityNames.AddItem('LW2WotC_RunAndGun');
	NameCondition.IncludeAbilityNames.AddItem('RunAndGun_LW');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// Add secondary ability that will refund arc thrower action points when used while Run and Gun is active
	AddSecondaryAbility(Template, LikeLightningRefund());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

static function X2AbilityTemplate LikeLightningRefund()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	local X2Condition_UnitValue RunAndGunCondition;
	
	// Create an effect that will refund the cost of attacks
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'F_LikeLightning_Refund';
	Effect.TriggeredEvent = 'F_LikeLightning_Refund';
	Effect.CountValueName = 'F_LikeLightning_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	// The bonus only applies to arc thrower shots
	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames.AddItem('ArcThrowerStun');
	AbilityNameCondition.IncludeAbilityNames.AddItem('EMPulser');
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Only refunds if Run and Gun has been activated
	RunAndGunCondition = new class'X2Condition_UnitValue';
	RunAndGunCondition.AddCheckValue('RunAndGun_SuperKillCheck', 0, eCheck_GreaterThan,,,'AA_RunAndGunNotUsed');
	Effect.AbilityShooterConditions.AddItem(RunAndGunCondition);

	// Create the template using a helper function
	return Passive('F_LikeLightning_Refund', "img:///UILibrary_XPerkIconPack.UIPerk_lightning_chevron", false, Effect);
}

// Stationary Threat
// (AbilityName="F_StationaryThreat", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Gain plus one damage to your primary weapon for each turn that you do not move.
static function X2AbilityTemplate StationaryThreat()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_UnitValue Value;
	local X2Effect_SetUnitValue ValueEffect;

	// Create a value that uses a unit value.
	Value = new class'XMBValue_UnitValue';
	
	// The value that counts the number of turns without movement
	Value.UnitValueName = 'F_StationaryThreat_TurnsWithoutMovement';
	 
	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	// The effect adds damage each turn
	Effect.AddDamageModifier(default.STATIONARYTHREAT_DAMAGE_PER_TURN);

	// The effect stacks a configurable number of times
	Effect.ScaleValue = Value;
	Effect.ScaleMax = default.STATIONARYTHREAT_DAMAGE_MAX_TURNS;

	// Restrict to the weapon matching this ability
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Create the template using a helper function
	Template = Passive('F_StationaryThreat', "img:///UILibrary_XPerkIconPack.UIPerk_rifle_blaze", default.STATIONARYTHREAT_AWC, Effect);
	
	// Default the counter to 0
	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = 'F_StationaryThreat_TurnsWithoutMovement';
	ValueEffect.NewValueToSet = 0;
	ValueEffect.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(ValueEffect);

	// Secondary ability that increments 'turns without movement' by 1 at the start of each turn
	AddSecondaryAbility(Template, StationaryThreatBeginTurn());

	// Secondary ability that sets 'turns without movement' to 0 when a move is made
	AddSecondaryAbility(Template, StationaryThreatMovement());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate StationaryThreatBeginTurn()
{
	local X2AbilityTemplate Template;
	local X2Effect_IncrementUnitValue ValueEffect;
	
	// Increments counter by one at the start of each turn
	ValueEffect = new class'X2Effect_IncrementUnitValue';
	ValueEffect.UnitName = 'F_StationaryThreat_TurnsWithoutMovement';
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTactical;

	// Create a triggered ability that will activate whenever the unit's turn beings
	Template = SelfTargetTrigger('F_StationaryThreat_BeginTurn', "img:///UILibrary_XPerkIconPack.UIPerk_rifle_blaze", false, ValueEffect, 'PlayerTurnBegun', eFilter_Player);

	return Template;
}

static function X2AbilityTemplate StationaryThreatMovement()
{
	local X2AbilityTemplate Template;
	local X2Effect_SetUnitValue ValueEffect;
	
	// Resets counter to 0 when a move is made
	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = 'F_StationaryThreat_TurnsWithoutMovement';
	ValueEffect.NewValueToSet = 0;
	ValueEffect.CleanupType = eCleanup_BeginTactical;

	// Create a triggered ability that will activate whenever the unit moves
	Template = SelfTargetTrigger('F_StationaryThreat_Movement', "img:///UILibrary_XPerkIconPack.UIPerk_rifle_blaze", false, ValueEffect, 'UnitMoveFinished');

	return Template;
}

// Opportunist
// (AbilityName="F_Opportunist")
// Reaction fire shots now ignore half of cover bonuses
// NOTE: Extended Information lies about this ability's bonuses in the flyover
static function X2AbilityTemplate Opportunist()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus LowCoverBonusEffect;
	local XMBEffect_ConditionalBonus FullCoverBonusEffect;

	Template = Passive('F_Opportunist', "img:///UILibrary_FavidsPerkPack.UIPerk_Opportunist", default.OPPORTUNIST_AWC, none);

    // Bonus for when targets are in low cover
	LowCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(default.HalfCoverCondition);
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(default.ReactionFireCondition);
	LowCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS / 2);
    AddSecondaryEffect(Template, LowCoverBonusEffect);
    
    // Bonus for when targets are in full cover
	FullCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	FullCoverBonusEffect.AbilityTargetConditions.AddItem(default.FullCoverCondition);
	FullCoverBonusEffect.AbilityTargetConditions.AddItem(default.ReactionFireCondition);
	FullCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS / 2);
    AddSecondaryEffect(Template, FullCoverBonusEffect);

    return Template;
}

// Maim
// (AbilityName="F_Maim", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire a shot that immobilizes the target until the end of their next turn. Cooldown-based.
static function X2AbilityTemplate Maim()
{
	local X2AbilityTemplate Template;
	local X2Effect_Immobilize Effect;
	
	// Create the template using a helper function
	Template = Attack('F_Maim', "img:///UILibrary_FavidsPerkPack.UIPerk_Maim", default.MAIM_AWC, none, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_WeaponConsumeAll, default.MAIM_AMMO_COST);

	// Cooldown
	AddCooldown(Template, default.MAIM_COOLDOWN);

	// Effect
	Effect = new class'X2Effect_Immobilize';
	Effect.EffectName = 'F_Maim_Immobilize';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(default.MAIM_DURATION, false, true, , eGameRule_PlayerTurnEnd);
	Effect.AddPersistentStatChange(eStat_Mobility, 0, MODOP_Multiplication);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	Effect.VisualizationFn = EffectFlyOver_Visualization;
	Template.AddTargetEffect(Effect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Quick Patch
// (AbilityName="F_QuickPatch")
// Using a Medikit does not cost an action. Passive.
static function X2AbilityTemplate QuickPatch()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	
	// Create an effect that will refund the cost of the action
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'F_QuickPatch';
	Effect.TriggeredEvent = 'F_QuickPatch';

	// The bonus only applies to medikit abilities
	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames = default.QUICKPATCH_ABILITIES;
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Create the template using a helper function
	return Passive('F_QuickPatch', "img:///UILibrary_XPerkIconPack.UIPerk_medkit_chevron", default.QUICKPATCH_AWC, Effect);
}

// Preservation
// (AbilityName="F_Preservation")
// When your concealment is broken, gain a bonus to defense for a few turns. Passive.
static function X2AbilityTemplate Preservation()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange DefenseEffect;

	// Create a persistent stat change effect that grants a defense bonus
	DefenseEffect = new class'X2Effect_PersistentStatChange';
	DefenseEffect.EffectName = 'F_PreservationEffect';
	DefenseEffect.AddPersistentStatChange(eStat_Defense, default.PRESERVATION_DEFENSE_BONUS);
	
	// Prevent the effect from applying to a unit more than once
	DefenseEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts for a specified duration
	DefenseEffect.BuildPersistentEffect(default.PRESERVATION_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	
	// Add a visualization that plays a flyover over the target unit
	DefenseEffect.VisualizationFn = EffectFlyOver_Visualization;

	// Ability is triggered when concealment is broken
	Template = SelfTargetTrigger('F_Preservation', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_defense2", default.PRESERVATION_AWC, DefenseEffect, 'UnitConcealmentBroken', eFilter_Unit);
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	return Template;
}

// Lick Your Wounds
// (AbilityName="F_LickYourWounds")
// Hunker Down restores some health and removes poison, burning, and acid burning. Passive.
static function X2AbilityTemplate LickYourWounds()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local X2Effect_ApplyHeal HealEffect;
	
	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('F_LickYourWounds', "img:///UILibrary_FavidsPerkPack.UIPerk_LickYourWounds", default.LICKYOURWOUNDS_AWC, none, 'AbilityActivated');

	// Only trigger with Hunker Down
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('HunkerDown');
	NameCondition.IncludeAbilityNames.AddItem('ShieldWall');
	AddTriggerTargetCondition(Template, NameCondition);

	// Restore health effect
	HealEffect = new class'X2Effect_ApplyHeal';
	HealEffect.HealAmount = default.LICKYOURWOUNDS_HEALAMOUNT;
	HealEffect.MaxHealAmount = default.LICKYOURWOUNDS_MAXHEALAMOUNT;
	HealEffect.HealthRegeneratedName = 'LickYourWoundsHeal';
	Template.AddTargetEffect(HealEffect);

	// Heal the status effects that a Medkit would heal
	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType());
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	return Template;
}

// Momentum
// (AbilityName="F_Momentum", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Grants increased aim and critical chance if you have moved this turn. Passive.
static function X2AbilityTemplate Momentum()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus OffenseEffect;
	local X2Condition_UnitValue Condition;

	// Create a conditional bonus effect
	OffenseEffect = new class'XMBEffect_ConditionalBonus';

	// Add the aim and crit bonuses
	OffenseEffect.AddToHitModifier(default.MOMENTUM_AIM_BONUS, eHit_Success);
	OffenseEffect.AddToHitModifier(default.MOMENTUM_CRIT_BONUS, eHit_Crit);

	// Only if you have moved this turn
	Condition = new class'X2Condition_UnitValue';
	Condition.AddCheckValue('MovesThisTurn', 0, eCheck_GreaterThan);
	OffenseEffect.AbilityShooterConditions.AddItem(Condition);
	
	// Create the template using a helper function
	Template = Passive('F_Momentum', "img:///UILibrary_FavidsPerkPack.UIPerk_Momentum", default.MOMENTUM_AWC, OffenseEffect);

	return Template;
}

// Thousands To Go
// (AbilityName="F_ThousandsToGo", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Once per turn, after killing an enemy with your primary weapon, you may take an additional non-movement action. Passive.
static function X2AbilityTemplate ThousandsToGo()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Condition_UnitValue ValueCondition;
	local X2Effect_IncrementUnitValue IncrementEffect;

	// Effect adds a Run and Gun action point
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('F_ThousandsToGo', "img:///UILibrary_FavidsPerkPack.UIPerk_ThousandsToGo", default.THOUSANDSTOGO_AWC, Effect, 'KillMail');
    
    // Only trigger on kills with the matching weapon
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

	// Does not trigger when killing Lost
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	AddTriggerTargetCondition(Template, UnitTypeCondition);
    
	// Limit activations
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_ThousandsToGo_Activations', default.THOUSANDSTOGO_ACTIVATIONS_PER_TURN, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    // Create an effect that will increment the unit value
	IncrementEffect = new class'X2Effect_IncrementUnitValue';
	IncrementEffect.UnitName = 'F_ThousandsToGo_Activations';
	IncrementEffect.NewValueToSet = 1; // This means increment by one -- stupid property name
	IncrementEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(IncrementEffect);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Recharge
// (AbilityName="F_Recharge", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Killing an enemy with your primary weapon reduces the cooldown of all abilities. Passive.
static function X2AbilityTemplate Recharge()
{
	local X2AbilityTemplate Template;
	local X2Effect_ReduceCooldowns Effect;

	// Create an effect that reduces all cooldowns
	Effect = new class'X2Effect_ReduceCooldowns';
	Effect.Amount = default.RECHARGE_COOLDOWN_AMOUNT;
	Effect.ReduceAll = false;
	
	// Create a triggered ability that activates whenever the unit gets a kill
	Template = SelfTargetTrigger('F_Recharge', "img:///UILibrary_FavidsPerkPack.UIPerk_Recharge", default.RECHARGE_AWC, Effect, 'KillMail');
    
	// Effect only applies to matching weapon
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Pierce The Veil
// (AbilityName="F_PierceTheVeil", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Activated ability that confers bonus aim, damage, and armor piercing to organic targets with your primary weapon, while increasing the cooldown of all of your other abilities. Cooldown-based.
static function X2AbilityTemplate PierceTheVeil()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;
	local X2Condition_UnitProperty				OrganicCondition;
	local X2Effect_IncreaseCooldowns CooldownEffect;

	// Create a stat change effect that grants an aim bonus, damage bonus, and armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'F_PierceTheVeilBonuses';
	ShootingEffect.AddToHitModifier(default.PIERCETHEVEIL_AIM_BONUS);
	ShootingEffect.AddDamageModifier(default.PIERCETHEVEIL_DAMAGE_BONUS);
	ShootingEffect.AddArmorPiercingModifier(default.PIERCETHEVEIL_ARMOR_PIERCING);

	// Only against organics 
	OrganicCondition = new class'X2Condition_UnitProperty';
	OrganicCondition.ExcludeRobotic = true;
	ShootingEffect.AbilityTargetConditions.AddItem(OrganicCondition);

	// Only with the associated weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts for one turn
	ShootingEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	
	// Activated ability that targets user
	Template = SelfTargetActivated('F_PierceTheVeil', "img:///UILibrary_FavidsPerkPack.UIPerk_AmplifiedShot", default.PIERCETHEVEIL_AWC, ShootingEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	
	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Cooldown
	AddCooldown(Template, default.PIERCETHEVEIL_COOLDOWN);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// Now the effect to increase cooldowns
	CooldownEffect = new class'X2Effect_IncreaseCooldowns';
	CooldownEffect.Amount = default.PIERCETHEVEIL_INCREASE_COOLDOWN_AMOUNT;
	CooldownEffect.IncreaseAll = false;
	CooldownEffect.OnlyAlreadyOnCooldown = false;
	Template.AddTargetEffect(CooldownEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// The Bigger They Are
// (AbilityName="F_TheBiggerTheyAre")
// Grants increased aim against targets that cannot take cover. Passive.
static function X2AbilityTemplate TheBiggerTheyAre()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	// Add the aim bonus
	Effect.AddToHitModifier(default.THEBIGGERTHEYARE_AIM_BONUS);

	// Target must not be allowed to take cover (like MECs and Drones)
	Effect.AbilityTargetConditions.AddItem(default.CantTakeCoverCondition);
	
	// Create the template using a helper function
	Template = Passive('F_TheBiggerTheyAre', "img:///UILibrary_FavidsPerkPack.UIPerk_TheBiggerTheyAre", default.THEBIGGERTHEYARE_AWC, Effect);

	return Template;
}

// Call For Fire
// (AbilityName="F_CallForFire")
// Enter overwatch. All allies in a radius around you also enter overwatch.
static function X2AbilityTemplate CallForFire()
{
    local X2Effect_AddOverwatchActionPoints     Effect;
	local X2AbilityTemplate                     Template;
	local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              Condition;
    
    // Effect granting an overwatch shot
	Effect = new class'X2Effect_AddOverwatchActionPoints';

    // Activated ability that targets user
	Template = SelfTargetActivated('F_CallForFire', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_circle", default.CALLFORFIRE_AWC, Effect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_SingleConsumeAll);
	
	// The ability targets the unit that has it, but also effects all nearby units that meet the conditions on the multitarget effect.
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.CALLFORFIRE_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddMultiTargetEffect(Effect);

    // Only affects living allies
	Condition = new class'X2Condition_UnitProperty';
	Condition.RequireWithinRange = true;
	Condition.ExcludeHostileToSource = true;
	Condition.ExcludeFriendlyToSource = false;
	Condition.ExcludeDead = true; 
	Template.AbilityMultiTargetConditions.AddItem(Condition);
    
	// Cooldown
	AddCooldown(Template, default.CALLFORFIRE_COOLDOWN);

	// Show a flyover when activated
	Template.bShowActivation = true;

    // Do a pointing animation
	Template.CustomFireAnim = 'HL_SignalPoint';
    Template.bSkipFireAction = false;
    
    // Make the overwatch sound when used
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	return Template;
}

// Lock 'N Load
// (AbilityName="F_LockNLoad", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Kills with your primary weapon restore one ammo. Passive.
static function X2AbilityTemplate LockNLoad()
{
	local X2AbilityTemplate Template;
	local X2Effect_ReloadPrimaryWeapon Effect;

	// Create an effect that restores some ammo
	Effect = new class'X2Effect_ReloadPrimaryWeapon';
	Effect.AmmoToReload = default.LOCKNLOAD_AMMO_TO_RELOAD;
	
	// Create a triggered ability that activates whenever the unit gets a kill
	Template = SelfTargetTrigger('F_LockNLoad', "img:///UILibrary_XPerkIconPack.UIPerk_reload_shot", default.LOCKNLOAD_AWC, Effect, 'KillMail');
    
	// Effect only applies to matching weapon
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Imposition
// (AbilityName="F_Imposition")
// Standard shots with the unit's primary weapon lowers the target's aim until next turn. Passive.
static function X2AbilityTemplate Imposition()
{
	local X2AbilityTemplate Template;

	// Start with the passive template
	Template = Passive('F_Imposition', "img:///UILibrary_FavidsPerkPack.UIPerk_Imposition", default.IMPOSITION_AWC, none);
	
	return Template;
}

// Added to StandardShot in OnPostTemplatesCreated()
static function X2Effect_PersistentStatChange ImpositionEffect()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange		Effect;
	local X2Condition_AbilityProperty       Condition;

    // Get the template that we'll use for this effect's display info
    Template = Imposition();

    // Effect that reduces aim
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_Imposition_AimPenalty';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(default.IMPOSITION_DURATION, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.AddPersistentStatChange(eStat_Offense, default.IMPOSITION_AIM_PENALTY);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	Effect.VisualizationFn = EffectFlyOver_Visualization;
	Effect.bApplyOnMiss = true;

    // Only apply if shooter has Imposition passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_Imposition');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Trench Warfare
// (AbilityName="F_TrenchWarfare")
// If you get at least one kill during your turn, automatically hunker down at the end of it. Passive.
static function X2AbilityTemplate TrenchWarfare()
{
	local X2AbilityTemplate				Template;
	local X2Effect_IncrementUnitValue   ValueEffect;
	
	// Increments counter by one at the start of each turn
	ValueEffect = new class'X2Effect_IncrementUnitValue';
	ValueEffect.UnitName = 'F_TrenchWarfare_KillsThisTurn';
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTurn;
    
	// Create a triggered ability that runs when the owner gets a kill
	Template = SelfTargetTrigger('F_TrenchWarfare', "img:///UILibrary_FavidsPerkPack.UIPerk_TrenchWarfare", default.TRENCHWARFARE_AWC, ValueEffect, 'KillMail');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

    // Show flyover after a kill
    Template.bShowActivation = true;

    // Secondary ability that activates Hunker Down at the end of the turn if you got a kill
    AddSecondaryAbility(Template, TrenchWarfareActivator());

	return Template;
}

static function X2AbilityTemplate TrenchWarfareActivator()
{
    local X2Effect_GrantActionPoints ActionPointEffect;
	local X2Effect_ImmediateAbilityActivation HunkerDownEffect;
	local X2Effect_ImmediateAbilityActivation ShieldWallEffect;
	local X2AbilityTemplate Template;
	local X2Condition_UnitEffects EffectsCondition;
	local X2Condition_UnitValue ValueCondition;

	// Create a triggered ability that runs at the end of the player's turn
	Template = SelfTargetTrigger('F_TrenchWarfare_Activator', "img:///UILibrary_FavidsPerkPack.UIPerk_TrenchWarfare", false, none, 'PlayerTurnEnded', eFilter_Player);

	// Require not already hunkered down
	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	// Require that a kill has been made
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_TrenchWarfare_KillsThisTurn', 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

	// Hunkering requires an action point, so grant one if the unit is out of action points
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.DeepCoverActionPoint;
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.bApplyOnlyWhenOut = true;
	AddSecondaryEffect(Template, ActionPointEffect);

	// Activate the Hunker Down ability
	HunkerDownEffect = new class'X2Effect_ImmediateAbilityActivation';
	HunkerDownEffect.EffectName = 'ImmediateHunkerDown';
	HunkerDownEffect.AbilityName = 'HunkerDown';
	HunkerDownEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	AddSecondaryEffect(Template, HunkerDownEffect);

	// Activate the Shield Wall Ability
	ShieldWallEffect = new class'X2Effect_ImmediateAbilityActivation';
	ShieldWallEffect.EffectName = 'ImmediateShieldWall';
	ShieldWallEffect.AbilityName = 'ShieldWall';
	ShieldWallEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	AddSecondaryEffect(Template, ShieldWallEffect);

	return Template;
}

// Compensation
// (AbilityName="F_Compensation")
// Firing your sniper rifle with two actions will refund one of those actions. Passive.
static function X2AbilityTemplate Compensation()
{
    local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;

	// Create an effect that will refund the cost of attacks
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'F_Compensation_Refund';
	Effect.TriggeredEvent = 'F_Compensation_Refund';

	// Only refund once per turn
	Effect.CountValueName = 'F_Compensation_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

    // Only refund one action point instead of all
    Effect.bRefundSinglePoint = true;

	// The bonus only applies to standard sniper rifle shots
	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames.AddItem('SniperStandardFire');
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Create the template using a helper function
	return Passive('F_Compensation', "img:///UILibrary_XPerkIconPack.UIPerk_sniper_chevron_x2", default.COMPENSATION_AWC, Effect);
}

// First Strike
// (AbilityName="F_FirstStrike", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Grants a large damage bonus while concealed, and a small damage bonus while flanking. Passive.
static function X2AbilityTemplate FirstStrike()
{
	local X2AbilityTemplate Template;
    local X2Condition_UnitProperty   ConcealedCondition;
	local XMBEffect_ConditionalBonus ConcealedBonusEffect;
	local XMBEffect_ConditionalBonus FlankingBonusEffect;

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;

    // Bonus while concealed
	ConcealedBonusEffect = new class'XMBEffect_ConditionalBonus';
	ConcealedBonusEffect.AddDamageModifier(default.FIRSTSTRIKE_CONCEALED_DAMAGE_BONUS);
	ConcealedBonusEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
	ConcealedBonusEffect.AbilityTargetConditions.AddItem(ConcealedCondition);

	Template = Passive('F_FirstStrike', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_shot2", default.FIRSTSTRIKE_AWC, ConcealedBonusEffect);

    // Bonus while flanking
	FlankingBonusEffect = new class'XMBEffect_ConditionalBonus';
	FlankingBonusEffect.AddDamageModifier(default.FIRSTSTRIKE_FLANKING_DAMAGE_BONUS);
	FlankingBonusEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
	FlankingBonusEffect.AbilityTargetConditions.AddItem(default.FlankedCondition);
    AddSecondaryEffect(Template, FlankingBonusEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Disabling Shot
// (AbilityName="F_DisablingShot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire a shot that stuns the target. This attack cannot critically hit.
static function X2AbilityTemplate DisablingShot()
{
	local X2AbilityTemplate              Template;
	local X2Effect_Stunned	             StunnedEffect;
    local X2AbilityToHitCalc_StandardAim ToHitCalc;

	// Create the template using a helper function
	Template = Attack('F_DisablingShot', "img:///UILibrary_XPerkIconPack.UIPerk_shot_repair", default.DISABLINGSHOT_AWC, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_WeaponConsumeAll, default.DISABLINGSHOT_AMMO_COST);
	
	// Create Stun effect
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.DISABLINGSHOT_STUN_ACTIONS, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);
	
	// Custom hit calc to disallow critical hits
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Cooldown
	AddCooldown(Template, default.DISABLINGSHOT_COOLDOWN);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Blend
// (AbilityName="F_Blend")
// Immediately grants concealment that is automatically broken after a few turns.
static function X2AbilityTemplate Blend()
{
    local X2AbilityTemplate     Template;
	local X2Effect_SetUnitValue ValueEffect;

    // Start with a copy of the Ranger's Conceal ability
    Template = class'X2Ability_RangerAbilitySet'.static.Stealth('F_Blend');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_stealth_blaze";
    Template.bCrossClassEligible = default.BLEND_AWC;

    // Remove costs so we can add our own
    Template.AbilityCosts.Length = 0;
	Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges');
	Template.AbilityCosts.AddItem(default.FreeActionCost);

    // Add an effect that sets our counter value
	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = 'F_Blend_Activated';
	ValueEffect.NewValueToSet = 1; // start at 1
	ValueEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(ValueEffect);

    // Ability that will increment counter for number of turns concealed by Blend
    AddSecondaryAbility(Template, BlendConcealmentCounter());

    // Ability that will remove concealment on the start of next turn
    AddSecondaryAbility(Template, BlendConcealmentRemover());

    // Reset the counter when concealment is lost
    AddSecondaryAbility(Template, BlendConcealmentLostListener());

    return Template;
}

static function X2AbilityTemplate BlendConcealmentCounter()
{
    local X2AbilityTemplate     Template;
	local X2Effect_IncrementUnitValue ValueEffect;
    local X2Condition_UnitValue ValueCondition;
    
	// Increment counter by 1 each turn
	ValueEffect = new class'X2Effect_IncrementUnitValue';
	ValueEffect.UnitName = 'F_Blend_Activated';
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTactical;

	// Create a triggered ability that will activate whenever the unit's turn beings - priority set to occur before the remove ability
	Template = SelfTargetTrigger('F_Blend_ConcealmentCounter', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_blaze", false, ValueEffect, 'PlayerTurnBegun', eFilter_Player, 51);
    
    // Only fires if our counter is at least 1, meaning Blend has been used
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_Blend_Activated', 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    return Template;
}

static function X2AbilityTemplate BlendConcealmentRemover()
{
    local X2AbilityTemplate     Template;
    local X2Condition_UnitValue ValueCondition;

	// Create a triggered ability that will activate whenever the unit's turn beings
	Template = SelfTargetTrigger('F_Blend_ConcealmentRemover', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_blaze", false, new class'X2Effect_BreakUnitConcealment', 'PlayerTurnBegun', eFilter_Player, 50);

    // Only fires if our counter is greater than max number of turns
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_Blend_Activated', default.BLEND_TURNS_CONCEALED, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    return Template;
}

static function X2AbilityTemplate BlendConcealmentLostListener()
{
	local X2Effect_SetUnitValue ValueEffect;

    // Reset the counter for Blend when concealment is lost
	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = 'F_Blend_Activated';
	ValueEffect.NewValueToSet = 0;
	ValueEffect.CleanupType = eCleanup_BeginTactical;

	// Create a triggered ability that will activate whenever the unit breaks concealment
	return SelfTargetTrigger('F_Blend_ConcealmentLost', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_blaze", false, ValueEffect, 'UnitConcealmentBroken');
}

// Botnet
// (AbilityName="F_Botnet")
// While active, standard shots from all allies lower their target's hack defense.
static function X2AbilityTemplate Botnet()
{
	local X2AbilityTemplate Template;
    local X2Effect_Persistent Effect;

	// Activated ability that targets user
	Template = SelfTargetActivated('F_Botnet', "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_circle", default.BOTNET_AWC, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	Template.bShowActivation = true;

    // Has a mutli-target effect that grants a dummy effect to all allies
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'F_Botnet_Valid';
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

    // Cooldown
    AddCooldown(Template, default.BOTNET_COOLDOWN);

	return Template;
}

// Added to StandardShot in OnPostTemplatesCreated()
static function X2Effect_PersistentStatChange BotnetEffect()
{
	local X2Effect_PersistentStatChange		Effect;
	local X2Condition_UnitEffectsOnSource   Condition;
	local X2Condition_UnitProperty          Condition_UnitProperty;

    // Only on robots
	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = true;
	Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;
    
    // Effect that reduces hack defense
	Effect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.BOTNET_HACK_DEFENSE_PENALTY, Condition_UnitProperty);

    // Only apply if shooter has the required Botnet effect
	Condition = new class'X2Condition_UnitEffectsOnSource';
	Condition.AddRequireEffect('F_Botnet_Valid', 'AA_MissingRequiredEffect');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Ready For Anything
// (AbilityName="F_ReadyForAnything", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// When you make a standard attack with your primary weapon you automatically enter overwatch.
static function X2AbilityTemplate ReadyForAnything()
{
    //local X2Effect_ThreatAssessment         Effect;
	local X2AbilityTemplate                 Template;
	local X2Condition_AbilitySourceWeapon   AmmoCondition;
    local X2Effect_AddOverwatchActionPoints   Effect;
	
    // Effect granting an overwatch shot
	Effect = new class'X2Effect_AddOverwatchActionPoints';
    
	Template = SelfTargetTrigger('F_ReadyForAnything', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_shot_2", default.READYFORANYTHING_AWC, Effect, 'StandardShotActivated');
    Template.bShowActivation = true;
    
    // Only trigger with the matching weapon
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

    // Require that the user has ammo left
	AmmoCondition = new class'X2Condition_AbilitySourceWeapon';
	AmmoCondition.AddAmmoCheck(0, eCheck_GreaterThan);
	AddTriggerTargetCondition(Template, AmmoCondition);
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

// Resupply
// (AbilityName="F_Resupply", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Your GREMLIN moves to every ally, reloading the ammo in their primary weapon.
static function X2AbilityTemplate Resupply()
{
	local X2AbilityTemplate Template;
	local X2AbilityMultiTarget_AllAllies MultiTargetingStyle;
	local X2Condition_UnitProperty TargetCondition;
	local X2Effect_ReloadPrimaryWeapon Effect;

	Template = SelfTargetActivated('F_Resupply', "img:///UILibrary_FavidsPerkPack.UIPerk_Resupply", default.RESUPPLY_AWC, none);

	// Create an effect that reloads ammo
	Effect = new class'X2Effect_ReloadPrimaryWeapon';
	Effect.AmmoToReload = default.RESUPPLY_AMMO_TO_RELOAD;
	Template.AddMultiTargetEffect(Effect);

    // Targets all allies
	MultiTargetingStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetingStyle.bAllowSameTarget = true;
	MultiTargetingStyle.NumTargetsRequired = 1; //At least one ally must be a valid target
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

    // Allied squadmates only
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	// Targets must want a reload
	Template.AbilityMultiTargetConditions.AddItem(new class 'X2Condition_WantsReload');
    
	// Gremlin animation code
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinRestoration_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	Template.ActivationSpeech = 'Reloading';

    // Charges
	AddCharges(Template, default.RESUPPLY_CHARGES);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Immunize
// (AbilityName="F_Immunize", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Your GREMLIN flies to an ally, granting them immunity to damage until the beginning of next turn.
static function X2AbilityTemplate Immunize()
{
	local X2AbilityTemplate                     Template;
    local X2Effect_DamageImmune                 Effect;

    // Effect granting immunity until next turn
    Effect = new class'X2Effect_DamageImmune';
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

    Template = TargetedBuff('F_Immunize', "img:///UILibrary_XPerkIconPack.UIPerk_shield_gremlin", default.IMMUNIZE_AWC, Effect, default.AUTO_PRIORITY, eCost_Single);

    // Charges
    AddCharges(Template, default.IMMUNIZE_CHARGES);
    
	// Gremlin animation code
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
    
    // for later ref
	Template.CustomSelfFireAnim = 'NO_DefenseProtocolA';

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Rush
// (AbilityName="F_Rush", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Run towards an enemy and stab them with your knife. Can only perform with single-action moves. Costs a single action and does not end the turn.
static function X2AbilityTemplate Rush()
{
	local X2AbilityTemplate                 Template;
	local array<name>                       SkipExclusions;
    local X2AbilityTarget_MovingMelee       MovingMeleeTargeting;

	// Start with a copy of the Ranger's running Slash
	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('F_Rush');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_knife_move2";
    Template.bCrossClassEligible = default.RUSH_AWC;

    // Can only blue move
    MovingMeleeTargeting = new class'X2AbilityTarget_MovingMelee';
    MovingMeleeTargeting.MovementRangeAdjustment = 1;
    Template.AbilityTargetStyle = MovingMeleeTargeting;

    // No longer ends the turn
    Template.AbilityCosts.Length = 0;
    Template.AbilityCosts.AddItem(ActionPointCost(eCost_Single));

	// In LW2, melee attacks are allowed when disoriented, so we have to redo the shooter conditions from the base ability, which disables them while disoriented
	Template.AbilityShooterConditions.Length = 0;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Ammo Conservation
// (AbilityName="F_AmmoConservation")
// Activated ability that does not cost an action point. Until the beginning of next turn, your ammo will be refunded after each shot you take. Cooldown-based.
static function X2AbilityTemplate AmmoConservation()
{
	local X2AbilityTemplate		    Template;
	local X2Effect_RefundAmmoCost	Effect;
	
    // Handles the ammo cost refund
	Effect = new class'X2Effect_RefundAmmoCost';
	Effect.EffectName = 'F_AmmoConservation';
	Effect.bAppliesToSecondaries = default.AMMOCONSERVATION_APPLIES_TO_SECONDARIES;
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	Template = SelfTargetActivated('F_AmmoConservation', "img:///UILibrary_FavidsPerkPack.UIPerk_LockNLoad", default.AMMOCONSERVATION_AWC, Effect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	Template.bShowActivation = true;

    AddCooldown(Template, default.AMMOCONSERVATION_COOLDOWN);

	return Template;
}

// Well Protected
// (AbilityName="F_WellProtected")
// Grants a vest only utility slot. Passive.
static function X2AbilityTemplate WellProtected()
{
	// Create the template using a helper function - XComVestSlot.ini sets this perk as unlocking the vest pocket
	return Passive('F_WellProtected', "img:///UILibrary_FavidsPerkPack.Perk_Ph_WellProtected", default.WELLPROTECTED_AWC, none);
}

// Dedication
// (AbilityName="F_Dedication")
// Free action. Gain bonus mobility and ignore reaction fire for the rest of the turn. Cooldown-based.
static function X2AbilityTemplate Dedication()
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange Effect;
	
	// Activated ability that targets user
	Template = SelfTargetActivated('F_Dedication', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Dedication", default.DEDICATION_AWC, none, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY, eCost_Free);
	Template.bShowActivation = true;

	// Create a persistent stat change effect that grants a mobility bonus - naming the effect Shadowstep lets you ignore reaction fire
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'Shadowstep';
	Effect.AddPersistentStatChange(eStat_Mobility, default.DEDICATION_MOBILITY);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(Effect);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Cooldown
	AddCooldown(Template, default.DEDICATION_COOLDOWN);

	return Template;
}

// Triage
// (AbilityName="F_Triage")
// Restores health to the user and all allies in the surrounding area. Also removes physical status effects.
static function X2AbilityTemplate Triage()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Effect_ApplyMedikitHeal             HealEffect;
    local X2Effect_RemoveEffectsByDamageType    RemoveEffects;
    local array<name>                           SkipExclusions;
    local name                                  HealType;
    
    // Activated ability that targets user
	Template = SelfTargetActivated('F_Triage', "img:///UILibrary_XPerkIconPack.UIPerk_medkit_circle", default.TRIAGE_AWC, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_SingleConsumeAll);
	
	// The ability targets the unit that has it, but also effects all nearby units that meet the conditions on the multitarget effect.
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.TRIAGE_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    // Can be used while burning, but not under any other normally deblitating effects
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

    // Restore health effect
	HealEffect = new class'X2Effect_ApplyMedikitHeal';
	HealEffect.PerUseHP = default.TRIAGE_HEAL_AMOUNT;
	Template.AddTargetEffect(HealEffect);
	Template.AddMultiTargetEffect(HealEffect);

    // Remove the effects that a medikit would
	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);
	Template.AddMultiTargetEffect(RemoveEffects);
    
	// Charges
    AddCharges(Template, default.TRIAGE_CHARGES);

	// Show a flyover when activated
	Template.bShowActivation = true;

	return Template;
}

// Steadfast
// (AbilityName="F_Steadfast")
// Grants immunity to negative mental conditions including panic, mind control, stuns, and disorientation.
static function X2AbilityTemplate Steadfast()
{
    local X2Effect_DamageImmunity       Effect;
    
	Effect = new class'X2Effect_DamageImmunity';
	Effect.ImmuneTypes.AddItem('Mental');
	Effect.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
	Effect.ImmuneTypes.AddItem('Stun');
	Effect.ImmuneTypes.AddItem('Unconscious');
    
	return Passive('F_Steadfast', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Steadfast", default.STEADFAST_AWC, Effect);
}

// Corpsman
// (AbilityName="F_Corpsman")
// Grants a free medikit.
static function X2AbilityTemplate Corpsman()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem TemporaryItemEffect;
	
	// Effect granting a free medkit
	TemporaryItemEffect = new class'XMBEffect_AddUtilityItem';
	TemporaryItemEffect.EffectName = 'F_Corpsman';
	TemporaryItemEffect.DataName = 'Medikit';

	// Create the template using a helper function
	Template = Passive('F_Corpsman', "img:///UILibrary_XPerkIconPack.UIPerk_medkit_box", default.CORPSMAN_AWC, TemporaryItemEffect);

	return Template;
}

// Field Medic
// (AbilityName="F_FieldMedic")
// Grants additional medikit charges. Compatible with Corpsman
static function X2AbilityTemplate FieldMedic()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddItemCharges BonusItemEffect;
	
	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = default.FIELDMEDIC_BONUS_ITEMS;
	BonusItemEffect.ApplyToNames.AddItem('Medikit');
	BonusItemEffect.ApplyToNames.AddItem('NanoMedikit');

	// Create the template using a helper function
	Template = Passive('F_FieldMedic', "img:///UILibrary_PerkIcons.UIPerk_fieldmedic", default.FIELDMEDIC_AWC, BonusItemEffect);

	return Template;
}

// Stimulate
// (AbilityName="F_Stimulate")
// Once per turn, you may remove mental impairments from a nearby ally.
static function X2AbilityTemplate Stimulate()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
    local X2Condition_UnitProperty              TargetCondition;
    local X2Condition_UnitStatCheck             UnitStatCheckCondition;

	// Removes most mental effects
	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);

	// Create template using a helper function
	Template = TargetedBuff('F_Stimulate', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Stimulate", false, RemoveEffects, class'UIUtilities_Tactical'.const.MEDIKIT_HEAL_PRIORITY + 1, eCost_Single);
    
    // TargetedBuff() adds a condition that the target must be living; we need to remove that because Unconscious targets are not considered to be living
    Template.AbilityTargetConditions.Length = 0;

    // Restore action points to a stunned target
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints'); 

	// Once per turn
	AddCooldown(Template, 1);

	// Target must be suffering from a mental impairment
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_RevivalProtocol');
    
    // Target must be within range and friendly
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.ExcludeDead = false; //See comment below...
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = 144;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);
    
    // Target must be visible
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.bLimitTargetIcons = true;
	Template.ActivationSpeech = 'StabilizingAlly';
    
	Template.CustomFireAnim = 'HL_Revive';
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

// Bloodlet
// (AbilityName="F_Bloodlet")
// Standard shots from your primary weapon or a pistol now cause bleeding.
static function X2AbilityTemplate Bloodlet()
{
	local X2AbilityTemplate Template;

	// Start with the passive template
	Template = Passive('F_Bloodlet', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Bloodlet", default.BLOODLET_AWC, none);
	
	return Template;
}

// Added to StandardShot in OnPostTemplatesCreated()
static function X2Effect_Persistent BloodletEffect()
{
	local X2Effect_Persistent		    Effect;
	local X2Condition_AbilityProperty   Condition;

    // Create the bleed status effect
    Effect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BLOODLET_DURATION, default.BLOODLET_TICK_DAMAGE);
	Effect.ApplyChance = default.BLOODLET_BLEEDING_CHANCE_PERCENT;

    // Only apply if shooter has Bloodlet passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_Bloodlet');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Blinding Fire
// (AbilityName="F_BlindingFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire at enemies in a cone. This attack is inaccurate, but reduces the aim of all targets.
static function X2AbilityTemplate BlindingFire()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Shredder					WeaponDamageEffect;
    local X2Effect_PersistentStatChange     AimPenaltyEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_BlindingFire');

	// Boilerplate setup
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_shot_rifle";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
    Template.bCrossClassEligible = default.BLINDINGFIRE_AWC;

	// Boilerplate setup
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	
	// Ammo effects apply
	Template.bAllowAmmoEffects = true;

	// Requires one action point and ends turn
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Configurable ammo cost
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.BLINDINGFIRE_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Configurable cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BLINDINGFIRE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Can hurt allies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Cannot be used while disoriented, burning, etc.
	Template.AddShooterEffectExclusions();

	// Standard aim calculation
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.bOverrideAim = false;

	// Manual targetting
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	// Can shred
	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bFragileDamageOnly = true;
	Template.bCheckCollision = true;
	
	// Add miss target damage
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

    // Reduces the targets' aim
	AimPenaltyEffect = new class'X2Effect_PersistentStatChange';
	AimPenaltyEffect.EffectName = 'F_BlindingFire_AimPenalty';
	AimPenaltyEffect.DuplicateResponse = eDupe_Refresh;
	AimPenaltyEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	AimPenaltyEffect.AddPersistentStatChange(eStat_Offense, default.BLINDINGFIRE_TARGET_AIM_PENALTY);
	AimPenaltyEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	AimPenaltyEffect.VisualizationFn = EffectFlyOver_Visualization;
	AimPenaltyEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(AimPenaltyEffect);
	Template.AddMultiTargetEffect(AimPenaltyEffect);

	// Cone style target, does not go through full cover
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.BLINDINGFIRE_CONE_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength = default.BLINDINGFIRE_CONE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	// Standard visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	// Add a secondary ability to provide an aim penalty for the shooter on the shot
	AddSecondaryAbility(Template, BlindingFireMalus());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// This is part of the Blinding Fire effect, above
static function X2AbilityTemplate BlindingFireMalus()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'F_BlindingFire_Malus';
    
	// The effect modifies aim
	Effect.AddToHitModifier(default.BLINDINGFIRE_SOURCE_AIM_PENALTY, eHit_Success);

	// The effect only applies to the Blinding Fire ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('F_BlindingFire');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('F_BlindingFire_Malus', "img:///UILibrary_XPerkIconPack.UIPerk_shot_rifle", false, Effect);

	// Hide the icon for the passive aim penalty
	HidePerkIcon(Template);

	return Template;
}

// Quick Feet
// (AbilityName="F_QuickFeet")
// Refunds one action point when you are revealed from concealment via your own action.
static function X2AbilityTemplate QuickFeet()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RefundConcealmentBreakingAction					QuickFeetEffect;

	// Quick Feet Effect
	QuickFeetEffect = new class'X2Effect_RefundConcealmentBreakingAction';
	QuickFeetEffect.EffectName = 'F_QuickFeet';
	
	Template = Passive('F_QuickFeet', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_move", default.QUICKFEET_AWC, QuickFeetEffect);
	
	return Template;
}

// Combat Druges
// (AbilityName="F_CombatDrugs")
// Your smoke grenades confer bonuses to aim and critical chance.
static function X2AbilityTemplate CombatDrugs()
{
	return Passive('F_CombatDrugs', "img:///UILibrary_XPerkIconPack.UIPerk_smoke_shot_2", default.COMBATDRUGS_AWC, none);
}

// Added to SmokeGrenade and SmokeBomb in OnPostTemplatesCreated()
static function X2Effect CombatDrugsEffect()
{
	local X2Effect_SmokeToHitModifiers Effect;
	local XMBCondition_SourceAbilities Condition;

	// Aim and crit bonuses
	Effect = new class'X2Effect_SmokeToHitModifiers';
	Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocCombatDrugsEffect, default.LocCombatDrugsEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_smoke_shot_2");
	Effect.AimMod = default.COMBATDRUGS_AIM;
	Effect.CritMod = default.COMBATDRUGS_CRIT;
	Effect.DuplicateResponse = eDupe_Refresh;

	// Only applies if the thrower has Combat Drugs
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('F_CombatDrugs', 'AA_UnitIsImmune');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Salt in the Wound
// (AbilityName="F_SaltInTheWound")
// All attacks deal increased damage to targets suffering from Burning, Poison, Acid, or Bleeding.
static function X2AbilityTemplate SaltInTheWound()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
    local X2Condition_UnitAffectedByPhysicalEffect Condition;

	// Create a conditional bonus effect that increases damage
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'F_SaltInTheWound_Damage';
	Effect.AddDamageModifier(default.SALTINTHEWOUND_DAMAGE_BONUS, eHit_Success);

    // Add a condition that the target must suffer from a physical effect
    Condition = new class'X2Condition_UnitAffectedByPhysicalEffect';
	Effect.AbilityTargetConditions.AddItem(Condition);
	
	// Create the template using a helper function
	Template = Passive('F_SaltInTheWound', "img:///UILibrary_FavidsPerkPack.UIPerk_SaltInTheWound", default.SALTINTHEWOUND_AWC, Effect);

	return Template;
}

// Unload
// (AbilityName="F_Unload", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire with the unit's primary weapon until out of ammo or the target is dead. Shots cannot critical. Cooldown-based.
static function X2AbilityTemplate Unload()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	// Start with basic attack template, with a 0 ammo cost because we're going to do that in a very specific way on our own
	Template = Attack('F_Unload', "img:///UILibrary_FavidsPerkPack.UIPerk_Unload", default.UNLOAD_AWC, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_WeaponConsumeAll, 0);
	
	// Cooldown
	AddCooldown(Template, default.UNLOAD_COOLDOWN);

	// Require 2 ammo to be present so that at least two shots can be taken
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Actually charge 1 ammo for this shot. Follow-up shots will charge the extra ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Custom aim bonus/malus and potentially disallow critical hits
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.UNLOAD_AIM_BONUS;
	ToHitCalc.bAllowCrit = default.UNLOAD_ALLOW_CRIT;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Now set the ability up for triggering the follow-up shots
	Template.AdditionalAbilities.AddItem('F_Unload2');
	Template.PostActivationEvents.AddItem('F_Unload2');

	// This should grant the damage modification effect that only applies to Unload
	Template.AdditionalAbilities.AddItem('F_UnloadDamage');

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate Unload2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;

	// Start with basic attack template
	Template = Attack('F_Unload2', "img:///UILibrary_FavidsPerkPack.UIPerk_Unload", false, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_None, 1);
	
	// Custom aim bonus/malus and potentially disallow critical hits
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.UNLOAD_AIM_BONUS;
	ToHitCalc.bAllowCrit = default.UNLOAD_ALLOW_CRIT;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Remove the activate ability trigger added by the Attack helper function
	Template.AbilityTriggers.Length = 0;

	// Set the ability to trigger with a listener
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'F_Unload2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	// Now set the ability up for triggering the follow-up shots
	Template.PostActivationEvents.AddItem('F_Unload2');
	Template.CinescriptCameraType = "StandardGunFiring";

	// We don't want this ability to actually show up to the user
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	// Show a flyover for each follow-up shot
	Template.bShowActivation = true;
	
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	return Template;
}

static function X2AbilityTemplate UnloadDamageBonus()
{
    local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'F_Unload_Bonuses';
    
	// The bonus reduces damage by a percentage
	Effect.AddPercentDamageModifier(-1 * default.UNLOAD_DAMAGE_PERCENT_MALUS);

	// The bonus only applies to the Unload ability and its follow-up shots
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('F_Unload');
	Condition.IncludeAbilityNames.AddItem('F_Unload2');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('F_UnloadDamage', "img:///UILibrary_FavidsPerkPack.UIPerk_Unload", false, Effect);

	// Unload will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

    return Template;
}

// Ambush
// (AbilityName="F_Ambush", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Take a reaction shot against any enemy that moves or attacks within a cone of fire. Can only be used while concealed.
static function X2AbilityTemplate Ambush()
{
	local X2AbilityTemplate                 Template;
    local X2Effect                          Effect;
    local X2Effect_MarkValidActivationTiles MarkTilesEffect;

    // Start with a copy of KillZone
    Template = class'X2Ability_SharpshooterAbilitySet'.static.KillZone('F_Ambush', false);
    
    // Use our own icon
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_stealth_overwatch";

    // Only usable while concealed
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_Concealed');

    // Modify it to use our AmbushShot ability instead of KillZoneShot
    foreach Template.AbilityShooterEffects(Effect)
    {
        MarkTilesEffect = X2Effect_MarkValidActivationTiles(Effect);
        if(MarkTilesEffect != none)
        {
            MarkTilesEffect.AbilityToMark = 'F_AmbushShot';
            break;
        }
    }

    // Use our own configuration value for the cooldown
    AddCooldown(Template, default.AMBUSH_COOLDOWN);

    // Remove the additional KillZoneShot ability and use our own AmbushShot instead
    Template.AdditionalAbilities.Length = 0;
	Template.AdditionalAbilities.AddItem('F_AmbushShot');

    // Use our own configuration value for AWC setting
    Template.bCrossClassEligible = default.AMBUSH_AWC;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

// The Ambush shot - mostly a copy of KillZoneShot, but we want it to be able to fire while the shooter is concealed
static function X2AbilityTemplate AmbushShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_AbilityProperty       AbilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_Persistent               KillZoneEffect;
	local X2Condition_UnitEffectsWithAbilitySource  KillZoneCondition;
	local X2Condition_Visibility            TargetVisibilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_AmbushShot');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('KillZone');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.TargetMustBeInValidTiles = true;
	Template.AbilityTargetConditions.AddItem(AbilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//  Do not shoot targets that were already hit by this unit this turn with this ability
	KillZoneCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	KillZoneCondition.AddExcludeEffect('KillZoneTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(KillZoneCondition);
	//  Mark the target as shot by this unit so it cannot be shot again this turn
	KillZoneEffect = new class'X2Effect_Persistent';
	KillZoneEffect.EffectName = 'KillZoneTarget';
	KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	KillZoneEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(KillZoneEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

// Renewal
// (AbilityName="F_Renewal")
// At the start of each turn, heals yourself and all allies in a radius on you.
static function X2AbilityTemplate Renewal()
{
    local X2Effect_ApplyHeal                    Effect;
	local X2AbilityTemplate                     Template;
	local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              HealTargetCondition;
    
    // Effect that restores health
	Effect = new class'X2Effect_ApplyHeal';
	Effect.HealAmount = default.RENEWAL_HEALAMOUNT;
	Effect.MaxHealAmount = default.RENEWAL_MAXHEALAMOUNT;
	Effect.HealthRegeneratedName = 'RenewalHeal';

    // Activated ability that targets user
	Template = SelfTargetTrigger('F_Renewal', "img:///UILibrary_XPerkIconPack.UIPerk_medkit_blossom", default.RENEWAL_AWC, Effect, 'PlayerTurnBegun', eFilter_Player);
	
	// The ability targets the unit that has it, but also effects all nearby units that meet the conditions on the multitarget effect.
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.RENEWAL_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddMultiTargetEffect(Effect);

	// Does not activate while dead
	AddTriggerTargetCondition(Template, default.LivingShooterProperty);

    // Only affects living allies
	HealTargetCondition = new class'X2Condition_UnitProperty';
	HealTargetCondition.RequireWithinRange = true;
	HealTargetCondition.ExcludeHostileToSource = true;
	HealTargetCondition.ExcludeFriendlyToSource = false;
	HealTargetCondition.ExcludeFullHealth = true;
	HealTargetCondition.ExcludeDead = true; 
	Template.AbilityMultiTargetConditions.AddItem(HealTargetCondition);
    
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);
    
	return Template;
}

// Warning Shot
// (AbilityName="F_WarningShot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire your primary weapon just over the target's head, causing them to panic. This attack deals no damage.
static function X2AbilityTemplate WarningShot()
{
	local X2AbilityTemplate Template;
	local X2Effect_Panicked Effect;

	// Effect
	Effect = new class'X2Effect_Panicked';
	Effect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	
	// Create the template using a helper function
	Template = Attack('F_WarningShot', "img:///UILibrary_FavidsPerkPack.Perk_Ph_WarningShot", default.WARNINGSHOT_AWC, Effect, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_WeaponConsumeAll, default.WARNINGSHOT_AMMO_COST);
    
	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;

	// Charges
	AddCharges(Template, default.WARNINGSHOT_CHARGES);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Open Fire
// (AbilityName="F_OpenFire")
// Gain bonus Aim and Critical Chance against targets that are at full health.
static function X2AbilityTemplate OpenFire()
{
	local X2AbilityTemplate Template;
    local X2Condition_UnitStatCheck Condition;
	local XMBEffect_ConditionalBonus Effect;

    // Aim and crit bonus
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.OPENFIRE_AIM, eHit_Success);
	Effect.AddToHitModifier(default.OPENFIRE_CRIT, eHit_Crit);
    
    // Only applies to full health targets
    Condition = new class'X2Condition_UnitStatCheck';
    Condition.AddCheckStat(eStat_HP, 100, eCheck_Exact, 100, 100, true);
	Effect.AbilityTargetConditions.AddItem(Condition);

	Template = Passive('F_OpenFire', "img:///UILibrary_XPerkIconPack.UIPerk_stabilize_shot_2", default.OPENFIRE_AWC, Effect);

    return Template;
}

// Havoc
// (AbilityName="F_Havoc", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Your Suppression and Area Suppression abilities now deal a small amount of damage to the primary target.
static function X2AbilityTemplate Havoc()
{
	local X2AbilityTemplate Template;
	local X2Effect_SuppressionDamage Effect;
	local XMBAbilityTrigger_EventListener EventListener;
	local XMBCondition_AbilityName NameCondition;
	local WeaponDamageValue DamageValue;

	// Base damage of 0 - X2Effect_SuppressionDamage will add damage for the weapon tier used
    DamageValue.Damage = 0;

	Effect = new class'X2Effect_SuppressionDamage';
    Effect.EffectDamageValue = DamageValue;
	Effect.Damage = default.HAVOC_DAMAGE;
	Effect.WeaponTech = default.HAVOC_WEAPON_TECH;

	Template = TargetedDebuff('F_Havoc', "img:///UILibrary_FavidsPerkPack.UIPerk_Mayhem", default.HAVOC_AWC, none,, eCost_None);
	Template.AddTargetEffect(Effect);

    Template.CustomFireAnim = '';

	Template.AbilityShooterConditions.Length = 0;
	Template.AbilityTargetConditions.Length = 0;

	HidePerkIcon(Template);
	AddIconPassive(Template);

	Template.AbilityTriggers.Length = 0;
	
	EventListener = new class'XMBAbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.bSelfTarget = false;
	Template.AbilityTriggers.AddItem(EventListener);

	NameCondition = new class'XMBCondition_AbilityName';
    NameCondition.IncludeAbilityNames.AddItem('Suppression');
    NameCondition.IncludeAbilityNames.AddItem('LW2WotC_AreaSuppression');
    NameCondition.IncludeAbilityNames.AddItem('Suppression_LW');
    NameCondition.IncludeAbilityNames.AddItem('AreaSuppression');
	EventListener.AbilityTargetConditions.AddItem(NameCondition);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
    
	return Template;
}

// Added to Suppression and LW2WotC_AreaSuppression in OnPostTemplatesCreated()
static function bool HavocDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Ability HavocAbility;
	local XComGameState_Unit OwnerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	OwnerState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	HavocAbility = XComGameState_Ability(History.GetGameStateForObjectID(OwnerState.FindAbility('F_Havoc').ObjectID));

    if(HavocAbility != none)
    {
        HavocAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
        return true;
    }

	return false;
}

// Finesse
// (AbilityName="F_Finesse")
// Your first melee attack each turn will have its actions refunded. Passive.
static function X2AbilityTemplate Finesse()
{
    local XMBEffect_AbilityCostRefund Effect;

	// Create an effect that will refund the cost of attacks
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'F_Finesse_Refund';
	Effect.TriggeredEvent = 'F_Finesse_Refund';

	// Only refund once per turn
	Effect.CountValueName = 'F_Finesse_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	// The bonus only applies to melee attacks
	Effect.AbilityTargetConditions.AddItem(default.MeleeCondition);

	// Create the template using a helper function
	return Passive('F_Finesse', "img:///UILibrary_XPerkIconPack.UIPerk_knife_chevron", default.FINESSE_AWC, Effect);
}

// Shoulder to Lean On
// (AbilityName="F_ShoulderToLeanOn")
// Allies in a small radius around you gain bonus Aim. This bonus is increased when Shield Wall is used.
static function X2AbilityTemplate ShoulderToLeanOn()
{
	local X2AbilityTemplate             Template;
	local X2Effect_ToHitBonusAOE               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_ShoulderToLeanOn');

	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_shield_shot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_ToHitBonusAOE';
	Effect.EffectName = 'F_ShoulderToLeanOn';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.ToHitBonus = default.SHOULDERTOLEANON_AIM_BONUS;
	Effect.ToHitBonusWithShieldWall = default.SHOULDERTOLEANON_AIM_BONUS_WITH_SHIELDWALL;
	Effect.AOEDistanceSquared = default.SHOULDERTOLEANON_RADIUS;
    Effect.IncludeOwner = false;
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('F_ShoulderToLeanOn_Passive');

	Template.bCrossClassEligible = default.SHOULDERTOLEANON_AWC;
	
	return Template;
}

static function X2AbilityTemplate ShoulderToLeanOnPassive()
{
	return PurePassive('F_ShoulderToLeanOn_Passive', "img:///UILibrary_XPerkIconPack.UIPerk_shield_shot", , 'eAbilitySource_Perk');
}

// Protect and Serve
// (AbilityName="F_ProtectAndServe")
// Gain a non-movement action point after using Shield Wall
static function X2AbilityTemplate ProtectAndServe()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
    local XMBCondition_AbilityName NameCondition;

	// Effect adds a Run and Gun action point
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('F_ProtectAndServe', "img:///UILibrary_XPerkIconPack.UIPerk_defense_chevron", default.PROTECTANDSERVE_AWC, Effect, 'AbilityActivated');

	// Only trigger with Shield Wall
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('ShieldWall');
	AddTriggerTargetCondition(Template, NameCondition);

    return Template;
}

// Bolstered Wall
// (AbilityName="F_BolsteredWall")
// While Shield Wall is active, gain a bonus to Dodge.
static function X2AbilityTemplate BolsteredWall()
{
	return PurePassive('F_BolsteredWall', "img:///UILibrary_XPerkIconPack.UIPerk_defense_move2", , 'eAbilitySource_Perk');
}

// Added to ShieldWall in OnPostTemplatesCreated()
static function X2Effect_PersistentStatChange BolsteredWallEffect()
{
    local X2Effect_PersistentStatChange		    Effect;
	local X2Condition_AbilityProperty   Condition;

    // Create the dodge bonus effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_BolsteredWall_Bonus';
	Effect.AddPersistentStatChange(eStat_Dodge, default.BOLSTEREDWALL_DODGE_BONUS);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocBolsteredWallEffect, default.LocBolsteredWallEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_defense_move2", true, , 'eAbilitySource_Perk');

    // Only apply if user has the Bolstered Wall passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_BolsteredWall');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Faultless Defense
// (AbilityName="F_FaultlessDefense")
// While Shield Wall is active, you cannot be critically hit
static function X2AbilityTemplate FaultlessDefense()
{
	return PurePassive('F_FaultlessDefense', "img:///UILibrary_XPerkIconPack.UIPerk_defense_crit2", , 'eAbilitySource_Perk');
}

// Added to ShieldWall in OnPostTemplatesCreated()
static function X2Effect_CannotBeCrit FaultlessDefenseEffect()
{
    local X2Effect_CannotBeCrit		    Effect;
	local X2Condition_AbilityProperty   Condition;

    // Create the crit protection effect
    Effect = new class'X2Effect_CannotBeCrit';
	Effect.EffectName = 'F_Faultless_CritProtection';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocFaultlessDefenseEffect, default.LocFaultlessDefenseEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_defense_crit2", true, , 'eAbilitySource_Perk');

    // Only apply if user has the Faultless Defense passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_FaultlessDefense');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Adrenaline
// (AbilityName="F_Adrenaline")
// Kills grant Shield. Passive.
static function X2AbilityTemplate Adrenaline()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange Effect;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Condition_UnitValue ValueCondition;
	local X2Effect_IncrementUnitValue IncrementEffect;
    
	// Create a persistent stat change effect that grants a mobility bonus
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_Adrenaline';
	Effect.AddPersistentStatChange(eStat_ShieldHP, default.ADRENALINE_SHIELD);
	Effect.DuplicateResponse = eDupe_Allow;
	Effect.BuildPersistentEffect(1, true, true, false);

	// Create a triggered ability that activates whenever the unit gets a kill
	Template = SelfTargetTrigger('F_Adrenaline', "img:///UILibrary_XPerkIconPack.UIPerk_shield_plus", default.ADRENALINE_AWC, Effect, 'KillMail');

	// Does not trigger when killing Lost
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost');
	AddTriggerTargetCondition(Template, UnitTypeCondition);
    
	// Limit activations
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_Adrenaline_Activations', default.ADRENALINE_ACTIVATIONS_PER_MISSION, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    // Create an effect that will increment the unit value
	IncrementEffect = new class'X2Effect_IncrementUnitValue';
	IncrementEffect.UnitName = 'F_Adrenaline_Activations';
	IncrementEffect.NewValueToSet = 1; // This means increment by one -- stupid property name
	IncrementEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(IncrementEffect);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when activated
	Template.bShowActivation = true;

	return Template;
}

// Watch Them Run
// (AbilityName="F_WatchThemRun", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// If you have thrown or launched a grenade this turn, automatically enter overwatch at the end of the turn.
static function X2AbilityTemplate WatchThemRun()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_PrimaryWeapon   AmmoCondition;
	local XMBCondition_AbilityName   NameCondition;
    local X2Effect_AddOverwatchActionPoints   Effect;
    local X2Condition_UnitValue ValueCondition;
    local X2Effect_IncrementUnitValue IncrementEffect;
	
    // Effect granting an overwatch shot
	Effect = new class'X2Effect_AddOverwatchActionPoints';
    
	Template = SelfTargetTrigger('F_WatchThemRun', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_grenade", default.WATCHTHEMRUN_AWC, Effect, 'AbilityActivated');
    Template.bShowActivation = true;

	// Only when Throw/Launch Grenade abilities are used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('ThrowGrenade');
	NameCondition.IncludeAbilityNames.AddItem('LaunchGrenade');
	AddTriggerTargetCondition(Template, NameCondition);

    // Require that the user has ammo left
	AmmoCondition = new class'X2Condition_PrimaryWeapon';
	AmmoCondition.AddAmmoCheck(0, eCheck_GreaterThan);
	AddTriggerTargetCondition(Template, AmmoCondition);
    
	// Limit activations
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('F_WatchThemRun_Activations', default.WATCHTHEMRUN_ACTIVATIONS_PER_TURN, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    // Create an effect that will increment the unit value
	IncrementEffect = new class'X2Effect_IncrementUnitValue';
	IncrementEffect.UnitName = 'F_WatchThemRun_Activations';
	IncrementEffect.NewValueToSet = 1; // This means increment by one -- stupid property name
	IncrementEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(IncrementEffect);
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

// Cover Area
// (AbilityName="F_CoverArea")
// Allies within 2 tiles receive half damage from explosives. Passive.
static function X2AbilityTemplate CoverArea()
{
	local X2AbilityTemplate             Template;
	local X2Effect_ReduceExplosiveDamage               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_CoverArea');
	
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_grenade_defense2";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_ReduceExplosiveDamage';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.ExplosiveDamageReduction = default.COVERAREA_EXPLOSIVE_DAMAGE_REDUCTION;
	Effect.AOEDistanceSquared = default.COVERAREA_RADIUS;
    Effect.IncludeOwner = true;
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('F_CoverArea_Passive');

	return Template;
}

static function X2AbilityTemplate CoverAreaPassive()
{
	return PurePassive('F_CoverArea_Passive', "img:///UILibrary_XPerkIconPack.UIPerk_grenade_defense2", , 'eAbilitySource_Perk');
}

// Outlaw
// (AbilityName="F_Outlaw")
// Gain bonus mobility for each enemy you can see, up to a specified maximum.
//static function X2AbilityTemplate Outlaw()
//{
	//local XMBEffect_ConditionalStatChange Effect;
	//local XMBValue_Visibility Value;
	 //
	//// Create a value that will count the number of visible units
	//Value = new class'XMBValue_Visibility';
//
	//// Only count enemy units
	//Value.bCountEnemies = true;
//
	//// Create a conditional stat change effect
	//Effect = new class'XMBEffect_ConditionalStatChange';
	//Effect.EffectName = 'F_Outlaw_Bonus';
	//Effect.DuplicateResponse = eDupe_Ignore;
//
	//// The effect adds Mobility per enemy unit
	//Effect.AddPersistentStatChange(eStat_Mobility, OUTLAW_MOBILITY_BONUS);
//
	//// The effect scales with the number of visible enemy units, to a maximum
	//Effect.ScaleValue = Value;
	//Effect.ScaleMax = default.OUTLAW_SCALE_MAX;
//
	//// Create the template using a helper function
	//return Passive('F_Outlaw', "", default.OUTLAW_AWC, Effect);
//}

// Rally
// (AbilityName="F_Rally")
// Grants Shield to yourself and all allies around you.
static function X2AbilityTemplate Rally()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCharges Charges;
	local X2AbilityCost_Charges ChargeCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_GrantShields ShieldedEffect;
	local X2AbilityMultiTarget_Radius MultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Rally');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.RALLY_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.RALLY_RADIUS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield receives a shield
	ShieldedEffect = new class'X2Effect_GrantShields';
	ShieldedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	ShieldedEffect.ConventionalAmount = default.RALLY_SHIELD_CV;
	ShieldedEffect.MagneticAmount = default.RALLY_SHIELD_MG;
	ShieldedEffect.BeamAmount = default.RALLY_SHIELD_BM;
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.VisualizationFn = EffectFlyOver_Visualization;

	Template.AddTargetEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    
	Template.CustomFireAnim = 'HL_SignalPoint';

	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

// Shield Trauma
// (AbilityName="F_ShieldTrauma", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Upgrade to Shield Bash that stuns the target for one action in addition to disorienting them.
static function X2AbilityTemplate ShieldTrauma()
{
	local X2AbilityTemplate                 Template;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('F_ShieldTrauma');

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));
    
	Template.OverrideAbilities.AddItem('ShieldBash');

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Avenger
// (AbilityName="F_Avenger", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// When an ally within a small radius is shot at, you will automatically take a Pistol shot back at the shooter.
static function X2AbilityTemplate Avenger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFireAOE                FireEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Avenger');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_pistol_circle";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFireAOE';
    FireEffect.RequiredAllyRange = default.AVENGER_RADIUS;
    FireEffect.bAllowSelf = false;
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	// Although the ability name is PistolReturnFire, it will work with any gun
	Template.AdditionalAbilities.AddItem('PistolReturnFire');

	Template.bCrossClassEligible = false;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Fire First
// (AbilityName="F_FireFirst", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// When an enemy attempts to shoot at you, you will pre-emptively take a Pistol shot at them.
static function X2AbilityTemplate FireFirst()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_FireFirst');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_pistol_cycle";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFire';
    FireEffect.bPreEmptiveFire = true;
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.AdditionalAbilities.AddItem('PistolReturnFire');

	Template.bCrossClassEligible = false;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Flatline
// (AbilityName="F_Flatline", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire a shot with your primary weapon that deals additional damage and applies Rupture.
static function X2AbilityTemplate Flatline()
{
	local X2AbilityTemplate Template;
	local X2Effect_ApplyWeaponDamage Effect;

    // Standard damage effect that also applies Rupture
	Effect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	Effect.EffectDamageValue.Rupture = default.FLATLINE_RUPTURE;
	
	// Create the template using a helper function
	Template = Attack('F_Flatline', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Flatline", default.FLATLINE_AWC, Effect, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_WeaponConsumeAll, default.FLATLINE_AMMO_COST);
    
    // Standard attack effects for holotarget and weapon miss damage
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Cooldown
	AddCooldown(Template, default.FLATLINE_COOLDOWN);

    // Secondary ability that grants a damage bonus
    AddSecondaryAbility(Template, FlatlineDamageBonus());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate FlatlineDamageBonus()
{
    local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'F_Flatline_Bonuses';
    
	// The bonus reduces damage by a percentage
	Effect.AddDamageModifier(default.FLATLINE_DAMAGE_BONUS);

	// The bonus only applies to the Flatline ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('F_Flatline');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('F_Flatline_Damage', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Flatline", false, Effect);

	// Flatline will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

    return Template;
}

// Cold Blooded
// (AbilityName="F_ColdBlooded")
// The first standard shot you take against an enemy suffering from bleeding, poison, burning, or acid burning does not cost an action.
static function X2AbilityTemplate ColdBlooded()
{
    local XMBEffect_AbilityCostRefund               Effect;
	local XMBCondition_AbilityName                  AbilityNameCondition;
    local X2Condition_UnitAffectedByPhysicalEffect  StatusEffectCondition;
	
	// Create an effect that will refund the cost of attacks
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'F_ColdBlooded_Refund';
	Effect.TriggeredEvent = 'F_ColdBlooded_Refund';
	Effect.CountValueName = 'F_ColdBlooded_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	// The refund only applies to standard shots
	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames.AddItem('StandardShot');
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

    // Target must suffer from a physical status effect
    StatusEffectCondition = new class'X2Condition_UnitAffectedByPhysicalEffect';
	Effect.AbilityTargetConditions.AddItem(StatusEffectCondition);

	// Create the template using a helper function
	return Passive('F_ColdBlooded', "img:///UILibrary_FavidsPerkPack.Perk_Ph_ColdBlooded", default.COLDBLOODED_AWC, Effect);
}

// Predator
// (AbilityName="F_Predator")
// Grants an aim bonus on enemies that are flanked or out of cover. Passive.
static function X2AbilityTemplate Predator()
{
	local XMBEffect_ConditionalBonus Effect;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(default.PREDATOR_AIM_BONUS, eHit_Success);
	Effect.AddToHitModifier(default.PREDATOR_CRIT_BONUS, eHit_Crit);

	// The bonus only applies while flanking
	Effect.AbilityTargetConditions.AddItem(default.FlankedCondition);

	// Create the template using a helper function
	return Passive('F_Predator', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Predator", default.PREDATOR_AWC, Effect);
}

// Survivor
// (AbilityName="F_Survivor")
// Ensures the first killing blow in a mission will not lead to instant death. Also reduces this soldier's wound recovery time.
static function X2AbilityTemplate Survivor()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_GuaranteeBleedout GuaranteeBleedoutEffect;
	local X2Effect_ReduceSelfWoundTime ReduceSelfWoundTimeEffect;

	// Create the template using a helper function
	Template = Passive('F_Survivor', "img:///UILibrary_FavidsPerkPack.Perk_Ph_WellProtected", default.SURVIVOR_AWC, none);

	GuaranteeBleedoutEffect = new class'X2Effect_GuaranteeBleedout';
	GuaranteeBleedoutEffect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(GuaranteeBleedoutEffect);

	ReduceSelfWoundTimeEffect = new class'X2Effect_ReduceSelfWoundTime';
	ReduceSelfWoundTimeEffect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(ReduceSelfWoundTimeEffect);

    return Template;
}

// Regenerative Mist
// (AbilityName="F_RegenerativeMist")
// Your smoke grenades grant a health restoration effect to all targets in the smoke cloud. Passive.
static function X2AbilityTemplate RegenerativeMist()
{
	return Passive('F_RegenerativeMist', "img:///UILibrary_XPerkIconPack.UIPerk_smoke_medkit", default.REGENERATIVEMIST_AWC, none);
}

// Added to SmokeGrenade and SmokeBomb in OnPostTemplatesCreated()
static function X2Effect RegenerativeMistEffect()
{
	local X2Effect_SmokeRegeneration Effect;
	local XMBCondition_SourceAbilities Condition;

	// Health regen in smoke
	Effect = new class'X2Effect_SmokeRegeneration';
	Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocRegenerativeMistEffect, default.LocRegenerativeMistEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_smoke_medkit");
	Effect.HealAmount = default.REGENERATIVEMIST_HEAL_PER_TURN;
	Effect.MaxHealAmount = default.REGENERATIVEMIST_MAX_HEAL_AMOUNT;
	Effect.HealthRegeneratedName = 'F_RegenerativeMist_Healing';
	Effect.DuplicateResponse = eDupe_Refresh;

	// Only applies if the thrower has Regenerative Mist
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('F_RegenerativeMist', 'AA_UnitIsImmune');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Controlled Fire
// (AbilityName="F_ControlledFire")
// Additional shots fired from Area Suppression no longer cost ammo.
static function X2AbilityTemplate ControlledFire()
{
	return Passive('F_ControlledFire', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_bullet", default.CONTROLLEDFIRE_AWC, none);
}

// Added to LW2WotC_AreaSuppressionShot in OnPostTemplatesCreated()
static function X2AbilityCost_Ammo ControlledFireAmmoCost(X2AbilityCost_Ammo OriginalAmmoCost)
{
	local X2AbilityCost_Ammo NewAmmoCost;

	NewAmmoCost = new class'X2AbilityCost_Ammo_ControlledFire';
	NewAmmoCost.iAmmo = OriginalAmmoCost.iAmmo;
	NewAmmoCost.UseLoadedAmmo = OriginalAmmoCost.UseLoadedAmmo;
	NewAmmoCost.bReturnChargesError = OriginalAmmoCost.bReturnChargesError;
	NewAmmoCost.bConsumeAllAmmo = OriginalAmmoCost.bConsumeAllAmmo;

	return NewAmmoCost;
}

// Stiletto
// (AbilityName="F_Stiletto", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Shots with your primary weapon will now pierce armor.
static function X2AbilityTemplate Stiletto()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'F_Stiletto_Bonuses';
	ShootingEffect.AddArmorPiercingModifier(default.STILETTO_ARMOR_PIERCING);

	// Only with the associated weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('F_Stiletto', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Needle", default.STILETTO_AWC, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Stay Covered
// (AbilityName="F_StayCovered")
// Shield Wall no longer lowers your defense.
static function X2AbilityTemplate StayCovered()
{
	return PurePassive('F_StayCovered', "img:///UILibrary_XPerkIconPack.UIPerk_defense_plus", default.STAYCOVERED_AWC, 'eAbilitySource_Perk');
}

// Added to ShieldWall in OnPostTemplatesCreated()
static function X2Effect_PersistentStatChange StayCoveredEffect()
{
    local X2Effect_PersistentStatChange		    Effect;
	local X2Condition_AbilityProperty   Condition;

    // Create the bonus effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_StayCovered_Bonus';
	Effect.AddPersistentStatChange(eStat_Defense, default.STAYCOVERED_DEFENSE_BONUS);
	Effect.AddPersistentStatChange(eStat_Dodge, default.STAYCOVERED_DODGE_BONUS);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocStayCoveredEffect, default.LocStayCoveredEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_defense_plus", true, , 'eAbilitySource_Perk');

    // Only apply if user has the Stay Covered passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_StayCovered');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Indomitable
// (AbilityName="F_Indomitable")
// Become Untouchable for one turn.
static function X2AbilityTemplate Indomitable()
{
	local X2AbilityTemplate                     Template;
    local X2Effect_DamageImmune                 Effect;

    // Effect granting immunity until next turn
    Effect = new class'X2Effect_DamageImmune';
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	// Activated ability that targets user
	Template = SelfTargetActivated('F_Indomitable', "img:///UILibrary_XPerkIconPack.UIPerk_star_defense2", default.INDOMITABLE_AWC, Effect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Single);
	
	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Show a flyover when activated
	Template.bShowActivation = true;

    // Charges
    AddCharges(Template, default.INDOMITABLE_CHARGES);

	return Template;
}

// Perfect Guard
// (AbilityName="F_PerfectGuard")
// Gain Armor while Shield Wall is active
static function X2AbilityTemplate PerfectGuard()
{
	return PurePassive('F_PerfectGuard', "img:///UILibrary_XPerkIconPack.UIPerk_defense_blaze", default.PERFECTGUARD_AWC, 'eAbilitySource_Perk');
}

// Added to ShieldWall in OnPostTemplatesCreated()
static function X2Effect_PersistentStatChange PerfectGuardEffect()
{
    local X2Effect_PersistentStatChange		    Effect;
	local X2Condition_AbilityProperty   Condition;

    // Create the bonus effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_PerfectGuard_Bonus';
	Effect.AddPersistentStatChange(eStat_ArmorMitigation, default.PERFECTGUARD_ARMOR_BONUS);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocPerfectGuardEffect, default.LocPerfectGuardEffectDescription, "img:///UILibrary_XPerkIconPack.UIPerk_defense_blaze", true, , 'eAbilitySource_Perk');

    // Only apply if user has the Perfect Guard passive
	Condition = new class'X2Condition_AbilityProperty';
	Condition.OwnerHasSoldierAbilities.AddItem('F_PerfectGuard');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}

// Shield Regeneration
// (AbilityName="F_ShieldRegeneration")
// Gain Shield at the beginning of each turn if your current Shield is below the specified value
static function X2AbilityTemplate ShieldRegeneration()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentStatChange			Effect;
	local X2Condition_UnitStatCheck				UnitStatCheckCondition;

    // Triggered ability that activates at the start of eaech player turn that targets owner
	Template = SelfTargetTrigger('F_ShieldRegeneration', "img:///UILibrary_XPerkIconPack.UIPerk_shield_cycle", default.SHIELDREGENERATION_AWC, none, 'PlayerTurnBegun', eFilter_Player);

    // Create the bonus effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_ShieldRegeneration_Bonus';
	Effect.AddPersistentStatChange(eStat_ShieldHP, default.SHIELDREGENERATION_SHIELD);
	Effect.DuplicateResponse = eDupe_Allow;
	Effect.BuildPersistentEffect(1, true, true, false);
	Template.AddTargetEffect(Effect);

	// Does not activate while dead
	AddTriggerTargetCondition(Template, default.LivingShooterProperty);

	// Only activates when shield is below a threshold
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_ShieldHP, default.SHIELDREGENERATION_SHIELD_MAX, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);
    
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);
    
	return Template;
}

// Calm Mind
// (AbilityName="F_CalmMind")
// Permanently increases your Psi Offense and Will
static function X2AbilityTemplate CalmMind()
{
	local X2AbilityTemplate                     Template;
	local X2Effect_PersistentStatChange			Effect;

    // Create the bonus effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'F_CalmMind_Bonus';
	Effect.AddPersistentStatChange(eStat_PsiOffense, default.CALMMIND_PSI);
	Effect.AddPersistentStatChange(eStat_Will, default.CALMMIND_WILL);
	Effect.DuplicateResponse = eDupe_Ignore;

    // Activated ability that targets user
	Template = Passive('F_CalmMind', "img:///UILibrary_XPerkIconPack.UIPerk_mind_plus", default.CALMMIND_AWC, Effect);
    
	return Template;
}

// Suppressing Fire
// (AbilityName="F_SuppressingFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire a standard shot. If the shot does not kill the target, then suppress them
static function X2AbilityTemplate SuppressingFire()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;

	// Start with basic attack template
	Template = Attack('F_SuppressingFire', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2", default.SUPPRESSINGFIRE_AWC, none, , eCost_WeaponConsumeAll, 0);
	
	// Require 3 ammo to be present so that the shot and suppression can be used
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Actually charge 1 ammo for this shot. Follow-up shots will charge the extra ammo if necessary
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Now set the ability up for triggering the follow-up suppression
	Template.PostActivationEvents.AddItem('Suppressing');
	
	// Add an ability that will add an action point if the target is not killed, so that suppression can actually be used
	Template.AdditionalAbilities.AddItem('F_SuppressingFire_AddActions');

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate SuppressingFireAddActions()
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrantActionPoints Effect;
	local XMBCondition_AbilityName NameCondition;
	
	// Effect adds a Run and Gun action point
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	
	// Create a triggered ability that will activate whenever the unit takes an action
	Template = SelfTargetTrigger('F_SuppressingFire_AddActions', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2", false, Effect, 'AbilityActivated', eFilter_Unit, 75);
	
	// Only when Suppressing Fire is used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('F_SuppressingFire');
	AddTriggerTargetCondition(Template, NameCondition);

	// Only if the target is still alive
	AddTriggerTargetCondition(Template, default.LivingHostileUnitDisallowMindControlProperty);
	
	// Only if the target is still visible
	AddTriggerTargetCondition(Template, default.GameplayVisibilityCondition);

	Template.BuildVisualizationFn = none;

	return Template;
}

// Put 'Em Down
// (AbilityName="F_PutEmDown")
// Grants an aim bonus against targets that are stunned, disoriented, or panicked. Passive.
static function X2AbilityTemplate PutEmDown()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitAffectedByMentalEffect StatusEffectCondition;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim
	Effect.AddToHitModifier(default.PUTEMDOWN_AIM, eHit_Success);

    // Target must suffer from a mental status effect
    StatusEffectCondition = new class'X2Condition_UnitAffectedByMentalEffect';
	Effect.AbilityTargetConditions.AddItem(StatusEffectCondition);

	// Create the template using a helper function
	return Passive('F_PutEmDown', "img:///UILibrary_XPerkIconPack.UIPerk_mind_shot", default.PUTEMDOWN_AWC, Effect);
}

// Will to Survive
// (AbilityName="F_WilltoSurvive")
// Grants a bonus to Armor and Dodge. Passive.
static function X2AbilityTemplate WillToSurvive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatEffect;
	
	// Effect with the stat bonuses
	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_ArmorMitigation, float(default.WILLTOSURVIVE_ARMOR));
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.WILLTOSURVIVE_DODGE));

	// Create the template using a helper function
	Template = Passive('F_WilltoSurvive', "img:///UILibrary_LW_PerkPack.LW_AbilityWilltoSurvive", default.WILLTOSURVIVE_AWC, StatEffect);
	
	// Show the status bonuses in the armory
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, default.WILLTOSURVIVE_ARMOR);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.WILLTOSURVIVE_DODGE);

	return Template;
}

// Watchful Eye
// (AbilityName="F_WatchfulEye", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// You get a free overwatch shot when any target you have holotargeted moves or attacks.
static function X2AbilityTemplate WatchfulEye()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_Event Trigger;
	local X2Condition_UnitEffects Condition;
	local X2Condition_UnitProperty ShooterCondition;
	local X2Effect_Persistent MarkEffect;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;

	// Create the template with a helper function
	Template = Attack('F_WatchfulEye', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", default.WATCHFULEYE_AWC,,, eCost_None);
	HidePerkIcon(Template);
	AddIconPassive(Template);

	// Remove input trigger
	Template.AbilityTriggers.Length = 0;

	// Trigger when observing movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// Trigger when observing an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// Add standard overwatch effect conditions
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	// Can only fire on each target once per turn
	MarkEffect = new class'X2Effect_Persistent';
	MarkEffect.EffectName = 'F_WatchfulEye_Cooldown';
	MarkEffect.BuildPersistentEffect(1, false, false, true, eGameRule_PlayerTurnEnd);
	MarkEffect.bApplyOnHit = true;
	MarkEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(MarkEffect);

	// Has to be holotargeted by you, couldn't have been shot at yet by you
	Condition = new class'X2Condition_UnitEffectsWithAbilitySource';
	Condition.AddRequireEffect('LWHoloTarget', 'AA_Immune');
	Condition.AddExcludeEffect(MarkEffect.EffectName, 'AA_Immune');
	Template.AbilityTargetConditions.AddItem(Condition);

	// Don't shoot while concealed
	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	// Standard aim calculation for reaction shots
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = ToHitCalc;

	return Template;
}

// Guard
// (AbilityName="F_Guard", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Block the first attack made against you until next turn
static function X2AbilityTemplate Guard()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent                   Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Guard');

	// Boilerplate setup for this passive ability
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parry";
	
	// Add the active ability that grants the Guard effect
	Template.AdditionalAbilities.AddItem('F_Guard_Activate');

	// Targets self, always works
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// The effect that blocks the first attack once F_Guard_Activate is used
	Effect = new class'X2Effect_Parry';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	Template.bCrossClassEligible = default.GUARD_AWC;

	return Template;
}

// Activated ability that grants the Guard effect
static function X2AbilityTemplate GuardActivate()
{
	local X2AbilityTemplate						Template;
	local X2Effect_IncrementUnitValue			ParryUnitValue;
	local X2AbilityCost_ActionPoints			ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Guard_Activate');

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Parry";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
 	Template.AddShooterEffectExclusions();

	// Costs one action and ends the turn
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Cooldown
	AddCooldown(Template, default.GUARD_COOLDOWN);

	ParryUnitValue = new class'X2Effect_IncrementUnitValue';
	ParryUnitValue.NewValueToSet = 1;
	ParryUnitValue.UnitName = 'Parry';
	ParryUnitValue.CleanupType = eCleanup_BeginTurn;
	Template.AddShooterEffect(ParryUnitValue);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bSkipFireAction = true;
	
	// No animation for now
	Template.bShowActivation = false;

	return Template;
}

// Safeguard
// (AbilityName="F_Safeguard")
// Allies in a small radius around you gain bonus Defense. This bonus is increased when Shield Wall is used.
static function X2AbilityTemplate Safeguard()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ToHitAsTargetBonusAOE    Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Safeguard');

	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_shield_defense";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_ToHitAsTargetBonusAOE';
	Effect.EffectName = 'F_Safeguard';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.ToHitAsTargetBonus = default.SAFEGUARD_AIM_MODIFIER;
	Effect.ToHitAsTargetBonusWithShieldWall = default.SAFEGUARD_AIM_MODIFIER_WITH_SHIELDWALL;
	Effect.AOEDistanceSquared = default.SAFEGUARD_RADIUS;
    Effect.IncludeOwner = false;
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('F_Safeguard_Passive');

	Template.bCrossClassEligible = default.SAFEGUARD_AWC;
	
	return Template;
}

static function X2AbilityTemplate SafeguardPassive()
{
	return PurePassive('F_Safeguard_Passive', "img:///UILibrary_XPerkIconPack.UIPerk_shield_defense", , 'eAbilitySource_Perk');
}

// Trade Fire
// (AbilityName="F_TradeFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Until the start of next turn, fire at any enemy that takes a hostile action.
static function X2AbilityTemplate TradeFire()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ReturnFireAOE                FireEffect;
	
	// Activated ability that targets user
	Template = SelfTargetActivated('F_TradeFire', "img:///UILibrary_XPerkIconPack.UIPerk_rifle_circle", default.TRADEFIRE_AWC, none, , eCost_SingleConsumeAll);
	Template.bShowActivation = true;

	// The granted effect that lets the user return fire on any enemy
	FireEffect = new class'X2Effect_ReturnFireAOE';
    FireEffect.bAllowSelf = true;
	FireEffect.AbilityToActivate = 'F_TradeFire_Shot';
	FireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);
	
	// The shot taken
	Template.AdditionalAbilities.AddItem('F_TradeFire_Shot');

	// Cooldown
    AddCooldown(Template, default.TRADEFIRE_COOLDOWN);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// The shot taken for Trade Fire
static function X2AbilityTemplate TradeFireShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints	ReserveActionPointCost;
	local X2Effect_ApplyWeaponDamage		MissDamage;
	local X2Condition_Visibility			TargetVisibilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_TradeFire_Shot');
	class'X2Ability_DefaultAbilitySet'.static.PistolOverwatchShotHelper(Template);

	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_rifle_circle";
	Template.bShowPostActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	
	Template.AbilityCosts.Length = 0;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.ReturnFireActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	MissDamage = new class'X2Effect_ApplyWeaponDamage';
	MissDamage.bApplyOnHit = false;
	MissDamage.bApplyOnMiss = true;
	MissDamage.bIgnoreBaseDamage = true;
	MissDamage.DamageTag = 'Miss';
	MissDamage.bAllowWeaponUpgrade = true;
	MissDamage.bAllowFreeKill = false;
	Template.AddTargetEffect(MissDamage);
	
	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	return Template;
}

// Intimidate
// (AbilityName="F_Intimidate")
// When targeted by an attack, the enemy has a chance to panic.
static function X2AbilityTemplate Intimidate()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoveringFire                 CoveringEffect;

	Template = PurePassive('F_Intimidate', "img:///UILibrary_DLC3Images.UIPerk_spark_intimidate", default.INTIMIDATE_AWC, 'eAbilitySource_Perk', true);

	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, true, false, false);
	CoveringEffect.AbilityToActivate = 'F_IntimidateTrigger';
	CoveringEffect.GrantActionPoint = 'intimidate';
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.EffectName = 'IntimidateWatchEffect';
	Template.AddTargetEffect(CoveringEffect);

	Template.AdditionalAbilities.AddItem('F_IntimidateTrigger');

	return Template;
}

// The ability that is triggered when you are attacked
static function X2AbilityTemplate IntimidateTrigger()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Panicked						PanicEffect;
	local X2AbilityCost_ReserveActionPoints     ActionPointCost;
	local X2Condition_UnitEffects               UnitEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_IntimidateTrigger');

	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_intimidate";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('intimidate');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.AbilityToHitCalc = default.DeadEye;                //  the real roll is in the effect apply chance
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.ApplyChanceFn = IntimidationApplyChance;
	PanicEffect.VisualizationFn = class'X2Ability_SparkAbilitySet'.static.Intimidate_Visualization;
	Template.AddTargetEffect(PanicEffect);

	Template.CustomFireAnim = 'NO_Intimidate';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

// Chance to apply Intimidate - similar to the Spark's Intimidate, except it's based on secondary weapon tier instead of Spark Armor tier
function name IntimidationApplyChance(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	//  this mimics the panic hit roll without actually BEING the panic hit roll
	local XComGameState_Unit TargetUnit, SourceUnit;
	local name ImmuneName;
	local int AttackVal, DefendVal, TargetRoll, RandRoll;
	local XComGameState_Item WeaponState;
	local X2WeaponTemplate WeaponTemplate;
	local bool bFoundTemplate;

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit != none)
	{
		WeaponState = SourceUnit.GetItemInSlot(eInvSlot_SecondaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			WeaponTemplate = X2WeaponTemplate(WeaponState.GetMyTemplate());
			if (WeaponTemplate != none)
			{
				bFoundTemplate = true;
			}
		}
	}

	if (!bFoundTemplate)
	{
		return 'AA_WeaponIncompatible';
	}

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none && WeaponTemplate != none)
	{
		foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
		{
			if (TargetUnit.FindAbility(ImmuneName).ObjectID != 0)
			{
				return 'AA_UnitIsImmune';
			}
		}

		if (WeaponTemplate.Tier == 2 || WeaponTemplate.Tier == -2)
		{
			AttackVal = default.INTIMIDATE_TIER2_STRENGTH;
		}
		else if (WeaponTemplate.Tier == 3 || WeaponTemplate.Tier == -3)
		{
			AttackVal = default.INTIMIDATE_TIER3_STRENGTH;
		}
		else
		{
			AttackVal = default.INTIMIDATE_TIER1_STRENGTH;
		}

		DefendVal = TargetUnit.GetCurrentStat(eStat_Will);
		TargetRoll = class'X2AbilityToHitCalc_PanicCheck'.default.BaseValue + AttackVal - DefendVal;
		RandRoll = `SYNC_RAND(100);
		if (RandRoll < TargetRoll)
			return 'AA_Success';
	}

	return 'AA_EffectChanceFailed';
}

// Rampart
// (AbilityName="F_Rampart")
// Activated ability that grants damage reduction to the user and adjacent allies
static function X2AbilityTemplate Rampart()
{
    local X2Effect_DamageReductionAOE			Effect;
	local X2AbilityTemplate                     Template;
    local X2Condition_UnitProperty              Condition;
	local X2AbilityMultiTarget_AllAllies		MultiTargetStyle;
    
    // Activated ability that targets user
	Template = SelfTargetActivated('F_Rampart', "img:///UILibrary_XPerkIconPack.UIPerk_shield_defense2", default.RAMPART_AWC, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	
	// Targets self and nearby allies
	MultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetStyle.bAllowSameTarget = true;
	Template.AbilityMultiTargetStyle = MultiTargetStyle;
	
	// Damage reduction applies to the user and allies around them
	Effect = new class'X2Effect_DamageReductionAOE';
	Effect.EffectName = 'F_Rampart';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.DamageReduction = default.RAMPART_DAMAGE_MODIFIER;
	Effect.AOEDistanceSquared = default.RAMPART_RADIUS;
    Effect.IncludeOwner = true;
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

    // Only affects living allies
	Condition = new class'X2Condition_UnitProperty';
	Condition.RequireWithinRange = true;
	Condition.ExcludeHostileToSource = true;
	Condition.ExcludeFriendlyToSource = false;
	Condition.ExcludeDead = true; 
	Template.AbilityMultiTargetConditions.AddItem(Condition);
    
	// Cooldown
	AddCooldown(Template, default.RAMPART_COOLDOWN);

	// Show a flyover when activated
	Template.bShowActivation = true;

    // Do a pointing animation
	Template.CustomFireAnim = 'HL_SignalPoint';
    Template.bSkipFireAction = false;

	return Template;
}

// Strong Back
// (AbilityName="F_StrongBack")
// Reduces the mobility penalty for each weighted utility item by one. Passive.
static function X2AbilityTemplate StrongBack()
{
	local X2Effect_ReverseUtilityMobilityPenalites Effect;
	
	// This effect will grant +1 Mobility for each equipped utility item that grants -1 Mobility
	Effect = new class'X2Effect_ReverseUtilityMobilityPenalites';
	Effect.EffectName = 'F_StrongBack';
	Effect.SlotsToCheck.AddItem(eInvSlot_AmmoPocket);
	Effect.SlotsToCheck.AddItem(eInvSlot_GrenadePocket);
	Effect.SlotsToCheck.AddItem(eInvSlot_Utility);

	// Create the template using a helper function
	return Passive('F_StrongBack', "img:///UILibrary_XPerkIconPack.UIPerk_star_box", default.STRONGBACK_AWC, Effect);
}

// Coordinate Fire
// (AbilityName="F_CoordinateFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
// Fire at the target, then all adjacent allies will fire at that target.
static function X2AbilityTemplate CoordinateFire()
{
	local X2AbilityTemplate Template;

	// Create a standard attack
	Template = Attack('F_CoordinateFire', "img:///UILibrary_XPerkIconPack.UIPerk_shot_x2", default.COORDINATEFIRE_AWC, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_WeaponConsumeAll, 1);
	
	// Event that fires telling allies to shoot
	Template.PostActivationEvents.AddItem('CoordinateFireFollowup');

	// Passive ability that lets allies listen to the event
	Template.AdditionalAbilities.AddItem('F_CoordinateFire_Passive');
	
    // Cooldown
	AddCooldown(Template, default.COORDINATEFIRE_COOLDOWN);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// The passive partial ability allowing allies to followup your shots
static function X2AbilityTemplate CoordinateFirePassive()
{
	local X2AbilityTemplate			Template;
	local X2Effect_CoordinateFire_Passive		Effect;

	// Effect granting the ability to listen to the CoordinateFire event
	Effect = new class'X2Effect_CoordinateFire_Passive';
	Effect.Radius = default.COORDINATEFIRE_RADIUS;

	// Create the template using a helper function
	Template = Passive('F_CoordinateFire_Passive', "img:///UILibrary_XPerkIconPack.UIPerk_shot_x2", true, none);
	
	// Grants this effect to all allies on the mission
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	Template.AddMultiTargetEffect(Effect);
	
	// The Coordinate Fire ability will show up as an active ability, so hide the icon for the passive effect
	HidePerkIcon(Template);

	return Template;
}

// This ability is added to all primary weapons, and is the followup ability performed
static function X2AbilityTemplate CoordinateFireFollowup()
{
	local X2AbilityTemplate Template;

	// Create a standard attack that does not require an action point
	Template = Attack('F_CoordinateFire_Followup', "img:///UILibrary_XPerkIconPack.UIPerk_shot_x2", false, none, , eCost_Free, 1);
	
	// We don't want this ability to actually show up to the user
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	// Show a flyover for each follow-up shot
	Template.bShowActivation = true;

	// Remove the activate ability trigger added by the Attack helper function
	Template.AbilityTriggers.Length = 0;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Pack Tactics
// (AbilityName="F_PackTactics")
// If Shield Wall is active, then all adjacent allies will enter overwatch at the end of the turn.
static function X2AbilityTemplate PackTactics()
{
	local X2AbilityTemplate			Template;
	local X2Effect_PackTactics		Effect;

	// Effect granting the ability to listen to the CoordinateFire event
	Effect = new class'X2Effect_PackTactics';
	Effect.Radius = default.PACKTACTICS_RADIUS;

	// Create the template using a helper function
	Template = Passive('F_PackTactics', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_defense2", true, none);
	
	// Grants this effect to all allies on the mission
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	Template.AddMultiTargetEffect(Effect);

	return Template;
}

// Parry
// (AbilityName="F_Parry", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// You may parry melee attacks and counterattack with a Shield Bash.
static function X2AbilityTemplate Parry()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('F_Parry', "img:///UILibrary_LW_Overhaul.LW_AbilityCombatives", default.PARRY_AWC, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('F_Parry_Attack');
	Template.AdditionalAbilities.AddiTEm('F_Parry_Preparation');
	Template.AdditionalAbilities.AddItem('F_Parry_Counterattack');
	return Template;
}

// The attack used for the counter
static function X2AbilityTemplate ParryAttack()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
	local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
	local X2Effect_SetUnitValue SetUnitValEffect;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Condition_AbilityProperty StunCondition;
	local X2Effect_Stunned StunEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Parry_Attack');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_Ability_Combatives";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;

	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = MeleeHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Damage Effect
	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(PhysicalDamageEffect);
	
	// Disorient Effect
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
	
	// Stun Effect (if the unit has Shield Trauma)
	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	StunCondition = new class'X2Condition_AbilityProperty';
	StunCondition.OwnerHasSoldierAbilities.AddItem('F_ShieldTrauma');
	StunEffect.TargetConditions.AddItem(StunCondition);
	Template.AddTargetEffect(StunEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = 0;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	SetUnitValEffect.bApplyOnHit = true;
	SetUnitValEffect.bApplyOnMiss = true;
	Template.AddShooterEffect(SetUnitValEffect);

	// Remove the dodge increase (happens with a counter attack, which is one time per turn)
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability'.default.CounterattackDodgeEffectName);
	RemoveEffects.bApplyOnHit = true;
	RemoveEffects.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CinescriptCameraType = "Ranger_Reaper";

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Grants the passive dodge bonus during the enemy turn to increase the odds of Parry activating
static function X2AbilityTemplate ParryPreparation()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_ToHitModifier DodgeEffect;
	local X2Effect_SetUnitValue SetUnitValEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Parry_Preparation');

	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	// During the Enemy player's turn, the Unit gets a dodge increase
	DodgeEffect = new class'X2Effect_ToHitModifier';
	DodgeEffect.EffectName = class'X2Ability'.default.CounterattackDodgeEffectName;
	DodgeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	DodgeEffect.AddEffectHitModifier(eHit_Graze, default.PARRY_COUNTERATTACK_DODGE, "Parried", class'X2AbilityToHitCalc_StandardMelee', true, false, true, true, , false);
	DodgeEffect.bApplyAsTarget = true;
	Template.AddShooterEffect(DodgeEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(SetUnitValEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Activates the Attack when a melee attack misses or grazes
static function X2AbilityTemplate ParryCounterattack()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_Parry_Counterattack');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_Ability_Combatives";

	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.MeleeCounterattackListener;  // this probably has to change
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.CinescriptCameraType = "Muton_Counterattack";  // might need to change this to ranger or stun lancer ...

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Mind Blast
// (AbilityName="F_MindBlast", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
// Deal a small amount of damage based on secondary weapon tier and remove action points from the target for next turn. Cooldown-based.
static function X2AbilityTemplate MindBlast()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Stunned					StunnedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'F_MindBlast');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MINDBLAST_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'F_MindBlast';
	WeaponDamageEffect.bBypassShields = true;
	WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.MINDBLAST_STUN_ACTIONS, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;

	Template.IconImage = "img:///UILibrary_FavidsPerkPack.UIPerk_MindBlast";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';

	Template.ActivationSpeech = 'Mindblast';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.bCrossClassEligible = default.MINDBLAST_AWC;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

// Sense Panic
// (AbilityName="F_SensePanic")
// Shots against targets that are suffering from mental impairments ignore half of cover bonuses
static function X2AbilityTemplate SensePanic()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus LowCoverBonusEffect;
	local XMBEffect_ConditionalBonus FullCoverBonusEffect;

	Template = Passive('F_SensePanic', "img:///UILibrary_XPerkIconPack.UIPerk_enemy_shot_psi", default.SENSEPANIC_AWC, none);

    // Bonus for when targets are in low cover
	LowCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(default.HalfCoverCondition);
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(new class'X2Condition_UnitAffectedByMentalEffect');
	LowCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS / 2);
    AddSecondaryEffect(Template, LowCoverBonusEffect);
    
    // Bonus for when targets are in full cover
	FullCoverBonusEffect = new class'XMBEffect_ConditionalBonus';
	FullCoverBonusEffect.AbilityTargetConditions.AddItem(default.FullCoverCondition);
	LowCoverBonusEffect.AbilityTargetConditions.AddItem(new class'X2Condition_UnitAffectedByMentalEffect');
	FullCoverBonusEffect.AddToHitModifier(class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS / 2);
    AddSecondaryEffect(Template, FullCoverBonusEffect);

    return Template;
}

// Over Exertion
// (AbilityName="F_OverExertion")
// Immediately gain a full action point
static function X2AbilityTemplate OverExertion()
{
	local X2AbilityTemplate Template;
	local X2Effect_GrantActionPoints PointEffect;

	// Grants the action point
	PointEffect = new class'X2Effect_GrantActionPoints';
	PointEffect.NumActionPoints = 1;
	PointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	
	// Activated ability that targets user
	Template = SelfTargetActivated('F_OverExertion', "img:///UILibrary_DLC3Images.UIPerk_spark_overdrive", default.OVEREXERTION_AWC, PointEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);
	
	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Charges
	AddCharges(Template, default.OVEREXERTION_CHARGES);

	// Cooldown
	AddCooldown(Template, default.OVEREXERTION_COOLDOWN);

	// Show a flyover when activated
	Template.bShowActivation = true;

    return Template;
}

// Riot Control
// (AbilityName="F_RiotControl")
// Grants a free Flashbang and Smoke Grenade
static function X2AbilityTemplate RiotControl()
{
	local X2AbilityTemplate Template;

	// Create the template using a helper function
	Template = Passive('F_RiotControl', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash", default.RIOTCONTROL_AWC, none);
	
	// Hack to make this work for LWOTC (won't work in just WOTC)
	Template.AdditionalAbilities.AddItem('SmokeGrenade');
	Template.AdditionalAbilities.AddItem('Flashbanger');

	return Template;
}