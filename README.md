# frode_mvvm

flutter基于Provider实现mvvm示例及使用方法.

## Getting Started

注意该插件已依赖Provider.

```
provider: ^4.1.0
```


[github项目主页地址](https://github.com/2628748861/mvvm)

使用方法:

安装依赖:

```
dependencies:
  frode_mvvm: xx
```
编写model:

```
class User {
  int _age;
  String _name;
  User(this._age,this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }
}
```
编写state:

```
enum ModelState{
  LOADING,
  COMPLETE,
  ERROR,
  EMPTY
}
```


编写viewmodel:

```
class FourViewModel extends BaseViewModel<User,ModelState>{
  FourViewModel(User mode, ModelState state) : super(mode, state);
  @override
  void changeMode() {
    this.mode.name='xxxx';
    super.changeMode(newMode);
  }
}

```
编写view:

```
 @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_)=>TwoViewModel(User(100,'aaa'),ModelState.LOADING),
      builder: (context,child)=>Scaffold(
        body: Container(
          child: Column(
            children: [
              Text('Consumer简化写法:${context.watch<TwoViewModel>().mode.name}'),
              Consumer<TwoViewModel>(
                builder: (context,vm,child)=>Text('Consumer非简化写法:${vm.mode.name}'),
              ),
              Text('Selector简化写法:${context.select<TwoViewModel,int>((value) => value.mode.age)}'),
              Selector<TwoViewModel,int>(builder: (context,age,child){
                return Text('Selector非简化写法:$age');
              },selector: (context,vm)=>vm.mode.age,),
              RaisedButton(onPressed: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
                  return new Four();
                },));
              },child: Text('跳转下一页'),)
            ],
          ),
        ),
      ),
    );
 }
```

触发更新:

```
 Provider.of<FourViewModel>(context, listen: false).changeMode();
```

MultiProvider使用及跨组件更新方案:

如果一个页面包含多个viewmodel,则可以使用MultiProvider实现:

```
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<Counter>(create: (_)=>Counter(10000)),
      ChangeNotifierProvider<TwoViewModel>(create: (_)=>TwoViewModel(User(1101,'aaaa'),ModelState.LOADING)),
    ],child: xxx,);
  }
```

同样的,如果整个应用包含多个viewmodel,也可以按上面的写法.

main.dart (一定要作用于整个应用)
```
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<Counter>(create: (_)=>Counter(10000)),
      ChangeNotifierProvider<TwoViewModel>(create: (_)=>TwoViewModel(User(1101,'aaaa'),ModelState.LOADING)),
    ],child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        navigatorObservers: [routeObserver]
    ),);
  }
```



```
应用场景:

a.多个页面会使用到用户登录信息,当用户信息变更时,则需要触发全部刷新.
b.用户定位信息在不同页面的展示
...
```











