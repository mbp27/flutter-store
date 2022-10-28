import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:pitjarusstore/helpers/colors.dart';
import 'package:pitjarusstore/helpers/utils.dart';
import 'package:pitjarusstore/logic/blocs/logout/logout_bloc.dart';
import 'package:pitjarusstore/logic/blocs/selected_location/selected_location_bloc.dart';
import 'package:pitjarusstore/logic/blocs/store_list/store_list_bloc.dart';
import 'package:pitjarusstore/presentation/screens/loading/loading_screen.dart';
import 'package:pitjarusstore/presentation/screens/store_detail/store_detail_screen.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({super.key});

  static const String routeName = '/store_list';

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final LatLng _center = LatLng(-6.200000, 106.816666);
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final position =
        context.select((SelectedLocationBloc selectedLocationBloc) {
      final state = selectedLocationBloc.state;
      return state is SelectedLocationLoadSuccess ? state.position : null;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Store'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                final confirm = await showDialog<bool?>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Anda yakin ingin logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirm != null && confirm == true) {
                  if (!mounted) return;
                  context.read<LogoutBloc>().add(LogoutStarted());
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text('LOGOUT'),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<StoreListBloc, StoreListState>(
            listener: (context, state) {
              if (state is StoreListLoadSuccess) {
                context
                    .read<SelectedLocationBloc>()
                    .add(SelectedLocationLoad());
              }
              if (state is StoreListLoadFailure) {
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
          BlocListener<SelectedLocationBloc, SelectedLocationState>(
            listener: (context, state) {
              if (state is SelectedLocationLoadSuccess) {
                _mapController
                  ..rotate(0)
                  ..move(
                    LatLng(state.position.latitude, state.position.longitude),
                    15.0,
                  );
              }
            },
          ),
          BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutStartedInProgress) {
                Navigator.of(context).pushNamed(LoadingScreen.routeName);
              }
              if (state is LogoutStartedSuccess) {
                Navigator.of(context).pop();
              }
              if (state is LogoutStartedFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${state.error}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<StoreListBloc, StoreListState>(
          builder: (context, state) {
            if (state is StoreListLoadSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _center,
                        zoom: 15.0,
                      ),
                      nonRotatedChildren: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  heroTag: 'zoomTag',
                                  onPressed: () => _mapController
                                    ..rotate(0)
                                    ..move(
                                      _mapController.center,
                                      15.0,
                                    ),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  mini: true,
                                  child: const Icon(Icons.zoom_in_map),
                                ),
                                FloatingActionButton(
                                  heroTag: 'locationTag',
                                  onPressed: () => context
                                      .read<SelectedLocationBloc>()
                                      .add(SelectedLocationLoad()),
                                  foregroundColor: position != null
                                      ? MyColors.pallete
                                      : Colors.black,
                                  backgroundColor: Colors.white,
                                  mini: true,
                                  child: const Icon(Icons.my_location),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.mbp.pitjarusstore',
                        ),
                        if (position != null)
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                color: MyColors.pallete,
                                point: LatLng(
                                  position.latitude,
                                  position.longitude,
                                ),
                                borderColor: Colors.white,
                                borderStrokeWidth: 2.0,
                                radius: 6.0,
                              ),
                              CircleMarker(
                                color: MyColors.pallete.withOpacity(0.3),
                                point: LatLng(
                                  position.latitude,
                                  position.longitude,
                                ),
                                radius: 42.0,
                              ),
                            ],
                          ),
                        MarkerLayer(
                          markers: state.stores.map(
                            (e) {
                              return Marker(
                                point: MyUtils.generateLatLng(
                                    e.latitude, e.longitude),
                                builder: (context) => GestureDetector(
                                  onTap: () => _mapController
                                    ..rotate(0)
                                    ..move(
                                      MyUtils.generateLatLng(
                                        e.latitude,
                                        e.longitude,
                                      ),
                                      15.0,
                                    ),
                                  child: const Icon(
                                    Icons.place,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Text(
                        'List kunjungan ${DateFormat.yMd('id').format(DateTime.now())}'),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        if (!mounted) return;
                        context.read<StoreListBloc>().add(StoreListLoad());
                      },
                      child: ListView.builder(
                        itemCount: state.stores.length,
                        itemBuilder: (context, index) {
                          const distance = Distance();

                          final meter = distance(
                            position != null
                                ? LatLng(
                                    position.latitude,
                                    position.longitude,
                                  )
                                : _center,
                            MyUtils.generateLatLng(
                              state.stores[index].latitude,
                              state.stores[index].longitude,
                            ),
                          ).round();

                          return GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(
                              StoreDetailScreen.routeName,
                              arguments: StoreDetailScreenArguments(
                                store: state.stores[index],
                              ),
                            )
                                .then((value) {
                              if (value != null) {
                                context
                                    .read<StoreListBloc>()
                                    .add(StoreListLoad());
                              }
                            }),
                            child: Card(
                              elevation: 4.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                              '${state.stores[index].storeName}'),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            '${state.stores[index].channelName} - '
                                            '${state.stores[index].areaName}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          const SizedBox(height: 2.0),
                                          Text(
                                            '${state.stores[index].dcName} - '
                                            '${state.stores[index].accountName}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible:
                                              state.stores[index].storeVisit !=
                                                  null,
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 20.0,
                                              ),
                                              SizedBox(height: 2.0),
                                              Text(
                                                'Perfect Store',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              SizedBox(width: 6.0),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.place,
                                              color: Colors.lightGreen,
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              position != null
                                                  ? '${meter}m'
                                                  : '---m',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is StoreListLoadFailure) {
              return GestureDetector(
                onTap: () => context.read<StoreListBloc>().add(StoreListLoad()),
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
