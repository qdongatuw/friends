import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  int season = 0;
  int episode = 0;
List<List<List<int>>> favorites = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i=0; i<cc.length; i++){
      favorites.add([]);
      for (int j=0; j<cc[i].length; j++){
        favorites[i].add([]);
      }
    }
  }
  

  void addToFavorites(int indexSeason, int indexEpisode, int indexLine) {
    setState(() {
      favorites[indexSeason][indexEpisode].add(indexLine);
    });
  }

  void removeFavorites(int indexSeason, int indexEpisode, int indexLine) {
    setState(() {
      favorites[indexSeason][indexEpisode].removeAt(indexLine);
    });
  }

  // void showAll(BuildContext context){
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: cc.length,
  //             padding: EdgeInsets.all(10),
              
  //             itemBuilder: (context, index){
  //               return Column(
  //                 children: [
  //                   Image.asset('lib/assets/1.jpg'),
  //                   Center(child: Text('test')),
  //                   // ListView.builder( 
  //                   //     itemCount:cc[index].length, 
  //                   //     itemBuilder: (context1, indexEpisode){
  //                   //     return Text('Episode ${indexEpisode+1}');
  //                   //   }),
                    
                    
  //                 ],
  //               );
  //             })
  //       );
  //     });
  // }

  void showAll(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 600, // 设置底部弹出面板的高度
        child:
        Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cc.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Container(
              width: 150, // 设置列表项的宽度
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('lib/assets/1.jpg'),
                  SizedBox(height: 8),
                  Text('test')
                ],
              ),
            );
          },
        ),)
         
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        // textTheme: GoogleFonts.notoSerifTextTheme(), 
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Season ${season+1} - Episode ${episode+1}', style: GoogleFonts.lobster(),),),
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
                    
                    subtitle: Text(cc[season][episode+1]?[index][0], style: GoogleFonts.lobster(),),
                    index: index,
                    seasonIndex: season,
                    episodeIndex: episode,
                    addToFavorites: addToFavorites,
                    removeFavorites: removeFavorites,
                    isFavorite: favorites[season][episode].contains(index),
          )

                );
        }),
        floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
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
                },
                tooltip: 'Nest episode',
                child: const Icon(Icons.forward),
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
        ),
      ),
    );
  }
}

class ListTileWithFavorite extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
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
      subtitle: widget.subtitle,
      //tileColor: widget.color,
      trailing: IconButton(
        icon: _isFavorite ? const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite_border),
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
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final Function lastChapter;
  final Function showChapters;

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
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                lastChapter();
              },
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
    );
  }
}
