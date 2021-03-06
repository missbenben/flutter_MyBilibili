import 'package:flutter/material.dart';
import "package:mytest/model/jsonmodel/LiveItem.dart";
import 'package:mytest/util/GetUtilBilibili.dart';
import 'package:mytest/tools/LineTools.dart';
class LiveListViewPage extends StatefulWidget {
  @override
  _LiveListViewPageState createState() => _LiveListViewPageState();
}

class _LiveListViewPageState extends State<LiveListViewPage> 
with AutomaticKeepAliveClientMixin<LiveListViewPage>{
  final List<LivePartition> livepartitionlist=[];
  ScrollController _listviewscrollController = ScrollController(); //listview的控制器
  ScrollController _gridviewscrollController = ScrollController(); //gridview的控制器
  int listviewlen=0; 
  bool isaddok=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addCard();
  }
  addCard() async{
      livepartitionlist.addAll(await GetUtilBilibili.getLivePartition());
      print("list add ok");
      print("listlen "+livepartitionlist.length.toString());
      if(livepartitionlist.length!=0){
        isaddok=true;
      }
      listviewlen=livepartitionlist.length+1;
      setState(() {
        
      });
  }
  Future<void> _onRefresh() async{
    livepartitionlist.clear();
    livepartitionlist.addAll(await GetUtilBilibili.getLivePartition());
    listviewlen=livepartitionlist.length+1;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(//直播按钮
      onPressed: (){
        _onRefresh();
      },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.pink[300],
      ),
      body: buildLiveListView(),
    );
  }
  Widget buildLiveListView(){
    /*
    return ListView(
          children: <Widget>[
            ListTile(
              title: Text("data1"),
            ),
            ListTile(
              title: Text("data1"),
            ),
          ],
        );
        */
    if(isaddok==true){//判断是否加载出来数据
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _listviewscrollController,
          itemCount: listviewlen,
          itemBuilder: (context,index){
            if(index==0){
              return buildPartition();
            }
            else if(index>0){
              return buildLivePartition(livepartitionlist[index-1]);
            }
            
            //return ListTile(title: Text("data"),);
          },
        ),
      );
      
    }
    else{
      return Center(child: Text("正在加载。。"),);
    }
    
  }
  buildPartition(){
    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("images/partitions.png"))
      ),
    );
  }
  buildLivePartition(LivePartition partition){
    return Column(
      children: <Widget>[
        Container(
          height: 30,
          padding: EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text("${partition.name}"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7,right: 7),
          child: GridView.builder(
            controller: _gridviewscrollController,
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 7.0,
              crossAxisCount: 2,
              childAspectRatio: 0.8
            ),
            itemCount: partition.lives.length,
            itemBuilder: (BuildContext contex,int i){
              return buildCard(partition.lives[i]);
            },
          ),
        ),
        DrawLine.GreyLine(),
      ],
    );
  }
  buildCard(LiveItem carditem){
    return Container(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      //height: 120,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Hero(
              tag: "${carditem.id}",
              child: Container(
                //height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(carditem.user_cover),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5)
                  ),
                ),
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.only(
                      topRight:Radius.circular(5)
                    ),
                  ),
                  child: Text(" 热度 "+carditem.online.toString()+"  ",style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
                    
                  /*
                  height: 20,
                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: Row(
                    children: <Widget>[//信息栏
                      Text(" "+carditem.uname+"   ",style: TextStyle(color: Colors.white,fontSize: 12),),
                      Icon(Icons.person_outline,color: Colors.white,size: 15,),
                      Text(""+carditem.online.toString(),style: TextStyle(color: Colors.white,fontSize: 12),),
                    ],
                  ),
                  */
              ),
            ),
          ),
          Expanded(
            flex:3,
            child: Row(
              children: <Widget>[
                Container(//头像
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(carditem.face)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 7,),
                Text(carditem.uname,style: TextStyle(fontSize: 13),)
              ],
              
            ),
            
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5,left: 5,right: 5),
                  child: Text(carditem.title,style: TextStyle(color: Colors.black,fontSize: 14),maxLines: 2,),
                ),
              )
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text("${carditem.area_name}",style: TextStyle(color: Colors.grey,fontSize: 13),),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.centerRight,
                        child: Icon(Icons.more_vert,size: 13,color: Colors.grey,),
                      ),
                    )
                  ],
                ),
              )
          )

        ],
      ),
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}