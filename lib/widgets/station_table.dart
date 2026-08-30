// lib/widgets/train_table.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class StationTable extends StatelessWidget {
  final List<Map<String, dynamic>> stations;
  final Function(String id, String newName)? onEditStation;
  final Function(String id)? onDeleteStation;
  final Function(int oldIndex, int newIndex)? onReorderStations;
  const StationTable(
      {super.key,
      required this.stations,
      this.onEditStation,
      this.onDeleteStation,
      this.onReorderStations});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: [
        _buildHeader(),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stations.length,
          onReorder: (int oldIndex, int newIndex) {
            if (onReorderStations != null) {
              onReorderStations!(oldIndex, newIndex);
            }
          },
          itemBuilder: (context, index) {
            final station = stations[index];
            return _buildRow(context, station, index, ValueKey(station['id']));
          },
          buildDefaultDragHandles: false,
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [_hCell('Station Name', flex: 2)]),
    );
  }

  Widget _hCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Text(text.toUpperCase(),
            style: GoogleFonts.barlow(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
                letterSpacing: 0.7)),
      ),
    );
  }

  Widget _buildRow(
      BuildContext context, Map<String, dynamic> station, int index, Key key) {
    bool isHovered = false;
    return StatefulBuilder(
        key: key,
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Container(
              color: isHovered
                  ? AppColors.surface2.withValues(alpha: 0.7)
                  : index.isEven
                      ? AppColors.surface
                      : AppColors.surface2,
              child: Row(children: [
                MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.drag_indicator),
                    ),
                  ),
                ),
                Expanded(
                  child: _cell(
                    Text(
                      station["name"],
                      style: GoogleFonts.dmMono(
                          fontSize: 12, color: AppColors.muted),
                    ),
                  ),
                ),
                SizedBox(
                    width: 48,
                    child: isHovered
                        ? IconButton(
                            icon: const Icon(Icons.edit,
                                size: 16, color: AppColors.accent),
                            onPressed: () => _showEditDialog(context, station),
                            tooltip: 'Edit Station',
                            style: IconButton.styleFrom(
                                minimumSize: const Size(24, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))))
                        : const SizedBox.shrink()),
                SizedBox(
                    width: 48,
                    child: isHovered
                        ? IconButton(
                            icon: const Icon(Icons.delete,
                                size: 16, color: AppColors.critical),
                            onPressed: () =>
                                _showDeleteDialog(context, station),
                            tooltip: 'Delete Station',
                            style: IconButton.styleFrom(
                                minimumSize: const Size(24, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))))
                        : const SizedBox.shrink()),
                const SizedBox(width: 4)
              ]),
            ),
          );
        });
  }

  Widget _cell(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: child);

  void _showEditDialog(BuildContext context, Map<String, dynamic> station) {
    final controller = TextEditingController(text: station["name"]);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Edit Station',
            style: GoogleFonts.barlow(
                fontWeight: FontWeight.w600, color: AppColors.textMain)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
              labelText: 'Station Name', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel',
                style: GoogleFonts.barlow(
                    color: AppColors.muted, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              elevation: 0,
            ),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && onEditStation != null) {
                onEditStation!(station["id"], newName);
              }
              Navigator.pop(dialogContext);
            },
            child: Text('Save',
                style: GoogleFonts.barlow(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> station) {
    final String name = station['name'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete $name?',
            style: GoogleFonts.barlow(
                fontWeight: FontWeight.w600, color: AppColors.textMain)),
        content: Text(
          'Deleting $name station will also delete any references to it in the distance table',
          style: GoogleFonts.barlow(
              fontSize: 14, color: AppColors.textMain, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel',
                style: GoogleFonts.barlow(
                    color: AppColors.muted, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.critical,
              elevation: 0,
            ),
            onPressed: () async {
              onDeleteStation!(station['id']);
              Navigator.pop(dialogContext);
            },
            child: Text('Delete Station',
                style: GoogleFonts.barlow(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
