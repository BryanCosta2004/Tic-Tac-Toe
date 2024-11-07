import 'package:flutter/material.dart';

void main() {
  runApp(const MyGamePage());
}

class MyGamePage extends StatefulWidget {
  const MyGamePage({Key? key}) : super(key: key);

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  static const int _boardSize = 3; // Tabuleiro 3x3
  List<List<String>> _board = List.generate(_boardSize, (_) => List.filled(_boardSize, ' '));
  String _currentPlayer = 'X';
  bool _gameOver = false;
  String _winner = '';

  get rowSize => null;

  // Reseta o jogo
  void _resetGame() {
    setState(() {
      _board = List.generate(_boardSize, (_) => List.filled(_boardSize, ' '));
      _currentPlayer = 'X';
      _gameOver = false;
      _winner = '';
    });
  }

  // Atualiza o estado do jogo após um movimento
  void _makeMove(int row, int col) {
    if (_board[row][col] != ' ' || _gameOver) return;

    setState(() {
      _board[row][col] = _currentPlayer;
      if (_checkWinner(row, col)) {
        _gameOver = true;
        _winner = _currentPlayer;
      } else {
        _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
      }
    });
  }

  // Verifica se um jogador venceu após um movimento
  bool _checkWinner(int row, int col) {
    // Checa linha
    if (_board[row].every((cell) => cell == _currentPlayer)) {
      return true;
    }
    // Checa coluna
    if (_board.every((row) => row[col] == _currentPlayer)) {
      return true;
    }
    // Checa diagonal principal
    if (row == col && _board.every((row) => row[row.indexOf(row as String)] == _currentPlayer)) {
      return true;
    }
    // Checa diagonal inversa
    if (row + col == _boardSize - 1 && _board.every((row) => row[rowSize - col] == _currentPlayer)) {
      return true;
    }
    return false;
  }

  // Widget para renderizar o tabuleiro
  Widget _buildBoard() {
    return Column(
      children: List.generate(_boardSize, (row) {
        return Row(
          children: List.generate(_boardSize, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _gameOver
                  ? (_winner.isEmpty ? 'Empate!' : 'Jogador $_winner venceu!')
                  : 'Jogador $_currentPlayer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildBoard(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}