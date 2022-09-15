class MZ_Effect_DeflectByRange extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var bool bDeflectMelee, bDeflectAOE;
var int BaseDeflect, DeflectPerTile, MinDeflect, MaxDeflect;

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

	//	check for parry first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Parry') && TargetUnit.GetUnitValue('Parry', ParryUnitValue))
	{
		if (ParryUnitValue.fValue > 0)
		{
			return false;
		}		
	}

	//	check for untouchable first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Untouchable') && TargetUnit.Untouchable > 0)
	{
		return false;		
	}

	//	only parry can block melee abilities, so only check non-melee abilities
	if ((!AbilityState.IsMeleeAbility() || bDeflectMelee) && (bIsPrimaryTarget || bDeflectAOE))
	{
		Chance = Clamp((Attacker.TileDistanceBetween(TargetUnit) * DeflectPerTile + BaseDeflect), MinDeflect, MaxDeflect);
		RandRoll = `SYNC_RAND(100);
		if (RandRoll <= Chance)
		{
			NewHitResult = eHit_LightningReflexes; //eHit_Deflect;
			return true;
		}
	}

}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Deflect"
	BaseDeflect=0
	DeflectPerTile=0
	MinDeflect=0
	MaxDeflect=100
	bDeflectMelee=false
	bDeflectAOE=false
}