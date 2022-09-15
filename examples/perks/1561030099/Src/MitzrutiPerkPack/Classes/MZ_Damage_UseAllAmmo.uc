class MZ_Damage_UseAllAmmo extends X2Effect_Shredder;

var float Scalar;
var bool bPerRoundDamage, bMultiplyDamage, bNoShredder, bPerRoundShred;


function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue DamageValue;
	local X2WeaponTemplate WeaponTemplate;
	local float				fMult;

	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	fMult = (SourceWeapon.Ammo - 1) * Scalar;

	DamageValue.DamageType = WeaponTemplate.BaseDamage.DamageType;

	if ( !bNoShredder && SourceUnit.HasSoldierAbility('Shredder') && WeaponTemplate.WeaponCat != 'pistol' && WeaponTemplate.WeaponCat != 'sidearm' && !AbilityState.IsMeleeAbility())
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

	if ( bMultiplyDamage )
	{
		DamageValue.Damage = Round((WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate) )* fMult);
		DamageValue.Crit = Round(WeaponTemplate.BaseDamage.Crit * fMult);
		DamageValue.Spread = WeaponTemplate.BaseDamage.Spread * fMult;

		//handle scaling PlusOne.
		DamageValue.PlusOne = Round(WeaponTemplate.BaseDamage.PlusOne * fMult);
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
	}

	if ( bPerRoundDamage )
	{	
		DamageValue.Damage += Round(fMult);
	}

	if ( bPerRoundShred )
	{
		DamageValue.Shred += Round(fMult);
	}

	return DamageValue;
}

private function int GetBreakthroughBonus(X2WeaponTemplate WeaponTemplate)
{
	local XComGameStateHistory			History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local StateObjectReference				ObjRef;
	local X2TechTemplate					Tech;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;
	local X2BreakthroughCondition_WeaponTech TechCondition;
	local int								Bonus;

	History = `XCOMHISTORY;
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