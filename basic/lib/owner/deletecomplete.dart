import 'package:flutter/material.dart';

class deletecompleteforowner extends StatefulWidget {
  const deletecompleteforowner({super.key});

  @override
  State<deletecompleteforowner> createState() => _deletecompleteforownerState();
}

class _deletecompleteforownerState extends State<deletecompleteforowner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        
        title: const Text('User deleted'),
        content: const Text(
          'Selected user have been deleted \n'
          'All the permissions assigned to \n'
          'account will be withdraw\n'
          'immediately.',
        ),
        actions: <Widget>[
         
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
