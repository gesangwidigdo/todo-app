# Todo App

**Aplikasi dibuat menggunakan database Hive**

| Name                         | NRP        | Class |
|------------------------------|------------|-------|
| Muhammad Gesang Ridho Widigdo| 5025221216 | C     |

## Fitur

- CRUD Task
- Menyimpan task ke database Hive

## Penjelasan

Aplikasi dibuat menggunakan database yang terpasang di lokal, yaitu **Hive**.

### Install Dependency

Sebelum menggunakan Hive, perlu diinstall terlebih dahulu dependency nya dengan menambahkan baris berikut di `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  hive_generator: ^1.1.3
  build_runner: ^2.1.11
```

Kemudian tekan tombol untuk install dependency di atas, atau dapat dengan menjalankan perintah berikut di terminal.

```bash
flutter pub get
```

### Inisiasi

Inisiasi dilakukan pada fungsi `main()` di file `main.dart` dengan menambahkan line `await Hive.initFlutter();`. Setelah itu ditambahkan percabangan untuk mengecek apakah database dengan nama **taskBox** sudah ada atau belum menggunakan fungsi `isBoxOpen()`. Jika belum ada, maka dibuat database baru dengan fungsi `openBox()`. Fungsi ini dipanggil secara *asynchronous*, sehingga fungsi main diubah menjadi *async function*.

**lib/main.dart**
```dart
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  if (!Hive.isBoxOpen('taskBox')) {
    await Hive.openBox<Task>('taskBox');
  }
  runApp(const MainApp());
}
```

### Membuat Model

Setelah inisiasi database, dibuat model untuk menetapkan properti/field apa saja yang harus dimasukkan saat task dibuat agar dapat menyimpan *custom object*. Dalam kasus ini terdapat task, deadline, dan isCompleted.

**lib/model/task.dart**
```dart
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime deadline;

  @HiveField(2)
  bool isCompleted;

  Task({required this.task, required this.deadline, required this.isCompleted});
}
```

| Anotasi                      | Penjelasan|
|------------------------------|------------|
| ```@HiveType(typeId: 0)```| Menandai suatu class adalah Hive object, dan memberikan id unik untuk membedakan antar class/model yang akan disimpan. |
| ```@HiveField(num)```| Digunakan untuk menandai properti/field yang akan disimpan di class/model tersebut. `num` merupakan indeks dari field |

`part 'task.g.dart'` adalah directive dart. Baris ini perlu ditambahkan untuk menghubungkan file utama (dalam kasus ini `task.dart`) dengan file yang digenerate otomatis oleh Hive untuk dapat mengolah data dari class tersebut, yaitu `task.g.dart`.

File `task.g.dart` dapat di-generate dengan menjalankan perintah berikut.

```bash
flutter packages pub run build_runner build
```

### Implementasi CRUD

Untuk menggunakan fungsi-fungsi pada hive untuk menambahkan, membaca dan menghapus data, diperlukan inisialisasi variabel untuk membuka database yang sudah dibuat menggunakan fungsi ```.box(namaBox)```.

```dart
final Box<Task> _taskBox = Hive.box<Task>('taskBox');
```

#### Create

Create data, atau menambahkan data baru ke dalam database/box, dapat dengan menggunakan fungsi `put(key, value)`. Terdapat key karena Hive merupakan database **NoSQL**.

**lib/screen/main_screen.dart**
```dart
final Box<Task> _taskBox = Hive.box<Task>('taskBox');
...
void _addTask(Task task) {
  final key = 'key_${DateTime.now().millisecondsSinceEpoch}';
  _taskBox.put(key, task);
}
...
floatingActionButton: FloatingActionButton(
  onPressed:
      () => showTaskDialog(
        ...
        onSave: () {
          if (taskController.text.isNotEmpty) {
            final task = Task(
              task: taskController.text,
              deadline: DateTime.parse(dateController.text),
              isCompleted: false,
            );
            _addTask(task);
          }
        },
      ),
  ...
),
```

Pada kode di atas, key dibuat berdasarkan format waktu *milisecondSinceEpoch* yang akan selalu menghasilkan id yang unik karena waktu terus berjalan. Variabel task berisi objek Task berdasarkan input dari user.

#### Read

Untuk menampilkan data yang ada di database/box, terdapat beberapa fungsi yang bisa digunakan, yaitu `get()` dan `getAt(index)`. Pada contoh ini, fungsi yang digunakan adalah `getAt(index)` untuk menampilkan seluruh item ke tampilan layar.

Sebelum ditampilkan, terdapat algoritma sort untuk mengurutkan item berdasarkan deadline, kemudian key nya disimpan ke variable `_taskOriginalIndex`. Variabel ini digunakan untuk mengambil data berdasarkan index asli dari item yang tersimpan pada database. Pengambilan data menggunakan fungsi `getAt(_taskOriginalIndex)`.

**lib/screen/main_screen.dart**
```dart
return Scaffold(
  ...
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: ValueListenableBuilder(
      valueListenable: _taskBox.listenable(),
      builder: (context, Box<Task> box, _) {
        // Listen for changes in the box and rebuild the UI
        final taskList = box.values.toList();
        taskList.sort((a, b) => a.deadline.compareTo(b.deadline));

        return ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            final _taskIndex = _taskBox.keys.toList().indexOf(
              taskList[index].key,
            );
            final task = _taskBox.getAt(_taskIndex);
            return TodoCard(
              task: task!.task,
              deadline: task.deadline,
              isCompleted: task.isCompleted,
              taskKey: task.key,
            );
          },
        );
      },
    ),
  ),
  ...
);
```

#### Update

Fungsi untuk update sama seperti Create, yaitu menggunakan fungsi `put()`. Bedanya untuk fungsi update menggunakan key dari data yang ingin diubah. Berikut fungsi `_editTask()` pada kelas `TodoCard`.

**lib/widget/todo_card.dart**
```dart
class TodoCard extends StatelessWidget {
  TodoCard({
    super.key,
    required this.task,
    required this.deadline,
    required this.isCompleted,
    required this.taskKey,
  });

  final Box<Task> _taskBox = Hive.box<Task>('taskBox');
  
  final String task;
  final DateTime deadline;
  final bool isCompleted;
  final dynamic taskKey;
  ...
  void _editTask(Task updatedTask) {
    _taskBox.put(taskKey, updatedTask);
  }
  ...
    IconButton(
      onPressed:
          () => _editTask(
            Task(
              task: task,
              deadline: deadline,
              isCompleted: !isCompleted,
            ),
          ),
      icon: Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.limeAccent,
      ),
    ),
    IconButton(
      onPressed: () {
        ...
        showTaskDialog(
          ...
          onSave: () {
            if (taskController.text.isNotEmpty &&
                dateController.text.isNotEmpty) {
                ...
              _editTask(updatedTask);
            }
          },
        );
      },
      icon: Icon(Icons.border_color_sharp, color: Colors.lightBlue),
    ),
  ...
}
```

Fungsi pertama untuk update status `isCompleted`, sedangkan fungsi kedua untuk mengubah task dan deadlinenya.

Jadi key nya diambil dari pemanggilan kelas `TodoCard` di `main_screen.dart`

**lib/screen/main_screen.dart**
```dart
...
 return TodoCard(
    task: task!.task,
    deadline: task.deadline,
    isCompleted: task.isCompleted,
    taskKey: task.key,
  );
...
```

#### Delete

Untuk menghapus data, dapat dengan menggunakan fungsi `delete(key)`. Sama seperti fungsi `_editTask()`, key nya diambil saat pemanggilan kelas `TodoCard`, karena fungsi `_deleteTask()` terletak di file yang sama dengan fungsi `_editTask()`.

**lib/widget/todo_card.dart**
```dart
class TodoCard extends StatelessWidget {
  TodoCard({
    super.key,
    required this.task,
    required this.deadline,
    required this.isCompleted,
    required this.taskKey,
  });

  final Box<Task> _taskBox = Hive.box<Task>('taskBox');
  ...
  final dynamic taskKey;
  // delete task
  void _deleteTask(BuildContext context) {
    _taskBox.delete(taskKey);
  }

  // edit task
  void _editTask(Task updatedTask) {
    _taskBox.put(taskKey, updatedTask);
  }
  ...
    IconButton(
      onPressed: () => _deleteTask(context),
      icon: Icon(Icons.delete, color: Colors.red),
    ),
  ...
}
```