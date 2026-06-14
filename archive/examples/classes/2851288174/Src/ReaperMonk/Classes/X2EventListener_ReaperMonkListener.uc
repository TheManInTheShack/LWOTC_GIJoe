class X2EventListener_ReaperMonkListener extends X2EventListener;
//
//var config array<name> AbilityWhitelist;
//
//static function array<X2DataTemplate> CreateTemplates()
//{
    //local array<X2DataTemplate> Templates;
//
    //Templates.AddItem(AddMeleeAttackListener());
//
    //return Templates;
//}
//
//static function X2EventListenerTemplate AddMeleeAttackListener()
//{
    //local X2EventListenerTemplate Template;
//
    //`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'KVMeleeAttackListener');
//
    ////    Should the Event Listener listen for the event during tactical missions?
    //Template.RegisterInTactical = true;
    ////    Should listen to the event while on Avenger?
    //Template.RegisterInStrategy = false;
    //Template.AddEvent('EventID', EventListenerFunction);
//
    //return Template;
//}
//
//function EventListenerReturn KVMeleeAttackListenerReturn(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
//{
	//local XComGameStateContext_Ability AbilityContext;
	//local XComGameStateContext FindContext;
	//local int VisualizeIndex;
	//local XComGameStateHistory History;
//
	//History = `XCOMHISTORY;
//
	//FindContext = GameState.GetContext();
//
	//AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	//if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	//{
		//VisualizeIndex = GameState.HistoryIndex;
		//while( FindContext.InterruptionHistoryIndex > -1 )
		//{
			//FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
			//VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
		//}
//
		//AbilityTriggerAgainstSingleTarget(OwnerStateObject, false);
		////AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
	//}
	//return ELR_NoInterrupt;
//}