import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ItemToDo());
}

class ItemToDo extends StatelessWidget {
  const ItemToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Item ToDo",
      home: ItemToDoScreen(),
    );
  }
}

class AddItem {
  String title;
  String description;

  AddItem({
    required this.title,
    required this.description,
  });
}

class ItemToDoScreen extends StatefulWidget {
  const ItemToDoScreen({Key? key}) : super(key: key);
  @override
  State<ItemToDoScreen> createState() => _ItemToDoScreenState();
}

class _ItemToDoScreenState extends State<ItemToDoScreen> {
  List<AddItem> items = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Item To Do"),
          centerTitle: false,
          actions: const [Icon(Icons.search)],
        ),
        body: showAddItemBox(),
      ),
    );
  }

  SingleChildScrollView showAddItemBox() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // add item list
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "Add Title",
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter a value";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "Add Description",
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter a value";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String title = titleController.text;
                          String description = descriptionController.text;
                          setState(() {
                            items.add(
                                AddItem(title: title, description: description));
                          });
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent)),
                      child: const Text("Add"))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white60,
                    child: ListTile(
                      onTap: (){
                        FocusScope.of(context).unfocus();
                      },
                      onLongPress: () {
                        _showOptionItemDialogue(index);
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                      ),
                      title: Text(items[index].title),
                      subtitle: Text(items[index].description),
                      trailing: const Icon(CupertinoIcons.arrow_right),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void _showOptionItemDialogue(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showUpdateItem(index);
                  },
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  child: const Text("Delete",
                      style: TextStyle(color: Colors.lightBlueAccent)),
                )
              ],
            ),
          );
        });
  }

  void showUpdateItem(int index) {
    TextEditingController titleController =
        TextEditingController(text: items[index].title);
    TextEditingController descriptionController =
        TextEditingController(text: items[index].description);
    GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: mediaQueryData.viewInsets,
            child: SingleChildScrollView(
              child: Form(
                key: formKeyUpdate,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Edit Title",
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter a value";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Edit Description",
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter a value";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKeyUpdate.currentState!.validate()) {
                            items[index].title = titleController.text;
                            items[index].description = descriptionController.text;
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                        ),
                        child: const Text("Edit Done"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
