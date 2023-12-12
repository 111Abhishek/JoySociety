import 'package:flutter/cupertino.dart';
import 'package:joy_society/view/screen/profile/profile_settings_screen.dart';

import '../../../../localization/language_constants.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class PersonalLinkFields extends StatefulWidget {
  final int index;

  const PersonalLinkFields({super.key, required this.index});

  @override
  State<PersonalLinkFields> createState() => _PersonalLinkFieldsState();
}

class _PersonalLinkFieldsState extends State<PersonalLinkFields> {
  TextEditingController _personalLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _personalLinkController = TextEditingController();
  }

  @override
  void dispose() {
    _personalLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _personalLinkController.text =
          ProfileSettingsScreenState.personalLinksList[widget.index] ?? '';
    });

    return CustomTextField(
      textInputType: TextInputType.text,
      hintText: getTranslated('hint_add_a_personal_link', context),
      controller: _personalLinkController,
      onChanged: (v) => ProfileSettingsScreenState.personalLinksList[widget.index] = v,
      textInputAction: TextInputAction.next,
    );
  }
}
