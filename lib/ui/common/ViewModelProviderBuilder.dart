import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/ErrorRetry.dart';
import 'package:farmsmart_flutter/ui/common/RefreshableViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'LoadableViewModel.dart';

class _LocalisedStrings {
  static String loadingError() => Intl.message('Oops, there was a problem!');

  static String retryAction() => Intl.message('Retry');
}

typedef WidgetBuilder<T> = Widget Function(
    {required BuildContext context, required AsyncSnapshot<T> snapshot});

class ViewModelProviderBuilder<T> extends StatelessWidget {
  final ViewModelProvider<T> _provider;
  final WidgetBuilder<T> _successBuilder;
  final WidgetBuilder<T>? _errorBuilder;
  final WidgetBuilder<T>? _loadingBuilder;

  const ViewModelProviderBuilder({
    Key? key,
    required ViewModelProvider<T> provider,
    required WidgetBuilder<T> successBuilder,
    WidgetBuilder<T>? errorBuilder,
    WidgetBuilder<T>? loadingBuilder,
  })  : this._provider = provider,
        this._successBuilder = successBuilder,
        this._errorBuilder = errorBuilder,
        this._loadingBuilder = loadingBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorBuilder = _errorBuilder ?? _defaultErrorBuilder;
    final loadingBuilder = _loadingBuilder ?? _defaultLoadingBuilder;

    return StreamBuilder<T>(
        stream: _provider.stream(),
        initialData: _provider.initial(),
        builder: (
          BuildContext context,
          AsyncSnapshot<T> snapshot,
        ) {
          LoadingStatus status = (snapshot.error != null)
              ? LoadingStatus.ERROR
              : LoadingStatus.SUCCESS;
          final loadable = snapshot.data is LoadableViewModel
              ? snapshot.data as LoadableViewModel
              : null;
          status = loadable?.loadingStatus ?? status;
          switch (status) {
            case LoadingStatus.ERROR:
              return errorBuilder(context: context, snapshot: snapshot);
            case LoadingStatus.LOADING:
              return loadingBuilder(context: context, snapshot: snapshot);
            default:
              return _successBuilder(context: context, snapshot: snapshot);
          }
        });
  }

  Widget _defaultLoadingBuilder(
      {required BuildContext context, required AsyncSnapshot<T> snapshot}) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _defaultErrorBuilder(
      {required BuildContext context, required AsyncSnapshot<T> snapshot}) {
    final refreshable = snapshot.data is RefreshableViewModel
        ? snapshot.data as RefreshableViewModel
        : null;
    final VoidCallback refreshFunction = () {
      if (refreshable != null) {
        refreshable.refresh();
      }
    };
    return ErrorRetry(
      errorMessage: _LocalisedStrings.loadingError(),
      retryActionLabel: _LocalisedStrings.retryAction(),
      retryFunction: refreshFunction,
    );
  }
}
