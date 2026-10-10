
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const QudatAlRubApp());
}

const String ownerName = 'علاوي ال حمادي';

const Color bg = Color(0xFF151917);
const Color panel = Color(0xFF252E29);
const Color gold = Color(0xFFFFC766);
const Color wood = Color(0xFF80502F);

class QudatAlRubApp extends StatelessWidget {
  const QudatAlRubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قعدة الربع',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Animal {
  final String emoji;
  final String name;
  final String personality;

  const Animal(this.emoji, this.name, this.personality);
}

const List<Animal> animals = [
  Animal('🐂', 'الثور', 'العصبي'),
  Animal('🐒', 'القرد', 'المشاغب'),
  Animal('🫏', 'الحمار', 'المتفلسف'),
  Animal('🐄', 'البقرة', 'الهادئة'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF354B3B),
              bg,
              Color(0xFF38251A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const Icon(
                    Icons.casino,
                    size: 75,
                    color: gold,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'قعدة الربع',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'دومنة وضحك وسوالف عراقية!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 25),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: animals.map((a) {
                      return Container(
                        width: 135,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: gold.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              a.emoji,
                              style: const TextStyle(fontSize: 42),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              a.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              a.personality,
                              style: const TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GameScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'ابدأ اللعب',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'العب الدومنة واربح المراحل',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),
                  const Divider(color: Colors.white24),
                  const Text(
                    '© جميع الحقوق محفوظة',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    ownerName,
                    style: TextStyle(
                      color: gold,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Domino {
  final int a;
  final int b;

  const Domino(this.a, this.b);

  int get points => a + b;
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random random = Random();

  List<Domino> playerHand = [];
  List<Domino> botHand = [];
  List<Domino> board = [];

  int playerWins = 0;
  int botWins = 0;
  int level = 1;

  bool playerTurn = true;
  bool gameOver = false;
  bool waiting = false;

  String message = 'يلا نلعب يا ربع!';
  int selectedCharacter = 0;

  Animal get opponent => animals[selectedCharacter];

  String get characterLine {
    switch (selectedCharacter) {
      case 0:
        return 'الثور: ولك العب مضبوط، لا تعصبني!';
      case 1:
        return 'القرد: هاها، هالمرة أفوز عليكم!';
      case 2:
        return 'الحمار: آني مخطط لكل حركة!';
      default:
        return 'البقرة: يمعودين، خل نلعب بهدوء.';
    }
  }

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  List<Domino> _makeSet() {
    final List<Domino> tiles = [];

    for (int a = 0; a <= 6; a++) {
      for (int b = a; b <= 6; b++) {
        tiles.add(Domino(a, b));
      }
    }

    tiles.shuffle(random);
    return tiles;
  }

  void _newRound() {
    final tiles = _makeSet();

    playerHand = tiles.take(7).toList();
    botHand = tiles.skip(7).take(7).toList();
    board = [];

    selectedCharacter = (level - 1) % animals.length;
    playerTurn = true;
    gameOver = false;
    waiting = false;

    message = characterLine;

    if (mounted) setState(() {});
  }

  bool _canPlay(Domino tile) {
    if (board.isEmpty) return true;

    final left = board.first.a;
    final right = board.last.b;

    return tile.a == left ||
        tile.b == left ||
        tile.a == right ||
        tile.b == right;
  }

  bool get playerCanMove => playerHand.any(_canPlay);

  void _placeTile(Domino tile) {
    if (board.isEmpty) {
      board.add(tile);
      return;
    }

    final left = board.first.a;
    final right = board.last.b;

    if (tile.a == right) {
      board.add(tile);
    } else if (tile.b == right) {
      board.add(Domino(tile.b, tile.a));
    } else if (tile.b == left) {
      board.insert(0, tile);
    } else if (tile.a == left) {
      board.insert(0, Domino(tile.b, tile.a));
    }
  }

  void _playPlayer(Domino tile) {
    if (gameOver || !playerTurn || waiting) return;

    if (!_canPlay(tile)) {
      setState(() {
        message = 'هذا الحجر ما يركب، اختار حجر ثاني.';
      });
      return;
    }

    setState(() {
      _placeTile(tile);
      playerHand.remove(tile);

      if (playerHand.isEmpty) {
        _finishRound(true);
        return;
      }

      playerTurn = false;
      waiting = true;
      message = 'زين! هسه نشوف شيرد $opponent.name.';
    });

    if (gameOver) return;

    if (!botHand.any(_canPlay)) {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (!mounted || gameOver) return;

        setState(() {
          waiting = false;
          playerTurn = true;
          message = '${opponent.name}: ما عندي حجر يركب، دورك!';
        });

        _checkBlocked();
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 650), _botMove);
  }

  void _passTurn() {
    if (gameOver || !playerTurn || waiting || playerCanMove) return;

    setState(() {
      playerTurn = false;
      waiting = true;
      message = 'ما عندك حجر يركب، ننتظر الخصم.';
    });

    if (!botHand.any(_canPlay)) {
      setState(() {
        waiting = false;
        playerTurn = true;
      });
      _checkBlocked();
      return;
    }

    Future.delayed(const Duration(milliseconds: 650), _botMove);
  }

  void _botMove() {
    if (!mounted || gameOver) return;

    final playable = botHand.where(_canPlay).toList();

    if (playable.isEmpty) {
      setState(() {
        waiting = false;
        playerTurn = true;
        message = '${opponent.name}: ما عندي حجر، تفضل دورك.';
      });
      _checkBlocked();
      return;
    }

    playable.sort((a, b) => b.points.compareTo(a.points));
    final tile = playable.first;

    setState(() {
      _placeTile(tile);
      botHand.remove(tile);
      waiting = false;
      playerTurn = true;

      switch (selectedCharacter) {
        case 0:
          message = 'الثور: هااا! شفتوا الحجر شلون؟';
          break;
        case 1:
          message = 'القرد: هاهاها، حركة ذكية!';
          break;
        case 2:
          message = 'الحمار: مثل ما توقعت بالضبط!';
          break;
        default:
          message = 'البقرة: زين، هسه دورك.';
      }

      if (botHand.isEmpty) {
        _finishRound(false);
      }
    });

    if (!gameOver) _checkBlocked();
  }

  void _checkBlocked() {
    if (gameOver) return;

    if (!playerHand.any(_canPlay) &&
        !botHand.any(_canPlay)) {
      final playerPoints =
          playerHand.fold<int>(0, (sum, tile) => sum + tile.points);

      final botPoints =
          botHand.fold<int>(0, (sum, tile) => sum + tile.points);

      if (playerPoints <= botPoints) {
        _finishRound(true, blocked: true);
      } else {
        _finishRound(false, blocked: true);
      }
    }
  }

  void _finishRound(bool playerWon, {bool blocked = false}) {
    gameOver = true;
    waiting = false;

    if (playerWon) {
      playerWins++;
      message = blocked
          ? 'انسد اللعب، بس نقاطك أقل! فزت بالجولة.'
          : 'عاشت إيدك! فزت على ${opponent.name}!';
    } else {
      botWins++;
      message = blocked
          ? 'انسد اللعب ونقاط الخصم أقل. خسران هالمرة!'
          : '${opponent.name}: فزت عليك! بعدك تتعلم يمعود.';
    }

    if (mounted) setState(() {});
  }

  void _nextLevel() {
    level++;
    _newRound();
  }

  void _resetScores() {
    playerWins = 0;
    botWins = 0;
    level = 1;
    _newRound();
  }

  Widget _tileWidget(
    Domino tile, {
    bool compact = false,
    VoidCallback? onTap,
  }) {
    final width = compact ? 37.0 : 54.0;
    final height = compact ? 65.0 : 88.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1D5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD5B783),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '${tile.a}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: compact ? 19 : 25,
                  ),
                ),
              ),
            ),
            Container(height: 1.5, color: wood),
            Expanded(
              child: Center(
                child: Text(
                  '${tile.b}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: compact ? 19 : 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قعدة الربع'),
        backgroundColor: panel,
        actions: [
          IconButton(
            tooltip: 'إعادة النقاط من البداية',
            onPressed: _resetScores,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gold.withOpacity(0.35)),
              ),
              child: Row(
                children: [
                  Text(
                    opponent.emoji,
                    style: const TextStyle(fontSize: 38),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المرحلة $level • ${opponent.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إنت: $playerWins',
                    style: const TextStyle(
                      color: gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'الخصم: $botWins',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              height: 175,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF31543E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: wood, width: 5),
              ),
              child: board.isEmpty
                  ? const Center(
                      child: Text(
                        'طاولة الدومنة\nاختار أول حجر من إيدك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: board.map((tile) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: _tileWidget(
                                tile,
                                compact: true,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'أحجارك',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Text('${playerHand.length} أحجار'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 9,
                  children: playerHand.map((tile) {
                    return _tileWidget(
                      tile,
                      onTap: () => _playPlayer(tile),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (!gameOver &&
                      playerTurn &&
                      !playerCanMove)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _passTurn,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('ما عندي حجر يركب — تمرير الدور'),
                      ),
                    ),
                  if (gameOver)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _newRound,
                            child: const Text('جولة جديدة'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: _nextLevel,
                            child: const Text('المرحلة التالية'),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  const Text(
                    '© جميع الحقوق محفوظة — علاوي ال حمادي',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}