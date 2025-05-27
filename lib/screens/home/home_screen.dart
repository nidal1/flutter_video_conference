import 'package:flutter/material.dart';
import 'package:flutter_video_conference/core/services/auth_service.dart';
import 'package:flutter_video_conference/core/services/meeting_service.dart';
import '../../widgets/meeting_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _titles = ['Ongoing', 'Upcoming', 'Ended', 'Canceled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titles.length, vsync: this);

    // مهم باش يبدل اللون مني يتبدل tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // refresh UI
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white, // icon color
          ),
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white, // icon color
            ),
            icon: const Icon(
              Icons.notifications_none,
            ), // يمكن تبدلو بـ Icons.message
            onPressed: () {},
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.black),
            color: Colors.white,
            icon: const Icon(Icons.add),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Hi, Murad Hossain',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Start your meeting',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TabBar(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelPadding: EdgeInsets.zero,
            indicator: const BoxDecoration(), // indicator khawi
            tabs: List.generate(_titles.length, (index) {
              final isSelected = _tabController.index == index;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _titles[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                4,
                (_) => _buildMeetingList(
                  _titles[_tabController.index].toLowerCase(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingList(String status) {
    return FutureBuilder(
      future: MeetingService().fetchMeetingsByStatus(status),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }
        if (!asyncSnapshot.hasData || (asyncSnapshot.data as List).isEmpty) {
          return const Center(child: Text('No meetings found'));
        }

        final data = asyncSnapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, index) {
            final meeting = data[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: MeetingCard(meetingData: meeting),
            );
          },
        );
      },
    );
  }
}
