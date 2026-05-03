import 'package:flutter/material.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/post_ad/presentation/screens/widgets/ad_details_widget.dart';

class AdDetailsScreen extends StatelessWidget {
  final AdModel ad;

  const AdDetailsScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdImageHeader(
                    imageUrl: ad.photos.isNotEmpty
                        ? ad.photos[0]
                        : 'https://via.placeholder.com/300',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ad.category.label.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            Text(
                              " ${ad.adCity.label}, CA",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          ad.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\$${ad.price.toStringAsFixed(2)} ",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const TextSpan(
                                text: "/ hour",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const SellerCard(),
                        const SizedBox(height: 24),

                        const Text(
                          "Service Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ad.description,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildFeatureRow(
                          Icons.check_circle_outline,
                          "All equipment provided",
                        ),
                        _buildFeatureRow(
                          Icons.check_circle_outline,
                          "Insured and bonded professionals",
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("See All"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const ContactButtons(),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
