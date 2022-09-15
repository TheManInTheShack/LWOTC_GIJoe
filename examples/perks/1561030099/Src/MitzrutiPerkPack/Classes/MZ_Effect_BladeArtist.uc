class MZ_Effect_BladeArtist extends X2Effect_Persistent;

var float BonusMult;
var int MinCooldown;
var int BonusFlat;
var array<name> IncludeAbility;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	//local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate			MyTemplate;
	local X2AbilityCost_Focus		FocusCost;
	local X2AbilityCost_Charges		ChargeCost;
	local Grimy_AbilityCost_HP		HPCost;
	local int						i;
	local bool						Boost;
	local X2WeaponTemplate WeaponTemplate;

	MyTemplate = AbilityState.GetMyTemplate();

	if ( !MyTemplate.IsMelee() ){ return 0; }
	
	if ( ( MyTemplate.AbilityCooldown != none && MyTemplate.AbilityCooldown.iNumTurns >= MinCooldown ) || ( IncludeAbility.Find( AbilityState.GetMyTemplateName() ) != INDEX_NONE ) ) { 
		Boost = true;
	}

	if ( !Boost )
	{
		for (i = 0; i < MyTemplate.AbilityCosts.Length; ++i)
		{
			FocusCost = X2AbilityCost_Focus( MyTemplate.AbilityCosts[i] );
			if( FocusCost != none && !FocusCost.bFreeCost ) { 
				Boost = true;
				break;
			}
		
			ChargeCost = X2AbilityCost_Charges( MyTemplate.AbilityCosts[i] );
			if( ChargeCost != none && !ChargeCost.bFreeCost ) { 
				Boost = true;
				break;
			}

			HPCost = Grimy_AbilityCost_HP( MyTemplate.AbilityCosts[i] );
			if( HPCost != none ) {
				if( HPCost.Cost > 0 || HPCost.PercentCost > 0){
					Boost = true;
					break;
				}
			}

		}
	}

	if(Boost)
	{
		if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) { return BonusFlat; }

		if ( AbilityState.GetSourceWeapon() != none ) {
			WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
			if (WeaponTemplate != none) {
				return WeaponTemplate.BaseDamage.Damage * BonusMult + BonusFlat;
			}
		}
		else
		{
			return CurrentDamage * BonusMult + BonusFlat;
		}
	}

	return 0;	
		
}

defaultproperties
{
	BonusFlat=0
	BonusMult = 0.0
	MinCooldown = 3
	bDisplayInSpecialDamageMessageUI = true
}