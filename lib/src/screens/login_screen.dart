import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/src/base/base_page.dart';
import 'package:sample/src/blocs/login_bloc.dart';
import 'package:sample/src/util/app_colors.dart';
import 'package:sample/src/util/app_enums.dart';
import 'package:sample/src/util/app_navigation.dart';
import 'package:sample/src/util/app_routes.dart';
import 'package:sample/src/util/app_sizes.dart';
import 'package:sample/src/util/input_validator.dart';
import 'package:sample/src/widgets/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdTextField = TextEditingController(
    text: "alhamood@gmail.com",
  );

  final TextEditingController pwdTextField = TextEditingController(
    text: "AwFuel123456",
  );

  final FocusNode _userIdFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();

  @override
  void initState() {
    _userIdpwdValidation(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: _getBody(context),

      padding: EdgeInsets.only(
        left: AppWidgetSizes.dimen_20,
        right: AppWidgetSizes.dimen_20,
        top: AppWidgetSizes.dimen_20,
      ),
      menuRequired: false,
      appBarType: AppBarType.empty,
      preferredHeight: AppWidgetSizes.dimen_60,
    );
  }

  _getBody(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: Appcolors.textDarkBlueColor,
                    ),
                  ),
                  AppWidgetSizes.verticalSpace10,
                  Text(
                    'Please login to your account',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: Appcolors.textDarkBlueColor,
                    ),
                  ),
                ],
              ),
            ),
            AppWidgetSizes.verticalSpace150,
            Column(
              children: [
                Container(
                  height: AppWidgetSizes.dimen_50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Appcolors.textWhiteColor(context),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.textColor(context).withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0.0, 0.75),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppWidgetSizes.dimen_16,
                      right: AppWidgetSizes.dimen_16,
                    ),
                    child: SizedBox(
                      width:
                          AppWidgetSizes.screenWidth(context) -
                          AppWidgetSizes.dimen_16,
                      height: AppWidgetSizes.dimen_60,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.mail_outline_outlined),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _userIdFocusNode,
                              inputFormatters: InputValidator.userIdValidator(),
                              cursorColor: Appcolors.blackColor,
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: userIdTextField,
                              onChanged: (val) {
                                _userIdpwdValidation(context: context);
                              },
                              decoration: InputDecoration(
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Appcolors.textLightGrayColor(context),
                                  fontSize: AppWidgetSizes.fontSize14,
                                ),
                                border: InputBorder.none,
                                labelText: 'Username',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppWidgetSizes.verticalSpace20,
                Container(
                  height: AppWidgetSizes.dimen_50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Appcolors.textWhiteColor(context),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.textColor(context).withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0.0, 0.75),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppWidgetSizes.dimen_16,
                      right: AppWidgetSizes.dimen_16,
                    ),
                    child: SizedBox(
                      width:
                          AppWidgetSizes.screenWidth(context) -
                          AppWidgetSizes.dimen_16,
                      height: AppWidgetSizes.dimen_60,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.key_sharp),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _pwdFocusNode,
                              onChanged: (val) {
                                _userIdpwdValidation(context: context);
                              },
                              inputFormatters:
                                  InputValidator.passwordValidator(),
                              cursorColor: Appcolors.blackColor,
                              controller: pwdTextField,
                              style: Theme.of(context).textTheme.bodyMedium,
                              obscureText: state.obsecureEnabled,
                              maxLength: 15,
                              decoration: InputDecoration(
                                labelStyle: Theme.of(
                                  context,
                                ).textTheme.titleSmall!.copyWith(
                                  color: Appcolors.textLightGrayColor(context),
                                  fontSize: AppWidgetSizes.fontSize14,
                                ),
                                labelText: 'Password',
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppWidgetSizes.verticalSpace28,
            _loginButtonWidget(context: context),
            AppWidgetSizes.verticalSpace50,
          ],
        );
      },
    );
  }

  _userIdpwdValidation({required BuildContext context}) {
    if (pwdTextField.text.length > 5 && userIdTextField.text.length > 7) {
      context.read<LoginBloc>().add(ButtonEnableEvent(buttonEnabled: true));
    } else {
      context.read<LoginBloc>().add(ButtonEnableEvent(buttonEnabled: false));
    }
  }

  _loginButtonWidget({required BuildContext context}) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (context, state) {
        return state is ButtonEnableState;
      },
      builder: (context, state) {
        return (state.buttonEnabled)
            ? ButtonWidget(
              text: "Sign in",
              buttonState: ElevatedButtonState.active,
              onPressed: () {
                NavigationService().pushNavigation(Screenroutes.dashboard);
                // context.read<LoginBloc>().add(GetSecretKey(
                //     userId: userIdTextField.text, pwd: pwdTextField.text));
              },
            )
            : ButtonWidget(
              text: 'Sign in',
              buttonState: ElevatedButtonState.disable,
              onPressed: () {},
            );
      },
    );
  }
}
