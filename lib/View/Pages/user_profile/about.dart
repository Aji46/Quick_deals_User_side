import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Quick O Deals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Quick O Deals is an innovative mobile application designed as a user-friendly platform for buying and selling used products. It aims to connect buyers and sellers efficiently, making the process of purchasing second-hand goods seamless and reliable. The app incorporates features that facilitate safe transactions, easy listings, and a responsive user experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Key Features:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildFeature('User Authentication:',
                  'Quick O Deals offers secure user authentication via email and phone number, ensuring that users can create accounts safely and access their profiles easily.'),
              _buildFeature('Product Listings:',
                  'Sellers can create detailed listings for their used products, including descriptions, images, and pricing. The app allows users to upload multiple images to showcase their products effectively.'),
              _buildFeature('Category Browsing:',
                  'The application categorizes products into various sections (e.g., electronics, furniture, clothing), enabling buyers to browse items based on their interests easily.'),
              _buildFeature('Search Functionality:',
                  'Users can search for specific products using keywords, enhancing the discoverability of listings.'),
              _buildFeature('In-app Messaging:',
                  'Quick O Deals includes a messaging feature that allows buyers and sellers to communicate directly within the app, streamlining negotiations and inquiries.'),
              _buildFeature('Likes and Favorites:',
                  'Users can like or save products to their favorites list for easy access later, encouraging engagement with the platform.'),
              _buildFeature('User Profiles:',
                  'Each user has a profile showcasing their listed products, purchase history, and ratings, fostering a sense of community and trust among users.'),
              _buildFeature('Reviews and Ratings:',
                  'Buyers can leave reviews and ratings for sellers, enhancing accountability and helping future buyers make informed decisions.'),
              _buildFeature('Secure Transactions:',
                  'The app promotes secure payment methods and transaction processes, ensuring a safe buying and selling environment.'),
              _buildFeature('Notifications:',
                  'Users receive notifications about new messages, likes, and updates on their listings, keeping them informed and engaged.'),
              SizedBox(height: 16),
              Text(
                'Technology Stack:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Frontend: Built with Flutter for a responsive and interactive user interface.\n'
                'Backend: Firebase is utilized for user authentication, database management, and real-time data synchronization.\n'
                'State Management: The application employs the Provider pattern for effective state management, ensuring a smooth user experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Conclusion:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Quick O Deals aims to revolutionize the way users buy and sell used products by providing a reliable, secure, and easy-to-use platform. With its robust features and commitment to user satisfaction, the app is poised to become a go-to marketplace for second-hand goods.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
