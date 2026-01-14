import 'package:flutter/material.dart';
import 'data_services.dart';
import 'user.dart';
import 'user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();

  String _result = '-';
  List<User> _users = [];

  UserCreate? usCreate;
  UserCreate? usUpdate;

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API (DIO)'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _jobCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Job',
                  suffixIcon: IconButton(
                    onPressed: _jobCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              /// BUTTON ROW
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _dataService.getUsers();
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                          });
                        } else {
                          displaySnackbar('Failed to fetch users');
                        }
                      },
                      child: const Text('GET'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty ||
                            _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua field harus diisi');
                          return;
                        }

                        final postModel = UserCreate(
                          name: _nameCtl.text,
                          job: _jobCtl.text,
                        );

                        final res =
                            await _dataService.postUser(postModel);

                        setState(() {
                          _result = res.toString();
                          usCreate = res;
                        });

                        _nameCtl.clear();
                        _jobCtl.clear();
                      },
                      child: const Text('POST'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty ||
                            _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua data harus diisi');
                          return;
                        }

                        final res = await _dataService.putUser(
                          '3',
                          _nameCtl.text,
                          _jobCtl.text,
                        );

                        setState(() {
                          _result = res.toString();
                          usUpdate = UserCreate(
                            id: '3',
                            name: _nameCtl.text,
                            job: _jobCtl.text,
                            createdAt:
                                DateTime.now().toString(),
                          );
                        });

                        _nameCtl.clear();
                        _jobCtl.clear();
                      },
                      child: const Text('PUT'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res =
                            await _dataService.deleteUser('4');
                        setState(() {
                          _result = res.toString();
                        });
                      },
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// MODEL GET BUTTON
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final users =
                            await _dataService.getUserModel();
                        setState(() {
                          _users = users!.toList();
                        });
                      },
                      child: const Text(
                          'Model Class User Example'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _users.clear();
                        usCreate = null;
                        usUpdate = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                'Result',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: _users.isNotEmpty
                    ? _buildListUser()
                    : Text(_result),
              ),

              const SizedBox(height: 10),
              hasilCreateCard(),
              const SizedBox(height: 10),
              hasilUpdateCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// LIST USER
  Widget _buildListUser() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                user.avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            title:
                Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
          ),
        );
      },
      separatorBuilder: (_, __) =>
          const SizedBox(height: 8),
      itemCount: _users.length,
    );
  }

  /// POST CARD
  Widget hasilCreateCard() {
    return usCreate != null
        ? UserCard(usrCreate: usCreate!)
        : const Text('no data');
  }

  /// PUT CARD
  Widget hasilUpdateCard() {
    return usUpdate != null
        ? UserCard(usrCreate: usUpdate!)
        : const Text('no data');
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
