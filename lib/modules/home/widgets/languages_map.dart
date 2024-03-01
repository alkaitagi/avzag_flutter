import 'package:bazur/models/language.dart';
import 'package:bazur/modules/home/services/mapbox.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class LanguagesMap extends StatelessWidget {
  const LanguagesMap({
    required this.languages,
    required this.selected,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  final List<Language> languages;
  final Set<Language> selected;
  final ValueSetter<Language> onToggle;

  @override
  Widget build(context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(43, 45),
        zoom: 5,
        maxZoom: 9,
        minZoom: 5,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        swPanBoundary: LatLng(38, 38),
        nePanBoundary: LatLng(52, 52),
        slideOnBoundaries: true,
      ),
      children: <Widget>[
        getTileLayer(
          Theme.of(context).brightness == Brightness.dark,
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            size: const Size.square(48),
            showPolygon: false,
            maxClusterRadius: 32,
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(128),
            ),
            animationsOptions: const AnimationsOptions(
              zoom: duration200,
              fitBound: duration200,
              centerMarker: duration200,
              spiderfy: duration200,
            ),
            centerMarkerOnClick: false,
            markers: [
              for (final language in languages.where((l) => l.location != null))
                Marker(
                  width: 48,
                  height: 48,
                  point: LatLng(
                    language.location!.latitude,
                    language.location!.longitude,
                  ),
                  // anchorPos: AnchorPos.align(AnchorAlign.bottom),
                  builder: (context) {
                    final selected = this.selected.contains(language);
                    return AnimatedOpacity(
                      opacity: selected ? 1 : .5,
                      duration: duration200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Tooltip(
                          message: language.name.titled,
                          preferBelow: false,
                          child: InkWell(
                            onTap: () => onToggle(language),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: LanguageAvatar(language.name),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
            builder: (context, markers) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: .5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    markers.length.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
