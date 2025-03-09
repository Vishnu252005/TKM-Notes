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
        'Sem1':
            'https://drive.google.com/uc?id=1_XNZaPuxlol9czjI4jb-PVy3qsBCTZ2-&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=112NzP1FT0R3sP_8cghFY_m1xdf80r4-B&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=1JnqlCNeVdI58X3QYeQU49s-WufcdfLHQ&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1-bEjR2yn1FoNuO_SJ6Bt5GpJoCKXkFXL&export=download',
        'Sem5': 'https://vishnumeta.com/civil_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/civil_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/civil_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/civil_sem8.pdf',
      },
      'CHEMICAL': {
        'Sem1':
            'https://drive.google.com/uc?id=1Xs7CFOs9upI-FsX6LyiJT04by9EPEy1E&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=19aml3MjiF3daMVGeHJT4zOKSlbVVpWDA&export=download',
        'Sem3': '',
        'Sem4': '',
        'Sem5': 'https://vishnumeta.com/chemical_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/chemical_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/chemical_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/chemical_sem8.pdf',
      },
      'EC': {
        'Sem1':
            'https://drive.google.com/uc?id=1FsmbwVAVAcCVj2DPykf60Jrh22ZXwtBr&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=1aq_WG4QQlBcYqweXWe_wfzK1VlyCgRrD&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=1XMpHH2luVqZ2Feq_8bUHmA7ojodPjLDp&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1X0zmiV8ZR2AYhPNqJEvNS3_pjP5H5iFq&export=download',
        'Sem5': 'https://vishnumeta.com/ec_sem5.pdf',
        'Sem6': 'https://vishnumeta.com/ec_sem6.pdf',
        'Sem7': 'https://vishnumeta.com/ec_sem7.pdf',
        'Sem8': 'https://vishnumeta.com/ec_sem8.pdf',
      },
      'ER': {
        'Sem1':
            'https://drive.google.com/uc?id=1MNDjaghtZPbLQwipH30JNkUAR0-t8Mzo&export=download',
        'Sem2':
            'https://drive.google.com/uc?id=1Z0Pk-q5yTQuKVQZw54lzEP60W0tr8zPh&export=download',
        'Sem3':
            'https://drive.google.com/uc?id=100mBmwetdAtT9tnORGhIw4qYGvVcTEFC&export=download',
        'Sem4':
            'https://drive.google.com/uc?id=1wdVyo77gGE4Ix-MIgHUoasG7GSeuji4V&export=download',
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
