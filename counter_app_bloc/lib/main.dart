import 'package:counter_app_bloc/counter_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final counterBloc = CounterBloc();

  @override
  void dispose() {
    counterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('=' * 10 + 'WIDGET TREE' + '=' * 10);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<int>(
              stream: counterBloc.counterStream,
              initialData: 0,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Text("Some Error");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              counterBloc.eventSink.add(CounterAction.Increment);
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 5,
          ),
          FloatingActionButton(
            onPressed: () {
              counterBloc.eventSink.add(CounterAction.Decrement);
            },
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 5,
          ),
          FloatingActionButton(
            onPressed: () {
              counterBloc.eventSink.add(CounterAction.Reset);
            },
            tooltip: 'Reset',
            child: Icon(Icons.loop_outlined),
          ),
        ],
      ),
    );
  }
}
