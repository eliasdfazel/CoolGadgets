import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/dashboard/ui/Dashboard.dart';
import 'package:cool_gadgets/firebase_options.dart';
import 'package:cool_gadgets/resources/private/Privates.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(Privates.reCaptchEnterpriseSiteKey)
  );

  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  final firestoreDatabase = FirebaseFirestore.instance;
  firestoreDatabase.settings = const Settings(persistenceEnabled: true);

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 19));

  setupContent();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringsResources.taglineCoolGadgets,
      color: ColorsResources.black,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorsResources.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
      ),
      home: Dashboard(firebaseFirestore: firestoreDatabase),
      routes: <String, WidgetBuilder> {
        '/Home': (BuildContext context) => Dashboard(firebaseFirestore: firestoreDatabase)
        // '/Product': (BuildContext context) => const Product(productId: '')
      },
      onGenerateRoute: (routeSettings) {

        Uri uri = Uri.parse(routeSettings.name ?? "");

        Map<String, dynamic> parameters = {};

        uri.queryParameters.forEach((key, value) {

          parameters[key] = value;

        });

        if (parameters["productId"] != null) { // Open A Product
          debugPrint("Product Id: ${parameters["productId"].toString().toUpperCase()}");

          //https://geeks-empire-website.web.app/#/Product?productId=[]
          // return MaterialPageRoute(
          //     builder: (_) => Product(productId: int.parse(parameters["productId"]))
          // );

        }

      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {

              return Dashboard(firebaseFirestore: firestoreDatabase);
            }
        );
      }
  ));

}

void setupContent() async {

  StringsResources.coolGadgetsForFitness;
  StringsResources.coolGadgetsForGamers;
  StringsResources.coolGadgetsForMen;
  StringsResources.coolGadgetsForWomen;
  StringsResources.coolGadgetsForOffice;
  StringsResources.coolGadgetsForHome;
  StringsResources.coolGadgetsForFun;
  StringsResources.coolGadgetsForComputer;
  StringsResources.coolGadgetsForCamping;

  StringsResources.joinCommunity;

  StringsResources.brandLUMSBURRY;
  StringsResources.brandLYKTRIX;
  StringsResources.brandMAGMO;
  StringsResources.brandMAGTAME;
  StringsResources.brandMARVEL;
  StringsResources.brandMATTERPORT;
  StringsResources.brandMECHKEEB;
  StringsResources.brandMIFASO;
  StringsResources.brandMOES;
  StringsResources.brandMOODPIE;
  StringsResources.brandMRPEN;
  StringsResources.brandMSMV;
  StringsResources.brandNEKTECK;
  StringsResources.brandNEXIGO;
  StringsResources.brandNINJA;
  StringsResources.brandNOBEL;
  StringsResources.brandNordVPN;
  StringsResources.brandNORMIARITA;
  StringsResources.brandNOVIUM;
  StringsResources.brandNSL;
  StringsResources.brandODISTAR;
  StringsResources.brandOILKAS;
  StringsResources.brandONLYTOP;
  StringsResources.brandOTDMEL;
  StringsResources.brandOURA;
  StringsResources.brandPALADONE;
  StringsResources.brandPANTASY;
  StringsResources.brandPHILIPS;
  StringsResources.brandPROCONTROLLERS;
  StringsResources.brandQBALL;
  StringsResources.brandQIANWI;
  StringsResources.brandR2D2;
  StringsResources.brandRAZER;
  StringsResources.brandREDCOMETS;
  StringsResources.brandREIDEA;
  StringsResources.brandRELABTABY;
  StringsResources.brandREMARKABLE;
  StringsResources.brandRENPHO;
  StringsResources.brandRFUNGUANGO;
  StringsResources.brandRUCONLA;
  StringsResources.brandRUIXINDA;
  StringsResources.brandSAMISOLER;
  StringsResources.brandSANWA;
  StringsResources.brandSAROZZTAL;
  StringsResources.brandSHANDERBAR;
  StringsResources.brandSHARPER;
  StringsResources.brandSHASHIBO;
  StringsResources.brandSHIFTSCAM;
  StringsResources.brandSHOPSQUARE;
  StringsResources.brandSILVER;
  StringsResources.brandSILVERBUFFALO;
  StringsResources.brandSITHON;
  StringsResources.brandSKULLCANDY;
  StringsResources.brandSMALLFISH;
  StringsResources.brandSMARTLB;
  StringsResources.brandSOOOEC;
  StringsResources.brandSOVENOMUND;
  StringsResources.brandSPEKS;
  StringsResources.brandSTITCHGREEN;
  StringsResources.brandSUBSONIC;
  StringsResources.brandTAJA;
  StringsResources.brandTILE;
  StringsResources.brandTJPD;
  StringsResources.brandTOSY;
  StringsResources.brandTWINKLY;
  StringsResources.brandTYPECASE;
  StringsResources.brandUIOSMUPH;
  StringsResources.brandUNCANNY;
  StringsResources.brandVENOMINBOX;
  StringsResources.brandVERONESE;
  StringsResources.brandVISOFO;
  StringsResources.brandVLANDO;
  StringsResources.brandWACACO;
  StringsResources.brandWELSPO;
  StringsResources.brandWSKEN;
  StringsResources.brandXBOTGO;
  StringsResources.brandXIANGZHU;
  StringsResources.brandXINFRARED;
  StringsResources.brandXKEYS;
  StringsResources.brandXPPEN;
  StringsResources.brandXYNGU;
  StringsResources.brandYOLIPULI;
  StringsResources.brandYOURFPCUS;
  StringsResources.brandZEVO;
  StringsResources.brandZHOUCXZDA;
  StringsResources.brandZULAY;
  StringsResources.brandLUMSBURRY;
  StringsResources.brandLYKTRIX;
  StringsResources.brandMAGMO;
  StringsResources.brandMAGTAME;
  StringsResources.brandMARVEL;
  StringsResources.brandMATTERPORT;
  StringsResources.brandMECHKEEB;
  StringsResources.brandMIFASO;
  StringsResources.brandMOES;
  StringsResources.brandMOODPIE;
  StringsResources.brandMRPEN;
  StringsResources.brandMSMV;
  StringsResources.brandNEKTECK;
  StringsResources.brandNEXIGO;
  StringsResources.brandNINJA;
  StringsResources.brandNOBEL;
  StringsResources.brandNordVPN;
  StringsResources.brandNORMIARITA;
  StringsResources.brandNOVIUM;
  StringsResources.brandNSL;
  StringsResources.brandODISTAR;
  StringsResources.brandOILKAS;
  StringsResources.brandONLYTOP;
  StringsResources.brandOTDMEL;
  StringsResources.brandOURA;
  StringsResources.brandPALADONE;
  StringsResources.brandPANTASY;
  StringsResources.brandPHILIPS;
  StringsResources.brandPROCONTROLLERS;
  StringsResources.brandQBALL;
  StringsResources.brandQIANWI;
  StringsResources.brandR2D2;
  StringsResources.brandRAZER;
  StringsResources.brandREDCOMETS;
  StringsResources.brandREIDEA;
  StringsResources.brandRELABTABY;
  StringsResources.brandREMARKABLE;
  StringsResources.brandRENPHO;
  StringsResources.brandRFUNGUANGO;
  StringsResources.brandRUCONLA;
  StringsResources.brandRUIXINDA;
  StringsResources.brandSAMISOLER;
  StringsResources.brandSANWA;
  StringsResources.brandSAROZZTAL;
  StringsResources.brandSHANDERBAR;
  StringsResources.brandSHARPER;
  StringsResources.brandSHASHIBO;
  StringsResources.brandSHIFTSCAM;
  StringsResources.brandSHOPSQUARE;
  StringsResources.brandSILVER;
  StringsResources.brandSILVERBUFFALO;
  StringsResources.brandSITHON;
  StringsResources.brandSKULLCANDY;
  StringsResources.brandSMALLFISH;
  StringsResources.brandSMARTLB;
  StringsResources.brandSOOOEC;
  StringsResources.brandSOVENOMUND;
  StringsResources.brandSPEKS;
  StringsResources.brandSTITCHGREEN;
  StringsResources.brandSUBSONIC;
  StringsResources.brandTAJA;
  StringsResources.brandTILE;
  StringsResources.brandTJPD;
  StringsResources.brandTOSY;
  StringsResources.brandTWINKLY;
  StringsResources.brandTYPECASE;
  StringsResources.brandUIOSMUPH;
  StringsResources.brandUNCANNY;
  StringsResources.brandVENOMINBOX;
  StringsResources.brandVERONESE;
  StringsResources.brandVISOFO;
  StringsResources.brandVLANDO;
  StringsResources.brandWACACO;
  StringsResources.brandWELSPO;
  StringsResources.brandWSKEN;
  StringsResources.brandXBOTGO;
  StringsResources.brandXIANGZHU;
  StringsResources.brandXINFRARED;
  StringsResources.brandXKEYS;
  StringsResources.brandXPPEN;
  StringsResources.brandXYNGU;
  StringsResources.brandYOLIPULI;
  StringsResources.brandYOURFPCUS;
  StringsResources.brandZEVO;
  StringsResources.brandZHOUCXZDA;
  StringsResources.brandZULAY;
  StringsResources.brand7AM2M;
  StringsResources.brandADATA;
  StringsResources.brandAHOPEGARDEN;
  StringsResources.brandAIPER;
  StringsResources.brandAKMTRD;
  StringsResources.brandAMAZFIT;
  StringsResources.brandAMBIENTWEATHER;
  StringsResources.brandANERIMST;
  StringsResources.brandANKER;
  StringsResources.brandAPPLE;
  StringsResources.brandASUSROG;
  StringsResources.brandAULA;
  StringsResources.brandAZERON;
  StringsResources.brandAZLTC;
  StringsResources.brandBEATS;
  StringsResources.brandBITZEE;
  StringsResources.brandBLACKDECKER;
  StringsResources.brandBLAVOR;
  StringsResources.brandBLINK;
  StringsResources.brandBSZHI;
  StringsResources.brandBUYEXIG;
  StringsResources.brandCARSTUUS;
  StringsResources.brandCASIO;
  StringsResources.brandCHARMSET;
  StringsResources.brandCHICKADEE;
  StringsResources.brandCHIUEAST;
  StringsResources.brandCHOSMOYI;
  StringsResources.brandCINTWOR;
  StringsResources.brandCLOARKS;
  StringsResources.brandCLOCTECK;
  StringsResources.brandCMORIGINALS;
  StringsResources.brandCOFFEEMUGWARMER;
  StringsResources.brandCOMFILIFE;
  StringsResources.brandCORSAIR;
  StringsResources.brandCOTODAMA;
  StringsResources.brandDINSFINS;
  StringsResources.brandDIVOOM;
  StringsResources.brandDOWNIX;
  StringsResources.brandEGKIMBA;
  StringsResources.brandEMIRCEY;
  StringsResources.brandENERGIZER;
  StringsResources.brandENGERWALL;
  StringsResources.brandETEKCITY;
  StringsResources.brandEUTOUR;
  StringsResources.brandEVERSHOP;
  StringsResources.brandEVILEYE;
  StringsResources.brandEVOKOR;
  StringsResources.brandEXTREMEMIST;
  StringsResources.brandFEICHONGHO;
  StringsResources.brandFENPOS;
  StringsResources.brandFITBIT;
  StringsResources.brandFLOWTIME;
  StringsResources.brandFORLIM;
  StringsResources.brandFULIYING;
  StringsResources.brandFUNTOUCH;
  StringsResources.brandGARMIN;
  StringsResources.brandGEEKSEMPIRE;
  StringsResources.brandGEMSWILL;
  StringsResources.brandGENERIC;
  StringsResources.brandGENSROCK;
  StringsResources.brandGIFR;
  StringsResources.brandGODOX;
  StringsResources.brandGOGOONIKE;
  StringsResources.brandGOOGLE;
  StringsResources.brandGOVEE;
  StringsResources.brandGRAVASTAR;
  StringsResources.brandGREATEVER;
  StringsResources.brandGTPLAYER;
  StringsResources.brandHAGIBIS;
  StringsResources.brandHALLOCOOL;
  StringsResources.brandHANDFAN;
  StringsResources.brandHASIPU;
  StringsResources.brandHERORI;
  StringsResources.brandHOBOT;
  StringsResources.brandHSANHE;
  StringsResources.brandHUYUN;
  StringsResources.brandHYPERX;
  StringsResources.brandIDORTYBB;
  StringsResources.brandIFYOO;
  StringsResources.brandIKAGO;
  StringsResources.brandINTERYI;
  StringsResources.brandIRONFLASK;
  StringsResources.brandITEFDTUTNE;
  StringsResources.brandJMBRICKLAYER;
  StringsResources.brandKANDAO;
  StringsResources.brandKINDLE;
  StringsResources.brandKINGSPEC;
  StringsResources.brandKITVONA;
  StringsResources.brandKKPOT;
  StringsResources.brandKODAK;
  StringsResources.brandKWAK;
  StringsResources.brandLAGINE;
  StringsResources.brandLARETROTIENDA;
  StringsResources.brandLEGO;
  StringsResources.brandLEPOTEC;
  StringsResources.brandLEXIN;
  StringsResources.brandLIGHTIMETUNNEL;
  StringsResources.brandLINWIN;
  StringsResources.brandLOGITECHG;
  StringsResources.brandLOOKEE;

  StringsResources.title17623;
  StringsResources.description17623;
  StringsResources.title17381;
  StringsResources.description17381;
  StringsResources.title17368;
  StringsResources.description17368;
  StringsResources.title17360;
  StringsResources.description17360;
  StringsResources.title17331;
  StringsResources.description17331;
  StringsResources.title17271;
  StringsResources.description17271;
  StringsResources.title17256;
  StringsResources.description17256;
  StringsResources.title16879;
  StringsResources.description16879;
  StringsResources.title16842;
  StringsResources.description16842;
  StringsResources.title16533;
  StringsResources.description16533;
  StringsResources.title15415;
  StringsResources.description15415;
  StringsResources.title13353;
  StringsResources.description13353;
  StringsResources.title17389;
  StringsResources.description17389;
  StringsResources.title17247;
  StringsResources.description17247;
  StringsResources.title17271;
  StringsResources.description17271;
  StringsResources.title17256;
  StringsResources.description17256;
  StringsResources.title16879;
  StringsResources.description16879;
  StringsResources.title16842;
  StringsResources.description16842;
  StringsResources.title16276;
  StringsResources.description16276;
  StringsResources.title16262;
  StringsResources.description16262;
  StringsResources.title16256;
  StringsResources.description16256;
  StringsResources.title16228;
  StringsResources.description16228;
  StringsResources.title16222;
  StringsResources.description16222;
  StringsResources.title16217;
  StringsResources.description16217;
  StringsResources.title16180;
  StringsResources.description16180;
  StringsResources.title14784;
  StringsResources.description14784;
  StringsResources.title13436;
  StringsResources.description13436;
  StringsResources.title12539;
  StringsResources.description12539;
  StringsResources.title16514;
  StringsResources.description16514;
  StringsResources.title16470;
  StringsResources.description16470;
  StringsResources.title15415;
  StringsResources.description15415;
  StringsResources.title12667;
  StringsResources.description12667;
  StringsResources.title12315;
  StringsResources.description12315;
  StringsResources.title17619;
  StringsResources.description17619;
  StringsResources.title17613;
  StringsResources.description17613;
  StringsResources.title17419;
  StringsResources.description17419;
  StringsResources.title17389;
  StringsResources.description17389;
  StringsResources.title17375;
  StringsResources.description17375;
  StringsResources.title17336;
  StringsResources.description17336;
  StringsResources.title17263;
  StringsResources.description17263;
  StringsResources.title16592;
  StringsResources.description16592;
  StringsResources.title16586;
  StringsResources.description16586;
  StringsResources.title16541;
  StringsResources.description16541;
  StringsResources.title14398;
  StringsResources.description14398;
  StringsResources.title14394;
  StringsResources.description14394;
  StringsResources.title14390;
  StringsResources.description14390;
  StringsResources.title14034;
  StringsResources.description14034;
  StringsResources.title13970;
  StringsResources.description13970;
  StringsResources.title13851;
  StringsResources.description13851;
  StringsResources.title13764;
  StringsResources.description13764;
  StringsResources.title13686;
  StringsResources.description13686;
  StringsResources.title13656;
  StringsResources.description13656;
  StringsResources.title13485;
  StringsResources.description13485;
  StringsResources.title13424;
  StringsResources.description13424;
  StringsResources.title13382;
  StringsResources.description13382;
  StringsResources.title13375;
  StringsResources.description13375;
  StringsResources.title13077;
  StringsResources.description13077;
  StringsResources.title12913;
  StringsResources.description12913;
  StringsResources.title12811;
  StringsResources.description12811;
  StringsResources.title12797;
  StringsResources.description12797;
  StringsResources.title12753;
  StringsResources.description12753;
  StringsResources.title12667;
  StringsResources.description12667;
  StringsResources.title12483;
  StringsResources.description12483;
  StringsResources.title12437;
  StringsResources.description12437;
  StringsResources.title17360;
  StringsResources.description17360;
  StringsResources.title17277;
  StringsResources.description17277;
  StringsResources.title16861;
  StringsResources.description16861;
  StringsResources.title16823;
  StringsResources.description16823;
  StringsResources.title15866;
  StringsResources.description15866;
  StringsResources.title15776;
  StringsResources.description15776;
  StringsResources.title15719;
  StringsResources.description15719;
  StringsResources.title15589;
  StringsResources.description15589;
  StringsResources.title15344;
  StringsResources.description15344;
  StringsResources.title14369;
  StringsResources.description14369;
  StringsResources.title14326;
  StringsResources.description14326;
  StringsResources.title14024;
  StringsResources.description14024;
  StringsResources.title14015;
  StringsResources.description14015;
  StringsResources.title13676;
  StringsResources.description13676;
  StringsResources.title13661;
  StringsResources.description13661;
  StringsResources.title13318;
  StringsResources.description13318;
  StringsResources.title12876;
  StringsResources.description12876;
  StringsResources.title12430;
  StringsResources.description12430;
  StringsResources.title17413;
  StringsResources.description17413;
  StringsResources.title16284;
  StringsResources.description16284;
  StringsResources.title16262;
  StringsResources.description16262;
  StringsResources.title15873;
  StringsResources.description15873;
  StringsResources.title15866;
  StringsResources.description15866;
  StringsResources.title15862;
  StringsResources.description15862;
  StringsResources.title15851;
  StringsResources.description15851;
  StringsResources.title15735;
  StringsResources.description15735;
  StringsResources.title15496;
  StringsResources.description15496;
  StringsResources.title15485;
  StringsResources.description15485;
  StringsResources.title13661;
  StringsResources.description13661;
  StringsResources.title17635;
  StringsResources.description17635;
  StringsResources.title17629;
  StringsResources.description17629;
  StringsResources.title15873;
  StringsResources.description15873;
  StringsResources.title15776;
  StringsResources.description15776;
  StringsResources.title15288;
  StringsResources.description15288;
  StringsResources.title12907;
  StringsResources.description12907;
  StringsResources.title16574;
  StringsResources.description16574;
  StringsResources.title16563;
  StringsResources.description16563;
  StringsResources.title16559;
  StringsResources.description16559;
  StringsResources.title16533;
  StringsResources.description16533;
  StringsResources.title13436;
  StringsResources.description13436;
  StringsResources.title12539;
  StringsResources.description12539;

  StringsResources.titleAmazonPrime;
  StringsResources.descriptionAmazonPrime;

  StringsResources.titleLightWeightHeadset;
  StringsResources.descriptionLightWeightHeadset;

  StringsResources.titleVPN;
  StringsResources.descriptionVPN;

}