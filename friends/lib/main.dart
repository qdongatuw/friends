import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'friends_cc.dart';


/// Flutter code sample for [BottomAppBar].

void main() {
  runApp(const BottomAppBarDemo());
}

class BottomAppBarDemo extends StatefulWidget {
  const BottomAppBarDemo({super.key});

  @override
  State createState() => _BottomAppBarDemoState();
}

class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  bool darkTheme = false;
  bool showChinese = true;
  int season = 0;
  int episode = 0;
  double offset = 0.0;
List<String> favorites = [];
ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAppState();
    _controller.addListener(() async{ 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('offset', _controller.offset);});
  }
  

  Future<void> _loadAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = prefs.getBool('darkTheme') ?? false;
      showChinese = prefs.getBool('showChinese') ?? true;
      season = prefs.getInt('season') ?? 0;
      episode = prefs.getInt('episode') ?? 0;
      offset = prefs.getDouble('offset') ?? 0.0;
      favorites = prefs.getStringList('favorites') ?? [];
      _controller.jumpTo(offset);
    });
  }

  Future<void> _saveAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', darkTheme);
    await prefs.setBool('showChinese', showChinese);
    await prefs.setInt('season', season);
    await prefs.setInt('episode', episode);
    await prefs.setStringList('favorites', favorites);
  }
  

  void toggleChinese(){
    setState(() {
      showChinese = !showChinese;
    });
    _saveAppState();
  }

  void darkMode(){
    setState(() {
      darkTheme = !darkTheme;
    });
    _saveAppState();
  }
  

  void addToFavorites(String? item1, String? item2) {
    setState(() {
      favorites.add('$item1|$item2');
    });
    _saveAppState();
  }

  void removeFavorites(String? item1, String? item2) {
    setState(() {
      favorites.remove('$item1|$item1');
    });
    _saveAppState();
  }



  void showFavorite(BuildContext context){
    showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 1000, // 设置底部弹出面板的高度
        child: ListView.builder(
          
          itemCount: favorites.length,
          itemBuilder: (context, index){
            var group = favorites[index].split('|');

          return  Dismissible(
          key: Key(favorites[index]), // 必须提供一个唯一的key
          direction: DismissDirection.startToEnd, // 滑动方向
          onDismissed: (direction) {
            setState(() {
              favorites.removeAt(index);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Item Removed')),
            );
            _saveAppState();
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(title: Text(group[0]),subtitle: Text(group[1]),),
        );
      },
    )

    );
    });
    }
  
  


  void showAll(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 800, // 设置底部弹出面板的高度
        child:
        // Scrollbar
        //   thumbVisibility: true,
        //   child: 
          ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cc.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Container(
              width: 150, // 设置列表项的宽度
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Stack(
                   alignment: Alignment.bottomLeft, 
                   children: [
                    Image.asset('lib/assets/1.jpg'),
                    Text('S${index+1}', style: GoogleFonts.lobster(fontSize: 36, color: Colors.amber), )
                   ],
                  ),
                  
                  SizedBox(height: 8),
                  Expanded(
                  
                  //height: 150, // Height of the vertical ListView
                  child: ListView.separated(
                    itemCount: cc[index].length, // Number of vertical items
                    separatorBuilder: (BuildContext context, int index) => Divider(
    height: 1, // 分割线高度
    color: Colors.grey, // 分割线颜色
  ),
                    itemBuilder: (BuildContext context, int subIndex) {
                      return ListTile(
                        title: Text('Episode ${subIndex+1}', style: GoogleFonts.lobster(),), // Vertical item label
                        onTap: (){setState(() {
                          season = index;
                          episode = subIndex;
                        });
                        _saveAppState();
                        },
                      );
                    },
                  ),
                ),
                ],
              ),
            );
          },
        ),
         
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: darkTheme? const ColorScheme.dark(): const ColorScheme.light(),
        // textTheme: GoogleFonts.notoSerifTextTheme(), 
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Season ${season+1} - Episode ${episode+1}', style: GoogleFonts.lobster(),),
          actions: <Widget>[
            ToggleButtons(
              renderBorder: false,
              children: <Widget>[
                Icon(showChinese? Icons.subtitles_off:Icons.subtitles, color: Colors.lightGreen,),
                Icon(darkTheme? Icons.light_mode: Icons.dark_mode,  color: Colors.lightGreen,),
              ],
              isSelected: [showChinese, darkTheme],
              onPressed: (index) {
                if(index == 0){
                  toggleChinese();
                }
                else{
                  darkMode();
                }
              },
            ),
          ],
          ),
        body: ListView.builder(
          controller: _controller,
          itemCount: cc[season][episode]?.length,
          itemBuilder: (context, index){
            return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTileWithFavorite(
                    color: Colors.amberAccent,
                    // titleTextStyle: TextStyle(fontSize: 14),
                    title: SelectableText(
            cc[season][episode+1]?[index][1],
            onTap: () {
            },
          ),
                    
                    subtitle: showChinese? Text(cc[season][episode+1]?[index][0], style: GoogleFonts.lobster(),) : const Text(''),
                    index: index,
                    seasonIndex: season,
                    episodeIndex: episode,
                    addToFavorites: addToFavorites,
                    removeFavorites: removeFavorites,
                    isFavorite: favorites.contains('${cc[season][episode+1]?[index][1]}|${cc[season][episode+1]?[index][0]}'),
          )

                );
        }),
        floatingActionButton: FloatingActionButton(
                onPressed: () {_controller.animateTo(_controller.offset+600, duration: Duration(seconds: 1), curve: Curves.easeInOut,);},
                tooltip: 'Auto',
                child: const Icon(Icons.play_arrow),
              ),

        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: _DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: const CircularNotchedRectangle(),
          lastChapter: (){
            setState(() {
              if (episode == 0&&season==0){
                return;
              }
              if (episode==0){
                season--;
                episode = cc[season].length-1;
                return;
              }
              episode--;
            });
            _saveAppState();
          },
          showChapters: showAll,
          showFavoriteItmes: showFavorite,
          nextChapters: (){setState(() {
                    if(season==cc.length-1&&episode==cc[season].length-1){
                      return;
                    }
                    if(episode < cc[season].length-1)
                      {episode++;}
                    else{
                      episode = 0;
                      season++;
                    }
                  });
                  _saveAppState();
                  },

        ),
      ),
    );
  }
}

class ListTileWithFavorite extends StatefulWidget {
  final SelectableText title;
  final Text subtitle;
  final Color color;
  final Function(String?, String?) addToFavorites;
  final Function(String?, String?) removeFavorites;
  final bool isFavorite;
  final int seasonIndex;
  final int episodeIndex;
  final int index;

  const ListTileWithFavorite({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.addToFavorites,
    required this.removeFavorites,
    required this.isFavorite,
    required this.seasonIndex,
    required this.episodeIndex,
    required this.index,
  });

  @override
  _ListTileWithFavoriteState createState() => _ListTileWithFavoriteState();
}

class _ListTileWithFavoriteState extends State<ListTileWithFavorite> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      widget.addToFavorites(widget.title.data, widget.subtitle.data);
    } else {
      widget.removeFavorites(widget.title.data, widget.subtitle.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      // shadowColor: Colors.grey,
      // color: widget.color,
      child: ListTile(
      title: widget.title,
      subtitle: widget.subtitle.data == ''? null:widget.subtitle,
      //tileColor: widget.color,
      trailing: IconButton(
        icon: _isFavorite ? const Icon(Icons.check, color: Colors.green,) : const Icon(Icons.add),
        onPressed: _toggleFavorite,
      ),
    )); 
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.lastChapter,
    required this.showChapters,
    required this.nextChapters,
    required this.showFavoriteItmes,
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Function lastChapter;
  final Function showChapters;
  final Function nextChapters;
  final Function showFavoriteItmes;


  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Select Season and episode',
              icon: const Icon(Icons.menu),
              onPressed: (){
                showChapters(context);
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Previous episode',
              icon: const Icon(Icons.skip_previous),
              onPressed: () {
                lastChapter();
              },
            ),
            IconButton(
              tooltip: 'Next episode',
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                nextChapters();
              },
            ),
            IconButton(
              tooltip: 'Next episode',
              icon: const Icon(Icons.favorite),
              onPressed: () {
                showFavoriteItmes(context);
              },
            ),
          ],
        ),
    );
  }
}
