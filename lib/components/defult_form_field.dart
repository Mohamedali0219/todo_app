import 'package:flutter/material.dart';
import 'package:sqflite_todo_app/shared/cubit/cubit.dart';

Widget deflutTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onFieldSubmitted,
  Function(String)? onChange,
  required String? Function(String?)? validator,
  required String hint,
  required IconData prefix,
  required double prefixIconSize,
  bool obscureText = false,
  IconData? suffix,
  Function()? onPressed,
  Function()? onTap,
  double? suffixIconSize,
}) =>
    TextFormField(
      //email
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChange,
      onTap: onTap,
      validator: validator,
      obscureText: obscureText,

      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
          size: prefixIconSize,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(
                  suffix,
                  size: suffixIconSize,
                ))
            : null,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 20.0),
        border: const OutlineInputBorder(),
        // enabledBorder: OutlineInputBorder(),
        // focusedBorder: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              child: Text(model['time']),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model['date'],
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  Appcubit.get(context)
                      .updateDate(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  Appcubit.get(context)
                      .updateDate(status: 'archived', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive_outlined,
                ))
          ],
        ),
      ),
      onDismissed: (direction) {
        Appcubit.get(context).deleteData(
          id: model['id'],
        );
      },
    );
