*--------------------------------------
*--------------------------------------
* Sistema  : Planilla (PLANVIS)       
*            PLANVIS 2021
*            (GGSOFT DEL PERU S.A.)  
*--------------------------------------
* Programa : Planilla.Prg             
*--------------------------------------
REQUEST DBFCDX
#ifdef __XHARBOUR__
   #define hb_CurDrive() CurDrive()
#endif
#include "fivewin.ch"
#include "image.ch"
#include "InKey.ch"
#include "xBrowse.ch"
static oBrush,oIcono,oCur
*----------------------
Function Main()
*----------------------
Parameters VarVRM
local oBmp, oItem, oMsgBar
local oSay,oSay1,oSay2
//setHandleCount(250)
// Guillermo Garcia
//Violeta Lopez
//Gerardo
set date  to brit
Set Epoch To 1950
set dele on
set excl on
set softseek off
SET 3DLOOK ON
SET exact off
SET Bell  ON
SET CENT  ON
SET MULTIPLE OFF
HB_GcAll(.T.)

If pCount()  = 0
	IF IsExeRunning("Planilla.exe")
		Msgalert("Ejecutable ya cargado","Planilla Standart")
		Return
	EndIf
EndIf


PUBLIC ArrAsiste[6,50],uAsiste,SwForAlt,SwSimula,SWNTareo,MenuCol,xPerPlanper,SwPdfCreator,SwAnexo,cRiMCaGr1,cRiMCaGr2,cTbCoAdRe,tVERDEM,ArrPEspN,NomAud,DatAnt,DatPos
Public ArrTAus   := {"          ","01Trabajado","02Descanso","03Vacaciones","04Lic.S/Go","05Lic.C/Go","06Permiso","07Serv.Espec",;
				     "08Des M�dico","09Subsidio","10Feriado","11Canje","12Falta","13Falta Just","14Suspens","15Otro" }
Public ArrActi   := {"1 Activo","2 Subsidio","3 Vacaci�n","4 Lic.C/Go","5 Lic.S/Go","6 ---------","7 Cesado","8 Otro"}
Public ArrTCon   := {"1 Interno","2 Movimiento","3 Remuneraci�n","4 Descuento","5 AFP Dscto","6 Aporte Pat"}
Public ArrTCRT   := {"1 Ingres.Trabajador","2 Dsctos.Trabajador","3 Aport.Trabajador","4 Aport.Empleador",;
					 "5 Totales          ","6 Cabecera         ","7 Movimiento(D/H) " 	}
Public ArrTCR2   := {"1 Remuneraciones   ","2 Asignaciones     ","3 Bonificaciones  ","4 Gratificaciones",;
					 "5 Indemnizaciones  " 	}	
Public ArrUnid   := {"1 Soles","2 $D�lares","3 minutos","4 horas","5 dias","6 Meses","7 %Porcent","8 A�os","9 Euros","10Hijos","11Factor","12Valor","13Unidad","14Otros"}
Public ArrCCon   := {"1 Constante","2 Dato Fijo","3 Dato Variable","4 Formula"}
Public ArrCConR  := {"1 Konst","2 DatFijo","3 DatVariab","4 F�rmul"}
Public ArrCPla   := {"1 REMUNERACIONES","2 VACACIONES   ","3 GRATIFICACION ","4 LIQUIDACIONES","5 UTILIDADES  ","6 CONSOLIDADO","7 PLANTOTC","8 PLANADI ","9 PLANCTS  "}
Public ArrDSem   := {"1 Domingo  ","2 Lunes    ","3 Martes   ","4 Mi�rcoles","5 Jueves   ","6 Viernes  ","7 S�bado   "}
Public ArrNMes   := {"01 Enero","02 Febrero","03 Marzo","04 Abril","05 Mayo","06 Junio","07 Julio","08 Agosto","09 Setiembre","10 Octubre","11 Noviembre","12 Diciembre"}
PUBLIC ArrTCta   := {"1 Cta.Ahorros","2 Cta.Corriente.","3 Cta.Maestra","4 Cta.Interbanc","5 Otro"}
//PUBLIC ArrTDoc   := {"   Blanco     ","01 DNI/L.Elect","02 Carne Fza.Pol","03 Carne de F.Arm","04 Carne de Extran","06 R.U.C.","07 Pasaporte","08 Doc.Prov.Ident.",;
//                     "10 AutoGenerado","11 Part.Nac.-Ident","14 Carne de Extran","15 Interdicto"}
PUBLIC ArrTDAF   := {"   Blanco","00 DNI/L.Electoral","01 Carne Extranjer�a","02 Carne Milit/Polic","03 Lib.Adoles.Trabaj","04 Pasaporte","06 Permiso Temp.Permanenc" }
PUBLIC ArrTDCO   := {"   Blanco","01 L.Electoral","02 L.Militar","03 D N I","04 Part.nacim","05 Perm.Menores","06 Car.Extranj.","07 Bol.Insc.Milit","08 Pasaporte" }					 
PUBLIC ArrECiv   := {"1 Soltero","2 Casado","3 Viudo","4 Divorciado","5 Conviviente"}
Public ArrFPag   := {"1 Efectivo","2 Cheque","3 Cuenta Cte","4 Letra"}
Public ArrTDES   := {"1 Destaque Output","2 Destaque Input"}
Public ArrExCo   := {"0 Sin Exclusi�n","1 Excluida si no es AFP","2 Exclusi�n Total"}
Public ArrNEst   := {"1 Estab.Fiscal/Anexos","2 Estab.Destaque","3 Estab. Nos destacan"}
Public ArrFonts  := {"01 Arial","02 Arial Narrow","03 Arial Black","04 Bodoni","05 Calibri","06 Courier","07 Courier New",;
					 "08 Franklin Gothic Book","09 Franklin Gothic Demi","10 Script MS","11 Tahoma","12 Times New Roman","13 Verdana"}
Public Diastar[31],HorasTar[31],AConce[24],ArrD1Sem[07],ArrTarS[24],DiaSem[07],DiaSem1[07]					 
Public BackColor,ForeColor,cTbPBonGr,cLetNegra,cTipFont,cLetItalic,SwPlaGral,YaLiqui,SwProyec1,SwProyec2,SwProyec3,IngPerci,SwPlaAdi,cRTarSem,SwProCto, SwProCt2,SwRmxEPS
Public aTbRmDMed, aTbRmSubs, aTbRmSubM,SwDescri,NumRegFil,NumRegFil1,MaxCon,xViUsuari,xViClave, aTbPerSGo,MaxCon1,SwLogNSi,CalNue,SwAudito
Public SwRepPrn := .F.
Public SwPanChi := .F.
Public SwAnaInt := .F.
Public SwIngNor := .F. // Pase sin pedir clave
Public SwBolSem := .F. // Boleta Sin Email     
xViUsuari = ""
xViClave  = ""
CalNue    = .F.
NomAud = ""
Public TT,TTT,gCatGen,xSalirT,ArrCale[35]
Public VERGGA := 3
Public ArrInhb[5,36]
Public CLR_100,CLR_200,CLR_300,CLR_400
Public CLR_500,CLR_600,CLR_700,CLR_800,CLR_900,cPic,cPicX
Public CLR_990,CLR_995                                      
Public cTb4Bole4
MaxCon:= 365 // Reccount de Conceptos
cTbCoAdRe = 0
tVERDEM = "Versi�n Educativa "

/*
CLR_100 := RGB(196,255,254)  //  celeste claro
CLR_200 := RGB(255,255,174)  //  blanco
CLR_300 := RGB(255,255,140)  //  amarillo claro
CLR_400 := RGB(133,207,252)  //  celeste fuerte
CLR_500 := RGB(162,248,137)  //  verde claro
CLR_600 := RGB(226,224,156)  //  gris
CLR_700 := RGB(145,255,252)  //  celeste fuerte
CLR_800 := RGB(145,255,220)  //  celeste
CLR_900 := RGB(100,100,100)  //  plomo oscuro
CLR_990 := RGB(064,000,128)  //  morado
CLR_995 := RGB(204,171,248)  //  violeta
*/
CLR_100 := RGB(094,255,251)  //  celeste claro  *
CLR_200 := RGB(233,233,233)  //  blanco oscuro  *
CLR_300 := RGB(255,255,128)  //  amarillo claro *
CLR_400 := RGB(017,225,242)  //  celeste fuerte *
CLR_500 := RGB(147,255,128)  //  verde claro    *
CLR_600 := RGB(206,203,089)  //  pastel			*
CLR_700 := RGB(010,171,184)  //  celeste oscuro *
CLR_800 := RGB(255,000,000)  //  Rojo   		*
CLR_900 := RGB(138,138,138)  //  plomo oscuro	*
CLR_990 := RGB(000,000,000)  //  Negro   		*
CLR_995 := RGB(007,248,026)  //  Verde   		*

cPic	:= "@Z 99999,999.99"
cPicX	:= "@Z 99999,999.99"   
TT  := .3
TTT := .05
xSalirT  := .F.
SwPlaGral = .F.
SwNTareo  = .F.
SwSimula  = .F.
SwProyec1 = .F.  // HMB
SwProyec2 = .F.  // Montali
SwProyec3 = .F.  // Intelec
SwProCto  = .F.
SwProCt2  = .F.
SwLogNSi  = .F.
SwPlaAdi  = .F.
SwAnexo   = .F.


ArrD1Sem[1] = 2   // Lunes
ArrD1Sem[2] = 3   // Martes
ArrD1Sem[3] = 4   // Miercoles
ArrD1Sem[4] = 5   // Jueves
ArrD1Sem[5] = 6   // Viernes 
ArrD1Sem[6] = 7   // Sabado 
ArrD1Sem[7] = 1   // Domingo 

DiaSem[2] = "Lun"
DiaSem[3] = "Mar"
DiaSem[4] = "Mie"
DiaSem[5] = "Jue"
DiaSem[6] = "Vie"
DiaSem[7] = "S * "
DiaSem[1] = "D * "

DiaSem1[2] = "Lun"
DiaSem1[3] = "Mar"
DiaSem1[4] = "Mie"
DiaSem1[5] = "Jue"
DiaSem1[6] = "Vie"
DiaSem1[7] = "Sab"
DiaSem1[1] = "Dom"


//-----------Para Formulas------------------------------------

Public  XPRESANOR, VALTAB,   XPLDOCUME, SWMAY65, SWULTSEM
Public  SWSCTR_S,  SWSCTR_P, SWESSALU,  SWSITESP, XPLCTABCO, SWJUBILA, SWSABLAB
Public  SWEXTRAN,  DTRAMES,  SWDOMICI,  SWAFIEPS, SWFILTPE
Public  SW1VMES1,  SW1VMES2, SW1VMES3
PUBLIC  SWVidLey,  SwJornal, SwFcjmms,  SwAfpCic, SwFacfam,xPeRmBaIn,SwTarNum,SwTarAlf,SwTarCC
PUBLIC  SwAvis1,   SwAvis2,  SwAvis3,   SwUbiRtps
SwUltSem := .F.
SwUbiRtps:= .F.
//--------XLS------------------------------------
PUBLIC aFONTS    := {}
PUBLIC aFormats  := {}
PUBLIC cInfo     := {}
PUBLIC aOperators:= {}
//--------------------
Public ArrRtPr   := {"  S_Dat", "M Manual","C Copiar"}	
//------------------------------------------------------------	
Public ArrTDMes[2,31]	// (1, Ultimo dia de cada mes,   2, primer dia util de cada mes) Para Fechas de Ingreso y Retiro )
//------------------------------------------------------------
//  ArrCrta   1 Concepto + Descripcion
//            2 Alias
//            3 0
//            4 Desbr2
//            5 CpRenta
//
//  ArrMrta   1 Antes                   
//            2 Hoy   
//            3 Proyeccion
//            4 CpCodigo 
//            5 Alias    
//            6 Concurrencia 
//            7 Promedio 
//            8 Desc     
//            9 Desc     
//------------------------------------------------------------
//------------------------------------------------------------
Public ArrPPag   := {}
PUBLIC ArrCto    := {}
PUBLIC ArrCto2   := {}
PUBLIC ArrCto3   := {}
PUBLIC ArrAfp    := {}
PUBLIC ArrPlan   := {}
PUBLIC ArrAlias  := {}
PUBLIC ArrAliaC  := {}
PUBLIC ArrBan    := {}
PUBLIC ArrCat    := {}
PUBLIC ArrTemple := {}
PUBLIC ArrDivisi := {}

PUBLIC ArrSCa    := {}
PUBLIC ArrCdc    := {}
PUBLIC ArrEmp    := {}
PUBLIC ArrCon    := {}
PUBLIC ArrAre    := {}
PUBLIC ArrParti  := {}
PUBLIC ArrCar    := {}
PUBLIC ArrSCa    := {}
PUBLIC ArrAsi    := {}
PUBLIC ArrSESP   := {}   // Situacion especial
//--------------------
//--------------------
//------P.D.T.--------
//--------------------
PUBLIC ArrEstab  := {}
PUBLIC ArrEstaD  := {}

//--------------------
//Public ArrTDES   := {"1 Destaque Output","2 Destaque Input"}

//Public ArrDestT  := {}
//Public ArrDestF  := {}
//PUBLIC ArrEsta2  := {}

PUBLIC ArrTEsta  := {}
PUBLIC ArrDoIde  := {}
PUBLIC ArrVia    := {}
PUBLIC ArrZona   := {}
PUBLIC ArrTTrab  := {}
PUBLIC ArrNivEd  := {}
PUBLIC ArrRegPe  := {}
PUBLIC ArrTCtra  := {}
PUBLIC ArrPerio  := {}
PUBLIC ArrPreSa  := {}
PUBLIC ArrSiTra  := {}
PUBLIC ArrModPa  := {}
PUBLIC ArrMotFi  := {}
PUBLIC ArrModFo  := {}
PUBLIC ArrVinFa  := {}
PUBLIC ArrBajDH  := {}
PUBLIC ArrSubsi  := {}
PUBLIC ArrVacac  := {}
PUBLIC ArrInasi  := {}
PUBLIC ArrTiCom  := {}
PUBLIC ArrCatOc  := {}  ////////////////
PUBLIC ArrPlaCa  := {}
PUBLIC ArrGruAs  := {}  /////////////////
PUBLIC ArrMFiIn  := {}  /////////////////  Para Periodos Laborales

PUBLIC ArrDoPat  := {}
PUBLIC ArrConve  := {}
PUBLIC ArrCatGe  := {}  /////////////////
PUBLIC ArrRegLa  := {}  /////////////////
PUBLIC ArrTCPRO  := {}  /////////////////

PUBLIC ArrRegSa  := {}  /////////////////
PUBLIC ArrDepa:={}
PUBLIC ArrProv:={}
PUBLIC ArrDist:={}
PUBLIC ArrCCL:={}
//--------------
PUBLIC ArrSDF[31]
PUBLIC ArrDIA[31]
//--------------
//---Contratos--
//--------------
PUBLIC ArrRgLaC :={}  // Reg Laboral Contratos
PUBLIC ArrModal :={}  // Modalidad
PUBLIC ArrSbMod :={}  // Sub Modalidadfecrep

PUBLIC ArrGrOcu :={}  // Grupo Ocupacional
PUBLIC ArrTiMon :={}  // Tipo de Moneda
PUBLIC ArrTRmVa :={}  // Tipo de Rem.Variable
//--------------
//--------------
PUBLIC ArrRgEdu :={}  // Regimen Educativo
PUBLIC ArrTiIns :={}  // Tipo de Instituto 
//--------------
//--------------
//--------------
PUBLIC cDepart, cProvin, cDistri,cFilSel,vPerPag,xVarTF,oPrn,cEmGtrDia, cSelPdt ,cCtDescri, nSexMes, nSexDia, cFecAct, cOrdPPG, PlaAct, xPlCatego, xPlCatGen, xPrEsaNoc
PUBLIC cFecRet,xPlFecIng,xPlCodEmp,xPlIniVac,xPlDiavac,xPlFecNac,cMesCes,cMesPro,cCtImport,gDesBre,xPlNumSpp,xPlFeInHi,oImageL,xPlFecRet,cCatGen,Ult_Gra,Ult_GrB,cSiPlHi
Public DifDiaU,DifMesU,DifAnoU,DifDiaT,DifDiaS,DifMesS  // Difere de Dias.meses,Anos / Dif Dias Tot, Dif Dias sistema, Dif Dias Meses Sist,cTbPlMeCs
Public SwEsPyme, cTbCtsPym, cTbPlaMic, SwEsMicro,UltPer,UltVac,aTbDVaPPA,xTbDVaPPA,cTbDVaPPA,cTbAcmSub,SwGbGA,gVarFil,gTarSemn,SwLiCVal,SwNCesad,SwCesado,SwMueFil,SwRemInt
PUBLIC xUser := 'DEMO'
Public zAnopro, zMespro, zPerpag, cSaCtoCto, cSaCtCto2
PUBLIC Mones:= {"UNO","DOS","TRES","CUATRO","CINCO","SEIS","SIETE","OCHO","NUEVE","DIEZ","ONCE",;
                "DOCE","TRECE","CATORCE","QUINCE","DIECISEIS","DIECISIETE","DIECIOCHO","DIECINUEVE"}
Public Mdece:= {"VEINTE","TREINTA","CUARENTA","CINCUENTA","SESENTA","SETENTA","OCHENTA","NOVENTA"}
Public MCent:= {"CIENTO ","DOSCIENTOS ","TRESCIENTOS ","CUATROCIENTOS ","QUINIENTOS ","SEISCIENTOS ","SETECIENTOS ","OCHOCIENTOS ","NOVECIENTOS "}
Public mthree,mLetra,VAsgFamR,VAsgFamV,VAsgfamS,tAnoPro,tMesPro,ScPorFal
//----------------
Public Per_Block1,Per_Block2,Per_Block3,Per_Block4,Per_Block5,Per_Block6,Per_Block7,Per_Block8,Per_Block,vAno,cNoRecal
vAno = "A" + Chr(164) + "o"
vAno = Oemtoansi(vAno)

Per_Block1 := .F.
Per_Block2 := .F.
Per_Block3 := .F.
Per_Block4 := .f.
Per_Block5 := .f.
Per_Block6 := .f.
Per_Block7 := .f.
Per_Block8 := .f.
cSiPlHi    := .F.
cNoRecal   := .F.
//----------------
Public hWnd:=GetActiveWindow()
Public oWnd,RutaS,PlaAct,cViCodigo,NomCto,cFSelCto,TotRec,cTbSelCto,NumReg,NumRein,SwCamb6A,SwCamb6B,cAutRta,cRetGra,SwOnce,SwLogoGe
Public cEmDetCto, cEmDetCt2,  cEmDetAre, cArea, _Ancho,_Inicio
Public gAnoMes,gAnoPer,ggAnoMes,ggAnoPer,gAnoCes,ggAnoCes
Public zPlame, zCorre, zBole2,  zOtros,aGrad1,aGrad2,aGrad3,aGrad4,aGrad5,aGrad6,aGrad7,aGradx,aGrady
Public xPlTraPen,xPrRegPen,xPrTipTra,xPrCatOcu,xPrRegLab,xPrRegSal,xPrTipCtr,xPeInRePe,DiFeReMe,SwRegLab
//----------------------------------------------------------------------------------------------------
 
   //aGrad1 := {	{ 0.4, CLR_GREEN, 	CLR_HGREEN	}	,;
   //				{ 0.6, CLR_HGREEN,	CLR_GREEN	}	}
				
   aGrad1 := {	{ 0.4, nRGB(251,170,206), nRGB(251,170,206) }	,;
  				{ 0.6, nRGB(213,043,060), nRGB(213,043,060)	}	}			
				
   aGrad2 := {	{ 0.4, CLR_BLUE , 	CLR_HBLUE 	}	,;
				{ 0.6, CLR_HBLUE ,	CLR_BLUE 	}	}				

   aGrad3 := {	{ 0.4, CLR_CYAN , 	CLR_HCYAN 	}	,;
				{ 0.6, CLR_HCYAN ,	CLR_CYAN 	}	}	
				
   aGrad4 := {	{ 0.4, CLR_RED  , 	CLR_HRED  	}	,;
				{ 0.6, CLR_HRED  ,	CLR_RED  	}	}				
				
   aGrad5 := {	{ 0.4, CLR_MAGENTA ,CLR_HBLUE    }	,;
				{ 0.6, CLR_HMAGENTA,CLR_BLUE     }	}				
				
   aGrad6 := {	{ 0.4, CLR_GRAY , 	CLR_HGRAY 	}	,;
				{ 0.6, CLR_HGRAY ,	CLR_GRAY 	}	}								
				
   aGrad7 := {	{ 0.5, CLR_BLUE , 	CLR_YELLOW	}	,;
				{ 0.5, CLR_BLUE  ,	CLR_YELLOW	}	}
				
   aGrad7 := {	{ 0.5, CLR_RED  , 	CLR_YELLOW	}	,;
				{ 0.5, CLR_HRED  ,	CLR_YELLOW	}	}			
				
  			
				
Public cEmPlacas, xPlaCat    												// Categoria de Planilla
//     (1=Trab, 2=Pens, 3=Cuarta, 4=Pract, 5=Terceros, 6=CAS, 7=Cons.Civ, 8=Minera, 9=Pyme  )
//----------------------------------------------------------------------------------------------------
Public SwEnVeda, SwSepCto,  SwSepCat,  SwCalInv, SwTraCas, SwEnVedP, SwEmPyme, SwVolAfp // Atributos de Planilla
//     En veda,  Sep.C.Cto, Sep categ, Cal.Inve, Tra CAS,  EnvedaP,  Pyme                   
//----------------------------------------------------------------------------------------------------
Public CeroUno  := "01"
Public ResouDLL := 1
Public SwFilCC, Filter1, SwEstDir, SwEnCont
Public dPlFiPeTr := "  "
Public cPlFecFin := CtoD("  /  /    ")
Public SwFEsSal := .F.
//---------------------
Public cFmTime   := .T.
Public cFmDate   := .T.
Public cFmEjeCto := .T.
Public cFmConTit := .T.
Public cFmAncho  := 132
Public cFmMargen := -10
Public cFmLinIni :=  0
Public cFmDetIni :=  10
Public cFmLinMax :=  56
Public cFmPuntos :=  1
Public cFmCatGen :=  1
Public cFmLOGO   := .T. 
Public cFmLOGO2  := .T. 
Public cFmHorizo := .T.
Public cFmLogLin1,cFmlogCol1, cFmLogLin2,cFmlogCol2,cFmAncho,  cFmLinIni, cFmLarDes
Public cFmConTit, cFmDescri,  cFmCodigo, cFmSwFut1, cFmLinDob, cFmNombre
Public cFmObserv, cFmCodEmp,  cFmCargo,  cFmCtoCto, cFmCodRef, cFmfecNac
Public cFmFecIng, cFmFecCes,  cFmNumDoc, cFmCtaBco, cFmNumAfp, cFmIndCes
Public cFmIniVac, cFmLibSSP,  cFmCtaCts, cFmCtCto2, cFmTelefo, cFmArea
Public cFmEstCiv, cFmCatego,  cFmStCond, cFmForPag, cFmDocume, cFmResume
Public cFmRuc,    cFmIndRay,  cFmSwSTit, cSwSwPeri, cFmSwTCam, cFmNoCesa
Public cFmNumPag, cFmSwMone,  cFmMargIz, cFmMargDe, cFmMargAr, cFmMargAb
Public cFmLogRut1,cFmLogLin1, cFmLogLin2,cFmLogCol1,cFmLogCol2,cFmPiePag, cFmPiePa2
Public cFmLogAnc1,cFmLogAnc2, cFmLogAlt1,cFmLogAlt2, cFmSubTi, cFmEnlace
Public cFmEnlac1, cFmEnlac2,  cFmEnlac3, cFmEnlac4, cFmEnlac5, cFmEnlac6              
Public cFmCondic, cFmCondi2,  cFmFinVac, cFmSwFut2, cFmSwFut3, cFmSwFut4, cFmSwFut5
Public cFmSwFut6, cFmSwFut7,  cFmSwFut8, cFmSwFut9, cFmlogPie
Public cFmLogCol3,cFmLogAnc3, cFmLogAlt3,cFmLogLin3,cFmSwPeri, cFmrexCun 
Public cFmNomEps,cFmPolEps,cFmTiCont,cFmFiCont,cFmFFCont,cFmAfpMix,cFmVidLey,cFmEsaVid
Public cFmSctrSa,cFmSctrPe,cFmFdoMin,cFmFacFam,cFmRemBas,cFmDomici,cFmAfpCic,cFmAfpFec,cFmInRgPe
//-----------------------
Public ESE       := "S"
Public ESPA01    := " "

Public cTipLetra :=  3
Public cTamFont  :=  4
Public cTipBold  := .T.
Public cTipItal  := .F.

Public cActivi   :=  1
Public lPase     := .T.
Public CodEmp    := "01"
Public vDemo     := .T.
Public Terminal  := .F.
Public CreaEmp   := .F.
Public xSalir    := .F.

Public oFont0,   oFont1,   oFont2,   oFont3,   oFont4,   oFont5, oFont6, oFont7, oFont8, oPen1,  oPen2,  oFont, oFontW1
Public oFonPlc,  oFont1B,  oFont2B,  oFont3B,  oFont4B,  oFont5B
Public nfont1,   nfont2,   nfont3,   nfont4,   nfont5
Public nFormat0, nFormat2, nFormatN, nFormatD, nFormatP, nFormat4, nFormatE, nFormNeg
Public oFont0t, oFont1t,  oFont2t,   oFont3t,  oFont4t,  oFont5t, oPen1t, oPen2t, oFontt

DEFINE FONT oFonPlc NAME Substr(ArrFonts[1],4)   SIZE 0,-11

Public SwAFP    := 0
Public SwAFPMIX := .f.
Public SWClaPla := 0
Public SwCtoCto := 0
Public SwCtCto2 := 0
Public SwCarFam := 0
Public SwCondic := 0
Public SwCatego := 0
Public SwCargo  := 0
Public SwImpcar := .F.
Public DiasNeto := 0
Public nLinea   := 0
Public nPag     := 0
Public ValTab   := 0
Public FacSub   := 0
Public ZERO2    := "00"
Public SwArreglo:=.F.
//-----
Public  TarRed[4],TarRed1,TarRed2,eTarRed1,eTarRed2,eFec1,eFec2,cUsuHD,eUsuHD,RanTie,TieLic,SwT_Inaf
//------
PUBLIC cClave,cCodigo,cEmpresa,mes,cPagBco,cNomIni,oPerIni,cNomFin,oPerFin
PUBLIC oNomIni,cResCto,oSwPer,cSwExc,cMoneda,gVarCla,oNomFin, cEmcalEps,cSwCPlam,cSwCConc,cSWResCC

Public gPerPag,hPerPag,hClaPla,cHojExc,scAno,ApoMinEsa,cTbCsdEsa,cTbCsdAfp
Public cSwAfp,cAfp,xAfp,cSimCom,cSwVac,cSwGra
Public cSexo,xAlias
PUBLIC xAnopro,xMesPro,xSemana,xMesAno,xSemMes,gMesPro,IniLogo,xDiaSem
PUBLIC hAnopro,hMesPro
PUBLIC cAnoCes,cMesCes
Public nRowStep,nColStep,cTexto
Public xFecIni,xFecFin, xFecInM,xFecFiM
Public hPlanPer, aPlanPer
Public cOrden    :=  1
Public cClaPla   :=  1
Public gOrden    := 1

Public cSwCts    :=  .F.
Public cSwCto    :=  .F.
Public cSwCto2   :=  .F.
Public cCtoCto   :=  1
Public xCtoCto   :=  Space(10)
Public cCtCto2   :=  1
Public xCtCto2   :=  Space(10)

Public cSwCdc    :=  .F.
Public cCondic   :=  1
Public xCondic   :=  1

Public cSwEstab  :=  .F.
Public cEstabl   :=  1
Public xEstabl   :=  Space(04)

Public cSwCate   :=  .F.
Public cCatego   :=  1
Public xCatego   :=  1

Public cSwArea   :=  .F.
Public cArea     :=  1
Public xArea     :=  1

Public cSwCatGen :=  .F.
Public cCatGen   :=  1
Public xCatGen   :=  Space(02)

Public cSwPer    :=  .F.
Public cPerIni   :=  1
Public cPerFin   :=  1
Public xPerIni   :=  Space(4)
Public xPerFin   :=  Space(4)
Public cCodTra   :=  ""

Public cSwFilt1  :=  .F.
Public cSwFilt2  :=  .F.
Public cFiltro1  :=  Space(30)
Public cFiltro2  :=  Space(30)
Public cFiltro3  :=  " "
Public LetRuta

Public cPuntos   :=  1
Public cPermis1  :=  Space(254)
Public TopUser   :=  Space(05)
Public TopNiv    :=  00
Public RutaP,RutaAfp,RutaPDT 

If Left(alltrim(CurDir()),1)="\"
     RutaP = "\"+CurDir()
Else			
	 RutaP = HB_CurDrive()+":\"+CurDir()
EndIf	
RutaAfp = RutaP		
		
Public RutaW     :=  Alltrim(RutaP)
PUBLIC SwMetTar  := .t.
PUBLIC SwQuince  := .F.
PUBLIC cLogPla
PUBLIC rPrevia1,rPrevia2,rPrevia5, rPrevia4, rPrevia5, rPrevia6, rPrevia7
PUBLIC rPrevia8,rPrevia9,rPrevia10,rPrevia11,rPrevia12,rPrevia13,rPrevia14,rPrevia15
PUBLIC rPreviaV,rPreviaG,cTbPVaSep,rPreviaG2

SwGbGa := .F.
SwRegLab:= 0

GEN_INI()

If ( File("&RutaP\VIA.DBF") .and. File("&RutaP\VIA.CDX") )
Else
     DbCloseAll()
     MsgAlert("Archivos Via no existen en :" + CRLF+;
			   "/"+RutaP+"/",;
			   "Revisar....")
     CursorWait()
     set exclusive on
	 Return (NIL)
EndIf

cPuntos    :=  3
cTipFont   :=  1
cLetNegra  := .T.
cLetItalic := .F.
DefFonts(cPuntos,cTipFont,cLetNegra,cLetItalic,0)

Close("Via")
use &RutaP\Via index &RutaP\Via alias Via     new   via "dbfcdx" share
DbSelectArea("VIA")
DbGoTop()
*--------------------------------------------------------------------------------
SET RESOURCES TO "&RutaP\PLANILLA.DLL","&RutaP\PLANILLA2.DLL","&RutaP\BWCC32.DLL","&RutaP\PREV32SP.DLL"
BWCCRegister( GetResources() )
//-------------------------------------------------------------------------------
//------------------------------------------------------------------------------
If date() > Ctod("15/01/2022")  // Para que ya no funciones el sistema
		DbSelectArea("Via")
		DbGoTop()
		Do While !Eof()
			If DbRLock1()
				Repl Via->ViRutaP with ""
				DbUnlock()
			EndIf
			DbSkip()
		EndDo
		Close("Filred")
		use &RutaP\Filred alias filred    new   via "dbfcdx" EXCL
		DbSelectArea("Filred")
		DbGoTop()
		Repl All Filred->UU  with ""
		Repl All Filred->D1  with ""
		Repl All Filred->D2  with ""
		Repl All Filred->C1  with ""
		Repl All Filred->C2  with ""
		Repl All FilRed->AC  with ""
		Repl All FilRed->NN  with ""
		If Filred->C100 == 0
			Repla FilRed->C100  with CLR_100
			Repla FilRed->C200  with CLR_200
			Repla FilRed->C300  with CLR_300
			Repla FilRed->C400  with CLR_400
			Repla FilRed->C500  with CLR_500
			Repla FilRed->C600  with CLR_600
			Repla FilRed->C700  with CLR_700
			Repla FilRed->C800  with CLR_800
			Repla FilRed->C900  with CLR_900
		EndIf
		CLOSE("FilRed")
		msgwait("R E S E T","Warning",.5)
EndIf

 //////////     Claves seguidas
Crea_Tar()
If xSalir
	Return
EndIf

*--------------------------------------------------------------------------------
If SwMetTar   
		Lee_Tar()
		Crea_Tar()
		Adi_Tar(.f.,1)
EndIf
//---------------------------------------------------
//----------------------------------------------------
If Decrypt(Alltrim(Via->ViRutaP)) == "97022"
		vDemo=.F. // Remarks
		//msgwait("q d","",1)
EndIf		
*--------------------------------------------------------------------------------
A_Via(1,0)
Set Dele On

If xSalir
     DbCloseAll()
     CursorWait()
     Return (NIL)
EndIf

RutaS   := AllTrim(Via->ViRuta)

Close("TmpVia")
Use &RutaP\Tmpvia alias TmpVia new   via "dbfcdx"  Shared
If Bloquea("TMPVIA",3)
	Repl TbRutaP with RutaW
	Repl TbRutaS with Alltrim(Rutas)
	DbUnlock()
EndIf
Close("TmpVia")
*-------------------------------------------------------------------------
If !SwMetTar 
	PideClaves()
EndIf	
*-------------------------------------------------------------------------
Empre:= "EMPRESA.DBF"
If !File("&RutaS\&Empre")
    MsgAlert("Directorio no Existe ====>>> ( " + RutaS + " )","Revisar las RUTAS del archivo VIA")
    Return NIL
EndIf

If left(rutas,2)="\\"
	LetRuta := "\"
Else
	LetRuta := HB_CurDrive(RutaS) + ":"
EndIf	

*------------------------------------------------------------------------
If !Acc_ING()
	Return
EndIf
*-------------------------------------------------------------------------
use &rutaS\Empresa   index &rutaS\Empresa  alias Emp    new   via "dbfcdx"  Shared
use &rutaS\Tablas    index &rutaS\Tablas   alias Tablas new   via "dbfcdx"  Shared
use &rutaS\usuarios  index &rutaS\usuarios alias user   new   via "dbfcdx"  Shared

SwLogNSi  := Substr(Tablas->TbSecCal,55,1)
SwLogNSi  = If(SwLogNSi ="1",.T.,.F.)
//------------------------------------------
SwAudito     := Substr(Tablas->TbParPla,14,1)
SwAudito      = If(SwAudito="1",.T.,.F.)
//------------------------------------------
DbSelectArea("User")

If Fieldpos("USCTRCLA")==0
	Msgalert("Reestructurar Usuarios","")
	Return
EndIf

If RecCount() == 0
   If Bloquea("USER",3)
       DbAppend1()
       Repl Codigo   With "DEMO"
       Repl Nivel    With 9
       Repl Nombre   With "DEMOSTRACION DE LA PLANILLA                       "
       Repl Clave    With Encrypt("Demo100$")
       cPermis1 = ""
       For xx = 1 To 250
            cPermis1 := cPermis1 + "S"
       Next xx
       repla Permis1   with cPermis1
       DbUnLock()
   EndIf
Endif
If User->(FieldPos("TIPLET")) == 0    
		Msgalert("Ir a Planilla de Configuracion y Regresar","")
		Return                                       
EndIf


*-------------------------------------------------------
DbSelectArea("Emp")
if Reccount() > 1
   MsgAlert("Realizar mantenimiento de File EMPRESA","Revisar")
   Return NIL
endif


//----------------------------------
Public xPerHis,xFecHis
//----------------------------------
If EMP->(FieldPos("EMFECHIS")) == 0 
		Msgalert("Reestructuras Empresa","")
		xPerHis := "190100"
		xFecHis := Date()
		Return
Else
		xPerHis := Emp->EmPerHis
		xFecHis := Emp->EmFecHis
EndIf
//----------------------------------

cEmCalEps   := Emp->EmCalEps

DbSetOrder(1)
ArrEmp  := LlenaEmp()
Seek "01"
If Eof()
   MsgAlert("Llamar a GGSOFT, Error en Configuraci�n","Revisar")
   DbCloseAll()
   SET RESOURCES TO
   Return (NIL)
EndIf

//---------------------------------------------------
//---------------------------------------------------
//---------------------------------------------------
//---------------------------------------------------
//--------Crear DEMO---------------------------------
//---------------------------------------------------
//---------------------------------------------------
//---------------------------------------------------
//  para Intertek  quitar los comentarios
//  Normalmente colocar los comentarios a // vDemo
If ( Upper(Left(Emp->EmDescri,8))="INTERTEK" .or. Upper(Left(Emp->EmDescri,6))="NIPPON"  )
    msgwait("Intertek","",.5)
    vDEMO = .F.  
EndIf
vDEMO = .F.  
//----------------------------------------------------
If vDemo
	Msgalert(tVerDem,"")
   cPermis1 = ""
   For xx = 1 To 250
            cPermis1 := cPermis1 + "S"
   Next xx
EndIf

//--------------------------------------------------
//--------------------------------------------------
If User->(Fieldpos("USCTRCLA")) == 0
	Msgalert("Reestructurar USER","")
	Return
EndIf
//-------------------------------------------------- 
If !vDemo
    
	If SwLogNSi
			//-------------------------------
			//-------------------------------
			//---Inicio Fin------------------
			//-------------------------------
			//-------------------------------
			DbSelectArea("User")
			If Via->(Fieldpos("Viusuari")) > 0
				If ( Empty(Via->ViCodigo) .or. Empty(Via->ViClave) ) .or.;
					Via->ViFecReg <> Date()
				Else
					xViUsuari = Via->ViUsuari
					//msgalert("11 " +xuser)
					//msgwait("Usuario : " + xViUsuari,"",4)
					xViClave  = Via->ViClave 
					cViFecReg = Via->ViFecReg
					cViHorReg = Via->ViHorReg
					cHorReg   = Val(Alltrim(Left(cViHorReg,2) + "." + Substr(cViHorReg,4,2)))
					cHorTime  = Val(Alltrim(Left(time(),2)    + "." + Substr(time()   ,4,2)))
					DifHor = cHorTime - cHorReg 
					
					If DifHor < 4
						SwIngNor = .T.	
						DbSelectArea("User")
						Seek xViUsuari
						If Found()
							 msgwait("Usuario activo * " + xViUsuari,"Confirmar",.5)
							 //msgalert("22 vi  " +xViUsuari)
							 cPermis1:= User->Permis1
							 cPermis2:= User->Permis2
							 cPermis3:= User->Permis3
							 cPermis4:= User->Permis4
							 cPermis5:= User->Permis5
							 cPermis6:= User->Permis6
							 cPermis7:= User->Permis7
							 cPermis8:= User->Permis8
							 TopUser := User->Codigo
							 TopNiv  := User->Nivel
							 If User->TamFon == 0
								   cTamFont := 1
							 Else
								   cTamFont := User->TamFon
							 EndIf
							 If User->TipLet == 0
								   cTtipLet := 1
								   cTtipLet := 1
							 Else
								   cTipLett := User->TipLet
							 EndIf
							 cTipBol   := User->TipBol
							 cTipIta   := User->TipIta
						Else
							 Msgalert("Usuario * " + xViUsuari ,"No Ubicado")
							 SwIngNor = .F.
						EndIf
					EndIf
					
				EndIf
			EndIf
			//msgalert("88 " +xuser)
			//------------------------------	
			If !SwIngNor
				PideUser(1,"Standart")
			Else
				DbSelectArea("User")
				Seek xViUsuari
				If Found()
					 msgwait("Usuario activo ** " + xViUsuari,"Confirmar",.5)
					 cPermis1:= User->Permis1
					 cPermis2:= User->Permis2
					 cPermis3:= User->Permis3
					 cPermis4:= User->Permis4
					 cPermis5:= User->Permis5
					 cPermis6:= User->Permis6
					 cPermis7:= User->Permis7
					 cPermis8:= User->Permis8
					 
					 TopUser := User->Codigo
					 TopNiv  := User->Nivel
					 If User->TamFon == 0
						   cTamFont := 1
					 Else
						   cTamFont := User->TamFon
					 EndIf
					 If User->TipLet == 0
						   cTtipLet := 1
						   cTtipLet := 1
					 Else
						   cTipLett := User->TipLet
					 EndIf
					 cTipBol   := User->TipBol
					 cTipIta   := User->TipIta
					 xUser 		:= xViUsuari
				Else
					 Msgalert("Usuario ** " + xViUsuari ,"No Ubicado")
				EndIf	
				//msgalert("22aaaaa vi  " +xViUsuari)
				//msgalert("22 xuser   " +xuser )
			EndIf
			//msgalert("99 " +xuser)
			//------------------------------
			If Via->(Fieldpos("Viusuari")) > 0
				DbSelectArea("Via")
				If Bloquea("Via",3)
					Repl Via->ViUsuari	with xViUsuari
					Repl Via->ViClave 	with xViClave   
					Repl Via->ViFecReg	with Date()
					Repl Via->ViHorReg	with Time() 
					DbUnlock()
					cEmpresa := 0
				EndIf
			EndIf
	Else
						
			PideUser(1,"Standart")

    EndIf	
   //-------------------------------
   //-------------------------------
   //-------------------------------
Else
   cEmpresa := 1
EndIf


//---------------------------------------------------
zPLame:= Substr(User->Permis1,251,1)   // Plame
zPlame:= If(zPlame="S",.t.,.f.)
zCorre:= Substr(User->Permis1,252,1)   // Correo 
zCorre:= If(zCorre="S",.t.,.f.)
zBole2:= Substr(User->Permis1,253,1)   // Boletas 2
zBole2:= If(zBole2="S",.t.,.f.)
zOtros:= Substr(User->Permis1,254,1)   // Otros
zOtros:= If(zOtros ="S",.t.,.f.)

zPlame:= .T.
zBole2:= .T.
zCorre:= .T.
zOtros:= .T.


//--------------------------------------------------
If !lPase
    CursorWait()
    set exclusive on
    DbCloseAll()
	msgalert("Sistema Abortado lPase","")
    Return (NIL)
EndIf
*-------------------------------------------------------------------------
DbSelectArea("Emp")
If cEmpresa < 1
    cEmpresa = 1
EndIf
Clave = Left(ArrEmp[cEmpresa],2)
Seek Clave
CodEmp    := Emp->EmCodigo
cEmGtrDia := Emp->EmGtrDia
cOrdPPG   := FOrdppg()

cAutRta = Substr(Emp->EmAviErr,61,1)
cAutRta = IIF(Empty(cAutRta),.f.,.t.)

cRetGra = Substr(Emp->EmAviErr,62,1)
cRetGra = IIF(Empty(cRetGra),.f.,.t.)

cEmDetCto := Substr(Emp->EmAviErr,35,1)
cEmDetCt2 := Substr(Emp->EmAviErr,36,1)
cEmDetAre := Substr(Emp->EmAviErr,37,1)

cEmDetCto := If(cEmDetCto="1",.T.,.F.)
cEmDetCt2 := If(cEmDetCt2="1",.T.,.F.)
cEmDetAre := If(cEmDetAre="1",.T.,.F.)

PUBLIC xTipPla   :=Emp->EmTipPla
PUBLIC cEmFrecue :=Emp->EmFrecue

CursorWait()
DbCloseAll()
set exclusive off

Define Image oImageL Filename "&RutaS\Hea_Sun1.JPG"
oImageL:LoadBmp("&RutaS\Hea_Sun1.JPG")

*----------------------------
*------Revisa MaeEst---------
*----------------------------
If !File("&rutaS\MaeEst.DBF")
	If !( File("RutaW\MaeEst.DBF") .and. File("RutaW\MaeEst.CDX") )
		Msgalert("Archivo MAEEST no ubicado. En Planvis5","Cargarlo")
		Return NIL
	Else
		LZCopyFile("&RutaW" + "\MAEEST"+".DBF" ,"&RutaS" + "\MAEEST.DBF" )
		LZCopyFile("&RutaW" + "\MAEEST"+".CDX" ,"&RutaS" + "\MAEEST.CDX" )
	EndIf
EndIf
If !File("&RutaS\Documen.DBT")
	Msgalert("Archivo Documento Incompleto","")
	Return NIL
EndIf

//hora1 = Time()
//msgwait("Hora Inicio ",Hora1,1)
CursorWait()
*---------------------------
AbreFiles()
DbSelectArea("Con")
MaxCon:=Reccount()
If MaxCon < 150
	MaxCon = 150
EndIf
*----------------------------
IF Audito->(Fieldpos("AU_OBSE2")) = 0
		Msgalert("Reestructurar archivo Auditoria","Au_Obse2")
		Return
EndIf

If RemRet->(Fieldpos("RRRMOTIN")) = 0
		Msgalert("Reestructurar REMRET","RrRmOtIn")
		Return
EndIf
CursorWait()

Nom_Logo()
CursorWait()

//----------
PARQTA(0)  // Parametros de Quinta
//----------
LAsiste()
//----------

//----------------------------------------
SwPdfCreator := Substr(Tablas->TbParPla,12,1)
SwPdfCreator  = If(SwPdfCreator="1",.T.,.F.)

//------Proc Pago Bonif Ext Gratific-----
cTbPBonGr := Substr(Tablas->TbSecCal,27,1)
cTbPBonGr = If(cTbPBonGr="1",.T.,.F.)
//------Proc Proyectos ------------------
SwProyec1 := Substr(Tablas->TbSecCal,44,1)
SwProyec1 = If(SwProyec1="1",.T.,.F.)

SwProyec2 := Substr(Tablas->TbSecCal,45,1)
SwProyec2 = If(SwProyec2="1",.T.,.F.)

SwProyec3 := Substr(Tablas->TbSecCal,46,1)
SwProyec3 = If(SwProyec3="1",.T.,.F.)

SwProCto  := Substr(Tablas->TbSecCal,50,1)
SwProCto  = If(SwProCto ="1",.T.,.F.)

SwProCt2  := Substr(Tablas->TbSecCal,51,1)
SwProCt2  = If(SwProCt2 ="1",.T.,.F.)

If (SwProyec2 .or. SwProyec3)
	cSaCtoCto = "C.Costo"
    cSaCtCto2 = "PROYECTO"
Else
	cSaCtoCto = "C.Costo"
    cSaCtCto2 = "C.Costo 2"
EndIf	

If SwProyec1
	Msgwait ("Proyecto 1 ","",.5)
EndIf

If SwProyec2
	Msgwait ("Proyecto 2 ","",.5)
EndIf

If SwProyec3
	MsgWait ("Proyecto 3 ","",.5)
EndIf

gTarSemN := Val(Substr(Emp2->EmPlaCas,139,1))
SwForAlt := IF(Val(Substr(Emp2->EmPlacas,12,1))>0,.T.,.F.)

SwTarNum := IF(Val(Substr(Emp2->EmPlacas,13,1))>0,.T.,.F.)
SwTarAlf := IF(Val(Substr(Emp2->EmPlacas,14,1))>0,.T.,.F.)
SwTarCC  := IF(Val(Substr(Emp2->EmPlacas,15,1))>0,.T.,.F.)
cRTarSem := IF(Val(Substr(Emp2->EmPlacas,120,1))=1,.T.,.F.)

//----------------------------------------
cTbAcmSub := Substr(Tablas2->TbNetPun,064,1)
cTbAcmSub := If(cTbAcmSub="1",.T.,.F.)
CalNue    := IF(Val(Substr(Tablas->TbParPla,13,1))>0,.t.,.f.)
//---------------------------------------
ArrPlan := LlenaPlan()
ArrPPag := LlenaPpag()
ArrBan  := LlenaBan()
ArrCdc  := LlenaCdc()
ArrCat  := LlenaCat()
ArrCto  := LlenaCto()
ArrCto2 := LlenaCt2()
ArrCto3 := LlenaCt3()
ArrAfp  := LlenaAfp()
ArrCon  := LlenaCon()
ArrAre  := LlenaAre()
ArrCar  := LlenaCar()
ArrSCa  := LlenaSCa()
*----------------------------
//hora4 = Time()
//msgwait("Hora 4",Hora4,1)
*----------------------------
ArrEstab  := LlenaEst()
ArrEstaD  := LlenaEsD()  // Ruc + Denomi
ArrPlaCa  := LLenaPlC()
ArrGruAs  := LLenaGrA()
*----------------------------
*----------------------------
ArrTEsta  := LlenaTa2("02",2,0)
ArrDoIde  := LlenaTa2("03",2,0)
ArrVia    := LlenaTa2("05",2,0)
ArrZona   := LlenaTa2("06",2,0)
ArrTTrab  := LlenaTa2("08",2,0)
ArrNivEd  := LlenaTa2("09",2,0)
ArrRegPe  := LlenaTa2("11",2,0)
ArrTCtra  := LlenaTa2("12",2,0)
ArrPerio  := LlenaTa2("13",2,0)
ArrPreSa  := LlenaTa2("14",2,0)
ArrSiTra  := LlenaTa2("15",2,0)
ArrModPa  := LlenaTa2("16",2,0)
ArrMotFi  := LlenaTa2("17",2,0)
ArrModFo  := LlenaTa2("18",2,0)
ArrVinFa  := LlenaTa2("19",2,0)
ArrBajDH  := LlenaTa2("20",2,0)
ArrSubsi  := LlenaTa2("21",2,2)
ArrVacac  := LlenaTa2("21",2,3)
ArrInasi  := LlenaTa2("21",2,1)
ArrTiCom  := LlenaTa2("23",2,0)
ArrCatOc  := LlenaTa2("24",2,0)  ////////////////
ArrDoPat  := LlenaTa2("27",2,0)
ArrConve  := LlenaTa2("25",2,0)
ArrRegSa  := LlenaTa2("32",2,0)  ///////////////
ArrRegLa  := LlenaTa2("33",2,0)  ///////////////
ArrCatGe  := LlenaTa2("40",2,0)  ////////////////
*----------------------------
ArrRgEdu  := LlenaTa2("50",2,0)
ArrTiIns  := LlenaTa2("51",2,0)
ArrMFIIN  := LlenaTa2("55",2,0)
ArrSESP   := LlenaTa2("35",2,0)    // Situacion especial
*----------------------------
//ArrDestT  := LlenaDest(1)
//ArrDestF  := LlenaDest(2)
*--------Contratos-----------
ArrRgLac  := LlenaTa2("48",2,0)  ////////////////
ArrModal  := LlenaTa2("43",2,0)  ////////////////
ArrSbMod  := LlenaTa2("44",2,0)  ////////////////
ArrGrOcu  := LlenaTa2("45",2,0)  ////////////////
ArrTiMon  := LlenaTa2("46",2,0)  ////////////////
ArrTRmVa  := LlenaTa2("47",2,0)  ////////////////
*----------------------------
CursorWait()

dbSelectArea("Emp")
Seek CodEmp

Public IndPer    :=Emp->EmIndPer
PUBLIC xClapla   :=Emp->EmClaPla
PUBLIC xPerPag   :=Emp->EmPerpag
Public xSufijo   :=Substr(xPerPag,5,1)
PUBLIC xLogo     :=Alltrim(Emp->EmDesBre)
PUBLIC xLogoP    :=Alltrim(Left(xLogo,5))+"  "
PUBLIC xEmpresa  :=Alltrim(Emp->EmDescri)
PUBLIC xDirecc   :=Alltrim(Emp->EmDirecc)
PUBLIC cFecRep   :=Emp->EmFecRep
PUBLIC xRegUni   :=Emp->EmRegUni

IniLogo = Left(Upper(Alltrim(xLogo)),1)
PUBLIC cEmPresta :=Emp->EmPresta,SwToGrRm
Public cAvi01,cAvi02,cAvi03,cAvi04,cAvi05,cAvi06,cAvi07,cAvi08,cAvi09,cAvi10,cAviErr,cAviMay  
Public cAvi11,cAvi12,cAvi13,cAvi14,cAvi15,cAvi16,cAvi17,cAvi18,cAvi19,cAvi20
Public cAvi21,cAvi22,cAvi23,cAvi24,cAvi25,cAvi26,cAvi27,cAvi28,cAvi29,cAvi30
Public cAvi31,cAvi32,cAvi33,cAvi34,cAvi35,cAvi36,cAvi37,cAvi38,cAvi39,cAvi40
Public cAvi41,cAvi42,cAvi43,cAvi44,cAvi45,cAvi46,cAvi47,cAvi48,cAvi49,cAvi50
Public cAvi51,cAvi52,cAvi53,cAvi54,cAvi55,cAvi56,cAvi57,cAvi58,cAvi59,cAvi60
Public cAvi61,cAvi62,cAvi63,cAvi64,cAvi65,cAvi66,cAvi67,cAvi68,cAvi69,cAvi70             
Public cAvi71,cAvi72,cAvi73,cAvi74,cAvi75,cAvi76,cAvi77,cAvi78,cAvi79,cAvi80
Public cAvi81,cAvi82,cAvi83,cAvi84,cAvi85,cAvi86,cAvi87,cAvi88,cAvi89,cAvi90
Public cAvi91,cAvi92,cAvi93,cAvi94,cAvi95,cAvi96,cAvi97,cAvi98,cAvi99
Public cAvi100,cAvi101,cAvi102,cAvi103,cAvi104,cAvi105,cAvi106,cAvi107,cAvi108,cAvi109,cAvi110
Public cAvi111,cAvi112,cAvi113,cAvi114,cAvi115,cAvi116,cAvi117,cAvi118,cAvi119,cAvi120          
Public cEmReAf01,cEmReAf02,cEmReAf03,cEmReAf04,cEmReAf05,cEmReAf06,cEmReAf07,cEmReAf08
Public aEmReAf01,aEmReAf02,aEmReAf03,aEmReAf04,aEmReAf05,aEmReAf06,aEmReAf07,aEmReAf08   
Public cEmcDiaVac, cEmVacVta, cTbDiCtVa, cTbAdeVac, aEmcDiaVac, aEmVacVta, aTbDiCtVa, aTbAdeVac,oFontW
cTbCtsPYM := IF(Val(Substr(Tablas->TbUT,61,1))>0,.T.,.F.)
cTbPlaMic := IF(Val(Substr(Tablas->TbUT,62,1))>0,.T.,.F.)
cTbPlMeCs := IF(Val(Substr(Tablas->TbUT,63,1))>0,.T.,.F.)
//-------------------------------------
//------Remun Descanso Medico------
cTbRmDMed  := aScan(ArrCon,substr(Tablas2->TbDatBol,100,3))
If cTbRmDMed  <= 0
   cTbRmDMed := 1
EndIf

If cTbRmDMed > 1
	aTbRmDMed = BuscaCon(left(Arrcon[cTbRmDMed],3),.f.)
Else
	aTbRmDMed = ""
EndIf
//------Remun Subsidio Incapacidad-----
cTbRmSubs  := aScan(ArrCon,substr(Tablas2->TbDatBol,103,3))
If cTbRmSubs  <= 0
   cTbRmSubs := 1
EndIf
If cTbRmSubs > 1
	aTbRmSubS = BuscaCon(left(Arrcon[cTbRmSubs],3),.f.)
Else
	aTbRmSubS = ""
EndIf
//------Remun Subsidio Maternidad------
cTbRmSubM  := aScan(ArrCon,substr(Tablas2->TbDatBol,109,3))
If cTbRmSubM  <= 0
   cTbRmSubM := 1
EndIf
If cTbRmSubM > 1
	aTbRmSubM = BuscaCon(left(Arrcon[cTbRmSubM],3),.f.)
Else
	aTbRmSubM = ""
EndIf
//------Dias de Lic.Sin Goce-----------
cTbPerSGo  := aScan(ArrCon,substr(Tablas2->TbDatBol,52,3))
If cTbPerSGo  <= 0
   cTbPerSGo := 1
EndIf
If cTbPerSGo > 1
	aTbPerSGo = BuscaCon(left(Arrcon[cTbPerSGo],3),.f.)
Else
	aTbPerSGo = ""
EndIf
//-------------------------------------

//msgalert("aaaa")

//-------------
fReAfxx()     // Puede Hacer Ext al Modulo 
//-------------
//msgalert("bbbb") 

IniLogo = Left(Upper(Alltrim(xLogo)),1)
//--------------------------------
//-----------DEMO-----------------
//--------------------------------
If vDemo 
	IniLogo  = ""
	xEmpresa = "D E M O"
	xRegUNI  = "20304050607"
	xLogo    = "DEMO"
	xDirecc  = "AV.LOS DESCONOCIDOS 9988"
EndIf
//--------------------------------
//--------------------------------
//--------------------------------
dbSelectArea("Emp")
If xClaPla <= 0 .or. xClaPla >= 9
   If Bloquea("EMP",3)
      Repl Emp->EmClaPla With 1
      xClaPla := 1
      DbUnlock()
   EndIf
EndIf

If xTipPla <= 0 .or. xTipPla >= 6
   If Bloquea("EMP",3)
      Repl Emp->EmTipPla With 1
      xTipPla := 1
      DbUnlock()
   EndIf
EndIf

//msgalert("cccc")
//-----------------------
//-----------------------
//-----------------------
//-----------------------
FTiCaPla()
//-----------------------
//-----------------------
//-----------------------
//msgalert("dddd")
//-----------------------
VeNuePer()
//-----------------------

//hora7 = Time()
//msgwait("Hora 7",Hora7,1)

//////////////////////ValActi(0,0)   // Demora Bastante

//hora8 = Time()
//msgwait("Hora 8",Hora7,1)

//-----------------------
dbSelectArea("Tablas")
cTbSelCto:= TbSelCto
//-----------------------
//-----------------------
//-----------------------
cTbCsdAfp  := Val(Substr(Tablas->TbSecCal,24,1))
cTbCsdEsa  := Val(Substr(Tablas->TbSecCal,25,1))
If cTbCsdAfp = 1
   cTbCsdAfp = .T.
Else
   cTbCsdAfp = .F.
EndIf
If cTbCsdEsa = 1
   cTbCsdEsa = .T.
Else
   cTbCsdEsa = .F.
EndIf

CursorArrow()

//msgalert(cTamFont)
//-----------------------
//-----------------------
DbSelectArea("FMT")
//-----------------------
//msgalert("eeee")
//-----------------------
rPrevia1 = "Planilla Previa - 1"
rPrevia2 = "Planilla Previa - 2"
rPrevia3 = "Planilla Previa - 3"
rPrevia4 = "Planilla Previa - 4"
rPrevia5 = "Planilla Previa - 5"
rPrevia6 = "Planilla Previa - 6"
rPrevia7 = "Planilla Previa - 7"
rPrevia8 = "Planilla Previa - 8"
rPrevia9 = "Planilla Previa - 9"
rPrevia10= "Planilla Previa - 10"
rPrevia11= "Planilla Previa - 11"
rPrevia12= "Planilla Previa - 12"
rPrevia13= "Planilla Previa - 13"
rPrevia14= "Planilla Previa - 14"
rPrevia15= "Planilla Previa - 15"

rPreviaV = "Planilla Previa - Vacaciones"
rPreviaG = "Planilla Previa - Gratificaciones"
rPreviaG2= "Planilla Previa - Gratificaciones - 2"
Set Order To 1
//------------
Seek "PREVIA  "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia1 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA2 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia2 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA3 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia3 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA4 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia4 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA5 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia5 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA6 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia6 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA7 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia7 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA8 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia8 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA9 "
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia9 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA10"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia10 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA11"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia11 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA12"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia12 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA13"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia13 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA14"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia14 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREVIA15"
If Found() .and. !Empty(Fmt->FmObserv)
   rPrevia15 = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREV_VAC"
If Found() .and. !Empty(Fmt->FmObserv)
   rPreviaV = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREV_GRA"
If Found() .and. !Empty(Fmt->FmObserv)
   rPreviaG = Alltrim(Fmt->FmObserv)
Endif
//------------
Seek "PREV_GR2"
If Found() .and. !Empty(Fmt->FmObserv)
   rPreviaG2 = Alltrim(Fmt->FmObserv)
Endif
//msgalert("ffff")
//-------------------------------
Upd_Avi()       // Actualiza cAviERR
//-------------------------------
FArTDMes()		// Se Ejecuta la carga de Arreglo anterior
//-------------------------------
//------Proc Vac Separadamente-----------
cTbPVaSep := Substr(Tablas->TbSecCal,26,1)
cTbPVaSep = If(cTbPVaSep="1",.T.,.F.)
//----------------------------------------
IIF(Substr(Tablas2->TbRcPara,61,1)="1",SwLogoGe:=.T.,SwLogoGe:=.F.)
//----------------------------------------
If FMT->(FieldPos("FMNOMEPS")) == 0                                           
		Msgalert("Reestructurar Formatos","URGENTE")
		Return
EndIf
If User->(FieldPos("TIPLET")) == 0                                           
		Msgalert("Reestructurar Usuarios","URGENTE")
		Return
EndIf
If Per->(FieldPos("PEDICVAC")) == 0                                           
		Msgalert("Reestructurar Personal","URGENTE")
		Return
EndIf
If FMT->(FieldPos("FMPARINI")) == 0                                           
		Msgalert("Reestructurar Formatos","URGENTE")
		Return
EndIf
If HVaca->(FieldPos("VACONVSS")) == 0                                           
		Msgalert("Reestructurar HVacaci","URGENTE")
		Return
EndIf

If RemRet->(FieldPos("RRRTPGAN")) == 0                                           
		Msgalert("Reestructurar REMRET","URGENTE")
		Return
EndIf

If Tablas2->(FieldPos("TBTABL21")) = 0                                           
		Msgalert("Reestructurar Tablas2 ","URGENTE")
		Return
Else
		AnaTab21()
EndIf

If Tablas2->(FieldPos("TBVLEY_P")) = 0                                           
		Msgalert("Reestructurar Tablas2 ","URGENTE")
		Return
Endif

If Tablas2->(FieldPos("TBMENSA1")) = 0                                           
		Msgalert("Reestructurar Tablas2 ","URGENTE")
		Return
Endif

If User->(FieldPos("USENUSO")) == 0                                           
		Msgalert("Reestructurar Usuarios","URGENTE")
		Return
EndIf
//msgalert("gggg")
//---------------------------------------
Bus_Block(xPerPag)
//---------------------------------------
//msgalert(xuser)
Upd_Act_User(.T.)
//msgalert(xuser)
//---------------------------------------
Lee_Planper()
If Planper->(Fieldpos("PLANEXO")) = 0
	Msgalert("Reestructurar PLANPER","PLANEXO")
	Return
EndIf
//msgalert("hhhh")
//---------------------------------------
dbSelectArea("Emp")

   DEFINE BRUSH oBrush COLOR nRGB(000,128,128)
   DEFINE CURSOR oCur RESOURCE "Dedo"
     
   DEFINE WINDOW oWnd FROM 1, 0 TO 24, 79 ;
		BRUSH oBrush ;
		ICON "_PLANVIS1.ICO";
		TITLE  xLogo 	+ " ** PLANVIS 2021 ** " +;
		Left(xMesAno,3) + " / " + Str(xAnoPro,4) + " / Periodo : " + xPerPag +;
		+ IF(cEmFrecue="S"," ==>> Del " + DtoC(xFecIni) + " Al " + DtoC(xFecFin),"") + "  Usuario " + ;
		xUser + "  ==> " + RutaS  + ;
		Space(30) + "** Periodo actual en planilla  " + xPerPlanper + " **" ; 
		MENU  BuildMenu()
	  
	  cLogPla = "LOG_PLA1"
 
	  If File(RutaP+"\&cLogPla" + ".BMP") 
			@ 3, 0 IMAGE oImage  SIZE 1400, 680  OF oWnd ADJUST
						 oImage:LoadBmp(RutaP+"\&cLogPla" + ".BMP" )
	  Else
			Msgwait("Logo no ubicado ",cLogPla,.5)
	  EndIf			
	 //---------------------------------
	 DEFINE FONT oFontW1 NAME "Arial Narrow"        SIZE 0,-25  BOLD ITALIC
	 If vDEMO
			@ 350,580  SAY oSay1 PROMPT tVerDem  SIZE 270,035 PIXEL BORDER COLOR CLR_WHITE, CLR_RED  OF oWnd  FONT oFontW1
	 EndIf	
	 @ 080,600  SAY oSay1 PROMPT "Periodo : " + Left(xMesAno,3) + " / " + Str(xAnoPro,4) SIZE 210,035 PIXEL BORDER COLOR RGB(255,255,000),RGB(000,000,255) OF oWnd  FONT oFontW1
	 //---------------------------------
    FontGene(cTipLetra,cTamFont,cTipBold,cTipItal)
    DEFINE BUTTONBAR oBar 3D OF oWnd CURSOR oCur SIZE 60,60    // BOT_GRA
	
	
    DEFINE BUTTON RESOURCE "Cliente32" flat OF oBar;
       TOOLTIP "Mantenimiento de Personal";
       ACTION a_Per(xPlaCat,.F. )   ;
	   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
	  

	DEFINE BUTTON RESOURCE "BMP_FILES" FLAT   OF oBar;   // BOT_GRA
       TOOLTIP "Revisi�n de Conceptos";
	   ACTION B_Con(vDemo,.f.)     ;
	   When Substr(cPermis1,026,1) = "S"  .or. SwGbGa
 	 
    DEFINE BUTTON RESOURCE "Insert1" FLAT   OF oBar;
       TOOLTIP "Relacion de contratos";
	   ACTION A_Contra()  ;
	   When Substr(cPermis1,023,1) = "S"  .or. SwGbGa
	   
	DEFINE BUTTON RESOURCE "BMP_AGREGAR" FLAT   OF oBar;
       TOOLTIP "Registra Movimiento variable";
	   ACTION b_RemPer(0,0)  	;
	   When Substr(cPermis1,035,1) = "S"  .or. SwGbGa
	  
	DEFINE BUTTON RESOURCE "BMP_MODIFICAR" FLAT  OF oBar;
	   TOOLTIP "Emite Boletas Hist�ricas por Trabajador";
	   ACTION P_BolHis("BOLETAS",0 ) ;
	   When Substr(cPermis1,174,1) = "S"  .or. SwGbGa  //////////////////////
			 
	DEFINE BUTTON RESOURCE "BMP_REPORTS" FLAT   OF oBar;
	   TOOLTIP "Emite Boletas de Remuneraciones por Trabajador";
	   ACTION SelExeBol(0,0) 	;
	   When Substr(cPermis1,063,1) = "S"  .or. SwGbGa
	 
    DEFINE BUTTON RESOURCE "BMP_FONTS" FLAT   OF oBar;
       TOOLTIP "Define Tipo de Letra";
       ACTION  PideFont()           		
	   
	DEFINE BUTTON RESOURCE "Imprimir2" FLAT   OF oBar;
       TOOLTIP "Define Tipo de Impresora";
       ACTION PrinterSetup()           		
	   
	DEFINE BUTTON RESOURCE "PRODS32" FLAT  OF oBar;
       TOOLTIP "Colores del Sistema";
       ACTION  Sel_Color() 
	   
	DEFINE BUTTON RESOURCE "PROV32" FLAT   OF oBar;
       TOOLTIP "Actividad de Usuarios";
       ACTION  U_User1(1)       			   
	   
	DEFINE BUTTON RESOURCE "BMP_INTERNET" OF oBar ;
        ACTION ( ShellExecute(,"open","www.ggsoft-planillas-tutorial.blogspot.com",,,1)  )           ;
              PROMPT "Ayuda" ;
              TOOLTIP "Tutorial del sistema de Planilla en YouTube"  // GROUP
			  
	DEFINE BUTTON RESOURCE "BMP_INDICES" FLAT   OF oBar;
       TOOLTIP "Revisa y Editar Archivo Seleccionado";
       ACTION  U_RvEdSe()    

	DEFINE BUTTON RESOURCE "SALIR2" FLAT   OF oBar;
       TOOLTIP "Salir del sistema";
       ACTION (Upd_Act_User(.F.),oWnd:End())      			   

   SET MESSAGE OF oWnd ;
		TO "G"+chr(38)+"G Consultor�a en Inform�tica SAC * (051) -> (965)383-755 - 796-9787   ggsoftperu @ yahoo.es"  ;
		CENTERED	   
      	   
	DEFINE MSGITEM oItem OF oWnd:oMsgBar ;
	   BITMAPS "&RutaP\OPEN.BMP" ;
	   ACTION U_CamEmp(oWnd," ** PLANVIS MENSUAL 2021 ** ",0,1) ;
	   TOOLTIP "Cambio de Empresa" 
	   
  
    DEFINE MSGITEM oItem OF oWnd:oMsgBar ;
       BITMAPS "&RutaP\CALC.BMP" ;
       ACTION  WinExec("calc") ;
       TOOLTIP "Calculadora"

    DEFINE MSGITEM oItem OF oWnd:oMsgBar ;
       BITMAPS "&RutaP\PRINTER.BMP" ;
       ACTION PrinterSetup() ;
       TOOLTIP "Configura Impresora"

    DEFINE MSGITEM oItem OF oWnd:oMsgBar ;
       BITMAPS "&RutaP\EXIT.BMP" ;
       ACTION (Upd_Act_User(.F.),oWnd:End()) ;
       TOOLTIP "Salir del Sistema"
	   
    DEFINE MSGITEM oItem OF oWnd:oMsgBar ;
               PROMPT "WWW" ;
               TOOLTIP "Correo WEB" ;
               ACTION conecta( "WWW.GOOGLE.COM" )

    ACTIVATE WINDOW oWnd MAXIMIZED;
              ON INIT ( oWnd:oMsgBar:DateOn(),;
						oWnd:oMsgBar:KeybOn(),;
						oWnd:oMsgBar:ClockOn(),;
				  	    oItem:nClrPane := CLR_BLUE, oItem:nClrText := CLR_WHITE 	) 
	Upd_Act_User(.F.)
	
    CursorWait()
    set exclusive on
    DbCloseAll()
    SET RESOURCES TO
	
RETURN( NIL )




*----------------------------------------
FUNCTION BuildMenu()
*----------------------------------------
   local oMenu := NIL
   Local hRecurso := GetResources()    // BOT_GRA
   Local ggTitAFP,ggTitAfp2
  
   MENU oMenu
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
    MENUITEM  "&Archivos"
      MENU
	  
         MENUITEM "&Empresas"    RESOURCE (hRecurso,"LIB")  ;
            ACTION a_Emp(.t.) ;
            MESSAGE  "Mantenimiento de Empresas" ;
			When Substr(cPermis1,001,1) = "S"  .or. SwGbGa
			
         MENUITEM "&Establecimiento";
            ACTION A_MaeEst() ;
            MESSAGE  "Establecimientos Fiscales, Empresas de destaque y las que nos detascan personal" ;
			When Substr(cPermis1,001,1) = "S"   .or. SwGbGa
		
			SEPARATOR		

         MENUITEM "&Tablas Varias (T-Registro / PLAME)"  RESOURCE (hRecurso,"DBFS")  ;
            ACTION a_Tabrt2() ;
            MESSAGE  "Mantenimiento de las Tablas Varias, incluyendo principalmente las del -->> P L A M E" ;
			When  Substr(cPermis1,002,1) = "S"  .or. SwGbGa

         SEPARATOR

         MENUITEM "&Bancos (Ctas de la empresa)"    RESOURCE (hRecurso,"PAGOS16")  ;
            ACTION a_Ban();
            MESSAGE  "Mantenimiento de las cuentas Bancarias de la empresa"  ;
			When Substr(cPermis1,003,1) = "S"  .or. SwGbGa

         MENUITEM "&Per�odos de Pago"    RESOURCE (hRecurso,"PERIODO16")  ;
            ACTION a_Ppg() ;
            MESSAGE  "Mantenimiento de los Periodos de Pago"   ;
			When Substr(cPermis1,004,1) = "S"  .or. SwGbGa

			
		 MENUITEM "&Tipos de Empleado"   RESOURCE (hRecurso,"PERIODO16")  ;
            ACTION a_Temp() ;
            MESSAGE  "Mantenimiento de los Tipos de empleado"  ;
			When Substr(cPermis1,005,1) = "S"  .or. SwGbGa
			
		MENUITEM "&Divisiones"          RESOURCE (hRecurso,"PERIODO16")  ;
            ACTION a_Divi() ;
            MESSAGE  "Mantenimiento de las Divisiones"    ;
			When Substr(cPermis1,006,1) = "S"  .or. SwGbGa	
	
         SEPARATOR	
		 
		 MENUITEM "&Tablas Educativas" RESOURCE (hRecurso,"BUSCAR") 
                MENU         PopUp
					 MENUITEM "&Institutos Educativos"    RESOURCE (hRecurso,"HOME")  ;
						ACTION a_InsEdu() ;
						MESSAGE  "Mantenimiento de los Insitutos Educativos"  ;
						When Substr(cPermis1,007,1) = "S"  .or. SwGbGa
						
					 MENUITEM "&Carreras Educativas"    RESOURCE (hRecurso,"A-Z")  ;
						ACTION a_CarEdu() ;
						MESSAGE  "Mantenimiento de las carreras Educativas"  ;
						When Substr(cPermis1,007,1) = "S"	 .or. SwGbGa
		
					 SEPARATOR		
					 
					 MENUITEM "&Institutos y sus Carreras"    RESOURCE (hRecurso,"INDEX")  ;
						ACTION a_InsCar() ;
						MESSAGE  "Mantenimiento de los Institutos y sus carreras Educativas" ;
						When Substr(cPermis1,007,1) = "S"  .or. SwGbGa
				ENDMENU	
				
		 SEPARATOR
	 
		MENUITEM cSaCtoCto  RESOURCE (hRecurso,"BRWSMAL")  ;
            ACTION   a_cc() ;
            MESSAGE  "Mantenimiento de los " + cSaCtoCto ;
			When Substr(cPermis1,008,1) = "S"  .or. SwGbGa
			

		MENUITEM cSaCtCto2  RESOURCE (hRecurso,"BRWSMAL")  ;
				ACTION IF(SWProyec2,A_CCPry2(),a_cc2()) ;
				MESSAGE  "Mantenimiento de los " + cSaCtCto2 ;
				When Substr(cPermis1,009,1) = "S"  .or. SwGbGa
					
		 SEPARATOR 
		
         MENUITEM "&A F P "   RESOURCE (hRecurso,"CODE") ;
                      ACTION a_Afp(0,1) ;
                      MESSAGE  "Mantenimiento de A.F.P."  ;
					  When Substr(cPermis1,010,1) = "S"  .or. SwGbGa

    	SEPARATOR
		
		MENUITEM "&Cargos" RESOURCE (hRecurso,"BRWSMAL") ;
            ACTION a_cargos(1) ;
			When Substr(cPermis1,011,1) = "S"  .or. SwGbGa

         MENUITEM "&Areas de Trabajo" RESOURCE (hRecurso,"BRWSMAL") ;
            ACTION a_Area(1) ;
            MESSAGE  "Mantenimiento de las Areas de Trabajo "   ;
			When Substr(cPermis1,012,1) = "S"  .or. SwGbGa
			
		MENUITEM "&Feriados" RESOURCE (hRecurso,"BRWSMAL") ;
            ACTION a_Fer() ;
            MESSAGE  "Mantenimiento de las Dias feriados "   ;
            When Substr(cPermis1,013,1) = "S"	 .or. SwGbGa
			
		SEPARATOR

         MENUITEM "&Condiciones"  RESOURCE (hRecurso,"BRWSMAL") ;
            ACTION a_Condi() ;
            MESSAGE  "Mantenimiento de Condiciones de los Trabajadores";
			When Substr(cPermis1,014,1) = "S"  .or. SwGbGa
			

         MENUITEM "&Categor�as"  RESOURCE (hRecurso,"BRWSMAL") ;
            ACTION a_Cate() ;
            MESSAGE  "Mantenimiento de las Categor�as de los Trabajadores" ;
			When Substr(cPermis1,015,1) = "S"  .or. SwGbGa

		 SEPARATOR	
		 SEPARATOR
		 
         MENUITEM "&Personal" RESOURCE (hRecurso,"CLIENTE16") 
         MENU         PopUp
                   MENUITEM "Mantenimiento"  RESOURCE (hRecurso,"CLIENTE16") ;
                   ACTION a_Per(xPlacat,.F. ) ;
                   MESSAGE  "Mantenimiento del file de Personal" ;
				   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
				   
			       SEPARATOR
					   
				   MENUITEM "Mantenimiento (Seleccion de campos)"  RESOURCE (hRecurso,"CLIENTE16") ;
					ACTION a_Per(xPlacat,.T. ) ;
					MESSAGE  "Mantenimiento del file de Personal con selecci�n de campos" ;
					When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
				   
				   SEPARATOR
				   
					   MENUITEM "&ATAJOS" RESOURCE (hRecurso,"CLIENTE16") 		
							   //---------------------------------
							Menu PopUp
							   MENUITEM "Registra Importes Fijos"  RESOURCE (hRecurso,"CLIENTE16") ;
							   ACTION a_PerRem() ;
							   MESSAGE  "Registro de importes fijos como Konstantes, Remuneraciones y Descuentos al Personal" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   SEPARATOR
				
							   MENUITEM "Personal - Modificaciones r�pidas ( Categorias PLAME, Otros ) * Atajos"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT3("Per",0) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Categorias PLAME y Otros ) * Atajos"  ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas de varios campos (Parte 1)* Atajos"  RESOURCE (hRecurso,"TOGGLE");
							   ACTION a_CatRT3("Per",1) ;
							   MESSAGE  "Personal. Modificaciones r�pidas de varios campos con atajos. C.Cto, Area, Cargos, Bco, Cuentas, T.Cta., AFP, Categ, Condic, Tip Trab, Tip Contrato, Establecim, AFP MIX" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas de varios campos (Parte 2)* Atajos"  RESOURCE (hRecurso,"TOGGLE");
							   ACTION a_CatRT3("Per",2) ;
							   MESSAGE  "Personal. Modificaciones r�pidas de varios campos con atajos. Sexo, Fec.Nac.,Ubic.Geog.,Dir,Area,Ocup.Sunat,Sit Educ,Afil.EsSalud,Domic,Aseg.Pens,Seg.Med,Situ.Trab,...." ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa

							   SEPARATOR
							   
							   MENUITEM "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (BOLETAS)"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT4(0) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (Para Boletas de Pago)" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE RENTA)"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT4(1) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE RENTA)" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE CTS)"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT4(2) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE CTS)" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE UTILIDAD)"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT4(3) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS DE UTILIDAD)" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							   MENUITEM "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS-OTROS)"   RESOURCE (hRecurso,"TOGGLE") ;
							   ACTION a_CatRT4(4) ;
							   MESSAGE  "Personal - Modificaciones r�pidas (Correos, Habilitaciones) * Atajos (CERTIFICADOS-OTROS)" ;
							   When Substr(cPermis1,016,1) = "S"  .or. SwGbGa
							   
							EndMenu
							   //----------------------------------	
					 
							
					   SEPARATOR
					   
					   MENUITEM "Relaci�n de Periodos Laborales"  RESOURCE (hRecurso,"WRITE");
					   ACTION a_PerLab() ;
					   MESSAGE  "Relaci�n de los Periodos Laborales de todos los trabajadores" ;
					   When Substr(cPermis1,017,1) = "S"  .or. SwGbGa
					   
					   SEPARATOR
					   
					   MENUITEM "Derechos Habientes"  RESOURCE (hRecurso,"NEW")   ;
					   ACTION a_CarRT2() ;
					   MESSAGE  "Registro de los Derecho habientes" ;
					   When Substr(cPermis1,018,1) = "S"  .or. SwGbGa
					   
					   MENUITEM "Relaci�n de los Derechos Habientes"  RESOURCE (hRecurso,"IMPRE16") ;
					   ACTION a_RelDH() ;
					   MESSAGE  "Relaci�n de los Registro de los Derecho habientes"  ;
					   When Substr(cPermis1,018,1) = "S"  .or. SwGbGa
					   
					   SEPARATOR
					   SEPARATOR
					   SEPARATOR
					   
					   MENUITEM "C O N T R A T O S "   RESOURCE (hRecurso,"BROWSE")
					   
							Menu PopUp
							       SEPARATOR
								   SEPARATOR
								   
								  	   
								   MENUITEM "   Importaci�n masivo de Contratos"  RESOURCE (hRecurso,"WRITE");
								   ACTION C_ImpCon();
								   MESSAGE  "Genera Temporal de Contratos para Marca Masiva de Contratos";
								   When Substr(cPermis1,019,1) = "S"  .or. SwGbGa
								   
								   MENUITEM "     Revisa/Actualiza Archivo de contratos"  RESOURCE (hRecurso,"BROWSE");
								   ACTION C_RvCont();
								   MESSAGE  "Revisa Archivo Temporal de contratos" ;
								   When Substr(cPermis1,019,1) = "S"  .or. SwGbGa
							   
								   SEPARATOR
								   SEPARATOR
							   
								   MENUITEM "     Contratos"  RESOURCE (hRecurso,"NEW") ;
								   ACTION a_Contra() ;
								   MESSAGE  "Revisi�n de Contratos. Formato para importar"  ;
								   When Substr(cPermis1,019,1) = "S"  .or. SwGbGa
								   
								   MENUITEM "     Modifica datos de contratos"  RESOURCE (hRecurso,"BROWSE");
								   ACTION RvContra(0);
								   MESSAGE  "Modifica datos de contratos actuales" ;
								   When Substr(cPermis1,019,1) = "S"  .or. SwGbGa
								   
								   MENUITEM "     Relaci�n de Contratos por Vencimiento"  RESOURCE (hRecurso,"DBFS") ;
								   ACTION a_RelCon() ;
								   MESSAGE  "Relaci�n de Contratos e Impresi�n de Contratos";
								   When Substr(cPermis1,019,1) = "S"  .or. SwGbGa
								   
								   SEPARATOR
								   SEPARATOR
								   SEPARATOR
								   SEPARATOR
								   
								   MENUITEM "  &Documentos (Contratos)"  RESOURCE (hRecurso,"BROWSE")   ;
									ACTION a_Docume("9999",0);
									MESSAGE "Mantenimiento de los Documentos, Cartas, Contratos, etc. "   ;
									When Substr(cPermis1,019,1) = "S"   .or. SwGbGa
					
									MENUITEM "  &Tabla de Documentos (Contratos)"  RESOURCE (hRecurso,"BROWSE");
									ACTION a_TabDoc();
									MESSAGE "Mantenimiento de la Tabla de Documentos para el Modulo de Contratos";
									When Substr(cPermis1,019,1) = "S"  	 .or. SwGbGa
					
								   SEPARATOR
								   SEPARATOR
								   
							EndMenu	
					   
					   SEPARATOR
					   SEPARATOR
					   SEPARATOR

					   MENUITEM "P a d r o n e s"     RESOURCE (hRecurso,"WRITE")
					   Menu Popup
						   MENUITEM "Padrones de Personal"   RESOURCE (hRecurso,"IMPRE16")   ;
						   ACTION a_PerPad(0) ;
						   MESSAGE  "Padrones de Personal"     ;
						   When Substr(cPermis1,020,1) = "S"  .or. SwGbGa
						   
						   SEPARATOR
						   
						   MENUITEM "Reportes adicionales de Personal" RESOURCE (hRecurso,"IMPRE16")  ;
						   ACTION a_ReAdPe() ;
						   MESSAGE "Reportes adicionales de Personal (Tiempo de servicio, Cumplea�os)";
						   When Substr(cPermis1,020,1) = "S" .or. SwGbGa
						   
						   
						   SEPARATOR
						   
						   MENUITEM "Reportes Anuales de Personal (T.Serv.,Cumpl.) " RESOURCE (hRecurso,"IMPRE16")  ;
						   ACTION a_Peranu() ;
						   MESSAGE "Reportes adicionales de Personal. Vista Anual (Tiempo de servicio, Cumplea�os)";
						   When Substr(cPermis1,020,1) = "S" .or. SwGbGa

						   
						   SEPARATOR
						   SEPARATOR
						   SEPARATOR

						   MENUITEM "Ingresos masivos"  RESOURCE (hRecurso,"BRWSMAL");
						   ACTION IM_Perso() ;
						   MESSAGE  "Permite registrar los Ingresos Masivos mostrando el file completo de personal";
						   When Substr(cPermis1,020,1) = "S"  .or. SwGbGa
						   
						   MENUITEM "Renuncias masiva"   RESOURCE (hRecurso,"BROWSE");
						   ACTION R_PerLab() ;
						   MESSAGE  "Permite registrar las Renuncias Masivas mostrando el file completo de personal"   ;
						   When Substr(cPermis1,020,1) = "S"  .or. SwGbGa
						   
						   SEPARATOR
						   
						   MENUITEM "Act.Ingres.y Renuncias masivas en Pers.y Per.Lab."   RESOURCE (hRecurso,"BRWSMAL");
						   ACTION U_PerLab() ;
						   MESSAGE  "Actualiza Ingresos y Renuncias masivas en Personal y Periodos Laborales"  ;
						   When Substr(cPermis1,020,1) = "S"  .or. SwGbGa
					   
						   SEPARATOR
						   SEPARATOR
						   SEPARATOR
				       EndMenu
					   
					   SEPARATOR
					   SEPARATOR
					   
					   MENUITEM   "&I m p o r t a c i o n   d e   E x c e l"  RESOURCE (hRecurso,"PEOPLE");
							MESSAGE "Importacion de un formato EXCEL a la base de PERSONAL"                  
							
					   Menu Popup
							MENUITEM   "     &Importa Hoja de Excel de datos de Personal"  RESOURCE (hRecurso,"IMPORT");
								ACTION  PidPe_Main() ;     //  WinExec("&RutaW\Pid_PE.exe");
								MESSAGE "Transfiere data de Hoja de datos (EXCEL) de Datos de Personal a File temporal TMPPER.DBF" ;
										 When Substr(cPermis1,021,1) = "S"  .or. SwGbGa
							
							MENUITEM    "     &Revisa Archivo importado"  RESOURCE (hRecurso,"BROWSE");
								ACTION   A_RevPer(0) ;
								MESSAGE "Revisa Archivo importado de Excel de PERSONAL. Actualiza la tabla de Personal Standar del Sistema";
										When Substr(cPermis1,021,1) = "S"  .or. SwGbGa
						EndMenu			
						SEPARATOR
					    SEPARATOR
						
						
						
					    //////////////////	  
						//////////////////
						//////////////////	 
						MENUITEM  "T-Registro"  RESOURCE (hRecurso,"PEOPLE")
						MENU PopUp
						    SEPARATOR
							MENUITEM   "&Inicializa tablas de carga de datos del T-Registro"  RESOURCE (hRecurso,"CROSS");
								ACTION   T_Init();
								MESSAGE "Inicializa tablas de carga de datos del T-Registro";
								When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
								
							SEPARATOR
							SEPARATOR
						  
							MENUITEM   "&Importa Textos del T-Registro (Texto)"  RESOURCE (hRecurso,"IMPORT");
								ACTION   WinExec("&RutaW\ImpPlm.exe");
								MESSAGE "Importa archivos TXT del T-Tegistro y los transfiere a los Archivos PLAM_XXX (IDE, DIR, TRA, SSA, PEN, PFL, TER, ADH, BDH)"  ;
								When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
									
							SEPARATOR
							SEPARATOR
							
							MENUITEM   "&Arregla archivos generados del T-Registro"  RESOURCE (hRecurso,"TOOLS");
							   ACTION T_RegArr();
							   MESSAGE "Arregla archivos generados del T-Registro" ;
							   When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
							   
							SEPARATOR
							SEPARATOR
							SEPARATOR
							
							MENUITEM   "&PERSONAL DE PLANILLA"  RESOURCE (hRecurso,"PEOPLE");
									MESSAGE "Solo para el Personal de la Planilla Standar. Personal de Planilla"                  
							 
							MENUITEM   "      &Revisa Archivos generados del T-Registro (DIR)" RESOURCE (hRecurso,"BROWSE");
									ACTION T_RevTRE(1);
									MESSAGE "Arregla archivos generados del T-Registro (DIR). Datos de Identificaci�n" ;
									When Substr(cPermis1,022,1) = "S"  .or. SwGbGa		   
							   
							MENUITEM   "      &Revisa Archivos generados del T-Registro (IDE)"  RESOURCE (hRecurso,"BROWSE");
									ACTION T_RevTRE(2);
									MESSAGE "Arregla archivos generados del T-Registro (IDE). Datos de Direcciones" ;
									When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
							
							MENUITEM   "      &Revisa Archivos generados del T-Registro (TRA)"  RESOURCE (hRecurso,"BROWSE");
								   ACTION T_RevTRE(3);
								   MESSAGE "Arregla archivos generados del T-Registro (TRA). Datos Laborales" ;
								   When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
							
							MENUITEM   "      &Revisa Archivos generados del T-Registro (SSA)"  RESOURCE (hRecurso,"BROWSE");
								   ACTION T_RevTRE(4);
								   MESSAGE "Arregla archivos generados del T-Registro (SSA). Seguridad Social y adicionales" ;
								   When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
							   
							SEPARATOR
							SEPARATOR		
							 
							MENUITEM   "      &Transfiere datos al File de personal"  RESOURCE (hRecurso,"AVANZA");
								   ACTION T_TraPer();
								   MESSAGE "Transfiere datos de Personal al Sistema de Planilla" ;
								   When Substr(cPermis1,022,1) = "S"  .or. SwGbGa
								   
							SEPARATOR
							SEPARATOR

						EndMenu
						
						SEPARATOR
						SEPARATOR
						
						If Left(xEmpresa,8) = "INTERTEK"
						
							MENUITEM   "&Genera las Vistas TEMPUS"     RESOURCE (hRecurso,"CROSS");
									ACTION   U_Tempus();
									MESSAGE "Genera los archivos con las vistas TEMPUS" ;
									When Substr(cPermis1,024,1) = "S" .or. SwGbGa
						EndIf		
						
						SEPARATOR							
						SEPARATOR	
						
        ENDMENU

		SEPARATOR
		
		MENUITEM "&Conceptos"   RESOURCE (hRecurso,"TOOLS") 
                MENU         PopUp
                   MENUITEM "Mantenimiento"  RESOURCE (hRecurso,"DBFS") ;
                      ACTION b_con(vDemo,.F.) ;
                      MESSAGE  "Mantenimiento de Conceptos"    ;
					  When Substr(cPermis1,024,1) = "S"  .or. SwGbGa
					  
				    SEPARATOR
					
				  MENUITEM "Mantenimiento (Selecci�n de Campos)"  RESOURCE (hRecurso,"DBFS") ;
                      ACTION b_con(vDemo,.T.) ;
                      MESSAGE  "Mantenimiento de Conceptos con Selecci�n de Campos" ;
					  When Substr(cPermis1,026,1) = "S"  .or. SwGbGa
					  
				    SEPARATOR
					
					/*
				   MENUITEM "Conceptos VS PLAME"  RESOURCE (hRecurso,"DBFS") ;
                      ACTION b_con(vDemo,vDemo,1,1) ;
                      MESSAGE  "Revisa de Conceptos VS Plame"  ;
					  When Substr(cPermis1,026,1) = "S"  .or. SwGbGa

                   SEPARATOR
				   
				    MENUITEM "Conceptos - Rev.Inhibiciones"  RESOURCE (hRecurso,"DBFS") ;
                      ACTION b_con(vDemo,vDemo,1,2) ;
                      MESSAGE  "Revisa los Conceptos inhibidos por meses" ;
					  When Substr(cPermis1,026,1) = "S"  .or. SwGbGa

                   SEPARATOR
					*/
					
                   MENUITEM  "   Modifica F�rmulas y 2" RESOURCE (hRecurso,"FONTS");
                      ACTION a_ConFor(vDemo) ;
                      MESSAGE  "Modificaci�n de F�rmulas y Formulas 2" ;
					  When  Substr(cPermis1,027,1) = "S"  .or. SwGbGa
					  
					//If SwProyec3
							MENUITEM  "   Modifica F�rmulas y 3" RESOURCE (hRecurso,"FONTS");
								ACTION a_ConFo3(vDemo) ;
								MESSAGE  "Modificaci�n de F�rmulas y Formulas 3" ;
								When  Substr(cPermis1,027,1) = "S"  .or. SwGbGa
					//EndIf		
					  
				   SEPARATOR
				   
				   MENUITEM   "&Conceptos - Analogia Referencial" RESOURCE (hRecurso,"ON");
						ACTION   A_CONANA();
						MESSAGE "Permite revisar la analogia de Conceptos analogos. Valido para Transferencia de Otros Sistemas";
						When  Substr(cPermis1,028,1) = "S"  .or. SwGbGa

				   SEPARATOR
				   
                   MENUITEM  "Modifica Sumandos a Totales" RESOURCE (hRecurso,"BRowse") ;
                      ACTION a_ConRDA() ;
                      MESSAGE  "Modificaci�n de Sumanos a campos Totales"   ;
					  When  Substr(cPermis1,028,1) = "S"	   .or. SwGbGa

                ENDMENU
	
				MENUITEM "&Conceptos P L A M E"   RESOURCE (hRecurso,"BROWSE")
					MENU         PopUp
					   MENUITEM "Conceptos PLAME"  RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_TabCon("01",vDemo) ;
					   MESSAGE  "Mantenimiento de Conceptos del PLAME"   ;
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa

					   MENUITEM "Enlace del PLAME y Planilla" RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_tabCo2("01",vDemo) ;
					   MESSAGE  "Enlace del PLAME y Planilla" ;
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa

					   MENUITEM "Conceptos PLAME VS Conceptos Planilla" RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_TabCo3("01",vDemo) ;
					   MESSAGE  "Relaci�n de Conceptos del PLAME VS Conceptos internos de la Planilla interna";
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa
					   
					   SEPARATOR
					   
					   MENUITEM "Tributos Gravados a la Remuneraciones"  RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_TabCo4("02",vDemo) ;
					   MESSAGE  "Tributos Gravados a la Remuneraciones"  ;
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa
					   
					   MENUITEM "Leyendas de las Remuneraciones Gravadas"  RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_TabCo5("03",vDemo) ;
					   MESSAGE  "Leyendas de las Remuneraciones Gravadas"  ;
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa
					   
					   MENUITEM "Base gravada a los beneficios Sociales"  RESOURCE (hRecurso,"BRWSMAL") ;
					   ACTION a_TabCo6("04",vDemo) ;
					   MESSAGE  "Base gravada a los beneficios Sociales"   ;
					   When  Substr(cPermis1,029,1) = "S"  .or. SwGbGa

					ENDMENU

         SEPARATOR

         MENUITEM "&Salir"  RESOURCE (hRecurso,"EXIT")  ;
            ACTION if( MsgYesNo( " Desea terminar ?" ,"Finalizar el Sistema" ),;
                       (Upd_Act_User(.F.),oWnd:End()),) ;
            MESSAGE "Finalizar el Sistema" 
      ENDMENU
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      MENUITEM  "&Movimientos" 
      cClaPla   :=  1
	  
		ggTitAFP = "&Registra Relaci�n Laboral seg�n AFP por Trabajador" 
		ggTitAfp2 = "&Reporte para envio a AFP / &Genera Archivo Exportaci�n para AFP NET"
	  	  
      MENU
	  
		SEPARATOR
	  
        MENUITEM  "   &Inicializa Per�odo" RESOURCE (hRecurso,"CROSS");
            ACTION m_Trab(0,oWnd,1,1),If(!xSalir,(M_Ini(0),ActRem(.F.),AcPl_DV(1)),);
            MESSAGE "Proceso de Inicializar un Nuevo Per�odo y Eliminar el Movimiento variable"  ;
			When  Substr(cPermis1,031,1) = "S"  .or. SwGbGa
		SEPARATOR	
			
		MENUITEM  "   &Datos Constantes y Fijos en el Periodo"   RESOURCE (hRecurso,"TOOLS")  ;
			ACTION P_Consta() ;
			MESSAGE  "Datos Fijos y Constantes en el Periodo" ;
			When  Substr(cPermis1,032,1) = "S"		 .or. SwGbGa

        SEPARATOR
		
		
		MENUITEM  "  R&utas de C�lculo de Tipos de Planillas" RESOURCE (hRecurso,"CROSS");
					Message "Es un proceso opcional, valido para cambios del orden de procesos de planilla. Para efectos del acumulado del ingreso total"
		Menu PopUp
		
				MENUITEM "   &Calcula Aporte Patronal EsSalud"   RESOURCE (hRecurso,"CALC16")   ;
					ACTION P_CalEsa() ;
					MESSAGE  "Calcula el aporte patronal EsSalud de todas las planillas celebradas para el periodo"  ;
					When  Substr(cPermis1,033,1) = "S"  .or. SwGbGa
					
				MENUITEM "   &Marcaci�n de Planillas Procesadas - AFP / EsSalud"    RESOURCE (hRecurso,"BROWSE") ;
					ACTION P_CfgPl1() ;
					MESSAGE "Configura Planillas Procesadas - Tope AFP/EsSalud"  ;
					When  Substr(cPermis1,033,1) = "S" .and. ( cTbCsdAfp .or. cTbCsdEsa )  .or. SwGbGa

				MENUITEM "     &C�lculo de Remun.Acumul. - Topes AFP / EsSalud"    RESOURCE (hRecurso,"CALC16")  ;
					ACTION ( cClaPla:=0, P_CalTPS(0) ) ;
					MESSAGE "C�lculo de Remuneraci�n Acumulable para Topes de AFP y EsSalud"  ;
					When ( Substr(cPermis1,033,1) = "S" .and. cTbCsdAfp )  .or. SwGbGa

				MENUITEM "     ** &Revisa Remun.Acumul.para AFP ** "    RESOURCE (hRecurso,"DBFS") ;
					ACTION P_RevTPS(1) ;
					MESSAGE  "Revisa Remuneraci�n Acumulable para TOPES de prima de seguro de AFP"  ;
					When  ( Substr(cPermis1,033,1) = "S"  .and. cTbCsdAfp )  .or. SwGbGa

				MENUITEM "     ** &Revisa Aportes Acumulados para EsSalud ** "   RESOURCE (hRecurso,"DBFS") ;
					ACTION P_RevTPS(2) ;
					MESSAGE  "Revisa Aportes Acumulados para TOPES de EsSalud" ;
					When  ( Substr(cPermis1,033,1) = "S"  .and. cTbCsdAfp )  .or. SwGbGa
			
		ENDMENU	

		SEPARATOR
		SEPARATOR
		
		
		MENUITEM "           ***  REGISTRA MOVIMIENTO DEL EJERCICIO  *** " RESOURCE (hRecurso,"BRWMAL") ;
				  Message "Registra movimiento del ejercicio"
        MENUITEM "&Registra los conceptos de Remun.y Desc.Fijos"  RESOURCE (hRecurso,"DBFS") ;
            ACTION b_RemF("F",1,0,0) ;
            MESSAGE  "Proceso de Registro de los conceptos del tipo de Remuneraciones y Descuentos Fijos en la planilla de Remuneraciones";
			When Substr(cPermis1,034,1) = "S"  .or. SwGbGa
			
		 MENUITEM "&Registra los conceptos de Remun.y Desctos.Variables"  RESOURCE (hRecurso,"DBFS")  ;
            ACTION b_RemF("V",1,0,0) ;
            MESSAGE "Proceso de Registro de los conceptos del tipo de Remuneraciones y Descuentos Variables";
			When Substr(cPermis1,035,1) = "S"  .or. SwGbGa
			
		MENUITEM "&Registra los conceptos de Remun.y Desctos.==>>Fijos y Variables"  RESOURCE (hRecurso,"DBFS")  ;
            ACTION b_RemF("T",1,0,0) ;
            MESSAGE "Proceso de Registro de los conceptos del tipo de Remuneraciones y Descuentos Fijos y Variables";
			When Substr(cPermis1,036,1) = "S"  .or. SwGbGa	

		
		SEPARATOR
		
        MENUITEM "&Registra los conceptos Prioritarios "  RESOURCE (hRecurso,"DBFS")  ;
				ACTION b_RemF("P",1,0,0) ;
				MESSAGE "Proceso de Registro de los conceptos Prioritarios";
				When Substr(cPermis1,037,1) = "S"  .or. SwGbGa
			
		MENUITEM "&Registra los conceptos Seleccionados"  RESOURCE (hRecurso,"DBFS")  ;
				ACTION b_RemF("S",1,0,0) ;
				MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Previa Selecci�n de Concepto" ;
				When Substr(cPermis1,038,1) = "S" .or. SwGbGa		
				
		MENUITEM "&Registra los conceptos Marcados como Hoja de Datos"  RESOURCE (hRecurso,"DBFS")  ;
				ACTION b_RemF("H",1,0,0) ;
				MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Previa Selecci�n de Concepto" ;
				When Substr(cPermis1,039,1) = "S" .or. SwGbGa			

		SEPARATOR
		
        MENUITEM  "&Registra Ingresos y Descuentos para 1 SOLO TRABAJADOR "  RESOURCE (hRecurso,"NEW") ;
            ACTION b_RemPer(0,0) ;
            MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos (Fijos, Variables o Prioritarios) PARA 1 SOLO TRABAJADOR " ;
			When Substr(cPermis1,040,1) = "S"  .or. SwGbGa
			
		SEPARATOR
		SEPARATOR
		SEPARATOR
		
		MENUITEM  "&IMPORTACION MASIVA PLANILLA (x Concep:fij-Var), (Fecha:Vac,Subs,Inasist) DE Formatos EXCEL " RESOURCE (hRecurso,"NEW")
				  
				MENU 
					SEPARATOR					
					SEPARATOR
					
					MENUITEM   "   **  TRANSFERENCIA MASIVA POR CONCEPTO (Solo Importes)  **"   
					MENUITEM   "                               Movimiento por concepto" 
					SEPARATOR
					SEPARATOR
					
					 MENUITEM   "&Importa Movimiento Remunerativo de EXCEL a File temporal"  RESOURCE (hRecurso,"EXCEL");
						ACTION   WinExec("&RutaW\Pid_HD.exe");
						MESSAGE "Transfiere data de Hoja de datos (EXCEL) de hojas de Movimiento Remunerativo y Descuentos a File temporal HOJDAT.DBF" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					MENUITEM   "&Revisa Archivo importado" RESOURCE (hRecurso,"BROWSE");
						ACTION   A_RevHDA(0);
						MESSAGE "Revisa Archivo de Hoja de Datos del Mov. Remunerativo y Descuentos de las tablas de EXCEL (HOJDAT.DBF)" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
				    SEPARATOR	
					SEPARATOR
					
					MENUITEM   "&Reset de Campos de Planilla (Seg�n Hoja de Datos)"   RESOURCE (hRecurso,"CROSS");
						ACTION   A_InPlVa(1,0,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF. Si Planilla por C.Costo se puede RESET por CCosto";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					MENUITEM   "&Reset de Campos de Planilla por Trabajador(Seg�n Hoja de Datos)"   RESOURCE (hRecurso,"CROSS");
						ACTION   A_InPlTR(1,0,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF y por trabajador. Si Planilla por C.Costo se puede RESET por CCosto";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa	
						
					MENUITEM   "&Reset de Campos de Planilla (Conceptos:Variables y Formulas desactivadas) "   RESOURCE (hRecurso,"CROSS");
						ACTION   BorHD(1,0,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF. Si Planilla por C.Costo se puede RESET por CCosto";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa		
						
					SEPARATOR
					SEPARATOR					
										
					MENUITEM   "&Transfiere datos a Planilla actual " RESOURCE (hRecurso,"ALFINAL");
						ACTION   A_PasPla(0);
						MESSAGE "Transfiere datos a Planilla Actual ";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
						
					MENUITEM   "&Revisa Totales Transferidos" RESOURCE (hRecurso,"BUSCAR");
						ACTION   A_RevTra(0);
						MESSAGE "Revisa Totales Transferidos en Planilla actual";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
					
					
					SEPARATOR		
					SEPARATOR
					MENUITEM   "   **  TRANSFERENCIA MASIVA DE NO ASISTENCIA (por fechas)  **"   
					MENUITEM   "                       Movimiento x FECHA (Vac, Desc.Med, Subsid, Inasist)" 
					SEPARATOR
					SEPARATOR
										
					 MENUITEM   "&Genera Formato para transferencia masiva de no asistencia"  RESOURCE (hRecurso,"EXCEL");
						ACTION   FmtVAS(1);
						MESSAGE "Genera Formato para transferencia masiva de no asistencia" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					 MENUITEM   "&Importa Movimiento de NO ASISTENCIA de EXCEL a File temporal"  RESOURCE (hRecurso,"EXCEL");
						ACTION   A_ImpVAS(1);
						MESSAGE "Importa Movimiento de NO ASISTENCIA de Hojas de EXCEL del Movimiento de NO ASISTENCIA a File temporal TMPVAS" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa	
						
					MENUITEM   "&Revisa Archivo de NO Asistencia importado" RESOURCE (hRecurso,"BROWSE");
						ACTION   A_RevVAS(1);
						MESSAGE "Revisa Archivo de Hoja de Datos del Mov. de NO ASISTENCIA de las tablas de EXCEL (TMPVAS.DBF)" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					SEPARATOR		
					SEPARATOR
					
					MENUITEM   "   **  ACUMULADOS DE VACACIONES GOZADAS   **"  
					MENUITEM   "                        Movimiento x FECHA " 
					
					
					SEPARATOR		
					SEPARATOR
					
					MENUITEM   "&Genera Formato para carga de Acumulado de Vacacionrs"  RESOURCE (hRecurso,"EXCEL");
						ACTION   FmtVAS(2);
						MESSAGE "Genera Formato para acumulado de vacaciones" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					MENUITEM   "&Importa Hoja de Excel con Acum. de Vacaciones Gozadas"  RESOURCE (hRecurso,"IMPORT");
						ACTION   V_CarSVa();
						MESSAGE "Transfiere data de Hoja de datos (EXCEL) con los acmulados de vacaciones gozadas a un archivo TmpSVa.DBF";
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
							
					MENUITEM   "&Revisa Archivo Vacacional importado"  RESOURCE (hRecurso,"BROWSE");
						ACTION   V_RevSVa();
						MESSAGE "Revisa Archivo importado de Excel con los acumulados de vacaciones gozadas" ;
						When Substr(cPermis1,041,1) = "S"  .or. SwGbGa
						
					SEPARATOR
					SEPARATOR
					
				ENDMENU		
     

        SEPARATOR
        SEPARATOR
		SEPARATOR


		MENUITEM " Calcula remun.diaria de subsidios..." RESOURCE (hRecurso,"CROSS")
			Menu PopUp
				 MENUITEM "  ***  Calcula Remun.diaria por Subsidio "   RESOURCE (hRecurso,"CALC16")   ;
					ACTION m_RmSbDi() ;
					MESSAGE "Calcula la Remuneraci�n diaria para subsidios"	;
					When ( Substr(cPermis1,042,1) = "S" .and. cAvi98 ) .or. SwGbGa 
					
				 MENUITEM "        Revisa Remun.historica "   RESOURCE (hRecurso,"BRWSMAL")   ;
					ACTION m_RmSbHi() ;
					MESSAGE "Revisa la Remuneraciones historica para obtener la rem.diaria para subsidios"	;
					When ( Substr(cPermis1,042,1) = "S" .and. cAvi98 ) .or. SwGbGa 
					
					
			EndMenu		
			
		MENUITEM " Registro de subsidios y descansos m�dicos..." RESOURCE (hRecurso,"CROSS")
			Menu PopUp
				 MENUITEM "  ***  Registra &Subsidios o Descansos m�dicos al personal "   RESOURCE (hRecurso,"BRWSMAL")   ;
					ACTION m_Subsid() ;
					MESSAGE "Registro de los dias subsidiados y descansos m�dicos" ;
					When Substr(cPermis1,042,1) = "S"  .or. SwGbGa
					
					//ACTION ( ActPlas(0),m_Subsid(0),ActPlaS(0)) ;
				 MENUITEM "        Revisa los Subsidios y descansos m�dicos del personal"  RESOURCE (hRecurso,"DBFS")  ;
					ACTION m_Subsid() ;
					MESSAGE "Revisa los Subsidios y descandos m�dicos del personal " ;
					When Substr(cPermis1,042,1) = "S"	 .or. SwGbGa
					
				SEPARATOR

				 MENUITEM "        Importacion Masiva en otro Men�"	RESOURCE (hRecurso,"POINT")		
			EndMenu
		SEPARATOR
        SEPARATOR	

		 
		MENUITEM " Registro de dias no laborados (Faltas, Licencias, etc)" RESOURCE (hRecurso,"CROSS")
			Menu PopUp
				 MENUITEM "  ***  Registra Dias No Laborados (Inasistencias) (No Subsdios, No Vacaciones, Intermitencia)"   RESOURCE (hRecurso,"BRWSMAL")   ;
					ACTION m_NSulab(0,0);
					MESSAGE "Registra Dias No Laborados (Inasistencias) (No Subsdios, No Vacaciones, dias de Intermitencia)" ;
					When Substr(cPermis1,043,1) = "S"  .or. SwGbGa
					
				MENUITEM "        Revisa los Dias No Laborados (Inasistencias)"  RESOURCE (hRecurso,"DBFS")  ;
					ACTION m_NSulab(1,0);
					MESSAGE "Revisa los Dias No Laborados o Inasistencias del personal "  ;
					When Substr(cPermis1,043,1) = "S"	 .or. SwGbGa
					
				SEPARATOR

				 MENUITEM "        Importacion Masiva en otro Men�"		RESOURCE (hRecurso,"POINT")			
			EndMenu		 
			
         
         SEPARATOR
		 //SEPARATOR
         //------------------------------
         //------------------------------
	
		 MENUITEM "&Registra/Modificar Campos particul.para la planilla actual. Edici�n de conceptos (Calculo de Planilla)"  RESOURCE (hRecurso,"NEW")  ;
					ACTION m_RegTxt(1,1) ;
					MESSAGE "Registra � Modifica Campos particular en el File de la Planilla actual. Para editar conceptos en el cxalculo de la Planilla" ;
					When Substr(cPermis1,044,1) = "S"  .or. SwGbGa
					
        SEPARATOR
		
		MENUITEM ggTitAFP    RESOURCE (hRecurso,"NEW")  ;
				    ACTION M_RegVac("AFP","PER");
				    MESSAGE  ggTitAfp 	;
					When Substr(cPermis1,045,1) = "S"  .or. SwGbGa

		MENUITEM "&Registra a Trabajadores con Rubro de Alto Riesgo"   RESOURCE (hRecurso,"NEW")  ;
					ACTION M_RegVac("RIE","PER");
					MESSAGE  "Registra a Trabajadores con Rubro de Alto Riesgo"    ;
					When Substr(cPermis1,046,1) = "S"  .or. SwGbGa
	
        SEPARATOR
		SEPARATOR

	        //-------------------------------------------------
			//-------------------------------------------------
		MENUITEM "&Adelantos de Quincenas"    RESOURCE (hRecurso,"BRWSMAL") 
                cClaPla   :=  1
				
                MENU         PopUp
                    MENUITEM "&C�lculo de Adelantos de Quincena"  RESOURCE (hRecurso,"CALC16")  ;
                       ACTION ( Upd_Avi(),CarDiaM(1), SwQuince:=.T.,xSalirT:=.F., P_Cal(0,0,1,0) ) ;
                       MESSAGE  "Proceso de C�lculo de Planilla - Adelantos de Quincena"    ;
					   When  Substr(cPermis1,047,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Modificaci�n manual de Adelantos"    RESOURCE (hRecurso,"DBFS") ;
                       ACTION M_ModAde()  ;
                       MESSAGE "Modificaci�n manual de Adelantos"   ;
					   When Substr(cPermis1,047,1) = "S"  .or. SwGbGa
					   
				    MENUITEM "Reporte de Adelantos de Quincena"   RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION P_Pla("ADELANTO",1,0);
                       MESSAGE  "Reporte de adelantos de quincena"     ;
					   When Substr(cPermis1,047,1) = "S"  .or. SwGbGa


                    SEPARATOR

                    MENUITEM "&Emisi�n de Recibos"   RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION M_AdeRec(0) ;
                       MESSAGE  "Emite Recibos de Adelantos de Quincena"   ;
					   When Substr(cPermis1,047,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Reporte de Adelantos"   RESOURCE (hRecurso,"IMPRE16")   ;
                       ACTION P_Pla("ADELANTO",1,0);
		               MESSAGE "Emite Resumen de Adelantos de Quincena"  ;
					   When Substr(cPermis1,047,1) = "S"  .or. SwGbGa
                  
                ENDMENU

				//--------------------------------------------------
				//---------------------------------------------------
				
                MENUITEM "   &Pr�stamos - Cta.Cte."   RESOURCE (hRecurso,"PAGOS16") 
                MENU         PopUp
                    MENUITEM "&Registro de Pr�stamos-Largo Plazo"  RESOURCE (hRecurso,"PAGOS16")  ;
                       ACTION M_Presta( 0) ;
                       MESSAGE  "Proceso de Registro de los Pr�stamos a trabajadores" ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Detalle de las Cuotas"  RESOURCE (hRecurso,"PAGOS16")  ;
                       ACTION M_DetCuo( 0) ;
                       MESSAGE  "Detalle de las Cuotas de los Pr�stamos a trabajadores" ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    SEPARATOR
					/*
                    MENUITEM "&Ingreso de Adelantos y Colaboraciones"  RESOURCE (hRecurso,"DBFS") ;
                       ACTION M_Adelan( 1) ;
                       MESSAGE  "Ingreso de Adelantos y Colaboraciones"     ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Registro de Adelantos y Colaboraciones"  RESOURCE (hRecurso,"DBFS") ;
                       ACTION M_Presta( 1);
                       MESSAGE  "Registro de Adelantos y Colaboraciones"    ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Detalle de Adelantos y Colaboraciones"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_DetCuo( 1) ;
                       MESSAGE  "Detalle de los Adelantos y Colaboraciones"  ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
	
                    SEPARATOR
					*/
                    MENUITEM "&Pr�stamos otorgados al Trabajador"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_PreOto( ) ;
                       MESSAGE  "Pr�stamos otorgados al Trabajador"    ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "&Detalle de las Descuentos del Periodo" RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_DetPre( ) ;
                       MESSAGE  "Detalle de los Descuentos del Periodo"  ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
					   
                    MENUITEM "&Detalle de los Pr�stamos y sus Cuotas en General"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_DetCuo( 2) ;
                       MESSAGE  "Detalle de los Pr�stamos u sus Cuotas en General"  ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "&Reporte de Saldos por Trabajador"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION MsgAlert("Papel A4, Portrait, Puntos  8","Tipo de Papel"),PrinterSetup(),M_PreSal( ) ;
                       MESSAGE  "Emite Reporte de los Saldos de los Pr�stamos al Personal por Trabajador" ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    MENUITEM "&Reporte de Saldos por trabajador por Documento"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION MsgAlert("Papel A4, Portrait, Puntos  8","Tipo de Papel"),PrinterSetup(),M_PreDet( ) ;
                       MESSAGE "Reporte de Saldos por trabajador por Documento"   ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    MENUITEM "&Reporte de Detalle por trabajador"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_SalDet( ) ;
                       MESSAGE  "Reporte de Detalles por trabajador"    ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "&An�lisis de Pr�stamos"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_AnaPre( ) ;
                       MESSAGE  "An�lisis de Pr�stamos por trabajador y por Documento"  ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "Consistencia - &Pr�stamos sin Detalles"  RESOURCE (hRecurso,"ALERT") ;
                       ACTION M_PrSiDe( ) ;
                       MESSAGE  "Consistencia - An�lisis de Pr�stamos sin Detalle "   ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa

                    MENUITEM "Consistencia - &Detalles  sin Pr�stamo (UPD)"  RESOURCE (hRecurso,"ALERT") ;
                       ACTION M_DeSiPr( ) ;
                       MESSAGE  "Consistencia - An�lisis de Detalles sin Pr�stamo-Actualiza TC y Fecha de Pago de PERPAG" ;
					   When Substr(cPermis1,048,1) = "S"  .or. SwGbGa
					   
                ENDMENU
			SEPARATOR
			
			SEPARATOR
		 
		    //------------------------------------------------------
			//------------------------------------------------------
	
			MENUITEM "&Vacaciones "   RESOURCE (hRecurso,"BRWSMAL") 
                cClaPla   :=  2
                MENU         PopUp
				
					MENUITEM "  **     P R O M E D I O S    **"
					SEPARATOR
				
                    MENUITEM "&Genera Promedio de Vacaciones / PARAMETROS"  RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION  IF(cEmFrecue="S",P_VacPro(0,0,1),P_VacPro(0,0,0));
                       MESSAGE  "Genera Promedio de Vacaciones. Registro de parametros"  ;
					   When  Substr(cPermis1,049,1) = "S"  .or. SwGbGa
					   
					MENUITEM "&Reporte de Promedio de Vacaciones / PARAMETROS"  RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION  IF(cEmFrecue="S",P_VacPro(0,1,1),P_VacPro(0,1,0));
                       MESSAGE  "Reporte de Promedio de Vacaciones. Registro de parametros"   ;
					   When  Substr(cPermis1,049,1) = "S"  .or. SwGbGa   
				
				    SEPARATOR 
					MENUITEM "  **     S A L D O    D E    V A C A C I O N E S    **"
					SEPARATOR
					
				    MENUITEM " Registro los acumulados de Vacaciones"   RESOURCE (hRecurso,"BRWSMAL") ;
					ACTION P_SalVac();
					MESSAGE "Registra Fecha Ultima y las vacacones acumuladas a la fecha"  ;
					When Substr(cPermis1,049,1) = "S"  .or. SwGbGa
					
					SEPARATOR
				    MENUITEM "  Importacion Masiva (En Men� anterior)"	RESOURCE (hRecurso,"POINT")	
					
					SEPARATOR 
					SEPARATOR
					MENUITEM "  **     V A C A C I O N E S    **"
					SEPARATOR
					SEPARATOR
					//---------------------------------------------------
					//----------Metodos de Vacaciones--------------------
					//---------------------------------------------------
					//---------------------------------------------------
					If cTbPVaSep	// SEPARADO		
							MENUITEM "  Registra Vacaciones al personal (Separado)"  RESOURCE (hRecurso,"COPY")   ;
							ACTION ActRem(.F.),AcPl_DV(1),m_NSulaV(),ActRem(.F.),AcPl_DV(0) ;
							MESSAGE "Registro de los dias de Vacaciones. Vacaciones en 2 meses " +;
							"los separa por cada mes y los aportes de la misma forma (Ver Param E3 - Cambio Metodologia)";
							When Substr(cPermis1,049,1) = "S"  .or. SwGbGa
							//---------------------------------					
					Else			// CONTINUO
							//---------------------------------
							MENUITEM "  Registra Vacaciones al personal (Continuo)"  RESOURCE (hRecurso,"BRWSMAL")   ;
							ACTION ActRem(.F.), AcPl_DV(1),m_NSulaC(),ActRem(.F.),AcPl_DV(0) ;
							MESSAGE "Registro de los dias de Vacaciones. Vacaciones en 2 meses los trabaja en forma continua " + ;
							"(Ver Param E3 - Cambio Metodologia)";
							When Substr(cPermis1,049,1) = "S"  .or. SwGbGa
							//---------------------------------
					EndIf
					
					SEPARATOR
					
					MENUITEM " Revisa / Detalla / Lista las Vacaciones del personal"  RESOURCE (hRecurso,"IMPRE16") ;
					ACTION m_RevVac() ;
					MESSAGE "Revisa los detalles de Vacaciones del todo el personal con diferentes opciones. Reset Saldos antiguos"  ;
					When Substr(cPermis1,049,1) = "S"  .or. SwGbGa
					
					SEPARATOR
				    MENUITEM "   Importacion Masiva  (En Men� anterior)"	RESOURCE (hRecurso,"POINT")	
					
					//---------------------
                    SEPARATOR

                    MENUITEM "&C�lculo de Vacaciones"    RESOURCE (hRecurso,"CALC16")  ;
                       ACTION   (xSalir:=.F.,Upd_Avi(),ValActi(0,0),P_CalTPS(2),CarDiaM(2),P_CalVac());
                       MESSAGE  "Proceso del C�lculo de Vacaciones" ;
					   When  Substr(cPermis1,049,1) = "S"  .or. SwGbGa
				
				/*
				ACTION   (  IF(Per_Block2,Msgalert("Periodo Vac.Bloqueado"),),;
					            Upd_Avi(),CarDiaM(2),P_CalVac() Msgalert("No se Procesa") );
				*/
                    SEPARATOR

                    MENUITEM "&Transfiere Datos de Vacaciones a Remuneraciones"  RESOURCE (hRecurso,"AVANZA")  ;
                       ACTION (;
							If(cAvi41,GePlan_Anex(),),;	
							P_TraDat(2),;
							If(cAvi41,AdPlan_Anex(),)	);
                       MESSAGE "Transfiere Datos de Planilla de Vacaciones a Planilla de Remuneraciones";
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "&rPreviaV"   RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION P_Pla("PREV_VAC",2,0);
                       MESSAGE  "Planilla Previa de Vacaciones"     ;
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    SEPARATOR
                    SEPARATOR

                    MENUITEM "&Cierre de Planilla de Vacaciones"  RESOURCE (hRecurso,"CROSS")  ;
                       ACTION P_Cierre(2) ;
                       MESSAGE "Proceso de Cierre de Planilla de Vacaciones" ;
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    SEPARATOR
                    SEPARATOR

                    MENUITEM "&Reset de Planilla de Vacaciones"  RESOURCE (hRecurso,"CLOSEALL") ;
                       ACTION P_ZapV() ;
                       MESSAGE  "Reset del archivo de Planilla de Vacaciones (PlanVac)"  ;
					   When  Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    SEPARATOR

                    MENUITEM "&Registro Programa de Vacaciones del Personal"  RESOURCE (hRecurso,"DBFS") ;
                       ACTION M_RegVac("VAC","PER");
                       MESSAGE "Registro Programa de Vacaciones del Personal"   ;
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    MENUITEM "&Emite Programa de Vacaciones mensuales"  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION M_VacMes();
                       MESSAGE "Emite Programa de Vacaciones mensuales del Personal" ;
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    SEPARATOR
					SEPARATOR
					
					 MENUITEM "&Genera Promedio de Vacaciones / PARAMETROS"  RESOURCE (hRecurso,"IMPRE16")  ;
                       ACTION  IF(cEmFrecue="S",P_VacPro(0,0,1),P_VacPro(0,0,0));
                       MESSAGE  "Genera Promedio de Vacaciones. Registro de parametros"  ;
					   When  Substr(cPermis1,049,1) = "S"  .or. SwGbGa

                    MENUITEM "&Control de Vacaciones por Dias (Gen-HVACA) "  RESOURCE (hRecurso,"IMPRE16") ;
                       ACTION H_VacPrG() 	   ;
                       MESSAGE "Control de Vacaciones por Dias. Posiblidad de Generar HVACA de Planillla historicas. Sino Toma de Vacaciones detalladas ingresadas"   ;
					   When Substr(cPermis1,049,1) = "S"  .or. SwGbGa
					   
					SEPARATOR
					
            ENDMENU
	
	        //-------------------------------------------
			//-------------------------------------------
			//-------------------------------------------
			//-------------------------------------------
			If !cTbPlaMic
					MENUITEM "&Gratificaciones"    RESOURCE (hRecurso,"BRWSMAL") 
						cClaPla   :=  3
				
						MENU         PopUp
						
							MENUITEM "&Genera Promedio de Gratificaciones / PARAMETROS"  RESOURCE (hRecurso,"IMPRE16")  ;
								ACTION  IF(Per_Block3,Msgalert("Periodo Grat.Bloqueado","No se Procesa"),;
								IF(cEmFrecue="S",P_VacPro(1,0,1),P_VacPro(1,0,0))   );
								MESSAGE  "Genera Promedio de Gratificaciones. Registro de parametros" ;
								When  Substr(cPermis1,050,1) = "S"  .or. SwGbGa
								
							MENUITEM "&Reporte del Promedio de Gratificaciones / PARAMETROS"  RESOURCE (hRecurso,"IMPRE16")  ;
								ACTION  IF(Per_Block3,Msgalert("Periodo Grat.Bloqueado","No se Procesa"),;
								IF(cEmFrecue="S",P_VacPro(1,1,1),P_VacPro(1,1,0))   );
								MESSAGE  "Reporte de Promedio de Gratificaciones. Registro de parametros" ;
								When  Substr(cPermis1,050,1) = "S"  .or. SwGbGa	
				
							SEPARATOR 
						
						
							MENUITEM  "&P�rametros - Gratificaciones"  RESOURCE (hRecurso,"TOOLS")   ;
							   ACTION G_Para();
							   MESSAGE "P�rametros para el m�dulo de Gratificaciones"    ;
							   When Substr(cPermis1,050,1) = "S"   .or. SwGbGa
							   
							SEPARATOR
							
							MENUITEM  "&Revisa Remuneraci�n del mes anterior"  RESOURCE (hRecurso,"DBFS") ;
							   ACTION G_RvRmAn();
							   MESSAGE "Revisa la Remuneracion anterior v�lido para el c�lculo de Gratificaciones" ;
							   When Substr(cPermis1,050,1) = "S"    .or. SwGbGa
							   

							SEPARATOR
							
							MENUITEM  "&C�lculo de �ltima Gratificaci�n percibida. Se Copiara en Personal"  RESOURCE (hRecurso,"CALC16") ;
							   ACTION fUlt_Gra();
							   MESSAGE "C�lculo de �ltima Gratificaci�n percibida y se actualiza en Personal" ;
							   When Substr(cPermis1,050,1) = "S"    .or. SwGbGa
							   
							 MENUITEM "&Revisa/Actualiza Ultimas Gratificaciones"   RESOURCE (hRecurso,"DBFS")  ;
								ACTION M_RegVac("UGR","PER");
								MESSAGE  "Revisa/Actualiza Ultimas Gratificaciones"   ;
								When Substr(cPermis1,050,1) = "S"   .or. SwGbGa
								  
							 MENUITEM "&Actualiza Datos de Ultima Gratif a Planilla o Historicos (de Personal)"   RESOURCE (hRecurso,"TOOLS")  ;
								ACTION M_UpGrUl();            
								MESSAGE  "Actualiza Datos de Ultimas Gratificaciones y Afiliado a EPS en Files Historicos o Planilla Remun/Gratif. de PERSONAL"  ;
								When Substr(cPermis1,050,1) = "S"   .or. SwGbGa
							   
							SEPARATOR
							
							MENUITEM  "&C�lculo de Sextos"    RESOURCE (hRecurso,"CALC16")  ;
							   ACTION  M_Gracal();     
							   MESSAGE "C�lculo de Sextos de Gratificaciones"   ;
							   When Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							   
							SEPARATOR
							MENUITEM "&C�lculo de Gratificaciones"   RESOURCE (hRecurso,"CALC16");
							   ACTION (Upd_Avi(),P_CalTPS(3),CarDiaM(3),IF(Left(xEmpresa,8)="INTERTEK",P_CalGraI(),P_CalGra()));
							   MESSAGE  "Proceso del C�lculo de Gratificaciones"   ;
							   When  Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							   
							SEPARATOR
							MENUITEM "&Transfiere Datos de Gratificaciones a Remuneraciones"  RESOURCE (hRecurso,"ALFINAL") ;
								ACTION (;
									If(cAvi41,GePlan_Anex(),),;	
									P_TraDat(3),;
									If(cAvi41,AdPlan_Anex(),)	);
							   MESSAGE "Transfiere Datos de Planilla de Gratificaciones a Planilla de Remuneraciones";
							   When Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							SEPARATOR
							
							SEPARATOR
							MENUITEM "&rPreviaG"  RESOURCE (hRecurso,"IMPRE16")   ;
							   ACTION P_Pla("PREV_GRA",3,0);
							   MESSAGE  "Impresi�n de la Planilla Previa de Gratificaciones" ;
							   When Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							SEPARATOR
							
							MENUITEM "&rPreviaG2"  RESOURCE (hRecurso,"IMPRE16")   ;
							   ACTION P_Pla("PREV_GR2",3,0);
							   MESSAGE  "Impresi�n de la Planilla Previa de Gratificaciones 2"  ;
							   When Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							SEPARATOR
							
							SEPARATOR
							MENUITEM "&Cierre de Planilla de Gratificaciones"  RESOURCE (hRecurso,"CROSS")  ;
							   ACTION P_Cierre(3) ;
							   MESSAGE "Proceso de Cierre de Planilla de Gratificaciones"  ;
							   When Substr(cPermis1,050,1) = "S"  .or. SwGbGa
							SEPARATOR
							SEPARATOR

							MENUITEM "&Reset de Planilla de Gratificaciones"  RESOURCE (hRecurso,"CLOSEALL") ;
							   ACTION P_ZapG() ;
							   MESSAGE "Reset de Planilla de Gratificaciones"   ;
							   When  Substr(cPermis1,050,1) = "S"  .or. SwGbGa
					
					ENDMENU			
					
					SEPARATOR
					SEPARATOR
					 
 					MENUITEM "&Valida Traslape de fechas del Movimiento registrado"  RESOURCE (hRecurso,"TOOLS")  ;
						ACTION V_VaSuLa();
						MESSAGE  "Valida Traslape de fechas del Movimiento registrado en Vacaciones, Subsidios y Dias No laborados" ;
						When Substr(cPermis1,051,1) = "S"  .or. SwGbGa
					 
					MENUITEM "&Transfiere Datos (Entre Planillas)"  RESOURCE (hRecurso,"AVANZA")  ;
						ACTION T_PlaPla(0);
						MESSAGE  "Transfiere Datos de distintos campos de Planilla a Planilla" ;
						When Substr(cPermis1,053,1) = "S"  .or. SwGbGa
					SEPARATOR	
			EndIf			
      ENDMENU
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
      //////////////////

      MENUITEM  "&Procesos" 
      cClaPla   :=  1
	  //------------------------
      MENU
		
	   SEPARATOR
       MENUITEM "  &C�lculo de la Planilla"   RESOURCE (hRecurso,"CALC16")  ;
        ACTION 																				  ; 		
		IF( Per_Block1,     				Msgalert("Periodo Rem.Bloqueado","No se Procesa"),;	// Si Periodo bloqueado
		  ( IF(fUsua_Uso(),(Upd_Act_User(.F.),oWnd:End()),MsgWait("Adelante",	    "",.01)) ,;	// Si usuario ocupado
		    ValRegRta(),Upd_Avi(),ValActi(0,0),P_CalTPS(1),CarDiaM(1),SwQuince:=.F.			 ,;	// Valid.Dupl,Limpia Switch,Valid Activ,Realiza Acumul del mes  AFP y Essal,Conocer Sab-Dom-Feriado,
			IF(Valid_para(.F.),Msgalert("VALIDAR PARAMETROS","EN LA PROXIMA VENTANA"),)		 ,;	// Valida Parametros
			If(cAvi95,If(cEmFrecue="S",P_VacPro(3,2,1),P_VacPro(3,2,0)),MsgWait("No Promedio","",.01))	 ,;	// Obtiene promedios de Rem.Variables
			P_1VezMes(),			xSalirT:=.F.											 ,;	// Proceso que marca Uso de 1 Vez Mes
			If(cAvi25,	(ActSub("0000",1),ActPlaS(1))	  ,MsgWait("No Subsidios","",.01))	 ,;	// Subsidio
			If(cAvi26,				ActPla_DNL(1)		  ,MsgWait("No Inasistencia","",.01)),;	// Dias No Laborados
			If(cAvi27,	(ActRem(.F.),AcPl_DV(0))		  ,MsgWait("No Vacaciones", "",.01)),;	// Vacaciones
			If(cAvi41,				GePlan_Anex()		  ,MsgWait("No Anexo", 		"",.01)),;	// Guarda Registros co PlAnexo en 1
			If(cAvi51,				P_Cal(0,0,0,1)		  ,MsgWait("No 1er C�lc","",.01))	,; 	// 1er Calculo de Planilla
			If(cAvi95,	(U_Gra_PAG(),U_Acm_DSem()),MsgWait("No GraPag/AcmDias","",.01)),;		// Calcula Gratif Pagada y Dias acum semestre
 			If(cAvi53,     		    Cop_RmF()             ,MsgWait("No Cop_RmF", "",.01))	,; 	// Copia rem Fijas  de planper a Remret
			If(cAvi86,     		    Cop_RmV()             ,MsgWait("No Cop_RmV", "",.01))	,; 	// Copia rem Variab de planper a Remret
			If(cAvi55,   	        Pry_Rem()			  ,MsgWait("No Proy.RmFj,Ext","",.01)),;// Proyecta Rem Fijas, Proy Rem Externa en REMRET	
			If(cAvi65,				Pry_Gra()  			  ,MsgWait("No Proy.Gratif","",.01))  ,;// Proyecta Gratificacion de datos de RemRet 
			If(cAvi94,				Pry_GraRH()			  ,MsgWait("No Toma Grat.Rea","",.01)),;// Toma Gratificaciones de datos Reales de Historicos, sino de Planillas actuales 
			If(cAvi114,				Tom_GraPag()		  ,MsgWait("No Toma Grat.Pag","",.01)),;// Toma Gratificaciones Pagadas Reales de Historicos, sino de Planillas actuales  // Pandemia 
									CaUlSeAn()												  ,;// Solo si Plan.Semanal (Consolida Mes 12)
			If(cAvi115,				Borra_Grat_Rm()		  ,MsgWait("No Borra Gratif","",.01)),; // Borra Gratif/Bonif de Remuneraciones 
			If(cAvi111,				CalculoF15(0)		  ,MsgWait("No Calc.Renta","",.01) )  ,;// Calcula Renta de 5ta 
			If(cAvi112,			    P_Cal(0,0,0,5)		  ,MsgWait("No 2do Calc",  "",.01) )  ,;// 2do Calculo de Planilla					
			If(cAvi56,    		  ( Var_Eps1()												  ,;// Carga variables EPS
								    ActRemEps1()											  ,;// Actualiza Remuneraciones en Hoja de EPS
								    Cal_Eps1(0)												  ,;// Calcula EPS
								    P_Cal(0,0,0,6) )	  ,MsgWait("No Pro_EPS", "",.01) )	  ,;// 3er Calculo de Planilla															/////////////
			If(cAvi101,				SumRmGe()      		  ,MsgWait("No SCTR", "",.01) )		  ,;// Suma Remuneracion General y Ve total de SCTR, Compara y Activa SWITCH para recalculo
			If(cAvi102,				P_Cal(0,0,0,7)   	  ,MsgWait("No Calcula 4", "",.01))	  ,;// 4to calculo siempre y cuando se active en 101 (SumRmGe)
			If(cAvi106,			  ( T_PlaPla(1)												  ,;// Transferencia de campos de La Planilla 
									P_Cal(0,0,0,8) )	  ,MsgWait("No Transer", "",.01))	  ,;// 5to Calculo de Planilla																	 //////////////////
			If(Substr(Emp->EmAviErr,50,1)="1",;
						Msgalert("Final Incorrecto","MAL FINAL")							  ,;
						If(cAvi41,AdPlan_Anex(),)	) 										  ,;// Mensaje final
			Upd_Avi() 																		   ; 
		) )																					   ; // Cierre Final
            MESSAGE  "Proceso del calculo de la planilla";
			When  Substr(cPermis1,061,1) = "S"  .or. SwGbGa
			
			
					    //SumTotEps(1),;											 		// Actualiza Datos EPS
//-------------------------------------------------------------------------------------------------------------------------------			
//-------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------
			
         SEPARATOR
		 SEPARATOR
		 
         MENUITEM "** Solo &Revisi�n de los C�lculos"     RESOURCE (hRecurso,"ON") 
            MENU         PopUp
               MENUITEM "&Valida Remun Planilla VS Modulo Renta"   RESOURCE (hRecurso,"ON")  ;
                  ACTION  P_RmVSbol(0) ;
                  MESSAGE  "Valida las Remuneracion de la Planilla VS el modulo de Renta de Quinta categoria" ;
				  When  ( Substr(cPermis1,062,1) = "S" .and. cAvi43 )   .or. SwGbGa  
				  
			 MENUITEM "&Valida Dsctos Renta de la Planilla VS Modulo Renta"   RESOURCE (hRecurso,"ON")  ;
                  ACTION  P_RmVSbol(1) ;
                  MESSAGE  "Valida los Descuentos de Renta de la Planilla VS el modulo de Renta de Quinta categoria" ;
				  When  ( Substr(cPermis1,062,1) = "S" .and. cAvi44 )   .or. SwGbGa  
				
               SEPARATOR
			   SEPARATOR
			   
		       MENUITEM "&Por Concepto"   RESOURCE (hRecurso,"ON")  ;
                  ACTION  b_RevPla(0,.F.,.F.,0) ;
                  MESSAGE  "Solo Revisi�n del C�lculo de la Planilla por Concepto" ;
				  When Substr(cPermis1,062,1) = "S"  .or. SwGbGa  
				  
               MENUITEM "&Por Trabajador"  RESOURCE (hRecurso,"CLIENTE16")  ;
                  ACTION P_RevPlt(0,.F.,.F.,0) ;
                  MESSAGE "Solo Revisi�n del C�lculo de la Planilla por Tabajador" ;
				  When Substr(cPermis1,062,1) = "S"  .or. SwGbGa

               SEPARATOR
			   SEPARATOR
			   
				MENUITEM "&Por Concepto (Mod)"   RESOURCE (hRecurso,"ON")  ;
					ACTION  b_RevPla(0,.F.,.T.,0) ;
					MESSAGE  "Revisa y MODIFICA datos de la Planilla por Concepto" ;
					When Substr(cPermis1,062,1) = "S"  .or. SwGbGa    
					
				MENUITEM "&Por Trabajador (Mod)"  RESOURCE (hRecurso,"CLIENTE16")  ;
                  ACTION P_RevPlt(0,.F.,.T.,0) ;
                  MESSAGE "Revisa y Modifica dao de la Planilla por Tabajador" ;
				  When Substr(cPermis1,062,1) = "S"  .or. SwGbGa

			/*
               SEPARATOR
			   SEPARATOR
			   
			   MENUITEM "&Revisa C�lculos de Aportes de AFP de Prima de Seguro"    RESOURCE (hRecurso,"BROWSE") ;
				  ACTION P_RevEsa(2) ;
				  MESSAGE  "Revisa C�lculos de Aportes de AFP de prima de Seguro"  ;
				  When  Substr(cPermis1,062,1) = "S"  .or. SwGbGa

			   MENUITEM "&Revisa C�lculos de Aportes de EsSalud"    RESOURCE (hRecurso,"BROWSE") ;
				  ACTION P_RevEsa(1) ;
				  MESSAGE "Revisa C�lculos de Aportes patronales de EsSalud"   ;
				  When  Substr(cPermis1,062,1) = "S"  .or. SwGbGa
			*/
            ENDMENU

			SEPARATOR
			SEPARATOR
			
			MENUITEM "&B O L E T A S   D E   P A G O"  RESOURCE (hRecurso,"IMPRE16")
			MENU         PopUp
					SEPARATOR
					
				 MENUITEM "&Boletas de Pago. Impresi�n directa"  RESOURCE (hRecurso,"IMPRE16") ;
					ACTION SelExeBol(0,0) MESSAGE "Impresi�n de las boletas"   ;
					When Substr(cPermis1,063,1) = "S"  .or. SwGbGa
				   
					SEPARATOR
					SEPARATOR
					
				 MENUITEM "&Boletas - Genera PDF por cada Boleta"   RESOURCE  (hRecurso,"DBFS")  ;
					ACTION SelExeBol(1,0) MESSAGE "Impresi�n de las boletas y/o Genera en PDF";
					When Substr(cPermis1,064,1) = "S"  .or. SwGbGa
					
					SEPARATOR
					SEPARATOR
					
				 MENUITEM "&Boletas - Genera Archivos Comprimidos por cada Boleta generada"   RESOURCE  (hRecurso,"DBFS")  ;
					ACTION ZIP_BOL_PDF() MESSAGE "Generar archivos Comprimidos por cada BOLETA en PDF generada"  ;
					When Substr(cPermis1,065,1) = "S"  .or. SwGbGa					
					
					SEPARATOR
					SEPARATOR
					
				 MENUITEM "&Boletas - Envio por Correo"   RESOURCE (hRecurso,"MAIL") ;
					ACTION Correos(0,0) MESSAGE "Envio por Correo archivos PDF" ;
					When Substr(cPermis1,066,1) = "S"	 .or. SwGbGa
					
					SEPARATOR
					SEPARATOR
			
			
				 MENUITEM "&Recibos (V1) " RESOURCE (hRecurso,"IMPRE16") ;
					ACTION P_Bol45("BOL45",0) ;
					MESSAGE "Impresi�n de los Recibos de 4ta-5ta Categor�a" ;
					When Substr(cPermis1,067,1) = "S"   .or. SwGbGa
					
				 MENUITEM "&Recibos (V2)" RESOURCE (hRecurso,"IMPRE16") ;
					ACTION P_Bol46("BOL46",0) ;
					MESSAGE "Impresi�n de los Recibos de servicios de en general" ;
					When Substr(cPermis1,067,1) = "S"  .or. SwGbGa
			
			EndMenu			
			
			SEPARATOR
			SEPARATOR

			MENUITEM "& PLANILLAS "  RESOURCE (hRecurso,"IMPRE16")
			MENU         PopUp
				SEPARATOR
				 MENUITEM "&rPrevia1" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_Pla("PREVIA  ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia1  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa
				 MENUITEM "&rPrevia2" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_Pla("PREVIA2 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia2   ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa
				 MENUITEM "&rPrevia3" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_Pla("PREVIA3 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia3   ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa
				 MENUITEM "&rPrevia4"  RESOURCE (hRecurso,"IMPRE16") ;
					ACTION Printersetup(),P_Pla("PREVIA4 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia4  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa
				 MENUITEM "&rPrevia5"   RESOURCE (hRecurso,"IMPRE16") ;
					ACTION Printersetup(),P_Pla("PREVIA5 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia5  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
					
				SEPARATOR
				SEPARATOR
				SEPARATOR
					
				
				 MENUITEM "&rPrevia6"   RESOURCE (hRecurso,"REPORT") ;
					ACTION Printersetup(),P_Pla("PREVIA6 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia6   ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa
				 MENUITEM "&rPrevia7"   RESOURCE (hRecurso,"REPORT") ;
					ACTION Printersetup(),P_Pla("PREVIA7 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia7    ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia8"   RESOURCE (hRecurso,"REPORT") ;
					ACTION Printersetup(),P_Pla("PREVIA8 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia8    ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia9"   RESOURCE (hRecurso,"REPORT") ;
					ACTION Printersetup(),P_Pla("PREVIA9 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia9    ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia10"   RESOURCE (hRecurso,"REPORT") ;
					ACTION Printersetup(),P_Pla("PREVIA10 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia10    ;
					When Substr(cPermis1,069,1) = "S"  .or. SwGbGa		
					
				SEPARATOR
				SEPARATOR
				SEPARATOR
				
				 MENUITEM "&rPrevia11" RESOURCE (hRecurso,"CODE")  ;
					ACTION Printersetup(),P_Pla("PREVIA11 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia11  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia12" RESOURCE (hRecurso,"CODE")  ;
					ACTION Printersetup(),P_Pla("PREVIA12 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia12  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia13" RESOURCE (hRecurso,"CODE")  ;
					ACTION Printersetup(),P_Pla("PREVIA13 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia13  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia14" RESOURCE (hRecurso,"CODE")  ;
					ACTION Printersetup(),P_Pla("PREVIA14 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia14  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa	
				MENUITEM "&rPrevia15" RESOURCE (hRecurso,"CODE")  ;
					ACTION Printersetup(),P_Pla("PREVIA15 ",1,0);
					MESSAGE "Impresi�n de la " + rPrevia15  ;
                    When Substr(cPermis1,069,1) = "S"  .or. SwGbGa						

				SEPARATOR
				SEPARATOR
				SEPARATOR		// Planilla actual
			
			EndMenu	
			
			SEPARATOR
			SEPARATOR
		
			MENUITEM "& PLANILLAS Especiales "  RESOURCE (hRecurso,"IMPRE16")
				MENU         PopUp
				MENUITEM "&Planilla Oficial" RESOURCE (hRecurso,"CODE") ;
					ACTION  Printersetup(),P_PlaOfi("PLAOFI  ",1,.F.,0);
					MESSAGE "Impresi�n de la Planilla Oficial"   ;
					When Substr(cPermis1,071,1) = "S"  .or. SwGbGa
					
				MENUITEM "&Planilla Oficial (Version 2)"   RESOURCE (hRecurso,"IMPRE16") ;
					ACTION   (Printersetup(), P_PlaOfi("PLAOFI  ",1,.T.,0));
					MESSAGE  "Impresi�n de la Planilla Oficial (Version 2)"  ;
					When Substr(cPermis1,071,1) = "S"  .or. SwGbGa

				SEPARATOR
				
				MENUITEM "&Planilla por Rangos"   RESOURCE (hRecurso,"IMPRE16") ;
					ACTION   (Printersetup(), P_Plaran("PLARAN  ",1,.T.,0));
					MESSAGE  "Impresi�n de la Planilla Oficial (Version 2)"  ;
					When Substr(cPermis1,071,1) = "S"  .or. SwGbGa

				SEPARATOR
					
				MENUITEM "&Planilla de AFP" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION (Printersetup(),P_PlaAfp("AFP     ",0));
					MESSAGE  "Impresi�n de la Planilla de A.F.P."  ;
					When Substr(cPermis1,072,1) = "S"  .or. SwGbGa

				MENUITEM "&Reporte para envio a AFP / &Genera Archivo Exportaci�n para AFPNET"   RESOURCE (hRecurso,"IMPRE16");
					ACTION ( RevPer2(0), T_GenTXT(0) ) ;
					MESSAGE "Emite el Reporte para envio a las AFPs / Genera Archivo Texto y/o Excel  para envio a AFPNET" ;
					When Substr(cPermis1,072,1) = "S"  .or. SwGbGa
				
				MENUITEM "&Aportes Previsionales" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION (Printersetup(),P_Pla("PREVISIO",1,0));
					MESSAGE  "Impresi�n de la Planilla de Aportes Previsionales"  ;
					When Substr(cPermis1,072,1) = "S"  .or. SwGbGa
					
				SEPARATOR

				MENUITEM "&Resumen de Planilla por Conceptos" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_ResPla();
					MESSAGE  "Resumen de Planilla por Conceptos" ;
					When Substr(cPermis1,073,1) = "S"  .or. SwGbGa
					
				MENUITEM "&Rotaci�n de personal"  RESOURCE (hRecurso,"DATA16") ;
					ACTION R_genRot();
					MESSAGE  "Rotaci�n de personal"    ;
					When Substr(cPermis1,074,1) = "S"  .or. SwGbGa
					
				MENUITEM "&Reporte de Provisiones" RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_PlaPro();
					MESSAGE  "Reporte de Provisiones"  ;
					When Substr(cPermis1,074,1) = "S"  .or. SwGbGa
							
				SEPARATOR

				 MENUITEM "&Lista Planilla con detalles de conceptos"  RESOURCE (hRecurso,"IMPRE16")  ;
					ACTION Printersetup(),P_LisDet();
					MESSAGE  "Lista Planilla con detalles de conceptos"  ;
					When Substr(cPermis1,074,1) = "S"	 .or. SwGbGa

				SEPARATOR
				SEPARATOR
			EndMenu
			
			SEPARATOR
			SEPARATOR
			SEPARATOR
			SEPARATOR
			//----------------------------------------------------
			//----------------------------------------------------
			If cTbPlMeCs
							
							MENUITEM "&CIERRE de Planilla SEMANAL (en Planilla mensual)"  RESOURCE (hRecurso,"CROSS")  ;
							   ACTION P_Cierre(10) ;
							   MESSAGE "Proceso de CIERRE SEMANAL en una Planilla mensual. Se genera Historico Semanal SXAAmmSS"  ;
							   When Substr(cPermis1,074,1) = "S"  .or. SwGbGa
					SEPARATOR
					SEPARATOR
					SEPARATOR
					SEPARATOR
			EndIf
			//----------------------------------------------------
			//----------------------------------------------------			
			MENUITEM "&CIERRE de Planilla de Remuneraciones"   RESOURCE (hRecurso,"CROSS")  ;
				ACTION 	P_Cierre(1) ;
				MESSAGE "Proceso de Cierre de Planilla de Remuneraciones" ;
				When Substr(cPermis1,075,1) = "S"  .or. SwGbGa
			
			SEPARATOR
			SEPARATOR
			SEPARATOR
			SEPARATOR
	
			MENUITEM "&Tabula Planillas a PlanTot (Temporal) x Tipo de Planilla"  RESOURCE (hRecurso,"CALC16") ;
				ACTION K_Conso0(),K_Conso1(0),K_Conso1(1);
				MESSAGE "Consolida Planillas de Rem, Vac, Grat, Liq, y Utilidades y luego las TABULA (por C/Tipo de Planilla)-Genera PLANTOT en cada Directorio (Archivos Temporales)";
				When  Substr(cPermis1,076,1) = "S"  .or. SwGbGa
		
			SEPARATOR
			SEPARATOR
			SEPARATOR
			
			MENUITEM "&Actualiza 5ta Categoria" RESOURCE (hRecurso,"BUGS")  ;
				ACTION P_CieObr(0) ;
				MESSAGE  "Proceso de Actualizaci�n de 5ta Categor�a"  ;
				When  Substr(cPermis1,077,1) = "S"  .or. SwGbGa

			SEPARATOR
			SEPARATOR
			SEPARATOR

			MENUITEM "& PLANILLAS Consolidadas"  RESOURCE (hRecurso,"IMPRE16")
				MENU         PopUp
					MENUITEM "&Consolida Planillas PlanTot de Varias Empresas "  RESOURCE (hRecurso,"DBFS") ;
						  ACTION K_Conso2();
						  MESSAGE "Consolida Planillas PlanTot de varias Empresas" ;
						  When  Substr(cPermis1,078,1) = "S"  .or. SwGbGa
					SEPARATOR
				

					MENUITEM "&Renombre Planilla Consolidada"  RESOURCE (hRecurso,"EDIT") ;
						  ACTION K_Conso4();
						  MESSAGE "Renombra Planilla Consolidada para Posterior emisi�n";
						  When  Substr(cPermis1,078,1) = "S"  .or. SwGbGa
				EndMenu
			SEPARATOR	
			SEPARATOR
			SEPARATOR
      ENDMENU
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      ///SIMULACION/////
      //////////////////
	  //////////////////
      //////////////////
	  
	  If SwProyec3
					MENUITEM  "&Simulaciones" 
					cClaPla   :=  1
					//------------------------
					MENU 
						SEPARATOR
						SEPARATOR						
						
						MENUITEM "           ***  REGISTRA MOVIMIENTO DEL EJERCICIO SIMULADO  *** (PLANPERS) " RESOURCE (hRecurso,"BRWMAL") ;
 						    Message "Registra movimiento del ejercicio por trabajador (Resumen)"
						SEPARATOR
						MENUITEM "  &Inicializa Planilla simulada (Planper ==>> PlanperS)"   RESOURCE (hRecurso,"CALC16")  ;
							ACTION   CopPlan(); 
							MESSAGE  "Proceso de generacion de las Planilla simuladas  (PLANPER --> PLANPERS) " 	;
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
						
						SEPARATOR
						SEPARATOR				
						
						MENUITEM "&Registra Remun.y Desc.Fij.x Concepto "  RESOURCE (hRecurso,"DBFS") ;
							ACTION B_RemF("F",1,0,1) ;
							MESSAGE  "Proceso de Registro de las Remuneraciones y Descuentos Fijos por Concepto-Solo en Planilla de Remuneraciones (PLANPERS)";
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa

						MENUITEM "&Registra Remun.y Desc.Variables x Concepto"  RESOURCE (hRecurso,"DBFS")  ;
							ACTION B_RemF("V",1,0,1) ;
							MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Variables por Concepto (PLANPERS)";
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa

						SEPARATOR
						
						MENUITEM  "&Registra Rem/Desc Fijos/Variab x Trabajador "  RESOURCE (hRecurso,"NEW") ;
							ACTION B_RemPer(0,1) ;
							MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos (Fijos y Variables) por Trabajador" ;
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
						
						SEPARATOR
						SEPARATOR
							
						MENUITEM "  &C�lculo de Planilla General "   RESOURCE (hRecurso,"CALC16")  ;
							ACTION  ( 	Upd_Avi(),ValActi(0,0),P_CalTPS(1),CarDiaM(1),SwQuince:=.F.,xSalirT:=.f.,;
									SwSimula:=.T.,CieAbre(),P_Cal(0,0,0,1),SwSimula:=.F.,CieAbre()  );
									MESSAGE  "Proceso del c�lculo de la Planilla General con datos de la simulacion (PlanperS)" 	;
									When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
									
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
						MENUITEM "           ***  R E V I S I O N   ***  " RESOURCE (hRecurso,"BRWMAL") 
						SEPARATOR
						
						MENUITEM "&Por Concepto"   RESOURCE (hRecurso,"ON")  ;
							ACTION  Q_RevPla(0,.f.) ;
								MESSAGE  "Solo Revisi�n del C�lculo de la Planilla por Concepto (PPLANPER)"    ;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
						  
						MENUITEM "&Por Trabajador"  RESOURCE (hRecurso,"CLIENTE16")  ;
							ACTION Q_RevPlt(0,.f.) ;
								MESSAGE "Solo Revisi�n del C�lculo de la Planilla por Tabajador (PPLANPER)"   			;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
							
					    SEPARATOR
						SEPARATOR						
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
						MENUITEM "           ***  REGISTRA MOVIMIENTO DEL EJERCICIO POR PROYECTO ***  (PPLANPER)" RESOURCE (hRecurso,"BRWMAL") ;
 						    Message "Registra movimiento del ejercicio POR PROYECTO (EN PPLANPER)"
						SEPARATOR
						
						MENUITEM "  &Inicializa Planilla por Proyectos"   RESOURCE (hRecurso,"CALC16")  ;
							ACTION  ( M_IniCC2() ); 
							MESSAGE  "Proceso de generacion de las Planilla por Proyectos (PLANPER --> PPLANPER) " 	;
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
							
						SEPARATOR
						SEPARATOR				
						
						MENUITEM "&Registra Remun.y Desc.Fij.x Concepto "  RESOURCE (hRecurso,"DBFS") ;
							ACTION B_RemF("F",1,0,2);						//  m_RemFpp("F",1,0,1)
							MESSAGE  "Proceso de Registro de las Remuneraciones y Descuentos Fijos por Concepto-Solo en Planilla de Remuneraciones (En PPLANPER)";
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
							

						MENUITEM "&Registra Remun.y Desc.Variables x Concepto"  RESOURCE (hRecurso,"DBFS")  ;
							ACTION B_RemF("V",1,0,2);						//m_RemFpp("V",1,0,1) 
							MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Variables por Concepto  (En PPLANPER)";
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa

						SEPARATOR
						
						MENUITEM  "&Registra Rem/Desc Fijos/Variab x Trabajador "  RESOURCE (hRecurso,"NEW") ;
							ACTION B_RemPer(0,2);						// m_RemPPP(0) 
							MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos (Fijos y Variables) por Trabajador  (En PPLANPER)" ;
							When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
							
						SEPARATOR
						SEPARATOR
						
						MENUITEM "  &C�lculo Simulado de la Planilla por proyectos (PPLANPER)"   RESOURCE (hRecurso,"CALC16")  ;
							ACTION  ( 	Upd_Avi(),ValActi(0,0),P_CalTPS(1),CarDiaM(1), SwQuince:=.F.,;
									SwSimula:=.T.,CieAbre(),P_CalPry(0,0,0,1),SwSimula:=.F.,CieAbre() );
									MESSAGE  "Proceso del c�lculo de la simulacion de la planilla" 			;
									When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
						
									
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
						MENUITEM "           ***  R E V I S I O N   ***  " RESOURCE (hRecurso,"BRWMAL") 
						SEPARATOR
						
						MENUITEM "&Por Concepto"   RESOURCE (hRecurso,"ON")  ;
							ACTION  Q_RevPla(1,.F.) ;
								MESSAGE  "Solo Revisi�n del C�lculo de la Planilla por Concepto (PPLANPER)"    ;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
						  
						MENUITEM "&Por Trabajador"  RESOURCE (hRecurso,"CLIENTE16")  ;
							ACTION Q_RevPlt(1,.F.) ;
								MESSAGE "Solo Revisi�n del C�lculo de la Planilla por Tabajador (PPLANPER)"   ;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
								
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
						MENUITEM "           ***  R E P O R T E S   DE  S I M U L A C I O N ***  (PPLANPER) " RESOURCE (hRecurso,"BRWMAL") 
						SEPARATOR

						MENUITEM "Reporte Previa 1" RESOURCE (hRecurso,"IMPRE16")  ;
							ACTION Printersetup(),P_Pla("PPREVIA",1,0);
								MESSAGE "Impresi�n del Reporte Previa 1 Simulado (PPLANPER)";
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
								
						MENUITEM "Reporte Previa 2" RESOURCE (hRecurso,"IMPRE16")  ;
							ACTION Printersetup(),P_Pla("PPREVIA2",1,0);
								MESSAGE "Impresi�n del Reporte Previa 2 Simulado  (PPLANPER)";
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa

						MENUITEM "Reporte Previa 3" RESOURCE (hRecurso,"IMPRE16")  ;
							ACTION Printersetup(),P_Pla("PPREVIA3",1,0);
								MESSAGE "Impresi�n del Reporte Previa 3 Simulado  (PPLANPER)"		;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
								
						SEPARATOR
						SEPARATOR
						SEPARATOR

						MENUITEM "&Resumen de Planilla por Conceptos  (PPLANPER) " RESOURCE (hRecurso,"IMPRE16")  ;
								ACTION Printersetup(),P_ResPry(0,1);
								MESSAGE  "Resumen de Planilla por Conceptos (PPLANPER)"       ;
								When Substr(cPermis1,079,1) = "S"  .or. SwGbGa
					    SEPARATOR
					ENDMENU

			   

		EndIf
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
    MENUITEM  "&Quinta Categor�a "     
    MENU
            MENUITEM "&Par�metros Generales"  RESOURCE (hRecurso,"TOOLS")  ;
              ACTION  Q_Para2(0) ;
              MESSAGE "Par�metros Generales para el Impuesto a la Renta"     ;
			  When Substr(cPermis1,081,1) = "S"  .or. SwGbGa
			  
		  
            MENUITEM   "&Par�metros por Trabajador"  RESOURCE (hRecurso,"TOOLS")  ;
              ACTION  Q_ParPer(0) ;
              MESSAGE "Par�metros por Trabajador para el Impuesto a la Renta"   ;
			  When Substr(cPermis1,081,1) = "S"  .or. SwGbGa
			  
            MENUITEM   "&Registro de Extranjeros en el File de Personal"  RESOURCE (hRecurso,"TOOLS")  ;
              ACTION  M_RegExt();
              MESSAGE "Registro de Extranjeros en el File de Personal"   ;
			  When Substr(cPermis1,082,1) = "S"  .or. SwGbGa

            SEPARATOR
         		
			MENUITEM  "&Conceptos F�rmulas"  RESOURCE (hRecurso,"FUNCTION") ;
			  ACTION  Q_ConFor();
			  MESSAGE "F�rmulas en conceptos para el Hist�rico del Movimiento Hist�rico" ;
			  When  Substr(cPermis1,083,1) = "S"   .or. SwGbGa
		   
		    SEPARATOR
		    SEPARATOR
           
            MENUITEM   "   &REGISTRO DE REMUNERACIONES Y RETENCIONES  (Proceso principal)"    RESOURCE (hRecurso,"CALC16")  ;
              ACTION  VariaMes(),Q_QuiReg(0),RegreMes();
              MESSAGE  "Registro de Remuneraciones y Retenciones"   ;
			  When  Substr(cPermis1,084,1) = "S"  .or. SwGbGa


            SEPARATOR
            SEPARATOR
		   
		   
            MENUITEM   "&Certificados de Renta"  RESOURCE (hRecurso,"IMPRE16")  ;
              ACTION  VariaMes(),Q_Certi2(),RegreMes();
              MESSAGE  "Emite Certificados de Renta de Quinta Categor�a"  ;
			  When   Substr(cPermis1,085,1) = "S"  .or. SwGbGa
			  
            SEPARATOR
		    SEPARATOR
		   
		    MENUITEM   "&Resumen de Certificados de Renta"  RESOURCE (hRecurso,"IMPRE16")  ;
              ACTION  VariaMes(),Q_Certi2R(),RegreMes();
              MESSAGE  "Emite el Resumen de los Certificados de Renta de Quinta Categor�a";
			  When   Substr(cPermis1,085,1) = "S"  .or. SwGbGa
			  
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR		   
		   
		   MENUITEM "              ******    P R O C E S O     A N U A L  *********"
		   
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR
		   SEPARATOR		   

           MENUITEM "  &Copia Retenciones (REMRET) y Par�metros (Tablas) al Hist�rico (Procedimiento Anual) "  RESOURCE (hRecurso,"ALFINAL")   ;
						ACTION Q_CopHis();
						MESSAGE  "Copia Retenciones (REMRET) y Par�metros (Tablas) al Hist�rico (Procedimiento unicamente Anual)" ;
						When Substr(cPermis1,087,1) = "S"  .or. SwGbGa

		   SEPARATOR
		   
           MENUITEM "  Copia File AFP al Hist�rico  (Procedimiento Anual)"  RESOURCE (hRecurso,"ALFINAL")  ;
               ACTION A_AFPH() ;
               MESSAGE  "Copia File AFP a Hist�rico (Procedimiento unicamente Anual)" ;
			   When Substr(cPermis1,088,1) = "S"  .or. SwGbGa
			   
		   SEPARATOR
		   SEPARATOR
		   
		   
  
		//////////////////
		//////////////////
		//////////////////
		//////////////////
		//////////////////
		//////////////////
		
	    MENUITEM  "&Renta Historica"  
			SwClaPla   :=  1
			cClaPla    :=  1
			MENU   PopUp
	  
			MENUITEM "&Par�metros Generales"  RESOURCE (hRecurso,"TOOLS");
			  ACTION  Q_Para2(1) ;
              MESSAGE "Par�metros Generales para el Impuesto a la Renta"   ;
			  When Substr(cPermis1,089,1) = "S" .or. SwGbGa
			  
            MENUITEM "&Par�metros por Trabajador"  RESOURCE (hRecurso,"TOOLS");
              ACTION Q_ParPer(1) ;
              MESSAGE  "Par�metros por Trabajador para el Impuesto a la Renta" ;
			  When   Substr(cPermis1,089,1) = "S" .or. SwGbGa

            SEPARATOR

            MENUITEM "&Actualiza 5ta Categor�a"   RESOURCE (hRecurso,"FLOPPY");
              ACTION P_CieObr(1) ;
              MESSAGE  "Proceso de Actualizaci�n de 5ta Categor�a - Hist�rico"  ;
			  When Substr(cPermis1,089,1) = "S"  .or. SwGbGa
			  
			SEPARATOR
			
            MENUITEM "&Revisa Hist�rico de a�os anteriores"   RESOURCE (hRecurso,"BROWSE");
			  ACTION VariaMes(),Q_QuiReg(1),RegreMes();
              MESSAGE  "Revisa Hist�rico de  a�os anteriores"  ;
			  When Substr(cPermis1,089,1) = "S" .or. SwGbGa
			
			SEPARATOR			
			
            MENUITEM "&Certificados de Renta Hist�ricos "  RESOURCE (hRecurso,"IMPRE16");
              ACTION   VariaMes(),H_Certi2(),RegreMes();
              MESSAGE  "Emite Certificados de Renta Hist�ricos de a�os anteriores"   ;
			  When Substr(cPermis1,089,1) = "S"  .or. SwGbGa
			  
			SEPARATOR			  
			  
			MENUITEM   "&Resumen de Certificados de Renta"  RESOURCE (hRecurso,"IMPRE16")  ;
              ACTION  VariaMes(),H_Certi2R(),RegreMes();
              MESSAGE  "Emite el Resumen de los Certificados de Renta de Quinta Categor�a" ;
			  When   Substr(cPermis1,089,1) = "S"  .or. SwGbGa
	        SEPARATOR
		ENDMENU
	    
		   
		SEPARATOR
		SEPARATOR
		   
		  
		MENUITEM  "&Importaci�n a Quinta Categor�a"  RESOURCE (hRecurso,"NEW")
				
		MENU   PopUp
		   
		   	MENUITEM   "&Imp.Movim.de 5ta Categ.Remun/Retenc.a File TMP (XLS)(Fmt Rta-Rem )"  RESOURCE (hRecurso,"EXCEL");
				ACTION   (Gen_HojaRR(),WinExec("&RutaW\Pid_RR.exe"));
				MESSAGE "Transfiere data de Hoja de datos de hojas de Movimiento de Renta de 5ta categor�a a File temporal (Formatos RTA-REM )" ;
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
			
			MENUITEM   "&Revisa Archivo importado" RESOURCE (hRecurso,"BROWSE");
				ACTION   A_RevRR();
				MESSAGE "Revisa Archivo de Hoja de Datos del Mov. de 5ta categor�a de las tablas de EXCEL"  ;
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
	
			MENUITEM   "&Transfiere datos a 5ta Categor�a (REMRET)"  RESOURCE (hRecurso,"AVANZA");
				ACTION   A_PasRR(0);
				MESSAGE "Transfiere datos a 5ta categr�a (REMRET)" ;
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
				
			SEPARATOR	
			SEPARATOR	
			SEPARATOR	
			
			MENUITEM   "&Imp.Remun/Dsctos de Renta de EXCEL a File TMP (Fmt RENTA)" RESOURCE (hRecurso,"EXCEL");
				ACTION   (Gen_HojaRR(),S_ImpRta());                       
				MESSAGE "Transfiere data de Hoja de datos (EXCEL) de hojas de Remuneraciones y Descuentos de Renta a File temporal HOJRTA.DBF (Formato RENTA)";
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
			
			MENUITEM   "&Revisa Archivo importado" RESOURCE (hRecurso,"BROWSE");
				ACTION   A_RevRta();
				MESSAGE "Revisa Archivo de Hoja de Datos de las Remuneraciones y Descuentos de las tablas de EXCEL (HOJDAT.DBF)"  ;
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
			
			MENUITEM   "&Reset de Campos de Renta "   RESOURCE (hRecurso,"CROSS");
				  ACTION   A_IniRta();
				  MESSAGE "Reset de campos de Renta, segun los campos que aparecen en la hoja de Datos REMRET.DBF";
				  When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
		
			MENUITEM   "&Transfiere datos a Renta" RESOURCE (hRecurso,"ALFINAL");
				ACTION   A_PasRta();
				MESSAGE "Transfiere datos a Renta (REMRET)";
				When Substr(cPermis1,090,1) = "S"  .or. SwGbGa
				
			SEPARATOR		
			
		ENDMENU
		SEPARATOR
    ENDMENU
	  
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      MENUITEM "&Transferencia al PLAME"
      MENU
		
		MENUITEM "  ******      T - R E G I S T R O   *********"
				
				MENUITEM "&Genera Archivos de Personal"  RESOURCE (hRecurso,"DBFS") ;
				ACTION  A_PerTx2("PER",1 );
				MESSAGE "Genera los archivos textos para exportar datos al PDT del file de personal"  ;
				When Substr(cPermis1,091,1) = "S"  .or. SwGbGa
							
				MENUITEM "&Genera Periodos Laborales por trabajador - (per)"  RESOURCE (hRecurso,"DATABASE") ;
				ACTION  Genera06() ;
				MESSAGE "Genera Periodos laborales por Trabajador. Viene de Periodos Laborales (per)"   ;
				When Substr(cPermis1,092,1) = "S"  .or. SwGbGa
					
				MENUITEM "&Genera Establecimientos donde labora el Trabajador - (est)"   RESOURCE (hRecurso,"DATABASE");
				ACTION  T_EstTr2(0) ;
				MESSAGE "Genera el archivo Texto con los Establecimientos donde labora cada Trabajador (est)";
				When Substr(cPermis1,093,1) = "S"  .or. SwGbGa
					
				SEPARATOR
				SEPARATOR	

				SEPARATOR
				SEPARATOR

				MENUITEM "  ******      P  L  A  M  E   *********"
				
				MENUITEM "&VALIDACION PLAME " RESOURCE (hRecurso,"BTN_OK") ;
					ACTION (T_VPlame(),DbCloseAll(),Abrefiles());
					MESSAGE "Valida Datos de Plame. Planilla Actual VS Historicas cerradas"      ;
					When Substr(cPermis1,094,1) = "S"  .or. SwGbGa
				
				SEPARATOR		
				SEPARATOR		
				
				MENUITEM "&Genera Jornada laboral por Trabajador (jor)" RESOURCE (hRecurso,"DATA16")  ;
					ACTION T_JorLa2();
					MESSAGE "Datos de Jornada laboral por Trabajador - PLAME (jor)"      ;
					When Substr(cPermis1,096,1) = "S"  .or. SwGbGa
				
				SEPARATOR		
				SEPARATOR		
						 
				MENUITEM "&Genera los Dias Subsidiados y otros dias no Laborados (snl)" RESOURCE (hRecurso,"DATA16")  ;
					ACTION T_Sub_NL() ;
					MESSAGE "Genera el archivo Texto con los Dias subsidiados y No laborados (snl)"   ;
					When Substr(cPermis1,097) = "S"  .or. SwGbGa

				SEPARATOR
				SEPARATOR
				
				MENUITEM "&Generaci�n de OTRAS CONDICIONES (toc)" RESOURCE (hRecurso,"DATA16")  ;
					ACTION T_OtrCon() ;
					MESSAGE "Genera el archivo Texto con Otras condiciones. Asegura Tu Pension, EsSalud Vida, Retencion a 4ta, Domiciliado  (toc)";
					When Substr(cPermis1,098) = "S"   .or. SwGbGa

				SEPARATOR
				SEPARATOR
		
				MENUITEM "&Genera planilla de Remuneraciones - Trabajadores (rem)"    RESOURCE (hRecurso,"DATA16")  ;
					 ACTION (RevPlame(.F.),T_GenPl2("BOLSUNAT",0));
					 MESSAGE "Generacion de la Planilla de Remuneraciones - Trabajadores (rem)"   ;
					 When Substr(cPermis1,099,1) = "S"  .or. SwGbGa
		
				SEPARATOR
				SEPARATOR	
				
				MENUITEM "&Genera planilla de Otras Rentas de 5ta Categor�a (or5)"    RESOURCE (hRecurso,"DATA16")  ;
					 ACTION T_OtrR5t();
					 MESSAGE "Genera el archivo Texto de Otras Rentas de 5ta Categor�a percibidas por otro empleador (or5)";
					When Substr(cPermis1,100,1) = "S"  .or. SwGbGa
		
				SEPARATOR
				SEPARATOR	
				
				MENUITEM "&Generaci�n de tasas-SCTR-EsSalud y/o Convenio IES (tas)" RESOURCE (hRecurso,"DATA16")  ;
				ACTION T_TasEss();
				MESSAGE "Genera el archivo Texto con las Tasas SCTR (tas)"            		;
				When Substr(cPermis1,101,1) = "S"  .or. SwGbGa
			
				SEPARATOR
				SEPARATOR	
				SEPARATOR
				SEPARATOR	
					
				 MENUITEM "&Revisa Hist�ricos de Trabajadores"   RESOURCE (hRecurso,"PEOPLE");
					ACTION P_RevPD2(0) ;
					MESSAGE "Revisa Hist�ricos de Trabajadores"  	;
					When Substr(cPermis1,102,1) = "S"  .or. SwGbGa
							
				SEPARATOR
				SEPARATOR
			
				MENUITEM "***  MODALIDAD FORMATIVA  *** ";
				Message " Modalidad Formativa"
				
				SEPARATOR
			
				MENUITEM "    &Genera Establecimientos donde labora el practicante (lug)"  RESOURCE (hRecurso,"DATABASE");
				ACTION T_EstTr2(1) ;
				MESSAGE "Genera el archivo Texto con los Establecimientos donde labora cada Practicante (lug)" ;
				When Substr(cPermis1,103,1) = "S"  .or. SwGbGa
				
				separator
			
				MENUITEM "    &Genera planilla de Remuneraciones (for)"  RESOURCE (hRecurso,"DATABASE");
				ACTION T_GenPl2("BOLSUNAT",1);
				MESSAGE "Generacion de la Planilla de Remuneraciones (for)" ;
				When Substr(cPermis1,104,1) = "S"  .or. SwGbGa
				
				SEPARATOR
				SEPARATOR
				SEPARATOR
				
				MENUITEM "***  ARCHIVOS HISTORICOS  *** ";
				Message " Archivos Historicos"
				
				SEPARATOR
				
				MENUITEM "    &Revisa Hist�ricos PLAME  "  RESOURCE (hRecurso,"PEOPLE");
				ACTION P_RevPD2(1) ;
				MESSAGE "Revisa Hist�ricos de PLAME generados" ;
				When Substr(cPermis1,105,1) = "S"	  .or. SwGbGa
				SEPARATOR
      ENDMENU
	  
	  
	  //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////

      MENUITEM  "&Transfer.BANCOS" 
      MENU
	     SEPARATOR
		 MENUITEM "&Revisa datos de Bancos en Personal"  RESOURCE (hRecurso,"DBFS")  ;
            ACTION T_RevBco();
            MESSAGE  "Revisa datos de bancos en personal" ;     
			When Substr(cPermis1,106,1) = "S" .or. SwGbGa
			
		 SEPARATOR	
		 SEPARATOR	
		 
         MENUITEM "&Genera Archivo Temporal de Pagos"  RESOURCE (hRecurso,"ALFINAl")  ;
            ACTION T_GenTPa(1);
            MESSAGE  "Genera Archivo Temporal de Pagos de la Planilla"      ;
			When Substr(cPermis1,107,1) = "S" .or. SwGbGa

         MENUITEM "&Importa archivo de otra Planilla ( Consolida )"   RESOURCE (hRecurso,"ARRIBA")  ;
            ACTION T_ConTP2();
            MESSAGE   "Importa archivo temporal de Pagos de la Planilla Consolidado (Consolidacion)" ;
			When Substr(cPermis1,108,1) = "S" .or. SwGbGa

         MENUITEM "&Modifica Archivo Temporal de Pagos"  RESOURCE (hRecurso,"PROP")  ;
            ACTION T_ModTPa();
            MESSAGE "Modifica Archivo Temporal de Pagos de la Planilla"   ;
			When Substr(cPermis1,109,1) = "S" .or. SwGbGa
			
		 SEPARATOR	
		 SEPARATOR	
		 SEPARATOR	
		 
		 MENUITEM "&Recibos de Pagos"  RESOURCE (hRecurso,"DBFS")  ;
            ACTION M_AdeRe2();
            MESSAGE  "Emisi�n de los recibos de pagos"       ;
			When Substr(cPermis1,110,1) = "S" .or. SwGbGa
		//-------------------	
         SEPARATOR
		 SEPARATOR
		 SEPARATOR	
		//--------------------
         MENUITEM "&Banco de Cr�dito"   RESOURCE (hRecurso,"PAGOS16") 
            MENU         PopUp
                MENUITEM "&Par�metros" RESOURCE (hRecurso,"TOOLS")  ;
                  ACTION T_ParCre("PARAMETROS DEL BANCO DE CREDITO") ;
                  MESSAGE  "Par�metros del Banco de Cr�dito"              ;
				  When Substr(cPermis1,111,1) = "S" .or. SwGbGa
				  
                SEPARATOR
				                				
                MENUITEM   "&Genera Archivo T.C. (N�mina)" RESOURCE (hRecurso,"DBFS")   ;
                  ACTION T_CreTel(0);
                  MESSAGE  "Genera Archivo de Transf.al Banco de Cr�dito T.C.  (Nomina)"   ;
				  When Substr(cPermis1,111,1) = "S" .or. SwGbGa
				  
				MENUITEM   "&Genera Archivo T.C. (Proveedores)"  RESOURCE (hRecurso,"DBFS")  ;
                  ACTION T_CreTe2();
                  MESSAGE  "Genera Archivo de Transf.al Banco de Cr�dito T.C.  (Proveedores)" ;
				  When Substr(cPermis1,111,1) = "S"  .or. SwGbGa
				  
				MENUITEM   "&Genera Archivo T.C. ( C T S )"  RESOURCE (hRecurso,"DBFS")  ;
                  ACTION T_CreTe3();
                  MESSAGE  "Genera Archivo de Transf.al Banco de Cr�dito T.C.  ( C T S )"   ;
				  When Substr(cPermis1,111,1) = "S"    .or. SwGbGa
				  
                SEPARATOR
			   
                MENUITEM   "&Genera Archivo T.C. (Utilidades)"  RESOURCE (hRecurso,"DBFS")  ;
                  ACTION T_CreTCU();
                  MESSAGE    "Genera Archivo de Transferencia al Banco de Cr�dito T.C. (Utilidades)"  ;
				  When Substr(cPermis1,111,1) = "S" .or. SwGbGa
				SEPARATOR  
            ENDMENU
		//-------------------	
         SEPARATOR
		//------------------- 
         MENUITEM  "&Banco Continental"    RESOURCE (hRecurso,"PAGOS16") 
            MENU         PopUpo
               MENUITEM   "&Par�metros"  RESOURCE (hRecurso,"TOOLS")  ;
                  ACTION T_ParCon() ;
                  MESSAGE "Par�metros del Banco Continental"                                 ;
				  When Substr(cPermis1,112,1) = "S" .or. SwGbGa
				  
               SEPARATOR
			   
               MENUITEM   "&Genera Archivo Texto"  RESOURCE (hRecurso,"DBFS")  ;
                  ACTION T_TraCon() ;
                  MESSAGE   "Genera Archivo de Transferencia al Banco Continental"       ;
				  When Substr(cPermis1,112,1) = "S" .or. SwGbGa
         
            ENDMENU
		//-------------------
         SEPARATOR
		//------------------- 
         MENUITEM  "&Banco ScotiaBank"    RESOURCE (hRecurso,"PAGOS16") 
            MENU         PopUp
               MENUITEM  "&Par�metros"  RESOURCE (hRecurso,"TOOLS")  ;
                  ACTION T_ParSud() ;
                  MESSAGE   "Par�metros del Banco ScotiaBank"                    ;
				  When Substr(cPermis1,113,1) = "S" .or. SwGbGa

               MENUITEM  "&Genera Archivo Texto" RESOURCE (hRecurso,"DBFS")   ;
                  ACTION T_TraSud() ;
                  MESSAGE  "Genera Archivo de Transferencia al Banco ScotiaBank"   ;
				  When Substr(cPermis1,113,1) = "S" .or. SwGbGa

            ENDMENU
		//-------------------
		SEPARATOR
		//-------------------
         MENUITEM  "&Banco INTERBANK"    RESOURCE (hRecurso,"PAGOS16") 
            MENU         PopUp
               MENUITEM    "&Par�metros"  RESOURCE (hRecurso,"TOOLS")  ;
                  ACTION T_ParINT("PARAMETROS BANCO INTERBANK","INTERBANK",1,"99999") ;
                  MESSAGE  "Par�metros del Interbank"                          ;
				  When Substr(cPermis1,114,1) = "S" .or. SwGbGa
				  
				  SEPARATOR
               MENUITEM   "&Genera Archivo Texto - Pagos"  RESOURCE (hRecurso,"DBFS")  ;
                  ACTION T_TraInt() ;
                  MESSAGE  "Genera Archivo Texto para los Pagos al Banco Interbank"   ;
				  When Substr(cPermis1,114,1) = "S" .or. SwGbGa

            ENDMENU

      ENDMENU

      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	
      MENUITEM  "&Tareo-Asistencia"  
	  
	
      MENU
			SEPARATOR
			MENUITEM "&Par�metros"  RESOURCE (hRecurso,"TOOLS") ;
				ACTION (T_ParTar(),oWnd:SetMenu( BuildMenu() ) );
				MESSAGE  "Datos para el Tareo"   ;
				When ( Substr(cPermis1,116,1) = "S" .or. SwGbGa )
				
			SEPARATOR
			SEPARATOR		

			IF cRTarSem			
			
					MENUITEM "*----- P R O C E S O    S E M A N A L ----------*"
					SEPARATOR
					MENUITEM "*--------------T  A  R  E  O--------------------*"
					
					SEPARATOR
					SEPARATOR

					MENUITEM "  Formato &Num�rico Semanal (TareoS).Genera FMT.Excel(TAS)"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION T_Tar1Ex();
						 MESSAGE  "Genera el Formato de Tareo Num�rico de Asistencia diaria (TAS) en la semana de Horas Trab/Capacit/Movilidad/Rotaci�n" ;
						 When Substr(cPermis1,117,1) = "S" .or. SwGbGa
						 
					SEPARATOR
					SEPARATOR
					
					MENUITEM "  Importa Archivo XLS Num�rico (TmpTareo) ***** "  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar1imp();
						 MESSAGE  "Importa el archivo EXCEL del Tareo Num�rico de Dias, Horas (Asistencia diaria) a un Archivo TmpTAREO"   ;
						 When Substr(cPermis1,118,1) = "S" .or. SwGbGa
						 
					MENUITEM "  Revisa Archivo importado (TmpTareo-LST)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar1rvS();
						 MESSAGE  "Revisa el archivo Importado del archivo EXCEL del Tareo Num�rico de Dias, Horas (Asistencia diaria)"   ;
						 When Substr(cPermis1,119,1) = "S" .or. SwGbGa
						 
					MENUITEM "  Hoja de Trabajo para Revisi�n del Tareo" RESOURCE (hRecurso,"IMPRE16")  ;
						ACTION Printersetup(),P_Pla("TAREO1",1,0);
						MESSAGE "Hoja de Trabajo para Revisi�n del Tareo"  ;
						When Substr(cPermis1,120,1) = "S"  .or. SwGbGa
					
					SEPARATOR
					SEPARATOR
					SEPARATOR
					SEPARATOR
					
					MENUITEM "&Actualiza campos para el Pago autom�tico"  RESOURCE (hRecurso,"CROSS")  ;
						ACTION f_Act_Net();
						MESSAGE  "Actualiza campos para el Pago autom�tico. Segun SEMANA actualiza los parametros para la transferencia del Neto a Pagar al PAGO realizado" ;
						When Substr(cPermis1,121,1) = "S"  .or. SwGbGa
						
					
					MENUITEM "&Transfiere Datos en Planilla"  RESOURCE (hRecurso,"AVANZA")  ;
						ACTION T_PlaPla(1);
						MESSAGE  "Transfiere Datos de campos de Planilla a Planilla. Realiza la Transferencia del Neto a Pagar de la semana al PAGO realizado" ;
						When Substr(cPermis1,121,1) = "S"  .or. SwGbGa	
						
					SEPARATOR
					SEPARATOR
					
			Else

				If SwTarNum
				
					  MENUITEM "*----- P R O C E S O    M E N S U A L ----------*"
					  SEPARATOR
					  SEPARATOR
					  
					  MENUITEM "*--------TAREO NUMERICO-------*"
					  SEPARATOR
					  SEPARATOR

								
					  MENUITEM "&Calendario - Tareo. Genera TareoM "   RESOURCE (hRecurso,"PERIODO16") ;
						 ACTION T_CalTar(0) ;
						 MESSAGE "Calendario para el Tareo. Permite Generar TAREOM (Numerico) "   ;
						 When Substr(cPermis1,122,1) = "S" .or. SwGbGa
						 
					  SEPARATOR

					  MENUITEM "  Registro &Num�rico Manual (TareoM). Genera Formato Excel"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION T_Tar1Ex();
						 MESSAGE  "Genera el Formato de Tareo Num�rico de Dias, Horas (Asistencia diaria). Origen TAREOM (Numerico)"   	;
						 When Substr(cPermis1,123,1) = "S" .or. SwGbGa

					  MENUITEM "  Importa Archivo XLS Num�rico (TmpTareo) ***** "  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar1imp();
						 MESSAGE  "Importa el archivo EXCEL del Tareo Num�rico de Dias, Horas (Asistencia diaria) a un Archivo TmpTAREO"   ;
						 When Substr(cPermis1,123,1) = "S" .or. SwGbGa
						 
					  MENUITEM "  Revisa Archivo importado (TmpTareo-BRW)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar1rvl(0);
						 MESSAGE  "Revisa el archivo Importado del archivo EXCEL del Tareo Num�rico de Dias, Horas (Asistencia diaria)"  ;
						 When Substr(cPermis1,123,1) = "S" .or. SwGbGa
						 
					 MENUITEM   "  &Transfiere datos a TAREOM"  RESOURCE (hRecurso,"AVANZA");
						ACTION   T_PasTar1();
						MESSAGE "Transfiere datos a TAREOM" ;
						When ( Substr(cPermis1,124,1) = "S"  .and. gTarSemN = 0 ) .or. SwGbGa
						
						SEPARATOR
						SEPARATOR
						 
					  MENUITEM "  Registro &Num�rico Manual (TareoM) (BRW)"  RESOURCE (hRecurso,"CROSS") ;
							ACTION T_Tar1rvl(1); // T_Ta1RvHB(1);
							MESSAGE  "Registro del Tareo Num�rico de Asistencia (TareoM) (BRW)"  ;
							When ( Substr(cPermis1,125,1) = "S"  .and. gTarSemN = 0 ) .or. SwGbGa
						 
					  MENUITEM "  &Cierre de Tareo Num�rico"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION t_TarCie(1);
						 MESSAGE "Cierre del Tareo Numerico. TAREOM a TAaamm00" 	  ;
						 When ( Substr(cPermis1,125,1) = "S"  .and. gTarSemN = 0 ) .or. SwGbGa

					  MENUITEM "  &Registro Hist�rico Num�rico (BRW)"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION T_Tar1rvl(2);   // t_Ta1rvhB(2);
						 MESSAGE "Tareo del Tareo Num�rico de Asistencia (TAaamm00) - Hist�rico" ;
						 When ( Substr(cPermis1,125,1) = "S"  .and. gTarSemN = 0 ) .or. SwGbGa
				 
					  SEPARATOR
					  SEPARATOR
					  SEPARATOR
					  SEPARATOR
				EndIf
				
				If SwTarAlf
					  MENUITEM "*--------TAREO ALFANUMERICO-------*"
					
						SEPARATOR
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
					   MENUITEM "&Codigos de asistencia - tareo"  RESOURCE (hRecurso,"BROWSE") ;
						ACTION a_Tabr49() ;
						MESSAGE  "Mantenimiento de las Tabla de codigos de asistencia del tareo";
						When  Substr(cPermis1,126,1) = "S"	 .or. SwGbGa
						
					  SEPARATOR
					
					  MENUITEM "&Calendario - Tareo. Genera TareoC"   RESOURCE (hRecurso,"PERIODO16") ;
						 ACTION T_CalTar(1) ;
						 MESSAGE "Calendario para el Tareo. Permite TAREOC (Alfanumerico)";
						 When Substr(cPermis1,127,1) = "S" .or. SwGbGa	
					
					  SEPARATOR
					  
					  MENUITEM "  Tareo - Registro &AlfaNum�rico Manual (TareoC). Genera Formato Excel"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION t_Tar2ex(1);
						 MESSAGE  "Registro del Tareo AlfaNum�rico de los eventos diarios (TAREOC). Genera Formato EXCEL"  ;
						 When Substr(cPermis1,128,1) = "S" .or. SwGbGa
						 
					  MENUITEM "  Tareo - Importa Archivo XLS AlfaNum�rico (TmpTareoC)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar2imp(1);
						 MESSAGE  "Importa el archivo EXCEL del Tareo AlfaNum�rico de Asistencia diaria a un Archivo TmpTAREOC"  ;
						 When Substr(cPermis1,128,1) = "S" .or. SwGbGa	 
						 
					  MENUITEM "  Tareo - Revisa Archivo importado (TmpTareoC-LST)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar2rvl(1);
						 MESSAGE  "Revisa el archivo Importado del archivo EXCEL del Tareo AlfaNum�rico de Asistencia diaria"  ;
						 When Substr(cPermis1,128,1) = "S" .or. SwGbGa				 
						 
					  MENUITEM   "  &Transfiere datos a TAREOC"  RESOURCE (hRecurso,"AVANZA");
						ACTION   T_PasTar2(0);
						MESSAGE "Transfiere datos a TAREOC" ;
						When Substr(cPermis1,129,1) = "S"  .or. SwGbGa
						 
					  SEPARATOR	 
					  SEPARATOR
						 
					  MENUITEM   "  &Revisa TareoC y el Resumen del Tareo (TareoC-LST)"  RESOURCE (hRecurso,"BROWSE");
							ACTION   T_Ta2rvhl();
							MESSAGE "Revisa Archivo del TareoC alfanumerico y el Resumen calculado (TAREOC.DBF) - LST " ;
							When Substr(cPermis1,130,1) = "S"  .or. SwGbGa
							  
					  MENUITEM "  &Cierre de Tareo AlfaNum�rico"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_TarCie(2);
						 MESSAGE "Cierre del Tareo Alfanumerico" ;
						 When Substr(cPermis1,130,1) = "S" .or. SwGbGa
						 
					  MENUITEM "  &Tareo - Registro Hist�rico AlfaNum�rico - LST"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION T_Tar2ex(2);
						 MESSAGE "Registro del Tareo AlfaNum�rico de los eventos diarios Historicos - LST" ;
						 When Substr(cPermis1,130,1) = "S"	  .or. SwGbGa
						 
					  SEPARATOR	 
					  SEPARATOR
					  
				EndIf
				SEPARATOR	 
				SEPARATOR		
				
				
				If SwTarCC
					  MENUITEM "*--------TAREO ALFANUMERICO Y POR C.COSTO-------*"
					
						SEPARATOR
						SEPARATOR
						SEPARATOR
						SEPARATOR
						
					   MENUITEM "&Codigos de asistencia - TareoCC"  RESOURCE (hRecurso,"BROWSE") ;
						ACTION a_Tabr49() ;
						MESSAGE  "Mantenimiento de las Tabla de codigos de asistencia del tareo por C.Costo";
						When  Substr(cPermis1,131,1) = "S"	 .or. SwGbGa
						
					  SEPARATOR
					
					  MENUITEM "&Calendario - Tareo. Genera TareoCC"   RESOURCE (hRecurso,"PERIODO16") ;
						 ACTION T_CalTar(2) ;
						 MESSAGE "Calendario para el Tareo. Permite TAREOCC (Asistencia por C.Costo)" ;
						 When Substr(cPermis1,132,1) = "S" .or. SwGbGa	
					
					  SEPARATOR
					  
					  MENUITEM "  Registro por C.Costo Manual (TareoCC). Genera Formato Excel"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION t_Tar3ex(1);
						 MESSAGE  "Registro del Tareo por C.Costo de los eventos diarios (TAREOCC). Genera Formato EXCEL"   ;
						 When Substr(cPermis1,133,1) = "S" .or. SwGbGa
						 
					  MENUITEM "  Importa Archivo XLS AlfaNum�rico (TmpTareoCC)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar2imp(1);
						 MESSAGE  "Importa el archivo EXCEL del Tareo por C.Costo y Asistencia diaria a un Archivo TmpTAREOCC"  ;
						 When Substr(cPermis1,133,1) = "S" .or. SwGbGa	 
						 
					  MENUITEM "  Revisa Archivo importado (TmpTareoCC-LST)"  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_Tar2rvl(1);
						 MESSAGE  "Revisa el archivo Importado del archivo EXCEL del Tareo porC.Costo y Asistencia diaria"  ;
						 When Substr(cPermis1,133,1) = "S" .or. SwGbGa				 
						 
					  MENUITEM   "  &Transfiere datos a TAREOCC"  RESOURCE (hRecurso,"AVANZA");
						ACTION   T_PasTar2(0);
						MESSAGE "Transfiere datos a TAREOCC" ;
						When Substr(cPermis1,134,1) = "S"  .or. SwGbGa
						 
					  SEPARATOR	 
					  SEPARATOR
						 
					  MENUITEM   "  &Revisa TareoCC y el Resumen del Tareo (TareoCC-LST)"  RESOURCE (hRecurso,"BROWSE");
							ACTION   T_Ta2rvhl();
							MESSAGE "Revisa Archivo del TareoCC por C.Costo y el Resumen calculado (TAREOCC.DBF) - LST " ;
							When Substr(cPermis1,135,1) = "S"  .or. SwGbGa
							  
					  MENUITEM "  &Cierre de Tareo x C.Costo "  RESOURCE (hRecurso,"CROSS") ;
						 ACTION T_TarCie(2);
						 MESSAGE "Cierre del Tareo por C.Costo" ;
						 When Substr(cPermis1,135,1) = "S" .or. SwGbGa
						 
					  MENUITEM "  &TareoCC - Registro Hist�rico x C.Costo - LST"  RESOURCE (hRecurso,"BROWSE") ;
						 ACTION T_Tar3ex(2);
						 MESSAGE "Registro del Tareo por C.Costo de los eventos diarios Historicos - LST" ;
						 When Substr(cPermis1,135,1) = "S"  .or. SwGbGa
						 
					  SEPARATOR	 
					  SEPARATOR
					  
				EndIf
				SEPARATOR	 
				SEPARATOR		
				
				
        EndIf
      ENDMENU
	
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	  
	   MENUITEM "&E.P.S."
		MENU
				SEPARATOR
				SEPARATOR
				SEPARATOR
			 MENUITEM "   ***      P A C I F I C O     ***"
				SEPARATOR
				SEPARATOR
				SEPARATOR
			 MENUITEM "&Par�metros E.P.S. "  RESOURCE (hRecurso,"TOOLS")  ;
				ACTION E_ParPac();
				MESSAGE  "Par�metros para el M�dulo de las Empresas Prestadoras de Salud (PACIFICO)"      ;
				When Substr(cPermis1,137,1) = "S" .or. SwGbGa
			   
			 MENUITEM "&Registro de Asegurados "   RESOURCE (hRecurso,"CLOSEALL")  ;
				ACTION E_AsePac();
				MESSAGE  "Registro de Asegurados (Titular, dependientes e Hijos Mayores de 18,25)  (Pacifico) "  ;
				When Substr(cPermis1,138,1) = "S" .or. SwGbGa
			    
			 MENUITEM "&C�lculo de la Primas (V1) "   RESOURCE (hRecurso,"CALC16")  ;
				ACTION E_PriPac();
				MESSAGE "C�lculo de las Prima de las EPS  (Pacifico) (Version 1)"   ;
				When Substr(cPermis1,139,1) = "S" .or. SwGbGa
				
				/*
			MENUITEM "&C�lculo de la Primas (V2) "  RESOURCE (hRecurso,"CALC16")  ;
				ACTION E_PriPa2();
				MESSAGE "C�lculo de las Prima de las EPS  (Pacifico) (Version 2)" ;
				When Substr(cPermis1,140,1) = "S"	 .or. SwGbGa
				*/

			    SEPARATOR
				SEPARATOR
				SEPARATOR
				
				/*
			MENUITEM "   ***      R I M A C    ***"
				SEPARATOR
				SEPARATOR
				SEPARATOR
			 MENUITEM "&Par�metros E.P.S. "  RESOURCE (hRecurso,"TOOLS")  ;
				ACTION E_Para();
				MESSAGE  "Par�metros para el M�dulo de las Empresas Prestadoras de Salud (RIMAC)"      ;
				When Substr(cPermis1,137,1) = "S" .or. SwGbGa	
				
			 MENUITEM "&Registro de Asegurados "   RESOURCE (hRecurso,"CLOSEALL")  ;
				ACTION E_Asegur();
				MESSAGE  "Registro de Asegurados (Titular, esposa e hijos )  (RIMAC) "  ;
				When Substr(cPermis1,138,1) = "S" .or. SwGbGa

			 MENUITEM "&C�lculo de la Primas  "   RESOURCE (hRecurso,"CALC16")  ;
				ACTION E_Primas();
				MESSAGE "C�lculo de las Prima de las EPS  (RIMAC)"   ;
				When Substr(cPermis1,139,1) = "S" .or. SwGbGa	
				
				SEPARATOR
				SEPARATOR
				SEPARATOR
				*/
		ENDMENU
	  
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
	  //////////////////
	  //////////////////
      // HISTORICOS ////
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
	  //////////////////
      MENUITEM "&Procesos Hist�ricos"
      SwClaPla   :=  1
      cClaPla    :=  1
      MENU
      SEPARATOR

      MENUITEM "           ***  REGISTRA MOVIMIENTO DEL EJERCICIO HISTORICO *** "  ;
                Message "Registra movimiento del ejercicio Historico"
           MENUITEM "&Registra Remun.y Desc.Fijos x Concepto"  RESOURCE (hRecurso,"DBFS");
                ACTION B_RemF("F",1,1,0) ;
                MESSAGE  "Proceso de Registro de las Remuneraciones y Descuentos Fijos por Concepto - Hist�ricas";
                When Substr(cPermis1,146,1) = "S"  .or. SwGbGa

           MENUITEM "&Registra Remun.y Desc.Variables x Concepto"   RESOURCE (hRecurso,"DBFS");
                ACTION B_RemF("V",1,1,0) ;
                MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Variables por Concepto - Hist�ricas";
                When Substr(cPermis1,147,1) = "S" .or. SwGbGa

           MENUITEM "&Registra los conceptos de Remun.y Desctos.==>>Fijos y Variables - Historicas"  RESOURCE (hRecurso,"DBFS")  ;
                ACTION b_RemF("T",1,1,0) ;
                MESSAGE "Proceso de Registro de los conceptos del tipo de Remuneraciones y Descuentos Fijos y Variables";
                When Substr(cPermis1,148,1) = "S"  .or. SwGbGa	

            SEPARATOR

            MENUITEM "&Registra los conceptos Prioritarios "  RESOURCE (hRecurso,"DBFS")  ;
                ACTION b_RemF("P",1,1,0) ;
                MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Prioritarios por Concepto - Hist�ricas";
                When Substr(cPermis1,149,1) = "S" .or. SwGbGa

             MENUITEM "&Registra los conceptos Seleccionados"  RESOURCE (hRecurso,"DBFS")  ;
                ACTION b_RemF("S",1,1,0) ;
                MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos Previa Selecci�n de Concepto - Hist�ricas";
                When Substr(cPermis1,150,1) = "S" .or. SwGbGa	

            SEPARATOR

           MENUITEM "&Registra Rem/Desc F/V x Trabajador"  RESOURCE (hRecurso,"EDIT");
              ACTION b_RemPer(1,0);
              MESSAGE "Proceso de Registro de las Remuneraciones y Descuentos por Trabajador Hist�ricas";
              When Substr(cPermis1,151,1) = "S" .or. SwGbGa

           SEPARATOR

            MENUITEM "   ***  &Registra/Modificar Campos particulares para la planilla actual  ***   " RESOURCE (hRecurso,"WRITE");
                ACTION m_RegTxt(2,3) ;
                MESSAGE "Registra � Modifica Campos particular en el File de la Planilla actual";
                When Substr(cPermis1,152,1) = "S" .or. SwGbGa
           SEPARATOR
           SEPARATOR

            MENUITEM  "&IMPORTACION del Movimiento Historico"  RESOURCE (hRecurso,"NEW")
               MENU
                    MENUITEM   "&Importa Movimiento Remunerativo de EXCEL a File temporal"  RESOURCE (hRecurso,"EXCEL");
                    ACTION  WinExec("&RutaW\Pid_HD.exe");
                    MESSAGE "Transfiere data de Hoja de datos (EXCEL) de hojas de Movimiento Remunerativo y Descuentos a File temporal HOJDAT.DBF" ;
                    When Substr(cPermis1,154,1) = "S"  .or. SwGbGa

             MENUITEM   "&Revisa Archivo importado" RESOURCE (hRecurso,"BROWSE");
						ACTION   A_RevHDA(0);
						MESSAGE "Revisa Archivo de Hoja de Datos del Mov. Remunerativo y Descuentos de las tablas de EXCEL (HOJDAT.DBF)" ;
						When Substr(cPermis1,155,1) = "S"  .or. SwGbGa
						
					SEPARATOR
					SEPARATOR
								
					MENUITEM   "&Reset de Campos de Planilla (Seg�n Hoja de Datos)"   RESOURCE (hRecurso,"CROSS");
						ACTION   A_InPlVa(1,1,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF";
						When Substr(cPermis1,156,1) = "S"  .or. SwGbGa
						
					MENUITEM   "&Reset de Campos de Planilla por Trabajador(Seg�n Hoja de Datos)"   RESOURCE (hRecurso,"CROSS");
						ACTION   A_InPlTR(1,1,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF y por trabajador";
						When Substr(cPermis1,156,1) = "S"  .or. SwGbGa	
						
					MENUITEM   "&Reset de Campos de Planilla (Conceptos:Variables y Formulas desactivadas) "   RESOURCE (hRecurso,"CROSS");
						ACTION   BorHD(1,1,0);
						MESSAGE "Reset de campos de Planilla, segun las columnas que aparecen en la hoja de Datos HOJDAT.DBF";
						When Substr(cPermis1,156,1) = "S"  .or. SwGbGa		
						
					SEPARATOR
					//SEPARATOR
					
					MENUITEM   "   **  TRANSFERENCIA PLANILLA HISTORICA  ** "   RESOURCE (hRecurso,"CROSS")
					
					SEPARATOR
					
					MENUITEM   "&Transfiere datos a Planilla Historica " RESOURCE (hRecurso,"ALFINAL");
						ACTION   A_PasPla(1);
						MESSAGE "Transfiere datos a Planilla Historica " ;
						When Substr(cPermis1,157,1) = "S"  .or. SwGbGa
						
					MENUITEM   "&Revisa Totales Transferidos en Planilla Historica" RESOURCE (hRecurso,"BUSCAR");
						ACTION   A_RevTra(1);
						MESSAGE "Revisa Totales Transferidos en Planilla Historica";
						When Substr(cPermis1,157,1) = "S"  .or. SwGbGa		
						
				ENDMENU		
		   
		   //SEPARATOR
		   SEPARATOR
		   
           MENUITEM "  ***  C � L C U L O   D E   H I S T � R I C O S  ***"  
		   
		   SEPARATOR
		   //SEPARATOR

           MENUITEM "&C�lculo de la Planilla Hist�rica"  RESOURCE (hRecurso,"CALC16");
					  ACTION  If(;
								Per_Block1,;
								Msgalert("Periodo Rem Bloqueado",""),;
								( CarDiaM(1), SwQuince:=.F., H_Cal() ) ;
								 );
					  MESSAGE "Proceso de Rec�lculo de la planilla Hist�rica"  ;
					  When (Substr(cPermis1,158,1) = "S" .and. !vDemo) .or. SwGbGa
			 
			SEPARATOR 
          	   
            MENUITEM "&C�lculo de la Planilla Hist�rica por Periodos y concepto"  RESOURCE (hRecurso,"CALC16");
						ACTION If(;
						Per_Block1,;
						Msgalert("Periodo Rem Bloqueado",""),;
						( CarDiaM(1), SwQuince:=.F., H_CalCon() );
						);
                        MESSAGE "Proceso de Rec�lculo de la planilla Hist�rica por Periodos y concepto"  ;
						When (Substr(cPermis1,158,1) = "S" .and. !vDemo)  .or. SwGbGa

         
		   SEPARATOR
           MENUITEM "  ***  REVISA HIST�RICOS DE 1 PERIODO  ***"  
		   SEPARATOR

         MENUITEM "** &S�lo Revisa C�lculos Por Concepto"  RESOURCE (hRecurso,"BROWSE");
            ACTION B_RevPla(1,.T.,.F.,0);
            MESSAGE "S�lo Revisi�n del C�lculo de la Planilla Hist�rica por Concepto"    ;
            When Substr(cPermis1,159,1) = "S" .or. SwGbGa

         MENUITEM "** &S�lo Revisa C�lculos Por Trabajador"   RESOURCE (hRecurso,"BROWSE");
            ACTION P_RevPlT(1,.T.,.F.,0);
            MESSAGE "S�lo Revisi�n del C�lculo de la Planilla Hist�rica por Tabajador"   ;
			When Substr(cPermis1,159,1) = "S" .or. SwGbGa
			
        
			
          SEPARATOR
		  SEPARATOR
		  
		   MENUITEM "&C�lculo de Planilla - 1,2,3,4,5,6,7 o 8 F�rmulas"        RESOURCE (hRecurso,"TOOLS") ;
					  ACTION  If(;
								Per_Block1,;
								Msgalert("Periodo Rem Bloqueado",""),;
								(CarDiaM(1),P_CalUno()) ;
								);
					  MESSAGE  "C�lculo de Planilla de 1,2,3,4,5,6,7 o 8  F�rmulas que se deben de seleccionar"   ;
					  When  Substr(cPermis1,160,1) = "S"	 .or. SwGbGa  	

           MENUITEM "** &S�lo Revisa-Modifica C�lculos Por Trabajador"   RESOURCE (hRecurso,"BROWSE");
            ACTION P_RevPlT(1,.T.,.T.);
            MESSAGE "REVISA y permite MODIFICAR datos de la Planilla Hist�rica por Tabajador"   ;
			When Substr(cPermis1,160,1) = "S" .or. SwGbGa
			
			SEPARATOR
			SEPARATOR
		    MENUITEM "  ***  REVISA HIST�RICOS DE PERIODOS ACUMULADOS   ***"  
			SEPARATOR
	

            MENUITEM "&Hist�rico de 1 trabajador. Genera Archivo"  RESOURCE (hRecurso,"BROWSE");
              ACTION (H_AnaHis(),H_RevHis());
              MESSAGE "Hist�rico de 1 trabajador. Procesa datos de meses anteriores, generando el archivo Temporal"  ;
			  When  Substr(cPermis1,161,1) = "S"  .or. SwGbGa
			  
            MENUITEM "&Revisi�n del Hist�rico de 1 trabajador"  RESOURCE (hRecurso,"BROWSE");
              ACTION H_RevHis();
              MESSAGE "Revision del Hist�rico de 1 trabajador. Procesado en el Paso anterior en el archivo Temporal"  ;
			  When  Substr(cPermis1,162,1) = "S"  .or. SwGbGa
			  
		    SEPARATOR
			SEPARATOR
		   
            MENUITEM "&Boletas Hist�ricas por Trabajador" RESOURCE (hRecurso,"IMPRE16")  ;
			   ACTION  (PrinterSetup(),P_BolHis("BOLETAS",0)) ;
			   MESSAGE "Emite Boletas Hist�ricas por Trabajador"  ;
               When Substr(cPermis1,163,1) = "S"  .or. SwGbGa
			   
			MENUITEM "&Boletas - Envio por Correo"   RESOURCE (hRecurso,"MAIL") ;
					ACTION Correos(5,1) MESSAGE "Envio por Correo archivos PDF" ;
					When Substr(cPermis1,164,1) = "S"	 .or. SwGbGa
							   
			SEPARATOR
			SEPARATOR	
			SEPARATOR
			SEPARATOR		  
		   
		   MENUITEM "Revisa los Dias No Laborados. Genera Intermitencia de Historia"  RESOURCE (hRecurso,"POINT")  ;
			  ACTION m_NSulab(1,1) ;
			  MESSAGE "Revisa los Dias No Laborados o Inasistencias del personal. Genera Dias de Intermitencia " ;
			  When Substr(cPermis1,165,1) = "S"	 .or. SwGbGa
			  
			SEPARATOR
			SEPARATOR			
			
		//---------------------------------------------
		//---------------------------------------------
		//---------------------------------------------
		  
       
      ENDMENU
	  
      //////////////////
      //////////////////
      //////////////////
	  //////////////////
      // HISTORICOS-2 ///
      //////////////////
      //////////////////
      //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////

      MENUITEM  "&Reportes Hist�ricos"
      SwClaPla   :=  1
      cClaPla    :=  1
      MENU
		   MENUITEM "&Emisi�n de Recibos"  RESOURCE (hRecurso,"IMPRE16");
              ACTION M_AdeRec(1) ;
               MESSAGE  "Emite Recibos de Adelantos de Quincena"  ;
			   When Substr(cPermis1,167,1) = "S"  .or. SwGbGa
			   
			   
			SEPARATOR				
			SEPARATOR
			
       MENUITEM "&B O L E T A S   D E   P A G O"  RESOURCE (hRecurso,"IMPRE16")
            MENU         PopUp
					SEPARATOR
					
					
					MENUITEM "&Boletas de Pago. Impresi�n directa" RESOURCE (hRecurso,"IMPRE16");
						ACTION  (AbreTodo(),SelExeBol(0,1),AbreTodo(),Per_Act(xPerpag));
						MESSAGE "Impresi�n de las boletas en forma directa a las impresoras" ;
							When Substr(cPermis1,168,1) = "S"  .or. SwGbGa

					SEPARATOR
					SEPARATOR

					MENUITEM "&Boletas - Genera PDF por cada Boleta"   RESOURCE  (hRecurso,"DBFS")  ;
						ACTION (AbreTodo(),SelExeBol(1,1),Per_Act(xPerpag)) MESSAGE "Impresi�n de las boletas y/o Genera en PDF" ;
						When Substr(cPermis1,168,1) = "S"  .or. SwGbGa

					SEPARATOR
					SEPARATOR

					MENUITEM "&Boletas - Envio por Correo"   RESOURCE (hRecurso,"MAIL") ;
						ACTION Correos(0,1) MESSAGE "Envio de Boletas por Correo archivos PDF";
						When Substr(cPermis1,168,1) = "S"	 .or. SwGbGa

					SEPARATOR
					SEPARATOR

				   MENUITEM "&Recibos (V1) "  RESOURCE (hRecurso,"IMPRE16");
					ACTION P_Bol45("BOL45",1) ;
					MESSAGE "Impresi�n de los Recibos de 4ta-5ta Categor�a"   ;
					When Substr(cPermis1,169,1) = "S"   .or. SwGbGa

				   MENUITEM "&Recibos (V2)" RESOURCE (hRecurso,"IMPRE16");
					ACTION P_Bol46("BOL46",1) ;
					MESSAGE "Impresi�n de los Recibos de servicios de en general"   ;
					When Substr(cPermis1,169,1) = "S"  	 .or. SwGbGa
					SEPARATOR	   

            EndMenu	

            MENUITEM "&Planillas Previas "  RESOURCE (hRecurso,"IMPRE16")
             MENU         PopUp

					   MENUITEM "&rPrevia1"  RESOURCE (hRecurso,"IMPRE16");
						ACTION Printersetup(),P_Pla("PREVIA  ",1,1);
						MESSAGE "Impresi�n de " + rPrevia1  ;
						When Substr(cPermis1,170,1) = "S" .or. SwGbGa
						
					   MENUITEM "&rPrevia2"  RESOURCE (hRecurso,"IMPRE16");
						ACTION Printersetup(),P_Pla("PREVIA2 ",1,1);
						MESSAGE "Impresi�n de " + rPrevia2  ;
						When Substr(cPermis1,170,1) = "S" .or. SwGbGa
						
					   MENUITEM "&rPrevia3"  RESOURCE (hRecurso,"IMPRE16");
						ACTION Printersetup(),P_Pla("PREVIA3 ",1,1);
						MESSAGE "Impresi�n de " + rPrevia3    ;
						When Substr(cPermis1,170,1) = "S" .or. SwGbGa
						
					   MENUITEM "&rPrevia4"  RESOURCE (hRecurso,"IMPRE16");
						ACTION Printersetup(),P_Pla("PREVIA4 ",1,1);
						MESSAGE "Impresi�n de " + rPrevia4     ;
						When Substr(cPermis1,170,1) = "S" .or. SwGbGa
						
					   MENUITEM "&rPrevia5"   RESOURCE (hRecurso,"IMPRE16") ;
						ACTION Printersetup(),P_Pla("PREVIA5 ",1,1);
						MESSAGE "Impresi�n de la " + rPrevia5  ;
						When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
					
						SEPARATOR
							
						
						 MENUITEM "&rPrevia6"   RESOURCE (hRecurso,"REPORT") ;
							ACTION Printersetup(),P_Pla("PREVIA6 ",1,1);
							MESSAGE "Impresi�n de la " + rPrevia6   ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa
						 MENUITEM "&rPrevia7"   RESOURCE (hRecurso,"REPORT") ;
							ACTION Printersetup(),P_Pla("PREVIA7 ",1,1);
							MESSAGE "Impresi�n de la " + rPrevia7    ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia8"   RESOURCE (hRecurso,"REPORT") ;
							ACTION Printersetup(),P_Pla("PREVIA8 ",1,1);
							MESSAGE "Impresi�n de la " + rPrevia8    ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia9"   RESOURCE (hRecurso,"REPORT") ;
							ACTION Printersetup(),P_Pla("PREVIA9 ",1,1);
							MESSAGE "Impresi�n de la " + rPrevia9    ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia10"   RESOURCE (hRecurso,"REPORT") ;
							ACTION Printersetup(),P_Pla("PREVIA10",1,1);
							MESSAGE "Impresi�n de la " + rPrevia10    ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa		
							
						SEPARATOR
						
						 MENUITEM "&rPrevia11" RESOURCE (hRecurso,"CODE")  ;
							ACTION Printersetup(),P_Pla("PREVIA11",1,1);
							MESSAGE "Impresi�n de la " + rPrevia11  ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia12" RESOURCE (hRecurso,"CODE")  ;
							ACTION Printersetup(),P_Pla("PREVIA12",1,1);
							MESSAGE "Impresi�n de la " + rPrevia12  ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia13" RESOURCE (hRecurso,"CODE")  ;
							ACTION Printersetup(),P_Pla("PREVIA13",1,1);
							MESSAGE "Impresi�n de la " + rPrevia13  ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia14" RESOURCE (hRecurso,"CODE")  ;
							ACTION Printersetup(),P_Pla("PREVIA14",1,1);
							MESSAGE "Impresi�n de la " + rPrevia14  ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa	
						MENUITEM "&rPrevia15" RESOURCE (hRecurso,"CODE")  ;
							ACTION Printersetup(),P_Pla("PREVIA15",1,1);
							MESSAGE "Impresi�n de la " + rPrevia15  ;
							When Substr(cPermis1,170,1) = "S"  .or. SwGbGa						

						SEPARATOR	
						
					  MENUITEM "Previa de Vacaciones"   RESOURCE (hRecurso,"IMPRE16")  ;
						   ACTION P_Pla("PREV_VAC",2,1);
						   MESSAGE  "Planilla Previa de Vacaciones Historica"   ;
						   When Substr(cPermis1,170,1) = "S"  .or. SwGbGa
						
					   MENUITEM "Preva Gratificaciones"  RESOURCE (hRecurso,"IMPRE16")   ;
						   ACTION P_Pla("PREV_GRA",3,1);
						   MESSAGE  "Impresi�n de la Planilla Previa de Gratificaciones Historica"  ;
						   When Substr(cPermis1,170,1) = "S"  .or. SwGbGa
							
						
						
		   ENDMENU

			SEPARATOR		// Historicos

            MENUITEM "&Planilla Oficial"  RESOURCE (hRecurso,"IMPRE16");
              ACTION   P_PlaOfi("PLAOFI  ",1,.F.,1);
              MESSAGE  "Impresi�n de la Planilla Oficial"   ;
			  When Substr(cPermis1,171,1) = "S" .or. SwGbGa
			  
			MENUITEM "&Planilla Oficial (Versi�n 2)"  RESOURCE (hRecurso,"IMPRE16");
              ACTION   P_PlaOfi("PLAOFI  ",1,.T.,1);
              MESSAGE  "Impresi�n de la Planilla Oficial (Versi�n 2)"   ;
			  When Substr(cPermis1,171,1) = "S" .or. SwGbGa
		
            SEPARATOR

            MENUITEM "&Planilla de AFP"  RESOURCE (hRecurso,"IMPRE16");
              ACTION  P_PlaAfp("AFP     ",1);
              MESSAGE "Impresi�n de la Planilla de A.F.P."   ;
			  When Substr(cPermis1,171,1) = "S" .or. SwGbGa
			  
		    MENUITEM "&Reporte para envio a AFP / &Genera Archivo Exportaci�n para AFP NET"   RESOURCE (hRecurso,"IMPRE16");
			  ACTION T_GenTXT(1) ;
              MESSAGE "Emite el Reporte para envio a las AFPs / Genera Archivo Texto y/o Excel  para envio a AFP NET" ;
			  When Substr(cPermis1,171,1) = "S"  .or. SwGbGa
			  
			  
			MENUITEM "&Aportes Previsionales"  RESOURCE (hRecurso,"IMPRE16");
              ACTION  PrinterSetup(),P_Pla("PREVISIO",1,1);
              MESSAGE  "Impresi�n de la Planilla de Aportes Previsionales"   ;
			  When Substr(cPermis1,171,1) = "S" .or. SwGbGa
			  
			SEPARATOR
		   
			MENUITEM "&Resumen de Planilla por Conceptos (H)"  RESOURCE (hRecurso,"IMPRE16");
              ACTION   P_ResPla();
              MESSAGE "Impresi�n de la Planilla Resumen por Conceptos"  ;
			  When Substr(cPermis1,172,1) = "S" .or. SwGbGa

			SEPARATOR

			MENUITEM "&Genera Planilla Consolidada de Hist�ricos con determinados conceptos";
              ACTION H_GenHis();
              MESSAGE "Genera Archivo Hist�rico con acumulado de Conceptos";
			  When Substr(cPermis1,172,1) = "S" .or. SwGbGa

			MENUITEM "&Planilla Detallada"  RESOURCE (hRecurso,"IMPRE16");
              ACTION   P_Pla("DETCON",1,2);
              MESSAGE "Impresi�n de la Planilla Detallada"  ;
			  When Substr(cPermis1,172,1) = "S" .or. SwGbGa
			  
			 MENUITEM "&Planilla Consolidada"  RESOURCE (hRecurso,"IMPRE16");
              ACTION   P_Pla("DETCON",1,3);
              MESSAGE "Impresi�n de la Planilla Consolidada"  ;
			  When Substr(cPermis1,172,1) = "S" .or. SwGbGa 

			

			SEPARATOR

			MENUITEM "&Genera Planilla Hist�rica sin datos"   RESOURCE (hRecurso,"BROWSE");
              ACTION H_GeHiSD();
              MESSAGE "Genera Planilla Hist�rica sin datos";
			  When Substr(cPermis1,175,1) = "S" .or. SwGbGa

      ENDMENU
      //////////////////
      //////////////////
      //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      MENUITEM "&Parametrizaci�n" 
	  
      MENU
			 MENUITEM "  **  PARAMETROS  **" 
			 SEPARATOR
			 MENUITEM "&Par�metros-A : Renta 5ta.Par�metros, Conceptos para Renta, Conceptos Afp, Adelantos y Conceptos de Quincena, EsSalud, SCRT Salud, SCTR Pension"  RESOURCE (hRecurso,"DESIGN")  ;
				ACTION U_ParaA();
				MESSAGE "Par�metros-A : Renta 5ta.Par�metros, Conceptos para Renta, Conceptos Afp, Adelantos y Conceptos de Quincena, EsSalud, SCRT Salud, SCTR Pension" ;
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa

			 SEPARATOR

			 MENUITEM "&Par�metros-B : Conceptos Total Plan.Oficial, Asientos Contables, Contratos, Remun.Inversa, Conc.1 Vez al Mes, Konstantes-Remunerac-Desc Personal"  RESOURCE (hRecurso,"EDIT") ;
				ACTION U_ParaB();
				MESSAGE "Par�metros-B : Conceptos Total Plan.Oficial, Asientos Contables, Contratos, Remun.Inversa, Conc.1 Vez al Mes, Konstantes-Remunerac-Desc Personal";
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa

			 SEPARATOR

			 MENUITEM "&Par�metros-C : Concep.Gratif/Asistencia, Conceptos VARIOS, Cabecera Boletas, Base de Subsidios, Adelantos Semanales, Planilla Semanal"  RESOURCE (hRecurso,"FIELDS")  ;
				ACTION U_ParaC();
				MESSAGE "Par�metros-C : Concep.Gratif/Asistencia, Conceptos VARIOS, Cabecera Boletas, Base de Subsidios, Adelantos Semanales, Planilla Semanal" ;
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa

			 SEPARATOR
			 SEPARATOR

			 MENUITEM "&Par�metros-D : Boletas Stand, Boletas Alternativas, Logos en Gratif/Sunat, Horas Extras, Seleccion Directorios, Mensajes Errores, Textos Correo-Boletas, Direc.Especiales"  RESOURCE (hRecurso,"FUNCTION")  ;
				ACTION U_ParaD();
				MESSAGE  "Par�metros-D : Boletas Stand, Boletas Alternativas, Logos en Gratif/Sunat, Horas Extras, Seleccion Directorios, Mensajes Errores, Textos Correo-Boletas, Direc.Especiales" ;
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa

			 SEPARATOR

			 MENUITEM "&Par�metros-E : Prest.L.Plazo, Prest.C.Plazo, Promedios Provisiones, Configuraciones, Conceptos 4ta, Cuentas 4ta, Certif 4ta, Mensajes Varios"  RESOURCE (hRecurso,"PROP")  ;
				ACTION U_ParaE();
				MESSAGE "Par�metros-E : Prest.L.Plazo, Prest.C.Plazo, Promedios Provisiones, Configuraciones, Conceptos 4ta, Cuentas 4ta, Certif 4ta, Mensajes Varios" ;
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa

			 SEPARATOR
			 SEPARATOR

			 MENUITEM "&Hoja de Par�metros del Periodo"  RESOURCE (hRecurso,"PRINTER")  ;
				ACTION U_HojPar("HOJPAR");
				MESSAGE "Hoja de Par�metros del Periodo"  ;
				When Substr(cPermis1,176,1) = "S"  .or. SwGbGa
				
			 SEPARATOR	
			 SEPARATOR	
			 SEPARATOR	
		  
			//////////////////
			//////////////////
			//////////////////
			//////////////////
			//////////////////
			 MENUITEM  "  **  CONFIGURA REPORTES  **" 
		  
			 SEPARATOR
			 
			 MENUITEM "&Configura Reportes"   RESOURCE (hRecurso,"ORGANICE") ;
				ACTION u_Rep();
				MESSAGE "Configuraci�n de Reportes" ;
				When Substr(cPermis1,177,1) = "S"  .or. SwGbGa
				
			 MENUITEM "&Reportes Configurados"  RESOURCE (hRecurso,"REPORT") ;
				ACTION MsgAlert("Papel A4, Landscape, Ptos  8","Tipo de Papel"),PrinterSetup(),P_Pla("VARIOS",1,0);
				MESSAGE "Lista Reportes Configurados"   ;
				When Substr(cPermis1,177,1) = "S"  .or. SwGbGa
				
			 MENUITEM  "&Reportes Configurados-Hist�ricos"   RESOURCE (hRecurso,"TABLE") ;
				ACTION MsgAlert("Papel A4, Landscape, Ptos  8","Tipo de Papel"),PrinterSetup(),P_Pla("VARIOS",1,1);
				MESSAGE "Lista Reportes Hist�ricos Configurados" ;
				When Substr(cPermis1,177,1) = "S"  .or. SwGbGa

			 SEPARATOR

			 MENUITEM "&Configura Reportes de varios Archivos"  RESOURCE (hRecurso,"ORGANICE")  ;
				ACTION U_RepVar();
				MESSAGE "Configuraci�n de Reportes de varios Archivos del Sistema";
				When  (Substr(cPermis1,178,1) = "S"  .and. !vDemo )  .or. SwGbGa
				
			 MENUITEM "&Configura Reportes de varios Archivos-Fast" RESOURCE (hRecurso,"REPORT")  ;
				ACTION U_CfgPer();
				MESSAGE  "Configuraci�n de Reportes de varios Archivos del Sistema-FAST" ;
				When  Substr(cPermis1,178,1) = "S"  .or. SwGbGa
				
			 MENUITEM "&Genera Archivo para Exportar - Lista" RESOURCE (hRecurso,"TOBACK")  ;
				ACTION P_GenRep();
				MESSAGE "Genera Archivo para exportar, Lista Archivo" ;
				When Substr(cPermis1,178,1) = "S"  .or. SwGbGa
		
			
		     SEPARATOR

		     MENUITEM "&Configurar Deshabilitacion de cabecera (Boleta x Trabajador)" RESOURCE (hRecurso,"TASK")  ;
				ACTION U_CabBol();
				MESSAGE "Configura la deshabilitacion de campos de la Boleta de Pago por trabajador"  ;
				When Substr(cPermis1,179,1) = "S"	 .or. SwGbGa

		   SEPARATOR
		   SEPARATOR
		   SEPARATOR
		   
			  MENUITEM "  **  REPORTES HIST�RICOS  **" 
	             SEPARATOR
				 MENUITEM "&Reporte Acumulado Anual por Conceptos" RESOURCE (hRecurso,"TRAY")  ;
					ACTION  PrinterSetup(),H_RepAcu("VARIOS  ");
					MESSAGE "Reporte Acumulado Anual por Conceptos"  ;
					When (Substr(cPermis1,181,1) = "S"  .and. !vDemo )  .or. SwGbGa

				 SEPARATOR

				 MENUITEM "&Titulos - Reportes Configurados"  RESOURCE (hRecurso,"REPORT")  ;
					ACTION MsgAlert("Papel A4, Landscape, Ptos  8","Tipo de Papel"),PrinterSetup(),P_Platit("VARIOS  ",3);
					MESSAGE "Titulos Reportes Configurados"  ;
					When (Substr(cPermis1,182,1) = "S"  .and. !vDemo )  .or. SwGbGa

				 MENUITEM "&Reportes Configurados-Sin Titulos" RESOURCE (hRecurso,"REPORT")  ;
					ACTION MsgAlert("Papel A4, Landscape, Ptos  8","Tipo de Papel"),PrinterSetup(),P_PlaNot("VARIOS  ",1);
					MESSAGE "Lista Reportes Configurados-Sin Titulos"  ;
					When Substr(cPermis1,182,1) = "S"  .or. SwGbGa

				 SEPARATOR

				 MENUITEM "&Reporte Anualizado-Generacion del Archivo" RESOURCE (hRecurso,"DBFS")  ;
					ACTION H_GenAn1();
					MESSAGE "Reporte Anualizado-Generacion del Archivo" ;
					When (Substr(cPermis1,183,1) = "S"  .and. !vDemo )  .or. SwGbGa

				 MENUITEM "&Reporte Anualizado-Emite Reporte" RESOURCE (hRecurso,"REPORT")  ;
					ACTION MsgAlert("Papel A4, Landscape, Ptos  8","Tipo de Papel"),PrinterSetup(),H_GenAn2("REPANU");
					MESSAGE "Reporte Anualizado-Emisi�n del Reporte" ;
					When (Substr(cPermis1,183,1) = "S"  .and. !vDemo )  .or. SwGbGa

				SEPARATOR

      ENDMENU
  
	  
	  
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
	   //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      //////////////////
      MENUITEM "&Utilitarios"
      MENU
	             SEPARATOR
				 MENUITEM "&Cambio de Periodo"   RESOURCE (hRecurso,"PERIODO16")  ;
					ACTION ( M_trab(0,oWnd,0,0),ActRem(.F.),AcPl_DV(1),ValActi(0,0) );
					MESSAGE  "Opci�n para seleccionar el mes de trabajo"  ;
					When  Substr(cPermis1,191,1) = "S"  .or. SwGbGa
			
		    
				 MENUITEM "&Cambio de Empresa"   RESOURCE (hRecurso,"CLOSEALL")  ;
					ACTION ( U_CamEmp(oWnd," ** PLANVIS STANDAR 2021 ** ",0,1),oWnd:SetMenu(Buildmenu())  );
					MESSAGE "Selecciona Nueva Empresa"  ;
					When  (Substr(cPermis1,192,1) = "S" .and. !vDemo)  .or. SwGbGa
					
					SEPARATOR
		 
				MENUITEM "&Bloqueo de Meses"   RESOURCE (hRecurso,"ORGANICE")  ;
					ACTION ( U_BLOCK(), Bus_Block(xPerPag) );
					MESSAGE "Permite Bloquear los meses ya procesados" ;
					When (Substr(cPermis1,193,1) = "S" .and. !vDemo)  .or. SwGbGa
						
				SEPARATOR
				SEPARATOR				
				
				MENUITEM "   APUNTES para notas futuras"	RESOURCE (hRecurso,"BMP_MODIFICAR");
					ACTION pApuntes();
					MESSAGE "Permite Registrar apuntes para no olvidar temas a futuro" ;
					When  Substr(cPermis1,194,1) = "S"  .or. SwGbGa
					
				 MENUITEM "&Revisa Archivos Texto generado"    RESOURCE (hRecurso,"BRWSMAL")  ;
					ACTION RevTxt();
					MESSAGE  "Revisa Archivos Texto generado" ;
					When Substr(cPermis1,195,1) = "S" .or. SwGbGa
	
				
			    SEPARATOR
				SEPARATOR
				SEPARATOR
			
		
				
				MENUITEM "  &Impresi�n de Documentos Varios"  RESOURCE (hRecurso,"DBFS") ;
					ACTION a_DocVar() ;
					MESSAGE  "Impresi�n de Documentos varios" ;
					When Substr(cPermis1,196,1) = "S"	 .or. SwGbGa
		
			
				SEPARATOR
				SEPARATOR

				 MENUITEM "  &COPIAR - Planilla Actual  ======>>>>>  Hacia EL HIST�RICO ==========>>>>>>"  RESOURCE (hRecurso,"ALFINAL")   ;
					ACTION U_CopHi2();
					MESSAGE "Copiar Planilla Actual hacia EL Hist�rico";
					When (Substr(cPermis1,197,1) = "S"  .and. !vDemo )  .or. SwGbGa
				
				SEPARATOR
				SEPARATOR
				
				 MENUITEM "  &RESTAURAR A PLANILLA ACTUAL <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")  
					MENU POPUP
					
						 MENUITEM "  &Restaurar A PLANILLA (PLAN) Actual <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")   ;
							ACTION (U_CopHis(1),ValActi(0,0));
							MESSAGE "Restaurar A Planilla Actual del Hist�rico ";
							When ( Substr(cPermis1,198,1) = "S" .and. !vDemo )  .or. SwGbGa
							
						MENUITEM "  &Restaurar A PERSONAL (PER) Actual <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")   ;
							ACTION (U_CopHis(2),ValActi(0,0));
							MESSAGE "Restaurar A Personal del Hist�rico ";
							When ( Substr(cPermis1,198,1) = "S" .and. !vDemo )  .or. SwGbGa

						MENUITEM "  &Restaurar A Per_Lab  Actual <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")   ;
							ACTION (U_CopHis(3),ValActi(0,0));
							MESSAGE "Restaurar A Per_Lab  del Hist�rico ";
							When ( Substr(cPermis1,198,1) = "S" .and. !vDemo )  .or. SwGbGa	
							
						 MENUITEM "  &Restaurar A RemRet y Tabla de Par�metros Actual <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")   ;
							ACTION (U_CopHis(4),ValActi(0,0));
							MESSAGE "Restaurar A Rem-Ret y Tabla dde Par�metros Actual del Hist�rico ";
							When ( Substr(cPermis1,198,1) = "S" .and. !vDemo )  .or. SwGbGa	
					ENDMENU		
					
				SEPARATOR
				SEPARATOR	
							
				 MENUITEM "  &Restaurar A AFP      Actual <<<<<<=====  DEL   HISTORICO    <<<<<============"   RESOURCE (hRecurso,"ALPRINCIPIO")   ;
						ACTION U_CopHis(5);
						MESSAGE "Restaurar A Tabla de AFP Actual del Hist�rico ";
						When ( Substr(cPermis1,198,1) = "S" .and. !vDemo )  .or. SwGbGa		
							
					
				SEPARATOR			
				SEPARATOR			
				SEPARATOR
				
				MENUITEM "  &Planilla VS Historico (Comparativo) "   RESOURCE (hRecurso,"DBFS")   ;
					ACTION PLAVSHIS();
					MESSAGE "Verifica si Planilla actual vs Planilla Historica. Si Hay diferencias puede mostrarlas " ;
					When Substr(cPermis1,199,1) = "S"  .or. SwGbGa
					
				SEPARATOR
				
				MENUITEM "  &Renta    VS Historico (Comparativo) "   RESOURCE (hRecurso,"DBFS")   ;
					ACTION RTAVSHIS();
					MESSAGE "Verifica si Renta actual vs Renta Historica. Si Hay diferencias puede mostrarlas " ;
					When Substr(cPermis1,200,1) = "S"  .or. SwGbGa
				
				SEPARATOR			
				SEPARATOR			
				SEPARATOR
				SEPARATOR
				
		If SwGbGA
				
				
				 MENUITEM "  ***  REVISA PLANILLA TEMPORAL DE 1 PERIODO  ***"  
				 SEPARATOR

				 MENUITEM "** &S�lo Revisa C�lculos temporales Por Concepto"  RESOURCE (hRecurso,"BROWSE");
					ACTION B_RevPla(1,.T.,.F.,1);
					MESSAGE "S�lo Revisi�n del C�lculo de la Planilla Temporal por Concepto"    ;
					When SwGbGa

				 MENUITEM "** &S�lo Revisa C�lculos temporales Por Trabajador"   RESOURCE (hRecurso,"BROWSE");
					ACTION P_RevPlT(1,.T.,.F.,1);
					MESSAGE "S�lo Revisi�n del C�lculo de la Planilla temporal por Tabajador"   ;
					When SwGbGa
					
         
				SEPARATOR
				SEPARATOR
				SEPARATOR
				SEPARATOR
		EndIf
		
			 MENUITEM "&Revisa detalle de Auditoria"   RESOURCE (hRecurso,"ALERT")  ;
					ACTION W_DetAud();
					MESSAGE "&Revisa detalle de Auditoria";
					When  Substr(cPermis1,200,1) = "S"  .or. SwGbGa
			
		
				MENUITEM "&Acerca de PLANVIS"  RESOURCE (hRecurso,"EDIT") ;
					ACTION  Acerca();
					MESSAGE "Informaci�n acerca del Sistema de Planillas"
				SEPARATOR	
      ENDMENU
      //////////////////
      //////////////////
      //////////////////
      //////////////////
   ENDMENU

RETURN( oMenu )


//---------------------
Function AbreFiles()
//---------------------
If  !File("&RutaS\PLANPER.DBF") .or. !File("&RutaS\PLANPER.CDX") 
	If File("&RutaS\planold.dbf") .and. File("&RutaS\PlanOld.cdx")
		LZCopyFile("&RutaS\Planold.DBF","&RutaS\PLANPER.DBF" )
		LZCopyFile("&RutaS\Planold.cdx","&RutaS\PLANPER.cdx" )
		Msgalert("Planper Reconstruido","")
	    use &rutaS\Empresa  index &rutaS\Empresa  alias Emp     new   via "dbfcdx"  Shared
		cEmAviErr = Left(Emp->EmAviErr,48) + "  " + Substr(Emp->EmAviErr,51) 
		DbSelectArea("Emp")
		If Bloquea("EMP",3)
			Repl Emp->EmAviErr with cEmAviErr
			DbUnlock()
		EndIf	
		Close("EMP")
	EndIf
EndIf

xSalir = .F.
If  !File("&RutaS\PLANPER.CDX")  
	Msgalert("Reindexar el sistema URGENTE","PLANPER")
	xSalir = .T.
EndIf
If  !File("&RutaS\empresa.cdx") 
	Msgalert("Reindexar el sistema URGENTE","EMPRESA")
	xSalir = .T.
EndIf
If	!File("&RutaS\PerPag.cdx")  
	Msgalert("Reindexar el sistema URGENTE","PERPAG")
	xSalir = .T.
EndIf
If	!File("&RutaS\Personal.cdx")
	Msgalert("Reindexar el sistema URGENTE","PERSONAL")
	xSalir = .T.
EndIf
If	!File("&RutaS\CtoCto.cdx")  
	Msgalert("Reindexar el sistema URGENTE","CTOCTO")
	xSalir = .T.
EndIf
If	!File("&RutaS\Formatos.cdx")
	Msgalert("Reindexar el sistema URGENTE","FORMATOS")
	xSalir = .T.
EndIf
If	!File("&RutaS\PlaCal.cdx")  
	Msgalert("Reindexar el sistema URGENTE","PLACAL")
	xSalir = .T.
EndIf
If	!File("&RutaS\GruAsi.cdx")  
	Msgalert("Reindexar el sistema URGENTE","GRUASI")
	xSalir = .T.
EndIf
If	!File("&RutaS\PlanVac.cdx") 
	Msgalert("Reindexar el sistema URGENTE","PLANVAC")
	xSalir = .T.
EndIf
If	!File("&RutaS\PlanGra.cdx") 
     Msgalert("Reindexar el sistema URGENTE","PLANGRA")
	 xSalir = .T.
EndIf

If  !File("&RutaS\TAACTIVI.DBF")  .or.;
	!File("&RutaS\TANACION.DBF")  .or.;
	!File("&RutaS\TAOCUPUB.DBF")  .or.;
	!File("&RutaS\TAPAISES.DBF")  .or.;
	!File("&RutaS\TALARDIS.DBF")  .or.;
	!File("&RutaS\TAUBIGEO.DBF")  .or.;
	!File("&RutaS\TAOCUPRI.DBF")  .or.;
	!File("&RutaS\Partidas.DBF")  .or.;
	!File("&RutaS\TAPLIEGO.DBF")       
		Msgalert("Realizar Reestructuracion de Tablas Nuevas","")
	    xSalir = .T.		
EndIf

If xSalir
	 QUIT
	 Return
EndIf


If !File("&RutaS\PLANTOT.DBF")
     LZCopyFile("&RutaS\PLANPER.DBF" ,"&RutaS\PLANTOT.DBF" )
     LZCopyFile("&RutaS\PLANPER.CDX" ,"&RutaS\PLANTOT.CDX" )
EndIf

  use &rutaS\Empresa  index &rutaS\Empresa  alias Emp     new   via "dbfcdx"  Shared
  use &rutaS\Usuarios index &rutaS\Usuarios alias User    new   via "dbfcdx"  Shared
  use &rutaS\Tablas   index &rutaS\Tablas   alias Tablas  new   via "dbfcdx"  Shared
  use &rutaS\Tablas2  index &rutaS\Tablas2  alias Tablas2 new   via "dbfcdx"  Shared
  use &rutaS\Empres2  index &rutaS\Empres2  alias Emp2    new   via "dbfcdx"  Shared
  
  AvRutGen()

  use &rutaS\PerPag   index &rutaS\PerPag   alias Ppg     new   via "dbfcdx"  Shared
  
  use &rutaAFP\Afp    index &rutaAFP\Afp    alias Afp     new   via "dbfcdx"  Shared
  use &rutaAFP\AfpI   index &rutaAFP\AfpI   alias AfpI    new   via "dbfcdx"  Shared
  use &rutaS\Concepto index &rutaS\Concepto alias Con     new   via "dbfcdx"  Shared
  use &rutaS\Personal index &rutaS\Personal alias Per     new   via "dbfcdx"  Shared
  use &rutaS\PlanCta  index &rutaS\Plancta  alias Plan    new   via "dbfcdx"  Shared
  
  If SwSimula
		use &rutaS\PlanPerS  index &rutaS\PlanPerS  alias PlanPer new   via "dbfcdx"  Shared
  Else
		use &rutaS\PlanPer   index &rutaS\PlanPer   alias PlanPer new   via "dbfcdx"  Shared
  EndIf  
  
  use &rutaS\CtoCto   index &rutaS\Ctocto   alias Cto     new   via "dbfcdx"  Shared
  use &rutaS\CtoCto2  index &rutaS\Ctocto2  alias Cto2    new   via "dbfcdx"  Shared
  use &rutaS\CtoCto3  index &rutaS\Ctocto3  alias Cto3    new   via "dbfcdx"  Shared
  use &rutaS\Area     index &rutaS\Area     alias Area    new   via "dbfcdx"  Shared
  use &rutaS\Condici  index &rutaS\Condici  alias Condi   new   via "dbfcdx"  Shared
  use &rutaS\Catego   index &rutaS\Catego   alias Cate    new   via "dbfcdx"  Shared
  use &rutaS\Billetes index &rutaS\Billetes alias Bille   new   via "dbfcdx"  Shared

  use &rutaS\Formatos index &rutaS\Formatos alias Fmt     new   via "dbfcdx"  Shared
  use &rutaS\Bancos   index &rutaS\Bancos   alias Ban     new   via "dbfcdx"  Shared
  use &rutaS\PlanVac  index &rutaS\PlanVac  alias PlanVac new   via "dbfcdx"  Shared
  use &rutaS\PlanGra  index &rutaS\PlanGra  alias PlanGra new   via "dbfcdx"  Shared
  use &rutaS\PlanTot  index &rutaS\PlanTot  alias PlanTot new   via "dbfcdx"  Shared
  use &rutaS\PlanLiq  index &rutaS\PlanLiq  alias PlanLiq new   via "dbfcdx"  Shared
  use &rutaS\PlanUti  index &rutaS\PlanUti  alias PlanUti new   via "dbfcdx"  Shared
  use &rutaS\Audito   index &rutaS\Audito   alias Audito  new   via "dbfcdx"  Shared

  use &rutaS\Prestamo index &rutaS\Prestamo alias Presta  new   via "dbfcdx"  Shared
  use &rutaS\PresDeta index &rutaS\PresDeta alias PreDet  new   via "dbfcdx"  Shared
  
  use &rutaS\Feriados index &rutaS\Feriados alias FERIA   new   via "dbfcdx"  Shared

  If File("&rutaS\RemRetAn.dbf")
	use &rutaS\RemRetAn index &rutaS\RemRetAn alias RemRetAn new   via "dbfcdx"  Shared
  Else
		MsgWait("Creando el archivo RemRetAn","",1)
		copy File  &rutaS\RemRet.dbf  To &RutaS\RemRetAn.dbf
		copy File  &rutaS\RemRet.Cdx  To &RutaS\RemRetAn.Cdx
  EndIf  
  use &rutaS\RemRet   index &rutaS\RemRet   alias RemRet   new   via "dbfcdx"  Shared
  use &rutaS\HlCarFam index &rutaS\HlCarFam alias HCFam   new   via "dbfcdx"  Shared  
  
  use &rutaS\HLVACACI index &rutaS\HLVACACI alias HVACA   new   via "dbfcdx"  Shared
  use &rutaS\Cargos   index &rutaS\Cargos   alias Cargos  new   via "dbfcdx"  Shared
  
  use &rutaS\TaRTPS2  index &rutaS\TaRTPS2  alias TaRTPS2  new   via "dbfcdx"  Shared
  use &rutaS\TaConce  index &rutaS\TaConce  alias TaConce  new   via "dbfcdx"  Shared

  If File(RutaS+"\MaeEst.dbf")
	use &rutaS\MaeEst   index &rutaS\MaeEst   alias MaeEst   new   via "dbfcdx"  Shared
  Else
	msgalert("ERROR GRAVE","Archivo MAEEST no ubicado")
	msgalert("ERROR GRAVE","Archivo MAEEST no ubicado")
  EndIf  

  use &rutaS\Subsi    index &rutaS\Subsi    alias Subsi    new   via "dbfcdx"  Shared
  use &rutaS\NDiaLab  index &rutaS\NDiaLab  alias NDiaLab  new   via "dbfcdx"  Shared
  use &rutaS\Otr_Emp  index &rutaS\Otr_Emp  alias Otr_Emp  new   via "dbfcdx"  Shared
  use &rutaS\Per_Lab  index &rutaS\Per_Lab  alias Per_Lab  new   via "dbfcdx"  Shared
  use &rutaS\Contrato index &rutaS\Contrato alias Contra   new   via "dbfcdx"  Shared
  use &rutaS\Documen  index &rutaS\Documen  alias Docu     new   via "dbfcdx"  Shared
  use &rutaS\GruAsi   index &rutaS\GruAsi   alias GruAsi   new   via "dbfcdx"  Shared
  use &rutaS\PlaCal   index &rutaS\PlaCal   alias PlaCal   new   via "dbfcdx"  Shared
  If File("&RutaS\TAREOC.DBF")
		use &rutaS\TareoC   index &rutaS\TareoC   alias TareoC   new   via "dbfcdx"  Shared
  Else
		Msgalert("TareoC No Ubicado","Ejecutar Arreglo de estructuras")
  EndIf
 
  If File("&RutaS\TAREOCC.DBF")
		use &rutaS\TareoCC   index &rutaS\TareoCC   alias TareoCC   new   via "dbfcdx"  Shared
  Else
		Msgalert("TareoCC No Ubicado","Ejecutar Arreglo de estructuras")
  EndIf
  
  use &rutaS\TareoM   index &rutaS\TareoM   alias TareoM   new   via "dbfcdx"  Shared
  use &rutaS\TarDia   index &rutaS\TarDia   alias TarDia   new   via "dbfcdx"  Shared
  use &rutaS\Partidas index &rutaS\Partidas alias Parti    new   via "dbfcdx"  Shared

DbSelectArea("Tartps2")
Set Order to 1
Clave = "0049" + Space(08)
Seek Clave
If !Found()
	Msgalert("Actualizar Tablas VARIAS - TARTPS2 -","Avisar a su Proveedor URGENTE")
	Msgalert("Actualizar Tablas VARIAS - TARTPS2 -","Avisar a su Proveedor URGENTE")
	Return NIL
EndIf


If Con->(Fieldpos("CPDFO_AD")) = 0
		Msgalert("Revisar Estructura de Conceptos","CpDFo_AD...ARRE01")
		Return NIL
EndIf

  DbSelectArea("User")
  Seek TopUser
  GraT2()

RETURN (NIL)




//------------------------
Function R_PerLab()  // RETIROS Hacia Personal
//------------------------
   LOCAL  oDlg, oBrw
   Local  oFont5, oFontT, oFontC, cAlias
   LOCAL  oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oBtn6, oBtn7, oBtn8, oBtn9, oBtnA, oBtnB, oBtnC, oBtnD, oBtnF, oBtnG
   Private oPeFolati, oPeFolaff, oPeFolafi
   Private cPeFolaff, cPeFolati, dPeFolati, cPeFolafi
    Private oPeFolati, oPeFolaff, oPeFolafi
   Private cPeFolaff, cPeFolati, dPeFolati, cPeFolafi
   
   /*
    CLR_100 := RGB(196,255,254)
	CLR_200 := RGB(255,255,174)
	CLR_300 := RGB(255,255,034) 
	CLR_400 := RGB(034,142,249)
	CLR_500 := RGB(134,142,249)
	CLR_600 := RGB(226,224,156)
	CLR_700 := RGB(145,255,252)
	CLR_800 := RGB(145,255,220)
	CLR_900 := RGB(100,100,100)
   */
   
   cPic	   := "@Z 99999,999.99"
   cTexto  := "Registro de RETIROS MASIVOS en el file de Personal"
   Dbselectarea("per")
   DbGoBottom()
   NumRegFil:=  OrdKeyno()
   Set Filt to
   set order to 2
   DbGoTop()
   cPeFolafi = Ctod("  /  /    ")
   cPeFolaff = Ctod("  /  /    ")
   cPeFolati = 1
   dPeFolati = "  "
  
   //--------------------
   FontGene(cTipLetra,cTamFont,cTipBold,cTipItal)
   DEFINE FONT oFontT NAME "Ms Sans Serif" 	SIZE 0, -08 BOLD
   DEFINE FONT oFontL NAME "Arial" 			SIZE 0, -09 BOLD
   DEFINE FONT oFontB NAME "TAHOMA"        	SIZE 0, -12 BOLD

   DEFINE DIALOG oDlg RESOURCE "Archivos_BRW" Title cTexto  Font oFonPlc
				oBrw   := TxBrowse():New( oDlg )
				cAlias := Alias()
				oBrw   :  cAlias := cAlias
				oBrw:bClrSelFocus 		 := {|| { CLR_990 , CLR_995  }}
				oBrw:nMarqueeStyle 		 :=  MARQSTYLE_HIGHLROW
				oBrw:nColDividerStyle    := LINESTYLE_BLACK            // LINESTYLE_INSET
				oBrw:nRowDividerStyle    := LINESTYLE_BLACK			   // LINESTYLE_INSET
				oBrw:lColDividerComplete := .t. 	//completa pintado hasta el footer cuando lineas no llenan todo el browse
				oBrw:bClrStd 			 := {|| IF(MOD(PER->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_100}   ) }   // Color	para la fila Normal
				oBrw:nHeaderHeight		 :=  35		// Altura encabezados
				oBrw:nRowHeight			 :=  20		// Altura del Renglon
				oBrw:nHeaderLines        :=  2
				oBrw:nDataLines          :=  1
				oBrw:nFreeze             :=  4
				oBrw:lHScroll 			 := .t.    // FALSE  // TRUE
				oBrw:lVScroll 			 := .t.    // FALSE  // TRUE
				oBrw:lFastEdit			 := .t.    // .t.= edicion rapida, salta a sig col
				oBrw:lRecordSelector     := .t.    //  poner o no, COL de la flechita de la izq
				oBrw:bClrHeader    		 := {||  {  CLR_BLACK,CLR_700  } }  
			    oBrw:bClrFooter    		 := {||  {  CLR_BLACK,CLR_800  } }  		
				oBrw:lSeekWild     		 := .T.
			    oBrw:lIncrFilter   		 := .T.
				oBrw:l2007				 := .F.	
				oBrw:lAllowColSwapping	 :=.F.
			    oBrw:lAllowColHiding	 :=.F.
			    oBrw:lGradientComplete   :=.T.
				oBrw:nFooterHeight		 :=  25		// Altura del Footer
				oBrw:nFooterLines		 :=  2
				oBrw:lFooter			 := .T.
				oBrw:lExcelCellWise		 := .T.
				oBrw:lAutoSort			 := .T.
				oBrw:nStretchCol		 := STRETCHCOL_NONE
				oBrw:lFastEdit			 := .T.   
				oBrw:oFont				 := oFontL
				oBrw:bKeyChar 			 := {|nKey| If(nKey==VK_ESCAPE, oDlg:End(), nKey) }
				oBrw:bLDblClick			 :={|| 	( MarRet(), oBrw:Refresh(), oBrw:setFocus(.t.) ) }
				oBrw:bkeydown			 :={|key|if(key=13,(MarRet(), oBrw:Refresh(), oBrw:setFocus(.t.)  ) ,.t. )}
				
				//---------------------------------	
				//---------------------------------
				//---------------------------------	
				//---------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "C�digo" 
				oCol:bStrData  			:= { || Per->PeCodEmp}
				oCol:nWidth    		 	:= 050
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cSortOrder			:="PER1"
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				oCol:cToolTip 			:="Haga doble Click para ordenar por Codigo"   
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Apellidos y Nombres"
				oCol:bStrData  			:= { ||  Left(alltrim(Per->PeApelli)+" "+alltrim(Per->PeApell2)+" "+;
												 alltrim(Per->PeNombre)+" "+Alltrim(Per->PeNombr2),35)  }       
				oCol:cSortOrder			:="PER2"	
				oCol:nDataStrAlign   	:= AL_LEFT  
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cToolTip			:="Haga doble Click para Clasificar por Apellidos"  
				oCol:oHeaderFont		:=oFontL	
				oCol:cFooter			:= TRANSFORM(NumRegFil,"99,999") + " Registros"  	
				//------------------------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "D N I" 
				oCol:bStrData  			:= { || Per->PeLibEle }                              
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cSortOrder			:="PER8"
				oCol:cToolTip			:="Haga doble Click para Clasificar por D N I"           
				oCol:oHeaderFont		:=oFontL				
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Centro de Costo" 
				oCol:bStrData  			:= { || Alltrim(Per->PeCtoCto)+" "+Left(Cto->CtDescri,20)}
				oCol:nWidth    		 	:= 160
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:cSortOrder			:="PER6"
				oCol:cToolTip			:="Haga doble Click para Clasificar por C.Costo" 
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Fecha de"+CRLF+"Ingreso"              
				oCol:bEditValue 		:= { || Per->PeFecIng }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Fecha de"+CRLF+"Retiro"              
				oCol:bEditValue 		:= { || Per->PeFecRet }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Marca" 
				oCol:bStrData  			:= { || If(Per->PeMarca="R","Ret",If(Per->PeMarca="I","Ing",""))}
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "F.Ingres"+CRLF+"Masivo"              
				oCol:bEditValue 		:= { || Per->PeFolaFi }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "F.Retiro"+CRLF+"Masivo"              
				oCol:bEditValue 		:= { || Per->PeFoLaff }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Motivo" 
				oCol:bStrData  			:= { || Per->PeFolati }
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Descrip"+CRLF+"Motivo"
				oCol:bStrData  			:= { || BusMot(Per->PeFolati) }
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Activ" 
				oCol:bStrData  			:= { || IIf(Per->PeActivi>0.and.Per->PeActivi<8,Left(ArrActi[Per->PeActivi],10),"   ") }                              
				oCol:nWidth    		 	:= 050
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
   
     
          REDEFINE BUTTON oBtn1 ID 171 OF oDlg  Action ( DatRen(2),oBrw:Refresh(), oBrw:setFocus(.t.) )
          REDEFINE BUTTON oBtn2 ID 172 OF oDlg  Action ( BorMar(), oBrw:Refresh(), oBrw:setFocus(.t.) )
          REDEFINE BUTTON oBtn3 ID 128 OF oDlg  Action ( MarRet(), oBrw:Refresh(), oBrw:setFocus(.t.) )
		  REDEFINE BUTTON oBtn4 ID 129 OF oDlg  Action ( BorTod(2),oBrw:Refresh(), oBrw:setFocus(.t.) )
		  REDEFINE BUTTON oBtn5 ID 130 OF oDlg  ACTION ( OrdPla9(1),Dbsetorder(gOrden),oBrw:GoBottom(), oBrw:Refresh(), oBrw:setFocus(.t.) )
		  REDEFINE BUTTON oBtn6 ID 131 OF oDlg  
		  
		  REDEFINE BUTTON oBtnF ID 4001 OF oDlg ACTION ( DbGoTop(),		oBrw:GoUp(),	oBrw:Refresh(), oBrw:SetFocus(.T.) )
		  REDEFINE BUTTON oBtnG ID 4002 OF oDlg ACTION ( DbGoBottom(),	oBrw:GoBottom(),oBrw:Refresh(), oBrw:SetFocus(.T.) )
		  
	      REDEFINE BUTTON oBtn7 ID 170 OF oDlg 
          REDEFINE BUTTON oBtn8 ID 180 OF oDlg 
          REDEFINE BUTTON oBtn9 ID 260 OF oDlg 	  
		  REDEFINE BUTTON oBtnA ID 200 OF oDlg
          REDEFINE BUTTON oBtnB ID 127 OF oDlg
		  REDEFINE BUTTON oBtnC ID 210 OF oDlg 
          REDEFINE BUTTON oBtnD ID 175 OF oDlg
          REDEFINE BUTTON       ID 240 OF oDlg ACTION oDlg:End()
		  
		  oBtnF:cTitle("Inicio")    
		  oBtnF:cToolTip := "Permite ir al inicio del archivo segun clasificaci�n"  
		  oBtnG:cTitle("Final")
		  oBtnG:cToolTip := "Permite ir al Final del archivo segun clasificaci�n" 	
		  
		  oBtn1:cTitle("Pide datos")
          oBtn1:cToolTip := "Solicita Datos masivos para la Renuncia. Fecha y Tipo de Renuncia"
		  oBtn2:cTitle("Borra Retiro")
          oBtn2:cToolTip := "Borra fecha Final del Registro se�alado, Tipo de Renuncia y marca de masivo"
		  oBtn3:cTitle("RETIRO")
          oBtn3:cToolTip := "Marca la fecha Final del Registro se�alado, Tipo de Renuncia y marca de masivo"
		  
		  oBtn4:cTitle("Borra TODO")
          oBtn4:cToolTip := "Borra las marcas de todo el archivo"
		  
		  oBtn5:cTitle("Clasif")
          oBtn5:cToolTip := "Permite reclasificar el archivo de personal"
		  		  
		//---------------------------------------
		oBrw:CreateFromResource(181)
		//---------------------------------------
   ACTIVATE DIALOG oDlg CENTERED On Init ( oBtn6:Hide(),oBtn7:Hide(),oBtn8:Hide(),oBtn9:Hide(),;
										   oBtnA:Hide(),oBtnB:Hide(),oBtnC:Hide(),oBtnD:Hide(),;
										   oBtnF:Show(),oBtnG:Show())
   dbSelectArea("Per")
   Set Rela To
   Set Filter to
   DbGoTop()
RETURN( NIL )



//------------------------
Function IM_Perso()  // Hacia Personal
//------------------------
   LOCAL  oDlg
   Local  oFont5, oFontT, oFontC, cAlias, oBtnE, oBtnF
   LOCAL  oBtn1, oBtn2, oBtn3, oBtn4, oBtn5, oBtn6, oBtn7, oBtn8, oBtn9, oBtnA, oBtnB, oBtnC, oBtnD
   Private oPeFolati, oPeFolaff, oPeFolafi
   Private cPeFolaff, cPeFolati, dPeFolati, cPeFolafi
   /*
    CLR_100 := RGB(196,255,254)
	CLR_200 := RGB(255,255,174)
	CLR_300 := RGB(255,255,034) 
	CLR_400 := RGB(034,142,249)
	CLR_500 := RGB(134,142,249)
	CLR_600 := RGB(226,224,156)
	CLR_700 := RGB(145,255,252)
	CLR_800 := RGB(145,255,220)
	CLR_900 := RGB(100,100,100)
*/
   cPic	   := "@Z 99999,999.99"
   cTexto  := "Registro de INGRESOS MASIVOS en el file de Personal"
   Dbselectarea("per")
   DbGoBottom()
   NumRegFil:=  OrdKeyno()
   set filter to
   set order to tag Per2
   DbGoTop()
   cPeFolafi = Ctod("  /  /    ")
   cPeFolaff = Ctod("  /  /    ")
   cPeFolati = 1
   dPeFolati = "  "
   //--------------------
   FontGene(cTipLetra,cTamFont,cTipBold,cTipItal)
   DEFINE FONT oFontT NAME "Ms Sans Serif" 	SIZE 0, -08 BOLD
   DEFINE FONT oFontL NAME "Arial" 			SIZE 0, -09 BOLD
   DEFINE FONT oFontB NAME "TAHOMA"        	SIZE 0, -12 BOLD

   DEFINE DIALOG oDlg RESOURCE "Archivos_BRW" Title cTexto  Font oFonPlc
				oBrw   := TxBrowse():New( oDlg )
				cAlias := Alias()
				oBrw   :  cAlias := cAlias
				oBrw:bClrSelFocus 		 := {|| { CLR_990 , CLR_995  }}
				oBrw:nMarqueeStyle 		 :=  MARQSTYLE_HIGHLROW
				oBrw:nColDividerStyle    := LINESTYLE_BLACK            // LINESTYLE_INSET
				oBrw:nRowDividerStyle    := LINESTYLE_BLACK			   // LINESTYLE_INSET
				oBrw:lColDividerComplete := .t. 	//completa pintado hasta el footer cuando lineas no llenan todo el browse
				oBrw:bClrStd 			 := {|| IF(MOD(PER->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_100}   ) }   // Color	para la fila Normal
				oBrw:nHeaderHeight		 :=  35		// Altura encabezados
				oBrw:nRowHeight			 :=  20		// Altura del Renglon
				oBrw:nHeaderLines        :=  2
				oBrw:nDataLines          :=  1
				oBrw:nFreeze             :=  4
				oBrw:lHScroll 			 := .t.    // FALSE  // TRUE
				oBrw:lVScroll 			 := .t.    // FALSE  // TRUE
				oBrw:lFastEdit			 := .t.    // .t.= edicion rapida, salta a sig col
				oBrw:lRecordSelector     := .t.    //  poner o no, COL de la flechita de la izq
				oBrw:bClrHeader    		 := {||  {  CLR_BLACK,CLR_700  } }  
			    oBrw:bClrFooter    		 := {||  {  CLR_BLACK,CLR_800  } }  		
				oBrw:lSeekWild     		 := .T.
			    oBrw:lIncrFilter   		 := .T.
				oBrw:l2007				 := .F.	
				oBrw:lAllowColSwapping	 :=.F.
			    oBrw:lAllowColHiding	 :=.F.
			    oBrw:lGradientComplete   :=.T.
				oBrw:nFooterHeight		 :=  25		// Altura del Footer
				oBrw:nFooterLines		 :=  2
				oBrw:lFooter			 := .T.
				oBrw:lExcelCellWise		 := .T.
				oBrw:lAutoSort			 := .T.
				oBrw:nStretchCol		 := STRETCHCOL_NONE
				oBrw:lFastEdit			 := .T.   
				oBrw:oFont				 := oFontL
				oBrw:bKeyChar 			 := {|nKey| If(nKey==VK_ESCAPE, oDlg:End(), nKey) }
				oBrw:bLDblClick			 :={|| 	( MarIng(), oBrw:Refresh(), oBrw:setFocus(.t.) ) }
				oBrw:bkeydown			 :={|key|if(key=13,(MarIng(), oBrw:Refresh(), oBrw:setFocus(.t.)  ) ,.t. )}
				
				//---------------------------------	
				//---------------------------------
				//---------------------------------	
				//---------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "C�digo" 
				oCol:bStrData  			:= { || Per->PeCodEmp}
				oCol:nWidth    		 	:= 050
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cSortOrder			:="PER1"
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				oCol:cToolTip 			:="Haga doble Click para ordenar por Codigo"   
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Apellidos y Nombres"
				oCol:bStrData  			:= { ||  Left(alltrim(Per->PeApelli)+" "+alltrim(Per->PeApell2)+" "+;
												 alltrim(Per->PeNombre)+" "+Alltrim(Per->PeNombr2),35)  }       
				oCol:cSortOrder			:="PER2"	
				oCol:nDataStrAlign   	:= AL_LEFT  
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cToolTip			:="Haga doble Click para Clasificar por Apellidos"  
				oCol:oHeaderFont		:=oFontL	
				oCol:cFooter			:= TRANSFORM(NumRegFil,"99,999") + " Registros"  	
				//------------------------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "D N I" 
				oCol:bStrData  			:= { || Per->PeLibEle }                              
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:bClrStd 			 := {|| IF(  MOD(Per->(OrdKeyNo()),2) == 0, {CLR_BLACK, CLR_WHITE}, {CLR_BLACK,CLR_500 } ) }   // Color	para la fila Normal
				oCol:cSortOrder			:="PER8"
				oCol:cToolTip			:="Haga doble Click para Clasificar por D N I"           
				oCol:oHeaderFont		:=oFontL				
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Centro de Costo" 
				oCol:bStrData  			:= { || Alltrim(Per->PeCtoCto)+" "+Left(Cto->CtDescri,20)}
				oCol:nWidth    		 	:= 160
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:bClrHeader 		:= { ||  {CLR_BLACK,CLR_300 }	}
				oCol:cSortOrder			:="PER6"
				oCol:cToolTip			:="Haga doble Click para Clasificar por C.Costo" 
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Fecha de"+CRLF+"Ingreso"              
				oCol:bEditValue 		:= { || Per->PeFecIng }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Fecha de"+CRLF+"Retiro"              
				oCol:bEditValue 		:= { || Per->PeFecRet }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Marca" 
				oCol:bStrData  			:= { || If(Per->PeMarca="R","Ret",If(Per->PeMarca="I","Ing",""))}
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "F.Ingres"+CRLF+"Masivo"              
				oCol:bEditValue 		:= { || Per->PeFolaFi }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "F.Retiro"+CRLF+"Masivo"              
				oCol:bEditValue 		:= { || Per->PeFoLaff }                              
				oCol:cEditPicture  	    := "@D"
				oCol:nWidth    		 	:= 070
				oCol:nDataStrAlign   	:= AL_CENTER
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Motivo" 
				oCol:bStrData  			:= { || Per->PeFolati }
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Descrip"+CRLF+"Motivo"
				oCol:bStrData  			:= { || BusMot(Per->PeFolati) }
				oCol:nWidth    		 	:= 080
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:bLClickHeader 		:= {|| oBrw:GoTop() }	
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				oCol:=oBrw				:AddCol()
				oCol:cHeader   			:= "Activ" 
				oCol:bStrData  			:= { || IIf(Per->PeActivi>0.and.Per->PeActivi<8,Left(ArrActi[Per->PeActivi],10),"   ") }                              
				oCol:nWidth    		 	:= 050
				oCol:nDataStrAlign   	:= AL_LEFT
				oCol:nHeadStrAlign 		:= AL_CENTER //LEFT
				oCol:oHeaderFont		:=oFontL
				//-------------------------------
				
				
   
      
          REDEFINE BUTTON oBtn1 ID 171 OF oDlg  Action ( DatRen(1),oBrw:Refresh(), oBrw:setFocus(.t.) )
          REDEFINE BUTTON oBtn2 ID 172 OF oDlg  Action ( BorMar(), oBrw:Refresh(), oBrw:setFocus(.t.) )
          REDEFINE BUTTON oBtn3 ID 128 OF oDlg  
		  REDEFINE BUTTON oBtn4 ID 129 OF oDlg  Action ( BorTod(1),oBrw:Refresh(), oBrw:setFocus(.t.) )
		  REDEFINE BUTTON oBtn5 ID 130 OF oDlg  ACTION ( OrdPla9(1),DbSetorder(gorden),oBrw:GoUp(),oBrw:Refresh(), oBrw:setFocus(.t.) )
		  REDEFINE BUTTON oBtn6 ID 131 OF oDlg  Action ( MarIng(), oBrw:Refresh(), oBrw:setFocus(.t.) )
		  
		  REDEFINE BUTTON oBtnE ID 4001 OF oDlg  Action  ( DbGoTop(),		oBrw:GoUp(),	oBrw:Refresh(), oBrw:SetFocus(.T.) )
		  REDEFINE BUTTON oBtnF ID 4002 OF oDlg  Action  ( DbGoBottom(),	oBrw:GoBottom(),oBrw:Refresh(), oBrw:SetFocus(.T.) )
		  
	      REDEFINE BUTTON oBtn7 ID 170 OF oDlg 
          REDEFINE BUTTON oBtn8 ID 180 OF oDlg 
          REDEFINE BUTTON oBtn9 ID 260 OF oDlg 	  
		  REDEFINE BUTTON oBtnA ID 200 OF oDlg
          REDEFINE BUTTON oBtnB ID 127 OF oDlg
		  REDEFINE BUTTON oBtnC ID 210 OF oDlg 
          REDEFINE BUTTON oBtnD ID 175 OF oDlg
          REDEFINE BUTTON       ID 240 OF oDlg ACTION oDlg:End()
		  
		  oBtnE:cTitle("Inicio")    
		  oBtnE:cToolTip := "Permite ir al inicio del archivo segun clasificaci�n"  
		  oBtnF:cTitle("Final")
		  oBtnF:cToolTip := "Permite ir al Final del archivo segun clasificaci�n" 
		  
		  oBtn1:cTitle("Pide datos")
          oBtn1:cToolTip := "Solicita Datos masivos para la Renuncia. Fecha y Tipo de Renuncia"
		  oBtn2:cTitle("Borra Ingreso")
          oBtn2:cToolTip := "Borra fecha de ingresos masiva y marca de Ingreso del trabajador"
		  		  
		  oBtn4:cTitle("Borra TODO")
          oBtn4:cToolTip := "Borra TODO las marcas de todo el archivo"
		  
		  oBtn5:cTitle("Clasif")
          oBtn5:cToolTip := "Permite reclasificar el archivo de personal"
		  
		  oBtn6:cTitle("INGRESO")
          oBtn6:cToolTip := "Marca la fecha de Ingreso "
		  
		  //---------------------------------------
			oBrw:CreateFromResource(181)
		  //---------------------------------------
		  
      	 
   ACTIVATE DIALOG oDlg CENTERED On Init ( oBtn3:Hide(),oBtn7:Hide(),oBtn8:Hide(),;
											oBtn9:Hide(),oBtnA:Hide(),oBtnB:Hide(),oBtnC:Hide(),;
											oBtnD:Hide(),oBtnE:Show(),oBtnF:Show() )
   dbSelectArea("Per")
   Set Rela To
   Set Filter to
   DbGoTop()
RETURN( NIL )






//------------------------
Function U_PerLab()  // Actualiza Personal y Periodos Laborales
//------------------------
Local ContaI, ContaR
PidCla()
If xSalir
   Return NIL
EndIf
If cClave <> "PLANVIS"
	Msgalert("Proceso Abortado","")
	xSalir = .T.
	Return NIL
endif
//------
DbSelectArea("PER")
Set Filt To
ContaI = 0
ContaR = 0
Do While !Eof()
	If  ( ( Per->PeMarca = "R" .or. Per->PeMarca = "I" )  .and. Per->PeDobPun = 0 )
			If Per->PeMarca = "R" 
					//-----Validar----------
					Ubi_PL = .f.
					Clave = Per->PeCodEmp + DTOS(Per->PeFecing)
					Set Exact Off
					DbSelectArea("PER_LAB")   
					Set Order To tag pela1
					Seek Clave
					//msgalert("/"+Clave+"/")
					If Found()
					    /*
						Do While !Eof() .and. Per_Lab->PlCodemp = Clave
								If Per->PeFecIng = Per_Lab->PlFecIni
									DbSelectArea("PER_LAB")   
									If Bloquea("PER_LAB",3)
										Repl Per_Lab->PlPerPag with xPerPag       
										Repl Per_Lab->PlFecFin with Per->PeFoLaFF
										Repl Per_Lab->PlFiPeTr with Per->PeFoLaTi
										DbUnLock()
									EndIf	
									Ubi_PL = .T.
									Exit
								Endif
								DbSelectArea("PER_LAB")   
								DbSkip()
						EndDo
						*/
						DbSelectArea("PER_LAB")   
						If Bloquea("PER_LAB",3)
							Repl Per_Lab->PlPerPag with xPerPag       
							Repl Per_Lab->PlFecFin with Per->PeFoLaFF
							Repl Per_Lab->PlFiPeTr with Per->PeFoLaTi
							DbUnLock()
						EndIf	
						Ubi_PL = .T.
					else
					    msgalert("Personal no ubica su Registro en Periodos :" + Clave,"")
					EndIf
					If !Ubi_PL
						DbSelectArea("PER_LAB")   
						DbAppend1()
						If Bloquea("PER_LAB",3)
							Repl Per_Lab->PlPerPag with xPerPag       
							Repl Per_Lab->PlTipo   with 1
							Repl Per_Lab->PlCodEmp with Per->PeCodEmp
							Repl Per_Lab->PlCatGen with "01"
							Repl Per_Lab->PlFecIni with Per->PeFecIng
							Repl Per_Lab->PlFecFin with Per->PeFoLaFF
							Repl Per_Lab->PlFiPeTr with Per->PeFoLaTi
							Repl Per_Lab->PlLibEle with Per->PeLibEle
							Repl Per_Lab->PlApeNom with Alltrim(Per->PeApelli)+" "+Alltrim(Per->PeApell2)+" "+Alltrim(Per->PeNombre)+" "+Alltrim(Per->PeNombr2)
							DbUnLock()
						EndIf	
					EndIf
					//-----Fin valid--------
					ContaR = ContaR + 1
					DbSelectArea("PER")   
					If Bloquea("PER",3)
						Repl Per->PeFecRet with Per->PeFoLaFF
						Repl Per->PeDobPun with 1
						DbUnLock()
					EndIf	
					//----------------------------------------------
					//----------------------------------------------
					//----------------------------------------------
			Else
					//----------------------------------------------
					//-----------Ingreso-----------------------------
					//-----------------------------------------------
					//-----Validar----------
					Ubi_Mal = .f.
					Clave = Per->PeCodEmp
					Set Exact Off
					DbSelectArea("PER_LAB")   
					Set Order To tag pela1
					Seek Clave
					If Found()
						Do While !Eof() .and. Per_Lab->PlCodemp = Clave
								If  Day(Per_Lab->PlFecIni) = 0 .or. Day(Per_Lab->PlFecFin) = 0
									Msgalert("En Periodos Laborales hay algun registro sin CERRAR","Codigo : " + Clave + " " + Alltrim(Per->Peapelli))
									Ubi_Mal = .T.
									Exit
								Endif
								DbSelectArea("PER_LAB")   
								DbSkip()
						EndDo
					EndIf
					//-----------------------
					If !Ubi_Mal
								ContaI = ContaI + 1
								DbSelectArea("PER")   
								If Bloquea("PER",3)
									Repl Per->PeFecIng with Per->PeFoLaFI
									Repl Per->PeFecRet with CtoD("  /  /    ")
									Repl Per->PeDobPun with 1
									DbUnLock()
								EndIf	
								DbSelectArea("PER_LAB")   
								DbAppend1()
								If Bloquea("PER_LAB",3)
									Repl Per_Lab->PlPerPag with xPerPag       
									Repl Per_Lab->PlTipo   with 1
									Repl Per_Lab->PlCodEmp with Per->PeCodEmp
									Repl Per_Lab->PlCatGen with "01"
									Repl Per_Lab->PlFecIni with Per->PeFoLaFI
									Repl Per_Lab->PlFiPeTr with "  "
									Repl Per_Lab->PlLibEle with Per->PeLibEle
									Repl Per_Lab->PlApeNom with Alltrim(Per->PeApelli)+" "+Alltrim(Per->PeApell2)+" "+Alltrim(Per->PeNombre)+" "+Alltrim(Per->PeNombr2)
									DbUnLock()
								EndIf	
					EndIf
					//------------------------
			EndIf
	EndIf
	DbSelectArea("PER")   
	DbSkip()
EndDo
//-------
DbCommit()
If SwEnVeda
			Set Filter To ( Per->PeActivi < 6 .and. Per->PeActVed = 0 )
Else
			Set Filter To Per->PeActivi < 6 
EndIf	
DbGoTop()
Msgalert(" Ingresos    : " + Str(ContaI,10)+CRLF+ CRLF +" Renuncias : " + Str(ContaR,10),"Proceso de Update terminado")
Return  NIL  




//-----------------------
Static Function BorMar()
//-----------------------
msgwait( "","", 0.0001 )
DbSelectArea("Per")
 If Bloquea("PER",3)
     Repl Per->PeMarca    With " "
	 Repl Per->PeFolaFI   with Ctod("  /  /    ")
	 Repl Per->PeFolaFF   with Ctod("  /  /    ")
	 Repla Per->PeFolati  with "  "
	 Repla Per->PeDobPun  with 0
     DbUnLock()
 EndIf
 DbCommit()
Return NIL



//-----------------------
Static Function BorTod(Var2)
//-----------------------
msgwait( "","", 0.0001 )
DbSelectArea("Per")
Set Filter To
DbGoTop()
Do While !Eof()
	 If Bloquea("PER",3)
		 Repla Per->PeMarca    With " "
		 Repla Per->PeFolaFI   with Ctod("  /  /    ")
		 Repla Per->PeFolaFF   with Ctod("  /  /    ")
		 Repla Per->PeFolati   with "  "
		 Repla Per->PeDobPun   with 0
		 DbUnLock()
	 EndIf
	 DbSkip()
EndDo 
DbCommit()
If var2 = 1
	If SwEnVeda
			Set Filter To ( Per->PeActivi < 6 .and. Per->PeActVed = 0 )
	Else
			Set Filter To Per->PeActivi < 6 
	EndIf	
EndIf
DbGoTop()
Return NIL


//-----------------------
Static Function MarRet()
//-----------------------
msgwait( "","", 0.0001 )
If day(cPeFoLaff) = 0 .or. Empty(dPeFolati)
	msgalert("Pedir Fecha y Tipo de Renuncia primero","")
Else
	DbSelectArea("Per")
	If Day(Per->PeFecRet) = 0
		 If Bloquea("PER",3)
			 Repla Per->PeMarca   With "R"
			 Repla Per->PeFoLaff  with cPeFolaff
			 Repla Per->PeFolati  with dPeFolati
			 Repla Per->PeDobPun  with 0
			 DbUnLock()
		 EndIf
		 DbCommit()	
	 else
		msgalert("Tiene fecha de Retiro","")
	 endif
EndIf
Return NIL




//-----------------------
Static Function MarIng()
//-----------------------
msgwait( "","", 0.0001 )
If day(cPeFoLaff) = 0 
	msgalert("Pedir Fecha de Ingreso primero","")
Else
	If Day(Per->PeFecRet) > 0
		DbSelectArea("Per")
		 If Bloquea("PER",3)
			 Repla Per->PeMarca   With "I"
			 Repla Per->PeFoLafi  with cPeFolaff
			 Repla Per->PeFolati  with "  "      
			 Repla Per->PeDobPun  with 0
			 DbUnLock()
		 EndIf
	 Else
		msgalert("NO Tiene Fecha de Retiro anterior","")
     EndIf	 
	 DbCommit()
endif 
Return NIL





//-------------------------
Static Function BusMot(Var1) 
//-------------------------
Local xPefolati
NomMot = Space(10)
cPeFolati = 1
If !Empty(Var1)
	xPeFolati = aScan(ArrMotFi,Var1)
	If xPeFolati > 1
		cPefolati = Left(ArrMotFi[xPeFolati],2)
		NomMot    = Alltrim(Substr(ArrMotFi[xPeFolati],4))
	EndIf
EndIf
Return NomMot





//------------------------
Static Function datRen(VarIR)
//------------------------
Local oDlg
Local oAAAA,cAAAA
cPeFolaff = cFecRep
cPeFolati = 1
cAAAA = ""

DbSelectArea("PER")
If varIR = 1
	cTexto = "Datos masivos para el Ingreso. Solicita fecha de Ingreso"
	Set Filter To
Else
	cTexto = "Datos masivos para la Renuncia. Solicita fecha de Renuncia y Tipo de Renuncia"
	If SwEnVeda
		Set Filter To ( Per->PeActivi < 6 .and. Per->PeActVed = 0 )
	Else
		Set Filter To Per->PeActivi < 6 
	EndIf	
EndIf
DbGoTop()

DEFINE DIALOG oDlg RESOURCE "D_HISREIN2" Title cTexto   Font oFonPlc
   
   REDEFINE GET      oPeFolaff VAR cPeFolaff                ID 182 OF oDlg   Picture "@D"
   REDEFINE BUTTON                                          ID 161 OF oDlg   ACTION   MSGDATE(cPeFolaff,"Fecha Final    ",oPeFolaff)

   REDEFINE GET      oAAAA     VAR cAAAA                    ID 163 OF oDlg  
   REDEFINE COMBOBOX oPeFolati VAR cPeFolati ITEMS ArrMotFi ID 195 OF oDlg

   REDEFINE BUTTON ID 175 OF oDlg ACTION ( lSave := .T. , oDlg:End() )
   REDEFINE BUTTON ID 240 OF oDlg ACTION ( oDlg:End() )

ACTIVATE DIALOG oDlg CENTERED  On Init IIf(VarIR=1,(oPeFolati:Hide(),oAAAA:Hide()),"")

If varIR = 2
	dPeFolati = Left(ArrMotFi[cPeFolati],2)
else
    dPeFolati = "  "	
EndIf	
Return NIL
//---------------------------------------------------


Function xlsOpen()
Return NIL

Function xlsWrite()
Return NIL

Function xlsClose()
Return NIL




//-------------------------------------------
Static Function SelExeBol(VarMail1,VarHis)
//-------------------------------------------
VarHis1 = VarHis	// (o-Standar,1-Historia)
VarMail2 = VarMail1 // (0-PDF,1-Mail)
If zBole2
	//-----------------
	//---Boleta 2------
	//-----------------
	cTbParBo2 = Tablas2->TbParBo2
    cTb2Habil = Substr(cTbParBo2,001,1)
	
    If Val(cTb2Habil) > 0
		cTb2Habil = .T.
    Else
		cTb2Habil = .f.
    EndIf
	If cTb2Habil  // Formato 2 Habilitado
		P_Bol2("BOLETA2", 0, VarHis1, 0, VarMail2)
		Return NIL
	EndIf	
	//---------------
	//----Bol Sob----
	//---------------
	cTbParBo2 = Tablas2->TbParBo2
    cTb2BolSo = Substr(cTbParBo2,151,1)
    If Val(cTb2BolSo) > 0
		cTb2BolSo = .T.
    Else
		cTb2BolSo = .f.
    EndIf
	If cTb2BolSo // Formato Boleta Sobre Habilitado
		P_Bol("BOL_SOB", 0, VarHis1, 0, VarMail2)
		Return NIL
	EndIf	
	//---------------
	//---------------
EndIf

VarFmt = Val(Substr(Tablas2->TbCaAdBo,224,1))
If VarFmt = 0
	P_Bol("BOLETAS", 0, VarHis1, 0, VarMail2)
Else
	P_Bol4("BOLETA4", 0, VarHis1, 0, VarMail2)	// Lagos
EndIf
Return NIL





//--------------------------
Static Function V_VaSuLa()
//--------------------------
Local SwBien
Set Exact off
SwBien = .T.
DbSelectArea("Subsi")
Set Order to 1
DbSelectArea("NDiaLab")
Set Order to 1
//-------------------
DbSelectArea("HVaca")
DbGoTop()
Do WHile !Eof()
	If HVaca->VaPerpag = xPerPag
			Clave = HVaca->VaCodEmp
			DbSelectArea("Subsi")	
			Seek Clave
			Do While !Eof() .and. Subsi->SuCodemp = Clave
				If Subsi->SuPerpag = xPerpag
					If Day(Subsi->SuFecIni) >= Day(HVaca->VaFeSaVa) .and. Day(Subsi->SuFecIni) <= Day(HVaca->VaFeReVa) .or.;
					   Day(Subsi->SuFecFin) >= Day(HVaca->VaFeSaVa) .and. Day(Subsi->SuFecFin) <= Day(HVaca->VaFeReVa) 
							Msgalert("Codigo : " + Clave + CRLF + CRLF +;
							Alltrim(Subsi->SuApelli)     + CRLF + CRLF +;
							"Subsidios   " + Transform(Subsi->SuFecIni,"@D") + " " + Transform(Subsi->SuFecFin,"@D") + CRLF + CRLF +;
							"Vacaciones  " + Transform(HVaca->VaFeSaVa,"@D") + " " + Transform(HVaca->VaFeReVa,"@D")        ,;
							"Subsidio Overlap Con Vacaciones ")
							SwBien = .F.
					EndIf
				EndIf
				DbSelectArea("Subsi")	
				DbSkip()
			EndDo
	EndIf
	DbSelectArea("HVaca")
	DbSkip()
EndDo
//------------------
DbSelectArea("HVaca")
DbGoTop()
Do WHile !Eof()
	If HVaca->VaPerpag = xPerPag
			Clave = HVaca->VaCodEmp
			DbSelectArea("NDiaLab")
			Seek Clave
			Do While !Eof() .and. NDiaLab->NlCodemp = Clave
				If NDiaLab->NlPerpag = xPerpag
					If Day(NDiaLab->NlFecIni) >= Day(HVaca->VaFeSaVa) .and. Day(NDiaLab->NlFecIni) <= Day(HVaca->VaFeReVa) .or.;
					   Day(NDiaLab->NlFecFin) >= Day(HVaca->VaFeSaVa) .and. Day(NDiaLab->NlFecFin) <= Day(HVaca->VaFeReVa) 
							Msgalert("Codigo : " + Clave + CRLF + CRLF +;
							Alltrim(NDiaLab->NlApelli)   + CRLF + CRLF +;
							"Dias N Lab  " + Transform(NDiaLab->NlFecIni,"@D") + " " + Transform(NDiaLab->NlFecFin,"@D") + CRLF + CRLF +;
							"Vacaciones  " + Transform(HVaca->VaFeSaVa,"@D")   + " " + Transform(HVaca->VaFeReVa,"@D")          ,;
							"Dias No Laborados Overlap Con Vacaciones ")
							SwBien = .F.
					EndIf
				EndIf
				DbSelectArea("NDiaLab")
				DbSkip()
			EndDo
	EndIf
	DbSelectArea("HVaca")
	DbSkip()
EndDo
//------------------
DbSelectArea("Subsi")
DbGoTop()
Do WHile !Eof()
	If Subsi->SuPerpag = xPerPag
			Clave = Subsi->SuCodEmp
			DbSelectArea("NDiaLab")
			Seek Clave
			Do While !Eof() .and. NDiaLab->NlCodemp = Clave
				If NDiaLab->NlPerpag = xPerpag
					If Day(NDiaLab->NlFecIni) >= Day(Subsi->SuFecIni) .and. Day(NDiaLab->NlFecIni) <= Day(Subsi->SuFecFin) .or.;
					   Day(NDiaLab->NlFecFin) >= Day(Subsi->SuFecIni) .and. Day(NDiaLab->NlFecFin) <= Day(SubSi->SuFecFin) 
							Msgalert("Codigo : " + Clave + CRLF + CRLF +;
							Alltrim(NDiaLab->NlApelli)   + CRLF + CRLF +;
							"Dias N.Lab  " + Transform(NDiaLab->NlFecIni,"@D") + " " + Transform(NDiaLab->NlFecFin,"@D") + CRLF + CRLF +;
							"Subsidios   " + Transform(Subsi->SuFecini,"@D")   + " " + Transform(Subsi->SuFecfin,"@D")          ,;
							"Dias Subsidiados Overlap Con Dias no Laborados")
							SwBien = .F.
					EndIf
				EndIf
				DbSelectArea("NDiaLab")
				DbSkip()
			EndDo
	EndIf
	DbSelectArea("Subsi")
	DbSkip()
EndDo
//---------------------
If SwBien
	Msgalert("No existen Cruces de Fechas","")
Else
	Msgalert("Si existen Cruces de Fechas","Revisar Fechas")
EndIf
//---------------------
Return





//---------------------
Static Function T_INIT()
//---------------------
PidCla()
If xSalir
   Return
EndIf
If cClave <> "PLANVIS"
	Msgalert("Proceso Abortado","")
	xSalir = .T.
	Return
endif
//-------------
I_Plam()
//-------------
Close("Dir")
Use &Rutas\PLAM_DIR index &RutaS\Plam_Dir alias DIR   new via "dbfcdx"  Excl
DbSelectArea("DIR")
ZAP
Close("Dir")

Close("IDE")
Use &Rutas\PLAM_IDE index &RutaS\Plam_IDE alias IDE   new via "dbfcdx"  Excl
DbSelectArea("IDE")
ZAP
Close("IDE")

Close("TRA")
Use &Rutas\PLAM_TRA index &RutaS\Plam_TRA alias TRA   new via "dbfcdx"  Excl
DbSelectArea("TRA")
ZAP
Close("TRA")

Close("SSA")
Use &Rutas\PLAM_SSA index &RutaS\Plam_SSA alias SSA   new via "dbfcdx"  Excl
DbSelectArea("SSA")
ZAP
Close("SSA")

Close("PEN")
Use &Rutas\PLAM_PEN alias PEN   new via "dbfcdx"  Excl
DbSelectArea("PEN")
ZAP
Close("PEN")

Close("PFL")
Use &Rutas\PLAM_PFL alias PFL   new via "dbfcdx"  Excl
DbSelectArea("PFL")
ZAP
Close("PFL")

Close("TER")
Use &Rutas\PLAM_TER alias TER   new via "dbfcdx"  Excl
DbSelectArea("TER")
ZAP
Close("TER")

Close("ADH")
Use &Rutas\PLAM_ADH alias ADH   new via "dbfcdx"  Excl
DbSelectArea("ADH")
ZAP
Close("ADH")

Close("BDH")
Use &Rutas\PLAM_BDH alias BDH   new via "dbfcdx"  Excl
DbSelectArea("BDH")
ZAP
Close("BDH")
MSGALERT("RESET Finalizado","")
Return




//---------------------------------
Function BLogPagD(Var1)
//---------------------------------
Local cTexto1,xRuta,xRutaS,xArchi,gTexto1

Do case
	Case Var1 = 1
		cTexto1 := "Seleccionar Logo cabecera izquierda" 
		gTexto1 := "He*.JPG"
	Case Var1 = 2
		cTexto1 := "Seleccionar Logo cabecera Derecha" 	
		gTexto1 := "He*.JPG"
	Case Var1 = 3
		cTexto1 := "Seleccionar Logo de Firma" 	
		gTexto1 := "Fo*.JPG"
Endcase

xRuta  := cGetFile( gTexto1,cTexto1 )
xRuta  := Alltrim(xRuta)

xRutaS := Alltrim(cFilepath(xRuta))
xArchi := Alltrim(cFileNoPath(xRuta))

xRuta  := xRutaS + xArchi

Do case
	Case Var1 = 1
		cTbBRuLH1 = xRuta
	Case Var1 = 2
		cTbBRuLH2 = xRuta
	Case Var1 = 3
		cTbBRuLF1 = xRuta
Endcase
Return NIL





//----------------------------------------
//----------------------------------------
FUNCTION VaDefMFC( var1A )
//----------------------------------------
//----------------------------------------

Do case
    Case Var1A = 1
		cTbEmMaIz:= 042
		cTbEmMaDe:= 092
		cTbEmLiCe:= 062

		cTbTrMaIz:= 097
		cTbTrMaDe:= 127
		cTbTrLiCe:= 105

		oTbEmMaIz:Refresh()
		oTbEmMaDe:Refresh()
		oTbEmLiCe:Refresh()

		oTbTrMaIz:Refresh()
		oTbTrMaDe:Refresh()
		oTbTrLiCe:Refresh()
		
	Case Var1A = 2	
	
		cTb2FiIni:= 001
		cTb2CoIni:= 001
		
		cTb2LgFil:= 001 
		cTb2LgCol:= 002

		cTb2Ancho:= 270    
		cTb2LiADF:= 005
		cTb2AltFi:= 010
		cTb2CoDer:= 135
		cTb2AnBol:= 124
		
		cTb2Bole2:= .T. 

		oTb2FiIni:Refresh()
		oTb2CoIni:Refresh()
		
		oTb2LgFil:Refresh()
		oTb2LgCol:Refresh()

		oTb2Ancho:Refresh()
		oTb2LiADF:Refresh()
		oTb2AltFi:Refresh()
		oTb2CoDer:Refresh()
		oTb2AnBol:Refresh()
		oTb2Bole2:Refresh()
		
		
	Case Var1A = 3
		cTsEmMaIz:= 010
		cTsEmMaDe:= 060
		cTsEmLiCe:= 030

		cTsTrMaIz:= 065
		cTsTrMaDe:= 115
		cTsTrLiCe:= 080

		oTsEmMaIz:Refresh()
		oTsEmMaDe:Refresh()
		oTsEmLiCe:Refresh()

		oTsTrMaIz:Refresh()
		oTsTrMaDe:Refresh()
		oTsTrLiCe:Refresh()
		
	 Case Var1A = 4
		cTbTrMaIz:= 048
		cTbTrMaDe:= 077
		cTbTrLiCe:= 055
		
		cTbEmMaIz:= 087
		cTbEmMaDe:= 117
		cTbEmLiCe:= 095

		oTbEmMaIz:Refresh()
		oTbEmMaDe:Refresh()
		oTbEmLiCe:Refresh()

		oTbTrMaIz:Refresh()
		oTbTrMaDe:Refresh()
		oTbTrLiCe:Refresh()	
		
EndCase
Msgalert("Valores Default Actualizados","")
Return 





//------------------------------
Function BorrDir()
//------------------------------

cEmRuta01 = Space(200)
cEmRuta02 = Space(200)
cEmRuta03 = Space(200)
cEmRuta04 = Space(200)
cEmRuta05 = Space(200)
cEmRuta06 = Space(200)
cEmRuta07 = Space(200)
cEmRuta08 = Space(200)
cEmRuta09 = Space(200)
cEmRuta10 = Space(200)
cEmRuta11 = Space(200)
cEmRuta12 = Space(200)
cEmRuta13 = Space(200)
cEmRuta14 = Space(200)
cEmRuta15 = Space(200)
	
DbSelectArea("Emp2")
 If Bloquea("EMP2",3)
	repla Emp2->EmRuta01       with cEmRuta01
	repla Emp2->EmRuta02       with cEmRuta02
	repla Emp2->EmRuta03       with cEmRuta03 
	repla Emp2->EmRuta04       with cEmRuta04 
	repla Emp2->EmRuta05       with cEmRuta05 
	repla Emp2->EmRuta06       with cEmRuta06 
	repla Emp2->EmRuta07       with cEmRuta07 
	repla Emp2->EmRuta08       with cEmRuta08 
	repla Emp2->EmRuta09       with cEmRuta09 
	repla Emp2->EmRuta10       with cEmRuta10 
	repla Emp2->EmRuta11       with cEmRuta11 
	repla Emp2->EmRuta12       with cEmRuta12 
	repla Emp2->EmRuta13       with cEmRuta13 
	repla Emp2->EmRuta14       with cEmRuta14 
	repla Emp2->EmRuta15       with cEmRuta15 
	DbUnLock()
 EndIf
Return NIL



//------------------------------
Function BorrDir2()
//------------------------------

cEmRuta21 = Space(200)
cEmRuta22 = Space(200)
cEmRuta23 = Space(200)
cEmRuta24 = Space(200)
cEmRuta25 = Space(200)
cEmRuta26 = Space(200)
cEmRuta27 = Space(200)
cEmRuta28 = Space(200)
cEmRuta29 = Space(200)
cEmRuta30 = Space(200)
cEmRuta31 = Space(200)
cEmRuta32 = Space(200)
cEmRuta33 = Space(200)
cEmRuta34 = Space(200)
cEmRuta35 = Space(200)
cEmRuta36 = Space(200)
cEmRuta37 = Space(200)
cEmRuta38 = Space(200)
cEmRuta39 = Space(200)
cEmRuta40 = Space(200)
	
DbSelectArea("Emp2")
 If Bloquea("EMP2",3)
	repla Emp2->EmRuta21       with cEmRuta21
	repla Emp2->EmRuta22       with cEmRuta22
	repla Emp2->EmRuta23       with cEmRuta23 
	repla Emp2->EmRuta24       with cEmRuta24 
	repla Emp2->EmRuta25       with cEmRuta25 
	repla Emp2->EmRuta26       with cEmRuta26 
	repla Emp2->EmRuta27       with cEmRuta27 
	repla Emp2->EmRuta28       with cEmRuta28 
	repla Emp2->EmRuta29       with cEmRuta29 
	repla Emp2->EmRuta30       with cEmRuta30 
	repla Emp2->EmRuta31       with cEmRuta31 
	repla Emp2->EmRuta32       with cEmRuta32 
	repla Emp2->EmRuta33       with cEmRuta33 
	repla Emp2->EmRuta34       with cEmRuta34 
	repla Emp2->EmRuta35       with cEmRuta35 
	repla Emp2->EmRuta36       with cEmRuta36 
	repla Emp2->EmRuta37       with cEmRuta37 
	repla Emp2->EmRuta38       with cEmRuta38 
	repla Emp2->EmRuta39       with cEmRuta39 
	repla Emp2->EmRuta40       with cEmRuta40 
	DbUnLock()
 EndIf
Return NIL











DLL32 FUNCTION BWCCRegister( hInst AS LONG ) AS WORD PASCAL LIB "BWCC32.DLL"
