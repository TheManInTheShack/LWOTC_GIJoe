// This is an Unreal Script

class MZ_Effect_StormForce extends X2Effect_Persistent;

var float Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
	//local X2WeaponTemplate WeaponTemplate;
	local X2AbilityTemplate			MyTemplate;

	MyTemplate = AbilityState.GetMyTemplate();

	if(MyTemplate.ActionFireClass == class'MZ_Action_BlueVolt' || MyTemplate.ActionFireClass == class'X2Action_Fire_Volt' || MyTemplate.CustomFireAnim == 'HL_IonicStorm'){
		return Round(CurrentDamage * Bonus);
	}

	return 0;		
}

defaultproperties
{
	Bonus = 0.0
}