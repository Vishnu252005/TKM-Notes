// lib/widgets/syllabus.dart
class SyllabusData {
  String getSyllabusLink(String branch, String semester) {
    // Define your logic to return the correct syllabus link based on branch and semester.
    // Using branch and semester to form the link.

    final branchSemesterLinks = {
      'CSE': {
        'Sem1':
            'https://drive.google.com/uc?id=1SaeZdz-0VCS5EITyLdxyoc8OL5E8D-fs&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=1P7UtSZJOngJ5I34h6jE-C_UO6zREwN46&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=1hkwpmYiadj4c4W3rorLA7E5gVBTX3ko3&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1qoa0WcfA5SVzDu3O6VX8OPHxpvxmxSJ6&export=download',
        'Sem5': 'https://vishnumeta.com/cse_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/cse_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/cse_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/cse_sem8.pdf',
      },
      'MECH': {
        'Sem1':
            'https://drive.google.com/uc?id=1Ii75sQ47_C_UeHpExhFhljtYlIiOw3lX&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=1AyBxQXg8EFsh2-u-kTVo75xXBkpV_w1v&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=1wjj5iLFDSMu5eGyPlYS9Lm2Tqdb4Z3l7&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1vA3ac5AgzW6lzvM60t7wKRqybRR8GsD7&export=download',
        'Sem5': 'https://vishnumeta.com/mech_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/mech_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/mech_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/mech_sem8.pdf',
      },
      'EEE': {
        'Sem1':
            'https://drive.google.com/uc?id=1Pm9TdNczEe_aw5v6r1XhMXaCGhkeOsuo&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=1eloHMMR25_zJY3eUZS5wyl_ZK5MLxArP&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=1MYHfO5tOb1NZq08giDDsCuDy_2aG8f4_&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1c41QEvc_zgv72DLJ7W4bbQwYWFGZx4_Q&export=download',
        'Sem5': 'https://vishnumeta.com/eee_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/eee_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/eee_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/eee_sem8.pdf',
      },
      'CIVIL': {
        'Sem1': 'https://vishnumeta.com/civil_sem1.pdf',
        'Sem2': 'https://vishnumeta.com/civil_sem2.pdf',
        'Sem3': 'https://vishnumeta.com/civil_sem3.pdf',
        'Sem4': 'https://vishnumeta.com/civil_sem4.pdf',
        'Sem5': 'https://vishnumeta.com/civil_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/civil_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/civil_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/civil_sem8.pdf',
      },
      'CHEMICAL': {
        'Sem1': 'https://vishnumeta.com/chemical_sem1.pdf',
        'Sem2': 'https://vishnumeta.com/chemical_sem2.pdf',
        'Sem3': 'https://vishnumeta.com/chemical_sem3.pdf',
        'Sem4': 'https://vishnumeta.com/chemical_sem4.pdf',
        'Sem5': 'https://vishnumeta.com/chemical_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/chemical_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/chemical_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/chemical_sem8.pdf',
      },
      'EC': {
        'Sem1': 'https://vishnumeta.com/ec_sem1.pdf',
        'Sem2': 'https://vishnumeta.com/ec_sem2.pdf',
        'Sem3': 'https://vishnumeta.com/ec_sem3.pdf',
        'Sem4': 'https://vishnumeta.com/ec_sem4.pdf',
        'Sem5': 'https://vishnumeta.com/ec_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/ec_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/ec_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/ec_sem8.pdf',
      },
      'ER': {
        'Sem1': 'https://vishnumeta.com/er_sem1.pdf',
        'Sem2': 'https://vishnumeta.com/er_sem2.pdf',
        'Sem3': 'https://vishnumeta.com/er_sem3.pdf',
        'Sem4': 'https://vishnumeta.com/er_sem4.pdf',
        'Sem5': 'https://vishnumeta.com/er_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/er_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/er_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/er_sem8.pdf',
      },
    };

    // Return the appropriate syllabus link
    return branchSemesterLinks[branch]?[semester] ??
        'https://vishnumeta.com/error.pdf';
  }
}
