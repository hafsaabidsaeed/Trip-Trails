import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destinations extends StatefulWidget {
  const Destinations({super.key});

  @override
  State<Destinations> createState() => _DestinationsState();
}

class _DestinationsState extends State<Destinations> {


  // List of destinations (images and titles)
  final List<Map<String, String>> destinations = [
    {'title': 'Azad Kashmir', 'image': 'assets/img1.jpg'},
    {'title': 'Gilgit', 'image': 'assets/img2.jpg'},
    {'title': 'Naran Kaghan', 'image': 'assets/img3.jpg'},
    {'title': 'Hunza', 'image': 'assets/img4.jpg'},
    {'title': 'Sawat', 'image': 'assets/img5.jpg', 'subtitle': 'Family'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Build rows alternating between 3 and 2 items
          for (int i = 0;
          i < destinations.length;
          i += 5) ...[
            // First row with 3 items
            Row(
              children:
              List.generate(3, (index) {
                if (i + index <
                    destinations.length) {
                  final destination =
                  destinations[i + index];
                  return Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          5.0),
                      child: Stack(
                        children: [
                          // Background image
                          Container(
                            height:
                            250, // Adjust the height as per your design
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  15),
                              image:
                              DecorationImage(
                                image: AssetImage(
                                    destination[
                                    'image']!),
                                fit: BoxFit
                                    .cover,
                              ),
                            ),
                          ),
                          // Overlay text
                          Positioned(
                            left: 10,
                            bottom: 10,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                if (destination[
                                'subtitle'] !=
                                    null)
                                  Text(
                                    destination[
                                    'subtitle']!,
                                    style:
                                    const TextStyle(
                                      fontSize:
                                      14,
                                      color: Colors
                                          .redAccent,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                Text(
                                  destination[
                                  'title']!,
                                  style:
                                  const TextStyle(
                                    fontSize:
                                    20,
                                    color: Colors
                                        .white,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox
                    .shrink(); // Empty container if no image
              }),
            ),
            // Second row with 2 items
            if (i + 3 < destinations.length)
              Row(
                children:
                List.generate(2, (index) {
                  if (i + 3 + index <
                      destinations.length) {
                    final destination =
                    destinations[
                    i + 3 + index];
                    return Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .all(5.0),
                        child: Stack(
                          children: [
                            // Background image
                            Container(
                              height:
                              250, // Adjust the height as per your design
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    15),
                                image:
                                DecorationImage(
                                  image: AssetImage(
                                      destination[
                                      'image']!),
                                  fit: BoxFit
                                      .cover,
                                ),
                              ),
                            ),
                            // Overlay text
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  if (destination[
                                  'subtitle'] !=
                                      null)
                                    Text(
                                      destination[
                                      'subtitle']!,
                                      style:
                                      const TextStyle(
                                        fontSize:
                                        14,
                                        color: Colors
                                            .redAccent,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  Text(
                                    destination[
                                    'title']!,
                                    style:
                                    const TextStyle(
                                      fontSize:
                                      20,
                                      color: Colors
                                          .white,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox
                      .shrink(); // Empty container if no image
                }),
              ),
          ],
        ],
      ),
    );
  }
}
