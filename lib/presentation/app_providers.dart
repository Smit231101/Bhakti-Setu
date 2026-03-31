import 'package:bhakti_setu/data/repositories/donor_repository.dart';
import 'package:bhakti_setu/data/services/firebase/temple_info_service.dart';
import 'package:bhakti_setu/presentation/providers/donor_provider.dart';
import 'package:bhakti_setu/presentation/providers/temple_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bhakti_setu/data/services/api/festival_api_service.dart';
import 'package:bhakti_setu/data/services/firebase/firestore_service.dart';
import 'package:bhakti_setu/data/repositories/festival_repository.dart';
import 'package:bhakti_setu/data/repositories/event_repository.dart';
import 'package:bhakti_setu/presentation/providers/festival_provider.dart';
import 'package:bhakti_setu/presentation/providers/event_provider.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(
    create: (_) => FestivalProvider(
      FestivalRepository(FestivalApiService()),
    ),
  ),
  ChangeNotifierProvider(
    create: (_) => EventProvider(
      EventRepository(EventFirestoreService()),
    ),
  ),
  ChangeNotifierProvider(
    create: (_) => TempleProvider(TempleInfoService()),
  ),
  ChangeNotifierProvider(
  create: (_) => DonorProvider(
    DonorRepository(DonorFirestoreService()),
  ),
),
];