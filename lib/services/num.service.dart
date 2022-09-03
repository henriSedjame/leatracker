import 'package:shared_preferences/shared_preferences.dart';

const numbers = "numbers";

class NumService {

   final SharedPreferences _sharedPreferences;

  NumService(this._sharedPreferences);

  init() async {
    if(!_sharedPreferences.containsKey(numbers)) {
      _sharedPreferences.setStringList(numbers, []);
    }
  }

  Future<bool> addNum(String num) async {
    var nums = _sharedPreferences.getStringList(numbers);
    if(!nums!.contains(num)) {
      nums.add(num);
    }
    return  _sharedPreferences.setStringList(numbers, nums);
  }

  Future<List<String>> getNums() async {
    return _sharedPreferences.getStringList(numbers)!;
  }

  Future<bool> delete(String num) {
    var nums = _sharedPreferences.getStringList(numbers);
    nums!.remove(num);
    return  _sharedPreferences.setStringList(numbers, nums);
  }

}