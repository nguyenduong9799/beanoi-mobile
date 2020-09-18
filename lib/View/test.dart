import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TestProject'),
      ),
      body: new ListView(
        children: <Widget>[
          new Card(
            child: new ListTile(
              title: const Text('Some information'),
            ),
          ),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
            child: new TabBar(
              controller: _controller,
              tabs: [
                new Tab(
                  icon: const Icon(Icons.home),
                  text: 'Address',
                ),
                new Tab(
                  icon: const Icon(Icons.my_location),
                  text: 'Location',
                ),
              ],
            ),
          ),
          new Container(
            height: 80.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new Card(
                  child: new ListTile(
                    leading: const Icon(Icons.home),
                    title: new TextField(
                      decoration: const InputDecoration(hintText: 'Search for address...'),
                    ),
                  ),
                ),
                new Card(
                  child: new ListTile(
                    leading: const Icon(Icons.location_on),
                    title: new Text('Latitude: 48.09342\nLongitude: 11.23403'),
                    trailing: new IconButton(icon: const Icon(Icons.my_location), onPressed: () {}),
                  ),
                ),
              ],
            ),
          ),
          new Card(
            child: new ListTile(
              title: const Text('Some more information'),
            ),
          ),
          new RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {},
            child: const Text(
              'Search for POIs',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}