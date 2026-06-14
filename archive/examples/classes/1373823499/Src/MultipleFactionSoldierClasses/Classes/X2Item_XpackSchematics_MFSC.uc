class X2Item_XpackSchematics_MFSC extends X2Item_XpackSchematics;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;
	local X2SchematicTemplate Template;
	local int i;
	local bool UnlockUpgrade;
	local name SingleClass;
	local bool DontDoAnything;
	local bool Unrestrict;
	local name TierlessName;

	if (class'MultipleFactionSoldierClassController'.default.DontOverrideSchematicTemplates) {
		DontDoAnything = true;
	} else if (class'OrderControl'.static.CheckForActiveMod("EveryoneEquipsEverything") == true) {
		DontDoAnything = true;
	}

	if (DontDoAnything == true) {
		`log("MFSC: NOT patching schematics");
		Schematics.Length = 0;
		return Schematics;
	}

	`log("MFSC: Patching schematics");

	Schematics = super.CreateTemplates();
	
	for (i=0;i<Schematics.Length;i++) {
		Template = X2SchematicTemplate(Schematics[i]);
		if (Template != none && Template.Requirements.RequiredSoldierClass != '') {
			UnlockUpgrade = false;
			SingleClass = Template.Requirements.RequiredSoldierClass;

			Unrestrict = false;

			if (Template.Requirements.RequiredSoldierClass == 'Reaper') {

				TierlessName = GetTechName(Template.DataName);

				if (TierlessName == 'VektorRifle') {
					if (class'MultipleFactionSoldierClassController'.default.UnrestrictVektorRifle)
						Unrestrict = true;
				}

				if (Unrestrict) {
					if (class'MultipleFactionSoldierClassController'.default.ReaperClasses.Length > 1)
						UnlockUpgrade = true;
					else
						SingleClass = name(class'MultipleFactionSoldierClassController'.default.ReaperClasses[0]);
				}

			} else if (Template.Requirements.RequiredSoldierClass == 'Skirmisher') {

				TierlessName = GetTechName(Template.DataName);

				if (TierlessName == 'Bullpup') {
					if (class'MultipleFactionSoldierClassController'.default.UnrestrictBullpup)
						Unrestrict = true;

				} else if (TierlessName == 'WristBlade') {
					if (class'MultipleFactionSoldierClassController'.default.UnrestrictRipjack)
						Unrestrict = true;
				}

				if (Unrestrict) {
					if (class'MultipleFactionSoldierClassController'.default.SkirmisherClasses.Length > 1)
						UnlockUpgrade = true;
					else
						SingleClass = name(class'MultipleFactionSoldierClassController'.default.SkirmisherClasses[0]);
				}

			} else if (Template.Requirements.RequiredSoldierClass == 'Templar') {
				
				TierlessName = GetTechName(Template.DataName);

				if (TierlessName == 'ShardGauntlet') {
					if (class'MultipleFactionSoldierClassController'.default.UnrestrictGauntlet) {
						Unrestrict = true;
					}

				} else if (TierlessName == 'Sidearm') {
					if (class'MultipleFactionSoldierClassController'.default.UnrestrictAutopistol)
						Unrestrict = true;
				}

				if (Unrestrict) {
					if (class'MultipleFactionSoldierClassController'.default.TemplarClasses.Length > 1)
						UnlockUpgrade = true;
					else
						SingleClass = name(class'MultipleFactionSoldierClassController'.default.TemplarClasses[0]);
				}

			}
			
			if (Unrestrict) {
				if (UnlockUpgrade) {
					Template.Requirements.RequiredSoldierClass = '';
				} else {
					Template.Requirements.RequiredSoldierClass = SingleClass;
				}

				Schematics[i] = Template;
			}
				
		}
	}

	return Schematics;
}

static function name GetTechName(name TechName_Tier) {
	local string TechString;
	local name ConvertedTechName;
	local int in;

	TechString = string(TechName_Tier);
	in = InStr(TechString, "_");
	
	if (in == -1) {
		return TechName_Tier;
	}
	
	TechString = Left(TechString, in);

	ConvertedTechName = name(TechString);
	return ConvertedTechName;
}