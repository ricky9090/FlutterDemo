import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());  // 单行函数可使用 => 符号

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        home: new RandomWords(),
    );
  }
}

// 通用的展示列表页面
class CommonListPage extends StatefulWidget {

  final List<WordPair> dataList;
  final String title;
  CommonListPage(this.dataList, this.title);

  @override
  CommonListState createState() {
    return new CommonWordListState(dataList, title);
  }
}

abstract class CommonListState<T> extends State<CommonListPage> {

  List<T> _dataList;
  String _title;

  CommonListState(this._dataList, this._title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: _buildCommonList(),
    );
  }

  Widget _buildCommonList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {
        return _buildRowNormal(_dataList[i]);
      },
      itemCount: _dataList.length,
    );
  }

  Widget _buildRowNormal(T t);
}

class CommonWordListState extends CommonListState<WordPair> {

  final TextStyle _textStyle = new TextStyle(fontSize: 16.0);

  CommonWordListState(List<WordPair> _dataList, String _title) : super(_dataList, _title);

  @override
  _buildRowNormal(WordPair t) {
    return new ListTile(
        title: new Text(
          t.asPascalCase,
          style: _textStyle,
        ),
    );
  }
}


// 教程中的随机生成字符列表
class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() {
    return new RandomWordState();
  }
}

class RandomWordState extends State<RandomWords> {

  final List<WordPair> _wordList = <WordPair>[];
  final Set<WordPair> _favouriteList = new Set<WordPair>();
  final TextStyle _textStyle = new TextStyle(fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ListView Demo"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildWordList(),
    );
  }

  Widget _buildWordList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {
        // 简化代码，去掉了Demo中添加分割线的逻辑
        /*if (i.isOdd) {
          return new Divider();
        }
        final int index = i ~/ 2;*/
        if (i >= _wordList.length) {
          _wordList.addAll(generateWordPairs().take(10));
        }
        return _buildWordRowWithFavouriteButton(_wordList[i]);
      },
    );
  }

  Widget _buildWordRowWithFavouriteButton(WordPair pair) {
    bool isFavourite = _favouriteList.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _textStyle,
      ),
      trailing: new Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isFavourite) {
            _favouriteList.remove(pair);
          } else {
            _favouriteList.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new CommonListPage(_favouriteList.toList(growable: false), "Your Favourite");
        },
      ),
    );

  }
}
