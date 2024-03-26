import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<void> _launchMaps() async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=b%E1%BB%87nh%20vi%E1%BB%87n';

    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    } else {
      throw 'Could not launch ';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              _launchMaps();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('images/hospitalBackground.jpg'),
                  fit: BoxFit.cover
                )
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.4)
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Find nearby hospitals',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),

                    Icon(Icons.search,size: 40,color: Colors.white,),
                  ],
                ),
              ),
            ),
          )
        ],
      )

    );
  }
}

// class _MapScreenState extends State<MapScreen> {
//   WeatherAndLocationService weatherAndLocationService = WeatherAndLocationService();
//   List<Hospital> hospitals = []; // Sửa kiểu dữ liệu từ dynamic sang Hospital
//   bool isLoaded = false; // Thêm biến để kiểm tra dữ liệu đã được tải xong hay chưa
//
//   Future<void> getNearHospitals() async {
//     try {
//       Position position = await weatherAndLocationService.getCurrentLocation();
//       List<Hospital> nearbyHospitals = await weatherAndLocationService.getNearbyHospitals(position.latitude, position.longitude);
//       setState(() {
//         hospitals = nearbyHospitals;
//         isLoaded = true; // Đánh dấu dữ liệu đã được tải xong
//       });
//     } catch (e) {
//       print('Error getting nearby hospitals: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getNearHospitals();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Hospitals'),
//       ),
//       body: isLoaded ?
//       ListView.builder(
//         itemCount: hospitals.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(hospitals[index].name),
//             subtitle: Text(hospitals[index].address),
//           );
//         },
//       ) : const Center(
//         child: CircularProgressIndicator(),
//       ),
//
//     );
//   }
// }
