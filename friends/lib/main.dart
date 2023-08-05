import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
List<List<int>> favorites = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void toggleChinese(){
    setState(() {
      showChinese = !showChinese;
    });
  }

  void darkMode(){
    setState(() {
      darkTheme = !darkTheme;
    });
  }
  

  void addToFavorites(int indexSeason, int indexEpisode, int indexLine) {
    setState(() {
      favorites.add([indexSeason, indexEpisode, indexLine]);
    });
  }

  void removeFavorites(int indexSeason, int indexEpisode, int indexLine) {
    setState(() {
      favorites.remove([indexSeason, indexEpisode, indexLine]);
    });
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
            int indexSeason = favorites[index][0];
            int indexEpisode = favorites[index][1];
            int indexLine = favorites[index][2];
            return ListTileWithFavorite(title: cc[indexSeason][episode+1]![indexLine][1], subtitle: cc[indexSeason][indexEpisode+1]![indexLine][0], color: Colors.amber, addToFavorites: addToFavorites, removeFavorites: removeFavorites, isFavorite: true, seasonIndex: season, episodeIndex: episode, index: indexLine);
          })
      );
    }
    );
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
                  child: ListView.builder(
                    itemCount: cc[index].length, // Number of vertical items
                    itemBuilder: (BuildContext context, int subIndex) {
                      return ListTile(
                        title: Text('Episode ${subIndex+1}', style: GoogleFonts.lobster(),), // Vertical item label
                        onTap: (){setState(() {
                          season = index;
                          episode = subIndex;
                        });},
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
                    isFavorite: favorites.contains([season, episode, index]),
          )

                );
        }),
        floatingActionButton: FloatingActionButton(
                onPressed: () {showFavorite(context);},
                tooltip: 'My favorite',
                child: const Icon(Icons.favorite),
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
          },
          showChapters: showAll,
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
                  });},

        ),
      ),
    );
  }
}

class ListTileWithFavorite extends StatefulWidget {
  final Widget title;
  final Text subtitle;
  final Color color;
  final Function(int, int, int) addToFavorites;
  final Function(int, int, int) removeFavorites;
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
      widget.addToFavorites(widget.seasonIndex, widget.episodeIndex, widget.index);
    } else {
      widget.removeFavorites(widget.seasonIndex, widget.episodeIndex, widget.index);
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

  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Function lastChapter;
  final Function showChapters;
  final Function nextChapters;


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
          ],
        ),
    );
  }
}
