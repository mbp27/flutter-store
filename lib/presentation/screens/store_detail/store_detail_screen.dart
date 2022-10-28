import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/models/store_visit.dart';
import 'package:pitjarusstore/helpers/colors.dart';
import 'package:pitjarusstore/helpers/utils.dart';
import 'package:pitjarusstore/logic/blocs/selected_location/selected_location_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_detail/store_detail_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_visit/store_visit_bloc.dart';
import 'package:pitjarusstore/presentation/screens/loading/loading_screen.dart';

class StoreDetailScreenArguments {
  final Store store;

  StoreDetailScreenArguments({
    required this.store,
  });
}

class StoreDetailScreen extends StatelessWidget {
  const StoreDetailScreen({
    Key? key,
    required this.store,
  }) : super(key: key);

  static const String routeName = '/store_detail';

  final Store store;

  @override
  Widget build(BuildContext context) {
    final position =
        context.select((SelectedLocationBloc selectedLocationBloc) {
      final state = selectedLocationBloc.state;
      return state is SelectedLocationLoadSuccess ? state.position : null;
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.2),
            foregroundColor: Colors.white,
            child: const BackButton(),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<StoreDetailBloc, StoreDetailState>(
            listener: (context, state) {
              if (state is StoreDetailLoadFailure) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
            },
          ),
          BlocListener<StoreVisitBloc, StoreVisitState>(
            listener: (context, state) {
              if (state is StoreVisitStartedInProgress) {
                Navigator.of(context).pushNamed(LoadingScreen.routeName);
              }
              if (state is StoreVisitStartedSuccess) {
                Navigator.of(context)
                  ..pop()
                  ..pop(state.storeVisit);
              }
              if (state is StoreVisitStartedFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<StoreDetailBloc, StoreDetailState>(
          builder: (context, state) {
            if (state is StoreDetailLoadSuccess) {
              const distance = Distance();

              final meter = distance(
                LatLng(
                  position?.latitude ?? 0,
                  position?.longitude ?? 0,
                ),
                MyUtils.generateLatLng(
                  state.store.latitude,
                  state.store.longitude,
                ),
              ).round();

              final isLocationSame = meter <= 150;
              final lastVisit = state.store.storeVisit?.date;

              return Stack(
                children: [
                  Image.network(
                    'https://asset.kompas.com/crops/5sx-Iwd6FE4x-RV3ZoYGc'
                    'P8KstE=/90x0:1025x623/750x500/data/photo/2021/05/12/'
                    '609ba247501d2.jpg',
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 6.0,
                            margin: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 32.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        position != null
                                            ? isLocationSame
                                                ? 'Lokasi Sudah Sesuai'
                                                : 'Lokasi Belum Sesuai'
                                            : 'Sedang Mencari Lokasi...',
                                        style: TextStyle(
                                          color: position != null
                                              ? isLocationSame
                                                  ? Colors.green
                                                  : Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      ElevatedButton(
                                        onPressed: () => context
                                            .read<SelectedLocationBloc>()
                                            .add(SelectedLocationLoad()),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          fixedSize:
                                              const Size(double.infinity, 25.0),
                                          minimumSize: const Size(70.0, 0.0),
                                        ),
                                        child: const Text('Reset'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.store,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text('${state.store.storeName}'),
                                            const SizedBox(height: 12.0),
                                            Text(
                                              '${state.store.address}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'Tipe Outlet',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': (data)',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'Tipe Display',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': (data)',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'Sub Tipe Display',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': (data)',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'ERTM',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': Ya',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'Pareto',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': Ya',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    'E-merchandising',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ': Ya',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.document_scanner,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text('Last Visit'),
                                            Text(
                                              lastVisit != null
                                                  ? DateFormat.yMd('id')
                                                      .format(lastVisit)
                                                  : '-',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 30.0,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: MyColors.pallete,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.navigation,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: MyColors.pallete,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                GestureDetector(
                                  onTap: () => context
                                      .read<SelectedLocationBloc>()
                                      .add(SelectedLocationLoad()),
                                  child: Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: MyColors.pallete,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLocationSame
                                    ? () => context.read<StoreVisitBloc>().add(
                                          StoreVisitStarted(
                                            storeVisit: StoreVisit(
                                              storeId: store.storeId,
                                              date: DateTime.now(),
                                              type: StoreVisitType.noVisit,
                                              latitude:
                                                  position?.latitude.toString(),
                                              longitude: position?.longitude
                                                  .toString(),
                                            ),
                                          ),
                                        )
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('No Visit'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLocationSame
                                    ? () => context.read<StoreVisitBloc>().add(
                                          StoreVisitStarted(
                                            storeVisit: StoreVisit(
                                              storeId: store.storeId,
                                              date: DateTime.now(),
                                              type: StoreVisitType.visit,
                                              latitude:
                                                  position?.latitude.toString(),
                                              longitude: position?.longitude
                                                  .toString(),
                                            ),
                                          ),
                                        )
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                ),
                                child: const Text('Visit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is StoreDetailLoadFailure) {
              return GestureDetector(
                onTap: () => context
                    .read<StoreDetailBloc>()
                    .add(StoreDetailLoad(store: store)),
                child: const Center(
                  child: Icon(
                    Icons.refresh,
                    size: 40.0,
                  ),
                ),
              );
            } else {
              return Center(
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
