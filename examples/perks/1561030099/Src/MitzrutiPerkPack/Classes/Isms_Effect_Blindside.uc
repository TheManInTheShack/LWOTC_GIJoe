class Isms_Effect_Blindside extends X2Effect_Persistent config(IsmsRogue);

var bool Upside; //switch to height advantage instead of flanking.
var config array<name> Blindside_WeaponCats;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local GameRulesCache_VisibilityInfo VisInfo;
	local XComGameState_Item SourceWeapon;  ///Here Delete
	local int BonusDamage;
	local X2AbilityToHitCalc_StandardAim HitCalc;

	SourceWeapon = AbilityState.GetSourceWeapon();
	If (SourceWeapon == none || Blindside_WeaponCats.Find( SourceWeapon.GetWeaponCategory()) == INDEX_NONE ) { return 0; }
	
	HitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if ( HitCalc == none || HitCalc.bIndirectFire || HitCalc.bMeleeAttack || HitCalc.bIgnoreCoverBonus ) { return 0; }

	TargetUnit = XComGameState_Unit(TargetDamageable);

	Switch ( Attacker.GetSoldierRank() )
	{
		case 0:
		case 1:
		case 2:
			BonusDamage = 1;
			break;
		case 3:
		case 4:
			BonusDamage = 2;
			break;
		case 5:
		case 6:
			BonusDamage = 3;
			break;
		default:
			BonusDamage = 4;
	}

	If (CurrentDamage > 1 && !AbilityState.IsMeleeAbility() && TargetUnit != None && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{		
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, TargetUnit.ObjectID, VisInfo))
		{
			if ( Upside )
			{
				if (Attacker.HasHeightAdvantageOver(TargetUnit, true))
				{
					return BonusDamage;
				}
			}
			else
			{
				if (Attacker.CanFlank() && TargetUnit.CanTakeCover() && VisInfo.TargetCover == CT_None)
				{
					return BonusDamage;
				}

				if (Attacker.CanFlank() && !TargetUnit.CanTakeCover() && VisInfo.TargetCover == CT_None)
				{
					//what is this even for Isms?
					if (TargetUnit.GetMaxStat(eStat_HP) >= 12) 
					{
						return BonusDamage+1;
					}			
					else if (TargetUnit.GetMaxStat(eStat_HP) <= 12) 
					{
						return BonusDamage+1;
					}							
				}
			}
		}
	}
	return 0;
	
}