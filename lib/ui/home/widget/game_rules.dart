import 'package:flutter/material.dart';

class GameRulesWidget extends StatefulWidget {
  const new({super.key});

  @override
  State<GameRulesWidget> createState() => _GameRulesWidgetState();
}

class _GameRulesWidgetState extends State<GameRulesWidget> {
  late final PageController _pageViewController;
  late final int pageCount = 7;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (page == 0) {
      return;
    }
    page--;
    _pageViewController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void _nextPage() {
    if (page + 1 >= pageCount) {
      return;
    }
    page++;
    _pageViewController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentGeometry.centerRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
        ),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: page > 0,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: _previousPage,
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            Text('Game Rules', style: TextTheme.of(context).headlineSmall),
            Visibility(
              visible: page + 1 < pageCount,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: _nextPage,
                icon: Icon(Icons.arrow_forward_ios_sharp),
              ),
            ),
          ],
        ),
        const Divider(thickness: 2),
        Expanded(
          child: PageView(
            controller: _pageViewController,
            onPageChanged: (i) {
              page = i;
              setState(() {});
            },
            children: const [
              QwixxRulesPage(
                title: 'The Goal',
                description:
                    'Cross out as many numbers as possible in the four colored rows. '
                    'The more numbers you cross out, the more points you score.',
                image: 'assets/image/board.png',
              ),
              QwixxRulesPage(
                title: 'White dice',
                description:
                    'The active player rolls all six dice. The two white dice are '
                    'used by everyone. Add them together and mark that number in any row.',
                image: 'assets/image/white_dice.png',
              ),
              QwixxRulesPage(
                title: 'Colored dice',
                description:
                    'The active player may also combine one white die with one colored die. '
                    'Only the matching colored row can be marked.',
                image: 'assets/image/colored_dice.png',
              ),
              QwixxRulesPage(
                title: 'Mark Numbers',
                description:
                    'Numbers must always be crossed out from left to right. '
                    'Once you pass a number, you can never mark it later.',
                image: 'assets/image/board_markable.png',
              ),
              QwixxRulesPage(
                title: 'Lock a Row',
                description:
                    'To lock a color, you must have crossed out at least five numbers '
                    'in that row. Then the final number can be marked and the row is closed for everyone.',
                image: 'assets/image/complete_row.png',
              ),
              QwixxRulesPage(
                title: 'Misses',
                description:
                    'If the active player cannot or does not want to make a valid move, '
                    'they must take a miss. Each miss costs 5 points.',
                image: 'assets/image/misses.png',
              ),
              QwixxRulesPage(
                title: 'Game End',
                description:
                    'The game ends when two rows are locked or a player has four misses. '
                    'The player with the highest score wins.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QwixxRulesPage extends StatelessWidget {
  final String title;
  final String description;
  final String? image;

  const QwixxRulesPage({
    super.key,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          if (image != null) ...[
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(image!, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 28),
          ],
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
