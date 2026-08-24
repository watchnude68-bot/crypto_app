import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HardCryptoWallet());
}

class HardCryptoWallet extends StatelessWidget {
  const HardCryptoWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HARD CRYPTO WALLET',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E17),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- CENTRAL OFFLINE STATE DATA ---
double totalBalance = 54230.00;
bool isBalanceHidden = false;

List<Map<String, dynamic>> myAssets = [
  {"name": "Bitcoin", "code": "BTC", "amount": 0.45, "value": 31050.00, "icon": Icons.currency_bitcoin},
  {"name": "Ethereum", "code": "ETH", "amount": 6.20, "value": 18200.00, "icon": Icons.token},
  {"name": "Tether", "code": "USDT", "amount": 4980.00, "value": 4980.00, "icon": Icons.monetization_on},
];

List<Map<String, dynamic>> transactionHistory = [
  {"type": "Received", "code": "BTC", "amount": "0.05 BTC", "date": "Today, 02:45 PM", "isInbound": true},
  {"type": "Sent", "code": "ETH", "amount": "0.50 ETH", "date": "Yesterday, 11:15 AM", "isInbound": false},
];

// 1. SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_exchange_rounded, size: 100, color: Color(0xFFFFD700)),
            SizedBox(height: 30),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700))),
          ],
        ),
      ),
    );
  }
}

// 2. ONBOARDING SCREEN
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              const Column(
                children: [
                  Text('HCW', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 4, color: Color(0xFFFFD700))),
                  SizedBox(height: 10),
                  Text('HARD CRYPTO WALLET', style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 2)),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationController()));
                    },
                    child: const Text('Create a New Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationController()));
                    },
                    child: const Text('Sync Existing Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. MAIN NAVIGATION CONTROLLER (No text, pure icon-based bottom bar)
class MainNavigationController extends StatefulWidget {
  const MainNavigationController({Key? key}) : super(key: key);

  @override
  _MainNavigationControllerState createState() => _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF131A26),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home_rounded, size: 28, color: _currentIndex == 0 ? const Color(0xFFFFD700) : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 0),
                ),
                IconButton(
                  icon: Icon(Icons.history_toggle_off_rounded, size: 28, color: _currentIndex == 1 ? const Color(0xFFFFD700) : Colors.grey),
                  onPressed: () => setState(() => _currentIndex = 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 4. HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      _verifyAdminAccess(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF131A26),
                      child: Icon(Icons.person_outline_rounded, color: Color(0xFFFFD700)),
                    ),
                  ),
                  const Text('Vault Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const Icon(Icons.notifications_none_rounded, color: Colors.white),
                ],
              ),
              const SizedBox(height: 25),
              
              // Glassmorphic Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    const Text('Total Net Worth', style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isBalanceHidden ? '\u2022\u2022\u2022\u2022\u2022\u2022' : '\$${totalBalance.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(isBalanceHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                          onPressed: () => setState(() => isBalanceHidden = !isBalanceHidden),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Quick Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF131A26),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_upward_rounded, color: Colors.redAccent),
                      label: const Text('Send'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF131A26),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_downward_rounded, color: Colors.greenAccent),
                      label: const Text('Receive'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              
              const Text('My Assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 15),

              // Owner Asset Board
              Expanded(
                child: ListView.builder(
                  itemCount: myAssets.length,
                  itemBuilder: (context, index) {
                    final asset = myAssets[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF131A26), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(backgroundColor: const Color(0xFF0A0E17), child: Icon(asset['icon'], color: const Color(0xFFFFD700))),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(asset['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(asset['code'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${asset['value'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${asset['amount']} ${asset['code']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SECOND SECURITY LAYER: ADMIN PASSWORD VERIFICATION ('193719371937')
  void _verifyAdminAccess(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    const String masterPassword = "193719371937"; 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A26),
          title: const Text('Security Authorization', style: TextStyle(color: Color(0xFFFFD700))),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter Master Code",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text == masterPassword) {
                  Navigator.pop(context); 
                  _openAdminPanel(context); 
                } else {
                  Navigator.pop(context); 
                }
              },
              child: const Text('Verify', style: TextStyle(color: Color(0xFFFFD700))),
            ),
          ],
        );
      },
    );
  }

  // SECRET ADMIN PANEL
  void _openAdminPanel(BuildContext context) {
    final TextEditingController balanceController = TextEditingController(text: totalBalance.toString());
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131A26),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GHOST CONTROL PANEL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFD700), letterSpacing: 1)),
              const SizedBox(height: 8),
              const Text('Modify local storage architecture instantly.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              
              const Text('Edit Net Worth (\$)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0A0E17),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    totalBalance = double.tryParse(balanceController.text) ?? totalBalance;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Framework Changes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    transactionHistory.insert(0, {
                      "type": "Received",
                      "code": "BTC",
                      "amount": "1.50 BTC",
                      "date": "Just Now",
                      "isInbound": true
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Inject Mock Transaction Log', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 35),
            ],
          ),
        );
      },
    );
  }
}

// 5. TRANSACTION HISTORY SCREEN
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ledger History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 5),
              const Text('Local system transactions', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 25),
              
              Expanded(
                child: transactionHistory.isEmpty
                    ? const Center(child: Text('No transaction logs verified.', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: transactionHistory.length,
                        itemBuilder: (context, index) {
                          final tx = transactionHistory[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: const Color(0xFF131A26), borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF0A0E17),
                                      child: Icon(
                                        tx['isInbound'] ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                        color: tx['isInbound'] ? Colors.greenAccent : Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${tx['type']} ${tx['code']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text(tx['date'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '${tx['isInbound'] ? '+' : '-'}${tx['amount']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: tx['isInbound'] ? Colors.greenAccent : Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
