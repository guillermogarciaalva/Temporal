*--------------------------------------
*--------------------------------------
*³Sistema  : Planilla (PLANVIS)       
*³           PLANVIS 2021         
*³           (GGSOFT DEL PERU S.A.)  
*            _MAINPLAQPRG 
*--------------------------------------
*³Programa : _MAINPL2.Prg             
*--------------------------------------
REQUEST DBFCDX
#ifdef __XHARBOUR__
   #define hb_CurDrive() CurDrive()
#endif
#include "fivewin.ch"
#include "Inkey.CH"
#include "metropnl.ch"
#include "image.ch"
#include "colors.ch"

static oBrush

//====================================
Function _MainPla2()
//====================================
set dele on
set excl on
set softseek off
SET 3DLOOK ON
SET exact oN
SET Bell  ON
SET CENT  ON
SET CONF  ON

HB_GcAll(.T.)

IF IsExeRunning("_MAINPLA.exe")
	Msgalert("Ejecutable ya cargado","Planilla KERNEL")
	Return
EndIf

Private oWnd,RutaP,oMetro,cTexto
Public  aPlaEs
RutaP="\Planvis5"

If Left(alltrim(CurDir()),1)="\"
     RutaP = "\"+CurDir()
Else			
	 RutaP = HB_CurDrive()+":\"+CurDir()
EndIf	

GEN_INI()

DEFINE WINDOW oWnd FROM 1, 0 TO 24, 79 ;
					Title "Sistema de Planilla PLANVIS 2021";
					ICON "_PLANVIS.ICO"
					
_MainPl2()
 
Activate Window oWnd Maximized 
Release Font oFontlarge,oFontMed,oFontUL,oFontSmall
Release oFontL1,oFontL2,oFontL3,oFontL4
oWnd:End()
Return NIL





*------------------------
Function _MainPl2()
*------------------------
Local oMetro,oMbtn1,oMbtn2,oMbtn3,oMbtn4,oMbtn5
Local oFont,oFont2,oFontL1,oFontL2,oFontL3,oFontL4
local oBmp, oImage, oBrush
Public vDemo0

//fvDEmo()

Define Font oFont  		Name  "Segoe UI Light" Size  0, -15  Bold
Define Font oFont2 		Name  "Segoe UI Light" Size  0, -20  Bold
DEFINE FONT oFontL1    	NAME  "Arial" SIZE 0, -35 BOLD ITALIC
DEFINE FONT oFontL2    	NAME  "Arial" SIZE 0, -25 BOLD ITALIC
DEFINE FONT oFontL3    	NAME  "Arial" SIZE 0, -20 BOLD ITALIC
DEFINE FONT oFontL4    	NAME  "Arial" SIZE 0, -15 BOLD ITALIC
//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------
//--------------------------------------------------------------------
	DEFINE METROPANEL  oMetro of oWnd;
	   TITLE "";
	   COLOR RGB( 0,128, 0), RGB( 2, 70, 133 );
	   on Click oWnd:End()
	   
		oMetro:lDesignMode   := .F.
		oMetro:nMetroTop     := 260 // Margen TOP  //   260 // Margen TOP
		oMetro:nMetroMargin  := 250                //   250 
		oMetro:nBtnSize      := 130                //   130 
		oMetro:nSliderTop    := 180                //   200
		oMetro:nMetroRows 	 := 1
		oMetro:SetFont( oFontL4 ) 
		cTexto:="PLANVIS 2021"
		oTimer:=.T.
		
		
	   
	   oWnd:bMouseWheel = { | nKey, nDelta, nXPos, nYPos | oMetro:MouseWheel( nKey, nDelta, nXPos, nYPos ) }
	   oMetro:bRClicked:={|Row,Col|oWnd:End()}

       Define Brush oBrush File RutaP+"\LOG_PLA0.BMP" Resize
		 oMetro:SetBrush(oBrush)	   
		 oBrush:End()
		 
		 If vDemo0
			DEFINE FONT oFontW1 NAME "Arial Narrow"        SIZE 0,-25  BOLD ITALIC
			@ 050,500  SAY oSay1 PROMPT tVerDem + " 0*" SIZE 280,035 PIXEL BORDER COLOR CLR_WHITE, CLR_RED  OF oWnd  FONT oFontW1
		 EndIf	
		 
       If aPlaEs > 0
		   DEFINE METROBUTTON oMbtn1 OF oMetro ;
			  CAPTION 		"Planilla";
			  COLOR 		CLR_WHITE, RGB(255,255, 000 ) LARGE;
			  Font 			oFontL2;
			  ALIGN			"TOPCENTER";
			  IMAGE 		RutaP+"\P1.bmp";
			  BMPALIGN   	"BOTTOMLEFT";
			  SIZE 			060,060;
			  ACTION 		Corriendo(1)
			  oMbtn1:nClrCaption := CLR_HRED // RGB(255,255,255)
			  //COLOR 		RGB(255,255,255), RGB(0  ,255, 255 ) LARGE;
			  //IMAGE 		RutaP+"\Standar.bmp";
	   EndIf
	   
	   If aPlaEs > 1
		   DEFINE METROBUTTON oMbtn2 OF oMetro ;
			  CAPTION 		"Históricos";
			  COLOR 		CLR_WHITE,RGB(000,255,255) LARGE;
			  Font 			oFontL2;
			  ALIGN			"TOPCENTER";
			  IMAGE 		RutaP+"\P3.bmp";
			  BMPALIGN   	"BOTTOMLEFT";
			  SIZE 			060,060;
			  ACTION 		Corriendo(2)
			  oMbtn2:nClrCaption := CLR_HRED // RGB(255,255,255)
			  //COLOR 		RGB(255,255,255), RGB(255,000,000) LARGE;
			  //IMAGE 		RutaP+"\Historicos.bmp";
	   EndIf
	   
	   //If aPlaEs > 2
		   DEFINE METROBUTTON oMbtn3 OF oMetro ;
			  CAPTION 		"Configuración";
			  COLOR 		CLR_WHITE,RGB( 128, 255, 000 ) LARGE;
			  ALIGN			"TOPCENTER";
			  Font 			oFontL2;
			  IMAGE 		RutaP+"\P5.bmp";
			  BMPALIGN   	"BOTTOMLEFT";
			  SIZE 			060,060;
			  ACTION 		Corriendo(3)
			  oMbtn3:nClrCaption := CLR_HRED // RGB(255,255,255)
			  //COLOR 		CLR_WHITE,RGB( 251, 106, 0   ) LARGE;
			  //IMAGE 		RutaP+"\Configuracion.bmp";
	   //EndIf
	   If aPlaEs > 3
		   DEFINE METROBUTTON oMbtn4 OF oMetro ;
			  CAPTION 		"Especial";
			  COLOR 		RGB( 0, 0, 255 ),RGB( 255, 255, 0   )  LARGE;
			  ALIGN			"TOPCENTER";
			  Font 			oFontL2;
			  IMAGE 		RutaP+"\P4.bmp";
			  BMPALIGN   	"BOTTOMLEFT";
			  SIZE 			060,060;
			  ACTION 		Corriendo(4)
			  oMbtn4:nClrCaption := RGB(000,000,255)
			  //COLOR 		CLR_WHITE,RGB( 251, 106, 0   ) LARGE;
			  //IMAGE 		RutaP+"\Configuracion.bmp";
	   EndIf
		
	   DEFINE METROBUTTON oMbtn5 OF oMetro ;
			CAPTION 	"Salir";
			COLOR 		CLR_WHITE,RGB( 128, 128, 255 )  ;
			Font 		oFontL2;
			ALIGN		"TOPCENTER";
			IMAGE 		RutaP+"\PS.bmp";
			BMPALIGN   	"BOTTOMLEFT";
			SIZE 		060,060;
			ACTION ( oMetro:End(),oWnd:End() )
			oMbtn5:nClrCaption := CLR_WHITE    // RGB(255,255,255)
			//COLOR 		CLR_WHITE,RGB( 236,  55, 222 )  ;
			//IMAGE 		RutaP+"\Salir.bmp";
			
		
		oMetro:Show()


/*
	   DEFINE METROBUTTON oMbtn4 OF oMetro ;
	      CAPTION 		"Ayuda WEB";
		  COLOR 		RGB( 0, 0, 255 ),RGB( 255, 255, 0   )  LARGE;
		  Font 			oFontL2;
		  ALIGN			"TOPCENTER";
		  IMAGE 		RutaP+"\Man_Videos.bmp";
		  BMPALIGN   	"BOTTOMLEFT";
		  SIZE 			060,060;
		  ACTION 		Corriendo(4)
		  oMbtn4:nClrCaption := RGB(0  ,  0,255)
*/
		
			
return  NIL

//----------------------------------
Static Function Corriendo(VarEXE)
//----------------------------------
Local VarExeP,VarExeT
Do case
	Case VarExe = 1
		VarExeP = "Planilla.Exe"
		VarExeT = "Planilla de Proceso Mensual"
	Case VarExe = 2
		VarExeP = "Planil3.Exe"
		VarExeT = "Planilla Historica"
	Case VarExe = 3
		VarExeP = "Planil5.Exe"
		VarExeT = "Planilla de Configuracion"
	Case VarExe = 4
		VarExeP = "Plan_Cin.Exe"
		VarExeT = "Planilla Especial"	
		
		
	Case VarExe =  5
		If IsInternet()
			ShellExecute(,"open","www.ggsoft-planillas-tutorial.blogspot.com",,,1)  
		Else
			Msgalert("INTERNET","No Hay Conexion")
		EndIf
	Otherwise
		VarExeP = "Planilla.Exe"
		VarExeT = "Planilla Mensual"		
EndCase
If VarExe =  5
Else
    WINEXEC( VarExeP )
EndIf
Return

Function PidOrdpla()
Return

Function PidActivi()
Return

Function Abrefiles()
Return


Function xlsOpen()
Return NIL

Function xlsWrite()
Return NIL

Function xlsClose()
Return NIL

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

DLL32 FUNCTION BWCCRegister( hInst AS LONG ) AS WORD PASCAL LIB "BWCC32.DLL"
