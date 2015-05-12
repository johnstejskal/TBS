package staticData 
{
	import ManagerClasses.StateMachine;
	/**
	 * ...
	 * @author 
	 */
	public class SlideMenuStates 
	{
		
	static public const ARR_:Array = [
												 ["Play", StateMachine.STATE_GAME],
												 ["Competition", StateMachine.STATE_COMPETITION],
												 ["My Prizes", StateMachine.STATE_PRIZES_WON],
												 ["Shop", StateMachine.STATE_SHOP],
												 ["Achievements", StateMachine.STATE_ACHIEVEMENT], 
												 ["Leaderboards", StateMachine.STATE_LEADERBOARDS],
												 ["Share", StateMachine.STATE_SHARE],
												 ["Find a Maccas", StateMachine.STATE_FIND_STORE],
												 ["Redeem a code", StateMachine.STATE_REDEEM],
												 ["About", StateMachine.STATE_ABOUT],
												 ["Settings", StateMachine.STATE_SETTINGS],
												 ["Profile", StateMachine.STATE_PROFILE],
												 ["Login/Register", StateMachine.STATE_REGISTER]
												 ];
		
	}

}