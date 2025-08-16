import 'package:cromos_scanner_laliga/app/data/stickers_datasource.dart';
import 'package:cromos_scanner_laliga/app/entities/count.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/enums/count_type.dart';
import 'package:cromos_scanner_laliga/app/widgets/action_card_widget.dart';
import 'package:cromos_scanner_laliga/app/widgets/count_card_widget.dart';
import 'package:cromos_scanner_laliga/app/widgets/custom_grid.dart';
import 'package:cromos_scanner_laliga/app/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = true;
  late List<Count> counts;

  final int crossAxisCount = 2;

  Sticker? lastStickerAdded;

  Future<void> setCounts() async {
    List<int> counts = await StickersDataSource().getCounts();
    this.counts = [
      Count(count: counts[0], title: 'Total Cards', type: CountType.totalCards),
      Count(count: counts[1], title: 'Collected', type: CountType.collected),
      Count(count: counts[2], title: 'Missing', type: CountType.missing),
    ];
    isLoading = false;
    setState(() {});
  }


  @override
  void initState() {
    setCounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SearchBarWidget(),
          const SizedBox(height: 29),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: _buildCards(),
          ),
          const SizedBox(height: 20),
          Text(
            'Actions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomGrid(
            children: [
              ActionCardWidget(
                color: Color(0xFFB3007A),
                title: 'Scan Stickers',
                description: 'Use camera to scan new stickers',
                icon: Icons.flip,
                onTap: (){},
              ),
              ActionCardWidget(
                title: 'My Collection',
                description: 'View your complete sticket collection',
                icon: Icons.folder_open,
                onTap: (){
                  Navigator.of(context).pushNamed('/collection');
                },
              ),
              ActionCardWidget(

                title: 'Missing Stickers',
                description: 'See which stickers you still need',
                icon: Icons.error_outline,
                onTap: (){
                  Navigator.of(context).pushNamed('/missing');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Recent Activity',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildLastStickerAdded()
        ],
      ),
    );
  }

  Widget _buildLastStickerAdded(){
    if(lastStickerAdded == null){
      return const SizedBox();
    }
    return Row(
      children: [
        Icon(Icons.verified_outlined,color: Color(0xFFB3007A),),
        SizedBox(width: 10,),
        RichText(
            text: TextSpan(
                children: [
                  TextSpan(text: 'Added ',style: TextStyle(color: Color(0xC9FFFFFF))),
                  TextSpan(text: lastStickerAdded!.name,style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' to collection',style: TextStyle(color: Color(
                      0xC9FFFFFF))),
                ]
            )
        )
      ],
    );
  }
  List<Widget> _buildCards() {
    List<Count> counts = this.counts;
    List<Widget> cards = [];
    for (Count count in counts) {
      cards.add(CountCardWidget(count: count));
    }
    return cards;
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Stickers Collection'),
      actions: [
        Image.asset(
          'lib/app/assets/logo-laliga-panini-este.png',
          width: 104,
          height: 39,
        ),
      ],
    );
  }
}
