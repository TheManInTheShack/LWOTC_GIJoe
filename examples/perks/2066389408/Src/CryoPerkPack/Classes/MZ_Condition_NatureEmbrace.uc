class MZ_Condition_NatureEmbrace extends X2Condition;

var string Biome;	//Temperate, Tundra, Arid, Xenoform, Cave, Urban

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	
	if ( Biome != "Cave" && Biome != "Urban" )
	{
		if ( Biome == BattleData.MapData.Biome ) { return 'AA_Success'; }
	} 

	if (InStr(BattleData.MapData.PlotMapName, "_TUN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_CSH_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALN_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ALH_") != INDEX_NONE)
	{
		if( Biome == "Cave" ) {	return 'AA_Success'; }
	}

	if (InStr(BattleData.MapData.PlotMapName, "_CTY_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_SLM_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_RFT_") != INDEX_NONE || InStr(BattleData.MapData.PlotMapName, "_ABN_") != INDEX_NONE)
	{
		if( Biome == "Urban" ) {	return 'AA_Success'; }
	}

	/*
	Urban Biome:			//Urban and Cave are for plot types that don't  really show any sign of what biome they are, and sometimes are none.
	_CTY_	//city center
	_SLM_	//city slums
	_RFT_	//rooftop, also lost towers
	_ABN_	//lost city

	Cave Biome:
	_TUN_	//Tunnels
	_CSH_	//Chosen Stronghold
	_ALN_	//Leviathan
	_ALH_	//alien hunters derelict facility

	SHN, TWN, WLD			//Shanty, smalltown, wilderness: -have biomes. only WLD has Xenoform.
	*/
	return 'AA_WrongBiome';
}