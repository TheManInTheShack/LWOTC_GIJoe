class MZ_Item_CurseWeapons extends X2Item config(MZPerkWeapons);

var config WeaponDamageValue CurseRoundsBonusDamage, CurseGrenadeDamage, CurseBombDamage, CurseWarheadDamage;

var config int CurseGrenade_Range, CurseGrenade_Radius, CurseGrenade_EnvDamage;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Ammo;

	Ammo.AddItem(CreateMZCurseRounds());
	Ammo.AddItem(CreateMZCurseGrenade('MZCurseGrenade', default.CurseGrenadeDamage, 1));
	Ammo.AddItem(CreateMZCurseGrenade('MZCurseBomb', default.CurseBombDamage, 2));
	Ammo.AddItem(CreateMZCurseGrenade('MZCurseWarhead', default.CurseWarheadDamage, 3));
	
	return Ammo;
}

static function X2AmmoTemplate CreateMZCurseRounds()
{
	local X2AmmoTemplate Template;
	local WeaponDamageValue DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'MZCurseRounds');
	
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	DamageValue = default.CurseRoundsBonusDamage;
	Template.AddAmmoDamageModifier(none, DamageValue);

	Template.TargetEffects.AddItem(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DamageBonusLabel, , DamageValue.Damage);

	// Cost
	Template.CanBeBuilt = false;
		
	//FX Reference
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Stiletto_Rounds";
	Template.GameArchetype = "Ammo_Incendiary.PJ_Incendiary";
	
	return Template;
}

// **************************************************************************
// ***                   Grenade				                          ***
// **************************************************************************

static function X2DataTemplate CreateMZCurseGrenade(name TemplateName, WeaponDamageValue BaseDamage, int Tier)
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;
	local MZ_Effect_ApplyCurseToWorld		WorldEffect;
	//local ArtifactCost Resources;
	//local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, TemplateName);

	Template.strImage = "img:///WP_MZCurseWeapons.Inv_Curse_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_aliengrenade");

	Template.iRange = default.CurseGrenade_Range;
	Template.iRadius = default.CurseGrenade_Radius;

	Template.BaseDamage = default.CurseGrenadeDamage;
	Template.iSoundRange = 20;
	Template.iEnvironmentDamage = default.CurseGrenade_EnvDamage;
	Template.TradingPostValue = 10;
	Template.iClipSize = 1;
	Template.DamageTypeTemplateName = 'Psi';
	

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	Template.GameArchetype = "WP_MZCurseWeapons.WP_CurseGrenade";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.OnThrowBarkSoundCue = 'ThrowGrenade';


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.ThrownGrenadeEffects.AddItem(class'MZ_Effect_BloodCurse'.static.CreateBloodCurse());

	WorldEffect = new class'MZ_Effect_ApplyCurseToWorld';
	WorldEffect.bApplyOnMiss = false;
	WorldEffect.bApplyToWorldOnMiss = false;
	WorldEffect.bApplyOnHit = true;
	WorldEffect.bApplyToWorldOnHit = true;
	Template.ThrownGrenadeEffects.AddItem(WorldEffect);
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.Tier = Tier;
	Switch (Tier)
	{
		case 3:
			Template.strImage = "img:///WP_MZCurseWeapons.Inv_Curse_Grenade3";
			Template.CreatorTemplateName = 'SuperiorExplosives'; // The schematic which creates this item
			Template.BaseItem = 'MZCurseBomb'; // Which item this will be upgraded from

			Template.Requirements.RequiredTechs.AddItem('SuperiorExplosives');

			Template.iRadius += 1;
			break;
		case 2:
			Template.strImage = "img:///WP_MZCurseWeapons.Inv_Curse_Grenade2";
			Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
			Template.BaseItem = 'MZCurseGrenade'; // Which item this will be upgraded from

			Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
			Template.HideIfResearched = 'SuperiorExplosives';
			break;
		default:
			Template.HideIfResearched = 'AdvancedGrenades';
	}

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.CurseGrenade_Range);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.CurseGrenade_Radius);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.CurseGrenadeDamage.Shred);

	return Template;
}