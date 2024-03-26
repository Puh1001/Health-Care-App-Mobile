import 'package:heathtrack/providers/userProvider.dart';
import 'package:provider/provider.dart';

class DiagnosisEngine {
  // chẩn đoán vấn đề huyết áp
  static String diagnoseBloodPressureIssue(int systolic, int diastolic) {
    if (systolic == 0 && diastolic == 0) return '';
    if (systolic < 120 && diastolic < 80) {
      return "Optimal blood pressure";
    } else if (systolic >= 120 &&
        systolic < 130 &&
        diastolic >= 80 &&
        diastolic < 85) {
      return "Normal blood pressure";
    } else if (systolic >= 130 &&
        systolic < 140 &&
        diastolic >= 85 &&
        diastolic < 90) {
      return "Prehypertension";
    } else if (systolic >= 140 &&
        systolic < 150 &&
        diastolic >= 90 &&
        diastolic < 100) {
      return "Hypertension stage 1";
    } else if (systolic >= 150 &&
        systolic < 160 &&
        diastolic >= 100 &&
        diastolic < 110) {
      return "Hypertension stage 2";
    } else if (systolic >= 160 &&
        systolic < 180 &&
        diastolic >= 110 &&
        diastolic < 120) {
      return "Hypertension stage 3";
    } else if (systolic >= 180 && diastolic >= 120) {
      return "Hypertension stage 3";
    } else if (systolic >= 140 && diastolic < 90) {
      return "Isolated systolic hypertension";
    } else {
      return "Undiagnosable";
    }
  }

  // chẩn đoán vấn đề nhịp tim
  static String diagnoseHeartRateIssue(int heartRate) {
    if (heartRate == 0) return '';
    if (heartRate < 50 || heartRate > 150) {
      return 'Dangerous';
    } else if (heartRate < 60) {
      return 'Low heart rate';
    } else if (heartRate > 100) {
      return 'High heart rate';
    } else {
      return 'Normal heart rate';
    }
  }

  // chẩn đoán vấn đề nồng độ đường huyết
  static String diagnoseBloodGlucoseLevelIssue(double bloodGlucoseLevel) {
    if (bloodGlucoseLevel == 0) return '';
    if (bloodGlucoseLevel < 70) {
      return 'Low blood glucose level';
    } else if (bloodGlucoseLevel > 140) {
      return 'High blood glucose level';
    } else {
      return 'Normal blood glucose level';
    }
  }

  // chẩn đoán vấn đề nhiệt độ cơ thể
  static String diagnoseTemperatureIssue(double temperature) {
    if (temperature == 0) return '';
    if (temperature < 36.1) {
      return 'Low body temperature';
    } else if (temperature > 37.8) {
      return 'High body temperature';
    } else {
      return 'Normal body temperature';
    }
  }

  // chẩn đoán vấn đề nồng độ o2
  static String diagnoseOxygenSaturationIssue(double oxygenSaturation) {
    if (oxygenSaturation == 0) return '';
    if (oxygenSaturation < 90) {
      return 'Low oxygen saturation';
    } else if (oxygenSaturation > 100) {
      return 'High oxygen saturation';
    } else {
      return 'Normal oxygen saturation';
    }
  }

  //chẩn đoán chung về sức khỏe
  static String diagnoseHealth(double temperature, List<int> bloodPressure,
      int heartRate, double bloodGlucoseLevel, double bloodOxygenLevel) {
    String diagnosis = '';
    String heartStatus = diagnoseHeartRateIssue(heartRate);
    String bloodStatus =
        diagnoseBloodPressureIssue(bloodPressure[0], bloodPressure[1]);
    String oxyStatus = diagnoseOxygenSaturationIssue(bloodOxygenLevel);
    String tempStatus = diagnoseTemperatureIssue(temperature);
    String glucoseStatus = diagnoseBloodGlucoseLevelIssue(bloodGlucoseLevel);
    switch (heartStatus) {
      case "Dangerous":
        diagnosis += "➡️Dangerous Heart Rate\n";
        break;
      case "Low heart rate":
        diagnosis += "➡️Low Heart Rate\n";
        break;
      case "High heart rate":
        diagnosis += "➡️High Heart Rate\n";
        break;
      default:
        diagnosis += '';
    }
    switch (bloodStatus) {
      case "Optimal blood pressure":
        diagnosis += "➡️Optimal blood pressure\n";
        break;
      case "Prehypertension":
        diagnosis += "➡️Optimal blood pressure\n";
        break;
      case "Hypertension stage 1":
        diagnosis += "➡️Optimal blood pressure\n";
        break;
      case "Hypertension stage 2":
        diagnosis += "➡️Optimal blood pressure\n";
        break;
      case "Hypertension stage 3":
        diagnosis += "➡️Optimal blood pressure\n";
        break;
      case "Isolated systolic hypertension":
        diagnosis += "➡️Isolated systolic hypertension\n";
        break;
      case "Optimal blood pressure":
        diagnosis += "➡️Unable to diagnose blood pressure\n";
        break;
      default:
        diagnosis += '';
    }
    switch (oxyStatus) {
      case "Low oxygen saturation":
        diagnosis += "➡️Low oxygen saturation\n";
        break;
      case "High oxygen saturation":
        diagnosis += "➡️Low oxygen saturation\n";
        break;
      default:
        diagnosis += '';
    }
    switch (tempStatus) {
      case 'Low body temperature':
        diagnosis += '➡️Low body temperature\n';
        break;
      case 'High body temperature':
        diagnosis += '➡️High body temperature\n';
        break;
      default:
        diagnosis += '';
    }
    switch (tempStatus) {
      case 'Low blood glucose level':
        diagnosis += '➡️Low blood glucose level\n';
        break;
      case 'High blood glucose level':
        diagnosis += '➡️High blood glucose level\n';
        break;
      default:
        diagnosis += '';
    }
    // if (temperature >= 37.0 &&
    //     bloodPressure[0] >= 140 &&
    //     bloodPressure[1] >= 90 &&
    //     heartRate >= 100 &&
    //     bloodGlucoseLevel >= 200 &&
    //     bloodOxygenLevel < 95) {
    //   diagnosis = 'Good health 🌟🌿';
    // } else if (temperature >= 38.0 &&
    //     bloodPressure[0] >= 140 &&
    //     bloodPressure[1] >= 90) {
    //   diagnosis = 'High fever and high blood pressure 🌡️💉';
    // } else if (bloodPressure[0] >= 140 &&
    //     bloodPressure[1] >= 90 &&
    //     bloodOxygenLevel < 95) {
    //   diagnosis = 'High blood pressure and oxygen deficiency 💉🩸';
    // } else if (temperature >= 38.0 && bloodOxygenLevel < 95) {
    //   diagnosis = 'High fever and oxygen deficiency 😷🩺';
    // } else {
    //   diagnosis = 'Normal health 🌟';
    // }

    return diagnosis;
  }
// Hàm chẩn đoán huyết áp
  static int diagnoseBloodPressure(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 0; // Tình trạng tốt
    } else if ((systolic >= 120 && systolic <= 129) && diastolic < 80) {
      return 1; // Tình trạng ở mức đáng chú ý
    } else {
      return 2; // Tình trạng nguy hiểm
    }
  }

// Hàm chẩn đoán nhịp tim
  static int diagnoseHeartRate(int heartRate) {
    if (heartRate >= 60 && heartRate <= 100) {
      return 0; // Tình trạng tốt
    } else if ((heartRate >= 101 && heartRate <= 120) || (heartRate >= 40 && heartRate <= 59)) {
      return 1; // Tình trạng ở mức đáng chú ý
    } else {
      return 2; // Tình trạng nguy hiểm
    }
  }

// Hàm chẩn đoán nhiệt độ
  static int diagnoseTemperature(double temperature) {
    if (temperature >= 36.1 && temperature <= 37.2) {
      return 0; // Tình trạng tốt
    } else if ((temperature >= 37.3 && temperature <= 38) || (temperature >= 35 && temperature <= 36)) {
      return 1; // Tình trạng ở mức đáng chú ý
    } else {
      return 2; // Tình trạng nguy hiểm
    }
  }

// Hàm chẩn đoán đường huyết
  static int diagnoseBloodSugar(double bloodSugar) {
    if (bloodSugar >= 70 && bloodSugar <= 140) {
      return 0; // Tình trạng tốt
    } else if ((bloodSugar >= 141 && bloodSugar <= 180) || (bloodSugar >= 50 && bloodSugar <= 69)) {
      return 1; // Tình trạng ở mức đáng chú ý
    } else {
      return 2; // Tình trạng nguy hiểm
    }
  }

// Hàm chẩn đoán nồng độ O2
  static int diagnoseOxygenLevel(double oxygenLevel) {
    if (oxygenLevel >= 95) {
      return 0; // Tình trạng tốt
    } else if (oxygenLevel >= 91 && oxygenLevel <= 94) {
      return 1; // Tình trạng ở mức đáng chú ý
    } else {
      return 2; // Tình trạng nguy hiểm
    }
  }

  static double calculateBMI(double weight, double height) {
    return double.parse(
        (weight / (height * height / 10000)).toStringAsFixed(2));
  }

  static String diagnoseBMI(double bmi) {
    if (bmi < 18.5) {
      return "skinny";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return "normal";
    } else if (bmi >= 25 && bmi <= 29.9) {
      return "overweight";
    } else {
      return "obese";
    }
  }
}
