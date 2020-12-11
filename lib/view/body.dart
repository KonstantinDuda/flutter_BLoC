import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/counter_bloc.dart';
import '../bloc/provider_bloc.dart';
//import 'chack_page.dart';
//import 'counter_page.dart';

class Body extends StatelessWidget {
  final IconData icon; // = new IconData();
  Body(this.icon);

  @override
  Widget build(BuildContext context) {
    return /*Container( //alignment: Alignment.center,
      child: */Column(
      children: <Widget>[
        BlocBuilder<CounterBloc, int>(
          builder: (_, count) {
            return Expanded( child: Center(
              child: /*Container(
                //width: 50.0,
                //height: 50.0,
                child:*/ FloatingActionButton(
                  child: Center(
                    child: Text(
                      // Выводим каунт которым управляет и который
                      // прослушивает Блок строитель
                      '$count',
                      // Указываем стиль текста, чтоб менялся цвет
                      // когда меняет тему приложения
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  onPressed: () {
                    //Navigator.pushNamed(context, '/chackPage');
                    BlocProvider.of<ProviderBloc>(context)
                        .add(ProviderEvent.chackPage);
                  },
                ),
                //),
              ),
            );
          },
        ),
        /*floatingActionButton:*/ /*Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[*/
            /*Padding(
              padding: const EdgeInsets.only(right: 50.0,bottom: 5.0)  ,//.symmetric(vertical: 5.0),
              child:*/
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), 
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                child: Icon(/*Icons.add*/ icon),
                onPressed: () =>
                    // Благодаря тому, что у нас есть доступ к блоку счетчика
                    // так-как мы добавили его в провайдере в main
                    // теперь мы можем считать из контекста с указанием
                    // класса управляющего счетчиком и добавить событие
                    icon == Icons.add ? 
                    context.read<CounterBloc>().add(CounterEvent.increment) : 
                    context.read<CounterBloc>().add(CounterEvent.decrement) ,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), 
                alignment: Alignment.bottomRight ,
                child: FloatingActionButton(
                child: Icon(Icons.date_range),
                onPressed: () {}/*=>
                    // Благодаря тому, что у нас есть доступ к блоку счетчика
                    // так-как мы добавили его в провайдере в main
                    // теперь мы можем считать из контекста с указанием
                    // класса управляющего счетчиком и добавить событие
                    icon == Icons.add ? 
                    context.read<CounterBloc>().add(CounterEvent.increment) : 
                    context.read<CounterBloc>().add(CounterEvent.decrement) ,*/
              ),
            ),
          //],
        //),
      ],
    //),
    );
  }
}
