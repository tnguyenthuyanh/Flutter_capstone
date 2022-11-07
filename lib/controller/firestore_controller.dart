import 'package:cap_project/controller/storagecontrollers/budgetstoragecontroller.dart';
import 'package:cap_project/controller/storagecontrollers/monthsstoragecontroller.dart';
import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/fuelcostcalc.dart';
import 'package:cap_project/model/savings.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/model/tipcalc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/account.dart';
import '../model/budget.dart';
import '../model/budgetmonth.dart';
import '../model/constant.dart';
import '../model/plan.dart';
import '../model/purchase.dart';
import '../model/user.dart' as usr;
import 'storagecontrollers/accountstoragecontroller.dart';

class FirestoreController {
  static addUser({
    required usr.UserProfile userProf,
  }) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constant.users)
          .add(userProf.toFirestoreDoc());
      return ref.id; // doc id auto-generated.
    } catch (e) {
      rethrow;
    }
  }

  static addPlan({
    required Plan plan,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.plans)
        .add(plan.toFirestoreDoc());
    return ref.id;
  }

  static Future<void> updatePlan({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.plans)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<void> deletePlan({
    required Plan plan,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.plans)
        .doc(plan.docId)
        .delete();
  } //end food stuff

  static Future<List<Plan>> getPlanList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.plans)
        .where(Plan.CREATED_BY, isEqualTo: email)
        .orderBy(Plan.TIMESTAMP, descending: true)
        .get();
    var result = <Plan>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Plan.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          result.add(p);
        }
      }
    });
    return result;
  }

  static Future<String> addBudget({required Budget budget}) async {
    return await BudgetStorageController.addBudget(budget: budget);
  }

  static deleteBudget({required Budget budget}) async {
    await BudgetStorageController.deleteBudget(budget: budget);
  }

  static Future<List<Budget>> getBudgetList() async {
    return await BudgetStorageController.getBudgetList();
  }

  static Future<void> updateBudget({required Budget budget}) async {
    await BudgetStorageController.updateBudget(budget: budget);
  }

  static Future<String> addAccount({required Account object}) async {
    return await AccountStorageController.add(object: object);
  }

  static deleteAccount({required Account object}) async {
    await AccountStorageController.delete(object: object);
  }

  static Future<List<Account>> getAccountList() async {
    return await AccountStorageController.getList();
  }

  static Future<void> updateAccount({required Account object}) async {
    await AccountStorageController.update(object: object);
  }

  static Future<String> addBudgetMonth({required BudgetMonth object}) async {
    return await MonthsStorageController.add(object: object);
  }

  static deleteBudgetMonth({required BudgetMonth object}) async {
    await MonthsStorageController.delete(object: object);
  }

  static Future<List<BudgetMonth>> getMonthsList({required templateId}) async {
    return await MonthsStorageController.getList(templateId: templateId);
  }

  static Future<void> updateBudgetMonth({required BudgetMonth object}) async {
    await MonthsStorageController.update(object: object);
  }

  static Future<List<Debt>> getDebtList({
    required UserProfile user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.debts)
        .orderBy(DocKeyDebt.title.name, descending: true)
        .get();

    var result = <Debt>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Debt.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static addDebt({
    required UserProfile user,
    required Debt debt,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.debts)
        .add(debt.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<UserProfile> getUser({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .where(DocKeyUserprof.email.name, isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = UserProfile.fromFirestoreDoc(doc: document, docId: doc.id);
        if (u != null) return u;
      }
    }
    return UserProfile();
  }

  static Future<void> initProfile({
    required User user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: user.uid)
        .get();
    if (querySnapshot.size == 0) {
      List<String> searchOptions = [];
      String temp = "";
      for (int i = 0; i < user.email!.length; i++) {
        temp = temp + user.email![i].toLowerCase();
        searchOptions.add(temp);
      }
      await FirebaseFirestore.instance
          .collection(Constant.USERPROFILE_COLLECTION)
          .add({
        'name': "",
        'bio': "",
        'email': user.email,
        'uid': user.uid,
        'search_name': [],
        'search_email': searchOptions,
      });
    }
  }

  static Future<usr.UserInfo> getProfile({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();

    var i = querySnapshot.docs[0];
    //usr.UserInfo profile = usr.UserInfo.fromFirestoreDoc(doc: i.data() as Map<String, dynamic>, docId: i.id);
    var document = i.data() as Map<String, dynamic>;
    var p = usr.UserInfo.fromFirestoreDoc(
      doc: document,
      docId: i.id,
    );
    usr.UserInfo profile = p!;
    return profile;

    // return {
    //   'name': i['name'],
    //   'bio': i['bio'],
    //   'email': i['email'],
    //   "uid": i['uid']
    // };
  }

  static Future<void> addUpdateProfile({
    required String uid,
    required String name,
    required String bio,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();

    List<String> searchOptions = [];
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i].toLowerCase();
      searchOptions.add(temp);
    }

    await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .doc(querySnapshot.docs[0].id)
        .update({'name': name, 'bio': bio, 'search_name': searchOptions});
  }

  static Future<List<usr.UserInfo>> getUserList(
      {required String currentUID}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .orderBy(usr.UserInfo.EMAIL)
        .get();

    var result = <usr.UserInfo>[];

    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = usr.UserInfo.fromFirestoreDoc(
          doc: document,
          docId: doc.id,
        );
        if (p != null) {
          if (p.uid != currentUID) result.add(p);
        }
      }
    });
    return result;
  }

  static Future<void> deleteProfile({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();
    for (int i = 0; i < querySnapshot.size; i++)
      // ignore: curly_braces_in_flow_control_structures
      if (querySnapshot.docs[i]['uid'] == uid) {
        String docId = querySnapshot.docs[i].id;
        await FirebaseFirestore.instance
            .collection(Constant.USERPROFILE_COLLECTION)
            .doc(docId)
            .delete();
      }
  }

  static Future<void> addFriend({
    required usr.UserFriends userFriends,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .add(userFriends.toFirestoreDoc());
  }

  static Future<String> isFriendAdded({
    required String friendUID,
    required String currentUID,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where('uid_send', isEqualTo: currentUID)
        .where('uid_receive', isEqualTo: friendUID)
        .get();
    for (int i = 0; i < querySnapshot.size; i++)
      if (querySnapshot.docs[i]['accept'] == 0)
        return 'Pending';
      else
        return 'isFriend';

    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where('uid_send', isEqualTo: friendUID)
        .where('uid_receive', isEqualTo: currentUID)
        .get();
    for (int i = 0; i < querySnapshot1.size; i++)
      if (querySnapshot1.docs[i]['accept'] == 0)
        return 'Accept';
      else
        return 'isFriend';

    return 'canAdd';
  }

  static Future<void> acceptFriend({
    required String friendUID,
    required String currentUID,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where('uid_send', isEqualTo: friendUID)
        .where('uid_receive', isEqualTo: currentUID)
        .get();

    await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .doc(querySnapshot.docs[0].id)
        .update({usr.UserFriends.ACCEPT: 1});
  }

  static Future<List<usr.UserInfo>> getFriendList({
    required String currentUID,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where(usr.UserFriends.UID_RECEIVE, isEqualTo: currentUID)
        .where(usr.UserFriends.ACCEPT, isEqualTo: 1)
        .get();

    var result = <usr.UserInfo>[];

    for (int i = 0; i < querySnapshot.size; i++) {
      if (querySnapshot.docs[i] != null) {
        var document = querySnapshot.docs[i].data() as Map<String, dynamic>;
        var p = usr.UserFriends.fromFirestoreDoc(
          doc: document,
          docId: querySnapshot.docs[i].id,
        );
        if (p != null) {
          usr.UserInfo eachUser = await getProfile(uid: p.uid_send);
          result.add(eachUser);
        }
      }
    }

    querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where(usr.UserFriends.UID_SEND, isEqualTo: currentUID)
        .where(usr.UserFriends.ACCEPT, isEqualTo: 1)
        .get();

    for (int i = 0; i < querySnapshot.size; i++) {
      if (querySnapshot.docs[i] != null) {
        var document = querySnapshot.docs[i].data() as Map<String, dynamic>;
        var p = usr.UserFriends.fromFirestoreDoc(
          doc: document,
          docId: querySnapshot.docs[i].id,
        );
        if (p != null) {
          usr.UserInfo eachUser = await getProfile(uid: p.uid_receive);
          result.add(eachUser);
        }
      }
    }

    return result;
  }

  static Future<List<usr.UserInfo>> getFriendRequest({
    required String currentUID,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERFRIENDS_COLLECTION)
        .where(usr.UserFriends.UID_RECEIVE, isEqualTo: currentUID)
        .where(usr.UserFriends.ACCEPT, isEqualTo: 0)
        .get();

    var result = <usr.UserInfo>[];

    for (int i = 0; i < querySnapshot.size; i++) {
      if (querySnapshot.docs[i] != null) {
        var document = querySnapshot.docs[i].data() as Map<String, dynamic>;
        var p = usr.UserFriends.fromFirestoreDoc(
          doc: document,
          docId: querySnapshot.docs[i].id,
        );
        if (p != null) {
          usr.UserInfo eachUser = await getProfile(uid: p.uid_send);
          result.add(eachUser);
        }
      }
    }

    return result;
  }

  // tools - save tip calc
  static Future<String> saveTipCalc(TipCalc tc) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .add(tc.toFirestoreDoc());
    return ref.id;
  }

  // tools - get tipcalc list
  static Future<List<TipCalc>> getSavedTipCalcList(
      {required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .where(TipCalc.CREATE_BY, isEqualTo: email)
        .orderBy(TipCalc.TIMESTAMP, descending: true)
        .get();
    var result = <TipCalc>[];
    querySnapshot.docs.forEach((m) {
      var data = m.data() as Map<String, dynamic>;
      result.add(TipCalc.fromFirestoreDoc(docId: m.id, doc: data));
    });
    return result;
  }

  static Future<void> updateDebt({
    required UserProfile userP,
    required String docId,
    required Map<String, dynamic> update,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(userP.docId)
        .collection(Constant.debts)
        .doc(docId)
        .update(update);
  }

  // delete saved tip calc
  static Future<void> deleteSavedTipCalcItem(String docId) async {
    await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .doc(docId)
        .delete();
  }

  // tools - save fuel cost calc. result
  static Future<String> saveFuelCostCalc(FuelCostCalc fcc) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.savedFuelCostCalc)
        .add(fcc.toFirestoreDoc());
    return ref.id;
  }

  static addPurchase({
    required UserProfile user,
    required Purchase purchase,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.purchases)
        .add(purchase.toFirestoreDoc());
    return ref.id; // doc is auto-generated.
  }

  static Future<void> deleteTransaction(
      Purchase purchase, UserProfile user) async {
    await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.purchases)
        .doc(purchase.docId)
        .delete();
  }

  static Future<List<Purchase>> getPurchaseList({
    required UserProfile user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.purchases)
        .orderBy(DocKeyPurchase.amount.name, descending: true)
        .get();

    var result = <Purchase>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Purchase.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static Future<List<usr.UserInfo>> searchUsersByEmail({
    required String searchKey,
  }) async {
    var results = <usr.UserInfo>[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where(usr.UserInfo.SEARCH_EMAIL, arrayContains: searchKey)
        .get();

    querySnapshot.docs.forEach((doc) {
      var p = usr.UserInfo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) results.add(p);
    });

    return results;
  }

  static Future<List<usr.UserInfo>> searchUsersByName({
    required String searchKey,
  }) async {
    var results = <usr.UserInfo>[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where(usr.UserInfo.SEARCH_NAME, arrayContains: searchKey)
        .get();

    querySnapshot.docs.forEach((doc) {
      var p = usr.UserInfo.fromFirestoreDoc(
        doc: doc.data() as Map<String, dynamic>,
        docId: doc.id,
      );
      if (p != null) results.add(p);
    });

    return results;
  }

  static Future<List<Savings>> getSavings({
    required UserProfile user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.savings)
        .orderBy(DocKeySavings.amount.name, descending: true)
        .get();

    var result = <Savings>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Savings.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static addSavings({
    required UserProfile user,
    required Savings savings,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.savings)
        .add(savings.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }
}
