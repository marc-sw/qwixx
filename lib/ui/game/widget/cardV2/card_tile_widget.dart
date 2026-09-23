import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';

class CardTileWidget extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final CardTileViewModel viewModel;

  Widget _buildDecoration(BuildContext context, TileDecoration decoration) {
    return switch (decoration) {
      TileDecoration.none => SizedBox.shrink(),
      TileDecoration.marked => Transform.scale(
        scale: 3,
        child: Icon(Icons.close),
      ),
      TileDecoration.skipped => Transform.scale(
        scale: 3.45,
        child: Icon(Icons.remove),
      ),
      TileDecoration.markable => GestureDetector(
        onTap: () => viewModel.onTap(viewModel.tile),
        child: Container(color: Colors.green.withAlpha(150))
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
              delay: const Duration(milliseconds: 3000),
            )
            .fade(duration: const Duration(milliseconds: 1250)),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(5),
        border: BoxBorder.all(color: Colors.grey),
      ),
      child: Center(
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Text(
              viewModel.tile.number.toString(),
              style: GoogleFonts.alfaSlabOne(
                fontSize: 34,
                color: viewModel.color,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: viewModel.decorationListenable,
              builder: (context, value, child) =>
                  _buildDecoration(context, value),
            ),
          ],
        ),
      ),
    );
  }
}
