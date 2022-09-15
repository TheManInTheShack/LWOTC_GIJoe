class Grimy_Effect_BonusPointBlank extends X2Effect_Persistent;

var name AbilityName;
var int AimBonus, CritBonus;
var int MaxRange;
var float DamageBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;
	local int Tiles, Modifier, CritMod, AimMod;
	
	if (AbilityState.GetMyTemplateName() != AbilityName) { return; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if ( SourceWeapon == none ) { return; }
	if ( SourceWeapon.InventorySlot != eInvSlot_PrimaryWeapon ) { return; }

	if (Attacker != none && Target != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

		if (WeaponTemplate != none)
		{
			Tiles = Attacker.TileDistanceBetween(Target);

			if (WeaponTemplate.RangeAccuracy.Length > 0)
			{
				if (Tiles < WeaponTemplate.RangeAccuracy.Length)
					Modifier = 0 - WeaponTemplate.RangeAccuracy[Tiles];
				else  //  if this tile is not configured, use the last configured tile					
					Modifier = 0 - WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];
			}

			AimMod = Min(MaxRange +1 - Tiles, 0) * AimBonus / MaxRange;
			CritMod = Min(MaxRange +1 - Tiles, 0) * CritBonus / MaxRange;

			ModInfo.ModType = eHit_Success;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = AimMod + Modifier;
			ShotModifiers.AddItem(ModInfo);
		
			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = CritMod;
			ShotModifiers.AddItem(ModInfo);
		}
	}

	
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	if (AbilityState.GetMyTemplateName() != AbilityName) { return 0; }
	return CurrentDamage * DamageBonus;
}