#define TRUE 1
#define FALSE 0

#define ZERO_VEC3 (0, 0, 0)

#define GENERIC_INIT \
	init() \
	{ \
		thread onPlayerConnect(); \
	}

#define WAIT_CNT(ent) level waittill ( "connected", ent )

#define WAIT_ANY_RET(ent, ...) \
	ent common_scripts\utility::waittill_any_return( __VA_ARGS__ )

#define PLAYER_NOTIFY_CMD(ent, str, action) ent notifyOnPlayerCommand( str, action )

/* Tweak as necessary. Can be return, continue or break  */
#define CHK_ACTION continue

#ifdef IW4
#define BOT_CHK(ent) \
	if ( ent isBot() ) \
	{ \
		CHK_ACTION; \
	}
#else /* Valid for Plutinium IW5 with bot warfare */
#define BOT_CHK(ent) \
	if ( isDefined( ent.pers["isBot"] ) && ent.pers["isBot"] ) \
	{ \
		CHK_ACTION; \
	}
#endif

#define DEFINE_CHK(x) \
	if ( !isDefined( (x) ) ) \
	{ \
		CHK_ACTION; \
	}
