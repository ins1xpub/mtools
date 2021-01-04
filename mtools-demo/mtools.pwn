#if defined credits
.--------------------------------------------------------------------.
|                          |                                         |
|    db d8b   db .d8888.   | filterscript: MTOOLS                    |
|   o88 888o  88 88'  YP   | sa-mp server version: 0.3.7             |
|    88 88V8o 88 `8bo.     | contacts:                               |
|    88 88 V8o88   `Y8b.   | Discord: 1NS#7233                       |
|    88 88  V888 db   8D   | site: https://vk.com/1nsanemapping	     |
|    VP VP   V8P `8888Y'   | developer: 1NS                          |
|                          |                                2020     |
.--------------------------------------------------------------------.
/*
About MTOOLS for Texture Studio SA:MP

MTOOLS is a filterscript that complements Texture Studio and provides a classic dialog interface with basic map editor functionality.

MTOOLS appeared as a result of the fact that I was missing some basic functions in Texture Studio, their list was replenished and the idea of merging into one filterscript came up. The task of mtools is to provide more functions to mappers for more flexible work.

Editor options : TABSIZE 4, encoding utf-8 
*/
#endif

// VERSION
#define VERSION              	"0.3.7"
#define BUILD_DATE             	"27.12.2020"

#define DIALOG_MAIN 				6001
#define DIALOG_OBJECTS				6002
#define DIALOG_CREATEOBJ 			6003
#define DIALOG_DELETE 				6004
#define DIALOG_CAMSET 				6005
#define DIALOG_GROUPEDIT			6006
#define DIALOG_OBJLIST				6007
#define DIALOG_TUTORIAL				6008
#define DIALOG_CREATEMENU			6009
//#define DIALOG_CREATE3DTEXT			6010
#define DIALOG_CREATEMAPICON		6011
#define DIALOG_CREATEPICKUP			6012
#define DIALOG_SCOORDS				6013
#define DIALOG_SETTINGS				6014
#define DIALOG_INFOMENU				6015
#define DIALOG_WEATHER				6016
#define DIALOG_TIME					6017
#define DIALOG_ETC					6018
#define DIALOG_KEYBINDS				6019
#define DIALOG_ABOUT				6020
#define DIALOG_CLEARTEMPFILES		6021
#define DIALOG_SOUNDTEST			6022
#define DIALOG_CMDS					6023
#define DIALOG_GRAVITY				6024
#define DIALOG_ROTATION				6025
#define DIALOG_VEHICLE				6026
#define DIALOG_SOUNDPOINT			6027
#define DIALOG_SKIN					6028
#define DIALOG_CAMINTERPOLATE		6029
#define DIALOG_EDITMENU				6030
#define DIALOG_REMMENU				6031
#define DIALOG_TEXTUREMENU			6032
#define DIALOG_MAPMENU				6033
#define DIALOG_INTERFACE_SETTINGS	6034
#define DIALOG_MAINMENU_KEYBINDSET	6035
#define DIALOG_ACTORS				6036
#define DIALOG_ACTORSMASSMENU		6037
#define DIALOG_ACTORSMASSANIM		6038
#define DIALOG_ACTORCREATE			6039
#define DIALOG_ACTORANIMLIB			6040
#define DIALOG_ACTORANIMNAME		6041
#define DIALOG_PLAYERATTACHMAIN		6042
#define DIALOG_ATPINDEX_SELECT		6043
#define DIALOG_ATPMODEL_SELECT		6044
#define DIALOG_ATPBONE_SELECT		6045
#define DIALOG_ATPCOORD_INPUT		6046
#define DIALOG_VAE					6047
#define DIALOG_VAENEW				6048
#define DIALOG_CREATEPICKUP_BYNUM	6049
#define DIALOG_OBJECTSMENU			6050
#define DIALOG_FAVORITES			6051
#define DIALOG_LIMITS				6052
#define DIALOG_REMDEFOBJECT			6053
#define DIALOG_ACTORINDEX			6054
#define DIALOG_VEHSETTINGS			6055
#define DIALOG_VEHMOD				6056
#define DIALOG_RANGEDEL				6057
#define DIALOG_CAMPOINT				6058
#define DIALOG_CAMDELAY				6059
#define DIALOG_CAMENVIROMENT		6060
#define DIALOG_MOVINGOBJ			6061
#define DIALOG_CAMFIX				6062
#define DIALOG_WHEELS				6063
#define DIALOG_OBJSEARCH			6064
#define DIALOG_TEXTURESEARCH		6065
#define DIALOG_ACTORMASSANIM		6066
#define DIALOG_VEHSPEC				6067
#define DIALOG_VEHSTYLING			6068
#define DIALOG_SPOILERS				6069
#define DIALOG_CREDITS				6070
#define DIALOG_OBJDISTANCE			6071
#define DIALOG_OBJDISTANCE2			6072
#define DIALOG_MAPINFO				6073
#define DIALOG_MAPINFO_RESULTS		6074
#define DIALOG_DUPLICATESEARCH		6075
#define DIALOG_CAMSPEED				6076
#define DIALOG_FMACCEL				6077
#define DIALOG_FMSPEED				6078
#define DIALOG_CREATE3DTEXT			6079
#define DIALOG_3DTEXTMENU			6080
#define DIALOG_INDEX3DTEXT			6081
#define DIALOG_UPDATE3DTEXT			6082
#define DIALOG_DYNOBJSPEED			6083
#define DIALOG_DISTANCE3DTEXT		6084
#define DIALOG_COLOR3DTEXT			6085
#define DIALOG_MODELSIZEINFO		6086
#define DIALOG_ASKDELETE			6087
#define DIALOG_GAMETEXTTEST			6088
#define DIALOG_GAMETEXTSTYLE		6089

#define COLOR_SERVER_GREY		0x87bae7FF
#define COLOR_GREY 				0xAFAFAFAA
#define COLOR_RED  				0xF40B74FF
#define COLOR_LIME 				0x33DD1100

#include <a_samp> 
#include <foreach>
#if !defined foreach
	#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
	#define __SSCANF_FOREACH__
#endif
//#tryinclude <mselect> // https://github.com/Open-GTO/mselect
//#include <YSF> //https://github.com/IllidanS4/YSF/wiki

#if !defined _YSF_included
	#if !defined GetGravity
	native Float:GetGravity();
	#endif
#endif

#if !defined _YSF_included
// Already defined in YSF.inc
IsPlayerSpawned(playerid)
{
	new pState = GetPlayerState(playerid);
	return 0 <= playerid <= MAX_PLAYERS && pState != PLAYER_STATE_NONE && pState != PLAYER_STATE_WASTED && pState != PLAYER_STATE_SPECTATING;
}
#endif

//#include <mselect>
#include "/modules/streamer.inc"
//#include <streamer>
#include <filemanager>

/* ** Macros ** */
// HOLDING(keys)
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
// RELEASED(keys)
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
// PRESSED(keys)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define isnull(%1) \
	((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
	
#define GetDistanceBetweenPoints(%0,%1,%2,%3,%4,%6) \
	(VectorSize(%0-%3,%1-%4,%2-%6))

// Streamer macros
#define GetStreamerVersion()					Streamer_IncludeFileVersion
#define GetDynamicObjectPoolSize()				Streamer_GetUpperBound(STREAMER_TYPE_OBJECT)
#define GetDynamicObjectModel(%1)				Streamer_GetIntData(STREAMER_TYPE_OBJECT,(%1),E_STREAMER_MODEL_ID)
//GetNearestVisibleItem
#define GetNearestVisibleObject(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_OBJECT)
#define GetNearestVisiblePickup(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_PICKUP)
#define GetNearestVisibleCP(%0)					GetNearestVisibleItem((%0),STREAMER_TYPE_CP)
#define GetNearestVisibleRaceCP(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_RACE_CP)
#define GetNearestVisibleMapIcon(%0)			GetNearestVisibleItem((%0),STREAMER_TYPE_MAP_ICON)
#define GetNearestVisible3DText(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_3D_TEXT_LABEL)
#define GetNearestVisibleArea(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_AREA)
#define GetNearestVisibleActor(%0)				GetNearestVisibleItem((%0),STREAMER_TYPE_ACTOR)
// check old or new streamer plugin connected
#if defined INVALID_STREAMER_ID
	#define _new_streamer_included
#else 
	#define INVALID_STREAMER_ID (0)
#endif

#if defined _streamer_included
	#define MAX_OBJECTS			4096
	#define MAX_ACTORS			4096
	#define MAX_PICKUPS			4096
	#define MAX_MAPICONS		512
	#define MAX_3DTEXT_GLOBAL	4096
	#define MAX_REMOVED_OBJECTS	1000
#else
	#define MAX_MAPICONS		100
	#define MAX_REMOVED_OBJECTS	1000
#endif

// for compatibility with older streamer versions
#if !defined _streamer_included
	#if defined STREAMER_TYPE_OBJECT
		#define _streamer_included
	#endif
#endif

/*
65535 invalid objectid
1000 max objects
0 - 999 possible objectid

0 invalid dynamic objectid
~2147483647 max dynamic objects
1 - 2147483647 possible dynamic objectid
*/

#define INVALID_OBJECT_ID (0xFFFF)
#define TEXT3D_DEFAULT_DISTANCE 	20.0
#define TEXT3D_DEFAULT_COLOR	 	0xAFAFAFAA

#define TEXTURE_STUDIO
#define FILTERSCRIPT

// Variables without :bool tag because have problems with export to sql
new DB: mtoolsDB; //main database
new DEBUG = false;
new mtoolsRcon = false;
new bindFkeyToFlymode = false;
new useJetpack;
new useNOS = true;
new useBoost = false;
new useFlip = true;
new useAutoTune = true;
new useAutoFixveh = true;
new use3dTextOnObjects = true;
new removePlayerVehicleOnExit = false;
new targetInfo = true;
new streamedObjectsTD = true;
new aimPoint = true;
new vehCollision = true;
new superJump = true;
new fpsBarTD = true;
new autoLoadMap = true;
new showEditMenu = true;
new askDelete = true;

new mainMenuKeyCode = 1024; // ALT key
new LangSet = 0;
new EDIT_OBJECT_ID[MAX_PLAYERS];
new EDIT_OBJECT_MODELID[MAX_PLAYERS];
new LAST_OBJECT_ID[MAX_PLAYERS];
new PlayerVehicle[MAX_PLAYERS];
new bool:OnFly[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];
new Vehcam[MAX_PLAYERS];
new MAX_VISIBLE_OBJECTS; //defined at OnGameMode init
// PlayerTextDraws
new PlayerText:Objrate[MAX_PLAYERS];
new PlayerText:FPSBAR[MAX_PLAYERS];
new PlayerText:TDspecbar[MAX_PLAYERS]; 
new PlayerText:TDAIM[MAX_PLAYERS];
new PlayerText:Logo[MAX_PLAYERS];

// Forwards
forward LoadMtoolsDb(); // load mtlools.db
forward OnScriptUpdate(); // 0,5 sec timer (replace OnPlayerUpdtae)
forward ShowPlayerMenu(playerid, dialogid); // mtools main menu
forward DeleteObjectsInRange(playerid, Float:range);
forward SpawnNewVehicle(playerid, vehiclemodel); //spawn new veh by id
forward VaeUnDelay(target); // vae delay timer
forward VaeGetKeys(playerid); // vae keys hook
forward SurflyMode(playerid); // switch on/off surfly
forward Surfly(playerid); // timer
forward SetPlayerLookAt(playerid,Float:x,Float:y); // cam set look at point
forward GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz); 
forward MtoolsHudToggle(playerid);// on-off hud
forward FirstPersonMode(playerid);// on-off 1-st person mode

enum preSets
{
	Float:X1, Float:Y1,	Float:Z1,
	Float:X2, Float:Y2, Float:Z2,
	CamDelay, EditStatus
}

new Float:CamData[MAX_PLAYERS][preSets];

enum text3dData
{
	Text3D:index3d, Text3Dvalue[64],
	Text3Dcolor[11], Float: Text3Ddistance,
	Float: tPosX, Float: tPosY, Float: tPosZ
}
new Text3dArray[MAX_3DTEXT_GLOBAL][text3dData];
new CurrentIndex3dText = 0;

enum oMovData
{
	Float:X1, Float:Y1,	Float:Z1,
	Float:X2, Float:Y2, Float:Z2,
	MoveSpeed, movobject
}

new Float:ObjectsMoveData[MAX_PLAYERS][oMovData];
// vae
enum playerSets
{
	Float:OffSetX,
	Float:OffSetY,
	Float:OffSetZ,
	Float:OffSetRX,
	Float:OffSetRY,
	Float:OffSetRZ,
	obj,
	EditStatus,
	bool: delay,
	lr,
	VehicleID,
	objmodel,
	timer
}

new Float:VaeData[MAX_PLAYERS][playerSets];

const vaeFloatX =  1;
const vaeFloatY =  2;
const vaeFloatZ =  3;
const vaeFloatRX = 4;
const vaeFloatRY = 5;
const vaeFloatRZ = 6;
const vaeModel   = 7;
// END vae

// attachobjectseditor
enum
{
	Float:ATPCOORD_X,
	Float:ATPCOORD_Y,
	Float:ATPCOORD_Z
}
enum
{
	ATPPOS_OFFSET_X,
	ATPPOS_OFFSET_Y,
	ATPPOS_OFFSET_Z,
	ROT_OFFSET_X,
	ROT_OFFSET_Y,
	ROT_OFFSET_Z,
	ATPSCALE_X,
	ATPSCALE_Y,
	ATPSCALE_Z
}

new AttachmentBones[18][15] =
{
	{"�����"},
	{"������"},
	{"�. �����"},
	{"��. �����"},
	{"�. �����"},
	{"��. �����"},
	{"�. �����"},
	{"��. �����"},
	{"�. �����"},
	{"��. �����"},
	{"��. ������"},
	{"�. ������"},
	{"�. ����������"},
	{"��. ����������"},
	{"�. �������"},
	{"��. �������"},
	{"���"},
	{"�������"}
};

new AttachmentBonesEN[18][15] =
{
	{"Back"},
	{"Head"},
	{"L. shoulder"},
	{"Right shoulder"},
	{"L. Brush"},
	{"Ex. Brush"},
	{"L. thigh"},
	{"Right thigh"},
	{"L. stop"},
	{"Right stop"},
	{"Right shin"},
	{"L. shin"},
	{"L. forearm"},
	{"R. forearm"},
	{"L. collarbone"},
	{"R. collarbone"},
	{"Neck"},
	{"Jaw"}
};

new
bool:	gEditingAttachments		[MAX_PLAYERS],
		gCurrentAttachIndex		[MAX_PLAYERS],
bool:	gIndexUsed				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS],
		gIndexModel				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS],
		gIndexBone				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS],
Float:	gIndexPos				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][3],
Float:	gIndexRot				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][3],
Float:	gIndexSca				[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][3],
		gCurrentAxisEdit		[MAX_PLAYERS];
// END attachobjectseditor

// Don't use for old streamer versions //massactor[10];
new indexActor = 0, animactordatalib[32], animactordataname[32];
#if defined STREAMER_TAG_ACTOR
new massactor[10];
#endif
//new Actors[11] = {0, 0, ...};
new Actors[10];

new array_FavObjects[28] = {
	1215,1290,1570,1223,3534,3525,3461,3877,
	3524,3472,3437,19588,18728,1361,8623,2811,
	3509,738,19943,1255,946,638,650,3471,1460
};

isNumeric(const string[])
{
    for(new x = 0; x < strlen(string); x++)
    {
        if(string[x] < '0' || string[x] > '9')
            return false;
    }
    return true;
}

main()
{
	print("Filterscript mtools loaded successful.\n");
}

public LoadMtoolsDb()
{
	if(fexist("mtools/mtools.db"))
	{
		mtoolsDB = db_open("mtools/mtools.db");
		print("mtools.db loaded");
	} else {
		// Create table with default values
		mtoolsDB = db_open("mtools/mtools.db");
		db_query(mtoolsDB, "CREATE TABLE Settings (Option text, Value int)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('Language',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('mainMenuKeyCode',1024)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('bindFkeyToFlymode',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('aimPoint',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('useNOS',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('useBoost',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('useFlip',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('useAutoTune',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('useAutoFixveh',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('use3dTextOnObjects',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('removePlayerVehicleOnExit',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('targetInfo',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('streamedObjectsTD',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('vehCollision',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('superJump',0)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('fpsBarTD',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('autoLoadMap',1)");
		db_query(mtoolsDB, "INSERT INTO Settings (Option, Value) VALUES('showEditMenu',1)");
		if(fexist("mtools/mtools.db")) print("mtools.db created");
		else print("[fail] create mtools.db. Check /scriptfiles/mtools the directory was created!");
	}
	
	// Load settings
	new DBResult:MtoolsSettings;
	new field[64];
	MtoolsSettings = db_query(mtoolsDB, "SELECT Option, Value FROM Settings"); 
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	//printf("value lang: %i", strval(field));
	LangSet = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	mainMenuKeyCode = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	bindFkeyToFlymode = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	aimPoint = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	useNOS = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	useBoost = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	useFlip = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	useAutoTune = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	useAutoFixveh = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	use3dTextOnObjects = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	removePlayerVehicleOnExit = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	targetInfo = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	streamedObjectsTD = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	vehCollision = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	superJump = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	fpsBarTD = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	autoLoadMap = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	
	db_get_field_assoc(MtoolsSettings, "Value", field, 24);
	showEditMenu = strval(field);
	db_next_row(DBResult:MtoolsSettings);
	//db_free_result(MtoolsSettings);
	return 1;
}

public OnFilterScriptInit()
{
	// Load database
	LoadMtoolsDb();
	// Init 0,5 sec timer 
	SetTimer("OnScriptUpdate",500,true);
	// Check rcon mode
	if(fexist("mtools/rcon.txt")) {
		mtoolsRcon = true;
	}
	if(fexist("mtools/debug.txt")) {
		DEBUG = true;
	}
	// vae init
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			VaeData[i][timer] = -1;
			VaeData[i][obj] =  -1;
		}
	}
	// server version checker
	new server_version[64];
    GetConsoleVarAsString("version", server_version, sizeof(server_version));
	if(strfind("0.3.7", server_version, true) != -1)
	{
		printf("Recommended server version is 0.3.7, current %s", server_version);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	//PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);// camera shot
	//SendClientMessage(playerid, COLOR_GREY, 
	//"Visit mtools developers page: https://vk.com/1nsanemapping");
	
	#if defined _new_streamer_included
	// Streamer config
	#undef STREAMER_OBJECT_SD
	#define STREAMER_OBJECT_SD 550.0
	#undef STREAMER_OBJECT_DD
	#define STREAMER_OBJECT_DD 550.0
	
		// use if there are many objects in the interiors and they don�t hope to load
		#if defined AddSimpleModel // DL-SUPPORT
			Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 1500);
		#else
			//Sets the current visible item amount 1000 objects(default 500)
			#if defined Streamer_SetVisibleItems
			Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, MAX_OBJECTS, -1);
			#endif
		#endif	
	#endif
	//print("Streamer config:");
	/*(new tmpstr[64];
	format(tmpstr, sizeof(tmpstr), "STREAMER_OBJECT_SD: %.1f | STREAMER_OBJECT_DD: %.1f",
	STREAMER_OBJECT_SD, STREAMER_OBJECT_DD);
	printf("%s", tmpstr);
	*/
	//printf("MAX_VISIBLE_OBJECTS: %i", MAX_VISIBLE_OBJECTS);
	SendRconCommand("language English/Russian");
	
	// This feature is disabled by default to save bandwidth. 
	// But needto use GetPlayerCameraTargetVehicle(playerid)
	EnablePlayerCameraTarget(playerid, true);
	// Texdraws 
	// objects rate info
	Objrate[playerid] = CreatePlayerTextDraw(playerid, 34, 310, "_");
	PlayerTextDrawLetterSize(playerid, Objrate[playerid], 0.20, 1.2);
	PlayerTextDrawAlignment(playerid, Objrate[playerid], 1);
	//PlayerTextDrawColor(playerid, Objrate[playerid], 0xDFA906AA);
	PlayerTextDrawColor(playerid, Objrate[playerid], 0xFFFFFFFF);
	PlayerTextDrawSetShadow(playerid, Objrate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Objrate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Objrate[playerid], 255);
	PlayerTextDrawFont(playerid, Objrate[playerid], 2);
	PlayerTextDrawSetProportional(playerid, Objrate[playerid], 1);
	
	FPSBAR[playerid] = CreatePlayerTextDraw(playerid, 34, 325, "_");
	PlayerTextDrawLetterSize(playerid, FPSBAR[playerid], 0.20, 1.2);
	PlayerTextDrawAlignment(playerid, FPSBAR[playerid], 1);
	//PlayerTextDrawColor(playerid, FPSBAR[playerid], 0xDFA906AA);
	PlayerTextDrawColor(playerid, FPSBAR[playerid], 0xFFFFFFFF);
	PlayerTextDrawSetShadow(playerid, FPSBAR[playerid], 0);
	PlayerTextDrawSetOutline(playerid, FPSBAR[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, FPSBAR[playerid], 255);
	PlayerTextDrawFont(playerid, FPSBAR[playerid], 2);
	PlayerTextDrawSetProportional(playerid, FPSBAR[playerid], 1);
	
	TDspecbar[playerid] = CreatePlayerTextDraw(playerid, 20.0, 150.0, " "); 
	PlayerTextDrawFont(playerid, TDspecbar[playerid], 1); 
	PlayerTextDrawLetterSize(playerid, TDspecbar[playerid], 0.195, 0.9); 
	PlayerTextDrawSetOutline(playerid, TDspecbar[playerid], 1); 
	
	TDAIM[playerid] = CreatePlayerTextDraw(playerid, 320.5, 211.5, "."); //light
	PlayerTextDrawFont(playerid, TDAIM[playerid], 1); 
	PlayerTextDrawBackgroundColor(playerid, TDAIM[playerid], 255);
	PlayerTextDrawColor(playerid, TDAIM[playerid], -1);
	PlayerTextDrawLetterSize(playerid, TDAIM[playerid], 0.5, 1.6); 
	PlayerTextDrawSetOutline(playerid, TDAIM[playerid], 0);
	PlayerTextDrawSetProportional(playerid, TDAIM[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TDAIM[playerid], 0);
	
	Logo[playerid] = CreatePlayerTextDraw(playerid, 500, 8, "~R~M~w~TOOLS"); 
	PlayerTextDrawFont(playerid, Logo[playerid], 1); 
	PlayerTextDrawLetterSize(playerid, Logo[playerid], 0.3, 1.0); 
	PlayerTextDrawSetOutline(playerid, Logo[playerid], 1); 
	PlayerTextDrawShow(playerid, Logo[playerid]);
	
	// vars init
	SetPVarInt(playerid,"lang",LangSet);
	SetPVarInt(playerid,"hud",1);
	SetPVarInt(playerid,"freezed",0);
	SetPVarInt(playerid,"specbar",-1);
	SetPVarInt(playerid,"Firstperson",0);
	SetPVarInt(playerid,"LightsStatus",0);
	SetPVarInt(playerid, "drunk", 0);
	PlayerTextDrawShow(playerid, Objrate[playerid]);
	PlayerTextDrawShow(playerid, FPSBAR[playerid]);

	SetPlayerTime(playerid,12,0); 
	SetPVarInt(playerid,"Hour",12); 
	SetPlayerWeather(playerid,0); 
	SetPVarInt(playerid,"Weather",0);
	
	VaeData[playerid][timer] = -1;
	VaeData[playerid][obj] =  -1;
	EDIT_OBJECT_ID[playerid] = -1;
	
	OnFly[playerid] = false;
	//hide logo
	//#if defined TEXTURE_STUDIO
	//CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/logo");
	//#endif
	
	SendClientMessageToAllEx(0x33DD1100, "������� <ALT> ��� ������ mtools. ��������� /help ",
	"Press <Y> to open mtools. Use /help to get more");
	SendClientMessageToAllEx(0x33DD1100, "������ ��� ���������� � ������ �������� ���� ��������� ����� (/loadmap)",	"Create or load a map before getting started (/loadmap)");
	
	if(autoLoadMap)
	{
		#if defined TEXTURE_STUDIO
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/loadmap");		
		#endif
	}	
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerHealth(playerid, 99999);
	if(DEBUG)
	{
		SetPlayerSkin(playerid, 160);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	//firstpersonfix
	if(IsValidObject(firstperson[playerid])) {
		DestroyObject(firstperson[playerid]);
	} 
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid,	Logo[playerid]);
	PlayerTextDrawDestroy(playerid, TDspecbar[playerid]);
	PlayerTextDrawDestroy(playerid, TDAIM[playerid]);
	PlayerTextDrawDestroy(playerid, FPSBAR[playerid]);
	PlayerTextDrawDestroy(playerid, Objrate[playerid]);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// Open main menu on press ALT (rcon give full menu)
	if(newkeys == mainMenuKeyCode) 
	{
		if(mtoolsRcon) {
			if(IsPlayerAdmin(playerid)) ShowPlayerMenu(playerid, DIALOG_MAIN);
		} else {
			ShowPlayerMenu(playerid, DIALOG_MAIN);
		}
	
	}
	// open main menu in vehicle
	if(newkeys == 65536)// Y (InVehicle)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(mainMenuKeyCode == 1024)// KEY_ACTION
			{
				if(mtoolsRcon)
				{
					if(IsPlayerAdmin(playerid)) ShowPlayerMenu(playerid, DIALOG_MAIN);
				} else {
					ShowPlayerMenu(playerid, DIALOG_MAIN);
				}
			}
		}
	}
	// flip H key in vehicle
	if(useFlip)
	{
		if(newkeys == 2 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			FlipVehicle(GetPlayerVehicleID(playerid));
		}
	}
	// boost
	if(useBoost)
	{
		if(PRESSED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			const Float:velocity = 1.8;
			new Float:angle;
			GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
			new Float:vx = velocity * -floatcos(angle - 90.0, degrees);
			new Float:vy = velocity * -floatsin(angle - 90.0, degrees);
			SetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, 0.0);
		}
	}
	// autofix to LMB
	if(useAutoFixveh)
	{
		if(PRESSED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{ 
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
	}
	// Open vae menu on player attemp exit from veh
	if(GetPVarInt(playerid, "VaeEdit") > 0)
	{
		if(newkeys == KEY_SECONDARY_ATTACK) // ENTER
		{
			TogglePlayerControllable(playerid, false);
			SetPVarInt(playerid,"freezed",1);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
				PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
			}
			ShowPlayerMenu(playerid, DIALOG_VAE);
		}
	}
	// Start/stop flymode on F/ENTER
	if(newkeys == KEY_SECONDARY_ATTACK) // ENTER
	{
		if(bindFkeyToFlymode)
		{	
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
			#endif
		} else {
			if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
			{
				#if defined TEXTURE_STUDIO
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
				#endif
			}
			if(OnFly[playerid])// disable surfly
			{
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				SetPlayerPos(playerid,x,y,z);
				OnFly[playerid] = false;
			}
		}
	}
	// Auto tuning press 2
	if(useAutoTune)
	{
		if(newkeys == 512)
		{
			new WheelsIDs[14] = {1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085};
			// http://wiki.sa-mp.com/wiki/Car_Component_ID
			new RandomWheel = random(sizeof(WheelsIDs));
			new vehicleid = GetPlayerVehicleID(playerid);
			if (IsPlayerInAnyVehicle(playerid))
			{
				ChangeVehicleColor(vehicleid, random(120), random(120));
				switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
				{
					case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,
					493,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
				}
				AddVehicleComponent(vehicleid, WheelsIDs[RandomWheel]);
			}
		}
	}
	// Auto NOs refill
	if(useNOS)
	{
		if(newkeys == 1 || newkeys == 9 || newkeys == 33 
		&& oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
		{
			switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,
				493,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
			}
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		}
	}
	// Super jump on default <KEY_JUMP>
	if(PRESSED(KEY_JUMP))
	{
		if(superJump)
		{
			new Float:SuperJump[3];
			GetPlayerVelocity(playerid, SuperJump[0], SuperJump[1], SuperJump[2]);
			SetPlayerVelocity(playerid, SuperJump[0], SuperJump[1], SuperJump[2]+5);
		}
	}
	/*if(newkeys == KEY_SECONDARY_ATTACK)
	{
		if(useJetpack) {
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			useJetpack = false;
			SpawnPlayer(playerid);
		}
	}*/
	return 1;
}

public VaeGetKeys(playerid)
{
	new Keys, ud, gametext[36], Float: toAdd;
	
    GetPlayerKeys(playerid,Keys,ud,VaeData[playerid][lr]);    
	switch(Keys)
	{
		case KEY_FIRE:   toAdd = 0.000500;		
		default:         toAdd = 0.005000;
	}	
    if(VaeData[playerid][lr] == 128)
    {
        switch(VaeData[playerid][EditStatus])
        {
            case vaeFloatX:
            {
                VaeData[playerid][OffSetX] = floatadd(VaeData[playerid][OffSetX], toAdd);
                format(gametext, 36, "offsetx: ~w~%f", VaeData[playerid][OffSetX]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatY:
            {
                VaeData[playerid][OffSetY] = floatadd(VaeData[playerid][OffSetY], toAdd);
                format(gametext, 36, "offsety: ~w~%f", VaeData[playerid][OffSetY]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatZ:
            {
                VaeData[playerid][OffSetZ] = floatadd(VaeData[playerid][OffSetZ], toAdd);
                format(gametext, 36, "offsetz: ~w~%f", VaeData[playerid][OffSetZ]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRX:
            {
				if(Keys == 0) VaeData[playerid][OffSetRX] = floatadd(VaeData[playerid][OffSetRX],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRX] = floatadd(VaeData[playerid][OffSetRX],
				floatadd(toAdd,0.100000));					                			
                format(gametext, 36, "offsetrx: ~w~%f", VaeData[playerid][OffSetRX]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRY:
            {
            	if(Keys == 0) VaeData[playerid][OffSetRY] = floatadd(VaeData[playerid][OffSetRY],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRY] = floatadd(VaeData[playerid][OffSetRY],
				floatadd(toAdd,0.100000));	
            	format(gametext, 36, "offsetry: ~w~%f", VaeData[playerid][OffSetRY]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRZ:
            {
                if(Keys == 0) VaeData[playerid][OffSetRZ] = floatadd(VaeData[playerid][OffSetRZ],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRZ] = floatadd(VaeData[playerid][OffSetRZ],
				floatadd(toAdd,0.100000));	
                format(gametext, 36, "offsetrz: ~w~%f", VaeData[playerid][OffSetRZ]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeModel:
            {
                SetTimerEx("VaeUnDelay", 1000, false, "d", playerid);
                if(VaeData[playerid][delay]) return 1;
                DestroyObject(VaeData[playerid][obj]);
                VaeData[playerid][obj] = CreateObject(VaeData[playerid][objmodel]++,
				0.0, 0.0, -10.0, -50.0, 0, 0, 0);
                format(gametext, 36, "model: ~w~%d", VaeData[playerid][objmodel]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
				VaeData[playerid][delay] = true;
            }
		}
		AttachObjectToVehicle(VaeData[playerid][obj], VaeData[playerid][VehicleID],
		VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ],
		VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ]);
	}
	else if(VaeData[playerid][lr] == -128)
	{
	    switch(VaeData[playerid][EditStatus])
        {
            case vaeFloatX:
            {
                VaeData[playerid][OffSetX] = floatsub(VaeData[playerid][OffSetX], toAdd);
                format(gametext, 36, "offsetx: ~w~%f", VaeData[playerid][OffSetX]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatY:
            {
                VaeData[playerid][OffSetY] = floatsub(VaeData[playerid][OffSetY], toAdd);
                format(gametext, 36, "offsety: ~w~%f", VaeData[playerid][OffSetY]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatZ:
            {
                VaeData[playerid][OffSetZ] = floatsub(VaeData[playerid][OffSetZ], toAdd);
                format(gametext, 36, "offsetz: ~w~%f", VaeData[playerid][OffSetZ]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRX:
            {
				if(Keys == 0) VaeData[playerid][OffSetRX] = floatsub(VaeData[playerid][OffSetRX],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRX] = floatsub(VaeData[playerid][OffSetRX],
				floatadd(toAdd,0.100000));			
                format(gametext, 36, "offsetrx: ~w~%f", VaeData[playerid][OffSetRX]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRY:
            {
            	if(Keys == 0) VaeData[playerid][OffSetRY] = floatsub(VaeData[playerid][OffSetRY],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRY] = floatsub(VaeData[playerid][OffSetRY],
				floatadd(toAdd,0.100000));	
            	format(gametext, 36, "offsetry: ~w~%f", VaeData[playerid][OffSetRY]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeFloatRZ:
            {
                if(Keys == 0) VaeData[playerid][OffSetRZ] = floatsub(VaeData[playerid][OffSetRZ],
				floatadd(toAdd, 1.000000));	
				else VaeData[playerid][OffSetRZ] = floatsub(VaeData[playerid][OffSetRZ],
				floatadd(toAdd,0.100000));	
                format(gametext, 36, "offsetrz: ~w~%f", VaeData[playerid][OffSetRZ]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case vaeModel:
            {
                SetTimerEx("VaeUnDelay", 1000, false, "d", playerid);
                if(VaeData[playerid][delay]) return 1;
                DestroyObject(VaeData[playerid][obj]);
                VaeData[playerid][obj] = CreateObject(VaeData[playerid][objmodel]--,
				0.0, 0.0, -10.0, -50.0, 0, 0, 0);
                format(gametext, 36, "model: ~w~%d", VaeData[playerid][objmodel]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
				VaeData[playerid][delay] = true;
            }
		}
		AttachObjectToVehicle(VaeData[playerid][obj], VaeData[playerid][VehicleID],
		VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ],
		VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ]);
	}
    return 1;
}

public VaeUnDelay(target)
{
    VaeData[target][delay] = false;
    return 1;
}

#if defined _streamer_included
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	/*EDIT_OBJECT_ID[playerid] = objectid;
	new string[64];
	format(string, sizeof(string), "id: %i", EDIT_OBJECT_ID[playerid]);
	SendClientMessage(playerid, -1, string);*/
	
	if(showEditMenu)
	{
		if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
		{
			CancelEdit(playerid);
			ShowPlayerMenu(playerid,DIALOG_EDITMENU);
		}
	}
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	// TS Studio enum objects beginning with 0
	EDIT_OBJECT_ID[playerid] = objectid;
	EDIT_OBJECT_MODELID[playerid] = modelid;
	
	/*new string[64];
	format(string, sizeof(string), "id: %i model: %i", objectid, modelid);
	SendClientMessage(playerid, -1, string);*/
		
	switch(GetPVarInt(playerid, "Editmode"))
	{
		case 2:
	    {
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/editobject");
			#else
			EditDynamicObject(playerid, objectid);
			#endif
		}
		case 4:
		{
			if(askDelete)
			{
				ShowPlayerDialog(playerid, DIALOG_ASKDELETE, DIALOG_STYLE_MSGBOX,
				"You are sure?", "Delete this object?", "Delete", "Cancel");
			} else {
				#if defined TEXTURE_STUDIO
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dobject");
				#else
				DestroyDynamicObject(objectid);
				#endif
			}
		}
	}
	
	ShowPlayerMenu(playerid,DIALOG_EDITMENU);
	return 1;
}
#endif

/*
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	SetPVarInt(playerid, "SelectedObject", objectid);
	SetPVarInt(playerid, "ModelID", modelid);
	
	SendClientMessagef(playerid, -1, "objectid: %i modelid: %i", objectid, modelid);
	
	return 1;
}
*/
//==================================[CMDS]======================================

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[128], tmp[128], idx;
	cmd = strtok(cmdtext, idx);
	
	// Menu and submenu binds
	if(!strcmp(cmdtext, "/mtools", true))
    {
		ShowPlayerMenu(playerid, DIALOG_MAIN);
        return 1;
    }
	if (!strcmp(cmdtext, "/map", true))
	{
		ShowPlayerMenu(playerid,DIALOG_MAPMENU);
		return true;
	}
	if (!strcmp(cmdtext, "/mapload", true))
	{
		#if defined TEXTURE_STUDIO
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/loadmap");		
		#endif
		return true;
	}
	if (!strcmp(cmdtext, "/mapinfo", true))
	{
		ShowPlayerMenu(playerid,DIALOG_MAPINFO);
		return true;
	}
	if (!strcmp(cmdtext, "/cam", true))
	{
		ShowPlayerMenu(playerid,DIALOG_CAMSET);
		return true;
	}
	if (!strcmp(cmdtext, "/edit", true))
	{
		ShowPlayerMenu(playerid,DIALOG_EDITMENU);
		return true;
	}
	if (!strcmp(cmdtext, "/new", true))
	{
		ShowPlayerMenu(playerid,DIALOG_CREATEMENU);
		return true;
	}
	if (!strcmp(cmdtext, "/help", true))
	{
		ShowPlayerMenu(playerid, DIALOG_INFOMENU);
		return true;
	}
	if (!strcmp(cmdtext, "/cmds", true) || !strcmp(cmdtext, "/commands", true))
	{
		ShowPlayerMenu(playerid, DIALOG_CMDS);
		return true;
	}
	if(!strcmp(cmdtext,"/veh", true) || !strcmp(cmdtext,"/vehicle", true) || !strcmp(cmdtext,"/av", true))
    {
		ShowPlayerMenu(playerid, DIALOG_VEHICLE);
        return 1;
    }
	if(!strcmp(cmdtext,"/v", true))
    {
		#if defined TEXTURE_STUDIO
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/tcar");		
		#else
		SendClientMessage(playerid, -1, "Function unavaiable. Need TextureStudio");
		#endif
        return 1;
    }
	if (!strcmp(cmdtext, "/v ", true, 3))
	{
		if (!cmdtext[3])
		{
			SendClientMessageEx(playerid, COLOR_GREY,
			"�������������: /v [vehicleid]", "Use: /v [vehicleid]");
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/tcar");		
			#endif
			return true;
		}
		new PARAM = strval(cmdtext[3]);
		SpawnNewVehicle(playerid, PARAM);
		return true;
	}
	if (!strcmp(cmd, "/vehcolor", true) || !strcmp(cmd, "/cc", true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER){
			return SendClientMessageEx(playerid, -1,
			"�� ������ ���� � ������", "You must be in the car");
		}
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /carcolor [color1] [color2]. Colors 0-255");
		}
		new c1 = strval(tmp);
		
		if(c1 < 0 || c1 > 255)
		{
			return SendClientMessageEx(playerid, -1,
			"�������� ��������. ��������� 0-255", "Incorrect value. Available 0-255");
		}
		
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /carcolor [color1] [color2]. Colors 0-255");
		}
		new c2 = strval(tmp);
	
		if(c2 < 0 || c2 > 255)
		{
			return SendClientMessageEx(playerid, -1,
			"�������� ��������. ��������� 0-255", "Incorrect value. Available 0-255");
		}
		new tmpstr[64];
		new vehicleid = GetPlayerVehicleID(playerid);
		ChangeVehicleColor(vehicleid, c1, c2);
		PlayerPlaySound(playerid, 1134, 0, 0, 0);// respray
		format(tmpstr, sizeof tmpstr, "new colors %i - %i", c1, c2);
		SendClientMessage(playerid, -1, tmpstr);
		return 1;
	}
	if(!strcmp("/removepaintjob", cmd, true))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER){
			return SendClientMessageEx(playerid, -1,
			"�� ������ ���� � ������", "You must be in the car");
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		ChangeVehiclePaintjob(vehicleid, 3);
		return SendClientMessageEx(playerid, -1,
		"��������� ������� �������.", "Paintjob successfully deleted");
	}
	// vae
	if(!strcmp("/vae", cmd, true))
	{
		// if no object selected
		if(VaeData[playerid][obj] == -1)
		{
			ShowPlayerDialog(playerid, DIALOG_VAENEW, DIALOG_STYLE_INPUT, "VAE New attach", 
			"specify the object model to attach to the vehicle.\
			(For example minigun: 362)\nEnter model id:", ">>>","Cancel");
		} else {
			ShowPlayerMenu(playerid, DIALOG_VAE);
		}
		return true;
	}
	if(!strcmp("/vaestop", cmd, true))
	{
		KillTimer(VaeData[playerid][timer]);
		return SendClientMessageEx(playerid, -1, "�������������� ���������.", "Editing is complete");
	}
	if(!strcmp("/vaesave", cmd, true))
	{		
		tmp = strtok(cmdtext, idx);
		new File: file = fopen("mtools/Vaeditions.txt", io_append);
		new str[200];
		format(str, 200, "\r\nAttachObjectToVehicle(objectid, vehicleid, %f, %f, %f, %f, %f, %f); //Object Model: %d | %s", VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ], VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ], VaeData[playerid][objmodel], tmp);
		fwrite(file, str);
		fclose(file);
		return SendClientMessageEx(playerid, -1, "�� ��������� � \"vaeditions.txt\".", "Saved to \"vaeditions.txt\".");
	}
	if(!strcmp("/vaemodel", cmd, true))
	{
		//VaeData[playerid][EditStatus] = vaeModel;
		SendClientMessage(playerid, -1, "Editing Object Model.");
		ShowPlayerDialog(playerid, DIALOG_VAENEW, DIALOG_STYLE_INPUT,
		"VAE New attach", "specify the object model to attach to the vehicle.\
		(For example minigun: 362)\nEnter model id:", ">>>","Cancel");
	}
	// END vae
	if(!strcmp(cmdtext, "/drunk", true))
    {	
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			SendClientMessage(playerid, -1, "Set drunk level. Use: /drunk [0-50000]");
			SendClientMessageEx(playerid, -1, 
			"����� ������� ��������� ������ ���� 5000, ���������� HUD",
			"When the player's intoxication level is above 5000, the HUD is hidden.");
			SetPVarInt(playerid, "drunk", 0);
			SetPlayerDrunkLevel(playerid, 0);
		}
		new drunklvl = strval(tmp);
		//GetPlayerDrunkLevel(playerid);
		if(drunklvl > -1 && drunklvl <= 50000) SetPVarInt(playerid, "drunk", drunklvl);
		else SendClientMessage(playerid, -1, "Set drunk level. Use: /drunk [0-50000]");
		return 1;
	}
	if(!strcmp(cmdtext, "/flip", true))
    {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			FlipVehicle(GetPlayerVehicleID(playerid));
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/fix", true) || !strcmp(cmdtext, "/vehrepair", true))
    {
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{ 
			RepairVehicle(GetPlayerVehicleID(playerid));
		}
        return 1;
    }
	if(!strcmp(cmdtext, "/wheels", true))
    {
		ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST,
		"Wheels",
		"Shadow\nMega\nWires\nClassic\nRimshine\nCutter"\
		"\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance"\
		"\nAtomic\n{A9A9A9}Default",
		"OK", " < ");
		return 1;
	}
	if(!strcmp(cmdtext, "/hydraulics", true))
	{
		AddVehicleComponent(GetPlayerVehicleID(playerid),1087);
		PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		return 1;
	}
	if(strcmp(cmdtext, "/lights", true) == 0)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(vehicleid != INVALID_VEHICLE_ID)
			{
				if (GetPVarInt(playerid, "LightsStatus") != 0)
				{
					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "LightsStatus",0);
				} else {	
					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehicleid,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
					SetPVarInt(playerid, "LightsStatus",1);
				}
			}
		}
		return 1;
	}
	// debug
	if(!strcmp(cmdtext, "/specbar", true, 8)) 
	{
		new specid;
		if(!cmdtext[8]) 
		{
			if(GetPVarInt(playerid, "specbar") == -1)
			{
				PlayerTextDrawHide(playerid, TDspecbar[playerid]);
				specid = playerid;
				PlayerTextDrawShow(playerid, TDspecbar[playerid]);
				SetPVarInt(playerid, "specbar", specid);
				//SendClientMessageEx(playerid, COLOR_GREY, "��� ����������� ����� �������� ����������� ������� <Num4> � <Num6>", "Use the <Num4> and <Num6> keys to move between players");
				return true;
			} else {
				PlayerTextDrawHide(playerid, TDspecbar[playerid]);
				SetPVarInt(playerid, "specbar",-1);
				//SendClientMessageEx(playerid, COLOR_GREY, "������� ��� ��������. ������� /specbar <ID> ����� ��������", "Specbar was disabled. Use /specbar <ID> to enable");
				return true;
			}
		}
		PlayerTextDrawHide(playerid, TDspecbar[playerid]);
		specid = strval(cmdtext[9]);
		PlayerTextDrawShow(playerid, TDspecbar[playerid]);
		SetPVarInt(playerid, "specbar", specid);
		//SendClientMessageEx(playerid, COLOR_GREY, "��� ����������� ����� �������� ����������� ������� <Num4> � <Num6>", "Use the <Num4> and <Num6> keys to move between players");
		return true;
	}
	// EDITOR cmds
	if (!strcmp(cmd, "/rotate", true) || !strcmp(cmd, "/rot", true))
	{
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			SendClientMessage(playerid, -1, "Use: /rotate [rx] [ry] [rz]");
			return ShowPlayerMenu(playerid, DIALOG_ROTATION);
		}
		new rx = strval(tmp);
		
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			SendClientMessage(playerid, -1, "Use: /rotate [rx] [ry] [rz]");
			return ShowPlayerMenu(playerid, DIALOG_ROTATION);
		}
		new ry = strval(tmp);
	
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			SendClientMessage(playerid, -1, "Use: /rotate [rx] [ry] [rz]");
			return ShowPlayerMenu(playerid, DIALOG_ROTATION);
		}
		new rz = strval(tmp);
 
		if(EDIT_OBJECT_ID[playerid] == -1) 
			return SendClientMessageEx(playerid, -1,
			"������ ����� ������� ������!", "first you need to select an object!");
		
		#if defined TEXTURE_STUDIO
		new param[24];
		format(param, sizeof(param), "/rx %d", rx);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		format(param, sizeof(param), "/ry %d", ry);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		format(param, sizeof(param), "/rz %d", rz);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		#else
		SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], rx, ry, rz);
		#endif
		return 1;
	}
	if (!strcmp(cmd, "/spos", true))
	{
		new Float:pos[4];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		GetPlayerFacingAngle(playerid, pos[3]);
		SetPVarFloat(playerid, "lastPosX", pos[0]);
		SetPVarFloat(playerid, "lastPosY", pos[1]);
		SetPVarFloat(playerid, "lastPosZ", pos[2]);
		SetPVarFloat(playerid, "lastPosA", pos[3]);
		SendClientMessage(playerid, COLOR_GREY,
		"OnFoot position saved. Use: /lpos to load saved position");
		return 1;
	}
	if (!strcmp(cmd, "/lpos", true))
	{
		if(GetPVarType(playerid, "lastPosX") == PLAYER_VARTYPE_NONE)
		{
			return SendClientMessage(playerid, COLOR_GREY,
			"Use: /spos to save current OnFoot position");
		}
		SetPlayerPos(playerid, GetPVarFloat(playerid, "lastPosX"),
		GetPVarFloat(playerid, "lastPosY"), GetPVarFloat(playerid, "lastPosZ"));
		SetPlayerFacingAngle(playerid, GetPVarFloat(playerid, "lastPosA"));
		SendClientMessage(playerid, COLOR_GREY,
		"Saved OnFoot position loaded");
		return 1;
	}
	if (!strcmp(cmd, "/cpos", true) || !strcmp(cmd, "/coords", true))
	{
		GetPlayerCoords(playerid);
		return 1;
	}
	if (!strcmp(cmd, "/pos", true))
	{
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /pos [ox] [oy] [oz]");
		}
		new ox = strval(tmp);
		
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /pos [ox] [oy] [oz]");
		}
		new oy = strval(tmp);
	
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /pos [ox] [oy] [oz]");
		}
		new oz = strval(tmp);
 
		if(EDIT_OBJECT_ID[playerid] == -1) 
			return SendClientMessageEx(playerid, -1,
			"������ ����� ������� ������!", "first you need to select an object!");
		
		#if defined TEXTURE_STUDIO
		new param[24];
		format(param, sizeof(param), "/ox %d", ox);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		format(param, sizeof(param), "/oy %d", oy);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		format(param, sizeof(param), "/oz %d", oz);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		#else
		SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], ox, oy, oz);
		#endif
		return 1;
	}
	if (!strcmp(cmd, "/tpc", true))
	{
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /tpc [x] [y] [z]");
		}
		new px = strval(tmp);
		
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /tpc [x] [y] [z]");
		}
		new py = strval(tmp);
	
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			return SendClientMessage(playerid, -1, "Use: /tpc [x] [y] [z]");
		}
		new pz = strval(tmp);
		
		#if defined TEXTURE_STUDIO
		new param[24];
		format(param, sizeof(param), "/tpcoord %d %d %d", px, py, pz);
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
		#else
		SetPlayerPos(playerid, px, py, pz);
		#endif
		return 1;
	}
	if(!strcmp(cmdtext, "/newobj", true) || !strcmp(cmdtext, "/oadd", true))
	{
		ShowPlayerMenu(playerid,DIALOG_CREATEOBJ);
		return 1;
	}
	if(!strcmp(cmdtext, "/dive", true))
	{
		if(IsPlayerInAnyVehicle(playerid)) return 1;
		tmp = strtok(cmdtext, idx);
		if (strlen(tmp) == 0){
			SendClientMessage(playerid, -1, "Use: /dive [100-2000]");
			return ShowPlayerMenu(playerid, DIALOG_ROTATION);
		}
		new height = strval(tmp);
		
		if(height < 100 || height > 2000) {
			return SendClientMessageEx(playerid, -1,
			"������������ ��������. ���������� �� 100 �� 2000",
			"Incorrect value. Valid from 100 to 2000");
		}
		new Float:x, Float:y, Float:z;
		//if(IsApplyAnimation(playerid, "FALL_fall") && z > 150) return 1;
		GetPlayerPos(playerid, x, y, z);
		z = z + height;
		SetPlayerPos(playerid, x, y, z);
		GivePlayerWeapon(playerid, 46, 1);
		return 1;
	}
	if(!strcmp(cmdtext, "/nearest", true))
	{
		new tmpstr[64];
		new objectid = GetNearestVisibleItem(playerid, STREAMER_TYPE_OBJECT);
		if (GetPVarInt(playerid, "lang") == 0) {
			format(tmpstr, sizeof(tmpstr), "Nearest object -  objectid: %i modelid: %i",
			objectid, GetDynamicObjectModel(objectid));
		} else {
			format(tmpstr, sizeof(tmpstr), "��������� ������ - objectid: %i modelid: %i",
			objectid, GetDynamicObjectModel(objectid));
		}
		SendClientMessage(playerid, -1, tmpstr);
		return 1;
	}
	// camera cmds
	if (!strcmp(cmdtext, "/fixcam", true))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			new Float:x1,Float:y1,Float:z1;
			GetPlayerCameraPos(playerid,x1,y1,z1);
			SetPlayerCameraPos(playerid, x1,y1,z1);
			GetPlayerCameraLookAt(playerid, x1,y1,z1);
			SetPlayerCameraLookAt(playerid, x1,y1,z1);
		} else {
			new Float:X, Float:Y, Float:Z, Float:Angle;
			GetPlayerPos(playerid, X , Y , Z);
			GetPlayerFacingAngle(playerid, Angle);
			SetPlayerCameraPos(playerid, X , Y , Z); 
			SetPlayerCameraLookAt(playerid, X , Y , Z);
			GetPlayerFacingAngle(playerid, Angle);
		}
		SendClientMessageEx(playerid, -1,
		"������� /retcam ��� ���� ����� ������� ������",
		"Enter /retcam to return the camera");
		return 1;
	}
	if (!strcmp(cmdtext, "/retcam", true))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
			#endif
		} else {
			SetCameraBehindPlayer(playerid);
		}
		return 1;
	}
	if (!strcmp(cmdtext, "/firstperson", true))
	{
		FirstPersonMode(playerid);
		return true;
	}
	if (!strcmp(cmdtext, "/camera", true))
	{
		GivePlayerWeapon(playerid, 43, 10000);
		return true;
	}
	if (!strcmp(cmdtext, "/jump", true))
	{
		Jump(playerid);
		return true;
	}
	if (!strcmp(cmdtext, "/fly", true) || !strcmp(cmdtext, "/surfly", true))
	{
		SurflyMode(playerid);
		return true;
	}
	if (!strcmp(cmdtext, "/hud", true))
	{
		MtoolsHudToggle(playerid);
		return true;
	}
	if (!strcmp(cmdtext, "/nologo", true))
	{
		PlayerTextDrawHide(playerid, Logo[playerid]);
		return true;
	}
	if(!strcmp(cmdtext, "/freeze", true))
	{
		if(GetPVarInt(playerid, "freezed") > 0)
		{
			TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid,"freezed",0);
			SendClientMessageEx(playerid, -1, "�� ������������","You are unfreezed");
		} else {
			TogglePlayerControllable(playerid, false);
			SetPVarInt(playerid,"freezed",1);
			SendClientMessageEx(playerid, -1, "�� �����������","You are freezed");
		}
		return 1;
	}
	if(!strcmp(cmdtext, "/unfreeze", true))
	{
		TogglePlayerControllable(playerid, true);
		SetPVarInt(playerid,"freezed",0);
		SendClientMessageEx(playerid, -1, "�� �����������","You are freezed");
		return 1;
	}
	if(!strcmp(cmdtext, "/slowmo", true))
	{
		if(GetGravity() == 0.008)
		{
			SendClientMessageEx(playerid, COLOR_LIME,
			"������� ����� ������",
			"Slow motion mode enabled");
			SetGravity(0.001);
		} else {
			SetGravity(0.008);
		}
		return 1;
	}
	if (!strcmp(cmdtext, "/respawn", true) || !strcmp(cmdtext, "/kill", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    {
	        SendClientMessageEx(playerid, COLOR_GREY,
			"������ �� �� ������ ������������.", "You can't respawn yourself right now.");
	        return true;
	    }
		SpawnPlayer(playerid);
		return true;
	}
	if(!strcmp(cmdtext, "/day", true))
	{
		SetPlayerTime(playerid, 9, 0);
		return 1;
	}
	if(!strcmp(cmdtext, "/night", true))
	{
		SetPlayerTime(playerid, 21, 0); 
		return 1;
	}
	if (!strcmp(cmdtext, "/weather", true))
	{
	    SendClientMessageEx(playerid, COLOR_GREY,
		"�������������: /weather [� ������]", "Use: /weather [weather ID]");
		ShowPlayerDialog(playerid, DIALOG_WEATHER, DIALOG_STYLE_INPUT,
		"Set weather",
		"Weather IDs 1-22 appear to work correctly (max 255)\n"\
		"Enter weather id\n", "Ok", "Cancel");
	    return true;
	}
	if (!strcmp(cmdtext, "/time", true))
	{
		SendClientMessageEx(playerid, COLOR_GREY,
		"�������������: /time [���]", "Use: /time [hour]");
		ShowPlayerDialog(playerid, DIALOG_TIME, DIALOG_STYLE_INPUT,
		"Set time", "Enter time [0-23]. Default [12].", "Ok", "Cancel");
		return true;
	}
	if (!strcmp(cmdtext, "/jetpack", true) || !strcmp(cmdtext, "/jp", true))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessageEx(playerid, COLOR_GREY, 
			"�� �� ������ ������������ ������� � ����������.", 
			"You can't use jetpack while spectating.");
			return true;
		}
		if (GetPlayerState(playerid) == SPECIAL_ACTION_USEJETPACK)
		{
			SendClientMessageEx(playerid, COLOR_GREY,
			"�� ��� �� ��������.", "You already have jetpack.");
			return true;
		}
		useJetpack = true;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		return true;
	}
	// Debug commands
	if(!strcmp(cmdtext, "/testf", true))
    {
		// Per AMX function calling
		//CallFunctionInScript("tstudio", "OnPlayerCommandText", "is", playerid, "/flymode");
		//CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
		//SelectObject(playerid);
		//SendClientMessagef(playerid, -1, "cam mode: %i", GetPlayerCameraMode(playerid));
		//SendClientMessagef(playerid, -1, "obj: %i", Streamer_GetUpperBound(STREAMER_TYPE_OBJECT)-1);
		//IsPlayerInRangeOfAnyObject(playerid, 20.0);
		new internalid = Streamer_GetItemInternalID(playerid, STREAMER_TYPE_OBJECT, EDIT_OBJECT_ID[playerid]);
		new streamerid = Streamer_GetItemStreamerID(playerid, STREAMER_TYPE_OBJECT, EDIT_OBJECT_ID[playerid]);
		printf("internalid %i streamerid %i", internalid, streamerid);
        return 1;
    }
	if (!strcmp(cmdtext, "/reloadmtools", true)) 
	{
		if(IsPlayerAdmin(playerid))
		{
			SendRconCommand("unloadfs mtools");
			SendRconCommand("loadfs mtools");
			SendClientMessageEx(playerid, COLOR_GREY, 
			"filterscript mtools ��� ������������",
			"filterscript mtools reloaded");
			return 1;
		} else {
			return SendClientMessageEx(playerid, COLOR_GREY,
			"��� ������������� ���� ������� ����� RCON �����", 
			"To use these functions, you need RCON rights!");
		}
	}
    return 0;
}

//================================END CMDS======================================

public OnPlayerText(playerid, text[])
{
   return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[256];
	if(dialogid == DIALOG_MAIN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerMenu(playerid, DIALOG_EDITMENU);
				case 1: ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
				case 2: ShowPlayerMenu(playerid, DIALOG_REMMENU);
				case 3: ShowPlayerMenu(playerid, DIALOG_TEXTUREMENU);
				case 4: ShowPlayerMenu(playerid, DIALOG_MAPMENU);
				case 5: ShowPlayerMenu(playerid, DIALOG_VEHICLE);
				case 6: ShowPlayerMenu(playerid, DIALOG_CAMSET);
				case 7: ShowPlayerMenu(playerid, DIALOG_ETC);
				case 8: ShowPlayerMenu(playerid, DIALOG_SETTINGS);
				case 9: ShowPlayerMenu(playerid, DIALOG_INFOMENU);
			}
		}
	}
	if(dialogid == DIALOG_INFOMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerMenu(playerid, DIALOG_CMDS);
				case 1:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/thelp");		
					#else
					SendClientMessage(playerid, -1, "Function unavaiable. Need TextureStudio");
					#endif
				}
				case 2: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, 
						"Hotkeys",
						"{FFFFFF}������� ������� mtools:\n"\
						"ALT - ������� ���� �������� ����\n"\
						"Escape - ����� ����� �� ���������, ��� ������ �������\n"\
						"Space - ����� ������� ������ �� ����� ��������������\n"\
						"� ������\n"\
						"2 - ����������\n\n"\
						"������� ������� Texture Studio:\n"\
						"������� ����:\n"\
						" � flymode - Shift � ������� ������ - N\n\n"\
						"��� ���������� ����� ������ �������� /mtextures\n"\
						"������� Alt � �������� ������� �� ������\n\n"\
						"� flymode ����� ������� ��������:\n"\
						" ���� - ������� F+Num4\n"\
						" ����� - ������� F+Num6\n"\
						" �������� ����� - Num4\n"\
						" �������� ������ - Num6\n"\
						"������� �������� �� � /flymode:\n"\
						" ���� - H\n"\
						" ����� - Y\n"\
						" �������� ����� - Num4\n"\
						" �������� ������ - Num6\n\n"\
						"�������� �������� � ����:\n"\
						" � �������� ��� ��������� ������� /csel - ������\n"\
						" � ������� ������ - ������+���\n\n"\
						"��� ���������� /editobject ������� Alt � ������ � ����������.\n"\
						"����������� �������� ������� � ����� ������ - H+��� �� �������\n"\
						"�������� �������� ������� �� ������ ������ - Alt+��� �� �������. \n",
						"OK","");
					} else {
						ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, 
						"Hotkeys",
						"GUI: When in fly mode to open the GUI press 'Jump Key'\n"\
						"otherwise it can be opened by pressing 'N' Key\n"\
						"{FFFFFF} mtools hotkeys: \n"\
						"ALT - will open the map editor menu \n"\
						"Escape - to exit the editor, or select an object \n"\
						"Space - to rotate the camera while editing \n"\
						"In the car \n"\
						"2 - auto tuning \n\n",
						"OK","");
					}
				}
				case 3:	//https://www.burgershot.gg/showthread.php?tid=174
				{
					PlayerPlaySound(playerid, 32402, 0.0, 0.0, 0.0); //heli slah ped 
					ShowPlayerDialog(playerid, DIALOG_CREDITS, DIALOG_STYLE_MSGBOX, "Credits", 
					"{FFFFFF}Texture Studio credits:\n\n"\
					"Pottus - Creating the script itself\n"\
					"Crayder - New developer\n\n"\
					"Incognito - Streamer plugin\n"\
					"Y_Less - sscanf - original object model sizes - YSI\n"\
					"Slice - strlib - sqlitei\n"\
					"JaTochNietDan Filemanager\n"\
					"SDraw - 3D Menu include\n"\
					"codectile - Objectmetry functions\n"\
					"Abyss Morgan - Streamer Functions\n",
					"OK", "");
				}
				case 4: 
				{
					new tbtext[500];
					new header[100];
					format(header, sizeof(header),
					"{FF0000}M{FFFFFF}TOOLS {FFFFFF}Version: {FFD700}%s{FFFFFF} build %s\n",
					VERSION, BUILD_DATE);
					if (GetPVarInt(playerid, "lang") == 0)
					{
						format(tbtext, sizeof(tbtext),
						"{FF0000}m{FFFFFF}tools � ��� filterscript ������� ��������� Texture Studio � �������������\n"\
						"������������ ��������� �� �������� � ��������� ��������� ��������� ����\n\n"\
						"������ �� ������� ��������� ������� ������� � Texture Studio\n"\
						"�� ������ ����������, � ������ ���� ������� ������ ���������� � ����\n"\
						"filterscript - ��� � �������� mtools\n\n"\
						"�������� �������� mtools: {4682b4}vk.com/1nsanemapping{FFFFFF}\n"\
						"����� ���? �������� � �������!\n");
					} else {
						format(tbtext, sizeof(tbtext),
						"{FF0000}m{FFFFFF}tools is a filterscript that complements Texture Studio and provides\n"\
						"a classic dialog interface with basic map editor functions\n\n"\
						"Many were missing some basic functionality in Texture Studio\n"\
						"their list was replenished, and the idea of ??merging into one filterscript\n"\
						"came up - and this is how mtools\n\n"\
						"mtools homepage: {4682b4}vk.com/1nsanemapping{FFFFFF}\n"\
						"Have you found a bug? Please report it!\n");
					}
					PlayerPlaySound(playerid, 32402, 0.0, 0.0, 0.0); //heli slah ped 
					ShowPlayerDialog(playerid, DIALOG_ABOUT, DIALOG_STYLE_MSGBOX,
					header,	tbtext, "OK", "");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_ETC)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_SCOORDS, DIALOG_STYLE_LIST, "Coords",
						"���������� � ������� �������\n"\
						"��������� ���������� � �������: X,Y,Z\n"\
						"��������� ���������� � �������: X,Y,Z,angle\n"\
						"��������� ���������� � �������: {X,Y,Z},\n"\
						"��������� ���������� � �������: {X,Y,Z,angle,world,interior},\n"\
						"��������� ���������� � �������: {maxX,mixX,maxY,minY},\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_SCOORDS, DIALOG_STYLE_LIST, "Coords",
						"information about the current position\n"\
						"save coordinates in the format: X,Y,Z\n"\
						"save coordinates in the format: X,Y,Z,angle\n"\
						"save coordinates in the format: {X, Y, Z},\n"\
						"save coordinates in the format: {X, Y, Z, angle, world, interior},\n"\
						"save coordinates in the format: {maxX, mixX, maxY, minY},\n",
						"Select","Cancel");
					}
				}
				case 1: Jump(playerid);
				case 2:
				{
					SurflyMode(playerid);
					// failunder
					//new Float:x, Float:y, Float:z;
					//GetPlayerPos(playerid, x,y,z);
					//SetPlayerPos(playerid,x,y,z-4);
				}
				/*case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_SOUNDPOINT, DIALOG_STYLE_INPUT, "Soundpoint",
					"{FFFFFF}Sets the radio to the player's current position(Example: 19800[bass])\nEnter sound ID:", "Select","Cancel");
				}*/
				case 3:
				{
					if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
					{
						SendClientMessageEx(playerid, COLOR_GREY,
						"�� �� ������ ������������ ������� � ����������.",
						"You can't use jetpack while spectating.");
						return true;
					}
					if (GetPlayerState(playerid) == SPECIAL_ACTION_USEJETPACK)
					{
						SendClientMessageEx(playerid, COLOR_GREY,
						"�� ��� �� ��������.", "You already have jetpack.");
						return true;
					}
					useJetpack = true;
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
				}
				case 4:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gotoint");
					#endif
				}
				case 5:
				{
					for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++){
						Streamer_Update(i);
					}
					// Note: dynamic objects are restored in 50 ms 
					// (or through the specified value by the Streamer_TickRate function).
					Streamer_DestroyAllVisibleItems(playerid, STREAMER_TYPE_OBJECT);
					SendClientMessageEx(playerid, -1,
					"��� ������������ ������� ���� ���������","All dynamic objects have been updated");
				}
				case 6: ShowPlayerMenu(playerid, DIALOG_SOUNDTEST);
				case 7: 
				{
					ShowPlayerDialog(playerid, DIALOG_GAMETEXTSTYLE, DIALOG_STYLE_LIST,
					"Select Gametext style",
					"{FFFFFF}Game Text 0\n"\
					"{00FF00}Game Text 1\n"\
					"{FF0000}Game Text 2\n"\
					"{FFFFFF}Game Text 3\n"\
					"{FFFFFF}Game Text 4\n"\
					"{FFFFFF}Game Text 5\n"\
					"{FFFFFF}Game Text 6\n",
					"OK","Cancel");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_VEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/tcar");
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avnewcar");
					#endif
				}
				case 2: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avsel");
					#endif
				}
				case 3: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avclonecar");
					#endif
				}
				case 4: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avdeletecar");
					#endif
				}
				case 5: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avsetspawn");
					#endif
				}
				case 6: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avexport");
					#endif
				}
				case 7: 
				{
					new tbtext[450];
					if(GetPVarInt(playerid, "lang") == 0)
					{		
						format(tbtext, sizeof(tbtext),
						"�����\tcmd\n"\
						"�����\t{00FF00}/avcarcolor\n"\
						"����������� ������\t{00FF00}/avpaint\n"\
						"�������� � ����������\t{00FF00}/avmodcar\n"\
						"���������� ����������\t\n"\
						"���������� ������ �����\t\n"\
						"[>] �����\t\n"\
						"[>] ��������\t\n");
					} else {
						format(tbtext, sizeof(tbtext),
						"Option\tCommand\n"\
						"Color\t{00FF00}/avcarcolor\n"\
						"Paintjobs\t{00FF00}/avpaint\n"\
						"Workshop teleport\t{00FF00}/avmodcar\n"\
						"Install hydraulics \t\n"\
						"Install NOS \t\n"\
						"[>] Wheels\t\n"\
						"[>] Styling\t\n");
					}
					
					ShowPlayerDialog(playerid, DIALOG_VEHMOD, DIALOG_STYLE_TABLIST_HEADERS,
					"[VEHICLE - TUNING]",tbtext, "OK","Cancel");
				}
				case 8: 
				{
					new tbtext[350];
					if(GetPVarInt(playerid, "lang") == 0)
					{		
						format(tbtext, sizeof(tbtext),
						"���� �����\n"\
						"���� ��������\n"\
						"[���/����] ����\n"\
						"������� ��� 4 ������\n"\
						"������� ������ 2 ������\n"\
						"������������\n");
					} else {
						format(tbtext, sizeof(tbtext),
						"Open Hood \n"\
						"Open Trunk \n"\
						"[On/off] Headlights \n"\
						"Punch all 4 wheels \n"\
						"Punch rear 2 wheels \n"\
						"Alarm \n");
					}
					
					ShowPlayerDialog(playerid, DIALOG_VEHSPEC, DIALOG_STYLE_LIST,
					"[VEHICLE - Spec]",tbtext, "OK","Cancel");
				}
				case 9:	ShowPlayerMenu(playerid, DIALOG_VEHSETTINGS);
			}
		}
	}
	if(dialogid == DIALOG_VEHSETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					if(useBoost)
					{
						useBoost = false;
						SendClientMessageEx(playerid, -1, "������ ��������.", "Boost mode disabled.");
					} else {
						useBoost = true;
						SendClientMessageEx(playerid, -1, "������ �������. ������� ��� ��� ���������", "Boost mode enabled. Press LMB to increase speed");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='useBoost'", useBoost);
					db_query(mtoolsDB,query);
				}
				case 1: 
				{
					if(useNOS)
					{
						useNOS = false;
						SendClientMessageEx(playerid, -1, "������������� NOS ���������.",
						"NOS refill disabled.");
					} else {
						useNOS = true;
						SendClientMessageEx(playerid, -1, "������������� NOS ��������.",
						"NOS refill enabled.");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='useNOS'", useNOS);
					db_query(mtoolsDB,query);
				}
				case 2:
				{
					if(useAutoFixveh)
					{
						useAutoFixveh = false;
						SendClientMessageEx(playerid, -1, "������������� ���������",
						"Auto vehicle repair disabled");
					} else {
						useAutoFixveh = true;
						SendClientMessageEx(playerid, -1, "������������� ��������",
						"Auto vehicle repair enabled");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='useAutoFixveh'", useAutoFixveh);
					db_query(mtoolsDB,query);
				}
				case 3:
				{
					if(useAutoTune)
					{
						useAutoTune = false;
						SendClientMessageEx(playerid, -1, "���������� �� <2> ��������",
						"Auto vehicle tuning on key <2> disabled");
					} else {
						useAutoTune = true;
						SendClientMessageEx(playerid, -1, "���������� �� <2> �������",
						"Auto vehicle tuning on key <2> enabled");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='useAutoTune'", useAutoTune);
					db_query(mtoolsDB,query);
				}
				case 4:
				{
					if(useFlip)
					{
						useFlip = false;
						SendClientMessageEx(playerid, -1, "Flip �� <H> ��������",
						"Flip on key <H> disabled");
					} else {
						useFlip = true;
						SendClientMessageEx(playerid, -1, "Flip �� <H> �������",
						"Flip on key <H> enabled");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='useFlip'", useFlip);
					db_query(mtoolsDB,query);
				}
				case 5:
				{
					if(vehCollision)
					{
						DisableRemoteVehicleCollisions(playerid, 0); //off
						vehCollision = false;
						SendClientMessageEx(playerid, -1, "�������� ���������� ��������",
						"Vehicle collision enabled");
					} else {
						DisableRemoteVehicleCollisions(playerid, 1); //disable collision
						vehCollision = true;
						SendClientMessageEx(playerid, -1, "�������� ���������� ���������", 
						"Vehicle collision disabled");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='vehCollision'", vehCollision);
					db_query(mtoolsDB,query);
				}
				case 6:
				{
					SendClientMessageEx(playerid, COLOR_LIME, 
					"��� ����� �������� ������ ��� ��������� ���������� ����� /v [id]",
					"This option only works for a transport called via / v [id]");
					if(removePlayerVehicleOnExit)
					{
						removePlayerVehicleOnExit = false;
						SendClientMessageEx(playerid, -1, "������������ ���������� ������ ���������",
						"auto delete player transport is disabled");
					} else {
						removePlayerVehicleOnExit = true;
						SendClientMessageEx(playerid, -1, "������������ ���������� ������ ��������",
						"auto delete player transport is enabled");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='removePlayerVehicleOnExit'", removePlayerVehicleOnExit);
					db_query(mtoolsDB,query);
				}
			}
		}
		//else ShowPlayerMenu(playerid, DIALOG_VEHICLE);
	}
	if(dialogid == DIALOG_VEHSTYLING)
	{// https://wiki.sa-mp.com/wiki/Car_Component_ID
	    if(response)
		{
			switch(listitem)
        	{
				case 0:// Alien kit
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					if(GetVehicleModel(vehicleid) == 562) // Elegy
			        {
			            AddVehicleComponent(vehicleid,1036);
			            AddVehicleComponent(vehicleid,1034);
			            AddVehicleComponent(vehicleid,1038);
			            AddVehicleComponent(vehicleid,1040);
			            AddVehicleComponent(vehicleid,1147);
			            AddVehicleComponent(vehicleid,1149);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        }
					else if(GetVehicleModel(vehicleid) == 565) // Flash
					{
					    AddVehicleComponent(vehicleid,1046);
					    AddVehicleComponent(vehicleid,1047);
					    AddVehicleComponent(vehicleid,1049);
					    AddVehicleComponent(vehicleid,1051);
					    AddVehicleComponent(vehicleid,1054);
					    AddVehicleComponent(vehicleid,1150);
					    AddVehicleComponent(vehicleid,1153);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else if(GetVehicleModel(vehicleid) == 559) // Jester
					{
					    AddVehicleComponent(vehicleid,1065);
					    AddVehicleComponent(vehicleid,1067);
					    AddVehicleComponent(vehicleid,1069);
					    AddVehicleComponent(vehicleid,1071);
					    AddVehicleComponent(vehicleid,1159);
					    AddVehicleComponent(vehicleid,1160);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else if(GetVehicleModel(vehicleid) == 560) // Sultan
					{
					    AddVehicleComponent(vehicleid,1141);
					    AddVehicleComponent(vehicleid,1169);
					    AddVehicleComponent(vehicleid,1138);
					    AddVehicleComponent(vehicleid,1026);
					    AddVehicleComponent(vehicleid,1027);
					    AddVehicleComponent(vehicleid,1028);
					    AddVehicleComponent(vehicleid,1032);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else if(GetVehicleModel(vehicleid) == 558)  // Uranus
					{			
					    AddVehicleComponent(vehicleid,1164);
					    AddVehicleComponent(vehicleid,1166);
					    AddVehicleComponent(vehicleid,1168);
					    AddVehicleComponent(vehicleid,1088);
					    AddVehicleComponent(vehicleid,1090);
					    AddVehicleComponent(vehicleid,1092);
					    AddVehicleComponent(vehicleid,1094);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					} else {
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
				}
				case 1:
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					if(GetVehicleModel(vehicleid) == 562) // Elegy
			        {
			            AddVehicleComponent(vehicleid,1035);
			            AddVehicleComponent(vehicleid,1037);
			            AddVehicleComponent(vehicleid,1039);
			            AddVehicleComponent(vehicleid,1041);
			            AddVehicleComponent(vehicleid,1046);
			            AddVehicleComponent(vehicleid,1048);
			            AddVehicleComponent(vehicleid,1172);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			        }
					else if(GetVehicleModel(vehicleid) == 565) // Flash
					{
					    AddVehicleComponent(vehicleid,1045);
					    AddVehicleComponent(vehicleid,1048);
					    AddVehicleComponent(vehicleid,1050);
					    AddVehicleComponent(vehicleid,1052);
					    AddVehicleComponent(vehicleid,1053);
					    AddVehicleComponent(vehicleid,1151);
					    AddVehicleComponent(vehicleid,1152);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else if(GetVehicleModel(vehicleid) == 559) // Jester
					{
					    AddVehicleComponent(vehicleid,1066);
					    AddVehicleComponent(vehicleid,1068);
					    AddVehicleComponent(vehicleid,1070);
					    AddVehicleComponent(vehicleid,1072);
					    AddVehicleComponent(vehicleid,1073);
					    AddVehicleComponent(vehicleid,1158);
					    AddVehicleComponent(vehicleid,1161);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					/*else if(GetVehicleModel(vehicleid) == 561) // Stratum
					{
					    AddVehicleComponent(vehicleid,1156); //xflow
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}*/
					else if(GetVehicleModel(vehicleid) == 560) // Sultan
					{
					    AddVehicleComponent(vehicleid,1029);
					    AddVehicleComponent(vehicleid,1030);
					    AddVehicleComponent(vehicleid,1033);
					    AddVehicleComponent(vehicleid,1031);
					    AddVehicleComponent(vehicleid,1139);
					    AddVehicleComponent(vehicleid,1140);
					    AddVehicleComponent(vehicleid,1170);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else if(GetVehicleModel(vehicleid) == 558)  // Uranus
					{			
					    AddVehicleComponent(vehicleid,1089);
					    AddVehicleComponent(vehicleid,1091);
					    AddVehicleComponent(vehicleid,1093);
					    AddVehicleComponent(vehicleid,1095);
					    AddVehicleComponent(vehicleid,1165);
					    AddVehicleComponent(vehicleid,1167);
			            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					} else {
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "{ffffff}Pro\nWin\nDrag\nAlpha\nChamp\nRace\nWorx","OK", " < ");
				}
				case 3: //hood remove
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					new panels, doors, lights, tires;
					GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
					UpdateVehicleDamageStatus(vehicleid, panels, (doors | 0b00000100), lights, tires);
				}
				case 4: // trunk remove
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					new panels, doors, lights, tires;
					GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
					UpdateVehicleDamageStatus(vehicleid, panels, (doors | 0b00000000_00000000_0000100_00000100), lights, tires);
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_VEHICLE);
	}
	if(dialogid == DIALOG_SPOILERS)
	{
	    if(response)
		{
			new vehicleid;
			vehicleid = GetPlayerVehicleID(playerid);
			switch(vehicleid){
				case 406,407,430,432,425,447,464,476,601:
				{
					return SendClientMessageEx(playerid, -1,
					"���������� ��� ������� ����������","Not available for this vehicle"); // airveh
				}
				case 446,448,452,424,453,454,461,462,463,468,471,472,449,473,481,484,493,
				509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611:
				{
					return SendClientMessageEx(playerid, -1,
					"���������� ��� ������� ����������","Not available for this vehicle");
				}
			}
			// 1000 - Pro 1001 - Win 1002 - Drag 1003 - Alpha 1014 - Champ 1015 - Race 1016 - Worx
		    if(listitem == 0)AddVehicleComponent(vehicleid,1000);
			if(listitem == 1)AddVehicleComponent(vehicleid,1001);
			if(listitem == 2)AddVehicleComponent(vehicleid,1002);
			if(listitem == 3)AddVehicleComponent(vehicleid,1003);
			if(listitem == 4)AddVehicleComponent(vehicleid,1014);
			if(listitem == 5)AddVehicleComponent(vehicleid,1015);
			if(listitem == 6)AddVehicleComponent(vehicleid,1016);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		}
		else ShowPlayerMenu(playerid, DIALOG_VEHICLE);
	}
	if(dialogid == DIALOG_WHEELS)
	{
	    if(response)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
				return SendClientMessageEx(playerid, -1,
				"�� ������ ���� � ������", "You must be in the car");
			}
			new vehicleid;
			vehicleid = GetPlayerVehicleID(playerid);
			switch(listitem)
			{
				case 0: AddVehicleComponent(vehicleid,1073);
				case 1: AddVehicleComponent(vehicleid,1074);
				case 2: AddVehicleComponent(vehicleid,1076);
				case 3: AddVehicleComponent(vehicleid,1077);
				case 4: AddVehicleComponent(vehicleid,1075);
				case 5: AddVehicleComponent(vehicleid,1079);
				case 6: AddVehicleComponent(vehicleid,1078);
				case 7: AddVehicleComponent(vehicleid,1080);
				case 8: AddVehicleComponent(vehicleid,1081);
				case 9: AddVehicleComponent(vehicleid,1082);
				case 10: AddVehicleComponent(vehicleid,1083);
				case 11: AddVehicleComponent(vehicleid,1084);
				case 12: AddVehicleComponent(vehicleid,1085);
				case 13:
				{
					new dop;
					dop = GetVehicleComponentInSlot(vehicleid, 7);
					if(dop != 0)
					{
						RemoveVehicleComponent(vehicleid, dop);
						PlayerPlaySound(playerid,5202,0.0,0.0,0.0);
					}
				}
			}
			if(listitem >= 0 && listitem <= 12) {
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST,
			"Wheels",
			"Shadow\nMega\nWires\nClassic\nRimshine\nCutter"\
			"\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance"\
			"\nAtomic\n{A9A9A9}Default",
			"OK", " < ");
		}
	}
	if(dialogid == DIALOG_VEHSPEC) 
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					// open hood
					new vehicleid = GetPlayerVehicleID(playerid);
					if (IsABike(vehicleid) || IsABoat(vehicleid) || 
					IsAPlane(vehicleid) || IsANoSpeed(vehicleid)) {
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if (bonnet != 0) {
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,0,boot,objective); 
					}
					else SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,1,boot,objective);
				}
				case 1:
				{
					// open trunk
					new vehicleid = GetPlayerVehicleID(playerid);
					if(IsABike(vehicleid) || IsABoat(vehicleid) ||
					IsAPlane(vehicleid) || IsANoSpeed(vehicleid)) {
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(boot != 0) {
						SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,0,objective);
					}
					else SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,1,objective);
				}
				case 2:
				{
					// turn on-off lights
					new vehicleid = GetPlayerVehicleID(playerid);
					if(IsABoat(vehicleid) || IsAPlane(vehicleid) ||
					IsANoSpeed(vehicleid)){
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
					if(lights != 0){
						SetVehicleParamsEx(vehicleid,engine,0,alarm,doors,bonnet,boot,objective);
					}
					else SetVehicleParamsEx(vehicleid,engine,1,alarm,doors,bonnet,boot,objective);
				}
				case 3: // 4 wheels cut
				{
					if(useAutoFixveh) {
						SendClientMessageEx(playerid, -1,
						"������������� ��������� autofix � ���������� ��� ������������� ���� �������","it is recommended to disable auto-repair in the settings to use this function");
					}
					new vehicleid = GetPlayerVehicleID(playerid);
					if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsANoSpeed(vehicleid)){
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new panels, doors, lights, tires;	
					GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
					UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
				}
				case 4: // 2 wheels cut
				{
					if(useAutoFixveh) {
						SendClientMessageEx(playerid, -1,
						"������������� ��������� autofix � ���������� ��� ������������� ���� �������","it is recommended to disable auto-repair in the settings to use this function");
					}
					new vehicleid = GetPlayerVehicleID(playerid);
					if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsANoSpeed(vehicleid)){
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new panels, doors, lights, tires;	
					GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
					UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 5);
				}
				case 5: // alarm
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsANoSpeed(vehicleid)){
						return SendClientMessageEx(playerid, -1,
						"���������� ��� ������� ����������","Not available for this vehicle");
					}
					new engine, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
					if(alarm != 0){
						SetVehicleParamsEx(vehicleid, engine,
						lights, 1, doors, bonnet, boot, objective);
					} else {
						SetVehicleParamsEx(vehicleid, engine,
						lights, 0, doors, bonnet, boot, objective);
					}
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_VEHICLE);
	}
	if(dialogid == DIALOG_VEHMOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avcarcolor");		
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avpaint");		
					#endif
				}
				case 2: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avmodcar");		
					#endif
				}
				case 3:
				{
					// hydraulics
					AddVehicleComponent(GetPlayerVehicleID(playerid),1087);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
				case 4:
				{
					switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,
						493,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
					}
					AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
					PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
				case 5: 
				{
					ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST,
					"Wheels",
					"Shadow\nMega\nWires\nClassic\nRimshine\nCutter"\
					"\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance"\
					"\nAtomic\n{A9A9A9}Default",
					"OK", " < ");
				}
				case 6:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_VEHSTYLING, DIALOG_STYLE_LIST,
						"Styling",
						"{4682B4}����� Wheel Arc. Alien\n"\
						"{FF4500}����� Wheel Arc. X-Flow\n"\
						"{E6E6FA}[>] �������� Transfender\n"\
						"{B22222}����� �����\n"\
						"{B22222}����� ��������\n",
						"OK", " < ");
					} else {
						ShowPlayerDialog (playerid, DIALOG_VEHSTYLING, DIALOG_STYLE_LIST,
						"Styling",
						"{4682B4} Wheel Arc body kit. Alien \n"\
						"{FF4500} Wheel Arc body kit. X-Flow \n"\
						"{E6E6FA} [>] Spoilers for Transfender \n"\
						"{B22222} Remove the hood \n"\
						"{B22222} Remove trunk \n",
						"OK", "<");
					}
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_VEHICLE);
	}
	if(dialogid == DIALOG_TEXTUREMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/mtextures");		
					if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
					{
						SendClientMessageEx(playerid, COLOR_LIME,
						"���������� � ������ ������", "Controls in flymode:");
						SendClientMessageEx(playerid, COLOR_LIME,
						"Y - ����. ��������, H - ����. ��������", 
						"Y - Last Texture, H - Next Texture");
					} else {
						SendClientMessageEx(playerid, COLOR_LIME,
						"���������� ������", "Controls on-foot:");
						SendClientMessageEx(playerid, COLOR_LIME,
						"Enter + Num 4 - ����. ��������, Enter + Num 6 - ����. ��������", 
						"Enter + Num 4 - Last Texture, Enter + Num 6 - Next Texture");
					}
					SendClientMessageEx(playerid, COLOR_LIME,
					"Num 4 - ����. ��������, Num 6 - ����. ��������",
					"Num 4 - Last Page, Num 6 - Next Page");
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ttextures");		
					#endif
				}
				case 2:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_TEXTURESEARCH, DIALOG_STYLE_INPUT,
						"Textures search", 
						"����� �������� �� �����. ������� ����� ��� ������:\n",
						"Select", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_TEXTURESEARCH, DIALOG_STYLE_INPUT,
						"Textures search", 
						"����� �������� �� �����. Enter a search word:\n",
						"Select", "Cancel");
					}
				}
				case 3: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/stexture");		
					#endif
				}
				case 4: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/text");		
					#endif
				}
				case 5: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/mtreset");		
					#endif
				}
				case 6:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/copy");		
					#endif
				}
				case 7:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/paste");		
					#endif
				}
				case 8:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/clear");		
					#endif
				}
				
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_MAPMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/loadmap");		
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/newmap");		
					#endif
				}
				case 2:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/renamemap");		
					#endif
				}
				case 3:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/setspawn");		
					#endif
				}
				case 4:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/importmap");		
					#endif
				}
				case 5:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/export");		
					#endif
				}
				case 6:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/avexportall");		
					#endif
				}
				case 7:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gtaobjects");		
					#endif
				}
				case 8:
				{
					if(GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_CREATEMAPICON, DIALOG_STYLE_INPUT, "Mapicon","{FFFFFF}���������� ������ ��������� mapicon ����� �� �����\n"\
						"{00BFFF}https://pawnokit.ru/mapicons_id\n"\
						"{FFFFFF}������� {00FF00}mapicon ID:\n","Create","Back");
					} else {
						ShowPlayerDialog(playerid, DIALOG_CREATEMAPICON, DIALOG_STYLE_INPUT, "Mapicon",
						"{FFFFFF}Type {00FF00}mapicon ID:\n","Create","Back");
					}
				}
				case 9:
				{
					new tbtext[300], CountActors;
					
					#if defined _new_streamer_included
					CountActors = Streamer_CountItems(STREAMER_TYPE_ACTOR, 1);
					#else 
					new i,j;
					for(i = 0, j = GetActorPoolSize(); i <= j; i++)
					{
						if(!IsValidActor(i)) break;
					}
					CountActors = i;
					#endif
						
					format(tbtext, sizeof(tbtext),
					" \t \n"\
					"Objects:\t{FFFF00}%i\n"\
					"Pickups:\t{FFFF00}%i\n"\
					"CPs:\t{FFFF00}%i\n"\
					"Race CPs:\t{FFFF00}%i\n"\
					"MapIcons:\t{FFFF00}%i\n"\
					"3D Texts:\t{FFFF00}%i\n"\
					"Actors:\t{FFFF00}%i\n"\
					"Vehicles:\t{FFFF00}%i\n"\
					"Dynamic areas:\t{FFFF00}%i\n",
					CountDynamicObjects(),
					CountDynamicPickups(),
					CountDynamicCPs(),
					CountDynamicRaceCPs(),
					CountDynamicMapIcons(),
					CountDynamic3DTextLabels(),
					CountActors,
					GetVehiclePoolSize(),
					CountDynamicAreas()
					);
					
					ShowPlayerDialog(playerid, DIALOG_LIMITS, DIALOG_STYLE_TABLIST_HEADERS, "Limits",
					tbtext,"OK","");
				}
				case 10:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/deletemap");		
					#endif
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_MAPINFO)
	{
		if(response)
		{
			LoadMapInfo(playerid, listitem);
		}
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				case 1: ShowPlayerMenu(playerid, DIALOG_KEYBINDS);
				case 2: ShowPlayerMenu(playerid, DIALOG_VEHSETTINGS);
				case 3:
				{
					if(GetPVarInt(playerid, "lang") == 0)
					{
						SetPVarInt(playerid, "lang",1);
						LangSet = 1;
						SendClientMessage(playerid, COLOR_GREY, "Your language has been set to English");
					} else {
						SetPVarInt(playerid, "lang",0);
						LangSet = 0;
						SendClientMessage(playerid, COLOR_GREY, "������ ������� ����");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='Language'", LangSet);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_SETTINGS);
				}
				case 4:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT,
						"����� �����", "{FFFFFF}������� id �����", "Ok", "�����");
					} else { 
						ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_INPUT, 
						"Change skin", "{FFFFFF}Enter the skin ID below", "Confirm", "Cancel");
					}
				}
				case 5:
				{
					//(dialogid == DIALOG_WEATHER) //weather set
					ShowPlayerDialog(playerid, DIALOG_WEATHER, DIALOG_STYLE_INPUT, "Set weather",
					"{FFFFFF}Weather IDs 1-22 appear to work correctly but other IDs may result in strange effects (max 255)\n\n"\
					"1 = SUNNY_LA (DEFAULT)\t11 = EXTRASUNNY_VEGAS (heat waves)\n"\
					"2 = EXTRASUNNY_SMOG_LA\t12 = CLOUDY_VEGAS\n"\
					"3 = SUNNY_SMOG_LA\t13 = EXTRASUNNY_COUNTRYSIDE\n"\
					"4 = CLOUDY_LA\t\t14 = SUNNY_COUNTRYSIDE\n"\
					"5 = SUNNY_SF\t\t15 = CLOUDY_COUNTRYSIDE\n"\
					"6 = EXTRASUNNY_SF\t\t16 = RAINY_COUNTRYSIDE\n"\
					"7 = CLOUDY_SF\t\t17 = EXTRASUNNY_DESERT\n"\
					"8 = RAINY_SF\t\t18 = SUNNY_DESERT\n"\
					"9 = FOGGY_SF\t\t19 = SANDSTORM_DESERT\n"\
					"10 = SUNNY_VEGAS\t20 = UNDERWATER (greenish, foggy)\n\n"\
					"Enter weather id\n",
					"Ok", "Cancel");
				}
				case 6: 
				{
					ShowPlayerDialog(playerid, DIALOG_TIME, DIALOG_STYLE_INPUT, 
					"Set time",	"Enter time [0-23]. Default [12].", "Ok", "Cancel");
				}
				case 7: 
				{
					ShowPlayerDialog(playerid, DIALOG_GRAVITY, DIALOG_STYLE_INPUT, 
					"Set gravity","Enter new gravity value. Default server value [0.008].",
					"OK", "Cancel");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_KEYBINDS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(bindFkeyToFlymode) 
					{
						bindFkeyToFlymode = false;
					} else { 
						bindFkeyToFlymode = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='bindFkeyToFlymode'", bindFkeyToFlymode);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_KEYBINDS);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_MAINMENU_KEYBINDSET, DIALOG_STYLE_LIST, "Set key",
					"{00FF00}< ALT >\n{00FF00}< Y >\n{00FF00}< N >\n{00FF00}< H >\n", "Select", "Cancel");
				}
				case 2:
				{
					if(superJump) 
					{
						SendClientMessageEx(playerid, -1,
						"����� ������ �������������", "Super jump deactivated");
						superJump = false;
					} else { 
						SendClientMessageEx(playerid, -1,
						"����� ������ �����������, ������� ������� ������ ��� ���������",
						"Super jump activated, press jump key to view");
						superJump = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='superJump'", superJump);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_KEYBINDS);
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_SETTINGS);
	}
	if(dialogid == DIALOG_MAINMENU_KEYBINDSET)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: mainMenuKeyCode = 1024;
				case 1: mainMenuKeyCode = 65536;
				case 2: mainMenuKeyCode = 131072;
				case 3: mainMenuKeyCode = 262144;
			}
			new query[128];
			format(query,sizeof(query),
			"UPDATE `Settings` SET Value=%d WHERE Option='mainMenuKeyCode'", mainMenuKeyCode);
			db_query(mtoolsDB,query);
			ShowPlayerMenu(playerid, DIALOG_KEYBINDS);
		}
		else ShowPlayerMenu(playerid, DIALOG_SETTINGS);
	}
	if(dialogid == DIALOG_INTERFACE_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(streamedObjectsTD) 
					{
						PlayerTextDrawHide(playerid, Objrate[playerid]);
						streamedObjectsTD = false;
					} else { 
						PlayerTextDrawShow(playerid, Objrate[playerid]);
						streamedObjectsTD = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='streamedObjectsTD'",
					streamedObjectsTD);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 1:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/position");
					#endif
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 2:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/edittext3d");
					#endif
				}
				case 3:
				{
					#if defined TEXTURE_STUDIO
					if(use3dTextOnObjects)
					{
						CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/hidetext3d");
						
					} else {
						CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/showtext3d");
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='use3dTextOnObjects'", use3dTextOnObjects);
					db_query(mtoolsDB,query);
					#else
					SendClientMessageEx(playerid, -1, "��� ������� �������� ������ � TextureStudio",
					"This feature is only available in TextureStudio");
					#endif
				}
				case 4:
				{
					if(aimPoint) 
					{
						PlayerTextDrawHide(playerid, TDAIM[playerid]);
						aimPoint = false;
					} else { 
						aimPoint = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='aimPoint'",
					aimPoint);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 5:
				{
					if(targetInfo) 
					{
						targetInfo = false;
					} else { 
						targetInfo = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='targetInfo'",
					targetInfo);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 6:
				{
					if(fpsBarTD) 
					{
						fpsBarTD = false;
					} else { 
						fpsBarTD = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='fpsBarTD'",
					fpsBarTD);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 7:
				{
					if(autoLoadMap) 
					{
						autoLoadMap = false;
					} else { 
						autoLoadMap = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='autoLoadMap'",
					autoLoadMap);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
				case 8:
				{
					if(showEditMenu) 
					{
						showEditMenu = false;
					} else { 
						showEditMenu = true;
					}
					new query[128];
					format(query,sizeof(query),
					"UPDATE `Settings` SET Value=%d WHERE Option='showEditMenu'",
					showEditMenu);
					db_query(mtoolsDB,query);
					ShowPlayerMenu(playerid, DIALOG_INTERFACE_SETTINGS);
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_SETTINGS);
	}
	if(dialogid == DIALOG_CREATEMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_OBJECTSMENU, DIALOG_STYLE_TABLIST_HEADERS, 
						"[CREATE - Objects]",
						"��������\t�������\n"\
						"{A9A9A9}������� ������ �� ������\t{00FF00}/newobj\n"\
						"������ �������� ����������� ��� ��������������\t{00FF00}/lsel\n"\
						"{A9A9A9}��������� �������\t\n"\
						"����� �������� �� �����\t{00FF00}/osearch\n"\
						"{A9A9A9}����� ���������� ��������\t\n"\
						"���������� ���������� ����� ����� ���������\t\n"\
						"{A9A9A9}���������� � ������ �������\t{00FF00}/minfo\n"\
						"�������� ������� �������\t\n"\
						"{A9A9A9}��������� ������\t{00FF00}/nearest\n",
						//"[>] �������� ��������\t\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_OBJECTSMENU, DIALOG_STYLE_TABLIST_HEADERS, 
						"[CREATE - Objects]",
						"Description\tCommand\n"\
						"{A9A9A9}Create object by number\t{00FF00}/newobj\n"\
						"List of objects loaded for editing\t{00FF00}/lsel\n"\
						"{A9A9A9}Favorite objects\n"\
						"Search objects\t{00FF00}/osearch\n"\
						"{A9A9A9}Finding duplicate objects\t\n"\
						"Determine the distance between two objects\t\n"\
						"{A9A9A9}Object model information\t{00FF00}/minfo\n"\
						"Show hidden objects\t\n"\
						"{A9A9A9}Nearest object info\t{00FF00}/nearest\n",
						//"[>] Object movement\t\n",
						"Select","Cancel");
					}
				}
				case 1: ShowPlayerMenu(playerid, DIALOG_3DTEXTMENU);
				case 2: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/textobj");
					#endif
				}
				case 3: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_CREATEPICKUP, DIALOG_STYLE_LIST, 
						"�������� pickup",
						"{FFFFFF}������� pickup �� ID\n"\
						"{AFDAFC}������� pickup �����\n"\
						"{FF0000}������� pickup ���������� ��������\n"\
						"{191970}������� pickup jetpack\n"\
						"{A9A9A9}������� pickup ����� � ��������\n",
						"Select","Cancel");
					} else {
	
						ShowPlayerDialog(playerid, DIALOG_CREATEPICKUP, DIALOG_STYLE_LIST, 
						"Create pickup",
						"{FFFFFF} Create pickup by ID \n" \
						"{AFDAFC} Create booking pickup \n" \
						"{FF0000} Create health refill pickup \n" \
						"{191970} Create jetpack pickup \n" \
						"{A9A9A9} Create interior entrance pickup \n",
						"Select","Cancel");
					}
				}
				case 4: ShowMainAttachEditMenu(playerid);
				case 5:
				{
					// if no object selected
					if(VaeData[playerid][obj] == -1)
					{
						ShowPlayerDialog(playerid, DIALOG_VAENEW, DIALOG_STYLE_INPUT, "VAE New attach", 
						"specify the object model to attach to the vehicle.\
						(For example minigun: 362)\nEnter model id:",
						">>>","Cancel");
					} else {
						ShowPlayerMenu(playerid, DIALOG_VAE);
					}
				}
				case 6: ShowPlayerMenu(playerid, DIALOG_ACTORS);
			}
		} 
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_OBJECTSMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowPlayerMenu(playerid,DIALOG_CREATEOBJ);
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/lsel");
					#endif
				}
				case 2:
				{
					#if defined _mselect_included
					MSelect_Show(playerid, MSelect:FavObjects);
					#else
					new tbtext[250];
					new tmpstr[10];
					for(new i = 0; i < 25; i++)
					{
						format(tmpstr, sizeof(tmpstr), "%i\n", array_FavObjects[i]);
						strcat(tbtext, tmpstr);
					}
					ShowPlayerDialog(playerid,DIALOG_FAVORITES,DIALOG_STYLE_LIST,"Favorites",tbtext,"Create","Close");
					#endif
				}
				case 3: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_OBJSEARCH, DIALOG_STYLE_INPUT,
						"Object search", 
						"����� �������� �� �����. ������� ����� ��� ������:\n",
						"Search", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_OBJSEARCH, DIALOG_STYLE_INPUT,
						"Object search", 
						"Search for objects by word. Enter a search word:\n",
						"Search", "Cancel");
					}
				}
				case 4: 
				{
					new tbtext[128];
					new objectid = GetNearestVisibleItem(playerid, STREAMER_TYPE_OBJECT);
					if (GetPVarInt(playerid, "lang") == 0) {
						format(tbtext, sizeof(tbtext),
						"{FFFFFF}Nearest object %i - modelid: %i\nEnter modelid to search:",
						objectid, GetDynamicObjectModel(objectid));
					} else {
						format(tbtext, sizeof(tbtext),
						"{FFFFFF}��������� ������ %i - modelid: %i\n������� modelid ��� ������:",
						objectid, GetDynamicObjectModel(objectid));
					}
					ShowPlayerDialog(playerid, DIALOG_DUPLICATESEARCH, DIALOG_STYLE_INPUT,
					"Duplicate search",tbtext, "Search", "Cancel");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_OBJDISTANCE, DIALOG_STYLE_INPUT,
					"Distance [object #1]",
					"{FFFFFF}Determine the distance between two objects. Enter objectid:",
					"Next", "Cancel");
				}
				case 6:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_MODELSIZEINFO, DIALOG_STYLE_INPUT,
						"Object model information", 
						"������� modelid ��� ������:\n",
						"Search", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_MODELSIZEINFO, DIALOG_STYLE_INPUT,
						"Object model information", 
						"Enter modelid to search:\n",
						"Search", "Cancel");
					}
				}
				case 7:
				{
					#if defined STREAMER_ALL_TAGS
					Streamer_ToggleAllItems(playerid, STREAMER_TYPE_OBJECT, 1);
					#else
						#if defined _YSF_included
						for(new i = 0; i < MAX_OBJECTS; i++)
						{
							if(IsObjectHiddenForPlayer(playerid, i)) ShowObjectForPlayer(playerid, i);
						}
						#endif
					#endif
					SendClientMessageEx(playerid, -1,
					"��� ������� ������� ���� ��������","All hidden objects have been revealed");
				}
				case 8:
				{
					new tmpstr[64];
					new objectid = GetNearestVisibleItem(playerid, STREAMER_TYPE_OBJECT);
					if (GetPVarInt(playerid, "lang") == 0) {
						format(tmpstr, sizeof(tmpstr), "Nearest object -  objectid: %i modelid: %i",
						objectid, GetDynamicObjectModel(objectid));
					} else {
						format(tmpstr, sizeof(tmpstr), "��������� ������ - objectid: %i modelid: %i",
						objectid, GetDynamicObjectModel(objectid));
					}
					SendClientMessage(playerid, -1, tmpstr);
				}
				case 9:
				{
					new tbtext[400];
					
					format(tbtext, sizeof tbtext,
					" \t \n"\
					"Select object\t\n"\
					"Set start position\t%.2f,%.2f,%.2f\n"\
					"Set final position\t%.2f,%.2f,%.2f\n"\
					"Set move speed\t%i\n"\
					"Preview\t\n"\
					"Stop\t\n"\
					"Export to filterscript\t\n",
					ObjectsMoveData[playerid][X1],
					ObjectsMoveData[playerid][Y1],
					ObjectsMoveData[playerid][Z1],
					ObjectsMoveData[playerid][X2],
					ObjectsMoveData[playerid][Y2],
					ObjectsMoveData[playerid][Z2],
					ObjectsMoveData[playerid][MoveSpeed]);
					
					ShowPlayerDialog(playerid, DIALOG_MOVINGOBJ, DIALOG_STYLE_TABLIST_HEADERS,
					"[CAM] - Object moviements (MoveDynamicObject)", tbtext,
					"Select", "Cancel");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_CREATEPICKUP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid,DIALOG_CREATEPICKUP_BYNUM,DIALOG_STYLE_INPUT,
					"Create pickup","Enter pickup id:","Create","Cancel");
				}
				case 1: mCreatePickup(1242, playerid);// armourpickup
				case 2: mCreatePickup(1240, playerid);// hppickup
				case 3: mCreatePickup(370, playerid);// jetpickup
				case 4: mCreatePickup(19130, playerid);// black arrow
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_CREATEPICKUP_BYNUM)
	{
		if(response)
		{
			if(!isnull(inputtext) && isNumeric(inputtext)){
				mCreatePickup(strval(inputtext), playerid);
			}
		}
	}
	if(dialogid == DIALOG_FAVORITES)
	{
		if(response)
		{	
			CreateDynamicObjectByModelid(playerid, array_FavObjects[listitem]);
		}
	}
	if(dialogid == DIALOG_CREATEOBJ)
	{
		if(response)
		{
			new modelid = strval(inputtext);
			if(!IsValidObjectModel(modelid)) {
				SendClientMessageEx(playerid,COLOR_GREY,
				"�� ������� �������������� ID ������!","Wrong objectid!");
				return ShowPlayerMenu(playerid, DIALOG_CREATEOBJ);
			}
			new param[24];
			format(param, sizeof(param), "/cobject %d", modelid);
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
			#endif
		}
	}
	if(dialogid == DIALOG_CREATE3DTEXT)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				if(strlen(inputtext) > 64) {
					return SendClientMessageEx(playerid, COLOR_GREY, 
					"�������� �������� (Max: 64 symbols)", "Incorrect value (Max: 64 symbols)");
				}
				new index =	CurrentIndex3dText;
				strcat(Text3dArray[index][Text3Dvalue], inputtext);
				Text3dArray[index][Text3Ddistance] = TEXT3D_DEFAULT_DISTANCE;
				Text3dArray[index][Text3Dcolor] = TEXT3D_DEFAULT_COLOR;
				GetPlayerPos(playerid,Text3dArray[index][tPosX],
				Text3dArray[index][tPosY],Text3dArray[index][tPosZ]);
				#if defined _streamer_included
				Text3dArray[index][index3d] = CreateDynamic3DTextLabel(Text3dArray[index][Text3Dvalue],	Text3dArray[index][Text3Dcolor], Text3dArray[index][tPosX], Text3dArray[index][tPosY],
				Text3dArray[index][tPosZ], Text3dArray[index][Text3Ddistance], INVALID_PLAYER_ID,
				INVALID_VEHICLE_ID, 0, -1, -1, -1, Text3dArray[index][Text3Ddistance]);
				#else
				Text3dArray[index][index3d] = Create3DTextLabel(Text3dArray[index][Text3Dvalue],
				Text3dArray[index][Text3Dcolor],Text3dArray[index][tPosX],Text3dArray[index][tPosY],
				Text3dArray[index][tPosZ],Text3dArray[index][Text3Ddistance],0);
				#endif
			}
		}
	}
	if(dialogid == DIALOG_COLOR3DTEXT)
	{
		if(response)
		{
			if(!isnull(inputtext) || strlen(inputtext) > 10)
			{
				new index = CurrentIndex3dText;
				if(index <= MAX_3DTEXT_GLOBAL) {
					Text3dArray[index][Text3Dcolor] = EOS;
					strcat(Text3dArray[index][Text3Dcolor], inputtext);
				}	
			} else {
				SendClientMessageEx(playerid, COLOR_GREY, 
				"�������� ��������", "Incorrect value");
			}
		} 
		else ShowPlayerMenu(playerid, DIALOG_3DTEXTMENU);
	}
	if(dialogid == DIALOG_INDEX3DTEXT)
	{
		if(response)
		{
			if(!isnull(inputtext) || !isNumeric(inputtext))
			{
				new index = strval(inputtext);
				if(index <= MAX_3DTEXT_GLOBAL) {
					CurrentIndex3dText = index;
				}	
			} else {
				SendClientMessageEx(playerid, COLOR_GREY, 
				"�������� ��������", "Incorrect value");
			}
		} 
		else ShowPlayerMenu(playerid, DIALOG_3DTEXTMENU);
	}
	if(dialogid == DIALOG_DISTANCE3DTEXT)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				new index = CurrentIndex3dText;
				Text3dArray[index][Text3Ddistance] = strval(inputtext);
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_3DTEXTMENU);
	}
	if(dialogid == DIALOG_UPDATE3DTEXT)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				new index = CurrentIndex3dText;
				UpdateDynamic3DTextLabelText(Text3dArray[index][index3d],
				Text3dArray[index][Text3Dcolor], inputtext);
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_3DTEXTMENU);
	}
	if(dialogid == DIALOG_SCOORDS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: GetPlayerCoords(playerid);
				case 1: SaveCoords(playerid);
				case 2: SaveCoords(playerid,1);
				case 3: SaveCoords(playerid,2);
				case 4: SaveCoords(playerid,3);
				case 5: SaveCoords(playerid,4);
			}
		}
	}
	if(dialogid == DIALOG_CREATEMAPICON)
	{
		if(response)
		{
			if(!strval(inputtext)) return 0;
			new nwMapicon[126];
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			//CreateDynamicMapIcon(Float:x, Float:y, Float:z, type, color, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);//Native in streamer  
			#if defined _new_streamer_included 
			//if(IsValidDynamicPickup(pickupid))
			CreateDynamicMapIcon(X, Y, Z, strval(inputtext), 0, -1, -1, -1, 250, MAPICON_LOCAL,-1,0);
			// iconid == the player's icon ID, ranging from 0 to 99, to be used in RemovePlayerMapIcon.
			//SetPlayerMapIcon(playerid, iconid, Float:x, Float:y, Float:z, markertype, color);
			//and with:
			//RemovePlayerMapIcon( playerid, iconid);
			#else
			SetPlayerMapIcon(playerid, strval(inputtext), X, Y, Z, MAPICON_LOCAL, -1);
			#endif
			
			//SetPlayerMapIcon(playerid, 46, X, Y, Z, strval(inputtext), 0 );
			new File:pos2 = fopen("mtools/MapIcons.txt", io_append);
			format(nwMapicon, sizeof nwMapicon, 
			"CreateDynamicMapIcon(%.2f, %.2f, %.2f, %i, 0, -1, -1, -1, 100.0);\r\n", 
			X, Y, Z, strval(inputtext));
			fwrite(pos2, nwMapicon);
			fclose(pos2);
			SendClientMessage(playerid, -1,
			"Dynamic MapIcon export to {FFD700}scriptfiles > mtools > MapIcons.txt");
		}
	}
	if(dialogid == DIALOG_EDITMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/csel");		
					#else 
					SelectObject(playerid);
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/editobject");
					#else 
					EditDynamicObject(playerid, EDIT_OBJECT_ID[playerid]);
					#endif
				}
				case 2:
				{
					ShowPlayerMenu(playerid, DIALOG_ROTATION);
				}
				case 3:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/scsel");
					#else
					new clo_object = GetClosestDynamicObject(playerid);
					format(string, sizeof(string), "~w~the closest ID~y~%i", clo_object);
					//SendTexdrawMessage(playerid, string);
					EditDynamicObject(playerid, clo_object);
					#endif
				}
				case 4:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/clone");
					#endif
				}
				case 5:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rotreset");
					#endif
				}
				case 6:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dobject");		
					#else 
					DestroyDynamicObject(EDIT_OBJECT_ID);
					#endif
				}
				case 7: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/oprop");
					#endif
				}
				case 8:
				{
					#if defined TEXTURE_STUDIO
					new param[64];
					format(param, sizeof(param), "/minfo %i",
					GetDynamicObjectModel(EDIT_OBJECT_ID[playerid]));
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);					
					#endif
				}
				case 9:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/pivot");
					#endif
				}
				case 10: ShowPlayerMenu(playerid, DIALOG_TEXTUREMENU);
				case 11: ShowPlayerMenu(playerid, DIALOG_GROUPEDIT);
				case 12: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/undo");
					#endif
				}
				case 13: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/redo");
					#endif
				}
			}
		} else {
			//if(EDIT_OBJECT_ID[playerid] == 0) ShowPlayerMenu(playerid, DIALOG_MAIN);
			CancelEdit(playerid);
		}
	}
	if(dialogid == DIALOG_GROUPEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gsel");		
					#else 
					SelectObject(playerid);
					#endif
				}
				case 1: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/setgroup");
					#endif
				}
				case 2: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/selectgroup");
					#endif
				}
				case 3: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gclone");
					#endif
				}
				case 4: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gclear");
					#endif
				}
				case 5: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/gdelete");
					#endif
				}
				case 6: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/obmedit");
					#endif
				}
			}
		}
	}
	if(dialogid == DIALOG_REMMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dobject");		
					#else 
					DestroyDynamicObject(EDIT_OBJECT_ID);
					#endif
				}
				case 1:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dcsel");		
					#endif
				}
				case 2: 
				{
					if (GetPVarInt(playerid, "lang") == 1) {
						ShowPlayerDialog(playerid, DIALOG_RANGEDEL, DIALOG_STYLE_INPUT, "/rangedel", "{FFFFFF}This action {FF0000}delete all{FFFFFF} in the specified radius. Enter radius:\n","Delete"," < ");
					} else {
						ShowPlayerDialog(playerid, DIALOG_RANGEDEL, DIALOG_STYLE_INPUT, "/rangedel", "{FF0000}������� ���{FFFFFF} ������� � �������. ������� ������:\n",
						"�������"," < ");
					}
				}
				case 3: ShowPlayerDialog(playerid, DIALOG_REMDEFOBJECT, DIALOG_STYLE_INPUT,
				"/remobject", "{FFFFFF}Delete default objects by index.\nEnter index:","Delete","<");
				/*case 3:
				{
					#if defined _streamer_included
					if(EDIT_OBJECT_ID[playerid] != 0)
					{
						#if defined TEXTURE_STUDIO
						new param[64];
						format(param, sizeof(param), "/dobject %i", EDIT_OBJECT_ID[playerid]);
						CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
						#endif
					} else {
						SendClientMessageEx(playerid, COLOR_GREY, "�� ������ ��������� ��������� ������", "Last created object not found");
					}
					#endif
				}*/
				case 4:
				{
					if(EDIT_OBJECT_ID[playerid] == -1){
						return SendClientMessageEx(playerid, COLOR_GREY, 
						"�� ������ ������", "No object selected");
					}
					#if defined STREAMER_ALL_TAGS
					Streamer_ToggleItem(playerid, STREAMER_TYPE_OBJECT, EDIT_OBJECT_ID[playerid], 0);
					#else
						#if defined _YSF_included
						HideObjectForPlayer(playerid, EDIT_OBJECT_ID[playerid]);
						#endif
					#endif
				}
				case 5:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/undo");		
					#else
					SendClientMessage(playerid, -1, "Function unavaiable. Need TextureStudio");
					#endif
				}
				case 6: ShowPlayerDialog(playerid, DIALOG_CLEARTEMPFILES, DIALOG_STYLE_MSGBOX, "", "{FFFFFF}This action {FF0000}delete all{FFFFFF} temporary files. You are sure?\n","��","<");
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if(dialogid == DIALOG_RANGEDEL)
	{
		if(response)
		{
			if(!isnull(inputtext) && isNumeric(inputtext))
			{
				DeleteObjectsInRange(playerid, strval(inputtext));
			}
		}
	}
	if(dialogid == DIALOG_REMDEFOBJECT)
	{
		if(response)
		{
			if(!isnull(inputtext) && isNumeric(inputtext))
			{
				#if defined TEXTURE_STUDIO
				new param[64];
				format(param, sizeof(param), "/remobject %i", strval(inputtext));
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
				#endif
			}
		}
	}
	if(dialogid == DIALOG_ASKDELETE)
	{
		if(response)
		{
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/dobject");
			#else
		    DestroyDynamicObject(objectid);
			#endif
		}
	}
	if(dialogid == DIALOG_ROTATION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rx 90");		
					#else
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX + 90, RotY, RotZ);
					#endif
				}
				case 1:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ry 90");		
					#else				
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY+90, RotZ);
					#endif
				}
				case 2:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rz 90");		
					#else
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ+90);
					#endif
				}
				case 3:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rx 180");		
					#else
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX+180, RotY, RotZ);
					#endif
				}
				case 4:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ry 180");		
					#else				
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY+180, RotZ);
					#endif
				}
				case 5:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rz 180");		
					#else
					new Float:RotX,Float:RotY,Float:RotZ;
					GetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ);
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], RotX, RotY, RotZ+180);
					#endif
				}
				case 6:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/rotreset");
					#else
					SetDynamicObjectRot(EDIT_OBJECT_ID[playerid], 0,0,0);
					#endif
				}
			}
		}
		//else ShowPlayerMenu(playerid,DIALOG_EDITMENU);
	}
	if(dialogid == DIALOG_CAMINTERPOLATE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new tbtext[300], cam1_st[18], cam2_st[18];
					
					if(CamData[playerid][X1] > 0) 
					cam1_st = "{00FF00}[Active]"; else cam1_st = "{FF0000}[�FF]";
					
					if(CamData[playerid][X2] > 0)
					cam2_st = "{00FF00}[Active]"; else cam2_st = "{FF0000}[�FF]";
					
					format(tbtext, sizeof tbtext,
					"\t\n"\
					"starting position\t%s\n"\
					"end position\t%s\n",
					cam1_st, cam2_st);
					
					ShowPlayerDialog(playerid, DIALOG_CAMPOINT, DIALOG_STYLE_TABLIST_HEADERS,
					"[CAM] - Point", tbtext, "Select", "Cancel");
				}
				case 1:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_CAMDELAY, DIALOG_STYLE_INPUT,
						"[CAM] - Time", "������� ����� � ������������� �� ���������� �����������:", "Select", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_CAMDELAY, DIALOG_STYLE_INPUT,
						"[CAM] - Time", "Input the time in milliseconds before the move is complete:", "Select", "Cancel");
					}
				}
				case 2:
				{
					if (CamData[playerid][X1] == 0) {
						return SendClientMessageEx(playerid, -1,
						"������ ���������� ��������� �������","Set the starting position first");
					}
					if (CamData[playerid][X2] == 0) {
						return SendClientMessageEx(playerid, -1,
						"���������� �������� �������","Set end position");
					}
					if (CamData[playerid][CamDelay] < 1000) {
						CamData[playerid][CamDelay] = 1000;
					}
					InterpolateCameraPos(playerid,
					CamData[playerid][X1], CamData[playerid][Y1], CamData[playerid][Z1],
					CamData[playerid][X2], CamData[playerid][Y2], CamData[playerid][Z2],
					CamDelay, CAMERA_MOVE);
				}
				case 3:
				{
					if (CamData[playerid][X1] == 0) {
						return SendClientMessageEx(playerid, -1,
						"������ ���������� ��������� �������","Set the starting position first");
					}
					if (CamData[playerid][X2] == 0) {
						return SendClientMessageEx(playerid, -1,
						"���������� �������� �������","Set end position");
					}
					new File: file = fopen("mtools/camdata.txt", io_append);
					new str[200];
					format(str, 200,
					"\r\nInterpolateCameraPos(playerid, %f, %f, %f, %f, %f, %f, %i, CAMERA_MOVE);", 
					CamData[playerid][X1], CamData[playerid][Y1], CamData[playerid][Z1],
					CamData[playerid][X2], CamData[playerid][Y2], CamData[playerid][Z2],
					CamDelay);
					fwrite(file, str);
					fclose(file);
					return SendClientMessageEx(playerid, -1, "�� ��������� � \"camdata.txt\".",
					"Saved to \"camdata.txt\".");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if(dialogid == DIALOG_CAMPOINT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new Float: x, Float: y, Float: z;
					GetPlayerPos(playerid, x,y,z);
					CamData[playerid][X1] = x;
					CamData[playerid][Y1] = y;
					CamData[playerid][Z1] = z;
					SendClientMessageEx(playerid, -1, "������ ����� �����������","First point set");
				}
				case 1:
				{
					new Float: x, Float: y, Float: z;
					GetPlayerPos(playerid, x,y,z);
					CamData[playerid][X2] = x;
					CamData[playerid][Y2] = y;
					CamData[playerid][Z2] = z;
					SendClientMessageEx(playerid, -1, "������ ����� �����������","Second point set");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if(dialogid == DIALOG_CAMFIX)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new Float:X, Float:Y, Float:Z, Float:Angle;
					GetPlayerPos(playerid,X,Y,Z);
					GetPlayerFacingAngle(playerid, Angle);
					SetPlayerCameraPos(playerid,X,Y,Z+50);
					SetPlayerCameraLookAt(playerid,X,Y,Z);
					SetPlayerFacingAngle(playerid,Angle-180.0);
					SendClientMessageEx(playerid, -1,
					"������� /retcam ��� ���� ����� ������� ������",
					"Enter /retcam to return the camera");
				}
				case 1: 
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
					{
						new Float:x1,Float:y1,Float:z1;
						GetPlayerCameraPos(playerid,x1,y1,z1);
						SetPlayerCameraPos(playerid, x1,y1,z1);
						GetPlayerCameraLookAt(playerid, x1,y1,z1);
						SetPlayerCameraLookAt(playerid, x1,y1,z1);
					} else {
						new Float:X, Float:Y, Float:Z, Float:Angle;
						GetPlayerPos(playerid, X , Y , Z);
						GetPlayerFacingAngle(playerid, Angle);
						SetPlayerCameraPos(playerid, X , Y , Z); 
						SetPlayerCameraLookAt(playerid, X , Y , Z);
						GetPlayerFacingAngle(playerid, Angle);
					}
					SendClientMessageEx(playerid, -1,
					"������� /retcam ��� ���� ����� ������� ������",
					"Enter /retcam to return the camera");
				}
				case 2:
				{
					SetCameraBehindPlayer(playerid);
					if(Vehcam[playerid] == 0)
					{
						if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
						{
							return SendClientMessageEx(playerid, -1,
							"������� �� ������ ����������",
							"Stop spectating mode before using this function");
						}
						if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
						{
							new vehicleid = GetPlayerVehicleID(playerid);
							Vehcam[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
							AttachObjectToVehicle(Vehcam[playerid], vehicleid,
							0.0, 0.0, 1.0, 0.0, 0.0, 0.0); // hood view
							AttachCameraToObject(playerid, Vehcam[playerid]);
						} else {
							return SendClientMessageEx(playerid, -1,
							"�� ������ ���� � ������", "You must be in the car");
						}
					}
					else
					{
						SetCameraBehindPlayer(playerid);
						DestroyObject(Vehcam[playerid]);
						Vehcam[playerid] = 0;
					}
				}
				case 3:
				{
					SetCameraBehindPlayer(playerid);
					if(Vehcam[playerid] == 0)
					{
						if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
						{
							return SendClientMessageEx(playerid, -1,
							"������� �� ������ ����������",
							"Stop spectating mode before using this function");
						}
						if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
						{
							new vehicleid = GetPlayerVehicleID(playerid);
							Vehcam[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
							AttachObjectToVehicle(Vehcam[playerid], vehicleid,
							-2.0, -3.0, 1, 0.0, 0.0, 0.0); // hood view
							AttachCameraToObject(playerid, Vehcam[playerid]);
						} else {
							return SendClientMessageEx(playerid, -1,
							"�� ������ ���� � ������", "You must be in the car");
						}
					}
					else
					{
						SetCameraBehindPlayer(playerid);
						DestroyObject(Vehcam[playerid]);
						Vehcam[playerid] = 0;
					}
					/*
					//Attach camera to side vehicle
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						new vehicleid = GetPlayerVehicleID(playerid);
						new Float:x, Float:y, Float:z;
						GetVehiclePos(vehicleid, x,y,z);
						SetPlayerCameraPos(playerid, x,y,z);
						//TogglePlayerSpectating (playerid, 1);
						PlayerSpectateVehicle (playerid, vehicleid, SPECTATE_MODE_SIDE);
					}*/
				}
				case 4:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/ogoto");
					#endif
				}
				case 5:
				{
					//Attach camera to vehicle
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						new vehicleid = GetPlayerVehicleID(playerid);
						TogglePlayerSpectating (playerid, 1);
						PlayerSpectateVehicle (playerid, vehicleid);
					} else {
						if (PlayerVehicle[playerid] != 0)
						{
							TogglePlayerSpectating (playerid, 1);
							PlayerSpectateVehicle (playerid, PlayerVehicle[playerid]);
							//AttachCameraToObject
						} else {
							SendClientMessageEx(playerid, -1,
							"�� ������ ���� � ���������� ��� ���������� ��������� ����� /v",
							"You must be in a transport or spawn a transport via /v");
						}
					}
				}
				case 6:
				{
					new 
						Float:fPX, Float:fPY, Float:fPZ,
						Float:fVX, Float:fVY, Float:fVZ,
						Float:object_x, Float:object_y, Float:object_z
					;
					const Float:fScale = 5.0;
					GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
					GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
					object_x = fPX + floatmul(fVX, fScale);
					object_y = fPY + floatmul(fVY, fScale);
					object_z = fPZ + floatmul(fVZ, fScale);
					format(string, sizeof(string),
					"CameraPos: %f,%f,%f | LookAt: %f,%f,%f",fPX,fPY,fPZ,object_x,object_y,object_z);
					SendClientMessage(playerid, -1, string);
				}
				case 7:
				{
					Vehcam[playerid] = 0; // Fix vehcam
					if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
					{
						#if defined TEXTURE_STUDIO
						CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
						#endif
					} else {
						if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)	{
							TogglePlayerSpectating (playerid, 0);
						}
						SetCameraBehindPlayer(playerid);
					}
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if(dialogid == DIALOG_CAMSPEED)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_FMSPEED, DIALOG_STYLE_INPUT,
					"/fmspeed","{FFFFFF}Enter flight speed in flymode [5-500]", "OK","Cancel");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_FMACCEL, DIALOG_STYLE_INPUT,
					"/fmaccel","{FFFFFF}Enter acceleration in flymode [0.005-0.5]", "OK","Cancel");
				}
				case 2:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/fmtoggle");
					#endif
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if(dialogid == DIALOG_FMACCEL)
	{
		if (!isnull(inputtext))
		{
			new param[64];
			format(param, sizeof(param), "/fmaccel %s", inputtext);
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
			#endif
		}
	}
	if(dialogid == DIALOG_FMSPEED)
	{
		if (!isnull(inputtext))
		{
			//if(strval(inputtext) <= 5 && strval(inputtext) >= 500)
			new param[64];
			format(param, sizeof(param), "/fmspeed %s", inputtext);
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
			#endif
		}
	}
	if(dialogid == DIALOG_CAMSET)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/flymode");
					#endif
				}
				case 1: FirstPersonMode(playerid);
				case 2: GivePlayerWeapon(playerid, 43, 100);
				case 3: 
				{
					MtoolsHudToggle(playerid);
					SelectTextDraw(playerid, 0xFFFFFF);
				}
				case 4:
				{
					new tbtext[450];
					
					if(GetPVarInt(playerid, "lang") == 1)
					{		
						format(tbtext, sizeof(tbtext),
						"View from above (2D Like)\n"\
						"Hold camera position\n"\
						"�amera on the hood of the car\n"\
						"�amera on the side of the vehicle\n"\
						"Camera to the current object\n"\
						"Camera to the current vehicle\n"\
						"Get the current position and direction of the camera\n"\
						"{00FF00}Restore camera\n");
					} else {
						format(tbtext, sizeof(tbtext),
						"��� ������ (2D �����)\n"\
						"��������� ������\n"\
						"��������� ������ �� ������ ������\n"\
						"��������� ������ ����� �� ���������\n"\
						"������ � �������� �������\n"\
						"������ � �������� ����������\n"\
						"������� ������� ������� � ����������� ������\n"\
						"{00FF00}������� ������\n");
					}
					
					ShowPlayerDialog(playerid, DIALOG_CAMFIX, DIALOG_STYLE_LIST,
					"[CAM] camfix",tbtext, "OK","Cancel");
				}
				case 5:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_CAMSPEED, DIALOG_STYLE_TABLIST_HEADERS,
						"[CAM] - Speed",
						"Option\tState\n\
						���������� ������������ �������� � ������ ������\t{00FF00}/fmspeed \n\
						���������� ��������� � ������ ������\t{00FF00}/fmaccel \n\
						���-���� ��������� � ������ ������\t{00FF00}/fmtoggle \n",
						"Select", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_CAMSPEED, DIALOG_STYLE_TABLIST_HEADERS,
						"[CAM] - Speed",
						"Option\tState\n\
						set max speed in flymode\t{00FF00}/fmspeed\n\
						set acceleration in flymode\t{00FF00}/fmaccel\n\
						toggle acceleration in flymode\t{00FF00}/fmtoggle\n",
						"Select", "Cancel");
					}
				}
				case 6: 
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_CAMINTERPOLATE, DIALOG_STYLE_LIST,
						"[CAM] - Interpolate", 
						"���������� �����\n�������� �����������\n������������\n������� � filterscript",
						"Select", "Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_CAMINTERPOLATE, DIALOG_STYLE_LIST,
						"[CAM] - Interpolate", 
						"Set cam point\nMove speed\nPreview\nExport to filterscript",
						"Select", "Cancel");
					}
				}
				case 7: 
				{
					ShowPlayerDialog(playerid, DIALOG_CAMENVIROMENT, DIALOG_STYLE_LIST,
					"[CAM] - Enviroment", 
					" Welcome2Hell\n Matrix\n Realistic physic\n Open space\n Slow-Mo\n Default",
					"Select", "Cancel");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_MAIN);
	}
	if (dialogid == DIALOG_MOVINGOBJ)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					#if defined TEXTURE_STUDIO
					CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/csel");		
					#else 
					SelectObject(playerid);
					#endif
				}
				case 1:
				{
					new Float: x, Float: y, Float: z;
					if(EDIT_OBJECT_ID[playerid] != 0){
						GetDynamicObjectPos(EDIT_OBJECT_ID[playerid], x, y, z);
					} else {
						GetPlayerPos(playerid, x,y,z);
						SendClientMessageEx(playerid, -1,
						"������ �� ��� ������, � �������� ��������� ����� ���������� ������",
						"The object was not selected, set player coordinates as object coords");
					}
					ObjectsMoveData[playerid][X1] = x;
					ObjectsMoveData[playerid][Y1] = y;
					ObjectsMoveData[playerid][Z1] = z;
					SendClientMessageEx(playerid, -1, "��������� ����� �����������","Start point set");
				}
				case 2:
				{
					new Float: x, Float: y, Float: z;
					if(EDIT_OBJECT_ID[playerid] != 0){
						GetDynamicObjectPos(EDIT_OBJECT_ID[playerid], x, y, z);
					} else {
						GetPlayerPos(playerid, x,y,z);
						SendClientMessageEx(playerid, -1,
						"������ �� ��� ������, � �������� ��������� ����� ���������� ������",
						"The object was not selected, set player coordinates as object coords");
					}
					ObjectsMoveData[playerid][X2] = x;
					ObjectsMoveData[playerid][Y2] = y;
					ObjectsMoveData[playerid][Z2] = z;
					SendClientMessageEx(playerid, -1, "��������� ����� �����������","End point set");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_DYNOBJSPEED, DIALOG_STYLE_INPUT,
					"Move speed",
					"{FFFFFF}Enter movement speed in ms:",
					"OK", "Cancel");
				}
				case 4:
				{
					if(EDIT_OBJECT_ID[playerid] != 0){
						ObjectsMoveData[playerid][movobject] = EDIT_OBJECT_ID[playerid];
					} else {
						return SendClientMessageEx(playerid, -1,
						"������ �� ��� ������!","The object was not selected!");
					}
					if(ObjectsMoveData[playerid][MoveSpeed] <= 0){
						ObjectsMoveData[playerid][MoveSpeed] = 20000;
					}
					if(ObjectsMoveData[playerid][X1] == 0){
						return SendClientMessageEx(playerid, -1,
						"��������� ������� �� �����������","Set start point!");
					}
					/*if(ObjectsMoveData[playerid][X2] == 0){
						return SendClientMessageEx(playerid, -1,
						"��������� ������� �� �����������","Set end point!");
					}*/
					new Float: rx, Float: ry, Float: rz;
					GetDynamicObjectRot(ObjectsMoveData[playerid][movobject], rx, ry, rz);
					MoveDynamicObject(ObjectsMoveData[playerid][movobject],
					ObjectsMoveData[playerid][X2],
					ObjectsMoveData[playerid][Y2],
					ObjectsMoveData[playerid][Z2],
					ObjectsMoveData[playerid][MoveSpeed],
					rx, ry, rz);
					// back to start pos
					/*MoveDynamicObject(ObjectsMoveData[playerid][movobject],
					ObjectsMoveData[playerid][X1],
					ObjectsMoveData[playerid][Y1],
					ObjectsMoveData[playerid][Z1],
					ObjectsMoveData[playerid][MoveSpeed],
					rx, ry, rz);*/
				}
				case 5:
				{
					StopDynamicObject(EDIT_OBJECT_ID[playerid]);
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_OBJECTSMENU);
	}
	if (dialogid == DIALOG_CAMENVIROMENT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 
				{
					//SetPlayerWeather(playerid, 1276);
					//SetPlayerTime(playerid, 6, 0);
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					SetPlayerInterior(playerid, 0);
					SetPlayerWeather(playerid,42);
					SetPlayerTime(playerid, 23, 0);
					SetPlayerSkin(playerid, 162);
					//new explode_object = CreateDynamicObject(18682,
					//x, y, z, 0.0,0.0,0.0, -1,-1,-1, 300); 
					//DestroyDynamicObject(explode_object);	
					CreateExplosion(x, y, z, 12, 7);
					SendClientMessageEx(playerid, COLOR_RED,
					"� ��� ��� ����� � ����. Welcome to hell!",
					"No light, no water. no mercy. Welcome to hell!");
				}
				case 1:
				{
					SetGravity(0.005);
					SetPlayerWeather(playerid, 20);
					SetPlayerTime(playerid, 0, 0);
					SetPlayerSkin(playerid, 294);
					superJump = true;
					GameTextForPlayer(playerid, "~g~Enter the Matrix", 1000, 5);
					SendClientMessageEx(playerid, COLOR_LIME,
					"� ���� ������ �������� ���������� � ������� ����� ������",
					"In this mode, the gravity is changed and the super jump is enabled");
				}
				case 2:
				{
					SetGravity(0.013);
					SendClientMessageEx(playerid, COLOR_LIME,
					"� ���� ������ �������� ������ �� ����� ������������",
					"In this mode, physics has been changed to more realistic");
				}
				case 3:
				{
					SendClientMessageEx(playerid, COLOR_LIME,
					"� ���� ������ ��������� ��������� ����������",
					"In this mode, gravity is disabled.");
					SetGravity(0.000);
					SetPlayerWeather(playerid, 21);
					SetPlayerTime(playerid, 5, 0);
				}
				case 4:
				{
					SendClientMessageEx(playerid, COLOR_LIME,
					"������� ����� ������",
					"Slow motion mode enabled");
					SetGravity(0.001); 
				}
				case 5:
				{
					SetGravity(0.008);
					SetPlayerWeather(playerid,0);
					SetPlayerTime(playerid, 12, 0);
					superJump = false;
					SendClientMessageEx(playerid, COLOR_LIME,
					"������ � ��������� ������������� �� �����������",
					"Physics and environment restored to standard");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if (dialogid == DIALOG_CAMDELAY)
	{
		if(response)
		{
			if (isnull(inputtext) || !isNumeric(inputtext))
			{
				return SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
			if (strval(inputtext) < 1000)
			{
				SendClientMessageEx(playerid, COLOR_GREY, 
				"������� �������� �� ������ 1000�� (1���)",
				"Enter a value not less than 1000ms (1sec)");
			} else {
				CamData[playerid][CamDelay] = strval(inputtext);
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CAMSET);
	}
	if (dialogid == DIALOG_OBJSEARCH)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new param[64];
				format(param, sizeof(param), "/osearch %s", inputtext);
				#if defined TEXTURE_STUDIO
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
				#endif
			} else {
				SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_MODELSIZEINFO)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new param[64];
				format(param, sizeof(param), "/minfo %s", inputtext);
				#if defined TEXTURE_STUDIO
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
				#endif
			} else {
				SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_TEXTURESEARCH)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new param[64];
				format(param, sizeof(param), "/tsearch %s", inputtext);
				#if defined TEXTURE_STUDIO
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);		
				#endif
			} else {
				SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_OBJDISTANCE)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new objectid = strval(inputtext);
				if(IsValidDynamicObject(objectid))
				{
					SetPVarInt(playerid, "d_objectid",objectid);
					ShowPlayerDialog(playerid, DIALOG_OBJDISTANCE2, DIALOG_STYLE_INPUT,
					"Distance [object #2]",
					"{FFFFFF}Enter 2 objectid:",
					"OK", "Cancel");
				} else {
					SendClientMessageEx(playerid, COLOR_GREY,
					"�� ������ ������ � ����� id", "No object with this id found");
				}
			} else {
				SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_OBJDISTANCE2)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new objectid2 = strval(inputtext);
				if(IsValidDynamicObject(objectid2))
				{
					new
						Float:x, Float:y, Float:z,
						Float:x2, Float:y2, Float:z2,
						Float: distance, tmpstr[128]
					;
					GetDynamicObjectPos(GetPVarInt(playerid, "d_objectid"), x, y, z);
					GetDynamicObjectPos(objectid2, x2, y2, z2);
					distance = GetDistanceBetweenPoints(x, y, z, x2, y2, z2);
					//GetDistanceBetweenObjects(GetPVarInt(playerid, "d_objectid"),
					format(tmpstr, sizeof(tmpstr),
					"distance %.3f between id:%i and id2:%i",
					distance, GetPVarInt(playerid, "d_objectid"), objectid2);
					SendClientMessage(playerid, -1, tmpstr);
					DeletePVar(playerid, "d_objectid");
				} else {
					SendClientMessageEx(playerid, COLOR_GREY,
					"�� ������ ������ � ����� id", "No object with this id found");
				}
			} else {
				SendClientMessageEx(playerid, COLOR_GREY,
				"�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_DYNOBJSPEED)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				ObjectsMoveData[playerid][MoveSpeed] = strval(inputtext);
			}
		}
	}
	if (dialogid == DIALOG_DUPLICATESEARCH)
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				new modelid = strval(inputtext);
				if(IsValidObjectModel(modelid))	{
					FindDuplicateObjects(playerid, modelid);
				}
			}
		}
	}
	if(dialogid == DIALOG_SKIN)// /skin
    {
        if(response)
        {
            new skinid = strval(inputtext);
            if(skinid < 0 || skinid > 301 || skinid == 74)
            {
                SendClientMessageEx(playerid, COLOR_GREY, "������: �������� ���� � ��������� 0-301", "Error: Choose a skin ID between 0 and 301.");
            }
            else
            {
				if (IsPlayerInAnyVehicle(playerid)) {
					return SendClientMessage(playerid, COLOR_GREY, "Exit from vehicle!");
				}
				new oldskinid = GetPlayerSkin(playerid);
				if (GetPVarInt(playerid, "lang") == 1) {
					format(string, sizeof(string), "New skin id: %i, old skin id: %i",
					skinid, oldskinid);
				} else {
					format(string, sizeof(string), "� ������ �����: %i, � ����������� �����: %i",
					skinid, oldskinid);
				}
				SendClientMessage(playerid, COLOR_LIME, string);
                SetPlayerSkin(playerid, skinid);
            }
        }
		else ShowPlayerMenu(playerid, DIALOG_SETTINGS);
    }
	if (dialogid == DIALOG_WEATHER) //weather set
	{
		if(response)
		{
			if (strval(inputtext) > 255 || strval(inputtext) < 1)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "�������� � ������, ��������� �������� [1-255]", "Incorrect weather ID, available values [1-255]");
			} else {
				SetPlayerWeather(playerid, strval(inputtext)); 
				SetPVarInt(playerid,"Weather",strval(inputtext));
			}
			ShowPlayerDialog(playerid, DIALOG_WEATHER, DIALOG_STYLE_INPUT, "Set weather",
			"{FFFFFF}Weather IDs 1-22 appear to work correctly but other IDs may result in strange effects (max 255)\n\n"\
			"1 = SUNNY_LA (DEFAULT)\t11 = EXTRASUNNY_VEGAS (heat waves)\n"\
			"2 = EXTRASUNNY_SMOG_LA\t12 = CLOUDY_VEGAS\n"\
			"3 = SUNNY_SMOG_LA\t13 = EXTRASUNNY_COUNTRYSIDE\n"\
			"4 = CLOUDY_LA\t\t14 = SUNNY_COUNTRYSIDE\n"\
			"5 = SUNNY_SF\t\t15 = CLOUDY_COUNTRYSIDE\n"\
			"6 = EXTRASUNNY_SF\t\t16 = RAINY_COUNTRYSIDE\n"\
			"7 = CLOUDY_SF\t\t17 = EXTRASUNNY_DESERT\n"\
			"8 = RAINY_SF\t\t18 = SUNNY_DESERT\n"\
			"9 = FOGGY_SF\t\t19 = SANDSTORM_DESERT\n"\
			"10 = SUNNY_VEGAS\t20 = UNDERWATER (greenish, foggy)\n\n"\
			"Enter weather id\n",
			"Ok", "Cancel");
		}
	}
	if (dialogid == DIALOG_TIME) //time set
	{
		if(response)
		{
			if (strval(inputtext) > 23 || strval(inputtext) < 0)
			{
				SendClientMessageEx(playerid, COLOR_GREY, "��������� ����� 0-23 �����", "Incorrect [hour], available values [0-23]");
			} else {
				SetPlayerTime(playerid,strval(inputtext),0); 
				SetPVarInt(playerid,"Hour",strval(inputtext)); 
			}
		}
	}
	if (dialogid == DIALOG_GRAVITY) 
	{
		if(response)
		{
			if (!isnull(inputtext))
			{
				SetGravity(floatstr(inputtext)); 
			} else {
				SendClientMessageEx(playerid, COLOR_GREY, "�������� ��������", "Incorrect value");
			}
		}
	}
	if (dialogid == DIALOG_CLEARTEMPFILES)
	{
		if(response) RemoveTempMapEditorFiles(playerid);
	}
	if(dialogid == DIALOG_SOUNDTEST)
	{
		if(response)
		{
			new Value = strval(inputtext);
			format(string, sizeof(string), "Sound id: %d", Value);
			SendClientMessage(playerid, -1, string);
			PlayerPlaySound(playerid,Value,0,0,0);
			ShowPlayerMenu(playerid, DIALOG_SOUNDTEST);
		} else {
			PlayerPlaySound(playerid,strval(inputtext)+1,0,0,0);
			PlayerPlaySound(playerid,0,0,0,0);
			StopAudioStreamForPlayer(playerid);
		}
	}
	if(dialogid == DIALOG_SOUNDPOINT)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				new Value = strval(inputtext);
				format(string, sizeof(string), "Sound id: %d", Value);
				SendClientMessage(playerid, -1, string);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0],pos[1],pos[2]);
				PlayerPlaySound(playerid, Value, pos[0], pos[1], pos[2]);
			}
			#if defined TEXTURE_STUDIO
			CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/cobject 2226");
			#endif
		}
	}
	if(dialogid == DIALOG_3DTEXTMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:	
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_CREATE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text","{FFFFFF}������� �����\n",
						"Create","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_CREATE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text","{FFFFFF}Enter text\n",
						"Create","Cancel");
					}
				}
				case 1:
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_INDEX3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Index","{FFFFFF}������� index ��� ��������������\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_INDEX3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Index","{FFFFFF}Enter index to edit\n",
						"Select","Cancel");
					}
				}
				case 2:
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_UPDATE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Edit text","{FFFFFF}������� ����� �����\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_UPDATE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Edit text","{FFFFFF}Enter new text\n",
						"Select","Cancel");
					}
				}
				case 3:
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_COLOR3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Color","{FFFFFF}������� ����� ���� � ������� (0xAFAFAFAA)\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_COLOR3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Color","{FFFFFF}Enter new color. format(0xAFAFAFAA)\n",
						"Select","Cancel");
					}
				}
				case 4:
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_DISTANCE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Color","{FFFFFF}������� ���������\n",
						"Select","Cancel");
					} else {
						ShowPlayerDialog(playerid, DIALOG_DISTANCE3DTEXT, DIALOG_STYLE_INPUT,
						"3D Text - Color","{FFFFFF}Enter new distance\n",
						"Select","Cancel");
					}
				}
				case 5:
				{
					new index =	CurrentIndex3dText;
					new tmpstr[128];
					GetPlayerPos(playerid,Text3dArray[index][tPosX],
					Text3dArray[index][tPosY],Text3dArray[index][tPosZ]);
					#if defined _streamer_included
					DestroyDynamic3DTextLabel(Text3dArray[index][index3d]);
					Text3dArray[index][index3d]= CreateDynamic3DTextLabel(Text3dArray[index][Text3Dvalue],
					Text3dArray[index][Text3Dcolor], Text3dArray[index][tPosX], Text3dArray[index][tPosY],
					Text3dArray[index][tPosZ], Text3dArray[index][Text3Ddistance], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
					#else
					Delete3DTextLabel(Text3dArray[index][index3d]);
					Text3dArray[index][index3d] = Create3DTextLabel(Text3dArray[index][Text3Dvalue],Text3dArray[index][Text3Dcolor],Text3dArray[index][tPosX],Text3dArray[index][tPosY],Text3dArray[index][tPosZ],Text3dArray[index][Text3Ddistance],0);
					#endif
					format(tmpstr, sizeof(tmpstr), "3Dtext:%i position %.2f,%.2f,%.2f",
					index, Text3dArray[index][tPosX],
					Text3dArray[index][tPosY],Text3dArray[index][tPosZ]);
					SendClientMessage(playerid, -1, tmpstr);
					//Streamer_Update(playerid);
				}
				case 6:
				{
					new index =	CurrentIndex3dText;
					Text3dArray[index][Text3Dvalue] = EOS;
					Text3dArray[index][Text3Dcolor] = TEXT3D_DEFAULT_COLOR;
					Text3dArray[index][Text3Ddistance] = TEXT3D_DEFAULT_DISTANCE;
					Text3dArray[index][tPosX] = 0.0;
					Text3dArray[index][tPosY] = 0.0;
					Text3dArray[index][tPosY] = 0.0;
					DestroyDynamic3DTextLabel(Text3dArray[index][index3d]);
				}
				case 7:
				{
					new buffer[450];
					new File:pos = fopen("mtools/3DText.txt", io_append);
					new index =	CurrentIndex3dText;
					
					#if defined _streamer_included
					format(buffer, sizeof buffer, 
					"CreateDynamic3DTextLabel(\"%s\", %s, %.2f, %.2f, %.2f, %.1f, 0,\
					INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, %.1f);\r\n",
					Text3dArray[index][Text3Dvalue], Text3dArray[index][Text3Dcolor],
					Text3dArray[index][tPosX],Text3dArray[index][tPosY],
					Text3dArray[index][tPosZ],Text3dArray[index][Text3Ddistance],
					Text3dArray[index][Text3Ddistance]);
					#else
					format(buffer, sizeof buffer, 
					"Create3DTextLabel(\"%s\", %s, %.2f, %.2f, %.2f, %.1f, 0);\r\n",
					Text3dArray[index][Text3Dvalue], Text3dArray[index][Text3Dcolor], 
					Text3dArray[index][tPosX],Text3dArray[index][tPosY],
					Text3dArray[index][tPosZ],Text3dArray[index][Text3Ddistance]);
					#endif
					fwrite(pos, buffer);
					fclose(pos);
					SendClientMessage(playerid, -1,
					"3D Text export to {FFD700}scriptfiles > mtools > 3DText.txt");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_ACTORS)
	{
		if(response)
		{
			switch(listitem)
			{
				// ApplyDynamicActorAnimation(playerid, "VENDING", "VEND_EAT1_P", 4.1, 0, 0, 0, 0, 0);
				case 0:	
				{
					if (GetPVarInt(playerid, "lang") == 0) {
						ShowPlayerDialog(playerid, DIALOG_ACTORCREATE, DIALOG_STYLE_INPUT,
						"Create actor", "{FFFFFF}������� �� ����� ������","OK"," < ");
					} else {
						ShowPlayerDialog(playerid, DIALOG_ACTORCREATE, DIALOG_STYLE_INPUT,
						"Create actor", "{FFFFFF}Enter the actor's skin id","OK"," < ");
					}
				}
				case 1:
				{
					if (GetPVarInt(playerid, "lang") == 0) 
					{
						ShowPlayerDialog(playerid, DIALOG_ACTORINDEX, DIALOG_STYLE_INPUT,
						"ACTORS manager", "�������� ������ ������ (0-10):", "OK"," < ");
					} else {
						ShowPlayerDialog(playerid, DIALOG_ACTORINDEX, DIALOG_STYLE_INPUT,
						"ACTORS manager", "Select actor index (0-10):", "OK"," < ");
					}
				}
				case 2:
				{
					if (GetPVarInt(playerid, "lang") == 0)
					{
						ShowPlayerDialog(playerid, DIALOG_ACTORANIMLIB, DIALOG_STYLE_INPUT,
						"Animlib",
						"{FFFFFF}������� �������� ���������� �������� (animlib[]) �������� PED",
						"OK"," < ");
					} else {
						ShowPlayerDialog(playerid, DIALOG_ACTORANIMLIB, DIALOG_STYLE_INPUT,
						"Animlib",
						"{FFFFFF}Enter the name of the animation lib (animlib[]) example PED",
						"OK"," < ");
					}
				}
				case 3: 
				{
					#if defined _new_streamer_included
					if(IsDynamicActorInvulnerable(Actors[indexActor])){
						SetDynamicActorInvulnerable(Actors[indexActor], false);
					}
					else SetDynamicActorInvulnerable(Actors[indexActor], true);
					#else
					if(IsActorInvulnerable(Actors[indexActor])) SetActorInvulnerable(Actors[indexActor], false);
					else SetActorInvulnerable(Actors[indexActor], true);
					#endif
				}
				case 4:
				{
					new Float: x, Float: y, Float: z, Float:ang;  
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					#if defined _new_streamer_included
					SetDynamicActorPos(Actors[indexActor], x, y, z);
					#else
					SetActorFacingAngle(Actors[indexActor], ang-180.0);
					SetActorPos(Actors[indexActor], x+1, y, z);
					#endif
				}
				case 5:
				{
					new Float:ang, Float:actor_ang;
					GetPlayerFacingAngle(playerid, ang);
					#if defined _new_streamer_included
					GetDynamicActorFacingAngle(Actors[indexActor], actor_ang);
					SetDynamicActorFacingAngle(Actors[indexActor], ang -180.0);
					#else
					GetActorFacingAngle(Actors[indexActor], actor_ang);
					SetActorFacingAngle(Actors[indexActor], ang-180.0);
					#endif
				}
				case 6: 
				{
					#if defined _new_streamer_included
					DestroyDynamicActor(Actors[indexActor]);
					#else
					DestroyActor(Actors[indexActor]);
					#endif
				}
				case 7: 
				{
					ShowPlayerDialog(playerid, DIALOG_ACTORSMASSMENU, DIALOG_STYLE_LIST,
					"������� ��������",
					"{FFFFFF}������� ��������\n"\
					"���-�� �������\n"\
					"��������� ��������\n"\
					"������������ ��������\n"\
					"������������ ����������\n"\
					"{FF0000}���������� ��������\n",
					"OK","Cancel");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_ACTORINDEX)
	{
		if(response)
		{
			if(!isnull(inputtext) && isNumeric(inputtext))
			{
				if(strval(inputtext) > 0 && strval(inputtext) <= 10){
					indexActor = strval(inputtext);
				} 
				else SendClientMessageEx(playerid, -1, "������������ ��������","Incorrect value");
			}
		}
	}
	if(dialogid == DIALOG_ACTORCREATE)
	{
		if(response)
		{
			if(!isnull(inputtext) && isNumeric(inputtext))
			{
				new skinid = strval(inputtext);
				if(skinid >= 1 && skinid < 305 && skinid != 74)
				{
					new Float:pos[4];
					GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					// Create test actor
					#if defined _new_streamer_included
					DestroyDynamicActor(Actors[indexActor]);
					Actors[indexActor] = CreateDynamicActor(skinid, pos[0]+1, pos[1]+1, pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					#else
					DestroyActor(Actors[indexActor]);
					Actors[indexActor] = CreateActor(skinid, pos[0]+1, pos[1]+1, pos[2], pos[3]);
					SetActorVirtualWorld(Actors[indexActor], GetPlayerVirtualWorld(playerid));
					#endif
				}
				else SendClientMessageEx(playerid, -1, "����� ������ �� ����� �� 0 �� 305","Need to enter the skin id (0 to 305)");
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_ACTORS);
	}
	if(dialogid == DIALOG_ACTORANIMLIB)
	{
		if(response)
		{
			if(isnull(inputtext)) return SendClientMessage(playerid, -1, "�� �������� ���� ����� ������");
			format(animactordatalib, sizeof animactordatalib, "%s", inputtext);
			ShowPlayerDialog(playerid, DIALOG_ACTORANIMNAME, DIALOG_STYLE_INPUT, "Animlib",
			"{FFFFFF}������ ������ �������� �� ����� {00BFFF}http://wiki.pro-pawn.ru/wiki/��������\n {FFFFFF}������� �������� ��������. (animname[]) �������� IDLE_tired\n","Ok"," X ");
		}
		else ShowPlayerMenu(playerid, DIALOG_ACTORS);
	}
	if(dialogid == DIALOG_ACTORANIMNAME)
	{
		if(response)
		{
			if(isnull(inputtext)) return SendClientMessage(playerid, -1, "�� �������� ���� ����� ������");
			format(animactordataname, sizeof animactordataname, "%s", inputtext);
			#if defined _new_streamer_included
			ApplyDynamicActorAnimation(Actors[indexActor],animactordatalib,animactordataname, 4.1, 1, 0, 0, 0, 0);
			#else 
			ApplyActorAnimation(Actors[indexActor],animactordatalib,animactordataname, 4.1, 1, 0, 0, 0, 0); 
			#endif
			
			#if defined _YSF_included
			SendClientMessagef(playerid, -1, "animation %s - %s", animactordatalib, animactordataname);
			#endif
		}
		else ShowPlayerMenu(playerid, DIALOG_ACTORS);
	}
	#if defined STREAMER_TAG_ACTOR
	if(dialogid == DIALOG_ACTORSMASSMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new Float:pos[4];
					GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					for (new x = 0; x < sizeof(massactor); x++) {
						DestroyDynamicActor(massactor[x]);
					}
					massactor[0] = CreateDynamicActor(random(73), pos[0]+random(2)+2, pos[1]+random(5), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[1] = CreateDynamicActor(random(73), pos[0]+random(3)+3, pos[1]+random(6), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[2] = CreateDynamicActor(random(73), pos[0]+random(4)+4, pos[1]+random(7), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[3] = CreateDynamicActor(random(73), pos[0]+random(4)+2, pos[1]+random(8), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[4] = CreateDynamicActor(random(73), pos[0]+random(4)+3, pos[1]+random(9), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[5] = CreateDynamicActor(random(73), pos[0]+random(4)+4, pos[1]+random(10), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[6] = CreateDynamicActor(random(73), pos[0]+random(4)+1, pos[1]+random(11), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					massactor[7] = CreateDynamicActor(random(73), pos[0]+random(4)+1, pos[1]+random(12), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					ApplyDynamicActorAnimation(massactor[0], "RIOT", "RIOT_ANGRY", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[1], "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[2], "RIOT", "RIOT_challenge", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[3], "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[5], "RIOT", "RIOT_PUNCHES", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[6], "RIOT", "RIOT_shout", 4.1, 1, 0, 0, 0, 0);
				}
				case 1: SetPVarInt(playerid, "MassActors",10);
				//case 4: ShowPlayerDialog(playerid, DIALOG_ACTORMASSANIM, DIALOG_STYLE_LIST,
				//"������� ��������", "����������\nSWAT\n����������","�������","������");
				case 5:
				{
					for (new x = 0; x < sizeof(massactor); x++) {
						DestroyDynamicActor(massactor[x]);
					}
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_ACTORS);
	}
	if(dialogid == DIALOG_ACTORMASSANIM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new Float:pos[4];
					GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					for (new x = 0; x < sizeof(massactor); x++) {
						DestroyDynamicActor(massactor[x]);
					}
					for (new x = 0; x < sizeof(massactor); x++) {
						massactor[x] = CreateDynamicActor(random(73), pos[0]+random(4)+2, pos[1]+random(4)+0.5, pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
						if(x > 5)
						{
							if(x % 2 == 0) ApplyDynamicActorAnimation(massactor[x], "RIOT", "RIOT_ANGRY", 4.1, 1, 0, 0, 0, 0);
							else ApplyDynamicActorAnimation(massactor[x], "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0);
						}else{
							if(x % 2 == 0) ApplyDynamicActorAnimation(massactor[x], "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0);
							else ApplyDynamicActorAnimation(massactor[x], "RIOT", "RIOT_PUNCHES", 4.1, 1, 0, 0, 0, 0);
						}
					}
					/*ApplyDynamicActorAnimation(massactor[0], "RIOT", "RIOT_ANGRY", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[1], "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[2], "RIOT", "RIOT_challenge", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[3], "RIOT", "RIOT_CHANT", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[5], "RIOT", "RIOT_PUNCHES", 4.1, 1, 0, 0, 0, 0);
					ApplyDynamicActorAnimation(massactor[6], "RIOT", "RIOT_shout", 4.1, 1, 0, 0, 0, 0);*/
				}
				case 1:
				{
					new Float:pos[4];
					GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					for (new x = 0; x < sizeof(massactor); x++) {
						DestroyDynamicActor(massactor[x]);
					}
					for (new x = 0; x < sizeof(massactor); x++) {
						if(x == 5) break;
						if(x % 2 == 0){
							massactor[x] = CreateDynamicActor(285, pos[0], pos[1]+random(2)+x+2, pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
						}else{
							massactor[x] = CreateDynamicActor(285, pos[0], pos[1]+random(3)+x+3, pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
						}
						ApplyDynamicActorAnimation(massactor[x], "PED", "IDLE_HBHB", 4.1, 1, 0, 0, 0, 0);
					}
				}
				case 2:
				{
					new Float:pos[4];
					GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					for (new x = 0; x < sizeof(massactor); x++) {
						DestroyDynamicActor(massactor[x]);
					}
					// CreateDynamicActor(modelid, Float:x, Float:y, Float:z, Float:r, invulnerable = 1, Float:health = 100.0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_ACTOR_SD, areaid = -1, priority = 0)
					massactor[0] = CreateDynamicActor(178, pos[0]+random(2), pos[1]+random(2), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					ApplyDynamicActorAnimation(massactor[0], "STRIP","strip_D", 4.1, 1, 0, 0, 0, 0);
					massactor[1] = CreateDynamicActor(90, pos[0]+random(2), pos[1]+random(2), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					ApplyDynamicActorAnimation(massactor[1], "STRIP","strip_G", 4.1, 1, 0, 0, 0, 0);
					massactor[2] = CreateDynamicActor(152, pos[0]+random(2), pos[1]+random(2), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					ApplyDynamicActorAnimation(massactor[2], "STRIP","strip_C", 4.1, 1, 0, 0, 0, 0);
					massactor[3] = CreateDynamicActor(214, pos[0]+random(2), pos[1]+random(2), pos[2], pos[3], 0, 100.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, STREAMER_ACTOR_SD, -1, 0);
					ApplyDynamicActorAnimation(massactor[3], "STRIP","strip_F", 4.1, 1, 0, 0, 0, 0);
				}
			}
		}
	}
	#endif
	if(dialogid == DIALOG_PLAYERATTACHMAIN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 00:ShowIndexList(playerid);
				case 01:ShowModelInput(playerid);
				case 02:ShowBoneList(playerid);
				case 03:EditAttachCoord(playerid, ATPPOS_OFFSET_X);
				case 04:EditAttachCoord(playerid, ATPPOS_OFFSET_Y);
				case 05:EditAttachCoord(playerid, ATPPOS_OFFSET_Z);
				case 06:EditAttachCoord(playerid, ROT_OFFSET_X);
				case 07:EditAttachCoord(playerid, ROT_OFFSET_Y);
				case 08:EditAttachCoord(playerid, ROT_OFFSET_Z);
				case 09:EditAttachCoord(playerid, ATPSCALE_X);
				case 10:EditAttachCoord(playerid, ATPSCALE_Y);
				case 11:EditAttachCoord(playerid, ATPSCALE_Z);
				case 12:EditAttachment(playerid);
				case 13:ClearCurrentIndex(playerid);
				case 14:SaveAttachedObjects(playerid);
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_ATPINDEX_SELECT)
	{
		if(response)
		{
			gCurrentAttachIndex[playerid] = listitem;
			ShowMainAttachEditMenu(playerid);
		}
		else ShowMainAttachEditMenu(playerid);

		return 1;
	}
	if(dialogid == DIALOG_ATPMODEL_SELECT)
	{
		if(response)
		{
			gIndexModel[playerid][gCurrentAttachIndex[playerid]] = strval(inputtext);
			ShowMainAttachEditMenu(playerid);
		}
		else ShowMainAttachEditMenu(playerid);
	}

	if(dialogid == DIALOG_ATPBONE_SELECT)
	{
		if(response)
		{
			gIndexBone[playerid][gCurrentAttachIndex[playerid]] = listitem + 1;
			ShowMainAttachEditMenu(playerid);
		}
		else ShowMainAttachEditMenu(playerid);
	}
	if(dialogid == DIALOG_ATPCOORD_INPUT)
	{
		if(response)
		{
			new Float:value = floatstr(inputtext);

			switch(gCurrentAxisEdit[playerid])
			{
				case ATPPOS_OFFSET_X:  gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = value;
				case ATPPOS_OFFSET_Y:  gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = value;
				case ATPPOS_OFFSET_Z:  gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = value;
				case ROT_OFFSET_X:  gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = value;
				case ROT_OFFSET_Y:  gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = value;
				case ROT_OFFSET_Z:  gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = value;
				case ATPSCALE_X:       gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = value;
				case ATPSCALE_Y:       gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = value;
				case ATPSCALE_Z:       gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = value;
			}

			SetPlayerAttachedObject(playerid,
			gCurrentAttachIndex[playerid],
			gIndexModel[playerid][gCurrentAttachIndex[playerid]],
			gIndexBone[playerid][gCurrentAttachIndex[playerid]],
			gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
			gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
			gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
			gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
			gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
			gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
			gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
			gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
			gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z]);
		}
		ShowMainAttachEditMenu(playerid);
	}
	if(dialogid == DIALOG_VAE)
	{	
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//VaeData[playerid][EditStatus] = vaeModel;
					ShowPlayerDialog(playerid, DIALOG_VAENEW, DIALOG_STYLE_INPUT,
					"VAE New attach", "specify the object model to attach to the vehicle.\
					(For example minigun: 362)\nEnter model id:",
					">>>","Cancel");
					SendClientMessage(playerid, -1, "Editing Object Model.");
				}
				case 1:
				{
					VaeData[playerid][EditStatus] = vaeFloatX;
					SendClientMessage(playerid, -1, "�������������� ��� X.");
				}
				case 2:
				{
					VaeData[playerid][EditStatus] = vaeFloatY;
					SendClientMessage(playerid, -1, "�������������� ��� Y.");
				}
				case 3:
				{
					VaeData[playerid][EditStatus] = vaeFloatZ;
					SendClientMessage(playerid, -1, "�������������� ��� Z.");
				}
				case 4:
				{
					VaeData[playerid][EditStatus] = vaeFloatRX;
					SendClientMessage(playerid, -1, "�������������� ��� RX.");
				}
				case 5:
				{
					VaeData[playerid][EditStatus] = vaeFloatRY;
					SendClientMessage(playerid, -1, "�������������� ��� RY.");
				}
				case 6:
				{
					VaeData[playerid][EditStatus] = vaeFloatRZ;
					SendClientMessage(playerid, -1, "�������������� ��� RZ.");
				}
				case 7:
				{
					if(GetPVarInt(playerid, "freezed") > 0)
					{
						TogglePlayerControllable(playerid, true);
						SetPVarInt(playerid,"freezed",0);
						SendClientMessageEx(playerid, -1, "�� ������������","You are unfreezed");
					} else {
						TogglePlayerControllable(playerid, false);
						SetPVarInt(playerid,"freezed",1);
						SendClientMessageEx(playerid, -1, "�� �����������","You are freezed");
					}
				}
				case 8:
				{
					KillTimer(VaeData[playerid][timer]);
					TogglePlayerControllable(playerid, true);
					SetPVarInt(playerid,"freezed",0);
					DeletePVar(playerid, "VaeEdit");
					SendClientMessage(playerid, -1, "�������������� ���������.");
				}
				case 9:
				{
					new File: file = fopen("mtools/Vaeditions.txt", io_append);
					new str[200];
					format(str, 200, "\r\nAttachObjectToVehicle(objectid, vehicleid, %f, %f, %f, %f, %f, %f); //Object Model: %d | %s", VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ], VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ], VaeData[playerid][objmodel]);
					fwrite(file, str);
					fclose(file);
					return SendClientMessageEx(playerid, -1, "�� ��������� � \"vaeditions.txt\".", "Saved to \"vaeditions.txt\".");
				}
			}
		}
		else ShowPlayerMenu(playerid, DIALOG_CREATEMENU);
	}
	if(dialogid == DIALOG_VAENEW)
	{
		if(response)
		{
			if(!isnull(inputtext) && strval(inputtext) != INVALID_OBJECT_ID)
			{
				if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessageEx(playerid, -1, "�� �� � ������.","You are not in the car.");
				if(VaeData[playerid][timer] != -1) KillTimer(VaeData[playerid][timer]);
				if(IsValidObject(VaeData[playerid][obj])) DestroyObject(VaeData[playerid][obj]);
				
				if(VaeData[playerid][obj] == -1)
				{
					SendClientMessageEx(playerid, -1, 
					"����������� ������� {FF0000}�����-������{FFFFFF} ��� ����������� ������",
					"Use keys {FF0000}LEFT - RIGHT{FFFFFF} to move attach");
					SendClientMessageEx(playerid, -1, 
					"����������� {FF0000}F / ENTER{FFFFFF} ��� ���� ����� �������� ���� ��������������",
					"Hold {FF0000}F / ENTER{FFFFFF} to show the edit menu");
				}
			
				if(VaeData[playerid][timer] != -1) KillTimer(VaeData[playerid][timer]);
				if(IsValidObject(VaeData[playerid][obj])) DestroyObject(VaeData[playerid][obj]);	
				new Obj = CreateObject(strval(inputtext), 0.0, 0.0, -10.0, -50.0, 0, 0, 0);
				new vId = GetPlayerVehicleID(playerid);
				AttachObjectToVehicle(Obj, vId, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				VaeData[playerid][timer] = SetTimerEx("VaeGetKeys", 30, true, "i", playerid);
				VaeData[playerid][EditStatus] = vaeFloatX;
				VaeData[playerid][VehicleID] = vId;		
				VaeData[playerid][objmodel] = strval(inputtext);
				if(Obj != VaeData[playerid][obj])
				{
					VaeData[playerid][OffSetX]  = 0.0;
					VaeData[playerid][OffSetY]  = 0.0;
					VaeData[playerid][OffSetZ]  = 0.0;
					VaeData[playerid][OffSetRX] = 0.0;
					VaeData[playerid][OffSetRY] = 0.0;
					VaeData[playerid][OffSetRZ] = 0.0;
				}	
				VaeData[playerid][obj] = Obj;
				TogglePlayerControllable(playerid, false);
				SetPVarInt(playerid,"freezed",1);
				SetPVarInt(playerid, "VaeEdit",1);
				ShowPlayerMenu(playerid, DIALOG_VAE);
				GameTextForPlayer(playerid,"~w~HOLD ENTER~n~to open edit menu",5000,1);
			}
		} 
	}
	if(dialogid == DIALOG_GAMETEXTSTYLE)
	{
		if(response)
		{
			if(listitem == 2)
			{
				SendClientMessageEx(playerid, -1,
				"����� �������� ����� ������", "the text will disappear after death");
			}
			SetSVarInt("gametextstyle", listitem);
			ShowPlayerDialog(playerid, DIALOG_GAMETEXTTEST, DIALOG_STYLE_INPUT,
			"Gametext",
			"{FFFFFF}~n~New line -k- Keycode\n"\
			"{FF0000}~r~Red {008000}~g~Green {000080}~b~Blue \
			{FFFFFF}~w~White {FFFF00}~y~Yellow {262626}~l~black\n"\
			"{FFFFFF}Enter text to test", "OK","Cancel");
		}
	}
	if(dialogid == DIALOG_GAMETEXTTEST)
	{
		if(response)
		{
			if(!isnull(inputtext))
			{
				GameTextForPlayer(playerid, inputtext, 5000, GetSVarInt("gametextstyle"));
			}
		}
	}
	// lastdialog last dialog
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	// show aim pointer on flymode
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_SPECTATING)
	{
		if(aimPoint && GetPVarInt(playerid,"hud") != 0) 
		{
			PlayerTextDrawShow(playerid, TDAIM[playerid]);
		}
	}
	// hide aim pointer on flymode
	if(oldstate == PLAYER_STATE_SPECTATING)
	{
		PlayerTextDrawHide(playerid, TDAIM[playerid]);
	}
	// By analogy with the Texture studio, it removes transport on player exit
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
		if(removePlayerVehicleOnExit){
			if(PlayerVehicle[playerid] != 0) DestroyVehicle(PlayerVehicle[playerid]);
		}
		if(Vehcam[playerid] != 0) { 
			DestroyObject(Vehcam[playerid]);
			SetCameraBehindPlayer(playerid);
		}
	}
	return 1;
}

public OnScriptUpdate()
{
	// used to optimize some functions instead of  OnPlayerUpdate
	// OnScriptUpdate - interval: 500 ms
	foreach(new i : Player)
	{
		if(useAutoFixveh)
		{
			RepairVehicle(GetPlayerVehicleID(i));
		}
		// Show streamed objects
		if (streamedObjectsTD && IsPlayerSpawned(i) && GetPVarInt(i,"hud") != 0)
		{
			new streamedObjects[30];
			format(streamedObjects,sizeof(streamedObjects),"streamed objects: %i/1000", Streamer_CountVisibleItems(i, STREAMER_OBJECT_TYPE_GLOBAL, 1));
			PlayerTextDrawSetString(i, Objrate[i], streamedObjects);
		}
		// Drunk mode
		if(GetPVarInt(i, "drunk") > 0)
		{
			SetPlayerDrunkLevel(i, GetPVarInt(i, "drunk"));
		}
	}
	return 1;
}	

public OnPlayerUpdate(playerid)
{
	new tdtext[1024], string[128];
	
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && targetInfo) 
	{
		new objectid = GetPlayerCameraTargetObject(playerid);
		if(IsValidDynamicObject(objectid))
		{
			new 
				Float: x, Float: y, Float: z,
				Float: ox, Float: oy, Float: oz,
				Float: rx, Float: ry, Float: rz,
				Float: distance, objinfo[200]
			;
			GetDynamicObjectPos(objectid, ox, oy, oz);
			GetDynamicObjectRot(objectid, rx, ry, rz);
			GetPlayerPos(playerid, x,y,z);
			#if defined _new_streamer_included
			Streamer_GetDistanceToItem(x,y,z,STREAMER_TYPE_OBJECT,objectid,distance,3);
			#else
			Streamer_GetDistanceToItem(x,y,z,STREAMER_TYPE_OBJECT,objectid,distance);	
			#endif
			format(objinfo, sizeof(objinfo), "~n~~n~~w~modelid: %i distance: %.2f~n~"\
			"x:%.3f y:%.3f z:%.3f rx:%.3f ry:%.3f rz:%.3f",
			GetDynamicObjectModel(objectid),distance, ox, oy, oz, rx, ry, rz);
			GameTextForPlayer(playerid,objinfo,10000,5);
		}
		new vehicleid = GetPlayerCameraTargetVehicle(playerid);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			new 
				Float: x, Float: y, Float: z,
				Float: rx, Float:ry, Float: rz,
				vehinfo[200]
			;
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleRotation(vehicleid, rx, ry, rz);
			format(vehinfo, sizeof(vehinfo), "~n~~n~~w~modelid: %i~n~"\
			"x:%.3f y:%.3f z:%.3f rx:%.3f ry:%.3f rz:%.3f",
			GetVehicleModel(vehicleid), x, y, z, rx, ry, rz);
			GameTextForPlayer(playerid,vehinfo,10000,5);
		}
	}
	
	if (fpsBarTD)
	{
		GetPlayerFPS(playerid);
		new fpsbardata[256];
		//PlayerTextDrawColor(playerid, FPSBAR[playerid], 0xFFFFFFFF);
		if(GetPVarInt(playerid, "fps") < 550 && GetPVarInt(playerid, "fps") > 20)
		{
			format(fpsbardata,sizeof(fpsbardata),"FPS: %.0f",floatabs(GetPVarInt(playerid, "fps")));
			PlayerTextDrawSetString(playerid, FPSBAR[playerid], fpsbardata);
		}
	}
		
	if (GetPVarInt(playerid, "specbar") != -1 && IsPlayerConnected(GetPVarInt(playerid,"specbar")))
	{
		new specid = GetPVarInt(playerid, "specbar");
		format(string, sizeof(string), "[~w~DEBUG] ~r~M~w~tools v~r~%s~n~", VERSION);
		strcat(tdtext, string);	
		
		new Float: health, Float: armour;
		GetPlayerHealth(specid, health);
		GetPlayerArmour(specid, armour);
		//format(string, sizeof(string), "~r~HP = %.1f ~h~~b~Armour = %.1f~n~", health, armour);
		format(string, sizeof(string), "~r~HP = %.1f ~h~~b~Armour = %.1f ~w~FPS:~r~%.0f ~w~Ping:~r~%d ~w~P.Loss:~r~%.1f~n~",
		health, armour,floatabs(GetPVarInt(specid, "fps")),GetPlayerPing(specid),GetPVarFloat(specid, "ploss"));
		strcat(tdtext, string);			

		new newstate[36];
		switch(GetPlayerState(specid))
		{
			case 0: format(newstate, sizeof(newstate), "PLAYER_STATE_NONE");
			case 1:	format(newstate, sizeof(newstate), "PLAYER_STATE_ONFOOT");
			case 2:	format(newstate, sizeof(newstate), "PLAYER_STATE_DRIVER");
			case 3:	format(newstate, sizeof(newstate), "PLAYER_STATE_PASSENGER");
			case 4:	format(newstate, sizeof(newstate), "PLAYER_STATE_EXIT_VEHICLE");
			case 5:	format(newstate, sizeof(newstate), "PLAYER_STATE_ENTER_VEHICLE_DRIVER");
			case 6:	format(newstate, sizeof(newstate), "PLAYER_STATE_ENTER_VEHICLE_PASSENGER");	
			case 7:	format(newstate, sizeof(newstate), "PLAYER_STATE_WASTED");
			case 8:	format(newstate, sizeof(newstate), "PLAYER_STATE_SPAWNED");
			case 9:	format(newstate, sizeof(newstate), "PLAYER_STATE_SPECTATING");
			default: format(newstate, sizeof(newstate), "PLAYER_STATE_NONE");
		}
		
		format(string, sizeof(string), "~w~Skin ~r~%d~w~ ~w~AnimIndex ~r~%d~w~ %s ~n~", 
		GetPlayerSkin(specid),GetPlayerAnimationIndex(specid), newstate);
		strcat(tdtext, string);
		
		format(string, sizeof(string), "~w~Freezed ~r~%d ~w~world ~r~%d~w~ interior ~r~%d~n~", GetPVarInt(specid, "frz"),GetPlayerVirtualWorld(specid), GetPlayerInterior(specid));
		strcat(tdtext, string);	
					
		format(string, sizeof(string), "~w~FlyMode ~r~%d ~w~Specing ~r~%d ~w~Player speed ~r~%d~n~", GetPVarInt(specid, "FlyMode"), GetPVarInt(specid, "Specing"), GetPlayerSpeed(specid));
		strcat(tdtext, string);			
		
		format(string, sizeof(string), "~w~Streamed Players ~r~%d~w~ Vehicles ~r~%d~w~~n~", 
		GetPVarInt(specid, "StreamedPlayers"),GetPVarInt(specid, "StreamedVehicles"));
		strcat(tdtext, string);	
		
		format(string, sizeof(string), "~w~PlayerCameraMode ~r~%i~w~ ~n~", 
		GetPlayerCameraMode(playerid));
		strcat(tdtext, string);
		
		PlayerTextDrawSetString(playerid, TDspecbar[playerid],tdtext);
	}
}

public OnFilterScriptExit()
{
	/*new query[128];
	format(query,sizeof(query),
	"UPDATE `Settings` SET Value=%d, WHERE Option='Language'", LangSet);
	db_query(mtoolsDB,query);*/
	db_close(mtoolsDB);
	// vae
	for(new i = 0; i < MAX_PLAYERS; ++i) DestroyObject(VaeData[i][obj]);
	return 1;
}

//================================== [MENU] ====================================
public ShowPlayerMenu(playerid, dialogid)
{
	// Used for frequently called dialogues
	// dialogid == dialogid from function OnDialogResponse
	switch(dialogid)
	{
		case DIALOG_MAIN:
		{
			new tbtext[500];
			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"[>] Edit\n"\
				"{A9A9A9}[>] Create\n"\
				"[>] Remove\n"\
				"{A9A9A9}[>] Textures\n"\
				"[>] Map manage\n"\
				"{A9A9A9}[>] Vehicles\n"\
				"[>] Cam mode\n"\
				"{A9A9A9}[>] Etc\n"\
				"[>] Settings\n"\
				"{A9A9A9}[>] Information\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"[>] �������������\n"\
				"{A9A9A9}[>] �������\n"\
				"[>] �������\n"\
				"{A9A9A9}[>] ��������\n"\
				"[>] ���������� ������\n"\
				"{A9A9A9}[>] ���������\n"\
				"[>] ����� ������\n"\
				"{A9A9A9}[>] ������\n"\
				"[>] ���������\n"\
				"{A9A9A9}[>] ����������\n");
			}
			ShowPlayerDialog(playerid, DIALOG_MAIN, DIALOG_STYLE_LIST,
			"{FF0000}M{FFFFFF}TOOLS",tbtext,">>>","");
		}
		case DIALOG_INFOMENU:
		{
			new tbtext[150];
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"������� mtools\n"\
				"������� TextureStudio\n"\
				"���������� � ������� �������\n"\
				"Credits\n"\
				"� mtools\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"Commands mtools\n"\
				"Commands TextureStudio\n"\
				"Controls and hotkeys\n"\
				"Credits\n"\
				"About mtools\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_INFOMENU, DIALOG_STYLE_LIST,
			"[INFO]",tbtext, "OK","Cancel");
		}
		case DIALOG_ETC:
		{
			// todo "��������� ����� �� ������� ���������� ��������\t\n"
			new tbtext[550];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				" \t \n"\
				"[>] ��������� ����������\t\n"\
				"�������� ������\t{00FF00}/jump\n"\
				"Surfly mode\t{00FF00}/surfly\n"\
				"����� �������\t{FFFF00}/jetpack\n"\
				"����������������� � ����������� ��������\t{FFFF00}/gotoint\n"\
				"�������� ��� ������������ ��������\t\n"\
				"�������������� ID ����� �� ����\t\n"\
				"������� Gametext\t\n");
			} else {
				format(tbtext, sizeof(tbtext),
				" \t \n"\
				"[>] Save coords\t\n"\
				"Jump forward\t{00FF00}/jump\n"\
				"Surfly mode\t{00FF00}/surfly\n"\
				"Take a jetpack\t{FFFF00}/jetpack\n"\
				"Teleport to standard interior\t{FFFF00}/gotoint\n"\
				"Update All Dynamic Elements\t\n"\
				"Test sound ID from game\t\n"\
				"Gametext\t\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_ETC, DIALOG_STYLE_TABLIST_HEADERS,
			"[ETC]",tbtext,"OK","Close");
		}
		case DIALOG_CREATEMENU:
		{
			new tbtext[400];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"{A9A9A9}[>] ������\n"\
				"[>] 3D �����\n"\
				"{A9A9A9}[>] �����\n"\
				"[>] Pickup\n"\
				"{A9A9A9}[>] Attach � ������\n"\
				"[>] Attach �� ���������\n"\
				"{A9A9A9}[>] ������\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"{A9A9A9}[>] Object\n"\
				"[>] 3D text\n"\
				"{A9A9A9}[>]  Text object\n"\
				"[>] Pickup\n"\
				"{A9A9A9}[>] Attach to Player\n"\
				"[>] Attach to Vehicle\n"\
				"{A9A9A9}[>] Actor\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_CREATEMENU, DIALOG_STYLE_LIST,
			"[CREATE]",tbtext, "OK","Cancel");
		}
		case DIALOG_EDITMENU:
		{
			new header[64];
			if(EDIT_OBJECT_MODELID[playerid] > 0)
			{
				format(header, sizeof header, "[EDIT] iternalid:%i model:%i",
				EDIT_OBJECT_ID[playerid], EDIT_OBJECT_MODELID[playerid]);
			} else {
				format(header, sizeof header, "[EDIT]");
			}
			
			new tbtext[600];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"��������\t�������\n"\
				"������� ������\t{00FF00}/csel\n"\
				"����������� ������\t{00FF00}/editobject\n"\
				"��������� ������ ��\t{00FF00}/rot\n"\
				"������� ������ ������� �����\t{00FF00}/scsel\n"\
				"���������� ������\t{00FF00}/clone\n"\
				"�������� ������� ������� �� ��������\t{00FF00}/rotreset\n"\
				"������� ������\t{00FF00}/dobject\n"\
				"���������� � ������� ������e\t{00FF00}/oprop\n"\
				"���������� � ������ �������\t{00FF00}/minfo\n"\
				"���������� ������� �����\t{00FF00}/pivot\n"\
				"[>] ���������\t\n"\
				"[>] �������������� ������\t\n"\
				"{00FF00}<<<{FFFFFF} ������ ���������� ��������\t{00FF00}/undo\n"\
				"{00FF00}>>>{FFFFFF} ������� ����������� ��������\t{00FF00}/redo\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"Description\tCommand\n"\
				"Select object\t{00FF00}/csel\n"\
				"Move object\t{00FF00}/editobject\n"\
				"Rotate object by\t{00FF00}/rot\n"\ 
				"Select a nearby object\t{00FF00}/scsel\n"\
				"Copy object\t{00FF00}/clone\n"\
				"Rotation reset\t{00FF00}/rotreset\n"\
				"Delete object\t{00FF00}/dobject\n"\
				"Information about the current object\t{00FF00}/oprop\n"\
				"Object model information\t{00FF00}/minfo\n"\
				"Set anchor point\t{00FF00}/pivot\n"\
				"[>] Textures edit\t\n"\
				"[>] Groups edit\t\n"\
				"{00FF00}<<<{FFFFFF} Undo the last action\t{00FF00}/undo\n"\
				"{00FF00}>>>{FFFFFF} Reverting the previous action\t{00FF00}/redo\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_EDITMENU, DIALOG_STYLE_TABLIST_HEADERS, 
			header ,tbtext, "OK","Cancel");
		}
		case DIALOG_GROUPEDIT:
		{
			new tbtext[500];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"��������\t�������\n"\
				"����������/�������� ������� �� ������\t{00FF00}/gsel\n"\
				"���������� ������������� ������\t{00FF00}/setgroup\n"\
				"������������� ��� �������\t{00FF00}/selectgroup\n"\
				"���������� ������� ������� ��������� � ������\t{00FF00}/gclone\n"\
				"������� ��� ������� �� ������\t{00FF00}/gclear\n"\
				"������� ������� ������� ��������� � ������\t{00FF00}/gdelete\n"\
				"�������� objectmetry ������\t{00FF00}/obmedit\n");
				
			} else {
				format(tbtext, sizeof(tbtext),
				"Description\tCommand\n"\
				"Adding/removing an object from the group\t{00FF00}/gsel\n"\
				"Set group id \t{00FF00}/setgroup\n"\
				"Group all objects \t{00FF00}/selectgroup\n"\
				"Copy objects that are in the group\t{00FF00}/gclone\n"\
				"Remove all objects from the group\t{00FF00}/gclear\n"\
				"Delete objects that are in the group\t{00FF00}/gdelete\n"\
				"Creating an objectmetry figure\t{00FF00}/obmedit\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_GROUPEDIT, DIALOG_STYLE_TABLIST_HEADERS,
			"[GROUP]",tbtext, "OK","Cancel");
		}
		case DIALOG_REMMENU:
		{
			new tbtext[500];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"��������\t�������\n"\
				"������� ������� ������\t{FF0000}/dobject\n"\
				"������� ��������� ������\t{FF0000}/dcsel\n"\
				"������� ������� � �������\t{FF0000}/rangedel\n"\
				"������� ����������� ������\t{FF0000}/remobject\n"\
				"������ ������\t\n"\
				"<<< ������� ��������� ������\t{FFFF00}/undo\n"\
				"������� ��������� ����� mtools\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"Description\tCommand\n"\
				"Delete current object\t{FF0000}/dobject\n"\
				"Delete nearest object\t{FF0000}/dcsel\n"\
				"Remove objects in radius\t{FF0000}/rangedel\n"\
				"Delete default SA object\t{FF0000}/remobject\n"\
				"Hide object\t\n"\
				"<<< Restore deleted object\t{FFFF00}/undo\n"\
				"Delete temporary files mtools\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_REMMENU, DIALOG_STYLE_TABLIST_HEADERS,
			"[REMOVE]",tbtext, "OK","Cancel");
		}
		case DIALOG_TEXTUREMENU:
		{
			new tbtext[550];
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),	
				"��������\t�������\n"\
				"�������� �������\t{00FF00}/mtextures\n"\
				"����������� ��������\t{00FF00}/ttextures\n"\
				"����� �������� �� ����� �����\t{00FF00}/tsearch\n"\
				"�������� �������\t{00FF00}/stexture\n"\
				"�������� ����� �� ������\t{00FF00}/text\n"\
				"����� ��������� � ����� �������\t{00FF00}/mtreset\n"\
				"���������� �������� ������� (��������/����/�����) � �����\t{00FF00}/copy\n"\
				"�������� �������� �� ��������� ������ �� ������\t{00FF00}/paste\n"\
				"�������� �������� ������� �� ������\t{00FF00}/clear\n");
			} else {
				format(tbtext, sizeof(tbtext),	
				"Description\tCommand\n"\
				"Texture manager\t{00FF00}/mtextures\n"\
				"Saved textures\t{00FF00}/ttextures\n"\
				"Find texture by part of name\t{00FF00}/tsearch\n"\
				"Texture editor\t{00FF00}/stexture\n"\
				"Add text to object\t{00FF00}/text\n"\
				"Reset object material and color\t{00FF00}/mtreset\n"\
				"Copy object properties (texture/color/text) to buffer\t{00FF00}/copy\n"\
				"Paste properties on the selected object from the buffer\t{00FF00}/paste\n"\
				"Clear object properties from buffer \t{00FF00}/clear\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_TEXTUREMENU, DIALOG_STYLE_TABLIST_HEADERS,
			"[TEXTURE]",tbtext, "OK","Cancel");
		}
		case DIALOG_CREATEOBJ:
		{
			if (GetPVarInt(playerid, "lang") == 0){
				ShowPlayerDialog(playerid,DIALOG_CREATEOBJ,DIALOG_STYLE_INPUT,
				"������� ������",
				"{FFFFFF}������� ID ������ ������� ��� ���� ����� ��� �������\n"\
				"������ �������� ����� ����, ����� �� ������ �������� ���\n\n"\
				"{FFD700}615-18300 GTASA: 18632-19521 SAMP\n"\
				"{FFFFFF}������ �������� �� ���������� ����� ����������:\n"\
				"�� ����� {00BFFF}https://dev.prineside.com/ru",
				"Create","Close");
			} else {
				ShowPlayerDialog(playerid,DIALOG_CREATEOBJ,DIALOG_STYLE_INPUT,
				"Create object",
				"{FFFFFF} Enter the model ID of the object to create it \n"\
				"The object will appear in front of you, then you will modify it\n\n"\
				"{FFD700} 615-18300 GTASA: 18632-19521 SAMP\n"\
				"{FFFFFF} The list of objects by category can be viewed:\n"\
				"on the site {00BFFF} https://dev.prineside.com/ru",
				"Create","Close");
			}
		}
		case DIALOG_SOUNDTEST:
		{
			new tbtext[600] =
			"{FFFFFF}SOUND_BONNET_DENT 1009 \t\t SOUND_WHEEL_OF_FORTUNE_CLACKER 1027 \n"\
			"SOUND_AMMUNATION_BUY_WEAPON 1052 \t SOUND_AMMUNATION_BUY_WEAPON_DENIED 1053\n" \
			"SOUND_SHOP_BUY 1054 \t\t SOUND_SHOP_BUY_DENIED 1055\n"\
			"SOUND_RACE_321 1056 \t\t SOUND_RACE_GO 1057\n"\ 
			"SOUND_PART_MISSION_COMPLETE 1058 \t SOUND_PUNCH_PED 1130\n"\ 
			"SOUND_CAMERA_SHOT 1132 \t\t SOUND_BUY_CAR_MOD 1133 \n"\
			"SOUND_BUY_CAR_RESPRAY 1134 \t SOUND_CHECKPOINT_AMBER 1137 \n"\
			"SOUND_CHECKPOINT_GREEN 1138	\t SOUND_CHECKPOINT_RED 1139 \n"\
			"SOUND_PROPERTY_PURCHASED 1149 \t SOUND_PICKUP_STANDARD 1150\n"\
			"\nEnter sound ID:\n";
			
			ShowPlayerDialog(playerid, DIALOG_SOUNDTEST, DIALOG_STYLE_INPUT, "Soundtest",
			tbtext, "Play", "Stop");
		}
		case DIALOG_ACTORS:
		{
			new tbtext[300];
			
			new header[64];
			if(indexActor > -1)
			{
				format(header, sizeof header, "[ACTORS] actorindex: %i", indexActor);
			} else {
				format(header, sizeof header, "[ACTORS]");
			}
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"{FFFFFF}������� ������ � ������� ����\n"\
				"������� ������\n"\
				"��������� ��������\n"\
				"������� ������ �����������\n"\
				"����������� ������\n"\
				"��������� ������ ����� � ������\n"\
				"{FF0000}������� ������\n");
				//"{FFFFFF}[>] ������� ��������\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"{FFFFFF}Create actor and set skin\n"\
				"Change actor index\n"\
				"Set animation\n"\
				"Set actor invulnerable\n"\
				"Move actor\n"\
				"Rotate the actor to face the player\n"\
				"{FF0000}Remove actor\n");
				//"{FFFFFF}[>] Create crowd\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_ACTORS, DIALOG_STYLE_LIST,
			header, tbtext, "OK","Cancel");
		}
		case DIALOG_3DTEXTMENU:
		{
			new tbtext[450];
			if(GetPVarInt(playerid, "lang") == 0)
			{	
				format(tbtext, sizeof(tbtext),
				"��������\t�������\n"\
				"������� 3DText\t\n"\
				"������\t%i\n"\
				"�������� �����\t%s\n"\
				"�������� ����\t\n"\
				"�������� ���������\t%.1f\n"\
				"�������� �������\t\n"\
				"{FF0000}������� 3Dtext\t\n"\
				"�������������� � filterscript\t\n",
				CurrentIndex3dText, 
				Text3dArray[CurrentIndex3dText][Text3Dvalue],
				Text3dArray[CurrentIndex3dText][Text3Dcolor],
				Text3dArray[CurrentIndex3dText][Text3Ddistance]
				);
			} else {
				format(tbtext, sizeof(tbtext),
				"Action\tCommand\n"\
				"Create 3DText\t\n"\
				"Index\t%i\n"\
				"Change text\t%s\n"\
				"Change color\t\n"\
				"Change distance\t%.1f\n"\
				"Change Position\t\n"\
				"{FF0000}Delete 3Dtext\t\n"\
				"Export to filterscript\t\n",
				CurrentIndex3dText, 
				Text3dArray[CurrentIndex3dText][Text3Dvalue],
				Text3dArray[CurrentIndex3dText][Text3Dcolor],
				Text3dArray[CurrentIndex3dText][Text3Ddistance]);
			}
			ShowPlayerDialog(playerid, DIALOG_3DTEXTMENU, DIALOG_STYLE_TABLIST_HEADERS,
			"[3D TEXT]",tbtext, "OK","Cancel");
		}
		case DIALOG_VEHICLE:
		{
			new tbtext[450];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"��������\t�������\n"\
				"�������� ����������\t{00FF00}/v\n"\
				"������� ����� ������\t{00FF00}/avnewcar\n"\
				"������� ������ ��� ��������������\t{00FF00}/avsel\n"\
				"���������� ������\t{00FF00}/avclonecar\n"\
				"������� ������\t{00FF00}/avdeletecar\n"\
				"���������� ����� ������\t{00FF00}/avsetspawn\n"\
				"������� ��������� ������\t{00FF00}/avexport\n"\
				"[>] ������\t\n"\
				"[>] ����������� �����������\t\n"\
				"[>] ���������\t\n");
			} else {
				format(tbtext, sizeof(tbtext),
				"Action\tCommand\n"\
				"Test vehicle\t{00FF00}/v\n"\
				"Create new vehicle\t{00FF00}/avnewcar\n"\
				"Select vehicle\t{00FF00}/avsel\n"\
				"Clone vehicle\t{00FF00}/avclonecar\n"\
				"Delete vehicle\t{00FF00}/avdeletecar\n"\
				"Set spawn place\t{00FF00}/avsetspawn\n"\
				"Export selected vehicle\t{00FF00}/avexport\n"\
				"[>] Tuning\t\n"\
				"[>] Special abilities\t\n"\
				"[>] Settings\t\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS,
			"[VEHICLE]",tbtext, "OK","Cancel");
		}
		case DIALOG_MAPMENU:
		{
			new tbtext[500];
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),	
				"��������\t�������\n"\
				"��������� �����\t{00FF00}/loadmap\n"\
				"������� �����\t{00FF00}/newmap\n"\
				"������������� �����\t{00FF00}/renamemap\n"\
				"������ ����� ������\t{00FF00}/setspawn\n"\
				"������������� ������� �� �����\t{00FF00}/importmap\n"\
				"�������������� �����\t{00FF00}/export\n"\
				"�������������� ���� ���������\t{00FF00}/avexportall\n"\
				"�������� ����������� ������� �� �����\t{00FF00}/gtaobjects\n"\
				"�������� mapicon �� �����\t\n"\
				"������\t\n"\
				"{FF0000}������� �����\t{FF0000}/deletemap\n");
			} else {
				format(tbtext, sizeof(tbtext),	
				"Action\tCommand\n"\
				"Load map\t{00FF00}/loadmap\n"\
				"New map\t{00FF00}/newmap\n"\
				"Rename map\t{00FF00}/renamemap\n"\
				"Set spawn point\t{00FF00}/setspawn\n"\
				"Import object from file\t{00FF00}/importmap\n"\
				"Export map\t{00FF00}/export\n"\
				"Export all vehicles\t{00FF00}/avexportall\n"\
				"Show default objects on map\t{00FF00}/gtaobjects\n"\
				"Add mapicon\t\n"\
				"Limits\t\n"\
				"{FF0000}Delete map\t{FF0000}/deletemap\n");
			}
			
			ShowPlayerDialog(playerid, DIALOG_MAPMENU, DIALOG_STYLE_TABLIST_HEADERS,
			"[MAP]",tbtext, "OK","Cancel");
		}
		case DIALOG_MAPINFO:
		{
			new dir:dHandle = dir_open("./scriptfiles/tstudio/SavedMaps/");
			new tbtext[450], buf[20], item[40], type;
			format(tbtext, sizeof tbtext, "{FFFFFF}");
			
			while(dir_list(dHandle, item, type))
			{
				if(type == FM_FILE) 
				{
					format(buf, sizeof buf, "%s\n", item);
					strcat(tbtext, buf);
				}
			}
			dir_close(dHandle);
			
			ShowPlayerDialog(playerid, DIALOG_MAPINFO, DIALOG_STYLE_LIST,
			"[MAP INFO]", tbtext, "Select","Cancel");
		}
		case DIALOG_CAMSET:
		{
			new tbtext[500];
			new Firstperson_st[16];
			
			if(GetPVarInt(playerid,"Firstperson") == 1)
			Firstperson_st = "{00FF00}[ON]"; else Firstperson_st = "{FF0000}[OFF]";
			
			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"Option\tState\n"\
				"Flycam\t{FFFF00}/flymode\n"\
				"First person cam\t%s\n"\
				"Take a photocamera\t{FFFF00}/camera\n"\
				"Hide all textdraws\t{FFFF00}/hud\n"\
				"[>] Camera position\t\n"\
				"[>] Camera speed\t\n"\
				"[>] Interpolate camera\t\n"\
				"[>] Environment and effects\t\n",
				Firstperson_st);
			} else {
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"����� �������\t{FFFF00}/flymode\n"\
				"��� �� ������� ����\t%s\n"\
				"����� �����������\t{FFFF00}/camera\n"\
				"�������� ��� ����������\t{FFFF00}/hud\n"\
				"[>] ������� ������\t\n"\
				"[>] �������� ����������� ������\t\n"\
				"[>] ������������ ������\t\n"\
				"[>] ��������� � �������\t\n",
				Firstperson_st);
			}
			
			ShowPlayerDialog(playerid, DIALOG_CAMSET, DIALOG_STYLE_TABLIST_HEADERS,
			"[CAMSET]",tbtext, "OK","Cancel");
		}
		case DIALOG_SETTINGS:
		{
			new tbtext[500];
			new 
				Lang_st[48]
			;
			
			if(GetPVarInt(playerid,"lang") == 1) 
			Lang_st = "{ffffff}[English]"; else Lang_st = "{ffffff}[Ru{3A5FCD}ssi{ff0000}an]";

			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"Option\tState\n"\
				"[>] Interface\t\n"\
				"{A9A9A9}[>] Keybinds\t\n"\
				"[>] Vehicles settings\t\n"\
				"Language\t%s\n"\
				"Change skin\t{00FF00}%i\n"\
				"Set Weather\t{00FF00}%i\n"\
				"Set Time\t{00FF00}%i\n"\
				"Set Gravity\t{00FF00}%.3f\n",
				Lang_st, GetPlayerSkin(playerid), GetPVarInt(playerid,"Weather"),
				GetPVarInt(playerid,"Hour"), GetGravity());
			} else {
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"[>] ���������\t\n"\
				"{A9A9A9}[>] ������� �������\t\n"\
				"[>] ��������� ����������\t\n"\
				"����\t%s\n"\
				"������� ����\t{00FF00}%i\n"\
				"���������� ������\t{00FF00}%i\n"\
				"���������� �����\t{00FF00}%i\n"\
				"���������� ����������\t{00FF00}%.3f\n",
				Lang_st, GetPlayerSkin(playerid), GetPVarInt(playerid,"Weather"),
				GetPVarInt(playerid,"Hour"), GetGravity());
			}
			ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS,
			"[SETTINGS]",tbtext, "Select","Cancel");
		}
		case DIALOG_KEYBINDS:
		{
			new tbtext[500];
			new 
				SuperJump_st[16], 
				bindFkeyToFlymode_st[16], mainMenuKeyCode_st[16]
			;
			
			if(superJump) 
			SuperJump_st = "{00FF00}[ON]"; else SuperJump_st = "{FF0000}[OFF]";
			if(bindFkeyToFlymode)
			bindFkeyToFlymode_st = "{00FF00}[ON]"; else bindFkeyToFlymode_st = "{FF0000}[OFF]";
			switch(mainMenuKeyCode)
			{
				case 1024: mainMenuKeyCode_st = "{00FF00}< ALT >";
				case 65536: mainMenuKeyCode_st = "{00FF00}< Y >";
				case 131072: mainMenuKeyCode_st = "{00FF00}< N >";
				case 262144: mainMenuKeyCode_st = "{00FF00}< H >";
			}
			
			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"Option\tState\n"\
				"Flymode mode at <F>\t%s\n"\
				"Main menu hotkey\t%s\n"\
				"SuperJump\t%s\n",
				bindFkeyToFlymode_st, mainMenuKeyCode_st, SuperJump_st);
			} else {
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"����� ������ �� <F>\t%s\n"\
				"����� �������� ���� �� �������\t%s\n"\
				"C���� ������\t%s\n",
				bindFkeyToFlymode_st, mainMenuKeyCode_st, SuperJump_st);
			}
			
			ShowPlayerDialog(playerid, DIALOG_KEYBINDS, DIALOG_STYLE_TABLIST_HEADERS,
			"Keybinds",tbtext, "Select","Cancel");
		}
		case DIALOG_INTERFACE_SETTINGS:
		{
			new tbtext[650];
			new 
				StreamedObjectsTD_st[16], AIMTD_st[16],
				TargetInfo_st[16], fpsBarTD_st[16],
				autoLoadMap_st[16], showEditMenu_st[16]
			;
			
			if(streamedObjectsTD) 
			StreamedObjectsTD_st = "{00FF00}[ON]"; else StreamedObjectsTD_st = "{FF0000}[OFF]";
			if(aimPoint) 
			AIMTD_st = "{00FF00}[ON]"; else AIMTD_st = "{FF0000}[OFF]";
			if(fpsBarTD) 
			fpsBarTD_st = "{00FF00}[ON]"; else fpsBarTD_st = "{FF0000}[OFF]";
			if(targetInfo) 
			TargetInfo_st = "{00FF00}[ON]"; else TargetInfo_st = "{FF0000}[OFF]";
			if(autoLoadMap)
			autoLoadMap_st = "{00FF00}[ON]"; else autoLoadMap_st = "{FF0000}[OFF]";
			if(showEditMenu)
			showEditMenu_st = "{00FF00}[ON]"; else showEditMenu_st = "{FF0000}[OFF]";
		
			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"Option\tState\n"\
				"Streamed objects counter TD\t%s\n"\
				"Information about the current position\t(/position)\n"\
				"Editor 3dtext settings\t(/edittext3d)\n"\
				"Show 3d text on objects\t/objtext3d\n"\
				"Point in the center of the screen in flight\t%s\n"\
				"Information about objects and vehicles in flymode\t%s\n"\
				"Show FPS over the radar\t%s\n"\
				"Show map loading window at login\t%s\n"\
				"Show EditMenu when editing object\t%s\n",
				StreamedObjectsTD_st,AIMTD_st,TargetInfo_st,
				fpsBarTD_st, autoLoadMap_st, showEditMenu_st);
			} else {
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"TD �������� �������� � ������� ������\t%s\n"\
				"���������� � ������� �������\t/position\n"\
				"��������� 3d ������ �� ��������\t/edittext3d\n"\
				"���������� 3d ����� �� ��������\t/objtext3d\n"\
				"����� �� ������ ������ � ������\t%s\n"\
				"���������� � �������� � ���������� � ������ ������\t%s\n"\
				"���������� FPS ��� �������\t%s\n"\
				"���������� ���� �������� ����� ��� �����\t%s\n"\
				"���������� EditMenu ��� �������������� �������\t%s\n",
				StreamedObjectsTD_st,AIMTD_st,TargetInfo_st,
				fpsBarTD_st, autoLoadMap_st, showEditMenu_st);
			}
			
			ShowPlayerDialog(playerid, DIALOG_INTERFACE_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "[SETTINGS - Interface]",tbtext, "Select","Cancel");
		}
		case DIALOG_VEHSETTINGS:
		{
			new //menu states
				tbtext[550], useNOS_st[18], useAutoFixveh_st[18],
				useBoost_st[18], vecol_st[18], useAutoTune_st[18],
				useFlip_st[18], autoremveh_st[18]
			;
			
			if(useBoost) useBoost_st = "{00FF00}[ON]";
			else useBoost_st = "{FF0000}[OFF]";
			
			if(useNOS) useNOS_st = "{00FF00}[ON]";
			else useNOS_st = "{FF0000}[OFF]";
			
			if(useAutoFixveh) useAutoFixveh_st = "{00FF00}[ON]";
			else useAutoFixveh_st = "{FF0000}[OFF]";
			
			if(useAutoTune) useAutoTune_st = "{00FF00}[ON]";
			else useAutoTune_st = "{FF0000}[OFF]";
			
			if(useFlip) useFlip_st = "{00FF00}[ON]";
			else useFlip_st = "{FF0000}[OFF]";
			
			if(removePlayerVehicleOnExit) autoremveh_st = "{00FF00}[ON]";
			else autoremveh_st = "{FF0000}[OFF]";
			
			if(vehCollision) 
			vecol_st = "{00FF00}[ON]"; else vecol_st = "{FF0000}[OFF]";
			
			if(GetPVarInt(playerid, "lang") == 0)
			{		
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"Speed Boost\t%s\n"\
				"������������� Nos\t%s\n"\
				"�����������\t%s\n"\
				"���������� (������� 2)\t%s\n"\
				"��������� ��������� �� ������ (������� H)\t%s\n"\
				"�������� ����������\t%s\n"\
				"������� ��������� ������ ��� ������ �� ������\t%s\n",
				useBoost_st, useNOS_st, useAutoFixveh_st, useAutoTune_st,
				useFlip_st, vecol_st, autoremveh_st);
			} else {
				format(tbtext, sizeof(tbtext),
				"Option\tCommand\n"\
				"Speed Boost\t%s\n"\
				"Autorefill Nos\t%s\n"\
				"Autofix\t%s\n"\
				"Auto Tuning (Key 2)\t%s\n"\
				"Put transport on wheels (Key H)\t%s\n"\
				"Vehicle Collision\t%s\n"\
				"Remove player vehice on exit\t%s\n",
				useBoost_st, useNOS_st, useAutoFixveh_st, useAutoTune_st,
				useFlip_st, vecol_st, autoremveh_st);
			}
			
			ShowPlayerDialog(playerid, DIALOG_VEHSETTINGS, DIALOG_STYLE_TABLIST_HEADERS, 
			"[VEHICLE - Settings]",tbtext, "OK","Cancel");
		}
		case DIALOG_ROTATION:
		{
			ShowPlayerDialog(playerid, DIALOG_ROTATION, DIALOG_STYLE_LIST,
			"[EDIT - Rotate]",
			"Rx 90\nRy 90\nRz 90\nRx 180\nRy 180\nRz 180\n{FF0000}/rotreset",
			"OK","Cancel");
		}
		case DIALOG_VAE:
		{
			new tbtext[500];
			new header[64];
			
			if(VaeData[playerid][objmodel] != -1)
			{
				format(header, sizeof(header),"[VAE] - Vehicle Attachments Editor - modelid: %i",
				VaeData[playerid][objmodel]);
			}
			else format(header, sizeof(header),"[VAE] - Vehicle Attachments Editor");
			
			if(GetPVarInt(playerid, "lang") == 1)
			{		
				format(tbtext, sizeof(tbtext),
				"Option\tState\n"\
				"Change model\t{00FF00}/vaemodel\n"\
				"adjustment X\t%.2f\n"\
				"adjustment Y\t%.2f\n"\
				"adjustment Z\t%.2f\n"\
				"adjustment RX\t%.2f\n"\
				"adjustment RY\t%.2f\n"\
				"adjustment RZ\t%.2f\n"\
				"Freeze-Unfreeze\t{00FF00}/freeze\n"\
				"Stop edit\t{00FF00}/vaestop\n"\
				"Save\t{00FF00}/vaesave\n",
				VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ],
				VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ]);
			} else {
				format(tbtext, sizeof(tbtext),
				"�����\t������\n"\
				"�������� ������\t{00FF00}/vaemodel\n"\
				"����������� ��� X\t%.2f\n"\
				"����������� ��� Y\t%.2f\n"\
				"����������� ��� Z\t%.2f\n"\
				"����������� ��� RX\t%.2f\n"\
				"����������� ��� RY\t%.2f\n"\
				"����������� ��� RZ\t%.2f\n"\
				"����������-�����������\t{00FF00}/freeze\n"\
				"��������� ��������������\t{00FF00}/vaestop\n"\
				"���������\t{00FF00}/vaesave\n",
				VaeData[playerid][OffSetX], VaeData[playerid][OffSetY], VaeData[playerid][OffSetZ],
				VaeData[playerid][OffSetRX], VaeData[playerid][OffSetRY], VaeData[playerid][OffSetRZ]);
			}
			
			ShowPlayerDialog(playerid, DIALOG_VAE, DIALOG_STYLE_TABLIST_HEADERS, 
			header,tbtext, "Select","Cancel");
		}
		case DIALOG_CMDS:
		{
			ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "CMDS", 
			"{FFD700}Basic commands:\n"\
			"{FFFFFF}/time, /weather, /day, /night, /hud\n"\
			"{FFD700}Position commands:\n"\
			"{FFFFFF}/respawn, /freeze, /unfreeze, /cpos, /spos, /lpos\n"\
			"{FFD700}Editor commands:\n"\
			"{FFFFFF}/map, /oadd, /rot [rx] [ry] [rz], /pos [ox] [oy] [oz]\n"\
			"{FFD700}Special commands:\n"\
			"{FFFFFF}/jetpack, fly, /jump, /dive\n"\
			"{FFD700}Vehicle commands:\n"\
			"{FFFFFF}/v, /veh, /vae, /flip, /fix\n"\
			"{FFD700}Camera commands:\n"\
			"{FFFFFF}/cam, /fixcam, /flymode, /slowmo\n"\
			"{FFFFFF}\nPress Y to open Main menu or use: /mtools\n",
			"OK","Cancel");
		}
	}
	return 1;
}

// mselect
#if defined _mselect_included
MSelectCreate:FavObjects(playerid)
{
	MSelect_Open(playerid, MSelect:FavObjects, array_FavObjects, sizeof(array_FavObjects), .rot_z = -45.0, .header = "Favorite");
}

MSelectResponse:FavObjects(playerid, MSelectType:response, itemid, modelid)
{
	if(MSelectType:response == 1 && modelid != -1) CreateDynamicObjectByModelid(playerid,modelid);
	//if(MSelectType:response == 2) ShowPlayerDialog (playerid, DIALOG_OBJLIST, DIALOG_STYLE_LIST, "�������� �������",ObjlistMenu, " > ","�����");
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
        if(!_:clickedid ^ 0xFFFF)
        {
            MSelect_Close(playerid);
        }
        return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) 
{
        if(playertextid == PlayerText:INVALID_TEXT_DRAW)
        {
			MSelect_Close(playerid);
		}
}
#endif

//==================================[STOCKS]====================================
stock GetDirectionInWhichPlayerLooks(playerid, Float:facing_angle = -1.0)
{
    static const
        Float: side_of_the_world = 20.0,//(0.0 - 45.0)
        Float: coord_indent = 0.1;

    new const
        Float: north_coord_min = 360.0-side_of_the_world,
        Float: north_coord_max = 0.0+side_of_the_world,

        Float: west_coord_min = 90.0-side_of_the_world,
        Float: west_coord_max = 90.0+side_of_the_world,

        Float: south_coord_min = 180.0-side_of_the_world,
        Float: south_coord_max = 180.0+side_of_the_world,

        Float: east_coord_min = 280.0-side_of_the_world,
        Float: east_coord_max = 280.0+side_of_the_world;


    if(!floatcmp(facing_angle, -1.0))
        GetPlayerFacingAngle(playerid, facing_angle);
    else if(floatcmp(facing_angle, 0.0) == -1)
        facing_angle = 0.0;
    else if(floatcmp(facing_angle, 360.0) == 1)
        facing_angle = 360.0;

    if(north_coord_min <= facing_angle <= 360.0 || 0.0 <= facing_angle <= north_coord_max)
        return 0;
    else if(north_coord_max+coord_indent <= facing_angle <= west_coord_min-coord_indent)
        return 1;

    else if(west_coord_min <= facing_angle <= west_coord_max)
        return 2;
    else if(west_coord_max+coord_indent <= facing_angle <= south_coord_min-coord_indent)
        return 3;

    else if(south_coord_min <= facing_angle <= south_coord_max)
        return 4;
    else if(south_coord_max+coord_indent <= facing_angle <= east_coord_min-coord_indent)
        return 5;

    else if(east_coord_min <= facing_angle <= east_coord_max)
        return 6;
    else //if(east_coord_max+coord_indent <= facing_angle <= north_coord_min-coord_indent)
        return 7;
}

stock GetClosestDynamicObject(playerid)
{
	new
		Float:px,
		Float:py,
		Float:pz,
		Float:ox,
		Float:oy,
		Float:oz,
		Float:dist,
		Float:check = 99999.9,
		result; 
	GetPlayerPos(playerid, px, py, pz); 
	for(new i; i < Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i++)
	{
		GetDynamicObjectPos(i, ox, oy, oz); 
		dist = floatsqroot(floatpower(floatabs(floatsub(px, ox)), 2) + floatpower(floatabs(floatsub(py, oy)), 2) + floatpower(floatabs(floatsub(pz, oz)), 2)); 
		if(dist < check)
		{
			check = dist;
			result = i;
		}
	}
	return result;
}

stock GetNearestVisibleItem(playerid,type)
{
	// 2019 Abyss Morgan. All rights reserved.
	// Website:  adm.ct8.pl
	// Download: adm.ct8.pl/r/download
	new Float:x, Float:y, Float:z, max_element, tmp_item, itemid = INVALID_STREAMER_ID,
		Float:min_radius = 20000.0, Float:distance, idx_max = 0, idx = 0;
	
	GetPlayerPos(playerid,x,y,z);
	idx_max = Streamer_CountVisibleItems(playerid,type,1);
	switch(type){
		case STREAMER_TYPE_OBJECT, STREAMER_TYPE_PICKUP, STREAMER_TYPE_MAP_ICON, STREAMER_TYPE_3D_TEXT_LABEL: {
			#if defined _new_streamer_included
			max_element = Streamer_GetVisibleItems(type,playerid);
			#else
			max_element = Streamer_GetVisibleItems(type);
			#endif
			while(idx <= max_element && idx_max > 0){
				if((tmp_item = Streamer_GetItemStreamerID(playerid,type,idx)) != INVALID_STREAMER_ID){
					idx_max--;
					Streamer_GetDistanceToItem(x,y,z,type,tmp_item,distance,3);
					if(distance < min_radius){
						itemid = tmp_item;
						min_radius = distance;
					}
				}
				idx++;
			}
		}
		
		default: return INVALID_STREAMER_ID;
	}
	return itemid;
}

//================================END STOCKS====================================

stock mCreatePickup(pickupid, playerid)
{
	new nwPickup[126];
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	#if defined _new_streamer_included
	//CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 100.0);
	CreateDynamicPickup(pickupid, 1, X, Y, Z, -1, GetPlayerInterior(playerid), -1, STREAMER_PICKUP_SD);
	#else
	AddStaticPickup(pickupid, 1, X, Y, Z, -1);
	#endif
	new File:pos3 = fopen("mtools/Pickup.txt", io_append);
	format(nwPickup, sizeof nwPickup, "CreateDynamicPickup(%i, 2, %.2f, %.2f, %.2f, %i, %i, -1, 250, -1, 0);\r\n", pickupid, X, Y, Z, GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
	fwrite(pos3, nwPickup);
	fclose(pos3);
	SendClientMessage(playerid, -1, "Pickup ��� �������� � ����� {FFD700}scriptfiles > mtools > Pickups.txt");
}

stock CreateDynamicObjectByModelid(playerid, modelid)
{
	new Float:playerpos[3];
	GetPlayerPos(playerid, playerpos[0], playerpos[1], playerpos[2]);
	new param[24];
	format(param, sizeof(param), "/cobject %d", modelid);
	#if defined TEXTURE_STUDIO
	CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);
	LAST_OBJECT_ID[playerid] = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT) -1;
	#else
	new objectid = CreateDynamicObject(modelid, playerpos[0]+1, playerpos[1]+1, playerpos[2]+1,
	0.0, 0.0, 0.0, -1, -1, -1, 200.0);
	LAST_OBJECT_ID[playerid] = objectid;
	#endif
	/*
	if(originalcoords){
		id = CreateDynamicObject(modelid, playerpos[0]+1, playerpos[1]+1, playerpos[2]+1, 0.0,0.0,0.0, -1, -1, -1, 100.0);
	} else { 
		//id = CreateDynamicObject(modelid, playerpos[0]+1, playerpos[1]+1, playerpos[2]+3, 0.0,0.0,0.0, -1, -1, -1, 100.0);
		id = CreateDynamicObject(modelid, PX, PY, PZ, RX, RY, RZ, -1, -1, -1, 100.0);
	}
	if(reverse)	SetDynamicObjectRot(id, 0, 0, 180);
	*/
	//if(id > DEF_MAX_OBJECTS) return SendClientMessageToAll(COLOR_WHITE,"������ ��� �������� �������, ����� �������� ��������!");
	
	//EDIT_OBJECT_ID[playerid] = id;
	//LAST_OBJECT_ID[playerid] = id;
	
	//EditDynamicObject(playerid, id);
	//return EDIT_OBJECT_ID[playerid];
}

stock RemoveTempMapEditorFiles(playerid)
{
	// Remove Temp files from mtolls folder
	fremove("mtools/Coords.txt");
	fremove("mtools/MapIcons.txt");
	fremove("mtools/3DText.txt");
	fremove("mtools/Pickup.txt");
	fremove("mtools/Attachments.txt");
	fremove("mtools/Vaeditions.txt");
	SendClientMessageEx(playerid, -1, "��������� ����� �� {FFD700}scriptfiles/mtools{FFFFFF} �������",
	"Temporary files from {FFD700}scriptfiles/mtools{FFFFFF} have been cleared");
}

stock GetPlayerCoords(playerid)
{
	// Send to chat current player position.
	new currentinterior = GetPlayerInterior(playerid);
	new currentworld = GetPlayerVirtualWorld(playerid);
	new coordinfo[144];
	new Float:x,Float:y,Float:z,Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	if (GetPVarInt(playerid, "lang") == 0) {
		format(coordinfo,sizeof(coordinfo),"����������: %f,%f,%f,%f", x, y, z, a);
	} else {
		format(coordinfo,sizeof(coordinfo),"OnFoot position: %f,%f,%f,%f", x, y, z, a);
	}
	SendClientMessage(playerid,-1,coordinfo);
	
	if (GetPVarInt(playerid, "lang") == 0) {
		format(coordinfo,sizeof(coordinfo),"��������: %i, ����������� ��� %i",
		currentinterior, currentworld);
	} else {
		format(coordinfo,sizeof(coordinfo),"Interior: %i, VirtualWorld %i",
		currentinterior, currentworld);
	}
	SendClientMessage(playerid,-1,coordinfo);
	
	if (GetPlayerVehicleID(playerid))
	{
		new currentveh;
		currentveh = GetPlayerVehicleID(playerid);
		new Float:vehx, Float:vehy, Float:vehz;
		GetVehiclePos(currentveh, vehx, vehy, vehz);
		new vehpostext[96];
		if (GetPVarInt(playerid, "lang") == 0) {
			format(vehpostext, sizeof(vehpostext),
			"������� ������� ������� ����������: %f, %f, %f", vehx, vehy, vehz);
		} else {
			format(vehpostext, sizeof(vehpostext),
			"The current position of this vehicle: %f, %f, %f", vehx, vehy, vehz);
		}
		SendClientMessage(playerid, -1, vehpostext);
	}
}

stock SaveCoords(playerid, wmode = 0)
{
	new Float:X,Float:Y,Float:Z,Float:ang;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, ang);
	new File:coord = fopen("mtools/Coords.txt", io_append);
	new nwCoords[126];
	if(wmode == 1) format(nwCoords, sizeof nwCoords, "( %f, %f, %f ),\r\n", X, Y, Z);
	else if(wmode == 2) format(nwCoords, sizeof nwCoords, "%f, %f, %f, %f\r\n", X, Y, Z, ang);
	else if(wmode == 3) format(nwCoords, sizeof nwCoords, "SetPlayerPosEx(playerid, %f, %f, %f, %f, %i, %i)\r\n", X, Y, Z, ang, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	else if(wmode == 4){
		if(GetPVarFloat(playerid, "BoundsMaxX") == 0){
			SetPVarFloat(playerid, "BoundsMaxX", X);
			SetPVarFloat(playerid, "BoundsMaxY", Y);
			return SendClientMessage(playerid, -1, "������ ���� ��������� ���������, ������������� � ��������������� ����");
		}
		if(GetPVarFloat(playerid, "BoundsMinX") == 0){
			SetPVarFloat(playerid, "BoundsMinX", X);
			SetPVarFloat(playerid, "BoundsMinY", Y);
			format(nwCoords, sizeof nwCoords, "SetPlayerWorldBounds(playerid, %f, %f, %f, %f);\r\n",
			GetPVarFloat(playerid, "BoundsMaxX"), GetPVarFloat(playerid, "BoundsMinX"),GetPVarFloat(playerid, "BoundsMaxY"), GetPVarFloat(playerid, "BoundsMinY"));
			SendClientMessage(playerid, -1, "������ ���� ��������� ���������.");
			DeletePVar(playerid, "BoundsMaxX");
			DeletePVar(playerid, "BoundsMinX");
			DeletePVar(playerid, "BoundsMaxY");
			DeletePVar(playerid, "BoundsMinY");
		} else {
			DeletePVar(playerid, "BoundsMaxX");
			DeletePVar(playerid, "BoundsMinX");
			DeletePVar(playerid, "BoundsMaxY");
			DeletePVar(playerid, "BoundsMinY");
		}
	}
	else format(nwCoords, sizeof nwCoords, "%f, %f, %f\r\n", X, Y, Z);
	fwrite(coord, nwCoords);
	fclose(coord);
	SendClientMessage(playerid, -1, "���������� ���� ��������� � ����� {FFD700}scriptfiles > mtools > Coords.txt");
	return 1;
}

stock IsPlayerInRangeOfObject(playerid, Float:range, objectid)
{
	if(IsValidObject(objectid) && IsPlayerConnected(playerid))
	{
		new Float:x, Float:y, Float:z; 
		GetDynamicObjectPos(objectid, x,y,z);
		if(IsPlayerInRangeOfPoint(playerid, range, x, y, z)) return 1;
		else return 0;
	}
}

stock IsPlayerInRangeOfAnyObject(playerid, Float:range)
{
	new tmpstr[64];
	for(new I = 0; I < MAX_OBJECTS; I++)
	{
		if(I != INVALID_OBJECT_ID){
			new Float:x, Float:y, Float:z; 
			GetDynamicObjectPos(I, x,y,z);
			format(tmpstr, sizeof tmpstr, "objectid: %i modelid: %i", I, GetDynamicObjectModel(I));
			if(IsPlayerInRangeOfPoint(playerid, range, x, y, z)) SendClientMessage(playerid, -1, tmpstr);
		}
	}
	return 0;
}

stock FindDuplicateObjects(playerid, modelid)
{
	// Find Duplicate Objects by modelid 
	MAX_VISIBLE_OBJECTS = Streamer_GetVisibleItems(STREAMER_TYPE_OBJECT);
	//printf("MAX_VISIBLE_OBJECTS: %i", MAX_VISIBLE_OBJECTS);
	
	enum tmpObjectsData
	{
		id, Float:ox, Float:oy, Float:oz
	}
	new objData[100][tmpObjectsData];
	new tmpstr[128];
	new FindedObjects = 1;
	// Collect data
	for(new i = 0; i < MAX_VISIBLE_OBJECTS; i++)
	{
		if(IsValidDynamicObject(i) && GetDynamicObjectModel(i) == modelid) 
		{
			objData[i][id] = i;
			GetDynamicObjectPos(i, objData[i][ox], objData[i][oy], objData[i][oz]);
			//printf("object: %i pos x:%f, y:%f, z:%f",i, objData[i][x], objData[i][y], objData[i][z]);
		}
	}
	for(new i = 0; i < sizeof(objData); i++)
	{
		for(new j = 1; j < sizeof(objData) && j !=i ; j++)
		{
			if(objData[i][ox] != 0.0 && objData[j][ox] != 0.0)
			{
				//if(objData[i][ox] == objData[j][ox] || objData[i][oy] == objData[j][oy])
				if(floatabs(objData[i][ox] - objData[j][ox]) <= 0.5 || 
				floatabs(objData[i][oy] - objData[j][oy]) <= 0.5)
				{
					format(tmpstr, sizeof(tmpstr), "duplicate object:%i pos x:%f, y:%f, z:%f",
					objData[i][id], objData[i][ox], objData[i][oy], objData[i][oz]);
					SendClientMessage(playerid, -1, tmpstr);
					format(tmpstr, sizeof(tmpstr), "duplicate object:%i pos x:%f, y:%f, z:%f",
					objData[j][id], objData[j][ox], objData[j][oy], objData[j][oz]);
					SendClientMessage(playerid, -1, tmpstr);
					FindedObjects++;
				}
			}
		}
	}
	format(tmpstr, sizeof(tmpstr), "find %i duplicate objects", FindedObjects);
	SendClientMessage(playerid, -1, tmpstr);
}

stock IsDuplicateObject(objectid, objectid2)
{
	if(IsValidDynamicObject(objectid) && IsValidDynamicObject(objectid2))
	{
		new 
			Float: x, Float: y, Float: z,
			//Float: rx, Float: ry, Float: rz,
			Float: x2, Float: y2, Float: z2,
			//Float: rx2, Float: ry2, Float: rz2
		;
		GetDynamicObjectPos(objectid, x, y, z);
		GetDynamicObjectPos(objectid2, x2, y2, z2);
		//GetDynamicObjectRot(objectid, rx, ry, rz);
		//GetDynamicObjectRot(objectid2, rx2, ry2, rz2);
		if(x == x2 && y == y2 && z == z2)
		{
			return 1;
		}
	}
	return 0;
}

stock LoadMapInfo(playerid, listitem)
{
	new dir:dHandle = dir_open("./scriptfiles/tstudio/SavedMaps/");
	new 
		version, lasttime, author[32], DB: mapDB,
		path[64], item[40], type, f_counter = -1,
		Float:spawnx, Float:spawny, Float:spawnz,
		interior, world, tbtext[300]
	;
	
	while(dir_list(dHandle, item, type))
	{
		if(type == FM_FILE) 
		{
			f_counter++;
			if(f_counter == listitem) {
				format(path, sizeof path, "tstudio/SavedMaps/%s", item);
				if(fexist(path)) 
				{
					mapDB = db_open(path);
					new DBResult:MapInfo;
					new field[64];
					MapInfo = db_query(mapDB, "SELECT * FROM Settings"); 
					db_get_field_assoc(MapInfo, "Version", field, 24);
					version = strval(field);
					db_get_field_assoc(MapInfo, "LastTime", field, 24);
					lasttime = strval(field);
					db_get_field_assoc(MapInfo, "Author", field, 24);
					format(author, sizeof author, "%s", field);
					db_get_field_assoc(MapInfo, "SpawnX", field, 24);
					spawnx = floatstr(field);
					db_get_field_assoc(MapInfo, "SpawnY", field, 24);
					spawny = floatstr(field);
					db_get_field_assoc(MapInfo, "SpawnZ", field, 24);
					spawnz = floatstr(field);
					db_get_field_assoc(MapInfo, "Interior", field, 24);
					interior = strval(field);
					db_get_field_assoc(MapInfo, "VirtualWorld", field, 24);
					world = strval(field);
					db_free_result(MapInfo);
					db_close(mapDB);
					
					format(tbtext, sizeof(tbtext),
					"{FFFFFF}Version: %i LastTime: %i\n\
					Author: %s Spawn:\n\
					x:%f, y:%f, z:%f\n\
					interior: %i, world: %i",
					version, lasttime, author, spawnx, spawny, spawnz, interior, world);
					ShowPlayerDialog(playerid, DIALOG_MAPINFO_RESULTS, DIALOG_STYLE_MSGBOX, 
					"Results", tbtext, "X","");
				} else {
					printf("path not found: %s", path);
				}
			}
		}
	}
	dir_close(dHandle);
	
	return f_counter;
}

public DeleteObjectsInRange(playerid, Float:range)
{
	for(new i = -1; i < MAX_OBJECTS; i++)
	{
		if(i != INVALID_OBJECT_ID)
		{
			new objectid = i-1;
			new Float:x, Float:y, Float:z; 
			GetDynamicObjectPos(objectid, x,y,z);
			if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))
			{
				#if defined TEXTURE_STUDIO
				new param[24], param2[24];
				format(param, sizeof(param), "/sel %d", objectid);
				format(param2, sizeof(param2), "/dobject %d", objectid);
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param);	
				CallRemoteFunction("OnPlayerCommandText", "is", playerid, param2);	
				#else
				DestroyDynamicObject(objectid);
				#endif
			}
		}
	}
	return 0;
}

public SpawnNewVehicle(playerid, vehiclemodel) //spawn new veh by id
{
	// Spawn new vehicle for a player
	// Return: vehicleid
	//	if(IsApplyAnimation(playerid, "FALL_fall") return 0;
	if(vehiclemodel < 400 && vehiclemodel > 611) return 0;
	new Float:x,Float:y,Float:z,Float:ang;
	if(PlayerVehicle[playerid] != 0) DestroyVehicle(PlayerVehicle[playerid]);
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, ang);
	if (IsPlayerInAnyVehicle(playerid))
	{
		new CurrentVehID = GetPlayerVehicleID(playerid);
		DestroyVehicle(CurrentVehID);
	}
	PlayerVehicle[playerid] = CreateVehicle(vehiclemodel, x, y, z, ang, random(256), random(256), -1);
	new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
	//if(GetPlayerInterior(playerid) != 0) SetVehicleToRespawn(vehicleid);
	PutPlayerInVehicle(playerid, PlayerVehicle[playerid], 0);
	SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
	return vehicleid;
}

public GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz)
{
	//GetVehicleRotation Created by IllidanS4
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
	rx = asin(2*qy*qz-2*qx*qw);
	ry = -atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy);
	rz = -atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz);
}

public Surfly(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 1;
	new k, ud,lrk;
	GetPlayerKeys(playerid,k,ud,lrk);
	new Float:v_x,Float:v_y,Float:v_z,
		Float:x,Float:y,Float:z;
	if(ud < 0)	// forward
	{
		GetPlayerCameraFrontVector(playerid,x,y,z);
		v_x = x+0.1;
		v_y = y+0.1;
	}
	if(k & 128)	// down
		v_z = -0.4;
	else if(k & KEY_FIRE)	// up
		v_z = 0.2;
	if(k & KEY_WALK)	// slow
	{
		v_x /=5.0;
		v_y /=5.0;
		v_z /=5.0;
	}
	if(k & KEY_SPRINT)	// fast
	{
		v_x *=4.0;
		v_y *=4.0;
		v_z *=4.0;
	}
	if(v_z == 0.0) 
		v_z = 0.025;
	SetPlayerVelocity(playerid,v_x,v_y,v_z);
	if(v_x == 0 && v_y == 0)
	{	
		if(GetPlayerAnimationIndex(playerid) == 959)	
			ApplyAnimation(playerid,"PARACHUTE","PARA_steerR",6.1,1,1,1,1,0,1);
	}
	else 
	{
		GetPlayerCameraFrontVector(playerid,v_x,v_y,v_z);
		GetPlayerCameraPos(playerid,x,y,z);
		SetPlayerLookAt(playerid,v_x*500.0+x,v_y*500.0+y);
		if(GetPlayerAnimationIndex(playerid) != 959)
			ApplyAnimation(playerid,"PARACHUTE","FALL_SkyDive_Accel",6.1,1,1,1,1,0,1);
	}
	if(OnFly[playerid])
		SetTimerEx("Surfly",100,false,"i",playerid);
	return 1;
}

public SurflyMode(playerid)
{
	if(OnFly[playerid])
	{
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		SetPlayerPos(playerid,x,y,z);
		OnFly[playerid] = false;
	} else {
		OnFly[playerid] = true;
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		SetPlayerPos(playerid,x,y,z+5.0);
		ApplyAnimation(playerid,"PARACHUTE","PARA_steerR",6.1,1,1,1,1,0,1);
		Surfly(playerid);
		SendClientMessageEx(playerid, -1,
		"�� ������� � ����� ������ (surfly). ����������:",
		"You have entered surfly mode. Controls:");
		SendClientMessageEx(playerid, -1,
		"{FF0000}����� ������ ���� (LMB){FFFFFF} - ��������� ������",
		"{FF0000}Left Mouse Button (LMB){FFFFFF} - increase height");
		SendClientMessageEx(playerid, -1,
		"{FF0000}������ ������ ���� (RMB){FFFFFF} - ��������� ������",
		"{FF0000}Right Mouse Button (RMB){FFFFFF} - reduce height");
		SendClientMessageEx(playerid, -1,
		"{FF0000}������� ���� (KEY_SPRINT){FFFFFF} - ���������",
		"{FF0000}Sprint key (KEY_SPRINT){FFFFFF} - accelerate");
		SendClientMessageEx(playerid, -1,
		"{FF0000}F / �N��R{FFFFFF} - ����� �� ������ ������",
		"{FF0000}F / ENTER{FFFFFF} - exit flight mode");
		/*GameTextForPlayer(playerid,
		"~r~~k~~PED_FIREWEAPON~~w~- increase height~n~\
		~r~RMB ~w~- reduce height~n~\
		~r~~k~~PED_SPRINT~ ~w~- increase speed~n~\
		~r~~k~~SNEAK_ABOUT~ ~w~- reduce speed",10000,3);*/
	}
	return 1;
}

public FirstPersonMode(playerid)
{
	if(GetPVarInt(playerid, "Firstperson") == 0)
	{
		SendClientMessageEx(playerid, -1,
		"��� �������� � ���������� ����� ����������� ���������� ���������!",
		"When driving in transport, the environment may be displayed incorrectly!");
		firstperson[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachObjectToPlayer(firstperson[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
		AttachCameraToObject(playerid, firstperson[playerid]);
		SetPVarInt(playerid, "Firstperson",1);
	} else {
		SendClientMessageEx(playerid, -1,
		"�� ��������� ��� �� 1-�� ����", "You have disabled 1st person view");
		SetCameraBehindPlayer(playerid);
		DestroyObject(firstperson[playerid]);
		SetPVarInt(playerid, "Firstperson",0);
	}
	return 1;
}

public SetPlayerLookAt(playerid,Float:x,Float:y)
{
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((y-Py)/(x-Px)));
	if (x <= Px && y >= Py) 		Pa = floatsub(180.0, Pa);
	else if (x < Px && y < Py) 		Pa = floatadd(Pa, 180.0);
	else if (x >= Px && y <= Py)	Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) 
		Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
	return;
}

stock Jump(playerid)
{
	// Jump forward
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) useJetpack = true;
	new Float:facing_angle;
	new Float:adj = 4;
	GetPlayerFacingAngle(playerid, facing_angle);
	new LookAt = GetDirectionInWhichPlayerLooks(playerid, facing_angle);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	if (LookAt == 0) SetPlayerPos(playerid,x,y+adj,z+1);
	if (LookAt == 1) SetPlayerPos(playerid,x-adj,y+adj,z+1);
	if (LookAt == 2) SetPlayerPos(playerid,x-adj,y,z+1);
	if (LookAt == 3) SetPlayerPos(playerid,x-adj,y-adj,z+1);
	if (LookAt == 4) SetPlayerPos(playerid,x,y-adj,z+1);
	if (LookAt == 5) SetPlayerPos(playerid,x+adj,y-adj,z+1);
	if (LookAt == 6) SetPlayerPos(playerid,x+adj,y,z+1);
	if (LookAt == 7) SetPlayerPos(playerid,x+adj,y+adj,z+1);
	if(useJetpack) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
}

stock PlayerName(playerid)
{
	// Return player login name
	new pName[MAX_PLAYER_NAME]; 
	GetPlayerName(playerid, pName, sizeof(pName));
	return pName;
}

stock GetPlayerSpeed(playerid, bool:kmh = true)
{
	// Return player move speed. This function using for anticheat system
	new Float:Vx,Float:Vy,Float:Vz,Float:rtn;
	if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),Vx,Vy,Vz); else GetPlayerVelocity(playerid,Vx,Vy,Vz);
	rtn = floatsqroot(floatabs(floatpower(Vx + Vy + Vz,2)));
	return kmh?floatround(rtn * 100 * 1.61):floatround(rtn * 100);
}

GetPlayerFPS(playerid)
{
	new drunk2 = GetPlayerDrunkLevel(playerid);
	if(drunk2 < 100){
	    SetPlayerDrunkLevel(playerid,2000);
	}else{
	    if(GetPVarInt(playerid, "drunk") != drunk2){
	        new fps = GetPVarInt(playerid, "drunk") - drunk2;
	        if((fps > 0) )// && (fps < 200))
   			SetPVarInt(playerid, "fps", fps);
			SetPVarInt(playerid, "drunk", drunk2);
		}
	}
	return GetPVarInt(playerid, "fps");
}

// Attach editor
ShowMainAttachEditMenu(playerid)
{
	new string[350];

	if (GetPVarInt(playerid, "lang") == 0)
	{
		format(string, sizeof(string),
		"�����\t������\n\
		������ \t(%d)\n\
		������ \t(%d)\n\
		����� \t(%d)\n\
		X-������� \t(%.4f)\n\
		Y-������� \t(%.4f)\n\
		Z-������� \t(%.4f)\n\
		X-�������� \t(%.4f)\n\
		Y-�������� \t(%.4f)\n\
		Z-�������� \t(%.4f)\n\
		X-������� \t(%.4f)\n\
		Y-������� \t(%.4f)\n\
		Z-������� \t(%.4f)\n\
		�������������\t\n\
		{FF0000}��������{FFFFFF} ���� ������\t\n\
		���������",
		gCurrentAttachIndex[playerid],
		gIndexModel[playerid][gCurrentAttachIndex[playerid]],
		gIndexBone[playerid][gCurrentAttachIndex[playerid]],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z]);
	} else {
		format(string, sizeof(string),
		"Option\tState\n\
		Index \t(%d) \n\
		Object \t(%d) \n\
		Bone \t(%d) \n\
		X position \t(%.4f) \n\
		Y position \t(%.4f) \n\
		Z position \t(%.4f) \n\
		X-rotation \t(%.4f) \n\
		Y-rotation \t(%.4f) \n\
		Z Rotation \t(%.4f) \n\
		X-scale \t(%.4f) \n\
		Y-scale \t(%.4f) \n\
		Z-scale \t(%.4f) \n\
		Edit \t\n\
		{FF0000}Clear{FFFFFF} this index \t\n\
		Save",
		gCurrentAttachIndex[playerid],
		gIndexModel[playerid][gCurrentAttachIndex[playerid]],
		gIndexBone[playerid][gCurrentAttachIndex[playerid]],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
		gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z]);
	}

	ShowPlayerDialog(playerid, DIALOG_PLAYERATTACHMAIN, DIALOG_STYLE_TABLIST_HEADERS, "Attachments editor", string, "OK", "Cancel");

	gEditingAttachments[playerid] = true;
}

ShowIndexList(playerid)
{
	new string[512];

	for(new i; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			if (GetPVarInt(playerid, "lang") == 0)
			{
				if(gIndexUsed[playerid][i]) format(string, sizeof(string), "%s���� %d (%s - %d)\n", string, i, AttachmentBones[gIndexBone[playerid][i]], gIndexModel[playerid][i]);
				else format(string, sizeof(string), "%s���� %d (�������)\n", string, i);
			} else {
				if(gIndexUsed[playerid][i]) format(string, sizeof(string), "%sSlot %d (%s - %d)\n", string, i, AttachmentBonesEN[gIndexBone[playerid][i]], gIndexModel[playerid][i]);
				else format(string, sizeof(string), "%s Slot %d (External)\n", string, i);
			}
		}
		else format(string, sizeof(string), "%sSlot %d\n", string, i);
	}

	ShowPlayerDialog(playerid, DIALOG_ATPINDEX_SELECT, DIALOG_STYLE_LIST, "Attachments editor / Index", string, "OK", "Cancel");
}

ShowModelInput(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_ATPMODEL_SELECT, DIALOG_STYLE_INPUT, "Attachments editor / Object", "������� ������ ��� ������������", "OK", "Cancel");
}

ShowBoneList(playerid)
{
	new string[512];

	for(new i; i < sizeof(AttachmentBones); i++) 
	{
		if (GetPVarInt(playerid, "lang") == 0)
		{
			format(string, sizeof(string), "%s%s\n", string, AttachmentBones[i]);
		} else {
			format(string, sizeof(string), "%s%s\n", string, AttachmentBonesEN[i]);
		}
	}
	ShowPlayerDialog(playerid, DIALOG_ATPBONE_SELECT, DIALOG_STYLE_LIST, "Attachments editor / Bone", string, "OK", "Cancel");
}

EditAttachCoord(playerid, coord)
{
	gCurrentAxisEdit[playerid] = coord;
	ShowPlayerDialog(playerid, DIALOG_ATPCOORD_INPUT, DIALOG_STYLE_INPUT, "Attachments editor / Scale", "������� float-����� ��� ��������:", "OK", "Cancel");
}

EditAttachment(playerid)
{
	SetPlayerAttachedObject(playerid,
	gCurrentAttachIndex[playerid],
	gIndexModel[playerid][gCurrentAttachIndex[playerid]],
	gIndexBone[playerid][gCurrentAttachIndex[playerid]],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z]);

	EditAttachedObject(playerid, gCurrentAttachIndex[playerid]);

	gIndexUsed[playerid][gCurrentAttachIndex[playerid]] = true;
}

ClearCurrentIndex(playerid)
{
	gIndexModel[playerid][gCurrentAttachIndex[playerid]] = 0;
	gIndexBone[playerid][gCurrentAttachIndex[playerid]] = 1;
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = 0.0;
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = 0.0;
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = 0.0;
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = 0.0;
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = 0.0;
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = 0.0;
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X] = 0.0;
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y] = 0.0;
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z] = 0.0;
	gIndexUsed[playerid][gCurrentAttachIndex[playerid]] = false;

	RemovePlayerAttachedObject(playerid, gCurrentAttachIndex[playerid]);
	ShowMainAttachEditMenu(playerid);
}

SaveAttachedObjects(playerid)
{
	new str[256], File:file;
	if(!fexist("mtools/Attachments.txt")) file = fopen("mtools/Attachments.txt", io_write);
	else file = fopen("mtools/Attachments.txt", io_append);

	if(!file)
	{
		SendClientMessage(playerid, COLOR_GREY, "Error. Not found mtools/Attachments.txt");
		return 0;
	}

	format(str, 256,
	"SetPlayerAttachedObject(playerid, %d, %d, %d,  %f, %f, %f,  %f, %f, %f,  %f, %f, %f); // %d\r\n",
	gCurrentAttachIndex[playerid],
	gIndexModel[playerid][gCurrentAttachIndex[playerid]],
	gIndexBone[playerid][gCurrentAttachIndex[playerid]],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexPos[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexRot[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_X],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Y],
	gIndexSca[playerid][gCurrentAttachIndex[playerid]][ATPCOORD_Z],
	GetPlayerSkin(playerid));
	
	fwrite(file, str);
	fclose(file);

	ShowMainAttachEditMenu(playerid);

	return 1;
}
// END attach objects editor

stock GetPlayerCameraLookAt(playerid, &Float:rX, &Float:rY, &Float:rZ, Float:dist = 10.0) 
{
	new Float: locAt[6];
	GetPlayerCameraFrontVector(playerid, locAt[0], locAt[1], locAt[2]);
	GetPlayerCameraPos(playerid, locAt[3], locAt[4], locAt[5]);
	rX = locAt[0] * dist + locAt[3];
	rY = locAt[1] * dist + locAt[4];
	rZ = locAt[2] * dist + locAt[5]; 
}

stock FlipVehicle(vehicleid)
{
	new Float:a;
	GetVehicleZAngle(vehicleid, a);
	SetVehicleZAngle(vehicleid, a);
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock IsValidObjectModel(modelid)
{
   if(modelid >= 321 && modelid <= 328 || modelid >= 330 && modelid <= 331) return 1;
   else if(modelid >= 333 && modelid <= 339 || modelid >= 341 && modelid <= 373) return 1;
   else if(modelid >= 615 && modelid <= 661 || modelid == 664) return 1; 
   else if(modelid >= 669 && modelid <= 698 || modelid >= 700 && modelid <= 792)  return 1;
   else if(modelid >= 800 && modelid <= 906 || modelid >= 910 && modelid <= 964) return 1;
   else if(modelid >= 966 && modelid <= 998 || modelid >= 1000 && modelid <= 1193) return 1;
   else if(modelid >= 1207 && modelid <= 1325 || modelid >= 1327 && modelid <= 1572) return 1;
   else if(modelid >= 1574 && modelid <= 1698 || modelid >= 1700 && modelid <= 2882) return 1;
   else if(modelid >= 2885 && modelid <= 3135 || modelid >= 3167 && modelid <= 3175) return 1;
   else if(modelid == 3178 || modelid == 3187 || modelid == 3193 || modelid == 3214) return 1;
   else if(modelid == 3221 || modelid >= 3241 && modelid <= 3244) return 1;
   else if(modelid == 3246 || modelid >= 3249 && modelid <= 3250) return 1;
   else if(modelid >= 3252 && modelid <= 3253 || modelid >= 3255 && modelid <= 3265) return 1;
   else if(modelid >= 3267 && modelid <= 3347 || modelid >= 3350 && modelid <= 3415) return 1;
   else if(modelid >= 3417 && modelid <= 3428 || modelid >= 3430 && modelid <= 3609) return 1;
   else if(modelid >= 3612 && modelid <= 3783 || modelid >= 3785 && modelid <= 3869) return 1;
   else if(modelid >= 3872 && modelid <= 3882 || modelid >= 3884 && modelid <= 3888) return 1;
   else if(modelid >= 3890 && modelid <= 3973 || modelid >= 3975 && modelid <= 4541) return 1;
   else if(modelid >= 4550 && modelid <= 4762 || modelid >= 4806 && modelid <= 5084) return 1;
   else if(modelid >= 5086 && modelid <= 5089 || modelid >= 5105 && modelid <= 5375) return 1;
   else if(modelid >= 5390 && modelid <= 5682 || modelid >= 5703 && modelid <= 6010) return 1;
   else if(modelid >= 6035 && modelid <= 6253 || modelid >= 6255 && modelid <= 6257) return 1;
   else if(modelid >= 6280 && modelid <= 6347 || modelid >= 6349 && modelid <= 6525) return 1;
   else if(modelid >= 6863 && modelid <= 7392 || modelid >= 7415 && modelid <= 7973) return 1;
   else if(modelid >= 7978 && modelid <= 9193 || modelid >= 9205 && modelid <= 9267) return 1;
   else if(modelid >= 9269 && modelid <= 9478 || modelid >= 9482 && modelid <= 10310) return 1;
   else if(modelid >= 10315 && modelid <= 10744 || modelid >= 10750 && modelid <= 11417) return 1;
   else if(modelid >= 11420 && modelid <= 11753 || modelid >= 12800 && modelid <= 13563) return 1;
   else if(modelid >= 13590 && modelid <= 13667 || modelid >= 13672 && modelid <= 13890) return 1;
   else if(modelid >= 14383 && modelid <= 14528 || modelid >= 14530 && modelid <= 14554) return 1;
   else if(modelid == 14556 || modelid >= 14558 && modelid <= 14643) return 1;
   else if(modelid >= 14650 && modelid <= 14657 || modelid >= 14660 && modelid <= 14695) return 1;
   else if(modelid >= 14699 && modelid <= 14728 || modelid >= 14735 && modelid <= 14765) return 1;
   else if(modelid >= 14770 && modelid <= 14856 || modelid >= 14858 && modelid <= 14883) return 1;
   else if(modelid >= 14885 && modelid <= 14898 || modelid >= 14900 && modelid <= 14903) return 1;
   else if(modelid >= 15025 && modelid <= 15064 || modelid >= 16000 && modelid <= 16790) return 1;
   else if(modelid >= 17000 && modelid <= 17474 || modelid >= 17500 && modelid <= 17974) return 1;
   else if(modelid == 17976 || modelid == 17978 || modelid >= 18000 && modelid <= 18036) return 1;
   else if(modelid >= 18038 && modelid <= 18102 || modelid >= 18104 && modelid <= 18105) return 1;
   else if(modelid == 18109 || modelid == 18112 || modelid >= 18200 && modelid <= 18859) return 1;
   else if(modelid >= 18860 && modelid <= 19274 || modelid >= 19275 && modelid <= 19595) return 1;
   else if(modelid >= 19596 && modelid <= 19999) return 1; 
   else return 0;
}

public MtoolsHudToggle(playerid)
{
	//Toggle on-off mtools hud TD
	if(GetPVarInt(playerid,"hud") > 0)
	{
		SetPVarInt(playerid,"hud",0);
		SelectTextDraw(playerid, 0xFFFFFF);
		PlayerTextDrawHide(playerid, Objrate[playerid]);
		PlayerTextDrawHide(playerid, FPSBAR[playerid]);
		PlayerTextDrawHide(playerid, TDAIM[playerid]);
		PlayerTextDrawHide(playerid, Logo[playerid]);
		#if defined TEXTURE_STUDIO
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/logo");
		#endif
		SendClientMessageEx(playerid, -1, 
		"��� ���������� � ��� ������ ���� �������� ������",
		"All textdraws and player hud have been temporarily hidden");
		return 0;
	} else {
		SetPVarInt(playerid,"hud",1);
		PlayerTextDrawShow(playerid, Objrate[playerid]);
		PlayerTextDrawShow(playerid, FPSBAR[playerid]);
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING){
			PlayerTextDrawShow(playerid, TDAIM[playerid]);
		}
		PlayerTextDrawShow(playerid, Logo[playerid]);
		#if defined TEXTURE_STUDIO
		CallRemoteFunction("OnPlayerCommandText", "is", playerid, "/logo");
		#endif
		SendClientMessageEx(playerid, -1, 
		"��� ���������� � ��� ������ ���� �������������",
		"All text and player skin have been restored");
		return 1;
	}
	// Hide all textdraws (Variant 2)
	// GameTextForPlayer(playerid, "~w~", 5000, 0);
}

stock IsABike(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 461, 462, 463, 468, 471, 521, 522, 523, 581, 586, 448: return true;
	}
	return false;
}
stock IsAPlane(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 592,577,511,512,593,520,553,476,519,460,513,548,417,487,488,497,563,447,469: return true;
	}
	return false;
}
stock IsANoSpeed(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 441,448,449,450,464,462,465,481,501,509,510,537,538,564,569,570,590,591,594,606,607,608,610,611: return true;
	}
	return false;
}
stock IsABoat(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 472,473,493,595,484,430,452..454,446: return true;
	}
	return false;
}
stock IsALowrider(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 536, 575, 534, 567, 535, 566, 576, 412: return true;
	}
	return false;
}

// 2 lang chat func
stock GameTextForPlayerEx(playerid, const ru[], const en[], time, style)
{
	if (GetPVarInt(playerid, "lang") == 0)
	{
	    GameTextForPlayer(playerid, ru, time, style);
	}
	else if (GetPVarInt(playerid, "lang") == 1)
	{
	    GameTextForPlayer(playerid, en, time, style);
	}
}

stock SendClientMessageEx(playerid, color, const ru[], const en[])
{
	if (GetPVarInt(playerid, "lang") == 0)
	{
	    SendClientMessage(playerid, color, ru);
	}
	else if (GetPVarInt(playerid, "lang") == 1)
	{
	    SendClientMessage(playerid, color, en);
	}
	return true;
}

stock SendClientMessageToAllEx(color, const ru[], const en[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i))
	    {
	        SendClientMessageEx(i, color, ru, en);
	    }
	}
}