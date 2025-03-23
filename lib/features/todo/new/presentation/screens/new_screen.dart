import 'package:flutter/material.dart';
import 'package:swd4_s4/core/layout/todo_layout/todo_layout.dart';
import 'package:swd4_s4/features/todo/new/presentation/widgets/build_task_item.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return ListView.separated(
      itemBuilder: (context, index) => BuildTaskItem(
        model: tasks[index],
      ),
      separatorBuilder:
          (context, index) =>
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Divider(height: 1.0, color: Colors.grey, thickness: 1.5),
          ),
      itemCount: tasks.length,
    );
  }
}


