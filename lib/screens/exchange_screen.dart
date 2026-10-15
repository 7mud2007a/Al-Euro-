import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_localizations.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/common_header.dart';

class ExchangeScreen extends StatefulWidget {
  final SparePart? prefilledPart;
  const ExchangeScreen({super.key, this.prefilledPart});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  String _selectedCarBrand = 'Mercedes-Benz';
  String _selectedBranchKey = 'branch_main';
  bool _hasUploadedPhoto = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.prefilledPart != null) {
      _notesCtrl.text = 'OEM: ${widget.prefilledPart!.oemNumber}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AlEuroAppBar(
        title: context.tr('exchange_title'),
        showBack: widget.prefilledPart != null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.tr('exchange_subtitle'), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),

          // 1. إرفاق صورة القطعة القديمة
          InkWell(
            onTap: () => setState(() => _hasUploadedPhoto = true),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 135,
              decoration: BoxDecoration(
                color: AlEuroColors.black,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hasUploadedPhoto ? AlEuroColors.burgundy : AlEuroColors.darkGray,
                  width: 1.4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _hasUploadedPhoto ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                    size: 38,
                    color: _hasUploadedPhoto ? AlEuroColors.burgundy : AlEuroColors.warmGray,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasUploadedPhoto ? context.tr('photo_uploaded') : context.tr('upload_old_part'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. اختيار ماركة وموديل السيارة
          Text(context.tr('car_brand'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCarBrand,
            items: MockData.carHierarchy.keys
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCarBrand = val);
            },
          ),
          const SizedBox(height: 16),

          // 3. ملاحظات القطعة القديمة أو رقم OEM
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: context.tr('part_notes'),
            ),
          ),
          const SizedBox(height: 16),

          // 4. اختيار الفرع وموعد الفحص
          Text(context.tr('select_branch'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedBranchKey,
            items: [
              DropdownMenuItem(value: 'branch_main', child: Text(context.tr('branch_main'))),
              DropdownMenuItem(value: 'branch_north', child: Text(context.tr('branch_north'))),
              DropdownMenuItem(value: 'branch_west', child: Text(context.tr('branch_west'))),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedBranchKey = val);
            },
          ),
          const SizedBox(height: 16),

          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AlEuroColors.darkGray),
            ),
            tileColor: AlEuroColors.black,
            leading: const Icon(Icons.calendar_month_outlined, color: AlEuroColors.ivory),
            title: Text(context.tr('appointment_date')),
            subtitle: Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day} • 04:30 PM'),
            trailing: const Icon(Icons.edit_calendar_outlined, color: AlEuroColors.warmGray),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AlEuroColors.burgundy,
                  content: Text(context.tr('exchange_success')),
                ),
              );
            },
            icon: const Icon(Icons.verified_outlined),
            label: Text(context.tr('submit_exchange')),
          ),
        ],
      ),
    );
  }
}
