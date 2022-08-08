library aurum_country_code_picker;

import 'package:aurum_country_code_picker/src/au_bouncer.dart';
import 'package:aurum_country_code_picker/src/code_service.dart';
import 'package:aurum_country_code_picker/src/common_codes.dart';
import 'package:aurum_country_code_picker/src/country_code.dart';
import 'package:aurum_country_code_picker/src/dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

Future<CountryCode?> pickCountryCode(BuildContext context) async {
  CountryCode? result;

  await showDialog(
      context: context,
      builder: (_) => AuDialog(
          child: _CountryCodePicker(),
          height: AurumDialogSize.large)).then((value) {
    result = value;
  });

  return result;
}

class _CountryCodePicker extends StatefulWidget {
  const _CountryCodePicker({Key? key}) : super(key: key);

  @override
  State<_CountryCodePicker> createState() => __CountryCodePickerState();
}

class __CountryCodePickerState extends State<_CountryCodePicker> {
  TextEditingController controller = TextEditingController();

  Map<String, String> codes = {};
  Map<String, String> searchResult = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    listen();
    Future.delayed(Duration.zero, () {
      load();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listen() {
    controller.addListener(() {
      if (controller.text.length == 0) {
        setState(() {
          searchResult = {};
        });
      } else {
        searchFunc(controller.text);
      }
    });
  }

  void load() async {
    final _codes = await CountryCodesService.loadCodes();
    setState(() {
      codes = _codes;
      loading = false;
    });
  }

  void searchFunc(String input) {
    final result =
        CountryCodesService.search(controller.text.toLowerCase(), codes: codes);
    setState(() {
      searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData t = Theme.of(context);
    ColorScheme c = t.colorScheme;

    const InputBorder b = InputBorder.none;
    InputDecoration decor = InputDecoration(
        border: b,
        errorBorder: b,
        enabledBorder: b,
        focusedBorder: b,
        disabledBorder: b,
        focusedErrorBorder: b,
        hintText: 'Search here',
        hintStyle: t.textTheme.bodyText1
            ?.copyWith(color: c.onBackground.withOpacity(0.5)));

    return ResponsiveBuilder(builder: (context, si) {
      double height = si.screenSize.height;
      double width = si.screenSize.width;
      return Scrollbar(
          radius: Radius.circular(22),
          thickness: 3,
          interactive: true,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 14),
                  Text(
                    'Select a dial code',
                    style:
                        t.textTheme.headline2?.copyWith(color: c.onBackground),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    height: 58,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: c.onBackground.withOpacity(0.05),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 22,
                            height: 36,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                                  color: c.onBackground.withOpacity(0.5),
                                  size: 14),
                            )),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: decor,
                            style: t.textTheme.bodyText1
                                ?.copyWith(color: c.onBackground),
                            cursorColor: c.primary,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Divider(color: c.onBackground.withOpacity(0.1)),
                  const SizedBox(height: 22),
                ],
              )),
              Builder(builder: (context) {
                if (searchResult.isNotEmpty) {
                  return SliverList(
                      delegate:
                          SliverChildBuilderDelegate((context, int index) {
                    final countries = searchResult.keys.toList();
                    final dialCodes = searchResult.values.toList();
                    return dialCode(height, width, dialCodes[index].toString(),
                        countries[index]);
                  }, childCount: searchResult.length));
                }

                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, int index) {
                  final countries = commonDialCodes.keys.toList();
                  final dialCodes = commonDialCodes.values.toList();
                  return dialCode(
                      height, width, dialCodes[index], countries[index]);
                }, childCount: commonDialCodes.length));
              }),
              SliverToBoxAdapter(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(color: c.onBackground.withOpacity(0.1)),
                  const SizedBox(height: 22),
                ],
              )),
              Builder(builder: (context) {
                if (searchResult.isEmpty) {
                  return SliverList(
                      delegate:
                          SliverChildBuilderDelegate((context, int index) {
                    final countries = codes.keys.toList();
                    final dialCodes = codes.values.toList();
                    return dialCode(height, width, dialCodes[index].toString(),
                        countries[index]);
                  }, childCount: codes.length));
                }

                return SliverToBoxAdapter();
              })
            ],
          ));
    });
  }

  Widget dialCode(double height, double width, String code, String country) {
    return AuBouncer(
      child: Container(
          margin: const EdgeInsets.only(bottom: 22),
          child: Text(
            '$code\t\t$country',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
          )),
      onClick: () {
        Navigator.of(context).pop(CountryCode(code: code, country: country));
      },
    );
  }
}
