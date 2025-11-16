import 'package:flutter/material.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/Screens/Login/login_screen.dart';

class AdminAuthGuard extends StatefulWidget {
  final Widget child;
  
  const AdminAuthGuard({
    super.key,
    required this.child,
  });

  @override
  State<AdminAuthGuard> createState() => _AdminAuthGuardState();
}

class _AdminAuthGuardState extends State<AdminAuthGuard> {
  bool _loading = true;
  bool _hasAccess = false;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    try {
      final hasAccess = await SessionManager().hasAdminAccess();
      setState(() {
        _hasAccess = hasAccess;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _hasAccess = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Đang kiểm tra quyền truy cập...',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Fredoka',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasAccess) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(height: 24),
                Text(
                  'Không có quyền truy cập',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontFamily: 'Fredoka',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Bạn cần đăng nhập với tài khoản admin để truy cập trang này.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Fredoka',
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5CB15A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Đăng nhập Admin',
                        style: TextStyle(fontFamily: 'Fredoka'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Về trang chủ',
                        style: TextStyle(fontFamily: 'Fredoka'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
