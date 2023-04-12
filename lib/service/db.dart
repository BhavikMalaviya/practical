import 'package:practical/model/category_model.dart';
import 'package:practical/model/user_model.dart';
import 'package:practical/utils/globle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DataBaseHelper {
  static final DataBaseHelper _databaseHelper = DataBaseHelper._();

  DataBaseHelper._();
  late Database db;

  factory DataBaseHelper() {
    return _databaseHelper;
  }

  //Initialize & create db/Table
  Future<void> initializedDB() async {
    String dbPath = await getDatabasesPath();
    db = await openDatabase(
      p.join(dbPath, 'contact.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE user(
            user_id INTEGER PRIMARY KEY,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            mobile_no TEXT NOT NULL,
            email TEXT NOT NULL,
            category_id INTEGER NOT NULL,
            profile_image TEXT NOT NULL
            )''',
        );
        await db.execute(
          '''CREATE TABLE category(
            category_id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
            )''',
        );
      },
    );
  }

  //Insert category
  Future<void> insertCategory(CategoryModel categoryModel) async {
    await db.insert('category', categoryModel.toJson());
  }

  //Insert user
  Future<void> insertUser(UserModel userModel) async {
    await db.insert('user', userModel.toJson());
  }

  //Retrive category
  Future<List<CategoryModel>> retriveCategory() async {
    List<CategoryModel> categoryModelList = [];

    final List<Map<String, Object?>> queryResult = await db.query("category");
    categoryModelList = queryResult
        .map((e) => CategoryModel.fromJson(e))
        .toList(growable: true);

    return categoryModelList;
  }

  //Retrive user
  Future<List<UserModel>> retriveUser() async {
    List<UserModel> userModelList = [];

    final List<Map<String, Object?>> queryResult = await db.query("user");
    userModelList =
        queryResult.map((e) => UserModel.fromJson(e)).toList(growable: true);

    return userModelList;
  }

  //Update category
  Future<void> updateCategory(CategoryModel categoryModel) async {
    int result = await db.update(
      'category',
      categoryModel.toJson(),
      where: "category_id  = ?",
      whereArgs: [categoryModel.categoryId],
    );
    if (result == 1) {
      toast("Update successfully");
    }
  }

  //Update User
  Future<void> updateUser(UserModel userModel) async {
    int result = await db.update(
      'user',
      userModel.toJson(),
      where: "user_id  = ?",
      whereArgs: [userModel.userId],
    );
    if (result == 1) {
      toast("Update successfully");
    }
  }

  ///Delete category
  Future<void> deleteCategory(int id) async {
    int result = await db.delete(
      'category',
      where: "category_id = ?",
      whereArgs: [id],
    );
    if (result == 1) {
      toast("Delete successfully");
    }
  }

  ///Delete user
  Future<void> deleteUser(int id) async {
    int result = await db.delete(
      'user',
      where: "user_id = ?",
      whereArgs: [id],
    );
    if (result == 1) {
      toast("Delete successfully");
    }
  }
}
