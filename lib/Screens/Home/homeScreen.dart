import 'package:blue_car/Screens/Anuncio/anuncio_screen.dart';
import 'package:blue_car/Screens/Anuncio/create_edit_anuncio_screen.dart';
import 'package:blue_car/Screens/List/hotel_home_screen.dart';
import 'package:blue_car/Screens/Perfil/components/profile_pic.dart';
import 'package:blue_car/Screens/Perfil/my_anuncios/widgets/my_anuncios_widtget.dart';
import 'package:blue_car/Screens/Perfil/profile_screen.dart';
import 'package:blue_car/Services/bluecar_api.dart';
import 'package:blue_car/models/anuncios_list.dart';
import 'package:blue_car/notifier/anuncio_notifier.dart';
import 'package:blue_car/Screens/Home/widget/home_screen_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blue_car/configuration.dart';
import 'package:blue_car/theme.dart';
import 'package:blue_car/widgets/snackbar.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';
import 'package:provider/provider.dart';
import 'package:blue_car/Services/auth_services.dart';

import '../../data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    AnunciosModel anunciosModel =
        Provider.of<AnunciosModel>(context, listen: false);

    _getAnuncios(anunciosModel);
    super.initState();
  }

  _getAnuncios(AnunciosModel anunciosModel) async {
    anunciosModel.anuncioLista = await getAnuncios();
  }

  String page = 'Blue';

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        body: AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 30.0, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          child: IconButton(
                            onPressed: _handleMenuButtonPressed,
                            icon: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable: _advancedDrawerController,
                              builder: (context, value, child) {
                                return Icon(
                                  value.visible ? Icons.clear : Icons.menu,
                                );
                              },
                            ),
                          )),
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.search),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'Busca tu coche...',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start, // no impact
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return HotelHomeScreen();
                          }));
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(auth.currentUser.photoURL)),
                        ),
                        // Handle your callback
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              width: 85,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8.0),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Image.asset(categories[index]['iconPath'],
                                      height: 50, width: 50),
                                  Text(
                                    categories[index]['name'],
                                    style: const TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 12.0,
                                        color: Colors.black54),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ultimos anuncios:",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 16),
                      ),
                      Text(
                        "Ver todos",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<AnunciosList>>(
                  stream: getAnunciosList(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return buildText(
                              'Algo fue mal, vuelve a intentarlo mas tarde :(');
                        } else {
                          final anunciosList = snapshot.data;

                          if (anunciosList.isEmpty) {
                            return buildText('No Anuncios encontrados');
                          } else
                            print('ANUNCIOS:');
                          return Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Column(
                              children: [
                                HomeScreenBodyWidget(
                                    anunciosList: anunciosList),
                              ],
                            ),
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.black87),
        ),
      );
}
