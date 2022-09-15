class MZ_Effect_JetPackBonusDamage extends X2Effect_Persistent;

var int Bonus, PerTier;

var array<name> JetPackAbilities;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	local X2WeaponTemplate			Weapon;
	local X2ArmorTemplate			Armour;

	//can't be in jetshot when dots tick anyway.
	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) { return 0; }

	if ( JetPackAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE )
	{
		//covers heavy jetpack abilities. scale off of armour tech.
		Armour = X2ArmorTemplate(Attacker.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());

		Switch (Armour.ArmorTechCat)
		{
			case 'Powered':
				return 2*PerTier + Bonus;
			case 'Plated':
				return PerTier + Bonus;
			default:
				return Bonus;
		}
	}

	if (Attacker.IsUnitAffectedByEffectName('IRI_JetShot_Effect'))
	{
		//covers "during Jet Shot". scale off of weapon tech.
		Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		Switch (Weapon.WeaponTech)
		{
			case 'Beam':
				return 2*PerTier + Bonus;
			case 'Coil':
			case 'Magnetic':
				return PerTier + Bonus;
			default:
				return Bonus;
		}
	}
	
	return 0;	
}