// lib/widgets/syllabus.dart
class SyllabusData {
  String getSyllabusLink(String branch, String semester) {
    // Define your logic to return the correct syllabus link based on branch and semester.
    // Using branch and semester to form the link.

    final branchSemesterLinks = {
      'CSE': {
        'Sem1': 'https://example.com/cse_sem1.pdf',
        'Sem2': 'https://example.com/cse_sem2.pdf',
        'Sem3': 'https://example.com/cse_sem3.pdf',
        'Sem4': 'https://example.com/cse_sem4.pdf',
        'Sem5': 'https://example.com/cse_sem5.pdf',
        'Sem6': 'https://example.com/cse_sem6.pdf',
        'Sem7': 'https://example.com/cse_sem7.pdf',
        'Sem8': 'https://example.com/cse_sem8.pdf',
      },
      'MECH': {
        'Sem1': 'https://example.com/mech_sem1.pdf',
        'Sem2': 'https://example.com/mech_sem2.pdf',
        'Sem3': 'https://example.com/mech_sem3.pdf',
        'Sem4': 'https://example.com/mech_sem4.pdf',
        'Sem5': 'https://example.com/mech_sem5.pdf',
        'Sem6': 'https://example.com/mech_sem6.pdf',
        'Sem7': 'https://example.com/mech_sem7.pdf',
        'Sem8': 'https://example.com/mech_sem8.pdf',
      },
      'EEE': {
        'Sem1': 'https://example.com/eee_sem1.pdf',
        'Sem2': 'https://example.com/eee_sem2.pdf',
        'Sem3': 'https://drive.google.com/uc?export=download&id=1d8eGis1Pg92-Hcrey5G1ftEBHnbpa23_',
        'Sem4': 'https://example.com/eee_sem4.pdf',
        'Sem5': 'https://example.com/eee_sem5.pdf',
        'Sem6': 'https://example.com/eee_sem6.pdf',
        'Sem7': 'https://example.com/eee_sem7.pdf',
        'Sem8': 'https://example.com/eee_sem8.pdf',
      },
      'CIVIL': {
        'Sem1': 'https://example.com/civil_sem1.pdf',
        'Sem2': 'https://example.com/civil_sem2.pdf',
        'Sem3': 'https://example.com/civil_sem3.pdf',
        'Sem4': 'https://example.com/civil_sem4.pdf',
        'Sem5': 'https://example.com/civil_sem5.pdf',
        'Sem6': 'https://example.com/civil_sem6.pdf',
        'Sem7': 'https://example.com/civil_sem7.pdf',
        'Sem8': 'https://example.com/civil_sem8.pdf',
      },
      'CHEMICAL': {
        'Sem1': 'https://example.com/chemical_sem1.pdf',
        'Sem2': 'https://example.com/chemical_sem2.pdf',
        'Sem3': 'https://example.com/chemical_sem3.pdf',
        'Sem4': 'https://example.com/chemical_sem4.pdf',
        'Sem5': 'https://example.com/chemical_sem5.pdf',
        'Sem6': 'https://example.com/chemical_sem6.pdf',
        'Sem7': 'https://example.com/chemical_sem7.pdf',
        'Sem8': 'https://example.com/chemical_sem8.pdf',
      },
      'EC': {
        'Sem1': 'https://example.com/ec_sem1.pdf',
        'Sem2': 'https://example.com/ec_sem2.pdf',
        'Sem3': 'https://example.com/ec_sem3.pdf',
        'Sem4': 'https://example.com/ec_sem4.pdf',
        'Sem5': 'https://example.com/ec_sem5.pdf',
        'Sem6': 'https://example.com/ec_sem6.pdf',
        'Sem7': 'https://example.com/ec_sem7.pdf',
        'Sem8': 'https://example.com/ec_sem8.pdf',
      },
      'ER': {
        'Sem1': 'https://example.com/er_sem1.pdf',
        'Sem2': 'https://example.com/er_sem2.pdf',
        'Sem3': 'https://example.com/er_sem3.pdf',
        'Sem4': 'https://example.com/er_sem4.pdf',
        'Sem5': 'https://example.com/er_sem5.pdf',
        'Sem6': 'https://example.com/er_sem6.pdf',
        'Sem7': 'https://example.com/er_sem7.pdf',
        'Sem8': 'https://example.com/er_sem8.pdf',
      },
    };

    // Return the appropriate syllabus link
    return branchSemesterLinks[branch]?[semester] ?? 'https://example.com/error.pdf';
  }
}
