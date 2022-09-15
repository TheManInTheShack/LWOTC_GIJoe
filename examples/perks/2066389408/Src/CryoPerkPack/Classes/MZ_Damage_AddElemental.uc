class MZ_Damage_AddElemental extends X2Effect_Shredder;

var name Element;
var bool bNoShredder, bNoDoubleGrip; //pistol, sidearm, melee attacks already don't apply shredder, but this can also be used to toggle it off.
var float BonusDamageScalar; //note that this scales ALL aspects of the weapon's base damage, except rupture.
var int	AddRupture, AddShred, AddPierce, AddDamage, AddSpread, AddCrit; //Adds flat values after applying the scalar.

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue DamageValue;
	local X2WeaponTemplate WeaponTemplate;
	local XComGameStateHistory			History;
	local XComGameState_BaseObject		Target;
	local XComGameState_Unit			TargetUnit;
	local bool							bDoubleGrip;

	History = `XCOMHISTORY;
	Target = History.GetGameStateForObjectID( TargetRef.ObjectID );
	TargetUnit = XComGameState_Unit(Target);
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	//uh oh. need to add a proper immunity check!
	if ( WeaponTemplate == none || (Element != '' && TargetUnit.IsImmuneToDamage(Element)) )
	{
		return DamageValue;
	}
	else if ( TargetUnit.IsImmuneToDamage(WeaponTemplate.BaseDamage.DamageType) )
	{
		return DamageValue;
	}

	If ( AbilityState.IsMeleeAbility() && !bNoDoubleGrip)
	{
		bDoubleGrip = IsDoubleGrip(SourceUnit, AbilityState);
	}

	If ( ( Element == 'melee' || AbilityState.IsMeleeAbility() ) && TargetUnit.HasSoldierAbility('VulnerabilityMelee', true))
	{
		//also amplify sectoid's melee vulnerability.
		if ( bDoubleGrip )
		{
			DamageValue.Damage = Round((WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate, History) + GetDoubleGripDamage(WeaponTemplate) + class'X2Ability_Vulnerabilities'.default.MELEE_DAMAGE_MODIFIER)* BonusDamageScalar) + AddDamage;
		}
		else
		{
			DamageValue.Damage = Round((WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate, History) + class'X2Ability_Vulnerabilities'.default.MELEE_DAMAGE_MODIFIER)* BonusDamageScalar) + AddDamage;
		}
	}
	else if ( bDoubleGrip )
	{
		DamageValue.Damage = Round((WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate, History) + GetDoubleGripDamage(WeaponTemplate) )* BonusDamageScalar) + AddDamage;
	}
	else
	{
		DamageValue.Damage = Round((WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate, History) )* BonusDamageScalar) + AddDamage;
	}
	DamageValue.Crit = Round(WeaponTemplate.BaseDamage.Crit * BonusDamageScalar) + AddCrit;
	DamageValue.Spread = WeaponTemplate.BaseDamage.Spread * BonusDamageScalar + AddSpread;

	if ( bDoubleGrip )
	{
		DamageValue.Pierce = Round((WeaponTemplate.BaseDamage.Pierce + GetDoubleGripPierce(WeaponTemplate) )* BonusDamageScalar) + AddPierce;
	}
	else
	{
		DamageValue.Pierce = Round(WeaponTemplate.BaseDamage.Pierce * BonusDamageScalar) + AddPierce;
	}

	DamageValue.Rupture = AddRupture;	//generally rupture should only be handed out by special skills, since it's permanent.

	//handle scaling PlusOne.
	DamageValue.PlusOne = Round(WeaponTemplate.BaseDamage.PlusOne * BonusDamageScalar);
	//If it's over 100, that needs to be fixed. increasing the spread makes the damage range line up better to the expected value.
	While ( DamageValue.PlusOne > 99 )
	{
		DamageValue.Damage += 1;
		DamageValue.Spread += 1;
		DamageValue.PlusOne -= 100;
	}
	//If it's negative, that needs to be fixed.
	While ( DamageValue.PlusOne < 0 )
	{
		DamageValue.Damage -= 1;
		DamageValue.PlusOne += 100;
	}

	//Doing this allows shredder to be scaled up by the damage increase.
	//Shredder doesn't apply to pistol/sidearms or melee attacks.
	if ( !bNoShredder &&(SourceWeapon != none) && (SourceUnit != none) && SourceUnit.HasSoldierAbility('Shredder') && WeaponTemplate.WeaponCat != 'pistol' && WeaponTemplate.WeaponCat != 'sidearm' && !AbilityState.IsMeleeAbility())
	{
		Switch ( WeaponTemplate.WeaponTech )
		{
			case 'beam':
				DamageValue.Shred += default.BeamShred;
				break;
			case 'magnetic':
				DamageValue.Shred += default.MagneticShred;
				break;
			default:
				DamageValue.Shred += default.ConventionalShred;
		}
	}
	DamageValue.Shred = Round((DamageValue.Shred + WeaponTemplate.BaseDamage.Shred)*BonusDamageScalar + AddShred);

	if ( Element != '' )
	{
		DamageValue.DamageType = Element;
	}
	else
	{
		DamageValue.DamageType = WeaponTemplate.BaseDamage.DamageType;
	}

	return DamageValue;
}

private function int GetBreakthroughBonus(X2WeaponTemplate WeaponTemplate, XComGameStateHistory History)
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local StateObjectReference				ObjRef;
	local X2TechTemplate					Tech;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;
	local X2BreakthroughCondition_WeaponTech TechCondition;
	local int								Bonus;

	XComHQ = XComGameState_HeadquartersXCom( History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );

	Foreach XComHQ.TacticalTechBreakthroughs(ObjRef)
	{
		Tech = XComGameState_Tech(History.GetGameStateForObjectID(ObjRef.ObjectID)).GetMyTemplate();
		If ( Tech != none )
		{
			If ( Tech.RewardName == 'WeaponTypeBreakthroughBonus' )
			{
				WeaponTypeCondition = X2BreakthroughCondition_WeaponType(Tech.BreakthroughCondition);
				If (WeaponTypeCondition.WeaponTypeMatch == WeaponTemplate.WeaponCat)
				{
					Bonus +=1;
				}
			}
			else if ( Tech.RewardName == 'WeaponTechBreakthroughBonus')
			{
				TechCondition = X2BreakthroughCondition_WeaponTech(Tech.BreakthroughCondition);
				If (TechCondition.WeaponTechMatch == WeaponTemplate.WeaponTech)
				{
					Bonus +=1;
				}
			}
		}
	}

	return Bonus;
}

private function bool IsDoubleGrip(XComGameState_Unit Attacker, XComGameState_Ability AbilityState)
{
	local X2WeaponTemplate			Weapon;
	local X2WeaponTemplate			Offhand;

	if ( AbilityState.GetSourceWeapon() == Attacker.GetPrimaryWeapon() )
	{
		Weapon = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if ( class'MZMelee_AbilitySet'.default.DoubleGrip_WeaponCats.Find(Weapon.WeaponCat) != INDEX_NONE )
		{
			Offhand = X2WeaponTemplate(Attacker.GetSecondaryWeapon().GetMyTemplate());
			if ( Offhand == none || class'MZMelee_AbilitySet'.default.DoubleGrip_EmptyCats.Find(Offhand.WeaponCat) != INDEX_NONE )
			{
				return true;
			}
		}
	}
}
private function int GetDoubleGripDamage(X2WeaponTemplate Weapon)
{
	Switch (Weapon.WeaponTech)
	{
		case 'Beam':
			return 2*class'MZMelee_AbilitySet'.default.DoubleGrip_DmgPerTier + class'MZMelee_AbilitySet'.default.DoubleGrip_Dmg;
		case 'Coil':
		case 'Magnetic':
			return class'MZMelee_AbilitySet'.default.DoubleGrip_DmgPerTier + class'MZMelee_AbilitySet'.default.DoubleGrip_Dmg;
		default:
			return class'MZMelee_AbilitySet'.default.DoubleGrip_Dmg;
	}
}
private function int GetDoubleGripPierce(X2WeaponTemplate Weapon)
{
	Switch (Weapon.WeaponTech)
	{
		case 'Beam':
			return 2*class'MZMelee_AbilitySet'.default.DoubleGrip_PiercePerTier + class'MZMelee_AbilitySet'.default.DoubleGrip_Pierce;
		case 'Coil':
		case 'Magnetic':
			return class'MZMelee_AbilitySet'.default.DoubleGrip_PiercePerTier + class'MZMelee_AbilitySet'.default.DoubleGrip_Pierce;
		default:
			return class'MZMelee_AbilitySet'.default.DoubleGrip_Pierce;
	}
}


defaultproperties
{

}