// File: lib/widgets/delete_confirmation_dialog.dart

// import 'package:flutter/material.dart';
// import 'package:StapesHome/constants/colors.dart';

// class DeleteConfirmationDialog extends StatelessWidget {
//   final String itemType;
//   final String itemName;
//   final VoidCallback onDelete;

//   // TODO: make this a generic popup
//   const DeleteConfirmationDialog({
//     super.key,
//     required this.itemType,
//     required this.itemName,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Delete $itemType'),
//       content: Text('Are you sure you want to delete $itemName?'),
//       actions: <Widget>[
//         TextButton(
//           child: const Text(
//             'Cancel',
//             style: TextStyle(color: AppColor.grayColor),
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         TextButton(
//           child: const Text(
//             'Delete',
//             style: TextStyle(color: Colors.red),
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//             onDelete();
//           },
//         ),
//       ],
//     );
//   }
// }
