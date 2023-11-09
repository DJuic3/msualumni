import 'package:get/get.dart';
import '../../db_helper.dart';
import 'account_model.dart';


class AccountController extends GetxController {
  final RxList<Account> accountList = <Account>[].obs;

  // add data to table
  //second brackets means they are named optional
  Future<int> addAccount({Account? account}) {
    return DBHelper.insert(account);
  }

  // get all the data from table
  Future<void> getAccounts() async {
    final List<Map<String, dynamic>> accounts = await DBHelper.query();
    accountList.assignAll(accounts.map((data) => Account.fromJson(data)).toList());
  }

  // delete data from table
  void deleteAccounts(Account account) async {
    await DBHelper.delete(account);
    getAccounts();
  }
  void deleteAllAccounts() async {
    await DBHelper.deleteAll();
    getAccounts();
  }

  // update data int table
  void markAccountCompleted(int id) async {
    await DBHelper.update(id);
    getAccounts();
  }
}