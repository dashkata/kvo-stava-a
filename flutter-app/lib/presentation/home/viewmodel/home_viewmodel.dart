import '../../utils/base_state_viewmodel.dart';
import 'home_action.dart';
import 'home_state.dart';

final class HomeViewModel extends BaseStateViewModel<HomeState, HomeAction> {
  HomeViewModel()
      : super(
          initialState: const HomeState(),
        );

  @override
  Future<void> submitAction(HomeAction action) async {}

  @override
  Future<void> init() async {}
}
