
import 'package:mws_flutter_core/mws_flutter_core.dart';
import 'package:unit_convertor/config/enums.dart';
import 'package:unit_convertor/model/unit_entity.dart';
import 'package:unit_convertor/screen/widgets/enum_drop_down.dart';
import 'package:unit_convertor/services/unit_service.dart';
class UnitConversionScreen extends StatefulWidget {
  const UnitConversionScreen({super.key});

  @override
  State<UnitConversionScreen> createState() => _UnitConversionScreenState();
}

class _UnitConversionScreenState extends State<UnitConversionScreen> {
  final ValueNotifier<ChooseUnitsModel> _unitsNotifier =
      ValueNotifier<ChooseUnitsModel>(ChooseUnitsModel());

  final ValueNotifier<String> _resultNotifier =
      ValueNotifier<String>('Nothing');

  int fromUnit = 0;
  int toUnit = 0;

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _baseURlController = TextEditingController(text: 'http://192.168.2.13:7503');
  final TextEditingController _precisionController = TextEditingController();

  final UnitService _unitService = UnitService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.purple,
        title: Text('🧠 Smarty Converter', style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.grey)
            ),
            onPressed: () async{
              if(_valueController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    width: 500,
                    content: Row(
                      children: [
                        const Text("😜 ",style: TextStyle(fontSize: 30),),
                        Expanded(
                          child: Text("Hey! I can’t read your mind… type something!",style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.deepPurple,
                    behavior: SnackBarBehavior.floating,

                    duration: const Duration(seconds: 5),
                  ),
                );
                return;
              }
              UnitEntity unitEntity = UnitEntity()
                ..category = _unitsNotifier.value.unitCategory.index
                ..value = num.tryParse(_valueController.text)
                ..precision= num.tryParse(_precisionController.text)??0
                ..fromUnit = fromUnit
                ..toUnit = toUnit;
              final data = await  _unitService.postUnitData(_baseURlController.text,unitEntity);
              _resultNotifier.value = data['result'].toString();
            },
            child: Text("🎲 Roll It",style: TextStyle(fontSize: 18),),
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ValueListenableBuilder(
            valueListenable: _unitsNotifier,
            builder: (context, units, child) {
              return Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  PhoneField(),

                  Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: TextFormField(
                      controller: _baseURlController,
                      inputFormatters: [
                        // FilteringTextInputFormatter.allow(RegExp('[.0-9]')),
                      ],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        label: Text("BASE URL"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  EnumDropdown<UnitCategory>(
                    items: UnitCategory.values,
                    selectedItem: units.unitCategory,
                    onChanged: _onUnitCategoryChanged,
                    itemLabelBuilder: (UnitCategory item) => item.name,
                    headerLabelBuilder: (UnitCategory item) => item.name,
                    hintText: 'UNIT CATEGORY',
                  ),

                  Row(
                    spacing: 10,
                    mainAxisSize: .min,
                    children: [
                      Flexible(
                        child: EnumDropdown(
                          items:
                              units.unitCategory == UnitCategory.FLOW_QUANTITY
                              ? FlowUnit.values
                              : units.unitCategory == UnitCategory.CHLORINE
                              ? ChlorineUnit.values
                              : units.unitCategory == UnitCategory.PRESSURE
                              ? PressureUnit.values
                              : units.unitCategory == UnitCategory.FLOW_RATE
                              ? FlowRateUnit.values
                              : UnitCategory.values,
                          selectedItem: units.fromUnit,
                          onChanged: (enums) {
                            fromUnit = enums?.index ?? 0;
                          },
                          itemLabelBuilder: (item) => item.name,
                          headerLabelBuilder: (item) => item.name,
                          hintText: 'FROM',
                        ),
                      ),
                      Flexible(
                        child: EnumDropdown(
                          items: units.unitCategory == .FLOW_QUANTITY
                              ? FlowUnit.values
                              : units.unitCategory == .CHLORINE
                              ? ChlorineUnit.values
                              : units.unitCategory == .PRESSURE
                              ? PressureUnit.values
                              : units.unitCategory == .FLOW_RATE
                              ? FlowRateUnit.values
                              : UnitCategory.values,
                          selectedItem: units.toUnit,
                          onChanged: (enums) {
                            toUnit = enums?.index ?? 0;
                          },
                          itemLabelBuilder: (item) => item.name,
                          headerLabelBuilder: (item) => item.name,
                          hintText: 'TO',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: .min,
                    spacing: 10,
                    children: [
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: TextFormField(
                            controller: _valueController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[.0-9]')),
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              label: Text("ENTER"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: TextFormField(
                            controller: _precisionController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              label: Text("Precision"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ValueListenableBuilder(
                    valueListenable: _resultNotifier,
                    builder: (context, value, child) {
                      return Text("🎲 Dice Says ⬇️\n$value",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,);
                    }
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onUnitCategoryChanged(UnitCategory? p1) {
    if (p1 != null) {
      ChooseUnitsModel data = _unitsNotifier.value.copyWith(
        unitCategory: p1,
        fromUnit: null,
        toUnit: null,
      );
      _unitsNotifier.value = data;
    }
  }
}

/// Model class to hold selected units for various measurements.
///
/// Provides default values for each unit type and a convenient
/// [copyWith] method to create updated instances.
class ChooseUnitsModel {
  /// Creates a [ChooseUnitsModel] with optional overrides.
  ///
  /// Defaults:
  /// - [unitCategory] → [UnitCategory.liters]
  /// - [flowUnit] → [FlowUnit.lpm]
  /// - [flowRateUnit] → [FlowRateUnit.pulse]
  /// - [pressureUnit] → [PressureUnit.bar]
  /// - [levelUnit] → [LevelUnit.meter]
  /// - [chlorineQuantityUnit] → [ChlorineQuantityUnit.ppm]
  /// - [chlorineOutputUnit] → [ChlorineOutputUnit.mA420]
  ChooseUnitsModel({
    this.unitCategory = UnitCategory.PRESSURE,
    this.fromUnit,
    this.toUnit,
  });

  /// Unit used for measuring flow quantity.
  UnitCategory unitCategory;

  /// Unit used for measuring flow rate.
  Enum? fromUnit;

  /// Unit used for representing flow output.
  Enum? toUnit;

  /// Creates a copy of this [ChooseUnitsModel] with updated values.
  ///
  /// If a parameter is not provided, the current value is retained.
  ChooseUnitsModel copyWith({
    UnitCategory? unitCategory,
    Enum? fromUnit,
    Enum? toUnit,
  }) => ChooseUnitsModel(
    unitCategory: unitCategory ?? this.unitCategory,
    fromUnit: fromUnit ?? this.fromUnit,
    toUnit: toUnit ?? this.toUnit,
  );
}
