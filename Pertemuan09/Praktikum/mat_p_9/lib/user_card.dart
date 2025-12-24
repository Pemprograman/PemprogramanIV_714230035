import 'package:flutter/material.dart';
import 'user.dart';

class UserCard extends StatelessWidget {
  final UserCreate usrCreate;

  const UserCard({
    super.key,
    required this.usrCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildRow('ID', usrCreate.id),
          _buildRow('Name', usrCreate.name),
          _buildRow('Job', usrCreate.job),
          _buildRow('Created At', usrCreate.createdAt),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 70,
          child: Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(': ${value ?? '-'}'),
        ),
      ],
    );
  }
}
