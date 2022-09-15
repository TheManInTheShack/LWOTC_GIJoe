// This is an Unreal Script

class MZ_Effect_TenebrousForm extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var bool bDeflectMelee, bDeflectAOE, breflectMelee, breflectAOE;
var float fDeflectScalar, freflectScalar;
var int	iMinDeflectChance, iMaxDeflectChance, iMinreflectChance, iMaxreflectChance;

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Deflect"
	iMinDeflectChance=0
	iMaxDeflectChance=100
	iMinreflectChance=100
	iMaxreflectChance=100
	fDeflectScalar=1.0f
	freflectScalar=1.0f
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue							ParryUnitValue;
	local int								Chance, RandRoll;
	local X2AbilityToHitCalc_StandardAim	AttackToHit;

	//	don't respond to reaction fire
	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
		return false;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	if (!TargetUnit.IsAbleToAct())
		return false;

	//`log("X2Effect_Deflect::ChangeHitResultForTarget", , 'XCom_HitRolls');
	//	check for parry first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Parry') && TargetUnit.GetUnitValue('Parry', ParryUnitValue))
	{
		if (ParryUnitValue.fValue > 0)
		{
			//`log("Parry is available - not triggering deflect or reflect!", , 'XCom_HitRolls');
			return false;
		}		
	}

	//	check for untouchable first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Untouchable') && TargetUnit.Untouchable > 0)
	{
		//`log("Untouchable is available - not triggering deflect or reflect!", , 'XCom_HitRolls');
		return false;		
	}

	//	only parry can block melee abilities, so only check non-melee abilities
	if ((!AbilityState.IsMeleeAbility() || bDeflectMelee) && (bIsPrimaryTarget || bDeflectAOE))
	{
		
		//	Only try to deflect if HP is not full
		if (TargetUnit.GetCurrentStat(eStat_HP) < TargetUnit.GetMaxStat(eStat_HP))
		{
			Chance = fDeflectScalar * (100 - (100 * TargetUnit.GetCurrentStat(eStat_HP) / TargetUnit.GetMaxStat(eStat_HP)));
			if ( Chance < iMinDeflectChance) { Chance = iMinDeflectChance; }
			if ( Chance > iMaxDeflectChance) { Chance = iMaxDeflectChance; }
			RandRoll = `SYNC_RAND(100);
			if (RandRoll <= Chance)
			{
				//`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
				//	can't reflect Melee or Indirect attacks
				if ( TargetUnit.HasSoldierAbility('MZTenebrousReflect') && (!AbilityState.IsMeleeAbility() || breflectMelee) && (bIsPrimaryTarget || breflectAOE))
				{
					Chance = freflectScalar*(100 - (100 * TargetUnit.GetCurrentStat(eStat_HP) / TargetUnit.GetMaxStat(eStat_HP)));
					if ( Chance < iMinreflectChance) { Chance = iMinreflectChance; }
					if ( Chance > iMaxreflectChance) { Chance = iMaxreflectChance; }
					RandRoll = `SYNC_RAND(100);
					if (RandRoll <= Chance)
					{
						//`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
						NewHitResult = eHit_Reflect;
						return true;
					}
					//`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed. Cannot Reflect.", , 'XCom_HitRolls');
				}

				NewHitResult = eHit_Deflect;
				return true;

			}
			//`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed.", , 'XCom_HitRolls');
		}
		else
		{
			//`log("Unit HP is full. Cannot Deflect.", , 'XCom_HitRolls');
		}
	}
	else
	{
		//`log("Ability is a melee attack or an AOE attack - cannot be Reflected or Deflected.", , 'XCom_HitRolls');
	}

	return false;
}