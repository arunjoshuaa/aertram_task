import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
appBar: AppBar(
  backgroundColor: Colors.black,
  centerTitle: true,
  leading: IconButton(icon: Icon(Icons.menu,color: Colors.amber,),onPressed: () {
    
  },
    
  ),
  title: Text("AETRAM",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),),
  actions: [
    Container(
      decoration: BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.circular(18),border: BoxBorder.all(width: 1)),
      child: CircleAvatar(child: Icon(Icons.person,color: Colors.white,),backgroundColor: Colors.black,)),
    SizedBox(width: 10,)
  ],
),
body: SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(height: 10,),
      Text("USD Landing Account",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("Hello Name",style: TextStyle(color: Colors.white),),
              Text("          LND-USD-000354",style: TextStyle(color: Colors.grey),)
            ],
          ),
                   Column(
            children: [
              Text("LND Amount",style: TextStyle(color: Colors.white),),
              Text("\$67.908,.86",style: TextStyle(color: Colors.green),)
            ],
          ),

        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 20,right: 20),
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(children: [
                Text("Services",style: TextStyle(fontWeight: FontWeight.bold),),
                Spacer(),
                TextButton(onPressed: (){}, child: Text("See All",style: TextStyle(color: Colors.black),))
              ],),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.account_balance_wallet)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.paid)),
        
                        IconButton(onPressed: (){}, icon: Icon(Icons.swap_vert)),
                     IconButton(onPressed: (){}, icon: Icon(Icons.history)),
                  
        
          ],
        )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Text("Account",style: TextStyle(color: Colors.white,fontSize: 20),),
          ],
        ),
      ),
      SizedBox(height: 10,),
     Container(
      height: 200,
      width: double.infinity,
       child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                  contentPadding: EdgeInsets.only(left: 50,right: 50),
                  unselectedBackgroundColor: Colors.black,
                  unselectedLabelStyle: TextStyle(color: Colors.white),
                  
                  labelStyle:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                  //    icon: Icon(Icons.directions_car),
                      text: "Live",
                    ),
                    Tab(
                    //  icon: Icon(Icons.directions_transit),
                      text: "Demo",
                    ),
                  
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              ListTile(
                              title: Text("5000510441"),
                              subtitle: Text("MT5-USD-005531"),
                              leading: Icon(Icons.add_circle_outlined),
                              trailing: Icon(Icons.more_vert),
                            ),
                             ListTile(
                              title: Text("5000510441"),
                              subtitle: Text("MT5-USD-005531"),
                              leading: Icon(Icons.add_circle_outlined),
                              trailing: Icon(Icons.more_vert),
                            ),     
                        
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(Icons.directions_transit),
                      ),
                 
                    ],
                  ),
                ),
              ],
            ),
          ),
     ),
     SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: SizedBox(
                                                                  width: double.infinity,
                                                                  child:ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), child: Text("Create Account",style: TextStyle(color: Colors.black),),),
                                                                ),
                                  ) 
    ],
  ),
),
    );
  }
}