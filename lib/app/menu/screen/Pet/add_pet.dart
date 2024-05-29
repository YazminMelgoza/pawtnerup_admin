import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawtnerup_admin/app/menu/screen/menu_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pawtnerup_admin/auth/screens/register_data.dart';
import 'package:pawtnerup_admin/config/config.dart';
import 'package:pawtnerup_admin/services/firebase_service.dart';
import 'package:pawtnerup_admin/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawtnerup_admin/utils/login_google_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pawtnerup_admin/utils/pick_image.dart';
import 'package:pawtnerup_admin/utils/show_snack_bar.dart';
import 'package:pawtnerup_admin/services/user_service.dart';

import '../../../../models/pet_model.dart';
import '../../../../services/pet_service.dart';
import '../../../../shared/widgets/custom_image.dart';

class AddPet extends StatelessWidget {
  const AddPet({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // You can customize the app bar further with actions, leading, etc.
      ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: const _AddPet(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}

class _AddPet extends StatefulWidget {
  const _AddPet();

  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<_AddPet> {
  final name = TextEditingController();
  final raza = TextEditingController();
  final edad = TextEditingController();
  final descripcion = TextEditingController();

  File? image;
  List<String> animals = ['Dog', 'Cat'];
  List<String> BreedDogs = ['Labrador', 'Pastor Aleman', 'Chihuahua', 'Bulldog', 'Beagle'];
  List<String> SexAnimal = ['Female', 'Male'];
  List<String> BreedCats = ['Persa', 'Siames', 'Coon', 'Bengali', 'Britanico'];
  List<double> Edades = [0.5, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0];
  List<String> Personalidad = [];
  List<String> Colores = [];
  List<String> PhotosURLs = [];
  String selectedAnimal = 'Dog';
  String selectedDog = 'Labrador';
  String selectedCats = 'Persa';
  double selectedEdades = 1.0;
  String selectedSex = 'Male';
  User? user = FirebaseAuth.instance.currentUser;



  String getuid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
      print('User ID: $userId');
    } else {
      return '';
    }
  }
  final formKey = GlobalKey<FormState>();

  void _addPersonalityTrait() async {
    String newTrait = await _showAddPersonalityDialog(context);
    if (newTrait.isNotEmpty) {
      setState(() {
        Personalidad.add(newTrait);
      });
    }
  }
  void _addColorTrait() async {
    String newTrait = await _showAddColorDialog(context);
    if (newTrait.isNotEmpty) {
      setState(() {
        Colores.add(newTrait);
      });
    }
  }

  Future<String> _showAddPersonalityDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    String trait = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Añadir Personalidad"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Añadir rasgo de personalidad"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                trait = controller.text;
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
    return trait;
  }
  Future<String> _showAddColorDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    String trait = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Añadir Color"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Color de la mascota"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                trait = controller.text;
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
    return trait;
  }
  List<String> _uploadedPhotos = [];
  Future<void> _uploadPhoto() async {
    image = await pickImage(context);
    String photoUrl = await PetService().uploadPetPic(image!, user!.uid);
    setState(() {
      _uploadedPhotos.add(photoUrl);
    });
  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children:
              [
                //Primer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if(_uploadedPhotos.isEmpty)
                        {
                          _uploadPhoto();
                        }else
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Image.network(
                                  _uploadedPhotos.first,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }

                      },
                      child: Column(
                        children: [
                          SizedBox.square(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFFFBC00),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFFBC00).withOpacity(0.3),
                                    blurRadius: 0.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(8.0, -6.0),
                                  ),
                                  BoxShadow(
                                    color: Color(0xFFFFBC00).withOpacity(0.1),
                                    blurRadius: 0.0,
                                    spreadRadius: 4.0,
                                    offset: Offset(16.0, -12.0),
                                  ),
                                ],
                              ),
                              width: 150.0,
                              height: 150.0,
                              child: _uploadedPhotos.isEmpty
                                  ? const Icon(
                                    Icons.photo,
                                    size: 85,
                                    color: Colors.white,
                                  )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      _uploadedPhotos.first,
                                      width: 80.0,
                                      height: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                          ),
                          Text((_uploadedPhotos.isEmpty)?
                              "Foto Principal":"Foto Principal",
                            softWrap: true,
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () async {
                        _uploadPhoto();
                      },
                      child: Column(
                        children: [
                          SizedBox.square(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFFF8D00),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF8D00).withOpacity(0.3),
                                    blurRadius: 0.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(8.0, -6.0),
                                  ),
                                  BoxShadow(
                                    color: Color(0xFFFF8D00).withOpacity(0.1),
                                    blurRadius: 0.0,
                                    spreadRadius: 4.0,
                                    offset: Offset(16.0, -12.0),
                                  ),
                                ],
                              ),
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Pulsa aquí "),
                          Text("para añadir fotos"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Catálogo de Fotos:",
                      textAlign: TextAlign.left,style:  TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),

                (_uploadedPhotos.isNotEmpty)?
                Container(
                  height: 150,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: _uploadedPhotos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {


                              },
                              child: CustomImage(

                                _uploadedPhotos[index],
                                borderRadius: BorderRadius.circular(10),
                                isShadow: false,
                                width: double.infinity,
                                height: double.infinity,
                              ),

                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _uploadedPhotos.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                ):
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("Tus fotos se mostrarán aquí",style: const TextStyle(fontSize: 16),),
                  ],
                ),

                SizedBox(height: 10,),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Nombre",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    TextFormField(

                      controller: name,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontFamily: 'outfit',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                          color: AppColor.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        isDense: true,
                        hintText: "Nombre",
                        focusColor: AppColor.primary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Tipo de Mascota: ",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20.0),
                      ),

                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,

                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontFamily: 'outfit',
                              fontWeight: FontWeight.w500,
                            ),
                            value: selectedAnimal,
                            items: animals
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAnimal = value!;
                              });
                            },
                            iconEnabledColor: Colors.yellow,
                            iconDisabledColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Raza",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    TextFormField(
                      controller: raza,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontFamily: 'outfit',
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                          color: AppColor.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        isDense: true,
                        hintText: "Raza",
                        focusColor: AppColor.primary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Edad en años",
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: DropdownButton<double>(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontFamily: 'outfit',
                                fontWeight: FontWeight.w500,
                              ),
                              value: selectedEdades,
                              items: Edades
                                  .map((item) => DropdownMenuItem<double>(
                                value: item,
                                child: Text(item.toString()),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedEdades = value!;
                                });
                              },
                              iconEnabledColor: Colors.yellow,
                              iconDisabledColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Sexo",
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: DropdownButton<String>(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontFamily: 'outfit',
                                fontWeight: FontWeight.w500,
                              ),
                              value: selectedSex,
                              items: SexAnimal
                                  .map((item) => DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(item),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSex = value!;
                                });
                              },
                              iconEnabledColor: Colors.yellow,
                              iconDisabledColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Descripción",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20.0),

                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: TextFormField(
                        maxLines: 3,
                        controller: descripcion,
                        keyboardType: TextInputType.text,
                        style: TextStyle(

                          fontSize: 18,
                          color: Colors.black54,
                          fontFamily: 'outfit',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            color: AppColor.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          isDense: true,
                          hintText: "Añade una descripcion",
                          focusColor: AppColor.primary,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Personalidad",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        alignment: WrapAlignment.start,
                        children: Personalidad
                            .map((trait) => Chip(
                          label: Text(trait),
                          backgroundColor: Color(0xFFF8F7F7),
                          labelStyle: TextStyle(
                            fontFamily: 'outfit',
                          ),
                          onDeleted: () {
                            setState(() {
                              Personalidad.remove(trait);
                            });
                          },
                        ))
                            .toList(),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 2.0),
                          color: Colors.transparent,
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: _addPersonalityTrait,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Colores",
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        alignment: WrapAlignment.start,
                        children: Colores
                            .map((trait) => Chip(
                          label: Text(trait),
                          backgroundColor: Color(0xFFF8F7F7),
                          labelStyle: TextStyle(
                            fontFamily: 'outfit',
                          ),
                          onDeleted: () {
                            setState(() {
                              Colores.remove(trait);
                            });
                          },
                        ))
                            .toList(),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 2.0),
                          color: Colors.transparent,
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.black,
                          ),
                          onPressed: _addColorTrait,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CustomFilledButton(
                    text: 'Añadir Mascota',
                    buttonColor: Color(0xFFFF8D00),
                    icon: MdiIcons.fromString("paw"),

                    onPressed: () async {
                      String urlFile = await PetService().uploadProfilePic(image!, getuid());
                      PhotosURLs.add(urlFile);
                      PetModel newPet = PetModel(
                        id: '', // Generate a unique ID or leave it empty to let Firestore generate one
                        name: name.text,
                        type: selectedAnimal,
                        sex: selectedSex,
                        ageInYears: selectedEdades.toInt(),
                        size: '', // Add size if applicable
                        breed: selectedAnimal == 'Dog' ? selectedDog : selectedCats,
                        features: Personalidad,
                        colors: [], // Add colors if applicable
                        imageURLs: PhotosURLs, // Add image URLs if applicable
                        shelterId: getuid(), // Add shelter ID if applicable
                        adoptionStatus: 'published', // Add adoption status if applicable
                        story: descripcion.text.isNotEmpty ? descripcion.text : null,
                        publishedAt: Timestamp.now().millisecondsSinceEpoch, // Add publishedAt timestamp
                      );
                      try {
                        await PetService().addPet(newPet);
                        const SnackBar(
                          content: Text(
                            "Ha ocurrido un error inesperado. Inténtalo de nuevo más tarde.",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }catch (error) {
                        // Handle other non-Firebase errors
                        print(error); // Log the error for debugging
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Ha ocurrido un error inesperado. Inténtalo de nuevo más tarde.",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
                      // Optionally, you can show a message or navigate to a different screen after adding the pet


                      // Clear text controllers or reset the form
                      name.clear();
                      descripcion.clear();
                      setState(() {
                        Personalidad.clear();
                        PhotosURLs.clear();
                        selectedAnimal = 'Dog';
                        selectedDog = 'Labrador';
                        selectedCats = 'Persa';
                        selectedEdades = 1.0;
                        selectedSex = 'Male';
                      });

                    },
                  ),
                ),
              ],
              )
          )
      ),
    );
  }
}
