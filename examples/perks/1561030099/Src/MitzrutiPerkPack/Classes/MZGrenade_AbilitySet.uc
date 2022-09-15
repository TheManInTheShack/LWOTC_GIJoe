class MZGrenade_AbilitySet extends X2Ability config(MZPerkPack);

var config int AntiCritSmoke_Mod, DodgeSmoke_GrazeMod, DodgeSmoke_AimMod, FogWall_AmmoBonus, ImproviseExplosive_Cooldown, ImproviseExplosive_AP, GrenadeTrap_RangeFlat;
var config float FogWall_FogMod, GrenadeTrap_RangeMult;
var config array<name> SMOKE_GRENADES, ATTACK_GRENADES, ATTACK_GRENADE_ABILITIES, GrenadeTrap_ExcludeGrenades, Zombify_Grenades, SMOKE_ABILITIES, FortressSmoke_Immunities, MindShieldSmoke_Immunties, ROULETTE_GRENADES;
var config int SHELLSHOCK_DURATION, SHELLSHOCK_CHANCE, DEADLY_HAZE_DAMAGE, DEADLY_HAZE_TURNS;

var localized string DeadlyHazeEffectName, DeadlyHazeEffectDesc;
var localized string AntiCritSmokeEffectName, AntiCritSmokeEffectDesc, DodgeSmokeEffectName, DodgeSmokeEffectDesc, MindSmokeEffectName, MindSmokeEffectDesc, FogWallEffectName, FogWallEffectDesc, FortSmokeEffectName, FortSmokeEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(PurePassive('MZZombieGrenades', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ultrasoniclure"));
	Templates.AddItem(PurePassive('MZAntiCritSmoke', "img:///UILibrary_PerkIcons.UIPerk_resilience"));
	Templates.AddItem(PurePassive('MZDodgeSmoke', "img:///UILibrary_PerkIcons.UIPerk_smokebomb"));
	Templates.AddItem(PurePassive('MZMindShieldSmoke', "img:///UILibrary_PerkIcons.UIPerk_solace"));
	Templates.AddItem(PurePassive('MZFortressSmoke', "img:///UILibrary_PerkIcons.UIPerk_fortress"));

	Templates.AddItem(GrenadePocket());
	Templates.AddItem(AddFogWall("img:///UILibrary_PerkIcons.UIPerk_smokeandmirrors"));

	Templates.AddItem(FreeAcidGrenade());
	Templates.AddItem(FreeGasGrenade());
	Templates.AddItem(FreeEMPGrenade());
	Templates.AddItem(FreeFireGrenade());
	Templates.AddItem(FreeFragGrenade());
	Templates.AddItem(FreeRandomGrenade());
	Templates.AddItem(FreeFlashGrenade());
	Templates.AddItem(FreeSmokeGrenade());
	Templates.AddItem(FreeProxyMine());
	Templates.AddItem(FreeIRIMolotov());
	Templates.AddItem(FreeIRIPipeBomb());
	Templates.AddItem(FreeEricparHealBomb());
	Templates.AddItem(FreeCurseGrenade());

	Templates.AddItem(ImproviseExplosive());
	Templates.AddItem(ImproviseRandomExplosive());

	//Templates.AddItem(PurePassive('MZGrenadeTrap', "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine"));
	Templates.AddItem(GrenadeTrap());
	/*>>*/Templates.AddItem(ThrowGrenadeTrap());
	/*>>*/Templates.AddItem(GrenadeTrapDetonate());
	Templates.AddItem(GrenadeTrapStayConcealed());
	
	return Templates;
}

static function AddEffectsToGrenades()
{
	local X2ItemTemplateManager			ItemManager;
	local array<name>					TemplateNames;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;
	local X2GrenadeTemplate				GrenadeTemplate;
	local name							TemplateName, ItemName, SmokeAbilityName;
	local MZ_Effect_SmokeDefMod			SmokeCritEffect;
	local MZ_Effect_SmokeDefMod			SmokeDodgeEffect;
	local MZ_Effect_SmokeDefMod			FogWallEffect;
	local MZ_Effect_SmokeDefMod			SmokeMindEffect;
	local MZ_Effect_SmokeDefMod			SmokeFortressEffect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local X2Effect_RemoveEffects		MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects		MindControlRemovalEffect;
	local X2Condition_UnitProperty		EnemyCondition;
	local X2Condition_UnitProperty		FriendCondition;
	local X2AbilityTemplateManager		AbilityTemplateManager;
	local X2AbilityTemplate				AbilityTemplate;
	local X2Effect_Stunned				StunnedEffect;
	local Grimy_Effect_ReduceDamage		DamageEffect;
	local MZ_Effect_Zombify				ZombieEffect;

	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;

	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;

	SmokeCritEffect = new class'MZ_Effect_SmokeDefMod';
	SmokeCritEffect.EffectName = 'MZAntiCritSmokeEffect';
	SmokeCritEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	SmokeCritEffect.SetDisplayInfo(ePerkBuff_Bonus, default.AntiCritSmokeEffectName, default.AntiCritSmokeEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_resilience");
	SmokeCritEffect.CritMod = default.AntiCritSmoke_Mod;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZAntiCritSmoke');
	SmokeCritEffect.TargetConditions.AddItem(AbilityCondition);
	SmokeCritEffect.TargetConditions.AddItem(FriendCondition);

	SmokeDodgeEffect = new class'MZ_Effect_SmokeDefMod';
	SmokeDodgeEffect.EffectName = 'MZDodgeSmokeEffect';
	SmokeDodgeEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	SmokeDodgeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.DodgeSmokeEffectName, default.DodgeSmokeEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_smokebomb");
	SmokeDodgeEffect.GrazeMod = default.DodgeSmoke_GrazeMod;
	SmokeDodgeEffect.AimMod = default.DodgeSmoke_AimMod;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZDodgeSmoke');
	SmokeDodgeEffect.TargetConditions.AddItem(AbilityCondition);
	SmokeDodgeEffect.TargetConditions.AddItem(FriendCondition);

	FogWallEffect = new class'MZ_Effect_SmokeDefMod';
	FogWallEffect.EffectName = 'MZFogWallEffect';
	FogWallEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	FogWallEffect.SetDisplayInfo(ePerkBuff_Bonus, default.FogWallEffectName, default.FogWallEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_smokeandmirrors");
	FogWallEffect.FogWall = true;
	FogWallEffect.FogMod = Default.FogWall_FogMod;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFogWall');
	FogWallEffect.TargetConditions.AddItem(AbilityCondition);
	FogWallEffect.TargetConditions.AddItem(FriendCondition);

	//Mind Smoke does a whole bucket of things - cleanse and then immunity.
	//using the same condition for all three effects
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZMindShieldSmoke');
	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	MentalEffectRemovalEffect.DamageTypes.Length = 0;		//	don't let an immunity to "mental" effects resist this cleanse
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	MentalEffectRemovalEffect.TargetConditions.AddItem(AbilityCondition);
			
	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	MindControlRemovalEffect.TargetConditions.AddItem(AbilityCondition);
	
	SmokeMindEffect = new class'MZ_Effect_SmokeDefMod';
	SmokeMindEffect.EffectName = 'MZMindShieldSmokeEffect';
	SmokeMindEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	SmokeMindEffect.SetDisplayInfo(ePerkBuff_Bonus, default.MindSmokeEffectName, default.MindSmokeEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_solace");
	SmokeMindEffect.ImmuneTypes = default.MindShieldSmoke_Immunties;
	SmokeMindEffect.TargetConditions.AddItem(AbilityCondition);
	SmokeMindEffect.TargetConditions.AddItem(FriendCondition);

	SmokeFortressEffect = new class'MZ_Effect_SmokeDefMod';
	SmokeFortressEffect.EffectName = 'MZFortressSmokeEffect';
	SmokeFortressEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	SmokeFortressEffect.SetDisplayInfo(ePerkBuff_Bonus, default.FortSmokeEffectName, default.FortSmokeEffectDesc, "img:///UILibrary_PerkIcons.UIPerk_fortress");
	SmokeFortressEffect.ImmuneTypes = default.FortressSmoke_Immunities;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZFortressSmoke');
	SmokeFortressEffect.TargetConditions.AddItem(AbilityCondition);	
	SmokeFortressEffect.TargetConditions.AddItem(FriendCondition);
	
	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	foreach default.SMOKE_GRENADES(ItemName)
	{
		ItemManager.FindDataTemplateAllDifficulties(ItemName, TemplateAllDifficulties);
		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);
					
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeCritEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(SmokeCritEffect);		
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeDodgeEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(SmokeDodgeEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(FogWallEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(FogWallEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(MentalEffectRemovalEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(MentalEffectRemovalEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(MindControlRemovalEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(MindControlRemovalEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeMindEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(SmokeMindEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(SmokeFortressEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(SmokeFortressEffect);

			//once there's a highlander hook for it, will need to add these effects to the smoke too.
			//.AddItem(SmokeCritEffect);
			//.AddItem(SmokeDodgeEffect);
			//.AddItem(FogWallEffect);
			//.AddItem(SmokeMindEffect);
			//.AddItem(SmokeFortressEffect);
		}
	}

	/////////// Apply effects for offensive grenades: either they do damage, or are part of an explicit array.
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.SHELLSHOCK_DURATION, default.SHELLSHOCK_CHANCE);
	StunnedEffect.bRemoveWhenSourceDies = false;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyShellShock');
	StunnedEffect.TargetConditions.AddItem(AbilityCondition);
	StunnedEffect.TargetConditions.AddItem(EnemyCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimyDeadlyHaze');
	DamageEffect = new class'Grimy_Effect_ReduceDamage';
	DamageEffect.BonusDamage = default.DEADLY_HAZE_DAMAGE;
	DamageEffect.BuildPersistentEffect(default.DEADLY_HAZE_TURNS, true, false, false, eGameRule_PlayerTurnEnd);
	DamageEffect.TargetConditions.AddItem(AbilityCondition);
	DamageEffect.TargetConditions.AddItem(EnemyCondition);
	DamageEffect.SetDisplayInfo(ePerkBuff_Penalty, default.DeadlyHazeEffectName , default.DeadlyHazeEffectDesc, "img:///GrimyClassAN_Icons.UIPerk_ToxicCloud", true);

	ItemManager.GetTemplateNames(TemplateNames);
	foreach TemplateNames(TemplateName)
	{
		ItemManager.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
		// Iterate over all variants
		
		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);
			if (GrenadeTemplate != none)
			{
				if ( (GrenadeTemplate.BaseDamage.Damage > 0  && (GrenadeTemplate.ThrownGrenadeEffects.Length > 0 || GrenadeTemplate.LaunchedGrenadeEffects.Length > 0)) || default.ATTACK_GRENADES.find(TemplateName) != INDEX_NONE)
				{
					GrenadeTemplate.ThrownGrenadeEffects.AddItem(StunnedEffect);
					GrenadeTemplate.LaunchedGrenadeEffects.AddItem(StunnedEffect);
					GrenadeTemplate.ThrownGrenadeEffects.AddItem(DamageEffect);
					GrenadeTemplate.LaunchedGrenadeEffects.AddItem(DamageEffect);

					if(!GrenadeTemplate.IsA('X2RocketTemplate') && default.GrenadeTrap_ExcludeGrenades.Find(TemplateName) == INDEX_NONE)
					{	
						GrenadeTemplate.Abilities.AddItem('MZThrowGrenadeTrap');
						GrenadeTemplate.Abilities.AddItem('MZGrenadeTrapDetonate');
					}
				}
			}
		}
	}

	/////////// Handling for Zombie Grenades ability - applies it's effect only to specific grenades.
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZZombieGrenades');
	ZombieEffect = class'MZ_Effect_Zombify'.static.CreateZombifyEffect(class'MZUnspecific_AbilitySet'.default.ZombieGrenadeTurns);
	ZombieEffect.TargetConditions.AddItem(AbilityCondition);
	ZombieEffect.TargetConditions.AddItem(EnemyCondition);

	foreach default.Zombify_Grenades(ItemName)
	{
		ItemManager.FindDataTemplateAllDifficulties(ItemName, TemplateAllDifficulties);
		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);

			GrenadeTemplate.ThrownGrenadeEffects.AddItem(ZombieEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(ZombieEffect);
		}
	}

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.SMOKE_ABILITIES(SmokeAbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(SmokeAbilityName);
		if (AbilityTemplate != none)
		{
			if ( AbilityTemplate.AbilityMultiTargetEffects.Length > 0 )
			{
				AbilityTemplate.AddMultiTargetEffect(SmokeCritEffect);
				AbilityTemplate.AddMultiTargetEffect(SmokeDodgeEffect);
				AbilityTemplate.AddMultiTargetEffect(FogWallEffect);
				AbilityTemplate.AddMultiTargetEffect(SmokeMindEffect);
				AbilityTemplate.AddMultiTargetEffect(SmokeFortressEffect);
			}

			if ( AbilityTemplate.AbilityTargetEffects.Length > 0 )
			{
				AbilityTemplate.AddTargetEffect(SmokeCritEffect);
				AbilityTemplate.AddTargetEffect(SmokeDodgeEffect);
				AbilityTemplate.AddTargetEffect(FogWallEffect);
				AbilityTemplate.AddTargetEffect(SmokeMindEffect);
				AbilityTemplate.AddTargetEffect(SmokeFortressEffect);
			}

			//roving chemist allows the user to move into smoke after activating it, so make sure they also get the buffs.
			if ( AbilityTemplate.AbilityShooterEffects.Length > 0 )
			{
				AbilityTemplate.AddShooterEffect(SmokeCritEffect);
				AbilityTemplate.AddShooterEffect(SmokeDodgeEffect);
				AbilityTemplate.AddShooterEffect(FogWallEffect);
				AbilityTemplate.AddShooterEffect(SmokeMindEffect);
				AbilityTemplate.AddShooterEffect(SmokeFortressEffect);
			}
		}
	}

	foreach default.ATTACK_GRENADE_ABILITIES(SmokeAbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(SmokeAbilityName);
		if (AbilityTemplate != none)
		{
			AbilityTemplate.AddMultiTargetEffect(StunnedEffect);
			AbilityTemplate.AddMultiTargetEffect(DamageEffect);
		}
	}
}

static function X2AbilityTemplate GrenadePocket() {
	local X2AbilityTemplate									Template;

	Template = PurePassive('MZGrenadePocket', "img:///UILibrary_PerkIcons.UIPerk_grenadier");
	Template.SoldierAbilityPurchasedFn = class'X2Ability_GrenadierAbilitySet'.static.GrenadePocketPurchased;

	return template;
}

static function X2AbilityTemplate AddFogWall(string ImageIcon) {
	local X2AbilityTemplate									Template;
	local Grimy_BonusItemCharges						AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFogWall');

	Template.IconImage = ImageIcon;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'Grimy_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = default.FogWall_AmmoBonus;
	AmmoEffect.bUtilityGrenades = false;
	AmmoEffect.bPocketGrenades = false;
	AmmoEffect.ItemTemplateNames = default.SMOKE_GRENADES;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate FreeAcidGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeAcidGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_acidbomb";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'AcidGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeGasGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeGasGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_gas";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'GasGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeEMPGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeEMPGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_emp";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'EMPGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeFireGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeFireGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_firebomb";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'Firebomb';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeCurseGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeCurseGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aliengrenade";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'MZCurseGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeFragGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeFragGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fraggrenade";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'FragGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeRandomGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeRandomGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fraggrenade";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.RandomItemNames = default.ROULETTE_GRENADES;
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeProxyMine()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeProxyMine');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'ProximityMine';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeIRIMolotov()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeIRIMolotov');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///IRI_WOTCMolotov.UI.ThrowMolotov";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'IRI_Molotov';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeIRIPipeBomb()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeIRIPipeBomb');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///IRI_PipeBomb.perk_Pipebomb";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'IRI_PipeBomb_T1';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeEricparHealBomb()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeEricparHealBomb');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_HealBomb.UIPerk_grenade_heal";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'HealBomb';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('FieldMedic', class'X2Ability_SpecialistAbilitySet'.default.FIELD_MEDIC_BONUS);
	ItemEffect.AddBonusAmmoAbility('F_FieldMedic', class'X2Ability_SpecialistAbilitySet'.default.FIELD_MEDIC_BONUS);
	ItemEffect.MaxCharges = Max(class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO, class'X2Ability_SpecialistAbilitySet'.default.FIELD_MEDIC_BONUS) + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeFlashGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeFlashGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_flash";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'FlashbangGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate FreeSmokeGrenade()
{
	local X2AbilityTemplate					Template;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFreeSmokeGrenade');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'SmokeGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('MZFogWall', default.FogWall_AmmoBonus);
	ItemEffect.MaxCharges = Max(class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO, default.FogWall_AmmoBonus) + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);
 
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate ImproviseExplosive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZImproviseExplosive');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fraggrenade";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ImproviseExplosive_AP;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ImproviseExplosive_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.DataName = 'FragGrenade';
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);

	//Template.ActivationSpeech = 'ActivateConcealment';
	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate ImproviseRandomExplosive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local MZ_Effect_AddSevenWeapon			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZImproviseRandomExplosive');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fraggrenade";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ImproviseExplosive_AP;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ImproviseExplosive_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ItemEffect = new class'MZ_Effect_AddSevenWeapon';
	ItemEffect.RandomItemNames = default.ROULETTE_GRENADES;
	ItemEffect.InvSlotEnum = eInvSlot_Utility;
	ItemEffect.AddBonusAmmoAbility('GrimyLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.AddBonusAmmoAbility('PrimaryLightOrdnance', class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO);
	ItemEffect.MaxCharges = class'MZGrimyAnarchist_AbilitySet'.default.LIGHT_ORDNANCE_AMMO + 1;
	ItemEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	Template.AddTargetEffect(ItemEffect);

	//Template.ActivationSpeech = 'ActivateConcealment';
	Template.Hostility = eHostility_Neutral;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate ThrowGrenadeTrap()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	//local X2Condition_UnitInventory         UnitInventoryCondition;
	local X2Condition_AbilitySourceWeapon   GrenadeCondition; //, ProximityMineCondition;
	local MZ_Effect_GrenadeTrap           ProximityMineEffect;
	local MZ_Condition_RequireAbility		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZThrowGrenadeTrap');	
	
	Template.bDontDisplayInAbilitySummary = true;
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('TotalCombat');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	
	Template.bHideWeaponDuringFire = true;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	RadiusMultiTarget.AddAbilityBonusRadius('LaunchGrenade', 1.0f);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//UnitPropertyCondition = new class'X2Condition_UnitProperty';
	//UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	//AbilityCondition = new class'X2Condition_AbilityProperty';
	//AbilityCondition

	AbilityCondition = new class'MZ_Condition_RequireAbility';
	AbilityCondition.RequireAbilityName = 'MZGrenadeTrap';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MZGrenadeTrap');
	Template.AbilityShooterConditions.AddItem(AbilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	ProximityMineEffect = new class'MZ_Effect_GrenadeTrap';
	ProximityMineEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(ProximityMineEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.HideErrors.AddItem('AA_MissingRequiredEffect');
	//Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY; // +10;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_LootBodyStart';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = GrenadeTrapDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_Grenade';
	Template.CinescriptCameraType = "StandardGrenadeFiring";

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;
	Template.LostSpawnIncreasePerUse = 0;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ThrowGrenade'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'ThrowGrenade'

	return Template;	
}

function bool GrenadeTrapDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Item ItemState;
	local X2GrenadeTemplate GrenadeTemplate;
	local XComGameState_Ability DetonationAbility;
	local XComGameState_Unit SourceUnit;
	local XComGameStateHistory History;
	local StateObjectReference AbilityRef;

	ItemState = AbilityState.GetSourceAmmo();
	if (ItemState == none)
		ItemState = AbilityState.GetSourceWeapon();

	if (ItemState == none)
		return false;

	GrenadeTemplate = X2GrenadeTemplate(ItemState.GetMyTemplate());
	if (GrenadeTemplate == none)
		return false;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	AbilityRef = SourceUnit.FindAbility('MZGrenadeTrapDetonate', ItemState.GetReference());
	DetonationAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
	if (DetonationAbility == none)
		return false;

	DetonationAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	return true;
}

static function X2AbilityTemplate GrenadeTrapDetonate()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardAim			ToHit;
	local X2Condition_UnitProperty					UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon			GrenadeCondition;
	local X2AbilityTarget_Cursor					CursorTarget;
	local X2AbilityMultiTarget_Radius	            RadiusMultiTarget;
	//local X2Effect_ApplyWeaponDamage				WeaponDamage;
	local MZ_Condition_RequireAbility		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGrenadeTrapDetonate');

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bIndirectFire = true;
	Template.AbilityToHitCalc = ToHit;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.IncreaseWeaponRange = 2;
	Template.AbilityTargetStyle = CursorTarget;

	//Template.AddShooterEffect(new class'X2Effect_BreakUnitConcealment');

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	//RadiusMultiTarget.fTargetRadius = 2;
	RadiusMultiTarget.AddAbilityBonusRadius('LaunchGrenade', 1.5f);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	AbilityCondition = new class'MZ_Condition_RequireAbility';
	AbilityCondition.RequireAbilityName = 'MZGrenadeTrap';
	Template.AbilityShooterConditions.AddItem(AbilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	//Template.bUseLaunchedGrenadeEffects = true;
	Template.bUseThrownGrenadeEffects = true;
	
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by effect detecting movement in range of mine

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY; // + 50;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.FrameAbilityCameraType = eCameraFraming_Never;

	Template.ActivationSpeech = 'Explosion';
	//Template.bSkipFireAction = true;
	Template.ActionFireClass = class'MZ_Action_GrenadeTrapDetonate';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//  cannot interrupt this explosion
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.ConcealmentRule = eConceal_Never;

	return Template;
}

static function X2AbilityTemplate GrenadeTrap()
{
	local X2AbilityTemplate Template;
	local MZ_Effect_ModifyGrenadeRange                  Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGrenadeTrap');
	
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'MZ_Effect_ModifyGrenadeRange';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Effect.bLaunchGrenade = false;
	Effect.bThrowGrenade = false;
	Effect.bGrenadeTrap = true;
	Effect.RangeChangeMult = default.GrenadeTrap_RangeMult;
	Effect.RangeChangeFlat = default.GrenadeTrap_RangeFlat;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}

static function X2AbilityTemplate GrenadeTrapStayConcealed()
{
	local X2AbilityTemplate Template;
	local MZ_Effect_GrenadeTrapRetainConcealment HolyWarriorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZGrenadeTrapStayConcealed');
	
	Template.AbilitySourceName = 'eAbilitySource_Passive';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_proximitymine";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HolyWarriorEffect = new class'MZ_Effect_GrenadeTrapRetainConcealment';
	HolyWarriorEffect.DuplicateResponse = eDupe_Ignore;
	HolyWarriorEffect.BuildPersistentEffect(1, true, false, false);
	HolyWarriorEffect.bRemoveWhenTargetDies = false;
	HolyWarriorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(HolyWarriorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}