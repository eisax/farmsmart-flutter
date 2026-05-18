import 'package:farmsmart_flutter/model/analytics_interface.dart';
import 'package:farmsmart_flutter/ui/article/StandardListItem.dart';
import 'package:farmsmart_flutter/ui/article/viewModel/ArticleDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/article/viewModel/ArticleListItemViewModel.dart';
import 'package:farmsmart_flutter/ui/common/ContextualAppBar.dart';
import 'package:farmsmart_flutter/ui/common/headerAndFooterListView.dart';
import 'package:farmsmart_flutter/ui/common/image_provider_view.dart';
import 'package:farmsmart_flutter/ui/community/LinkBox.dart';
import 'package:farmsmart_flutter/ui/community/LinkBoxStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class _LocalisedStrings {
  static String shareText() =>
      Intl.message('Check out this article from the FarmSmart mobile app \n ');

  static String viewMore() => Intl.message('View more on the web');
}

class _Constants {
  static EdgeInsets externalLinkPadding = EdgeInsets.only(
    bottom: 20.0,
  );
}

class _AnalyticsNames {
  static const share = 'article_share';
  static const more = 'article_more';
}

class _Icons {
  static final defaultExternalLinkIcon = Icons.open_in_browser;
}

abstract class ArticleDetailStyle {
  final TextStyle titlePageStyle;
  final TextStyle dateStyle;
  final TextStyle bodyStyle;

  final EdgeInsets titlePagePadding;
  final EdgeInsets leftRightPadding;
  final EdgeInsets bodyPadding;

  final double spaceBetweenDataAndImage;
  final double spaceBetweenElements;
  final double imageHeight;

  final int maxLinesPerTitle;

  ArticleDetailStyle(
    this.titlePageStyle,
    this.dateStyle,
    this.bodyStyle,
    this.titlePagePadding,
    this.leftRightPadding,
    this.bodyPadding,
    this.spaceBetweenDataAndImage,
    this.spaceBetweenElements,
    this.imageHeight,
    this.maxLinesPerTitle,
  );
}

class _DefaultStyle implements ArticleDetailStyle {
  static const Color titlesColor = Color(0xFF121212);
  static const Color footColor = Color(0xFF767690);
  static const Color bodyColor = Color(0xFF4c4e6e);

  final TextStyle titlePageStyle = const TextStyle(
      fontSize: 27, fontWeight: FontWeight.bold, color: titlesColor);
  final TextStyle dateStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: footColor);
  final TextStyle bodyStyle = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.w500, color: bodyColor);

  final EdgeInsets titlePagePadding =
      const EdgeInsets.only(left: 34.0, right: 34.0, top: 15.0, bottom: 20.0);
  final EdgeInsets leftRightPadding =
      const EdgeInsets.only(left: 32.0, right: 32.0);
  final EdgeInsets bodyPadding = const EdgeInsets.only(left: 32.0, right: 32.0);

  final double spaceBetweenDataAndImage = 25;
  final double spaceBetweenElements = 41;
  final double imageHeight = 192;

  final int maxLinesPerTitle = 2;

  const _DefaultStyle();
}

class ArticleDetail extends StatefulWidget {
  static const analyticsName = 'article_detail';
  final ArticleDetailViewModel _viewModel;
  final ArticleDetailStyle _style;
  final Widget? _articleHeader;
  final Widget? _articleFooter;
  final bool _articleImageVisible;
  final bool _embedded;

  ArticleDetail({
    Key? key,
    required ArticleDetailViewModel viewModel,
    ArticleDetailStyle style = const _DefaultStyle(),
    Widget? articleHeader,
    Widget? articleFooter,
    bool shouldShowArticleImage = true,
    bool embedded = false,
  })  : this._viewModel = viewModel,
        this._style = style,
        this._articleHeader = articleHeader,
        this._articleFooter = articleFooter,
        this._articleImageVisible = shouldShowArticleImage,
        this._embedded = embedded,
        super(key: key);

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  Future<List<ArticleListItemViewModel>> fetchRelated() {
    return widget._viewModel.getRelated();
  }

  @override
  Widget build(BuildContext context) {
    final related = fetchRelated();
    AnalyticsInterface.implementation().impression(ArticleDetail.analyticsName,
        context: widget._viewModel.title);
    return FutureBuilder<List<ArticleListItemViewModel>>(
      future: related,
      builder: (BuildContext context,
          AsyncSnapshot<List<ArticleListItemViewModel>> relatedArticles) {
        final relatedItems = relatedArticles.data ?? [];
        final content = _content(relatedItems);
        if (widget._embedded) {
          return content;
        }
        return Scaffold(
          appBar: _buildAppBar(context),
          body: content,
        );
      },
    );
  }

  Widget _relatedHeader() {
    return Container(
      padding: widget._style.titlePagePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget._viewModel.relatedTitle,
              style: widget._style.titlePageStyle)
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    //TODO: LH add error popp up (when we have the widget)
  }

  Widget _externalLinkSection() {
    final linkBoxViewModel = LinkBoxViewModel(
        titleText: widget._viewModel.contentLinkTitle.isNotEmpty
            ? widget._viewModel.contentLinkTitle
            : widget._viewModel.title,
        detailText: widget._viewModel.contentLinkDescription.isNotEmpty
            ? widget._viewModel.contentLinkDescription
            : _LocalisedStrings.viewMore(),
        image: widget._viewModel.contentLinkIcon,
        icon: _Icons.defaultExternalLinkIcon,
        onTap: () {
          AnalyticsInterface.implementation().interaction(_AnalyticsNames.more,
              context: widget._viewModel.title);
          _launchURL(widget._viewModel.contentLink);
        });
    return Padding(
      padding: _Constants.externalLinkPadding,
      child: LinkBox(
        viewModel: linkBoxViewModel,
        style: LinkBoxStyles.buildWhatsAppStyle(),
      ),
    );
  }

  HeaderAndFooterListView _content(
      List<ArticleListItemViewModel> relatedItems) {
    final List<Widget> relatedTitle =
        relatedItems.isNotEmpty ? [_relatedHeader()] : [];
    final List<Widget> contentLink =
        (widget._viewModel.contentLink.trimRight().isNotEmpty)
            ? [_externalLinkSection()]
            : [];

    final List<Widget> articleHeaders = (widget._articleHeader != null)
        ? [widget._articleHeader!]
        : [_buildDefaultHeader()];
    final List<Widget> articleFooters =
        (widget._articleFooter != null) ? [widget._articleFooter!] : [];

    final headers = articleHeaders +
        [buildArticle()] +
        contentLink +
        articleFooters +
        relatedTitle;

    return HeaderAndFooterListView(
      itemCount: relatedItems.length,
      itemBuilder: (BuildContext context, int index) {
        final viewModel = relatedItems[index];
        return StandardListItem(
          viewModel: viewModel,
          onTap: () => _tappedListItem(
              context: context, viewModel: viewModel.detailViewModel),
        ).build(context);
      },
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      headers: headers,
    );
  }

  void _share(BuildContext context) async {
    final link = await widget._viewModel.shareLink;
    AnalyticsInterface.implementation()
        .interaction(_AnalyticsNames.share, context: widget._viewModel.title);
    await Share.share(_LocalisedStrings.shareText() + link);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return ContextualAppBar(
      shareAction: () => _share(context),
    );
  }

  Widget _buildDefaultHeader() {
    final List<Widget> titleSection =
        (widget._viewModel.title.isNotEmpty) ? [_buildTitle()] : [];
    final List<Widget> subtitleSection =
        (widget._viewModel.subtitle.isNotEmpty) ? [_buildSubtitle()] : [];
    final List<Widget> headerWidgets = titleSection + subtitleSection;
    return Column(
      children: headerWidgets,
    );
  }

  Widget buildArticle() {
    final Widget? image = _buildImage();
    final Widget body = _buildBody();
    final List<Widget> imageSection = image != null
        ? [
            SizedBox(height: widget._style.spaceBetweenElements),
            image,
          ]
        : [];
    final List<Widget> bodySection = [
      SizedBox(height: widget._style.spaceBetweenDataAndImage),
      body,
      SizedBox(height: widget._style.spaceBetweenElements)
    ];
    final List<Widget> articleWidgets = imageSection + bodySection;
    return Column(
      children: articleWidgets,
    );
  }

  void _tappedListItem(
      {required BuildContext context,
      required ArticleDetailViewModel viewModel}) {
    AnalyticsInterface.implementation()
        .interaction(ArticleDetail.analyticsName, context: viewModel.title);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetail(viewModel: viewModel),
        settings: const RouteSettings(name: ArticleDetail.analyticsName),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
        padding: widget._style.titlePagePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                widget._viewModel.title,
                style: widget._style.titlePageStyle,
                maxLines: widget._style.maxLinesPerTitle,
              ),
            )
          ],
        ));
  }

  Widget _buildSubtitle() {
    return Container(
        padding: widget._style.leftRightPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                widget._viewModel.subtitle,
                style: widget._style.dateStyle,
              ),
            )
          ],
        ));
  }

  Widget? _buildImage() {
    if (!widget._articleImageVisible) {
      return null;
    }
    return ImageProviderView(
        imageURLProvider: widget._viewModel.image,
        height: widget._style.imageHeight);
  }

  Widget _buildBody() {
    return Container(
      padding: widget._style.bodyPadding,
      child: Html(
        data: widget._viewModel.body,
      ),
    );
  }
}
