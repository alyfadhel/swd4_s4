import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swd4_s4/core/shared/widgets/my_form_field.dart';
import 'package:swd4_s4/features/todo/archive/presentation/screens/archive_screen.dart';
import 'package:swd4_s4/features/todo/done/presentation/screens/done_screen.dart';
import 'package:swd4_s4/features/todo/new/presentation/screens/new_screen.dart';
import 'package:path/path.dart' as p;

class TodoLayout extends StatefulWidget {
  const TodoLayout({super.key});

  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New'),
  BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
  BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive'),
];
int currentIndex = 0;
List<Widget> screens = [NewScreen(), DoneScreen(), ArchiveScreen()];
List<String> titles = ['New', 'Done', 'Archive'];
List<Map>tasks = [];
Database? database;
var scaffoldKey = GlobalKey<ScaffoldState>();
var formKey = GlobalKey<FormState>();
bool isBottomShow = false;
IconData fabIcon = Icons.edit;
var titleController = TextEditingController();
var dateController = TextEditingController();
var timeController = TextEditingController();

class _TodoLayoutState extends State<TodoLayout> {
  @override
  void initState() {
    createDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text(
          titles[currentIndex],
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if(isBottomShow)
          {
            if(formKey.currentState!.validate()){
              insertDataFromDataBase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value){
                getDataFromDatabase(database).then((value){
                  if(context.mounted){
                    Navigator.pop(context);
                    isBottomShow = false;
                    setState(() {
                      fabIcon = Icons.edit;
                    });
                  }
                });
              });
            }
          }else{
            scaffoldKey.currentState!.showBottomSheet(
                  (context) => Container(
                color: Colors.grey[300],
               padding: EdgeInsets.all(20.0,),
               child: Form(
                 key: formKey,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     MyFormField(
                         controller: titleController,
                         type: TextInputType.text,
                         prefix: Icons.title,
                         text: 'title',
                       validator: (value)
                       {
                         if(value!.isEmpty){
                           return 'Title must be not empty';
                         }
                          return null;
                       },
                     ),
                     SizedBox(
                       height: 20.0,
                     ),
                     MyFormField(
                       controller: dateController,
                       type: TextInputType.datetime,
                       prefix: Icons.calendar_today,
                       text: 'date',
                       validator: (value)
                       {
                         if(value!.isEmpty){
                           return 'Date must be not empty';
                         }
                         return null;
                       },
                       onTap: ()
                       {
                         FocusScope.of(context).requestFocus(FocusNode());
                         showDatePicker(
                             context: context,
                             firstDate: DateTime.now(),
                             lastDate: DateTime.parse('2025-12-31'),
                         ).then((value){
                           if(value!=null){
                             dateController.text = DateFormat.yMMMd().format(value);
                             debugPrint(DateFormat.yMMMd().format(value));
                           }
                         },);
                       },
                     ),
                     SizedBox(
                       height: 20.0,
                     ),
                     MyFormField(
                       controller: timeController,
                       type: TextInputType.datetime,
                       prefix: Icons.watch_later_outlined,
                       text: 'time',
                       validator: (value)
                       {
                         if(value!.isEmpty){
                           return 'Time must be not empty';
                         }
                         return null;
                       },
                       onTap: ()
                       {
                         FocusScope.of(context).requestFocus(FocusNode());
                         showTimePicker(
                             context: context,
                             initialTime: TimeOfDay.now(),
                         ).then((value){
                           if(value != null)
                           {
                             if(context.mounted){
                               timeController.text = value.format(context);
                               debugPrint(value.format(context));
                             }
                           }
                         });
                       },
                     ),
                   ],
                 ),
               ),
              ),
            ).closed.then((value){
              isBottomShow = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomShow = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.blue,
        child: Icon(
            fabIcon,
            color: Colors.white,
        ),
      ),
      body: screens[currentIndex],
    );
  }
}

void createDataFromDatabase() async {
  var databasesPath = await getDatabasesPath();
  String path = p.join(databasesPath, 'tasks.db');
  openDataFromDataBase(path: path);
}

void openDataFromDataBase({required String path})
async {
  await openDatabase(
    path,
    version: 1,
    onCreate: (Database database, int version) async {
      debugPrint('Database Created');
      await database
          .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
          )
          .then((value) {
            debugPrint('Table Created');
          })
          .catchError((error) {
            debugPrint('Error when table created${error.toString()}');
          });
    },
    onOpen: (database) {
      debugPrint('Database Opened');
    },
  ).then((value) {
    database = value;
  });
}

Future insertDataFromDataBase({
  required String title,
  required String date,
  required String time,
})
async {
  await database!.transaction((txn) async {
    await txn
        .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
        )
        .then((value) {
          getDataFromDatabase(database).then((value){
            tasks = value;
            debugPrint(tasks.toString());
          });
          debugPrint('$value Insert Successfully');
        })
        .catchError((error) {
          debugPrint('Error when insert new record ${error.toString()}');
        });
  });
}

Future<List<Map>> getDataFromDatabase(database)async
{
   return await database.rawQuery('SELECT * FROM tasks');
}


