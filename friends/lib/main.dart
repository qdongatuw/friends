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

  int season = 1;
  int episode = 1;
  List<List> favorites = [];

  void addToFavorites(List item) {
    setState(() {
      favorites.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        
        body: ListView.builder(
          
          itemCount: s1[1]?.length,
          itemBuilder: (context, index){
            return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTileWithFavorite(
                    color: Colors.amberAccent,
                    // titleTextStyle: TextStyle(fontSize: 14),
                    title: SelectableText(
            s1[1]?[index][1],
            style: TextStyle(fontSize: 20),
            onTap: () {
            },
            
          ),
                    
                    subtitle: Text(s1[1]?[index][0]),
                    index: index,
                    seasonIndex: season,
                    episodeIndex: episode,
                    addToFavorites: addToFavorites,
                    isFavorite: favorites.contains([season, episode, index]),
          )

                );
        }),
        floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: 'Create',
                child: const Icon(Icons.add),
              ),

        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: _DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: const CircularNotchedRectangle(),
        ),
      ),
    );
  }
}

class ListTileWithFavorite extends StatefulWidget {
  final Widget title;
  final Widget subtitle;
  final Color color;
  final Function(List) addToFavorites;
  final bool isFavorite;
  final int seasonIndex;
  final int episodeIndex;
  final int index;

  const ListTileWithFavorite({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.addToFavorites,
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
      widget.addToFavorites([widget.seasonIndex, widget.episodeIndex, widget.index]);
    } else {
      // Remove from favorites
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: Colors.grey,
      color: widget.color,
      child: ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      //tileColor: widget.color,
      trailing: IconButton(
        icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        onPressed: _toggleFavorite,
      ),
    )); 
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
