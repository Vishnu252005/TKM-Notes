import 'package:flutter/material.dart';
import 'CHEMICAL/sem1/chemical_sem1_screen.dart';
import 'CHEMICAL/sem2/chemical_sem2_screen.dart';
import 'CHEMICAL/sem3/chemical_sem3_screen.dart';
import 'CHEMICAL/sem4/chemical_sem4_screen.dart';
import 'CHEMICAL/sem5/chemical_sem5_screen.dart';
import 'CHEMICAL/sem6/chemical_sem6_screen.dart';
import 'CHEMICAL/sem7/chemical_sem7_screen.dart';
import 'CHEMICAL/sem8/chemical_sem8_screen.dart';

import 'CIVIL/sem1/civil_sem1_screen.dart';
import 'CIVIL/sem2/civil_sem2_screen.dart';
import 'CIVIL/sem3/civil_sem3_screen.dart';// bb
import 'CIVIL/sem4/civil_sem4_screen.dart';
import 'CIVIL/sem5/civil_sem5_screen.dart';
import 'CIVIL/sem6/civil_sem6_screen.dart';
import 'CIVIL/sem7/civil_sem7_screen.dart';
import 'CIVIL/sem8/civil_sem8_screen.dart';

import 'CSE/sem1/cse_sem1_screen.dart';
import 'CSE/sem2/cse_sem2_screen.dart';
import 'CSE/sem3/cse_sem3_screen.dart';
import 'CSE/sem4/cse_sem4_screen.dart';
import 'CSE/sem5/cse_sem5_screen.dart';
import 'CSE/sem6/cse_sem6_screen.dart';
import 'CSE/sem7/cse_sem7_screen.dart';
import 'CSE/sem8/cse_sem8_screen.dart';

import 'EC/sem1/ec_sem1_screen.dart';
import 'EC/sem2/ec_sem2_screen.dart';
import 'EC/sem3/ec_sem3_screen.dart';
import 'EC/sem4/ec_sem4_screen.dart';
import 'EC/sem5/ec_sem5_screen.dart';
import 'EC/sem6/ec_sem6_screen.dart';
import 'EC/sem7/ec_sem7_screen.dart';
import 'EC/sem8/ec_sem8_screen.dart';

import 'EEE/sem1/eee_sem1_screen.dart';
import 'EEE/sem2/eee_sem2_screen.dart';
import 'EEE/sem3/eee_sem3_screen.dart';
import 'EEE/sem4/eee_sem4_screen.dart';
import 'EEE/sem5/eee_sem5_screen.dart';
import 'EEE/sem6/eee_sem6_screen.dart';
import 'EEE/sem7/eee_sem7_screen.dart';
import 'EEE/sem8/eee_sem8_screen.dart';

import 'ER/sem1/er_sem1_screen.dart';
import 'ER/sem2/er_sem2_screen.dart';
import 'ER/sem3/er_sem3_screen.dart';
import 'ER/sem4/er_sem4_screen.dart';
import 'ER/sem5/er_sem5_screen.dart';
import 'ER/sem6/er_sem6_screen.dart';
import 'ER/sem7/er_sem7_screen.dart';
import 'ER/sem8/er_sem8_screen.dart';

import 'MECH/sem1/mech_sem1_screen.dart';
import 'MECH/sem2/mech_sem2_screen.dart';
import 'MECH/sem3/mech_sem3_screen.dart';
import 'MECH/sem4/mech_sem4_screen.dart';
import 'MECH/sem5/mech_sem5_screen.dart';
import 'MECH/sem6/mech_sem6_screen.dart';
import 'MECH/sem7/mech_sem7_screen.dart';
import 'MECH/sem8/mech_sem8_screen.dart';

import 'widgets/signup.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 3, 13, 148)),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, String>?;

        if (args != null) {
          switch (settings.name) {
            case 'EEESem1':
              return MaterialPageRoute(
                builder: (context) => EEESem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem2':
              return MaterialPageRoute(
                builder: (context) => EEESem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem3':
              return MaterialPageRoute(
                builder: (context) => EEESem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem4':
              return MaterialPageRoute(
                builder: (context) => EEESem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem5':
              return MaterialPageRoute(
                builder: (context) => EEESem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem6':
              return MaterialPageRoute(
                builder: (context) => EEESem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem7': 
              return MaterialPageRoute(
                builder: (context) => EEESem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'EEESem8':
              return MaterialPageRoute(
                builder: (context) => EEESem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            // Add similar cases for other branches and semesters

            // CSE
            
            case 'CSESem1':
              return MaterialPageRoute(
                builder: (context) => CSESem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem2':
              return MaterialPageRoute(
                builder: (context) => CSESem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem3':
              return MaterialPageRoute(
                builder: (context) => CSESem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem4':
              return MaterialPageRoute(
                builder: (context) => CSESem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem5':
              return MaterialPageRoute(
                builder: (context) => CSESem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem6':
              return MaterialPageRoute(
                builder: (context) => CSESem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem7':
              return MaterialPageRoute(
                builder: (context) => CSESem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CSESem8':
              return MaterialPageRoute(
                builder: (context) => CSESem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            // // MECH
            case 'MECHSem1':
              return MaterialPageRoute(
                builder: (context) => MECHSem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'MECHSem2':
              return MaterialPageRoute(
                builder: (context) => MECHSem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'MECHSem3':
              return MaterialPageRoute(
                builder: (context) => MECHSem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'MECHSem4':
              return MaterialPageRoute(
                builder: (context) => MECHSem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'MECHSem5':
              return MaterialPageRoute(
                builder: (context) => MECHSem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'MECHSem6':
              return MaterialPageRoute(
                builder: (context) => MECHSem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'MECHSem7':
              return MaterialPageRoute(
                builder: (context) => MECHSem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'MECHSem8':
              return MaterialPageRoute(
                builder: (context) => MECHSem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            // // CIVIL
            case 'CIVILSem1':
              return MaterialPageRoute(
                builder: (context) => CIVILSem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem2':
              return MaterialPageRoute(
                builder: (context) => CIVILSem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem3':
              return MaterialPageRoute(
                builder: (context) => CIVILSem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem4':
              return MaterialPageRoute(
                builder: (context) => CIVILSem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem5':
              return MaterialPageRoute(
                builder: (context) => CIVILSem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem6':
              return MaterialPageRoute(
                builder: (context) => CIVILSem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CIVILSem7':
              return MaterialPageRoute(
                builder: (context) => CIVILSem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'CIVILSem8':
              return MaterialPageRoute(
                builder: (context) => CIVILSem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            // EC
            case 'ECSem1':
              return MaterialPageRoute(
                builder: (context) => ECSem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ECSem2':
              return MaterialPageRoute(
                builder: (context) => ECSem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ECSem3':
              return MaterialPageRoute(
                builder: (context) => ECSem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ECSem4':
              return MaterialPageRoute(
                builder: (context) => ECSem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'ECSem5':
              return MaterialPageRoute(
                builder: (context) => ECSem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'ECSem6':
              return MaterialPageRoute(
                builder: (context) => ECSem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ECSem7':
              return MaterialPageRoute(
                builder: (context) => ECSem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'ECSem8':  
              return MaterialPageRoute(
                builder: (context) => ECSem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            // ER
            case 'ERSem1':
              return MaterialPageRoute(
                builder: (context) => ERSem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem2':
              return MaterialPageRoute(
                builder: (context) => ERSem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem3':
              return MaterialPageRoute(
                builder: (context) => ERSem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem4':
              return MaterialPageRoute(
                builder: (context) => ERSem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem5':
              return MaterialPageRoute(
                builder: (context) => ERSem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem6':
              return MaterialPageRoute(
                builder: (context) => ERSem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'ERSem7':
              return MaterialPageRoute(
                builder: (context) => ERSem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'ERSem8':
              return MaterialPageRoute(
                builder: (context) => ERSem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            // // CHEMICAL
            case 'CHEMICALSem1':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem1Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CHEMICALSem2':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem2Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CHEMICALSem3':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem3Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CHEMICALSem4':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem4Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CHEMICALSem5':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem5Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            case 'CHEMICALSem6':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem6Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'CHEMICALSem7':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem7Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );

            case 'CHEMICALSem8':
              return MaterialPageRoute(
                builder: (context) => CHEMICALSem8Screen(
                  fullName: args['fullName']!,
                  branch: args['branch']!,
                  year: args['year']!,
                  semester: args['semester']!,
                ),
              );
            default:
              return null;
          }
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => UndefinedRouteScreen(name: settings.name),
      ),
    );
  }
}

class UndefinedRouteScreen extends StatelessWidget {
  final String? name;

  const UndefinedRouteScreen({this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Undefined Route')),
      body: Center(
        child: Text('No route defined for ${name ?? 'unknown route'}'),
      ),
    );
  }
}
